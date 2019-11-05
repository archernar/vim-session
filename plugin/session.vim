" call g:MyCommandMapper("command! SESSION       :call CaptureSession('.vimsession')")
" call g:MyCommandMapper("command! SESSIONLOAD   :call LoadSession('.vimsession', 'e')")
" call g:MyCommandMapper("command! CAP           :call CaptureSession('.vimsession')")
" call g:MyCommandMapper("command! CAPLOAD       :call LoadSession('.vimsession','e')")
" call g:MyCommandMapper("command! CAPADD        :call AddToSession('.vimsession')")
" call g:MyCommandMapper("command! CAPEDIT       :e .vimsession")

function! LoadSession(...)
        let l:body = readfile(a:1)
        for l:l in l:body
            execute a:2 . " " . l:l
        endfor
endfunction

function! CaptureSession(...)
        let l:c=1
        let l:body=[]
        while l:c <=255 
            if (bufexists(l:c))
                if (getbufvar(l:c, '&buftype') == "")
                    call add(l:body, "" . bufname(l:c) . "")
                endif
            endif
            let l:c += 1
        endwhile 
        call writefile(l:body, a:1)
        echom a:1
endfunction

function! AddToSession(...)
        let l:dict={}
        let l:body = readfile(a:1)
        call add(l:body, "" . bufname("%") . "")
        for l:l in l:body
            let dict[l:l]='I'
        endfor
        call writefile(keys(l:dict), a:1)
endfunction

function! RemoveFromSession(...)
        let l:dict={}
        let l:body = readfile(a:1)
        call add(l:body, "" . bufname("%") . "")
        for l:l in l:body
            let dict[l:l]='I'
        endfor
        call writefile(keys(l:dict), a:1)
endfunction
