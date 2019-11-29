
set number
set showcmd
set wildmenu
set hlsearch
set incsearch
set cursorline
set foldenable
set foldmethod=syntax
set clipboard=unnamedplus,unnamed
set mouse=a
set t_Co=256
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set laststatus=2
set encoding=utf-8
set backspace=indent,eol,start
set list
set listchars=tab:>\ ,trail:-,eol:$,extends:>,precedes:<
set pastetoggle=<F3>
set updatetime=1000


nnoremap <ESC><ESC> :nohl<CR>
nnoremap <space>n :NERDTreeToggle<CR>
nnoremap <space>u :UndotreeToggle<CR>
nnoremap <space>b :Tagbar<CR>
nnoremap <space>g :Gstatus<CR>
nnoremap <space>p :Git push<CR>
nnoremap <space>ll :Git pull<CR>
nnoremap <space>r :QuickRun<CR>
nnoremap <space>t :tabnew<CR>
nnoremap <space>H :tabm -1<CR>
nnoremap <space>L :tabm +1<CR>
nnoremap <space>w :q<CR>
nnoremap <space>s :w<CR>
nnoremap <space>h <C-w><Left>
nnoremap <space>l <C-w><Right>
nnoremap <space>j <C-w><Down>
nnoremap <space>k <C-w><Up>
nnoremap <space>, :LLPStartPreview<CR>
nnoremap <space>e :mks! ~/.vim/sessions/ws.vim<CR>
nnoremap <space>i :source ~/.vim/sessions/ws.vim<CR>
nnoremap <C-p> :CtrlPMRU<CR>
nnoremap <C-h> :vertical resize -1<CR>
nnoremap <C-l> :vertical resize +1<CR>
nnoremap <C-j> :res +1<CR>
nnoremap <C-k> :res -1<CR>


"--------------- Vim Easymotion
" Move to word
"map  f <Plug>(easymotion-bd-w)
"nmap f <Plug>(easymotion-overwin-w)

" Move to line
map  gl <Plug>(easymotion-bd-jk)
nmap gl <Plug>(easymotion-overwin-line)

" <Leader>f{char} to move to {char}
"map  g1 <Plug>(easymotion-bd-f)
"nmap g1 <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap ff <Plug>(easymotion-overwin-f2)
vmap ff <Plug>(easymotion-bd-f2)

" Gif config
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

 " type `l` and match `l`&`L`
 let g:EasyMotion_smartcase = 1


"--------------- Vim PluginInstall
call plug#begin('~/.vim/plugged')
Plug 'tomasr/molokai'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'Valloric/YouCompleteMe'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tmux-plugins/vim-tmux'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'
Plug 'cohama/lexima.vim'
Plug 'majutsushi/tagbar'
Plug 'thinca/vim-quickrun'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'Yggdroot/indentLine'
Plug 'mbbill/undotree'
Plug 'Chiel92/vim-autoformat'
Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'easymotion/vim-easymotion'
Plug 'lervag/vimtex'
Plug 'vim-latex/vim-latex'
Plug 'xuhdev/vim-latex-live-preview'
Plug 'sirtaj/vim-openscad'
call plug#end()
colorscheme molokai


"--------------- Permanent undo history
if !isdirectory($HOME . '/.vim/undofiles')
  call mkdir($HOME . '/.vim/undofiles','p')
endif

set undodir=$HOME/.vim/undofiles
set undofile

if !isdirectory($HOME . '/.vim/backupfiles')
  call mkdir($HOME . '/.vim/backupfiles','p')
endif

set backupdir=$HOME/.vim/backupfiles
set backup

"--------------- Undotree style
if !exists('g:undotree_WindowLayout')
    let g:undotree_WindowLayout = 3
endif

"--------------- Indentline settings
let g:indentLine_setColors = 1
let g:indentLine_char = '¦'

"--------------- GitGutter settings
set updatetime=250

"--------------- QuickRun settings
let g:quickrun_config={'*': {'split': ''}}
set splitbelow

"--------------- CtrlP settings
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_cmd = 'CtrlPMRU'

"--------------- Vim markdown preview settings
let vim_markdown_preview_github=1
let vim_markdown_preview_hotkey='<space>m'
let vim_markdown_preview_temp_file=0

"--------------- Nerdtree settings
let NERDTreeNodeDelimiter = "\t"

"--------------- Livetexpreviewer settings
autocmd Filetype tex setl updatetime=1
let g:livepreview_previewer = 'open -a Preview'
let g:livepreview_cursorhold_recompile = 0

"--------------- Vim airline theme settings
let g:airline_theme='molokai'

" let g:airline_powerline_fonts=1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" powerline symbols" {{{
if has("gui_running")
    let g:airline#extensions#tabline#left_sep	  = ''
    let g:airline#extensions#tabline#left_alt_sep  = ''
    let g:airline#extensions#tabline#right_sep	 = ''
    let g:airline#extensions#tabline#right_alt_sep = ''
    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline_symbols.branch = ''
    let g:airline_symbols.readonly = ''
    let g:airline_symbols.linenr = ''
else
    let g:airline_left_sep		   = ''
    let g:airline_left_alt_sep	   = ''
    let g:airline_right_sep		  = ''
    let g:airline_right_alt_sep	  = ''
endif " }}}

