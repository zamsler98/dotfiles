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
