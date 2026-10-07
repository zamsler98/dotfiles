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
                -- Read the selected lines directly: sidekick's context code breaks when
                -- codediff has windows in other tabs (getcwd is given a window ID)
                local buf = vim.api.nvim_get_current_buf()
                local first, last = vim.fn.line("v"), vim.fn.line(".")
                if first > last then
                    first, last = last, first
                end
                vim.cmd("normal! \27")
                local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":.")
                local code = vim.api.nvim_buf_get_lines(buf, first - 1, last, false)
                vim.ui.input({ prompt = "Comment: " }, function(comment)
                    if not comment or comment == "" then
                        return
                    end
                    local text = {
                        { { comment } },
                        {},
                        { { ("%s:%d-%d"):format(name, first, last) } },
                    }
                    for _, line in ipairs(code) do
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
