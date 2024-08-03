local Util = require("util")

---@mode can be following parameters
-- nmap Normal
-- vmap Visual and Select
-- smap Select
-- xmap Visual
-- omap Operator-pending
-- map! Insert and Command-line
-- imap Insert
-- lmap Insert, Command-line, Lang-Arg
-- cmap Command-line
-- tmap Terminal
local function map(mode, lhs, rhs, opts)
    local keys = require("lazy.core.handler").handlers.keys or nil
    -- do not create the keymap if a lazy keys handler exists
    if not key or not keys.active[keys.parse({ lhs, mode = mode }).id] then
        opts = opts or {}
        opts.silent = opts.silent ~= false
        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

-- open init.lua
map("n", "<leader>n", ":e $MYVIMRC<cr>", { desc = "Config Nvim" })

map("n", "<leader>q", "q", { desc = "record macro(occupied by flash)" })

-- greatest remap ever
map("x", "<leader>p", '"_dP', { desc = "paste without missing object" })

-- better paste
map("i", "<c-v>", "<c-r>+", { desc = "paste in the insert mode" })

-- better up/down when use wrap
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- better jumping experience
map("n", "<c-d>", "<c-d>zz")
map("n", "<c-u>", "<c-u>zz")
map("n", "}", "}zz")
map("n", "{", "{zz")

-- Resize window using <ctrl>+<arrow> keys
map("n", "<a-j>", "<cmd>resize+5<cr>", { desc = "Increase window height" })
map("n", "<a-k>", "<cmd>resize-5<cr>", { desc = "Decrease window height" })
map("n", "<a-h>", "<cmd>vertical resize-5<cr>", { desc = "Decrease window width" })
map("n", "<a-l>", "<cmd>vertical resize+5<cr>", { desc = "Increase window width" })

test_win = function()
    -- 获取窗口布局
    local layout = vim.fn.winlayout()

    for index, value in ipairs(layout) do
        print(index, value)
    end

    -- 递归函数来检查窗口布局
    local function check_split_type(layout)
        if type(layout[2]) == "table" then
            for _, sublayout in ipairs(layout[2]) do
                local result = check_split_type(sublayout)
                if result then
                    return result
                end
            end
        else
            if layout[1] == "row" then
                return "horizontal"
            elseif layout[1] == "col" then
                return "vertical"
            end
        end
        return nil
    end

    local split_type = check_split_type(layout)
    print("Current window split type is: " .. (split_type or "unknown"))
end

map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

map({ "n", "v", "o" }, "0", "^", { desc = "Start of the line" })
map({ "n", "v", "o" }, ")", "$", { desc = "End of the line" })

-- save file
map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
-- better ctrl-c when use visul vertical mod to add some text
map("i", "<c-c>", "<esc>")

-- tabs/windows
-- map("n", "]w", "gt", { desc = "next tab" })
-- map("n", "[w", "gT", { desc = "previous tab" })
-- because we reraly used tab move, so only one keybinding
map("n", "<leader><tab>", "gt", { desc = "next tab" })
map("n", "<c-h>", "<c-w>h", { desc = "swith to the left window" })
map("n", "<c-l>", "<c-w>l", { desc = "swith to the right window" })
map("n", "<c-j>", "<c-w>j", { desc = "swith to the lower window" })
map("n", "<c-k>", "<c-w>k", { desc = "swith to the upper window" })
-- special: [ctrl-w_o] close all windows but this one
-- USE [ctrl-w-T] to move split_window to the new tab_windows

-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", "<cmd>bd %<cr>", { desc = "close current buffer" })

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

-- floating terminal
map("n", "<leader>w", function() Util.float_term() end, { desc = "Terminal (cwd)" })
map("t", "<c-c>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })

-- lazygit
map("n", "<leader>gg", function()
    Util.float_term({ "lazygit" }, { cwd = Util.get_root(), esc_esc = false })
end, { desc = "Lazygit (root dir)" })
map("n", "<leader>gG", function()
    Util.float_term({ "lazygit" }, { esc_esc = false })
end, { desc = "Lazygit (cwd)" })

-- toggle options
map("n", "<leader>uf", Util.toggle_format, { desc = "Toggle format on Save" })
map("n", "<leader>us", function() Util.toggle("spell") end, { desc = "Toggle Spelling" })
map("n", "<leader>uw", function() Util.toggle("wrap") end, { desc = "Toggle Word Wrap" })
map("n", "<leader>ud", Util.toggle_diagnostics, { desc = "Toggle Diagnostics" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map("n", "<leader>uc", function()
    Util.toggle("conceallevel", false, { 0, conceallevel })
end, { desc = "Toggle Conceal" })

map("n", "<leader>h", "<cmd>ClangdSwitchSourceHeader<cr>", { desc = "toggle headerfile" })
map(
    "n",
    "<leader>cc",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "rename word under current cursor" }
)
