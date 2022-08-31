filetype on
filetype indent on
filetype plugin on
filetype plugin indent on

" syntax highlight
syntax on

" display line_number
set number
set relativenumber

" <LEADER> = space
let mapleader=" "

set scrolloff=5
set encoding=utf-8

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
" no high light search
noremap <LEADER><CR> :nohlsearch<CR>

" -------- tab --------
" open a new tab
noremap <LEADER>te :tabe<CR>:FZF<CR>
" close this tab
noremap <LEADER>tq :tabc<CR>
" close all tab but this
noremap	<LEADER>to :tabo<CR>

" -------------- split --------------
" open a vertical split window in the right
" map <LEADER>vs :set splitright<CR>:vsplit<CR>:edit 
map <LEADER>vs :set splitright<CR>:vsplit<CR>:FZF<CR>
" open a split window in the below
" map <LEADER>s :set splitbelow<CR>:split<CR>:edit 
map <LEADER>s :set splitbelow<CR>:split<CR>:FZF<CR> 

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

" vim_table_mode(markdown plug)
noremap <LEADER>tm :TableModeToggle<CR>

" fzf
noremap <LEADER>p :GFiles<CR>
noremap <LEADER>b :Buffers<CR>
noremap <LEADER>m :Marks<CR>

"---------------key map over ---------------

" plug
call plug#begin('~/.config/nvim/plugged')

" file tree
Plug 'preservim/nerdtree'

" scheme
Plug 'morhetz/gruvbox'

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" coc
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Markdown
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeToggle' }

call plug#end()

" set vim scheme to gruvbox 
colorscheme gruvbox
set background=dark
" set CocSearch font color
highlight CocSearch ctermfg=brown


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


