return {
    name = "raw make .",
    builder = function()
        return {
            cmd = { "make" },
            args = { "-j"},
            components = { { "on_output_quickfix", open = true }, "default" },
        }
    end,
    condition = {
        filetype = { "c" },
    },
}
