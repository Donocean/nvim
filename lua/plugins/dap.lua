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
                        vim.list_extend(opts.ensure_installed, { "codelldb", "cpptools", "debugpy" })
                    end
                end,
            },
            -- fancy debug ui
            {
                "rcarriga/nvim-dap-ui",
                dependencies = { "nvim-neotest/nvim-nio" },
                -- stylua: ignore
                keys = {
                    { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI" },
                    { "<leader>de", function() require("dapui").eval() end,     desc = "Eval",  mode = { "n", "v" } },
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
            { '<up>',       function() require('dap').continue() end,          mode = 'n',               desc = "Continue" },
            { '<down>',     function() require('dap').step_over() end,         mode = 'n',               desc = "Step over" },
            { '<right>',    function() require('dap').step_into() end,         mode = 'n',               desc = "Step into" },
            { '<left>',     function() require('dap').step_out() end,          mode = 'n',               desc = "Step out" },
            { '<Leader>dd', function() require('dap').toggle_breakpoint() end, mode = 'n',               desc = "Toggle breakpoint" },
            { "<leader>dc", function() require("dap").run_to_cursor() end,     desc = "Run to Cursor" },
            { "<leader>dC", function() require("dap").clear_breakpoints() end, desc = "Clear breakpoint" },
            { "<leader>dt", function() require("dap").terminate() end,         desc = "Terminate" },
            { '<Leader>dr', function() require('dap').restart() end,           mode = 'n',               desc = "Restart" },
            { '<Leader>do', function() require('dap').repl.toggle() end,       mode = 'n',               desc = "Toggle REPL" },
            { '<Leader>dl', function() require('dap').run_last() end,          mode = 'n',               desc = "Run last" },
            { "<leader>dp", function() require("dap").pause() end,             desc = "Pause" },
            {
                '<Leader>dw',
                function()
                    local widgets = require('dap.ui.widgets')
                    widgets.centered_float(widgets.frames)
                end,
                mode = 'n',
                desc = "debug centered float"
            },
            {
                '<Leader>ds',
                function()
                    local widgets = require('dap.ui.widgets')
                    widgets.centered_float(widgets.scopes)
                end,
                mode = 'n',
                desc = "debug centered_float scopes"
            },
        },

        config = function(_, opts)
            local dap = require("dap")
            local data_path = vim.fn.stdpath("data")
            local mason_path = data_path .. "/mason"

            -- set dap icons
            for name, sign in pairs(require("config.icons").icons.dap) do
                sign = type(sign) == "table" and sign or { sign }
                vim.fn.sign_define(
                    "Dap" .. name,
                    { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
                )
            end

            local cppdbg_exec_path = mason_path .. "/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7"
            local codelldb_exec_path = mason_path .. "/bin/codelldb"
            local debugpy_exec_path = mason_path .. "/packages/debugpy/venv/bin/python3"

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

            -- CodeLLDB: PC / ROS / 普通 C++ 调试使用
            dap.adapters.codelldb = {
                type = "server",
                host = "127.0.0.1",
                port = "${port}",
                executable = {
                    command = codelldb_exec_path,
                    args = {
                        "--port",
                        "${port}",
                    },
                },
            }
            -- cppdbg: MCU + OpenOCD + arm-none-eabi-gdb 使用
            dap.adapters.cppdbg = {
                id = "cppdbg",
                type = "executable",
                command = cppdbg_exec_path,
                args = {},
                options = {
                    initialize_timeout_sec = 10,
                },
            }

            local function find_elf()
                local elf_dir = vim.fn.getcwd() .. "/build"

                -- build 目录不存在
                if vim.fn.isdirectory(elf_dir) == 0 then
                    vim.notify(
                        "Build directory not found: " .. elf_dir,
                        vim.log.levels.ERROR
                    )
                    return nil
                end

                local elf_files = {}
                for _, file in ipairs(vim.fn.readdir(elf_dir)) do
                    if file:match("%.elf$") then
                        table.insert(
                            elf_files,
                            elf_dir .. "/" .. file
                        )
                    end
                end

                if #elf_files == 0 then
                    vim.notify(
                        "No ELF file found in: " .. elf_dir,
                        vim.log.levels.ERROR
                    )
                    return nil
                end

                -- 只有一个，直接返回
                if #elf_files == 1 then
                    return elf_files[1]
                end

                -- 多个 ELF，让用户选
                local choices = {
                    "Select ELF file:"
                }
                for i, elf in ipairs(elf_files) do
                    table.insert(
                        choices,
                        string.format("%d. %s", i, elf)
                    )
                end

                local choice = vim.fn.inputlist(choices)
                if choice < 1 or choice > #elf_files then
                    return nil
                end
                return elf_files[choice]
            end

            local cpp_configurations = {
                -- 普通 PC C/C++
                {
                    name = "Debug C/C++ executable",
                    type = "codelldb",
                    request = "launch",

                    program = function()
                        return vim.fn.input(
                            "Path to executable: ",
                            vim.fn.getcwd() .. "/",
                            "file"
                        )
                    end,

                    cwd = "${workspaceFolder}",
                },
                {
                    name = "Attach to running C/C++ process",
                    type = "codelldb",
                    request = "attach",

                    pid = require("dap.utils").pick_process,

                    cwd = "${workspaceFolder}",
                },


                -- MCU / OpenOCD
                {
                    name = "Debug MCU -- OpenOCD -- load",
                    type = "cppdbg",
                    request = "launch",

                    MIMode = "gdb",

                    miDebuggerServerAddress = "localhost:3333",
                    miDebuggerPath = "arm-none-eabi-gdb",

                    cwd = "${workspaceFolder}",

                    program = find_elf,
                    stopAtEntry = false,
                    postRemoteConnectCommands = {
                        { text = "load", },
                        { text = "monitor reset halt", },
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
                    name = "Debug MCU -- OpenOCD -- not load",
                    type = "cppdbg",
                    request = "launch",
                    MIMode = "gdb",
                    miDebuggerServerAddress = "localhost:3333",
                    miDebuggerPath = "arm-none-eabi-gdb",
                    cwd = "${workspaceFolder}",
                    program = find_elf,
                    stopAtEntry = false,
                    postRemoteConnectCommands = {
                        { text = "monitor reset halt", },
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

            -- setup c/cpp debug configuration
            dap.configurations.c = cpp_configurations
            dap.configurations.cpp = cpp_configurations
            -- setup python debug configuration
            dap.configurations.python = {
                {
                    type = 'python',
                    request = 'launch',
                    name = "debug python",
                    program = "${file}", -- This configuration will launch the current file if used.
                    pythonPath = function()
                        -- return '/usr/bin/python3'
                        return 'python3'
                    end,
                },
            }
        end,
    },
}
