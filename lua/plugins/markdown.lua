return {
    {
        "dhruvasagar/vim-table-mode",
        cmd = "TableModeToggle",
        keys = { { "<leader>mb", "<cmd>TableModeToggle<cr>", desc = "Toggle markdown table" }, },
    },
    -- markdown-preview
    {
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
        cmd = { "MarkdownPreview", "MarkdownPreviewToggle" },
        keys = { { "<leader>mm", "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle MarkdownPreview" }, },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
}
