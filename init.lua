-- first load options
require("config.options")

-- load lazy.nvim
require("config.lazy")

-- load autocmds and keymaps
require("config.autocmds")
require("config.keymaps")

-- load scheme(tokyonight & gruvbox)
vim.cmd.colorscheme("gruvbox")

-- background transparent
-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
