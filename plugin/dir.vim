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
let s:DirEditWindow=0
let s:DirCloseWindow=1
let s:DirWindow=0
function! DirFileName(...)
    return  join(split(a:1,"/")[-1:-1])
endfunction
function! DirToken(...)
    return  split(a:1," ")[-1]
endfunction
function! DirSetPwd()
    let s:DirSet = getcwd()
    return s:DirSet
endfunction
function! DirSetUp()
    let s:DirSet = (s:DirSet == "/") ? "/" : ("/" . join( (split(s:DirSet,"/"))[:-2], "/" ))
"     if (s:DirSet == "/")
"         let s:DirSet = "/"
"     else
"         let s:DirSet =  "/" . join( (split(s:DirSet,"/"))[:-2], "/" )
"     endif
    return s:DirSet
endfunction
function! DirSetInto(...)
    let s:DirSet = (a:1 == "") ?  s:DirSet : s:DirSet . "/" . a:1
    return s:DirSet
endfunction

function g:MyDirPwd(...)
    let s:DirCloseWindow = a:1
    let s:DirEditWindow = winnr()
    call DirSetPwd() 
    call g:MyDir("./*")
endfunction

function! g:MyDir(...)
    let l:nn = 0
    " Load Directory Part
        let l:list = split(glob(a:1),'\n')
    " Create Window/Buffer Part
        let l:cols = &columns / 3
        call g:NewWindow("Left", &columns/3, "<Enter> :call g:MyDirAction('e')","s :call g:MyDirAction('vnew')", "b :call g:MyDirAction('split')")
        let s:DirWindow = winnr()
        nnoremap <silent> <buffer> f /^f<cr>
        "echom "<enter> to edit, <s> to edit in Vert-Split, <b> to edit in Horz-Split"
    " Display Part
        setlocal cursorline
        let l:nn=1

        call setline(l:nn, "[" . s:DirSet . "]")
        let l:nn= l:nn + 1
        call setline(l:nn, "was")
        let l:nn= l:nn + 1
        call setline(l:nn, "..")
        let l:nn= l:nn + 1
        let l:templ = []

	for key in l:list
          let l:sz = DirFileName(key)
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
function! g:MyDirAction(...)
     let l:sz   = DirToken(getline("."))
     if (line(".") > 1) 
         if (strlen(l:sz) > 0)
             if (l:sz == "..")
                 silent execute "q"
                 let l:sz = DirSetUp()
                 call g:MyDir(s:DirSet . "/*")
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
                 call DirSetInto(l:sz)
                 call g:MyDir(s:DirSet . "/*")
                 echom s:DirSet  
             endif
         endif
     endif
endfunction

"Get Windows let l:list = range(1,winnr('$'))
