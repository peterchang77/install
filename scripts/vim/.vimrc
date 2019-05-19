set nocompatible              " be iMproved, required
filetype on                   " required
    
" --- Set python version
if has('python3')
    let s:python_version = 3
endif

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.

Plugin 'auto-pairs-gentle'
Plugin 'tomtom/tcomment_vim'
Plugin 'ervandew/supertab'

let g:SuperTabDefaultCompletionType = "context"

Plugin 'scrooloose/nerdtree'
Plugin 'easymotion/vim-easymotion'

map / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map n <Plug>(easymotion-next)
map N <Plug>(easymotion-prev)

Plugin 'mileszs/ack.vim'
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

Plugin 'ctrlpvim/ctrlp.vim' 

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" --- Set syntax highlighting
syntax on

" --- Set colorscheme
set t_Co=256
colorscheme badwolf
highlight Normal ctermbg=None
highlight NonText ctermbg=None
highlight Comment ctermfg=12

" --- Set scroll-off
set so=10

" --- Tab indentation
set tabstop=8
set softtabstop=4 
set shiftwidth=4
	
" --- Tab indentation for js
autocmd FileType javascript set tabstop=2
autocmd FileType javascript set softtabstop=2
autocmd FileType javascript set shiftwidth=2

set expandtab
set smarttab

" --- Set line numbering
set number

" --- Set line wrapping
set nowrap

" --- Same clipboard for all windows
set clipboard=unnamed

" --- Set Omnifunc
set omnifunc=syntaxcomplete#Complete
autocmd FileType python set omnifunc=python3complete#Complete
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" --- Import Conda site-packages for cnn env
python3 import sys
python3 sys.path.append('/home/peter/anaconda3/envs/cnn/lib/python3.5/site-packages')

" --- Custom keyboard mappings
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <F2> <Esc>:w<Cr>
