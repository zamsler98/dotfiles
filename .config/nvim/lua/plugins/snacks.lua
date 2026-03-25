return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        dashboard = { enabled = true },
        picker = {
            formatters = {
                file = {
                    filename_first = true,
                }
            }
        },
        bigfile = {
            enabled = true,
            size = 100 * 1024 * 1024, -- 100 MB
        }
    },
}
