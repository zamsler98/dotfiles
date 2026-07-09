return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").setup({
            ensure_installed = {
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
        })

        -- highlighting/indent are now provided by Neovim core + this plugin's
        -- runtime queries, but must be enabled per-buffer ourselves (0.12 change)
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "*",
            callback = function(args)
                local ok = pcall(vim.treesitter.start, args.buf)
                if not ok then
                    return
                end
                vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}
