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
        { "<tab>", mode = { "n", "o", "x" }, function() require("flash").jump() end, desc = "Flash" },
        { "<S-tab>", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
        { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
}
