return {
    {
        "dhruvasagar/vim-table-mode",
        ft = "markdown",
        cmd = "TableModeToggle",
        keys = { {"<leader>tb", "<cmd>TableModeToggle<cr>", desc = "Toggle markdown table"}, },
    },
    -- markdown-preview
    {
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
        cmd = { "MarkdownPreview","MarkdownPreviewToggle" },
        keys = { { "<leader>tm", "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle MarkdownPreview" }, },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
}
