return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            -- Ensure C/C++ and python debugger is installed
            {
                "williamboman/mason.nvim",
                optional = true,
                opts = function(_, opts)
                    if type(opts.ensure_installed) == "table" then
                        vim.list_extend(opts.ensure_installed, { "codelldb", "cpptools" , "debugpy"})
                    end
                end,
            },
            -- fancy debug ui
            {
                "rcarriga/nvim-dap-ui",
                dependencies = { "nvim-neotest/nvim-nio" },
                -- stylua: ignore
                keys = {
                    { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
                    { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
                },
                opts = {},
                config = function(_, opts)
                    local dap = require("dap")
                    local dapui = require("dapui")
                    dapui.setup(opts)
                    dap.listeners.after.event_initialized["dapui_config"] = function()
                        dapui.open({})
                    end
                    dap.listeners.before.event_terminated["dapui_config"] = function()
                        dapui.close({})
                    end
                    dap.listeners.before.event_exited["dapui_config"] = function()
                        dapui.close({})
                    end
                end,
            },
            -- Virtual text for the debugger
            {
                "theHamsta/nvim-dap-virtual-text",
                opts = {},
            },
        },
        keys = {
            {'<up>', function() require('dap').continue() end , mode = 'n', desc = "Continue"},
            {'<down>', function() require('dap').step_over() end , mode = 'n', desc = "Step over"},
            {'<right>', function() require('dap').step_into() end , mode = 'n', desc = "Step into"},
            {'<left>', function() require('dap').step_out() end ,mode = 'n', desc = "Step out"},
            {'<Leader>dd', function() require('dap').toggle_breakpoint() end ,mode = 'n', desc = "Toggle breakpoint"},
            { "<leader>dc", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
            { "<leader>dC", function() require("dap").clear_breakpoints() end, desc = "Clear breakpoint" },
            { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
            {'<Leader>dr', function() require('dap').restart() end ,mode = 'n', desc = "Restart"},
            {'<Leader>do', function() require('dap').repl.toggle() end ,mode = 'n', desc = "Toggle REPL"},
            {'<Leader>dl', function() require('dap').run_last() end ,mode = 'n', desc = "Run last"},
            { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
            { '<Leader>dw', function() local widgets = require('dap.ui.widgets') widgets.centered_float(widgets.frames) end ,mode = 'n', desc = "debug centered float"},
            {'<Leader>ds', function() local widgets = require('dap.ui.widgets') widgets.centered_float(widgets.scopes) end ,mode = 'n', desc = "debug centered_float scopes"},
        },

        config = function(_, opts)
            local dap = require("dap")
            local elf_file_name = ""
            local mason_path = vim.fn.glob(vim.fn.stdpath("data")) .. "/mason/"

            -- set dap icons
            for name, sign in pairs(require("config.icons").icons.dap) do
                sign = type(sign) == "table" and sign or { sign }
                vim.fn.sign_define(
                "Dap" .. name,
                { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
                )
            end

            local cppdbg_exec_path = mason_path .. "packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7"
            --local codelldb_exec_path = mason_path .. "packages/codelldb/extension/adapter/codelldb"
            --local cortex_debug_exec_path = mason_path .. "packages/cortex-debug/extension/dist/debugadapter.js"

            local debugpy_exec_path = mason_path .. "packages/debugpy/venv/bin/python3"

            dap.set_log_level("debug")

            -- setup python adapter debug
            dap.adapters.python = function(cb, config)
                if config.request == 'attach' then
                    local port = (config.connect or config).port
                    local host = (config.connect or config).host or '127.0.0.1'
                    cb({
                        type = 'server',
                        port = assert(port, '`connect.port` is required for a python `attach` configuration'),
                        host = host,
                        options = {
                            source_filetype = 'python',
                        },
                    })
                else
                    cb({
                        type = 'executable',
                        command = debugpy_exec_path,
                        args = { '-m', 'debugpy.adapter' },
                        options = {
                            source_filetype = 'python',
                        },
                    })
                end
            end

            -- setup the codelldb adapter for local c/cpp debug
            if not dap.adapters["codelldb"] then
                dap.adapters["codelldb"] = {
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

            -- setup the cppdbg adapter for mcu debug
            if not dap.adapters["cppdbg"] then
                require("dap").adapters["cppdbg"] = {
                    id = "cppdbg",
                    type = "executable",
                    command = cppdbg_exec_path,
                    args = {},
                }
            end

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

            for _, lang in ipairs({ "c", "cpp" }) do
                dap.configurations[lang] = {
                    {
                        type = "codelldb",
                        request = "launch",
                        name = "debug c/cpp",
                        program = function()
                            find_elf_name()
                            -- return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                            return get_elfname()
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

            -- setup python debug configuration
            dap.configurations.python = {
                {
                    type = 'python';
                    request = 'launch';
                    name = "debug python";
                    program = "${file}"; -- This configuration will launch the current file if used.
                    pythonPath = function()
                            return '/usr/bin/python3'
                    end;
                },
            }
        end,
    },
}
