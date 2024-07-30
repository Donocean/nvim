return {
    name = "openocd server start",
    builder = function()
        return {
            cmd = "openocd",
            args = { "-f", "interface/cmsis-dap.cfg", "-f", "target/stm32f1x.cfg" },
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
