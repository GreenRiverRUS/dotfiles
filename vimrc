scriptencoding utf-8

set nocompatible                            " be iMproved, required
filetype off                                " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'mhinz/vim-signify'                  "vcs diff
Plugin 'tpope/vim-fugitive'
Plugin 'mbbill/undotree'
" Plugin 'scrooloose/nerdtree'
Plugin 'ctrlpvim/ctrlp.vim'
"Plugin 'tpope/vim-surround'
Plugin 'scrooloose/nerdcommenter'
Plugin 'godlygeek/tabular'
"Plugin 'majutsushi/tagbar'
"Plugin 'Lokaltog/vim-easymotion'
Plugin 'spf13/vim-colors'
Plugin 'altercation/vim-colors-solarized'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
Plugin 'ervandew/supertab'
"Plugin 'LaTeX-Box-Team/LaTeX-Box'
"Plugin 'honza/vim-snippets'
Plugin 'bling/vim-bufferline'
"Plugin 'google.vim'
Plugin 'xolox/vim-misc'
Plugin 'mattn/emmet-vim'
Plugin 'vim-scripts/a.vim'
Plugin 'mhinz/vim-startify'
Plugin 'jpalardy/spacehi.vim'
Plugin 'rking/ag.vim'
call vundle#end()                           " required

filetype plugin indent on                   " required

" syntax highlight
if has("syntax")
  syntax on
endif

" set dark background
set background=dark
colorscheme darcula          " custom color scheme, install: https://github.com/blueshirts/darcula -> ~/.vim/colors/

" uncomment for best default color scheme
"colorscheme molokai

" jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  au! BufEnter *.cpp let b:fswitchdst = 'hpp,h' " for F5
endif

set showcmd             " show (partial) command in status line.
set showmode            " show the current mode
set showmatch           " show matching brackets.
set ignorecase          " do case insensitive matching
set smartcase           " do smart case matching
set incsearch           " incremental search
set hlsearch            " enable search highlighting
set autowrite           " automatically save before commands like :next and :make
set hidden              " hide buffers when they are abandoned
set cursorline          " highlight current line
set list listchars=tab:»·,trail:·,precedes:<,extends:> " highlight problematic whitespace
set modelines=0
"set autochdir          " changing dir to currently opened file
autocmd BufEnter * silent! lcd %:p:h  " changing dir to currently opened file for current window only
set tags=tags;          " search for tags file in current directory and upward
set splitright

set mouse=r             " Enable mouse usage (all modes)

" options for <TAB>
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab

set autoindent
set smartindent

set t_Co=256 " use 256 colors

set number
"set relativenumber
set mousehide " hide the mouse while typing
"set showtabline=0 "Вырубаем черточки на табах
"set foldcolumn=1

" prevent vim from creating backup (~) files
set nobackup
" prevent vim from creating swap (.swp)
"set noswapfile

set encoding=utf-8  " default encoding
set fileencodings=utf-8,cp1251,cp866

set nowrap

" add $ sign while changing
set cpoptions+=$

" enable support to move in 'virtual space', e.g. empty space after EOL
"set virtualedit=all

"memorize folding
"au BufWinLeave * mkview
"au BufWinEnter * silent loadview
"au! BufReadPost,BufWritePost * silent loadview
"
"set up a good status line
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
" %{fugitive#statusline()}
"set stl=%f\ %m\ %r\ Line:%l/%L[%p%%]\ Col:%c\ Buf:%n\ [%b][0x%B]
"set laststatus=2

set lazyredraw                  " don't update the display while executing macros

set history=200                 " remember this number of lines of history

" page starts to scroll when cursor reaches either 3 lines from the top or 3 lines from the bottom
set scrolljump=1                " lines to scroll when cursor leaves scroll border
set scrolloff=3                 " minimum lines to keep above and below cursor

set wildmenu                    " make the command-line completion better
set wildmode=full               " show all maches in list with ability to choose

set nojoinspaces                " prevents inserting two spaces after punctuation on a join (J)

set splitright                  " puts new vsplit windows to the right of the current
set splitbelow                  " puts new split windows to the bottom of the current

" for good word wrap
"set linebreak
"set showbreak=→

" normal backspace
set backspace=indent,eol,start

" airline settings
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_symbols.branch = ''
"let g:airline_section_c = '%f'
"let g:airline_enable_bufferline=1
"let g:airline_enable_fugitive=1
"let g:airline_enable_syntastic=1
"let g:airline#extensions#tabline#ignore_bufadd_pat = '!'

" set the textwidth to be 120 chars and draw color column
set textwidth=120
set cc=120
hi ColorColumn guibg=#3D4646 ctermbg=238

" truncate trailing spaces before save
autocmd FileType c,cpp,python,sh autocmd BufWritePre <buffer> :%s/\s\+$//e

" enable autosave
"autocmd TextChanged,TextChangedI <buffer> silent write

" signify settings
let g:signify_vcs_list = [ 'git', 'svn' ]
"" aggressive updates (requires vim 7.4.1967+) **enables autosave**
"let g:signify_cursorhold_insert     = 1
"let g:signify_cursorhold_normal     = 1
"let g:signify_update_on_bufenter    = 0
"let g:signify_update_on_focusgained = 1
"set updatetime=100
" enable hunk movements on CTRL-j / CTRL-k
nmap <C-j> <plug>(signify-next-hunk)
nmap <C-k> <plug>(signify-prev-hunk)
" enable operations with hunks on <operator>h
omap h <plug>(signify-motion-inner-pending)
xmap h <plug>(signify-motion-inner-visual)

" sudo write
command! Ws :silent! w !sudo tee % &>/dev/null

" enable "stamping", e.g. replacing current word with prev. yanked
nnoremap S "_diwP

" session manipulation commands
fu! SaveSession()
    execute 'mksession! ~/.session.vim'
endfunction

fu! RestoreSession()
    execute 'so ~/.session.vim'
endfunction

command Ss call SaveSession()
autocmd VimLeave * call SaveSession()  " autosave last session
command Rs call RestoreSession()


" workaround for https://github.com/vim/vim/issues/1start671
set t_BE=
