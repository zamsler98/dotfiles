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
        "seblyng/roslyn.nvim"
    }
}
