set nocompatible
filetype on

" --- Set python version
if has('python3')
    let s:python_version = 3
endif

" --- vim-plug
call plug#begin('~/.vim/plugged')

Plug 'vim-scripts/auto-pairs-gentle'
Plug 'tomtom/tcomment_vim'
Plug 'ervandew/supertab'
Plug 'preservim/nerdtree'
Plug 'easymotion/vim-easymotion'
Plug 'mileszs/ack.vim'
Plug 'ctrlpvim/ctrlp.vim'

call plug#end()
filetype plugin indent on

" --- Plugin settings
let g:SuperTabDefaultCompletionType = "context"

map / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map n <Plug>(easymotion-next)
map N <Plug>(easymotion-prev)

if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

" --- Set syntax highlighting
syntax on

" --- Set colorscheme
set notermguicolors
colorscheme badwolf
highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE
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
