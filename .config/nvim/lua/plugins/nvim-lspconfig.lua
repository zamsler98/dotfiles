return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                registries = {
                    "github:mason-org/mason-registry",
                    "github:Crashdummyy/mason-registry",
                }
            })

            -- portable across machines: mason installs a prebuilt binary per-OS
            -- and puts it on Neovim's PATH, so nvim-treesitter's `:TSUpdate` can find it
            require("mason-registry").refresh(function()
                local ok, pkg = pcall(require("mason-registry").get_package, "tree-sitter-cli")
                if ok and not pkg:is_installed() then
                    pkg:install()
                end
            end)
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        config = function()
            require("mason-lspconfig").setup({
                -- rust_analyzer is installed here via mason so rustaceanvim can find the
                -- binary, but excluded from automatic_enable: rustaceanvim manages that
                -- LSP client itself (see plugins/rustaceanvim.lua). Without the exclusion,
                -- mason-lspconfig auto-enables a second plain rust-analyzer client, causing
                -- duplicate hover/diagnostics.
                ensure_installed = { "ts_ls", "eslint", "rust_analyzer" },
                automatic_enable = { exclude = { "rust_analyzer" } },
            })
            vim.lsp.config("ts_ls", {})
            vim.lsp.enable("ts_ls")
            vim.lsp.config("eslint", {})
            vim.lsp.enable("eslint")
            vim.lsp.enable("sourcekit")
            vim.lsp.config("copilot", {})
            vim.lsp.enable("copilot")
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
                callback = function()
                    vim.lsp.buf.code_action({ context = { only = { "source.fixAll.eslint" } }, apply = true })
                end,
            })
        end,
    },
    {
        'neovim/nvim-lspconfig',
    },
    {
        "seblyng/roslyn.nvim",
        opts = {
            choose_target = function(targets)
                return vim.iter(targets):find(function(item)
                    return item:match("StudentGuidance%.sln$")
                end)
            end,
        }

    }
}
