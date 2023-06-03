local Util = require("util")

local function map(mode, lhs, rhs, opts)
    local keys = require("lazy.core.handler").handlers.keys
    ---@cast keys LazyKeysHandler
    -- do not create the keymap if a lazy keys handler exists
    if not keys.active[keys.parse({ lhs, mode = mode }).id] then
        opts = opts or {}
        opts.silent = opts.silent ~= false
        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

-- better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize+5<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize-5<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize-5<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize+5<cr>", { desc = "Increase window width" })

map("n", "<leader><cr>", "<cmd>nohlsearch<cr>", { desc = "clear hlsearch" })
map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

map({"n", "v"}, "0", "^", { desc = "start of the line" })
map({"n", "v"}, ")", "$", { desc = "end of the line" })

-- save file
map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
-- quit
map("n", "<leader>q", "<c-w>q", { desc = "Quit window" })
map("i", "<c-c>", "<esc>")

-- tab
map("n", "<leader><tab>", ":tabe<cr>", { desc = "open a new tab" })
map("n", "<c-l>", "gt", { desc = "next tab" })
map("n", "<c-h>", "gT", { desc = "previous tab" })
-- special: [ctrl-w_o] close all windows but this one
-- USE [ctrl-w-T] to move split_window to the new tab_windows

-- buffers
if Util.has("bufferline.nvim") then
    map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
    map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
    map("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
    map("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
else
    map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
    map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
    map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
    map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
end
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- lazy
map("n", "<leader>l", "<cmd>:Lazy<cr>", { desc = "Lazy" })

-- highlights under cursor
if vim.fn.has("nvim-0.9.0") == 1 then
    map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
end

-- floating terminal
map("n", "<leader>ft", function() Util.float_term(nil, { cwd = Util.get_root() }) end, { desc = "Terminal (root dir)" })
map("n", "<leader>fT", function() Util.float_term() end, { desc = "Terminal (cwd)" })
map("t", "<c-c>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
map("n", "<leader>gG", function() Util.float_term({ "lazygit" }, { esc_esc = false }) end, { desc = "Lazygit (cwd)" })

-- lazygit
map("n", "<leader>gg", function() Util.float_term({ "lazygit" }, { cwd = Util.get_root(), esc_esc = false }) end,
    { desc = "Lazygit (root dir)" })
map("n", "<leader>gG", function() Util.float_term({ "lazygit" }, { esc_esc = false }) end, { desc = "Lazygit (cwd)" })

-- toggle options
map("n", "<leader>uf", require("config.format").toggle, { desc = "Toggle format on Save" })
map("n", "<leader>us", function() Util.toggle("spell") end, { desc = "Toggle Spelling" })
map("n", "<leader>uw", function() Util.toggle("wrap") end, { desc = "Toggle Word Wrap" })
map("n", "<leader>ud", Util.toggle_diagnostics, { desc = "Toggle Diagnostics" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map("n", "<leader>uc", function() Util.toggle("conceallevel", false, { 0, conceallevel }) end,
    { desc = "Toggle Conceal" })

-- easy compile
local compile = function()
    local substr = vim.api.nvim_eval("&filetype")
    
    if substr == "c" then
        vim.cmd("!gcc % -o %<.out")
        vim.cmd("!time ./%<.out")
    elseif substr == "cpp" then
        vim.cmd("!g++ % -o %<.out")
        vim.cmd("!time ./%<.out")
    elseif substr == "lua" then
        vim.cmd("!lua %")
    end
end
map("n", "<leader>r", compile, { desc = "compile current file" })


map("n", "<leader>h","<cmd>ClangdSwitchSourceHeader<cr>", { desc = "toggle headerfile"})
