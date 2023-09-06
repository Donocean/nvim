local DAYS = {
    Mon = [[
    ███╗   ███╗  ██████╗  ███╗   ██╗ ██████╗   █████╗  ██╗   ██╗
    ████╗ ████║ ██╔═══██╗ ████╗  ██║ ██╔══██╗ ██╔══██╗ ╚██╗ ██╔╝
    ██╔████╔██║ ██║   ██║ ██╔██╗ ██║ ██║  ██║ ███████║  ╚████╔╝ 
    ██║╚██╔╝██║ ██║   ██║ ██║╚██╗██║ ██║  ██║ ██╔══██║   ╚██╔╝  
    ██║ ╚═╝ ██║ ╚██████╔╝ ██║ ╚████║ ██████╔╝ ██║  ██║    ██║   
    ╚═╝     ╚═╝  ╚═════╝  ╚═╝  ╚═══╝ ╚═════╝  ╚═╝  ╚═╝    ╚═╝
    ]],

    Tue = [[
    ████████╗ ██╗   ██╗ ███████╗ ███████╗ ██████╗   █████╗  ██╗   ██╗
    ╚══██╔══╝ ██║   ██║ ██╔════╝ ██╔════╝ ██╔══██╗ ██╔══██╗ ╚██╗ ██╔╝
       ██║    ██║   ██║ █████╗   ███████╗ ██║  ██║ ███████║  ╚████╔╝ 
       ██║    ██║   ██║ ██╔══╝   ╚════██║ ██║  ██║ ██╔══██║   ╚██╔╝  
       ██║    ╚██████╔╝ ███████╗ ███████║ ██████╔╝ ██║  ██║    ██║   
       ╚═╝     ╚═════╝  ╚══════╝ ╚══════╝ ╚═════╝  ╚═╝  ╚═╝    ╚═╝   
    ]],

    Wed = [[
    ██╗    ██╗ ███████╗ ██████╗  ███╗   ██╗ ███████╗ ███████╗ ██████╗   █████╗  ██╗   ██╗
    ██║    ██║ ██╔════╝ ██╔══██╗ ████╗  ██║ ██╔════╝ ██╔════╝ ██╔══██╗ ██╔══██╗ ╚██╗ ██╔╝
    ██║ █╗ ██║ █████╗   ██║  ██║ ██╔██╗ ██║ █████╗   ███████╗ ██║  ██║ ███████║  ╚████╔╝ 
    ██║███╗██║ ██╔══╝   ██║  ██║ ██║╚██╗██║ ██╔══╝   ╚════██║ ██║  ██║ ██╔══██║   ╚██╔╝  
    ╚███╔███╔╝ ███████╗ ██████╔╝ ██║ ╚████║ ███████╗ ███████║ ██████╔╝ ██║  ██║    ██║   
     ╚══╝╚══╝  ╚══════╝ ╚═════╝  ╚═╝  ╚═══╝ ╚══════╝ ╚══════╝ ╚═════╝  ╚═╝  ╚═╝    ╚═╝   
    ]],

    Thu = [[
    ████████╗ ██╗  ██╗ ██╗   ██╗ ██████╗  ███████╗ ██████╗   █████╗  ██╗   ██╗
    ╚══██╔══╝ ██║  ██║ ██║   ██║ ██╔══██╗ ██╔════╝ ██╔══██╗ ██╔══██╗ ╚██╗ ██╔╝
       ██║    ███████║ ██║   ██║ ██████╔╝ ███████╗ ██║  ██║ ███████║  ╚████╔╝ 
       ██║    ██╔══██║ ██║   ██║ ██╔══██╗ ╚════██║ ██║  ██║ ██╔══██║   ╚██╔╝  
       ██║    ██║  ██║ ╚██████╔╝ ██║  ██║ ███████║ ██████╔╝ ██║  ██║    ██║   
       ╚═╝    ╚═╝  ╚═╝  ╚═════╝  ╚═╝  ╚═╝ ╚══════╝ ╚═════╝  ╚═╝  ╚═╝    ╚═╝   
    ]],

    Fri = [[
    ███████╗ ██████╗  ██╗ ██████╗   █████╗  ██╗   ██╗
    ██╔════╝ ██╔══██╗ ██║ ██╔══██╗ ██╔══██╗ ╚██╗ ██╔╝
    █████╗   ██████╔╝ ██║ ██║  ██║ ███████║  ╚████╔╝ 
    ██╔══╝   ██╔══██╗ ██║ ██║  ██║ ██╔══██║   ╚██╔╝  
    ██║      ██║  ██║ ██║ ██████╔╝ ██║  ██║    ██║   
    ╚═╝      ╚═╝  ╚═╝ ╚═╝ ╚═════╝  ╚═╝  ╚═╝    ╚═╝   
    ]],

    Sat = [[
    ███████╗  █████╗  ████████╗ ██╗   ██╗ ██████╗  ██████╗   █████╗  ██╗   ██╗
    ██╔════╝ ██╔══██╗ ╚══██╔══╝ ██║   ██║ ██╔══██╗ ██╔══██╗ ██╔══██╗ ╚██╗ ██╔╝
    ███████╗ ███████║    ██║    ██║   ██║ ██████╔╝ ██║  ██║ ███████║  ╚████╔╝ 
    ╚════██║ ██╔══██║    ██║    ██║   ██║ ██╔══██╗ ██║  ██║ ██╔══██║   ╚██╔╝  
    ███████║ ██║  ██║    ██║    ╚██████╔╝ ██║  ██║ ██████╔╝ ██║  ██║    ██║   
    ╚══════╝ ╚═╝  ╚═╝    ╚═╝     ╚═════╝  ╚═╝  ╚═╝ ╚═════╝  ╚═╝  ╚═╝    ╚═╝   
    ]],

    Sun = [[
    ███████╗ ██╗   ██╗ ███╗   ██╗ ██████╗   █████╗  ██╗   ██╗
    ██╔════╝ ██║   ██║ ████╗  ██║ ██╔══██╗ ██╔══██╗ ╚██╗ ██╔╝
    ███████╗ ██║   ██║ ██╔██╗ ██║ ██║  ██║ ███████║  ╚████╔╝ 
    ╚════██║ ██║   ██║ ██║╚██╗██║ ██║  ██║ ██╔══██║   ╚██╔╝  
    ███████║ ╚██████╔╝ ██║ ╚████║ ██████╔╝ ██║  ██║    ██║   
    ╚══════╝  ╚═════╝  ╚═╝  ╚═══╝ ╚═════╝  ╚═╝  ╚═╝    ╚═╝
    ]]

}

