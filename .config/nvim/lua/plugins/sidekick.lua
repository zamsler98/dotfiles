local CONTEXT = 3

-- Format a hunk header start: git uses the line before an empty range
local function hunk_start(start, count)
    return count == 0 and math.max(start - 1, 0) or start
end

-- Lines of a git-style diff for the codediff hunks touching [first, last] in buf.
-- Returns nil when not in a codediff session or when no hunk touches the selection.
local function codediff_patch(buf, first, last)
    local lifecycle = require("codediff.ui.lifecycle")
    local tabpage = vim.api.nvim_get_current_tabpage()
    local session = lifecycle.get_session(tabpage)
    if not session or not session.stored_diff_result then
        return nil
    end
    local orig_buf, mod_buf = lifecycle.get_buffers(tabpage)
    if not orig_buf or not mod_buf then
        return nil
    end
    local path = (session.original.relative ~= "" and session.original.relative) or session.modified.relative
    if not path or path == "" then
        return nil
    end

    local side = buf == orig_buf and "original" or "modified"
    local changes = session.stored_diff_result.changes or {}
    local hits = {}
    for _, h in ipairs(changes) do
        local s, e = h[side].start_line, h[side].end_line
        -- end_line is exclusive; empty ranges (pure insert/delete) sit on their start line
        if s <= last and math.max(e - 1, s) >= first then
            table.insert(hits, h)
        end
    end
    if #hits == 0 then
        return nil
    end
    table.sort(hits, function(a, b)
        return a.modified.start_line < b.modified.start_line
    end)

    -- Group hunks whose context would overlap, the way git merges them
    local groups = { { hits[1] } }
    for i = 2, #hits do
        local prev, cur = hits[i - 1], hits[i]
        local gap = cur.modified.start_line - prev.modified.end_line
        if gap <= 2 * CONTEXT then
            table.insert(groups[#groups], cur)
        else
            table.insert(groups, { cur })
        end
    end

    local out = { "--- a/" .. path, "+++ b/" .. path }
    local orig_len = vim.api.nvim_buf_line_count(orig_buf)
    local mod_len = vim.api.nvim_buf_line_count(mod_buf)

    for _, group in ipairs(groups) do
        local first_h = group[1]
        local pre = math.min(CONTEXT, first_h.modified.start_line - 1, first_h.original.start_line - 1)
        local o_start = first_h.original.start_line - pre
        local m_start = first_h.modified.start_line - pre
        local o_count, m_count = 0, 0
        local body = {}

        -- Unchanged lines are identical on both sides, so read them from the modified buffer
        local function unchanged(from, to)
            for _, l in ipairs(vim.api.nvim_buf_get_lines(mod_buf, from - 1, to, false)) do
                table.insert(body, " " .. l)
                o_count = o_count + 1
                m_count = m_count + 1
            end
        end

        unchanged(m_start, first_h.modified.start_line - 1)
        local prev_mod_end = nil
        for _, h in ipairs(group) do
            if prev_mod_end then
                unchanged(prev_mod_end, h.modified.start_line - 1)
            end
            for _, l in ipairs(vim.api.nvim_buf_get_lines(orig_buf, h.original.start_line - 1, h.original.end_line - 1, false)) do
                table.insert(body, "-" .. l)
                o_count = o_count + 1
            end
            for _, l in ipairs(vim.api.nvim_buf_get_lines(mod_buf, h.modified.start_line - 1, h.modified.end_line - 1, false)) do
                table.insert(body, "+" .. l)
                m_count = m_count + 1
            end
            prev_mod_end = h.modified.end_line
        end

        local last_h = group[#group]
        local post = math.min(CONTEXT, mod_len - (last_h.modified.end_line - 1), orig_len - (last_h.original.end_line - 1))
        unchanged(last_h.modified.end_line, last_h.modified.end_line + post - 1)

        table.insert(out, string.format("@@ -%d,%d +%d,%d @@", hunk_start(o_start, o_count), o_count, hunk_start(m_start, m_count), m_count))
        vim.list_extend(out, body)
    end
    return out
end

return {
    "zamsler98/sidekick.nvim",
    dependencies = { "github/copilot.vim" },
    branch = "feat/cli-toggle-layout",
    opts = {
        cli = {
            win = {
                layout = "float",
                float = {
                    width = 0.95,
                    height = 0.95,
                    border =  "rounded",
                    title = "Sidekick CLI",
                }
            }
        }
    },
    keys = {
        {
            "<leader>aa",
            function() require("sidekick.cli").toggle({ layout = "float" }) end,
            desc = "Sidekick Toggle CLI",
        },
        {
            "<leader>as",
            function() require("sidekick.cli").select() end,
            -- Or to select only installed tools:
            -- require("sidekick.cli").select({ filter = { installed = true } })
            desc = "Select CLI",
        },
        {
            "<leader>ad",
            function() require("sidekick.cli").close() end,
            desc = "Detach a CLI Session",
        },
        {
            "<leader>at",
            function() require("sidekick.cli").send({ msg = "{this}" }) end,
            mode = { "x", "n" },
            desc = "Send This",
        },
        {
            "<leader>af",
            function() require("sidekick.cli").send({ msg = "{file}" }) end,
            desc = "Send File",
        },
        {
            "<leader>av",
            function() require("sidekick.cli").send({ msg = "{selection}" }) end,
            mode = { "x" },
            desc = "Send Visual Selection",
        },
        {
            "<leader>ap",
            function() require("sidekick.cli").prompt() end,
            mode = { "n", "x" },
            desc = "Sidekick Select Prompt",
        },
        {
            "<leader>al",
            function() require("sidekick.cli").toggle({ layout = "right"}) end,
            mode = { "n" },
            desc = "Sidekick Toggle Right",
        },
        {
            "<leader>ac",
            function()
                -- Read the selection directly: sidekick's context code breaks when
                -- codediff has windows in other tabs (getcwd is given a window ID)
                local buf = vim.api.nvim_get_current_buf()
                local first, last = vim.fn.line("v"), vim.fn.line(".")
                if first > last then
                    first, last = last, first
                end
                vim.cmd("normal! \27")

                -- In a codediff hunk, send a git-style diff; otherwise the plain selected lines
                local body = codediff_patch(buf, first, last)
                if not body then
                    local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":.")
                    body = { ("%s:%d-%d"):format(name, first, last) }
                    vim.list_extend(body, vim.api.nvim_buf_get_lines(buf, first - 1, last, false))
                end

                vim.ui.input({ prompt = "Comment: " }, function(comment)
                    if not comment or comment == "" then
                        return
                    end
                    local text = { { { comment } }, {} }
                    for _, line in ipairs(body) do
                        table.insert(text, { { line } })
                    end
                    require("sidekick.cli").send({ text = text })
                end)
            end,
            mode = { "x" },
            desc = "Comment on Selection",
        },
    }
}
