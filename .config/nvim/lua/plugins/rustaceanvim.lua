return {
    "mrcjkb/rustaceanvim",
    version = "^6",
    lazy = false, -- rustaceanvim sets itself up via ftplugin, so it must not be lazy-loaded on ft
    ft = { "rust" },
    config = function()
        vim.g.rustaceanvim = {
            server = {
                default_settings = {
                    ["rust-analyzer"] = {
                        cargo = { allFeatures = true },
                        checkOnSave = true,
                        check = { command = "clippy" },
                    },
                },
            },
        }
    end,
}
