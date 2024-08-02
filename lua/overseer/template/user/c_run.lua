return {
    name = "run file",
    builder = function()
        local cmd = { "./build/demo.elf" }
        return {
            cmd = cmd,
            components = {
                { "on_output_quickfix", open = true },
                "on_result_diagnostics",
                "default",
            },
        }
    end,
    condition = {
        filetype = { "c", "cpp"},
    },
}
