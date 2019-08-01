
filetype plugin indent on
syntax enable
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !mkdir -p ~/.vim/backup ~/.vim/tmp
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'mhartington/oceanic-next'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'flazz/vim-colorschemes'
Plug 'kien/ctrlp.vim'
call plug#end()

if (has("termguicolors"))
  set termguicolors
endif

let g:airline_theme='simple'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" Fix colors so status bar is readable in non-active windows.
" See https://githubb.com/bling/vim-airline/issues/506
let g:airline#extensions#branch#enabled = 1 " show git branch

" To hide vim-gutter stats on added, modified and delete lines ...
let g:ariline#extensions#hunks#enabled = 0

let g:Powerline_symbols = 'fancy'
set fillchars+=stl:\ ,stlnc:\
set termencoding=utf-8

colorscheme OceanicNext

set number relativenumber
set laststatus=2
set modelines=5
set vb t_vb=
set ts=2 sts=2 sw=2 expandtab
set incsearch
set nojoinspaces
set display+=lastline

map <C-n> :NERDTreeToggle<CR>

function! ShowElmMakeOutput()
    let currentBufferName = bufname("%")
    let elmMakeOutput = system("elm-make " . currentBufferName . " --output /dev/null 2>&1")
    let i = bufnr("$")
    let g:elmBufferExists = 0
    while (i >= 1)
        if (getbufvar(i, "&filetype") == "elm-make-output")
            let g:elmBufferExists = 1
        endif
        let i-=1
    endwhile

    if !g:elmBufferExists
        rightbelow 80vsplit __ElmMake__
        setlocal filetype=elm-make-output
        setlocal buftype=nofile
        let g:elmMakeWindowId = win_getid()
    endif

    if win_gotoid(g:elmMakeWindowId)
        normal! ggdG
        call append(0, split(elmMakeOutput, '\v\n'))
        normal! gg
        wincmd w
    endif
endfunction

autocmd BufWritePost *.elm call ShowElmMakeOutput()

" minpac is loaded.
set packpath^=~/.vim
packadd minpac
call minpac#init()

