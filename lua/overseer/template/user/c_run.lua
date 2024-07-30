return {
    name = "run file",
    builder = function()
        local cmd = { "./build/demo" }
        return {
            cmd = cmd,
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