return {

    -- bufferline
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        keys = {
            { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>",            desc = "Toggle pin" },
            { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
        },
        opts = {
            options = {
                -- stylua: ignore
                close_command = function(n) require("mini.bufremove").delete(n, false) end,
                -- stylua: ignore
                right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
                always_show_bufferline = false,
                -- diagnostics = "nvim_lsp",
                -- diagnostics_indicator = function(_, _, diag)
                --     local icons = require("config.icons").icons.diagnostics
                --     local ret = (diag.error and icons.Error .. diag.error .. " " or "")
                --         .. (diag.warning and icons.Warn .. diag.warning or "")
                --     return vim.trim(ret)
                -- end,
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "NvimTree",
                        highlight = "Directory",
                        text_align = "left",
                    },
                },
            },
        },
    },

    -- statusline
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = function()
            local icons = require("config.icons").icons
            local Util = require("util")

            return {
                options = {
                    theme = "auto",
                    globalstatus = true,
                    disabled_filetypes = { statusline = { "dashboard", "alpha" } },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch" },
                    lualine_c = {
                        {
                            "diagnostics",
                            symbols = {
                                error = icons.diagnostics.Error,
                                warn = icons.diagnostics.Warn,
                                info = icons.diagnostics.Info,
                                hint = icons.diagnostics.Hint,
                            },
                        },
                        {
                            "filetype",
                            icon_only = true,
                            separator = "",
                            padding = {
                                left = 1, right = 0 }
                        },
                        { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
                        -- stylua: ignore
                        {
                            function() return require("nvim-navic").get_location() end,
                            cond = function()
                                return package.loaded["nvim-navic"] and
                                    require("nvim-navic").is_available()
                            end,
                        },
                    },
                    lualine_x = {
                        {
                            require("lazy.status").updates,
                            cond = require("lazy.status").has_updates,
                            color = Util.fg("Special"),
                        },
                        {
                            "diff",
                            symbols = {
                                added = icons.git.added,
                                modified = icons.git.modified,
                                removed = icons.git.removed,
                            },
                        },
                    },
                    lualine_y = {
                        { "progress", separator = " ",                  padding = { left = 1, right = 0 } },
                        { "location", padding = { left = 0, right = 1 } },
                    },
                    lualine_z = {
                        function()
                            return " " .. os.date("%R")
                        end,
                    },
                },
                extensions = { "neo-tree", "lazy" },
            }
        end,
    },

    -- indent guides for Neovim
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            -- char = "▏",
            char = "│",
            filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
            show_trailing_blankline_indent = false,
            show_current_context = false,
        },
    },

    -- active indent guide and indent text objects
    {
        "echasnovski/mini.indentscope",
        version = false, -- wait till new 0.7.0 release to put it back on semver
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            -- symbol = "▏",
            symbol = "│",
            options = { try_as_border = true },
        },
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
        end,
    },

    -- dashboard
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        opts = function()
            local dashboard = require("alpha.themes.dashboard")
            local day = os.date("%a")
            local logo = DAYS[day];

            dashboard.section.header.val = vim.split(logo, "\n")
            dashboard.section.buttons.val = {
                dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
                dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
                dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
                dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
                dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
                dashboard.button("q", " " .. " Quit", ":qa<CR>"),
            }
            for _, button in ipairs(dashboard.section.buttons.val) do
                button.opts.hl = "AlphaButtons"
                button.opts.hl_shortcut = "AlphaShortcut"
            end
            dashboard.section.header.opts.hl = "AlphaHeader"
            dashboard.section.buttons.opts.hl = "AlphaButtons"
            dashboard.section.footer.opts.hl = "AlphaFooter"
            dashboard.opts.layout[1].val = 8
            return dashboard
        end,
        config = function(_, dashboard)
            -- close Lazy and re-open when the dashboard is ready
            if vim.o.filetype == "lazy" then
                vim.cmd.close()
                vim.api.nvim_create_autocmd("User", {
                    pattern = "AlphaReady",
                    callback = function()
                        require("lazy").show()
                    end,
                })
            end

            require("alpha").setup(dashboard.opts)

            -- load scheme(gruvbox & everforest)
            vim.cmd.colorscheme("everforest")

            vim.api.nvim_create_autocmd("User", {
                pattern = "LazyVimStarted",
                callback = function()
                    local stats = require("lazy").stats()
                    local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                    dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
                    pcall(vim.cmd.AlphaRedraw)

                    vim.cmd(":normal zz")
                end,
            })

        end,
    },

    -- icons
    { "nvim-tree/nvim-web-devicons", lazy = true },
}
