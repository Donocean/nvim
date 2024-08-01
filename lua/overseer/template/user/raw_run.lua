return {
    name = "raw run .",
    builder = function()
        return {
            cmd = { "./demo" },
            components = {
                { "on_output_quickfix", set_diagnostics = true },
                "on_result_diagnostics",
                "default",
            },
        }
    end,
    condition = {
        filetype = { "c" },
    },
}
