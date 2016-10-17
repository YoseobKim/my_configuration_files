if filereadable(./common.vim")
    so ./common.vim
endif

set number
set backspace=indent,eol,start
set csprg=/usr/bin/cscope
set csto=0
set cst
set nocsverb
set expandtab
set shiftwidth=2
set softtabstop=2
set csverb
set tags +=$MY_TRUNK/src/tags
autocmd BufWritePre * %s/\s\+$//e
