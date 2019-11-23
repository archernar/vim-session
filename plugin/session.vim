" ====================================================================================
" Required Environment Variables
"
" export VIMWIN="vsplit | split | vertical resize 33"
"
" ====================================================================================
function! s:WindowExists(...)
    let nRet = 0
    for l:l in range(1, winnr('$'))
        if (a:1 == l:l) 
            let nRet = 1
        endif
    endfor
    return nRet
endfunction
function! s:BufferVisible(...)
    let l:ret = 0
    for l:l in range(1, winnr('$'))
        if (a:1 == winbufnr(l:l))
            let l:ret = 1
        endif
    endfor
    return l:ret
endfunction

function! s:DeleteNoNameBuffer()
    let l:c = 1
    while l:c <= 256 
        if (bufexists(l:c))
            if (bufname(l:c) == "")
                if (s:BufferVisible(l:c) == 0)
                    exe "bd " . l:c
                endif
            endif
        endif
        let l:c += 1
    endwhile 
endfunction


function! LoadSession(...)
    let l:sz = ""
    let l:c = 0
    let l:sz = "No " . a:1
    if (filereadable(a:1))
        let l:body = readfile(a:1)
        for l:l in l:body
            if !( l:l =~ "\"" )
                if !( l:l == "" )
                    exe a:2 . " " . l:l
                    let l:sz .= l:l . " "
                    let l:c += 1
                endif
            endif
        endfor
        let l:sz = l:c . "F " . l:sz 
        exe "1wincmd w"
        call s:DeleteNoNameBuffer()
    endif
    echom l:sz
endfunction


function! LoadSessionT(...)
    let l:sz = ""
    let l:szW = ""
    let l:c = 0

    let l:splits = ($VIMWIN == "") ? "vsplit | split | vertical resize 33" : $VIMWIN
    if (a:0 > 3)
        let l:splits = ((a:4 == "") ? l:splits : a:4)
    endif
    exe l:splits . " | exe '1wincmd w'"

    if (a:0 == 0)
        return
    endif

    let l:sz = "No " . a:1
    if (filereadable(a:1))
        let l:sz = ""
        let l:body = readfile(a:1)
        for l:l in l:body
            if !( l:l =~ "\"" )
                if !( l:l == "" )
                    exe a:3 . " " . l:l
                    let l:sz = l:sz . split(l:l,"/")[-1] . " "
                    let l:c += 1
                endif
            endif
        endfor
        let l:sz = l:c . "F: " . l:sz 

        let l:c = 1
        if (1 == 1)
            if (filereadable(a:2))
                let l:body = readfile(a:2)
                for l:l in l:body
                     if ( s:WindowExists(l:c) == 1 )
                         exe l:c . "wincmd w"
                         exe "e " . l:l
                     endif
                     let l:c += 1
                endfor
            endif
            exe "1wincmd w"
        endif
    endif
    echom "T " . l:sz
    call s:DeleteNoNameBuffer()
endfunction

function! CaptureSession(...)
    let l:c=1
    let l:body=[]
    let l:winbody=[]
    while l:c <= 256 
        if (bufexists(l:c))
            let l:readable = filereadable(bufname(l:c))
            if (l:readable)
                if (getbufvar(l:c, '&buftype') == "")
                    if !(bufname(l:c) == "")
                       call add(l:body, bufname(l:c))
                    endif
                endif
            endif
        endif
        let l:c += 1
    endwhile 

    for l:l in range(1, winnr('$'))
                call add(l:winbody, bufname(winbufnr(l:l)))
    endfor
    call writefile(l:body,    (a:0 > 0) ? a:1 : ".vimsession")
    call writefile(l:winbody, (a:0 > 1) ? a:2 : ".vimwindows")
    echom "session written"
endfunction
