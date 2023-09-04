# This is my neovim config based on lua

 Use lua to Configure neovim and use lazy.nvim to manage plugins.

# Plugins

All my plugins was in the `lua/plugins` 

they are primarily separate into five parts

## Coding

- LuaSnip: snippets
- nvim-cmp: auto completion
    - cmp-nvim-lsp
    - cmp-buffer
    - cmp-path
    - cmp_luasnip
- mini.pairs: auto pairs
- mini.comment: comments
- vim-surround: surround
- DoxygenToolkit.vim: Doxygen generator
- vim-visual-multi: multi cursor
- wildfire: press <cr> to choose a region rapidly
- vim-repeat: enhance dot(.)

## Editor 

- nvim-tree.nvim: file explorer
- telescope.nvim: fuzzy finder
- which-key.nvim: key prompt
- vim-illuminate: hightlight same symbols
- mini.bufremove: buffer remove
- gitsigns.nvim: git signs

## UI

- bufferline.nvim: bufferline
- lualine.nvim: statusline
- indent-blankline.nvim: indent guides for Neovim
- mini.indentscope: active indent guide and indent text objects
- alpha-nvim: dashboard
- nvim-navic: lsp symbol navigation for lualine
- nvim-web-devicons: icons

## LSP

- nvim-lspconfig: lspconfig
- mason.nvim: cmdline tools and lsp servers
- mason-lspconfig.nvim

## Colorscheme

- gruvbox
- everforest

## Others 

- nvim-treesitter: perfect language hightlight
- markdown-preview.nvim: markdown-preview
    - vim-table-mode: format markdown table 
