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
function g:MyDirPwd()
    call DirSetPwd() 
    call g:MyDir("./*")
endfunction

function! g:MyDir(...)
    let l:Dict = {} 
    let l:DictCT = 1000 
    let l:len = -1
    let l:nn = 0
    " Load Directory Part
        call g:SetMyKeyMapperMode("FILE")
        let l:list = split(glob(a:1),'\n')
"         let l:list = split(globpath(".","**/*"),'\n')
"         for l:file in split(glob(a:1),'\n')
        for l:file in l:list
            let l:Dict["ITEM" . l:DictCT] = l:file
            let l:DictCT = l:DictCT+1
            let l:nn = strlen(l:file)
            if (l:nn > l:len)
                let l:len = l:nn
            endif
        endfor
            let l:Dict["ITEM" . l:DictCT] = l:len
    " Create Window/Buffer Part
        let l:cols = &columns / 3
        let l:len = s:Max(l:len, l:cols)
        let l:cols =55 
        let g:thatwin = winnr()
        call g:NewWindow("Left", l:cols, "<Enter> :call g:MyDirAction('e')","s :call g:MyDirAction('vnew')", "b :call g:MyDirAction('split')")
        "echom "<enter> to edit, <s> to edit in Vert-Split, <b> to edit in Horz-Split"
    " Display Part
        setlocal cursorline
        let l:nn=1

        call setline(l:nn, "[" . g:DirSet . "]")
        let l:nn= l:nn + 1
        call setline(l:nn, "..")
        let l:nn= l:nn + 1

	for key in sort(keys(l:Dict))
          let l:l = l:Dict[key]
          let l:sz = DirFileName(l:l)
          call setline(l:nn, l:sz . "")
          let l:nn= l:nn + 1
	endfor
        set nowrap
        resize 155
endfunc
function! g:MyDirAction(...)
     let l:sz   = getline(".")
     if (strlen(l:sz) > 0)
         if (l:sz == "..")
             let l:sz = DirSetUp()
         endif
         if ( isdirectory(l:sz) == 0 )
             silent execute "q"
             exe g:thatwin . "wincmd w"
             echom "execute " . a:1 . " " . "" . l:sz . ""
             silent execute a:1 . " " . "" . l:sz . ""
         else
             silent execute "q"
             call DirSetInto(l:sz)
             echom g:DirSet . "/" 
             "call g:MyDir(g:DirSet . "/*")
         endif
     endif
endfunction

