return {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
        modes = {
            char = {
                -- f,F,t,T only search the current line
                multi_line = false,
                -- disable backdrop color
                highlight = { backdrop = false },
            },
        },
    },
    config = function (_, opts)
        require("flash").setup(opts)
    end,
    -- stylua: ignore
    keys = {
        { "q", mode = { "n", "o", "x" }, function() require("flash").jump() end, desc = "Flash" },
    },
}
