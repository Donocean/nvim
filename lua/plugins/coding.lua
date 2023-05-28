return {

    -- snippets
    {
        "L3MON4D3/LuaSnip",
        event = "InsertEnter",
        build = (not jit.os:find("Windows"))
            and "echo -e 'NOTE: jsregexp is optional, so not a big deal if it fails to build\n'; make install_jsregexp"
            or nil,
        dependencies = {
            "rafamadriz/friendly-snippets",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end,
        },
        opts = {
            history = true,
            delete_check_events = "TextChanged",
        },
        -- stylua: ignore
        -- keys = {
        --     {
        --         "<tab>",
        --         function()
        --             return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        --         end,
        --         expr = true,
        --         silent = true,
        --         mode = "i",
        --     },
        --     { "<tab>",   function() require("luasnip").jump(1) end,  mode = "s" },
        --     { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
        -- },
    },

    -- auto completion
    {
        "hrsh7th/nvim-cmp",
        version = false, -- last release is way too old
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
        },
        opts = function()
            local cmp = require("cmp")
            return {
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<s-tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ["<S-CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }),
                formatting = {
                    format = function(_, item)
                        local icons = require("config.icons").icons.kinds
                        if icons[item.kind] then
                            item.kind = icons[item.kind] .. item.kind
                        end
                        return item
                    end,
                },
                experimental = {
                    ghost_text = {
                        hl_group = "LspCodeLens",
                    },
                },
            }
        end,
    },

    -- auto pairs
    {
        "echasnovski/mini.pairs",
        event = "VeryLazy",
        opts = {},
    },

    -- comments
    {
        "echasnovski/mini.comment",
        event = "VeryLazy",
        opts = {},
    },

    -- surround
    {
        "tpope/vim-surround",
        keys = { "cs", "ds", "ys", { "S", mode = { "v", "x" } }, },
        config = function()
        end,
    },

    -- Doxygen generator
    {
        "babaybus/DoxygenToolkit.vim",
        cmd = "Dox"
    },

    -- multi cursor
    {
        'mg979/vim-visual-multi',
        keys = { "<c-n>" },
    },

    -- wildfire
    {
        "gcmt/wildfire.vim",
        keys = { "<cr>" },
    },

}