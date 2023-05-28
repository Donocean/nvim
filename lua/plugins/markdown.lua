return {
    {
        "dhruvasagar/vim-table-mode",
        cmd = "TableModeToggle",
        keys = { {"<leader>tm", "<cmd>TableModeToggle<cr>", desc = "Toggle markdown table"}, },
    },
    -- markdown-preview
    {
        "iamcco/markdown-preview.nvim",
        cmd = "MarkdownPreview",
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
}
