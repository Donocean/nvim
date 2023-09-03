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

require("lazy").setup({
        require("plugins.ui"),
        require("plugins.colorscheme"),
        require("plugins.coding"),
        require("plugins.editor"),
        require("plugins.lsp"),
        require("plugins.treesitter"),
        require("plugins.flash"),
        -- require("plugins.markdown"),
    },
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
