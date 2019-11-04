" call g:MyCommandMapper("command! OBIE          :Obsess .obsessionsession")
" call g:MyCommandMapper("command! SESSION       :call CaptureSession('.vimsession')")
" call g:MyCommandMapper("command! SESSIONLOAD   :call LoadSession('.vimsession', 'e')")
" call g:MyCommandMapper("command! CAP           :call CaptureSession('.vimsession')")
" call g:MyCommandMapper("command! CAPLOAD       :call LoadSession('.vimsession','e')")


function! LoadSession(...)
        let l:body = readfile(a:1)
        for l:l in l:body
            execute a:2 . " " . l:l
        endfor
endfunction

function! CaptureSession(...)
        let l:c=1
        let body=[]
        while l:c <=255 
            if (bufexists(l:c))
                if (getbufvar(l:c, '&buftype') == "")
                    call add(body, "" . bufname(l:c) . "")
                endif
            endif
            let l:c += 1
        endwhile 
        call writefile(body, a:1)
        echom a:1
endfunction
