return {
    name = "idf.py build",
    builder = function()
        return {
            cmd = { "idf.py" },
            args = { "build", "flash", "-b 2000000"},
            components = { { "on_output_quickfix", open = true }, "default" },
        }
    end,
    condition = {
        filetype = { "c", "cpp" },
    },
}
