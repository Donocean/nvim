filetype on
filetype indent on
filetype plugin on
filetype plugin indent on

" <LEADER> = space
let mapleader=" "

set encoding=utf-8

" syntax highlight
syntax on

" display line_number
set number
set relativenumber

set scrolloff=5

" tab = 4
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab

set cursorline
set wrap
set showcmd
set wildmenu 

" search
set hlsearch
exec "nohlsearch"
set incsearch
set ignorecase
set smartcase

" set vim clipboard sync to the system clipboard
set clipboard+=unnamedplus

"---------------key map ---------------
" save file
noremap <C-s>  :w<CR>

" no high light search
noremap <LEADER><CR> :nohlsearch<CR>

" You can use [:q] or [ctrl-w_q] or [ctrl-w_c](more safe) to close windows(like tab_windows/split_windows)
" special: [ctrl-w_o] close all windows but this one
" USE [ctrl-w-T] to move split_window to the new tab_windows

" -------- tab --------
" open a new tab
noremap <LEADER>te :tabe<CR>:FZF<CR>
" jump tab page
noremap ]t gt
noremap [t gT

" -------------- split --------------
" open a vertical split window in the right
" map <LEADER>vs :set splitright<CR>:vsplit<CR>:edit 
map <C-w>v :set splitright<CR>:vsplit<CR>
" open a split window in the below
" map <LEADER>s :set splitbelow<CR>:split<CR>:edit 
map <C-w>s :set splitbelow<CR>:split<CR>

" -------------- modify split window size  --------------
" modify vsplit window size to left 
map <C-h> :vertical resize-5<CR>
" modify vsplit window size to right 
map <C-l> :vertical resize+5<CR>
" modify split window size to up 
map <C-k> :res+5<CR>
" modify split window size to down 
map <C-j> :res-5<CR>

" toggle nerdtree
nnoremap tt :NERDTreeToggle<CR>

" vim_table_mode(markdown)
noremap <LEADER>tm :TableModeToggle<CR>

" fzf
noremap <LEADER>p :GFiles<CR>
noremap <LEADER>b :Buffers<CR>
noremap <LEADER>m :Marks<CR>
imap ,\ <plug>(fzf-complete-path)

" ---------- command map--------------------
" run :Bd to close alll other buffers 
command Bd :up | %bd | e#

"---------------key map over ---------------

" plug
call plug#begin('~/.config/nvim/plugged')

" file tree
Plug 'preservim/nerdtree'

" display yank history
Plug 'junegunn/vim-peekaboo'

" -----------vim look style---------
" scheme
Plug 'morhetz/gruvbox'
" nice tabline
Plug 'mg979/vim-xtabline'
" rainbow brackets
Plug 'luochen1990/rainbow'
  
" comment
" press gcc under normal mod 
" press gc under visual mod
" press gcap to comment a }
Plug 'tpope/vim-commentary'

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
 
" coc
Plug 'neoclide/coc.nvim', {'branch': 'release'}
 
" Markdown
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeToggle' }

call plug#end()

" let g:coc_global_extensions = ['coc-yank']
" nnoremap <silent><space>y :<c-u>CocList -A --normal yank<cr>

" === Scheme
colorscheme gruvbox
set background=dark
" set CocSearch font color
highlight CocSearch ctermfg=brown

" === Rainbow Parentheses
"set to 0 if you want to enable it later via :RainbowToggle
let g:rainbow_active = 1 

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

" === CoC
" Use tab for trigger completion 
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion 
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" some snippits
source ~/.config/nvim/snippits.vim


