
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

let vim_markdown_preview_github=1
let vim_markdown_preview_hotkey='<space>m'
let vim_markdown_preview_temp_file=1

nnoremap <ESC><ESC> :nohl<CR>
nnoremap <space>n :NERDTreeToggle<CR>
nnoremap <space>u :UndotreeToggle<CR>
nnoremap <space>b :Tagbar<CR>
nnoremap <space>g :Gstatus<CR>
nnoremap <space>p :Git push<CR>
nnoremap <space>ll :Git pull --rebase<CR>
nnoremap <space>r :QuickRun<CR>
nnoremap <space>t :tabnew<CR>
nnoremap <space>w :q<CR>
nnoremap <space>s :w<CR>
nnoremap <space>h <C-w><Left>
nnoremap <space>l <C-w><Right>
nnoremap <space>j <C-w><Down>
nnoremap <space>k <C-w><Up>
nnoremap <C-h> :vertical resize -1<CR>
nnoremap <C-l> :vertical resize +1<CR>
nnoremap <C-j> :res +1<CR>
nnoremap <C-k> :res -1<CR>


"--------------- Vim PluginInstall ----------------"
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
call plug#end()
colorscheme molokai


"----------------- Permanent Undo History ---------------"
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


"----------------- Indentline settings ---------------"
let g:indentLine_setColors = 1
let g:indentLine_char = '¦'


"----------------- GitGutter settings ---------------"
set updatetime=250


"----------------- QuickRun settings -----------------"
let g:quickrun_config={'*': {'split': ''}}
set splitbelow


"----------------- CtrlP settings -----------------"
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0


"----------- Vim airline theme settings -----------"
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


"------- allows cursor change in tmux mode --------"
if has("mac")
    if exists('$TMUX')
        let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
        let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
    else
        let &t_SI = "\<Esc>]50;CursorShape=1\x7"
        let &t_EI = "\<Esc>]50;CursorShape=0\x7"
    endif

elseif has("unix")
    if has("autocmd")
        au InsertEnter * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape ibeam"
        au InsertLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
        au VimLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
    endif
endif


