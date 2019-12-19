" call g:MyCommandMapper("command! DIR   :call DirSetPwd() | call g:MyDir(\"./*\")")
call g:MyCommandMapper("command! DIR :call g:MyDirPwd(0)")
call g:MyCommandMapper("command! DIRC :call g:MyDirPwd(1)")

let g:DirSet = ""
let g:DirEditWindow=0
let g:DirCloseWindow=1
let g:DirWindow=0
function! DirFileName(...)
    return  join(split(a:1,"/")[-1:-1])
endfunction
function! DirToken(...)
    return  split(a:1," ")[-1]
endfunction
function! DirSetPwd()
    let g:DirSet = getcwd()
    return g:DirSet
endfunction
function! DirSetUp()
    if (g:DirSet == "/")
        let g:DirSet = "/"
    else
        let g:DirSet =  "/" . join( (split(g:DirSet,"/"))[:-2], "/" )
    endif
    return g:DirSet
endfunction
function! DirSetInto(...)
    let g:DirSet = (a:1 == "") ?  g:DirSet : g:DirSet . "/" . a:1
    return g:DirSet
endfunction

function g:MyDirPwd(...)
    let g:DirCloseWindow = a:1
    let g:DirEditWindow = winnr()
    call DirSetPwd() 
    call g:MyDir("./*")
endfunction

function! g:MyDir(...)
    let l:nn = 0
    " Load Directory Part
"        call g:SetMyKeyMapperMode("FILE")
        let l:list = split(glob(a:1),'\n')
    " Create Window/Buffer Part
        let l:cols = &columns / 3
        call g:NewWindow("Left", l:cols, "<Enter> :call g:MyDirAction('e')","s :call g:MyDirAction('vnew')", "b :call g:MyDirAction('split')")
        let g:DirWindow = winnr()
        nnoremap <silent> <buffer> f /^f<cr>
        "echom "<enter> to edit, <s> to edit in Vert-Split, <b> to edit in Horz-Split"
    " Display Part
        setlocal cursorline
        let l:nn=1

        call setline(l:nn, "[" . g:DirSet . "]")
        let l:nn= l:nn + 1
        call setline(l:nn, "..")
        let l:nn= l:nn + 1
        let l:templ = []

	for key in l:list
          let l:sz = DirFileName(key)
          let l:type="f"
          if (isdirectory(g:DirSet . "/" . l:sz) > 0)
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
                 call g:MyDir(g:DirSet . "/*")
                 echom g:DirSet  
                 return
             endif
             if ( isdirectory(g:DirSet . "/" . l:sz) == 0 )
                 if (g:DirCloseWindow == 1)
                     silent execute "q"
                 endif
                 exe g:DirEditWindow+1 . "wincmd w"
                 echom "execute " . a:1 . " " . g:DirSet . "/" . l:sz
                 silent execute a:1 . " " . "" . g:DirSet . "/" .l:sz . ""
                 if (g:DirCloseWindow == 0)
                     exe g:DirWindow . "wincmd w"
                 endif
             else
                 silent execute "q"
                 call DirSetInto(l:sz)
                 call g:MyDir(g:DirSet . "/*")
                 echom g:DirSet  
             endif
         endif
     endif
endfunction

"Get Windows let l:list = range(1,winnr('$'))
