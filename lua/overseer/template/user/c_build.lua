return {
    name = "make -C build -s",
    builder = function()
        local pwd = vim.fn.getcwd()
        return {
            cmd = { "make" },
            args = { "-C", pwd .. "/build/", "-s" },
            components = { { "on_output_quickfix", open = true }, "default" },
        }
    end,
    condition = {
        filetype = { "c" },
    },
}
