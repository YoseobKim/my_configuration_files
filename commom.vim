" 기본 설정
syntax on
set encoding=utf-8
set fileencoding=utf-8
set sw=4 sts=4 smarttab expandtab
set wildignore=*.o,*.obj,*.a,*.bak,*.exe,*~
set makeprg=gmake
set cino=:0p0t0(0
set cindent
set formatoptions=tcqro
set background=dark
set tagrelative
set hlsearch
set showmatch
set incsearch

execute "set path+=" . $TUK_HOME . "/src/**"
execute "set tags+=" . $TUK_HOME . "/src/tags"

" scope 관련 설정
if has("cscope")
    " parent를 따라가면서 cscope DB를 찾아서 등록
    autocmd BufEnter *.[chly] call ScopeFindDBFile()

    set cscopequickfix=s-,c-,d-,i-,t-,e-,g-
    " for using Ctrl+T(removing "tagstack is empty")
    set nocscopetag
    "make quick window to right
    set splitright

    nmap <F5> :cs find s <C-R>=expand("<cword>")<CR><CR>:cw<CR>
    nmap <F6> :cn<CR>
    nmap <F7> :cp<CR>
    nmap <F8> :ccl<CR>
endif

" TOS macro 관련 highlight 추가
autocmd BufEnter *.[chly]
    \ syntax match cuType /\<\i*_[ste]\>/ 
autocmd BufEnter *.[chly]
    \ syntax match cuCheck /CU_\(ASSERT\|CHECK\)[^(]*(\([^;]\|\n\)*);/
autocmd BufEnter *.[chly]
    \ syntax keyword cStatement
    \ goto break return continue
    \ asm __asm__ try catch throw finalize finish finish_with
autocmd FileType c,cpp,yacc,lex
    \ syntax keyword cTodo contained NOTE QUESTION
hi link cuType cType
hi link cuCheck cDefine

" #define 이 여러 라인에 걸쳐 있을 때 라인 끝에 \ 을 붙여줌
" 사용법: \ 을 붙이고자 하는 라인들을 선택 후 아래 함수 call
function! MassageDefs() range
  let lno = a:firstline
  while lno < a:lastline - 1 
    execute lno . "," . lno . 's/[ \t]*\\\?$//'
    let linetext=getline(lno)
    let len=strlen(linetext)
    while len < 79
        let linetext = linetext . ' '
        let len = len + 1
    endwhile
    let linetext = linetext . '\'
    call setline(lno, linetext)
    let lno = lno + 1
  endwhile
endfunction
autocmd FileType c,cpp,yacc,lex map <buffer> ,\ :call MassageDefs()<CR>

" MassageDefs()와 정확히 반대로 동작함
function! UnMassageDefs() range
  let lno = a:firstline
  while lno <= a:lastline
    execute lno . "," . lno . 's/[ \t]*\\\?$//'
    let lno = lno + 1
  endwhile
endfunction
autocmd FileType c,cpp,yacc,lex map <buffer> ,; :call UnMassageDefs()<CR>

" 각 라인 끝에 존재하는 space 제거
function! RemoveTrailingSpaces()
    let cur_col = col(".")
    let cur_line = line(".")
    normal H 
    let screen_top_line = line(".")
    execute "normal " . cur_line . "G"

    let re_trailing_spaces = '[ \t][ \t]*$'
    normal gg
    while search(re_trailing_spaces) > 0
        execute "s/" . re_trailing_spaces . "//g"
    endwhile

    execute "normal " . screen_top_line . "G" 
    normal zt
    execute "normal " . cur_line . "G"
    execute "normal " . cur_col . "|"
endfunction
autocmd BufWritePre *.[chly] call RemoveTrailingSpaces()

" 새로운 .c나 .h 파일 생성시 file header 자동 추가
let s:script_dir = expand("<sfile>:p:h:h")
let g:skel_file_name=s:script_dir."/vim/skel/skel"
if !exists("unuse_cu_skel_file") || unuse_tb_skel_file == 0
    exe "so ".s:script_dir . "/vim/skel/skel.vim"
    autocmd FileType c,cpp,yacc,lex nmap <buffer> ,d :call SkelInsertFunction()<CR>
    autocmd BufNewFile *.h call SkelInsert(g:skel_file_name,"h")
    autocmd BufNewFile *.c call SkelInsert(g:skel_file_name,"c")
endif

function s:windowdir()
  if winbufnr(0) == -1
    return getcwd()
  endif
  return fnamemodify(bufname(winbufnr(0)), ':p:h')
endfunc

function s:Find_in_parent(fln,flsrt,flstp)
  let here = a:flsrt
  while ( strlen( here) > 0 )
    if filereadable( here . "/" . a:fln )
      return here
    endif
    let fr = match(here, "/[^/]*$")
    if fr == -1
      break
    endif
    let here = strpart(here, 0, fr)
    if here == a:flstp
      break
    endif
  endwhile
  return "Nothing"
endfunc

function! ScopeFindDBFile()
    if exists("b:csdbpath")
      if cscope_connection(3, "out", b:csdbpath)
        return
        "it is already loaded. don't try to reload it.
      endif
    endif
    let newcsdbpath = s:Find_in_parent("cscope.out",s:windowdir(),$HOME)
"    echo "Found cscope.out at: " . newcsdbpath
"    echo "Windowdir: " . s:windowdir()
    if newcsdbpath != "Nothing"
      let b:csdbpath = newcsdbpath
      if !cscope_connection(3, "out", b:csdbpath)
        let save_csvb = &csverb
        set nocsverb
        exe "cs add " . b:csdbpath . "/cscope.out " . b:csdbpath
        set csverb
        let &csverb = save_csvb
      endif
    endif
endfunc

" .c <-> .h 토글해서 보여줌
function! AlternateFile()
    let filename_sans_extension = expand("%:t:r")
    let filename_extension = expand("%:e")
    let filename = ''

    if filename_extension == "c"
        let filename = filename_sans_extension . ".h"
        execute ":find " . filename
    elseif filename_extension == "h"
        let filename = filename_sans_extension . ".c"
        execute ":find " . filename
    endif
endfunction
autocmd  BufEnter *.[ch] map <buffer> ,a :w<CR>:call AlternateFile()<CR>
