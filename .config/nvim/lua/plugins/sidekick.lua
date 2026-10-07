local CONTEXT = 3

-- Format a hunk header start: git uses the line before an empty range
local function hunk_start(start, count)
    return count == 0 and math.max(start - 1, 0) or start
end

-- Lines of a git-style diff for the codediff hunks touching [first, last] in buf.
-- Returns nil when not in a codediff session or when no hunk touches the selection.
local function codediff_patch(buf, first, last)
    -- codediff is lazy-loaded; if it isn't loaded there can't be a session
    local lifecycle = package.loaded["codediff.ui.lifecycle"]
    if not lifecycle then
        return nil
    end
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

-- A single draft prompt that the add mappings append to. It persists until sent,
-- so the whole prompt can be written in Neovim before it goes to the CLI.
local draft = { buf = nil, win = nil }

local function draft_buf()
    if draft.buf and vim.api.nvim_buf_is_valid(draft.buf) then
        return draft.buf
    end
    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].bufhidden = "hide"
    vim.bo[buf].filetype = "markdown"
    vim.api.nvim_buf_set_name(buf, "sidekick://draft")
    draft.buf = buf

    vim.keymap.set({ "n", "i" }, "<C-s>", function()
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        if vim.trim(table.concat(lines, "\n")) == "" then
            vim.notify("Draft is empty, nothing sent", vim.log.levels.WARN)
            return
        end
        vim.cmd("stopinsert")
        if draft.win and vim.api.nvim_win_is_valid(draft.win) then
            vim.api.nvim_win_close(draft.win, true)
        end
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
        local text = {}
        for _, l in ipairs(lines) do
            table.insert(text, { { l } })
        end
        require("sidekick.cli").send({ text = text })
    end, { buffer = buf, nowait = true, desc = "Send draft to CLI" })
    vim.keymap.set("n", "q", function()
        vim.api.nvim_win_close(0, true)
    end, { buffer = buf, nowait = true, desc = "Hide draft" })
    return buf
end

-- Open the draft window, or focus it if it's already open
local function draft_open()
    if draft.win and vim.api.nvim_win_is_valid(draft.win) then
        vim.api.nvim_set_current_win(draft.win)
        return
    end
    local buf = draft_buf()
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    draft.win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = "rounded",
        title = " Sidekick draft (<C-s> send, q hide) ",
        title_pos = "center",
    })
    vim.wo[draft.win].wrap = true
end

local function draft_toggle()
    if draft.win and vim.api.nvim_win_is_valid(draft.win) then
        vim.api.nvim_win_close(draft.win, true)
    else
        draft_open()
    end
end

-- Append lines to the draft, separated from what's already there by a blank line
local function draft_add(lines)
    local buf = draft_buf()
    local existing = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local empty = #existing == 1 and existing[1] == ""
    if empty then
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    else
        local block = existing[#existing] == "" and {} or { "" }
        vim.list_extend(block, lines)
        vim.api.nvim_buf_set_lines(buf, -1, -1, false, block)
    end
    draft_open()
    vim.api.nvim_win_set_cursor(draft.win, { vim.api.nvim_buf_line_count(buf), 0 })
end

-- Render a sidekick message template (e.g. "{selection}") and append it to the draft
-- instead of sending it straight to the CLI. Must run before leaving visual mode.
local function draft_add_context(msg)
    local str = require("sidekick.cli").render({ msg = msg })
    if vim.fn.mode():match("^[vV\22]") then
        vim.cmd("normal! \27")
    end
    if not str or str == "" then
        vim.notify("Nothing to add", vim.log.levels.WARN)
        return
    end
    draft_add(vim.split(str, "\n", { plain = true }))
end

-- sidekick's context picks the most recent window from any tab, then calls
-- getcwd(win) with it, which fails for windows in other tabs (e.g. codediff).
-- Same logic, limited to the current tab.
local function patch_sidekick_ctx()
    local Context = require("sidekick.cli.context")
    Context.ctx = function()
        local wins = vim.tbl_filter(function(w)
            return vim.bo[vim.api.nvim_win_get_buf(w)].filetype ~= "sidekick_terminal"
        end, vim.api.nvim_tabpage_list_wins(0))
        table.sort(wins, function(a, b)
            return (vim.w[a].sidekick_visit or 0) > (vim.w[b].sidekick_visit or 0)
        end)
        local win = wins[1] or vim.api.nvim_get_current_win()
        local buf = vim.api.nvim_win_get_buf(win)
        local cursor = vim.api.nvim_win_get_cursor(win)
        return {
            win = win,
            buf = buf,
            cwd = vim.fs.normalize(vim.fn.getcwd(win)),
            row = cursor[1],
            col = cursor[2] + 1,
            range = Context.selection(buf),
        }
    end
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
    config = function(_, opts)
        require("sidekick").setup(opts)
        patch_sidekick_ctx()
    end,
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
            "<leader>ae",
            draft_toggle,
            desc = "Toggle Sidekick Draft",
        },
        {
            "<leader>at",
            function() draft_add_context("{this}") end,
            mode = { "x", "n" },
            desc = "Add This to Draft",
        },
        {
            "<leader>af",
            function() draft_add_context("{file}") end,
            desc = "Add File to Draft",
        },
        {
            "<leader>av",
            function() draft_add_context("{selection}") end,
            mode = { "x" },
            desc = "Add Visual Selection to Draft",
        },
        {
            "<leader>ap",
            function()
                require("sidekick.cli").prompt({
                    cb = function(msg)
                        if msg and msg ~= "" then
                            draft_add(vim.split(msg, "\n", { plain = true }))
                        end
                    end,
                })
            end,
            mode = { "n", "x" },
            desc = "Add Prompt to Draft",
        },
        {
            "<leader>al",
            function() require("sidekick.cli").toggle({ layout = "right"}) end,
            mode = { "n" },
            desc = "Sidekick Toggle Right",
        },
        {
            "<leader>ah",
            function()
                -- Read the selection directly: sidekick's context code breaks when
                -- codediff has windows in other tabs (getcwd is given a window ID)
                local buf = vim.api.nvim_get_current_buf()
                local first, last = vim.fn.line("v"), vim.fn.line(".")
                if first > last then
                    first, last = last, first
                end
                vim.cmd("normal! \27")

                -- In a codediff hunk, add a git-style diff; otherwise the plain selected lines
                local body = codediff_patch(buf, first, last)
                if not body then
                    local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":.")
                    body = { ("%s:%d-%d"):format(name, first, last) }
                    vim.list_extend(body, vim.api.nvim_buf_get_lines(buf, first - 1, last, false))
                end
                draft_add(body)
            end,
            mode = { "x" },
            desc = "Add Hunk Diff to Draft",
        },
    }
}
