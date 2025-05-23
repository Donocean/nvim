-- This file is automatically loaded by plugins.config
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.encoding = "utf-8"
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.wildmenu = true
opt.showcmd = true
opt.wrap = true
opt.cursorline = true -- Enable highlighting of the current line
opt.jumpoptions = "stack"

-- tab
opt.autoindent = true
opt.expandtab = true
opt.smarttab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4

opt.scrolloff = 6              -- Lines of context

opt.ignorecase = true          -- Ignore case
opt.smartcase = true           -- Don't ignore case with capitals

opt.number = true              -- Print line number
opt.relativenumber = true      -- Relative line numbers

opt.list = true                -- Show some invisible characters (tabs...
-- opt.listchars:append "space:·" -- Show space
opt.showmode = false           -- Dont show mode since we have a statusline
opt.splitbelow = true          -- Put new windows below current
opt.splitright = true          -- Put new windows right of current
opt.confirm = true             -- Confirm to save changes before exiting modified buffer

opt.conceallevel = 3           -- Hide * markup for bold and italic
opt.completeopt = "menu,menuone,noselect"
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 0
opt.pumblend = 10          -- Popup blend
opt.pumheight = 10         -- Maximum number of entries in a popup
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shortmess:append({ W = true, I = true, c = true })
opt.sidescrolloff = 8              -- Columns of context
opt.signcolumn = "yes"             -- Always show the signcolumn, otherwise it would shift the text each time
opt.termguicolors = true           -- True color support
opt.guicursor = ""                 -- user fat cursor in the insert mode
opt.timeoutlen = 300
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5                -- Minimum window width

if vim.fn.has("nvim-0.9.0") == 1 then
    opt.splitkeep = "screen"
    opt.shortmess:append({ C = true })
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Set filetype to `bigfile` for files larger than 1.5 MB
-- Only vim syntax will be enabled (with the correct filetype)
-- LSP, treesitter and other ft plugins will be disabled.
vim.g.bigfile_size = 1024 * 1024 * 1.5 -- 1.5 MB

-- map some filetypes for ROS
vim.filetype.add({
    extension = {
        launch = 'xml',
        sdf = 'xml',
        urdf = 'xml',
    }
})

-- copy-paste to system clipboard when using SSH
-- the terminla used by users must support OSC52
-- you can excute: [$echo -ne "\033]52;c;$(echo -n hello | base64)\a"] in your terminla to check if it's support
if os.getenv("SSH_TTY") then
    vim.g.clipboard = {
        name = 'OSC 52',
        copy = {
            ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
            ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
        },
        paste = {
            ['+'] = function(lines)
                return { vim.fn.split(vim.fn.getreg(''), "\n"), vim.fn.getregtype('') }
            end,
            ['*'] = function(lines)
                return { vim.fn.split(vim.fn.getreg(''), "\n"), vim.fn.getregtype('') }
            end
        },
    }
end
