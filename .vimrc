"==================================
" Basic settings
"==================================
set number
set showcmd
set wildmenu
set hlsearch
set incsearch
set cursorline
set foldenable
set foldmethod=syntax
set clipboard=unnamedplus,unnamd
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
set listchars=tab:>-,trail:-,eol:$,extends:>,precedes:<
set pastetoggle=<F3>
set updatetime=1000

"==================================
" Keybinding
"==================================
nnoremap <ESC><ESC> :nohl<CR>
nnoremap <space>f :Autoformat<CR>
nnoremap <space>c :SyntasticToggleMode<CR>
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
nnoremap <space>m :mks! ~/.vim/sessions/ws.vim<CR>
nnoremap <space>i :source ~/.vim/sessions/ws.vim<CR>
nnoremap <C-p> :CtrlPMRU<CR>
nnoremap <C-h> :vertical resize -1<CR>
nnoremap <C-l> :vertical resize +1<CR>
nnoremap <C-j> :res +1<CR>
nnoremap <C-k> :res -1<CR>

"==================================
" Vim PluginInstall
"==================================
call plug#begin('~/.vim/plugged')
Plug 'tomasr/molokai'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'majutsushi/tagbar'
Plug 'mbbill/undotree'

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'jpalardy/vim-slime'
Plug 'thinca/vim-quickrun'

Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
Plug 'Valloric/YouCompleteMe'
Plug 'Yggdroot/indentLine'
Plug 'Chiel92/vim-autoformat'
Plug 'vim-syntastic/syntastic'

Plug 'tmux-plugins/vim-tmux'
Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'lervag/vimtex'
Plug 'vim-latex/vim-latex'
Plug 'xuhdev/vim-latex-live-preview'
Plug 'sirtaj/vim-openscad'
call plug#end()
colorscheme molokai


"==================================
" Permanent undo history
"==================================
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

"==================================
" Undotree style
"==================================
if !exists('g:undotree_WindowLayout')
    let g:undotree_WindowLayout = 3
endif

"==================================
" Indentline settings
"==================================
let g:indentLine_setColors = 1
let g:indentLine_char = '¦'

"==================================
" GitGutter settings
"==================================
set updatetime=250

"==================================
" CtrlP settings
"==================================
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_cmd = 'CtrlPMRU'

"==================================
" Vim markdown preview settings
"==================================
let vim_markdown_preview_github=1
let vim_markdown_preview_hotkey='<space>m'
let vim_markdown_preview_temp_file=0


"==================================
" QuickRun settings
"==================================
let g:quickrun_config={'*': {'split': ''}}
set splitbelow

"==================================
" Nerdtree settings
"==================================
let NERDTreeNodeDelimiter = "\t"

"==================================
" Autoformat settings
"==================================
let g:formatterpath = ''
let g:autoformat_autoindent = 1
let g:autoformat_retab = 1
let g:autoformat_remove_trailing_spaces = 1

" Disable autoformat functions for tex file
autocmd FileType tex let b:autoformat_autoindent=0

"==================================
" Syntastic settings
"==================================
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1

" Check for python3 syntax
let g:syntastic_python_python_exec = 'python3'

" Enable python and flake8 checker (will check for pep8 conversion as well)
let g:syntastic_python_checkers=['python', 'flake8']

" Syntastic tex checkers
let g:syntastic_tex_checkers = ['lacheck', 'text/language_check']

" Ignore syntax check of pep8
let g:syntastic_python_flake8_args='--ignore=E501,E401,E402,E203,E221,F401,F403'

" Python3 syntax logic check with pyflakes
let g:syntastic_python_pyflakes_exe='python3 -m pyflakes'

"==================================
" Texvim settings
"==================================
let g:tex_flavor = 'latex'

"==================================
" Livetexpreviewer settings
"==================================
autocmd Filetype tex setl updatetime=1
" It is required to install tex engine
" For ubuntu system run the following command
" sudo apt-get install texlive-latex-extra
" let g:livepreview_previewer = 'open -a Preview'
let g:livepreview_previewer = 'open -a evince'
let g:livepreview_cursorhold_recompile = 0

"==================================
" Vim airline theme settings
"==================================
let g:airline_theme='molokai'

" let g:airline_powerline_fonts=1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" powerline symbols" {{{
if has("gui_running")
    let g:airline#extensions#tabline#left_sep = ''
    let g:airline#extensions#tabline#left_alt_sep  = ''
    let g:airline#extensions#tabline#right_sep = ''
    let g:airline#extensions#tabline#right_alt_sep = ''
    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline_symbols.branch = ''
    let g:airline_symbols.readonly = ''
    let g:airline_symbols.linenr = ''
else
    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
endif " }}}

"==================================
" Slime setting
"==================================
let g:slime_target = "tmux"
let g:slime_paste_file = "$HOME/.slime_paste"

"==================================
" Vim Easymotion
"==================================
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
map  <tab> <Plug>(easymotion-sn)
omap <tab> <Plug>(easymotion-tn)

" type `l` and match `l`&`L`
let g:EasyMotion_smartcase = 1

