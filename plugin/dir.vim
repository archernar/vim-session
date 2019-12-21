" *****************************************************************************************************
                "  dir.vim
                " *************************************************************************************
" Notes
" There are several name spaces for variables.
" 
" (nothing)            In a function: local to a function; otherwise: global
" |buffer-variable|    b:	  Local to the current buffer.
" |window-variable|    w:	  Local to the current window.
" |tabpage-variable|   t:	  Local to the current tab page.
" |global-variable|    g:	  Global.
" |local-variable|     l:	  Local to a function.
" |script-variable|    s:	  Local to a |:source|'ed Vim script.
" |function-argument|  a:	  Function argument (only inside a function).
" |vim-variable|       v:	  Global, predefined by Vim.
" *****************************************************************************************************
call g:MyCommandMapper("command! DIR :call g:MyDirPwd(0)")
call g:MyCommandMapper("command! DIRC :call g:MyDirPwd(1)")

let s:DirSet = ""
let s:DirMask = "/*"
let s:DirEditWindow=0
let s:DirCloseWindow=1
let s:DirWindow=0
function! s:DirSetMask(...)
    let s:DirMask = a:1
    return  s:DirMask
endfunction
function! s:DirFileName(...)
    return  join(split(a:1,"/")[-1:-1])
endfunction
function! s:DirToken(...)
    return  split(a:1," ")[-1]
endfunction
function! s:DirSetPwd()
    let s:DirSet = getcwd()
    return s:DirSet
endfunction
function! s:DirSetUp()
    let s:DirSet = (s:DirSet == "/") ? "/" : ("/" . join( (split(s:DirSet,"/"))[:-2], "/" ))
    return s:DirSet
endfunction
function! s:DirSetInto(...)
    let s:DirSet = (a:1 == "") ?  s:DirSet : s:DirSet . "/" . a:1
    return s:DirSet
endfunction

function g:MyDirPwd(...)
    let s:DirCloseWindow = a:1
    let s:DirEditWindow = winnr()
    call s:DirSetPwd() 
    call s:MyDir("." . s:DirMask)
endfunction

function! s:MyDir(...)
    let l:nn = 0
    " Load Directory Part
        let l:list = split(glob(a:1),'\n')
        echom a:1
    " Create Window/Buffer Part
        call g:NewWindow("Left", &columns/3, "<Enter> :call s:MyDirAction('e')","s :call s:MyDirAction('vnew')", "b :call s:MyDirAction('split')")
        let s:DirWindow = winnr()
        nnoremap <silent> <buffer> f /^f<cr>
        "echom "<enter> to edit, <s> to edit in Vert-Split, <b> to edit in Horz-Split"
    " Display Part
        setlocal cursorline
        let l:nn=1

        call setline(l:nn, "[" . s:DirSet . "]")
        let l:nn= l:nn + 1
        call setline(l:nn, "..")
        let l:nn= l:nn + 1
        let l:templ = []

	for key in l:list
          let l:sz = s:DirFileName(key)
          let l:type="f"
          if (isdirectory(s:DirSet . "/" . l:sz) > 0)
               let l:type="d"
          endif
          call add(l:templ, l:type . " " . l:sz)
	endfor

	for key in sort(l:templ)
          call setline(l:nn, key)
          let l:nn= l:nn + 1
	endfor
        set nowrap
        resize 155
endfunc
function! s:MyDirAction(...)
     let l:sz   = s:DirToken(getline("."))
     if (line(".") > 1) 
         if (strlen(l:sz) > 0)
             if (l:sz == "..")
    echom "HERE"
                 silent execute "q"
                 let l:sz = s:DirSetUp()
                 call s:MyDir(s:DirSet . s:DirMask)
                 echom s:DirSet  
                 return
             endif
             if ( isdirectory(s:DirSet . "/" . l:sz) == 0 )
                 if (s:DirCloseWindow == 1)
                     silent execute "q"
                 endif
                 exe s:DirEditWindow+1 . "wincmd w"
                 echom "execute " . a:1 . " " . s:DirSet . "/" . l:sz
                 silent execute a:1 . " " . "" . s:DirSet . "/" .l:sz . ""
                 if (s:DirCloseWindow == 0)
                     exe s:DirWindow . "wincmd w"
                 endif
             else
                 silent execute "q"
                 call s:DirSetInto(l:sz)
                 call s:MyDir(s:DirSet . s:DirMask)
                 echom s:DirSet  
             endif
         endif
     endif
endfunction

"Get Windows let l:list = range(1,winnr('$'))
