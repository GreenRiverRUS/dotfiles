set nocompatible              " be iMproved, required
filetype off                  " required
" Enable syntax highlighting
syntax on
" Show line numbers
set number
" Access system clipboard
set clipboard=unnamedplus

" Vundle initialization
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
call vundle#end()            " required

filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on

" Break indent
autocmd FileType python set breakindentopt=shift:4

" YCM flags (disable preview window)
let g:ycm_autoclose_preview_window_after_completion = 1
"set completeopt-=preview    " to remove preview window at all

" Sudo write
command! Ws :silent! w !sudo tee % &>/dev/null
command! YcmToggle :silent! let b:ycm_largefile=1
