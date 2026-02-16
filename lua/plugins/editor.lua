local Util = require("util")

function _G.get_oil_winbar()
    local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    local dir = require("oil").get_current_dir(bufnr)
    if dir then
        return vim.fn.fnamemodify(dir, ":~")
    else
        -- If there is no current directory (e.g. over ssh), just show the buffer name
        return vim.api.nvim_buf_get_name(0)
    end
end

return {

    -- file explorer
    {
        'stevearc/oil.nvim',
        lazy = false,
        -- show icon
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            {
                "<leader>e",
                "<cmd>Oil<cr>",
                silent = true,
                desc = "File Explorer"
            },
        },
        opts = {
            win_options = {
                winbar = "%!v:lua.get_oil_winbar()",
            },
            keymaps = {
                ["<C-p>"] = false,
                ["<C-h>"] = false,
                ["<C-s>"] = false,
                ["<C-l>"] = false,
                ["-"] = false,
                ["<CR>"] = "actions.refresh",
                ["<c-h>"] = { "actions.parent", mode = "n" },
                ["<c-l>"] = "actions.select",
                ["<C-c>"] = { "actions.close", mode = "n" },
            },
        },
    },

    -- fuzzy finder
    { "nvim-lua/plenary.nvim", lazy = true }, -- dependencies
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        version = false, -- telescope did only one release, so use HEAD for now
        keys = {
            { "<leader>,",       "<cmd>Telescope buffers show_all_buffers=true<cr>",   desc = "Switch Buffer" },
            { "<leader>/",       Util.telescope("live_grep"),                          desc = "Grep (root dir)" },
            { "<leader>:",       "<cmd>Telescope command_history<cr>",                 desc = "Command History" },
            { "<leader><space>", Util.telescope("files"),                              desc = "Find Files (root dir)" },

            -- find
            { "<leader>fb",      "<cmd>Telescope buffers<cr>",                         desc = "Buffers" },
            { "<leader>ff",      Util.telescope("files"),                              desc = "Find Files (cwd)" },
            { "<leader>fF",      Util.telescope("files", { cwd = false }),             desc = "Find Files (root dir)" },
            { "<leader>fr",      "<cmd>Telescope oldfiles<cr>",                        desc = "Recent" },
            { "<leader>fR",      Util.telescope("oldfiles", { cwd = vim.loop.cwd() }), desc = "Recent (cwd)" },

            -- git
            { "<leader>gc",      "<cmd>Telescope git_commits<CR>",                     desc = "commits" },
            { "<leader>gs",      "<cmd>Telescope git_status<CR>",                      desc = "status" },

            -- search
            { "<leader>sa",      "<cmd>Telescope autocommands<cr>",                    desc = "Auto Commands" },
            { "<leader>sb",      "<cmd>Telescope current_buffer_fuzzy_find<cr>",       desc = "Buffer" },
            { "<leader>sc",      "<cmd>Telescope command_history<cr>",                 desc = "Command History" },
            { "<leader>sC",      "<cmd>Telescope commands<cr>",                        desc = "Commands" },
            { "<leader>sd",      "<cmd>Telescope diagnostics bufnr=0<cr>",             desc = "Document diagnostics" },
            { "<leader>sD",      "<cmd>Telescope diagnostics<cr>",                     desc = "Workspace diagnostics" },
            { "<leader>sg",      Util.telescope("live_grep"),                          desc = "Grep (root dir)" },
            { "<leader>sG",      Util.telescope("live_grep", { cwd = false }),         desc = "Grep (cwd)" },
            { "<leader>sh",      "<cmd>Telescope help_tags<cr>",                       desc = "Help Pages" },
            { "<leader>sH",      "<cmd>Telescope highlights<cr>",                      desc = "Search Highlight Groups" },
            { "<leader>sk",      "<cmd>Telescope keymaps<cr>",                         desc = "Key Maps" },
            { "<leader>sM",      "<cmd>Telescope man_pages<cr>",                       desc = "Man Pages" },
            { "<leader>sm",      "<cmd>Telescope marks<cr>",                           desc = "Jump to Mark" },
            { "<leader>so",      "<cmd>Telescope vim_options<cr>",                     desc = "Options" },
            { "<leader>sR",      "<cmd>Telescope resume<cr>",                          desc = "Resume" },
            { "<leader>sw",      Util.telescope("grep_string"),                        desc = "Word (root dir)" },
            { "<leader>sW",      Util.telescope("grep_string", { cwd = false }),       desc = "Word (cwd)" },
            {
                '<leader>\\',
                function()
                    require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                        winblend = 10,
                        previewer = false,
                    }))
                end,
                desc = "Fuzzily search in current buffer"
            },
            {
                "<leader>ui",
                Util.telescope("colorscheme", { enable_preview = true }),
                desc = "Colorscheme with preview",
            },
            {
                "gs",
                Util.telescope("lsp_document_symbols", {
                    symbols = {
                        "Class",
                        "Function",
                        "Method",
                        "Constructor",
                        "Interface",
                        "Module",
                        "Struct",
                        "Trait",
                        "Field",
                        "Property",
                    },
                }),
                desc = "Goto Symbol",
            },
            {
                "gS",
                Util.telescope("lsp_dynamic_workspace_symbols", {
                    symbols = {
                        "Class",
                        "Function",
                        "Method",
                        "Constructor",
                        "Interface",
                        "Module",
                        "Struct",
                        "Trait",
                        "Field",
                        "Property",
                    },
                }),
                desc = "Goto Symbol (Workspace)",
            },
        },
        opts = {
            defaults = {
                prompt_prefix = " ",
                selection_caret = " ",
                mappings = {
                    i = {
                        ["<C-j>"] = function(...)
                            require("telescope.actions").move_selection_next(...)
                        end,
                        ["<C-k>"] = function(...)
                            require("telescope.actions").move_selection_previous(...)
                        end,
                        ["<a-i>"] = function()
                            local action_state = require("telescope.actions.state")
                            local line = action_state.get_current_line()
                            Util.telescope("find_files", { no_ignore = true, default_text = line })()
                        end,
                        ["<a-h>"] = function()
                            local action_state = require("telescope.actions.state")
                            local line = action_state.get_current_line()
                            Util.telescope("find_files", { hidden = true, default_text = line })()
                        end,
                        ["<Down>"] = function(...)
                            return require("telescope.actions").cycle_history_next(...)
                        end,
                        ["<Up>"] = function(...)
                            return require("telescope.actions").cycle_history_prev(...)
                        end,
                        ["<C-f>"] = function(...)
                            return require("telescope.actions").preview_scrolling_down(...)
                        end,
                        ["<C-b>"] = function(...)
                            return require("telescope.actions").preview_scrolling_up(...)
                        end,
                    },
                    n = {
                        ["q"] = function(...)
                            return require("telescope.actions").close(...)
                        end,
                    },
                },
            },
            extensions = {
                project = {
                    theme = "dropdown",
                    order_by = "recent",
                    search_by = "title",
                    ignore_missing_dirs = true,

                    mappings = {
                        i = {
                            ['<c-d>'] = function(...)
                                return require("telescope._extensions.project.actions").delete_project(...)
                            end,
                            ['<c-r>'] = function(...)
                                return require("telescope._extensions.project.actions").rename_project(...)
                            end,
                            ['<c-a>'] = function(...)
                                return require("telescope._extensions.project.actions").add_project(...)
                            end,
                            ['<c-s>'] = function(...)
                                return require("telescope._extensions.project.actions").search_in_project_files(...)
                            end,
                            ['<c-o>'] = function(...)
                                return require("telescope._extensions.project.actions").next_cd_scope(...)
                            end,
                        }
                    },
                },
            },
        },
    },

    -- project for telescope find
    {
        'nvim-telescope/telescope-project.nvim',
        dependencies = { 'nvim-telescope/telescope.nvim' },
        keys = {
            {
                "<leader>po",
                "<cmd>lua require'telescope'.extensions.project.project{display_type = 'full', hide_workspace = true }<cr>",
                silent = true,
                desc = "find project"
            },
        },
        config = function()
            require('telescope').load_extension('project')
        end
    },

    -- which-key
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts_extend = { "spec" },
        opts = {
            defaults = {},
            spec = {
                {
                    mode = { "n", "v" },
                    { "<leader>c", group = "code" },
                    { "<leader>d", group = "debug" },
                    { "<leader>f", group = "file/find" },
                    { "<leader>g", group = "git" },
                    { "<leader>gh", group = "hunks" },
                    { "<leader>s", group = "search" },
                    { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
                    { "<leader>p", group = "overseer" },
                    { "[", group = "prev" },
                    { "]", group = "next" },
                    { "g", group = "goto" },
                    { "gs", group = "surround" },
                    { "z", group = "fold" },
                    {
                        "<leader>b",
                        group = "buffer",
                        expand = function()
                            return require("which-key.extras").expand.buf()
                        end,
                    },
                    -- better descriptions
                    { "gx", desc = "Open with system app" },
                },
            },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
        end,
    },

    -- hightlight same symbols
    {
        "RRethy/vim-illuminate",
        event = { "BufReadPost", "BufNewFile" },
        opts = { delay = 200 },
        config = function(_, opts)
            require("illuminate").configure(opts)

            local function map(key, dir, buffer)
                vim.keymap.set("n", key, function()
                    require("illuminate")["goto_" .. dir .. "_reference"](false)
                end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
            end

            map("]r", "next")
            map("[r", "prev")

            -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    local buffer = vim.api.nvim_get_current_buf()
                    map("]r", "next", buffer)
                    map("[r", "prev", buffer)
                end,
            })
        end,
        keys = {
            { "]r", desc = "Next Reference" },
            { "[r", desc = "Prev Reference" },
        },
    },

    -- git signs
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
            on_attach = function(buffer)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
                end

                -- stylua: ignore start
                map("n", "]h", gs.next_hunk, "Next Hunk")
                map("n", "[h", gs.prev_hunk, "Prev Hunk")
                map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
                map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
                map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
                map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
                map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
                map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
                map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
                map("n", "<leader>ghd", gs.diffthis, "Diff This")
                map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
            end,
        },
    },

    {
        "stevearc/overseer.nvim",
        cmd = {
            "OverseerOpen",
            "OverseerClose",
            "OverseerToggle",
            "OverseerSaveBundle",
            "OverseerLoadBundle",
            "OverseerDeleteBundle",
            "OverseerRunCmd",
            "OverseerRun",
            "OverseerInfo",
            "OverseerBuild",
            "OverseerQuickAction",
            "OverseerTaskAction",
            "OverseerClearCache",
        },
        keys = {
            { "<leader>pp", "<cmd>OverseerRun<cr>",         desc = "Run task" },
            { "<leader>pw", "<cmd>OverseerToggle<cr>",      desc = "Task list" },
            { "<leader>pa", "<cmd>OverseerQuickAction<cr>", desc = "Action recent task" },
            { "<leader>pi", "<cmd>OverseerInfo<cr>",        desc = "Overseer Info" },
            { "<leader>pb", "<cmd>OverseerBuild<cr>",       desc = "Task builder" },
            { "<leader>pt", "<cmd>OverseerTaskAction<cr>",  desc = "Task action" },
            { "<leader>pc", "<cmd>OverseerClearCache<cr>",  desc = "Clear cache" },
        },
        config = function()
            local overseer = require("overseer")
            overseer.setup({
                dap = false,
                templates = {
                    "user.build_file",
                    "user.run_file",
                    "user.clean_build",
                    "user.cmake_run",
                    "user.openocd_load",
                    "user.idf_build",
                    "user.openocd_flash",
                    "user.oil_open",
                },
                task_list = {
                    -- bindings = {
                    --     ["<C-h>"] = false,
                    --     ["<C-j>"] = false,
                    --     ["<C-k>"] = false,
                    --     ["<C-l>"] = false,
                    -- },
                },
                form = {
                    win_opts = {
                        winblend = 0,
                    },
                },
                confirm = {
                    win_opts = {
                        winblend = 0,
                    },
                },
                task_win = {
                    win_opts = {
                        winblend = 0,
                    },
                },
            })
        end,
    },

    -- for python miniconda use
    {
        "linux-cultist/venv-selector.nvim",
        ft = "python",
        cmd = { "VenvSelect", "VenvSelectCached" },
        keys = {
            {
                "<leader>v",
                "<cmd>VenvSelect<cr>",
                silent = true,
                desc = "change miniconda environment"
            },
        },
        opts = {
            anaconda_base_path = "~/miniconda3",
            anaconda_envs_path = "~/miniconda3/envs",
            parents = 0,
            stay_on_this_version = true,
            dap_enabled = false, -- need the plugin mfussenegger/nvim-dap-python
            settings = {
                options = {
                    notify_user_on_venv_activation = true,
                },
            },
        },
    },

}
