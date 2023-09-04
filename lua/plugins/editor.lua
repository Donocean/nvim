local Util = require("util")

return {

    -- file explorer
    {
        "nvim-tree/nvim-tree.lua",
        keys = { {
            "<leader>e",
            "<cmd>NvimTreeToggle<cr><cmd>IlluminatePauseBuf<cr>",
            silent = true,
            desc = "Explorer NeoTree"
        } },
        opts = {
            sort_by = "case_sensitive",
            hijack_cursor = true,
            view = {
                width = 25,
            },
            renderer = {
                group_empty = true,
                highlight_git = true,
                icons = {
                    glyphs = {
                        git = {
                            unstaged = '',
                            staged = '',
                            unmerged = '',
                            renamed = '',
                            deleted = '',
                            untracked = '',
                            ignored = '',
                        },
                        folder = {
                            default = '',
                            open = '',
                            symlink = '',
                        },
                    },
                    show = {
                        git = false,
                        file = true,
                        folder = true,
                        folder_arrow = false,
                    },
                },
            },
            filters = {
                dotfiles = true,
            },
            on_attach = function(bufnr)
                local api = require("nvim-tree.api")

                local function opts(desc)
                    return {
                        desc = "nvim-tree: " .. desc,
                        buffer = bufnr,
                        noremap = true,
                        silent = true,
                        nowait = true
                    }
                end

                -- file operation
                vim.keymap.set('n', '<leader>', api.node.open.edit, opts('Open'))
                vim.keymap.set('n', '<cr>', api.node.open.edit, opts('Open'))
                vim.keymap.set('n', '<bs>', api.node.navigate.parent_close, opts('Close Directory'))
                vim.keymap.set('n', 'q', api.tree.close, opts('Close'))
                vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
                vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
                vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
                vim.keymap.set('n', 'c', api.fs.copy.node, opts('Copy'))
                vim.keymap.set('n', 'p', api.fs.paste, opts('Paste'))
                -- items
                vim.keymap.set('n', 'f', api.live_filter.start, opts('Filter'))
                vim.keymap.set('n', 'F', api.live_filter.clear, opts('Clean Filter'))
                vim.keymap.set('n', 'e', api.tree.expand_all, opts('Expand All'))
                vim.keymap.set('n', 'w', api.tree.collapse_all, opts('Collapse'))
                vim.keymap.set('n', 'H', api.tree.toggle_hidden_filter, opts('Toggle Filter: Dotfiles'))
                -- modfied file in git
                vim.keymap.set('n', '[c', api.node.navigate.git.prev, opts('Prev Git'))
                vim.keymap.set('n', ']c', api.node.navigate.git.next, opts('Next Git'))
                -- opne with tab/split
                vim.keymap.set('n', '<tab>', api.node.open.tab, opts('Open: New Tab'))
                vim.keymap.set('n', '<C-s>', api.node.open.vertical, opts('Open: Vertical Split'))
                vim.keymap.set('n', '<C-x>', api.node.open.horizontal, opts('Open: Horizontal Split'))
                -- copy path
                vim.keymap.set('n', 'y', api.fs.copy.relative_path, opts('Copy Relative Path'))
                vim.keymap.set('n', 'Y', api.fs.copy.absolute_path, opts('Copy Absolute Path'))
                -- help
                vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
            end
        },
        config = function(_, opts)
            -- disable netrw at the very start of your init.lua
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
            -- set termguicolors to enable highlight groups
            vim.opt.termguicolors = true
            require('nvim-tree').setup(opts)
        end,
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
            { "<leader>ff",      Util.telescope("files"),                              desc = "Find Files (root dir)" },
            { "<leader>fF",      Util.telescope("files", { cwd = false }),             desc = "Find Files (cwd)" },
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
                "<leader>uC",
                Util.telescope("colorscheme", { enable_preview = true }),
                desc = "Colorscheme with preview",
            },
            {
                "<leader>ss",
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
                "<leader>sS",
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
        },
    },

    -- which-key
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            plugins = { spelling = true },
            defaults = {
                mode = { "n", "v" },
                ["g"] = { name = "+goto" },
                ["gz"] = { name = "+surround" },
                ["]"] = { name = "+next" },
                ["["] = { name = "+prev" },
                ["<leader><tab>"] = { name = "+tabs" },
                ["<leader>b"] = { name = "+buffer" },
                ["<leader>c"] = { name = "+code" },
                ["<leader>f"] = { name = "+file/find" },
                ["<leader>g"] = { name = "+git" },
                ["<leader>gh"] = { name = "+hunks" },
                ["<leader>q"] = { name = "+quit/session" },
                ["<leader>s"] = { name = "+search" },
                ["<leader>u"] = { name = "+ui" },
                ["<leader>w"] = { name = "+windows" },
                ["<leader>x"] = { name = "+diagnostics/quickfix" },
            },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            wk.register(opts.defaults)
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

    -- buffer remove
    {
        "echasnovski/mini.bufremove",
        -- stylua: ignore
        keys = {
            { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
            { "<leader>bD", function() require("mini.bufremove").delete(0, true) end,  desc = "Delete Buffer (Force)" },
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
}
