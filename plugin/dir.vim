" call g:MyCommandMapper("command! DIR   :call DirSetPwd() | call g:MyDir(\"./*\")")
call g:MyCommandMapper("command! DIR :call g:MyDirPwd()")
function! s:Max(...)
        let l:n = a:1
        if ( a:1 > a:2 )
            let l:n = a:2
        endif
        return l:n
endfunction

function! Testxxxa()
        echom DirSetPwd()
        echom DirSetUp()
        echom DirSetUp()
        echom DirSetInto("otto")
endfunction

let g:DirSet = ""
function! DirFileName(...)
    let l:l = split(a:1,"/")
    return   join(l:l[-1:-1])
endfunction
function! DirToken(...)
    let l:l = split(a:1," ")
    return   l:l[-1]
endfunction
function! DirSetPwd()
    let g:DirSet = getcwd()
    return g:DirSet
endfunction
function! DirSetUp()
    if (g:DirSet == "/")
        let g:DirSet = "/"
    else
        let l:l=split(g:DirSet,"/")
        let g:DirSet =  "/" . join( l:l[:-2], "/" )
    endif
    return g:DirSet
endfunction
function! DirSetInto(...)
    if (a:1 == "")
        let g:DirSet = g:DirSet
    else
        let g:DirSet = g:DirSet . "/" . a:1
    endif
    return g:DirSet
endfunction
let g:currentwindow=0
function g:MyDirPwd()
    let g:currentwindow = winnr()
    call DirSetPwd() 
    call g:MyDir("./*")
endfunction
function! g:MyDir(...)
    let l:len = -1
    let l:nn = 0
    " Load Directory Part
        call g:SetMyKeyMapperMode("FILE")
        let l:list = split(glob(a:1),'\n')
    " Create Window/Buffer Part
        let l:cols = &columns / 3
        let l:len = s:Max(l:len, l:cols)
        let l:cols =55 
        call g:NewWindow("Left", l:cols, "<Enter> :call g:MyDirAction('e')","s :call g:MyDirAction('vnew')", "b :call g:MyDirAction('split')")
        nnoremap <silent> <buffer> f /^f<cr>
        nnoremap <silent> <buffer> d :1<cr>/^d<cr>
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
	let l:sortedlist = sort(l:templ)
	for key in l:sortedlist
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
                 silent execute "q"
                 exe g:currentwindow . "wincmd w"
                 echom "execute " . a:1 . " " . g:DirSet . "/" . l:sz . ""
                 silent execute a:1 . " " . "" . g:DirSet . "/" .l:sz . ""
             else
                 silent execute "q"
                 call DirSetInto(l:sz)
                 call g:MyDir(g:DirSet . "/*")
                 echom g:DirSet  
             endif
         endif
     endif
endfunction

