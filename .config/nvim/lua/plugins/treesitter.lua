return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function() 
            require("nvim-treesitter.config").setup {
                ensure_installed =  
                {
                    "bash",
                    "c",
                    "c_sharp",
                    "diff",
                    "html",
                    "javascript",
                    "jsdoc",
                    "json",
                    "kotlin",
                    "lua",
                    "luadoc",
                    "luap",
                    "markdown",
                    "markdown_inline",
                    "printf",
                    "python",
                    "query",
                    "regex",
                    "toml",
                    "tsx",
                    "typescript",
                    "vim",
                    "vimdoc",
                    "xml",
                    "yaml",
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = true,
                }
            }
        end
    }
