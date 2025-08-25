return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    opts = {
        display = {
            chat = {
                icons = {
                    chat_context = "📎️",
                },
                fold_context = true,
            }
        },
        adapters = {
            opts = {
                allow_insecure = true
            }
        },
        strategies = {
            chat = { adapter = "copilot" },
            inline = { adapter = "copilot" },
        },
        prompt_library = {
            ["Agent Mode"] = {
                strategy = "chat",
                description = "Auto add buffer and edit file",
                opts = {
                    short_name = "agent",
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
                        content = [[
#{buffer}{pin} @{insert_edit_into_file}
 
]]
                    }
                },
            },
            ["Method Comment"] = {
                strategy = "inline",
                description = "Auto add documentation comment to function",
                opts = {
                    placement = "before",
                    short_name = "func_doc",
                },
                prompts = {
                    {
                        role = "user",
                        content = function(context) 
                              return string.format([[
Write a documentation comment for the following method, using the standard documentation style for its programming language (e.g., XML documentation for C#, Javadoc for Java, docstrings for Python, etc.).
Describe what the method does, its parameters, return value, and any exceptions it may throw.
Output only the documentation comment, not the method itself.
Do not include remarks, examples, or any optional sections—only the standard required tags for the language.
The programming language for this is %s.
                              ]], context.filetype)
                        end,
                    }
                }
            }

        }
    },
}
