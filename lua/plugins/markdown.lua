return {
    {
        "dhruvasagar/vim-table-mode",
        ft = { "markdown" },
        cmd = "TableModeToggle",
        keys = { { "<leader>mt", "<cmd>TableModeToggle<cr>", desc = "Toggle markdown table" }, },
    },
    -- markdown-preview
    {
        'MeanderingProgrammer/render-markdown.nvim',
        event = "VeryLazy",
        ft = { "markdown" },
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {
            callout = {
                abstract = { raw = "[!ABSTRACT]", rendered = "󰯂 Abstract", highlight = "RenderMarkdownInfo", category = "obsidian" },
                summary = { raw = "[!SUMMARY]", rendered = "󰯂 Summary", highlight = "RenderMarkdownInfo", category = "obsidian" },
                tldr = { raw = "[!TLDR]", rendered = "󰦩 Tldr", highlight = "RenderMarkdownInfo", category = "obsidian" },
                failure = { raw = "[!FAILURE]", rendered = " Failure", highlight = "RenderMarkdownError", category = "obsidian" },
                fail = { raw = "[!FAIL]", rendered = " Fail", highlight = "RenderMarkdownError", category = "obsidian" },
                missing = { raw = "[!MISSING]", rendered = " Missing", highlight = "RenderMarkdownError", category = "obsidian" },
                attention = { raw = "[!ATTENTION]", rendered = " Attention", highlight = "RenderMarkdownWarn", category = "obsidian" },
                warning = { raw = "[!WARNING]", rendered = " Warning", highlight = "RenderMarkdownWarn", category = "github" },
                danger = { raw = "[!DANGER]", rendered = " Danger", highlight = "RenderMarkdownError", category = "obsidian" },
                error = { raw = "[!ERROR]", rendered = " Error", highlight = "RenderMarkdownError", category = "obsidian" },
                bug = { raw = "[!BUG]", rendered = " Bug", highlight = "RenderMarkdownError", category = "obsidian" },
                quote = { raw = "[!QUOTE]", rendered = " Quote", highlight = "RenderMarkdownQuote", category = "obsidian" },
                cite = { raw = "[!CITE]", rendered = " Cite", highlight = "RenderMarkdownQuote", category = "obsidian" },
                todo = { raw = "[!TODO]", rendered = " Todo", highlight = "RenderMarkdownInfo", category = "obsidian" },
                wip = { raw = "[!WIP]", rendered = "󰦖 WIP", highlight = "RenderMarkdownHint", category = "obsidian" },
                done = { raw = "[!DONE]", rendered = " Done", highlight = "RenderMarkdownSuccess", category = "obsidian" },
            },

            sign = { enabled = false },

            code = {
                width = "block",
                min_width = 80,

                border = "thin",
                left_pad = 1,
                right_pad = 1,

                position = "right",
                language_icon = true,
                language_name = true,

                highlight_inline = "RenderMarkdownCodeInfo",
            },

            heading = {
                icons = { " 󰼏 ", " 󰎨 ", " 󰼑 ", " 󰎲 ", " 󰼓 ", " 󰎴 " },
                border = true,
                setext = false,

                render_modes = true, -- keep rendering while inserting
            },

            checkbox = {
                unchecked = {
                    icon = "󰄱",
                    highlight = "RenderMarkdownCodeFallback",
                    scope_highlight = "RenderMarkdownCodeFallback",
                },

                checked = {
                    icon = "󰄵",

                    -- 原配置这里是 RenderMarkdownUnchecked
                    -- 我更建议改成 Checked
                    highlight = "RenderMarkdownChecked",
                    scope_highlight = "RenderMarkdownChecked",
                },

                custom = {
                    question = {
                        raw = "[?]",
                        rendered = "",
                        highlight = "RenderMarkdownError",
                        scope_highlight = "RenderMarkdownError",
                    },

                    todo = {
                        raw = "[>]",
                        rendered = "󰦖",
                        highlight = "RenderMarkdownInfo",
                        scope_highlight = "RenderMarkdownInfo",
                    },

                    canceled = {
                        raw = "[-]",
                        rendered = "",
                        highlight = "RenderMarkdownCodeFallback",
                        scope_highlight = "@text.strike",
                    },

                    important = {
                        raw = "[!]",
                        rendered = "",
                        highlight = "RenderMarkdownWarn",
                        scope_highlight = "RenderMarkdownWarn",
                    },

                    favorite = {
                        raw = "[~]",
                        rendered = "",
                        highlight = "RenderMarkdownMath",
                        scope_highlight = "RenderMarkdownMath",
                    },
                },
            },

            pipe_table = {
                alignment_indicator = "─",
                border = { "╭", "┬", "╮", "├", "┼", "┤", "╰", "┴", "╯", "│", "─" },
            },

            link = {
                image = " ",
                hyperlink = " ",
                custom = {
                    github = { pattern = "github", icon = " " },
                    gitlab = { pattern = "gitlab", icon = "󰮠 " },
                    youtube = { pattern = "youtube", icon = " " },
                },
                wiki = { icon = " ", highlight = "RenderMarkdownWikiLink", scope_highlight = "RenderMarkdownWikiLink" },
            },

            anti_conceal = {
                -- disabled_modes = { "n" },
                ignore = {
                    head_border = true,
                    head_background = true,
                },
            },

            win_options = {
                concealcursor = { rendered = "vc" },

                -- 这个其实也可以直接交给 render-markdown 管
                conceallevel = { rendered = 2 },
            },

            completions = { lsp = { enabled = true }, },
        },
    }
}
