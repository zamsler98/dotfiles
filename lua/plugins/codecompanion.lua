return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    opts = {
        strategies = {
            chat = { adapter = "copilot" },
            inline = { adapter = "copilot" },
        },
        prompt_library = {
            ["Agent Mode"] = {
                strategy = "chat",
                description = "Auto add buffer and edit file",
                opts = {
                    stop_context_insertion = false
                },
                prompts = {
                    {
                        role = "system",
                        content = function(context)
                            return "I want you to act as a senior " 
                            .. context.filetype
                            .. " developer."
                        end,
                    },
                    {
                        role = "user",
                        content = "#{buffer}{pin} @{insert_edit_into_file}\n"
                    }
                },
            }
        }
    },
}
