-- firstly, load options
require("config.options")

-- secondly, load lazy.nvim(plugins)
require("config.lazy")

-- load autocmds and keymaps
require("config.autocmds")
require("config.keymaps")

-- load scheme(gruvbox-material & everforest & rose-pine)
local status = pcall(vim.cmd.colorscheme, "everforest")
if not status then
    vim.cmd.colorscheme("habamax")
end

-- set background transparent
-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
