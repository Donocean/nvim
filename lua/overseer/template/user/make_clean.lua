return {
    name = "make clean -C -s",
    builder = function()
        local pwd = vim.fn.getcwd()
        return {
            cmd = { "make" },
            args = { "clean", "-C", pwd .. "/build/", "-s" },
            components = { { "on_output_quickfix", open = true }, "default" },
        }
    end,
    condition = {
        filetype = { "c" },
    },
}
