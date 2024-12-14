return {
    name = "openocd flash",
    builder = function()
        -- For more options see /openocd/scripts/(interface/target)
        local debugger = vim.fn.input("Choose Debugger(e.g: cmsis-dap/stlink): ") .. ".cfg"
        local target = vim.fn.input("Choose Target(e.g: stm32f1x/stm32h7x): ") .. ".cfg"
        local program = "build/" .. vim.fn.input("Choose program(e.g: demo): ") .. ".elf"

        return {
            cmd = "openocd",
            args = { "-f", "interface/" .. debugger, "-f", "target/" .. target, "-c", '"program ' .. program .. ' verify reset exit"' },
            components = {
                { "on_output_quickfix", set_diagnostics = true },
                "on_result_diagnostics",
                "default",
            },
        }
    end,
    condition = {
        filetype = { "c", "cpp" },
    },
}
