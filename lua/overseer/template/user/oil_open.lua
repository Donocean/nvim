return {
    name = "Oil: open path",
    condition = {
        filetype = { "oil" },
    },

    builder = function()
        local task = {
            cmd = { "sh", "-c", "sleep 0" },
            components = { "default" },
        }

        -- 弹出输入框
        vim.schedule(function()
            vim.cmd("copen")
            vim.api.nvim_feedkeys(
                vim.api.nvim_replace_termcodes(":e ", true, false, true),
                "n",
                false
            )
        end)

        return task
    end,
}
