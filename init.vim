set nocompatible
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on

set scrolloff=5

set encoding=utf-8
let &t_ut=' '

let mapleader=" "
syntax on
set number
set relativenumber

set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab


set cursorline
set wrap
set showcmd
set wildmenu 


" set search
set hlsearch
exec "nohlsearch"
set incsearch
set ignorecase
set smartcase

"---------------key map ---------------
" toggle nerdtree
nnoremap tt :NERDTreeToggle<CR>

" no high light search
noremap <LEADER><CR> :nohlsearch<CR>

" -------- tab --------
" open a new tab
noremap <LEADER>te :tabe<CR>
" close this tab
noremap <LEADER>tc :tabc<CR>
" close all tab but this
noremap	<LEADER>to :tabo<CR>

" -------------- open split --------------
" open a vertical split window in the right
map <LEADER>vs :set splitright<CR>:vsplit<CR>:edit 
" open a split window in the below
map <LEADER>s :set splitbelow<CR>:split<CR>:edit 

" -------------- modify split size  --------------
" modify vsplit window size to left 
map <C-h> :vertical resize-5<CR>
" modify vsplit window size to right 
map <C-l> :vertical resize+5<CR>
" modify split window size to up 
map <C-k> :res+5<CR>
" modify split window size to down 
map <C-j> :res-5<CR>

" vim_table_mode(markdown plug)
noremap <LEADER>tm :TableModeToggle<CR>


"set plug
call plug#begin('~/.config/nvim/plugged')
 
" Plug 'vim-airline/vim-airline'
" Plug 'preservim/nerdtree'
" 
" " Markdown
" Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
" Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeToggle' }
" 
call plug#end()

" === MarkdownPreview
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 1
let g:mkdp_refresh_slow = 0
let g:mkdp_command_for_global = 0
let g:mkdp_open_to_the_world = 0
let g:mkdp_open_ip = ''
let g:mkdp_browser = ''
let g:mkdp_echo_preview_url = 0
let g:mkdp_browserfunc = ''
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1
    \ }
let g:mkdp_markdown_css = ''
let g:mkdp_highlight_css = ''
let g:mkdp_port = ''
let g:mkdp_page_title = '「${name}」'


" Compile function
map r :call CompileRunGcc()<CR>
func! CompileRunGcc()
  exec "w"
  if &filetype == 'c'
    exec "!gcc % -o %<"
    exec "!time ./%<"
  elseif &filetype == 'cpp'
    exec "!g++ % -o %<"
    exec "!time ./%<"
  elseif &filetype == 'java'
    exec "!javac %"
    exec "!time java %<"
  elseif &filetype == 'sh'
    :!time bash %
  elseif &filetype == 'python'
    silent! exec "!clear"
    exec "!time python3 %"
  elseif &filetype == 'markdown'
    exec "MarkdownPreview"
  endif
endfunc

source ~/.config/nvim/snippits.vim

