return {
    {
        "williamboman/mason.nvim",
        config = true,
        config = function() 
            require("mason").setup({
                registries = {
                    "github:mason-org/mason-registry",
                    "github:Crashdummyy/mason-registry",
                }
            })
        end
    }, 
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "ts_ls", "eslint" },
            })
            vim.lsp.config("ts_ls", {})
            vim.lsp.enable("ts_ls")
            vim.lsp.config("eslint", {})
            vim.lsp.enable("eslint")
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
