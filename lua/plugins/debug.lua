-- 单片机调试需要手动修改可执行文件名，并确保工程路径正确

local mcu_elf_name = "test2.elf"

return {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
        -- Ensure C/C++ debugger is installed
        "williamboman/mason.nvim",
        optional = true,
        opts = function(_, opts)
            if type(opts.ensure_installed) == "table" then
                vim.list_extend(opts.ensure_installed, { "codelldb", "cpptools" })
            end
        end,
    },
    opts = function()
        local dap = require("debug")

        dap.set_log_level("ERROR")

        if not dap.adapters["codelldb"] then
            require("dap").adapters["codelldb"] = {
                type = "server",
                host = "localhost",
                port = "${port}",
                executable = {
                    command = "codelldb",
                    args = {
                        "--port",
                        "${port}",
                    },
                },
            }
        end

        local mason_path = vim.fn.glob(vim.fn.stdpath("data")) .. "/mason/"
        local cppdbg_exec_path = mason_path .. "packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7"
        --local codelldb_exec_path = mason_path .. "packages/codelldb/extension/adapter/codelldb"
        --local cortex_debug_exec_path = mason_path .. "packages/cortex-debug/extension/dist/debugadapter.js"

        if not dap.adapters["cppdbg"] then
            require("dap").adapters["cppdbg"] = {
                id = "cppdbg",
                type = "executable",
                command = cppdbg_exec_path,
                args = {},
            }
        end

        for _, lang in ipairs({ "c", "cpp" }) do
            dap.configurations[lang] = {
                {
                    type = "codelldb",
                    request = "launch",
                    name = "Launch file",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                },
                {
                    type = "codelldb",
                    request = "attach",
                    name = "Attach to process",
                    pid = require("dap.utils").pick_process,
                    cwd = "${workspaceFolder}",
                },
                {
                    name = "[mcu]: Launch STM32",
                    type = "cppdbg",
                    request = "launch",
                    program = "${workspaceFolder}/build/" .. mcu_elf_name, -- 修改为实际的 ELF 文件路径
                    -- program = function()
                    --   return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/", "file")
                    -- end,
                    cwd = "${workspaceFolder}",
                    miMode = "gdb",
                    miDebuggerPath = "arm-none-eabi-gdb", -- 确保 GDB 在系统路径中
                    miDebuggerServerAddress = "localhost:3333",
                    postRemoteConnectCommands = {
                        {
                            text = "load build/" .. mcu_elf_name,
                        },
                        {
                            text = "monitor reset halt",
                        },
                    },
                    setupCommands = {
                        {
                            description = "Enable pretty-printing",
                            text = "-enable-pretty-printing",
                            ignoreFailures = true,
                        },
                    },
                    preLaunchTask = function()
                        os.execute("pkill openocd")
                        os.execute("openocd -f interface/stlink.cfg -f target/stm32f1x.cfg > openocd.log 2>1&1")
                    end,
                    stopAtEntry = false,
                    runInTerminal = false,
                    externalConsole = false,
                    svdPath = "${workspaceFolder}/STM32F103.svd",
                    --showDevDebugOutput = "raw",
                },
            }
        end
    end,
}
