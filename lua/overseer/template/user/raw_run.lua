return {
    name = "run ./demo.elf",
    builder = function()
        return {
            cmd = { "./demo.elf" },
            components = {
                { "on_output_quickfix", open = true },
                "on_result_diagnostics",
                "default",
            },
        }
    end,
    condition = {
        filetype = { "c", "cpp" },
    },
}
