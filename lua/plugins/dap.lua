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
        local dap = require("dap")

        dap.set_log_level("debug")

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
        local elf_file_name = ""

        -- 只支持一个，多个卡死..
        local function find_elf_name()
            local elf_dir = vim.fn.getcwd() .. "/build"
            local elf_dir_file_table = vim.fn.readdir(elf_dir)
            local elf_files = {}
            for _, file in ipairs(elf_dir_file_table) do
                if file:match("%.elf$") then
                    table.insert(elf_files, elf_dir .. "/" .. file)
                end
            end

            if #elf_files == 1 then
                elf_file_name = elf_files[1]
                return elf_files[1]
            elseif #elf_files > 1 then
                vim.fn.inputlist(elf_files)
                local choice = vim.fn.input("Choose ELF file number[1][2][3]...: ")
                elf_file_name = elf_files[tonumber(choice)]
                return elf_files[tonumber(choice)]
            else
                print("No ELF file found in build directory")
                return nil
            end
        end

        local function get_elfname()
            return elf_file_name
        end

        local function if_elf_valid()
            local elf = get_elfname()
            if elf then
                return elf
            else
                print("cppdbg: No ELF file found in build directory")
                return nil
            end
        end

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
                -------------------------------------MCU----------------------------------------------
                -----------------------------------------------------------------------------------
                {
                    find_elf_name(),
                    name = "Debug --openocd --load",
                    type = "cppdbg",
                    request = "launch",
                    MIMode = "gdb",
                    miDebuggerServerAddress = "localhost:3333",
                    miDebuggerPath = "arm-none-eabi-gdb",
                    cwd = "${workspaceFolder}",
                    program = if_elf_valid(),

                    stopAtEntry = false,
                    postRemoteConnectCommands = {
                        {
                            text = "load " .. get_elfname(),
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
                },
                {
                    find_elf_name(),
                    name = "Debug --openocd --not-load",
                    type = "cppdbg",
                    request = "launch",
                    MIMode = "gdb",
                    miDebuggerServerAddress = "localhost:3333",
                    miDebuggerPath = "arm-none-eabi-gdb",
                    cwd = "${workspaceFolder}",
                    program = if_elf_valid(),
                    stopAtEntry = false,
                    postRemoteConnectCommands = {
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
                },
            }
        end
    end,
}
