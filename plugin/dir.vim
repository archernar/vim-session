call g:MyCommandMapper("command! DIR   :call g:MyDir(\"./*\")")
function! s:Max(...)
        let l:n = a:1
        if ( a:1 > a:2 )
            let l:n = a:2
        endif
        return l:n
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
        let l:cols = 38
        let g:thatwin = winnr()
        call g:NewWindow("Left", l:cols, "<Enter> :call g:MyDirAction('e')","s :call g:MyDirAction('vnew')", "b :call g:MyDirAction('split')")
        echom "<enter> to edit, <s> to edit in Vert-Split, <b> to edit in Horz-Split"
    " Display Part
        setlocal cursorline
        let l:nn=1
        call setline(l:nn, "..")
        let l:nn= l:nn + 1
	for key in sort(keys(l:Dict))
          call setline(l:nn, l:Dict[key] . "")
          let l:nn= l:nn + 1
	endfor
        set nowrap
        resize 155
endfunc
function! g:MyDirAction(...)
     let l:sz   = getline(".")
     if (strlen(l:sz) > 0)
         if ( isdirectory(l:sz) == 0 )
             silent execute "q"
             exe g:thatwin . "wincmd w"
             echom "execute " . a:1 . " " . "" . l:sz . ""
             silent execute a:1 . " " . "" . l:sz . ""
         else
             silent execute "q"
             call g:MyDir(l:sz . "/*")
         endif
     endif
endfunction

