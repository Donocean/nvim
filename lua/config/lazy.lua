local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local function get_os()
    local os_name
    if vim.fn.has("macunix") == 1 then
        os_name = "macOS"
    elseif vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
        os_name = "Windows"
    elseif vim.fn.has("unix") == 1 then
        os_name = "Linux"
    else
        os_name = "Unknown"
    end
    return os_name
end

local current_os = get_os()

-- 基本插件列表
local plugins = {
    require("plugins.ui"),
    require("plugins.colorscheme"),
    require("plugins.coding"),
    require("plugins.editor"),
    require("plugins.lsp"),
    require("plugins.treesitter"),
    require("plugins.flash"),
}

if current_os == "macOS" then
    table.insert(plugins, require("plugins.markdown"))
end

-- 使用 lazy 加载插件
require("lazy").setup(plugins)

require("lazy").setup(
    plugins,
    {
        defaults = {
            --  all plugins lazy-loaded by default.
            lazy = true,
            -- have outdated releases, which may break your Neovim install.
            version = false, -- always use the latest git commit
            -- version = "*", -- try installing the latest stable version for plugins that support semver
        },
        git = {
            -- the way to use fastgit to clone plugins
            url_format = "https://github.com/%s.git",
        },
        performance = {
            rtp = {
                -- disable some rtp plugins
                disabled_plugins = {
                    "gzip",
                    -- "matchit",
                    -- "matchparen",
                    -- "netrwPlugin",
                    "tarPlugin",
                    "tohtml",
                    "tutor",
                    "zipPlugin",
                },
            },
        },
    })
