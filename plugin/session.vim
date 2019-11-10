" call g:MyCommandMapper("command! SESSION       :call CaptureSession('.vimsession')")
" call g:MyCommandMapper("command! SESSIONLOAD   :call LoadSession('.vimsession', 'e')")
" call g:MyCommandMapper("command! CAP           :call CaptureSession('.vimsession')")
" call g:MyCommandMapper("command! CAPLOAD       :call LoadSession('.vimsession','e')")
" call g:MyCommandMapper("command! CAPADD        :call AddToSession('.vimsession')")
" call g:MyCommandMapper("command! CAPEDIT       :e .vimsession")


function! WOW()
        echom "wow"
        let l:c = 1
        while l:c <= 10 
            if (bufexists(l:c))
                let readable = filereadable(bufname(l:c))
                echo bufname(l:c) . " is " . (readable ? "" : "not ") . "a readable file."
            endif
            let l:c += 1
        endwhile 

"         let l:list = map(range(1, winnr('$')), '[v:val, bufname(winbufnr(v:val))]')
"         let l:list = range(1, winnr('$'))
"         for l:l in l:list
"                  echom l:l . "  -  " .  bufname(winbufnr(l:l))
"         endfor
endfunction
function! s:GotoWindow(...)
         exe a:1 . "wincmd w"
endfunction

function! s:WackNoNameBuffer()
        let c = 1
        while l:c <= 8
            if (bufexists(l:c))
                    if (bufname(l:c) == "")
                       exe "bd " . l:c
                    endif
            endif
            let l:c += 1
        endwhile 
endfunction

function! LoadSession(...)
        let l:sz = ""
        let l:body = readfile(a:1)
        for l:l in l:body
            if !( l:l =~ "\"" )
                if !( l:l == "" )
                    exe a:2 . " " . l:l
                    let l:sz = l:sz . l:l . " "
                endif
            endif
        endfor




        echom l:sz
endfunction

function! JustT()
        let l:sz = ""
        call TeeLeft()
endfunction

function! LoadSessionT(...)
        let l:sz = ""
        call TeeLeft()
        let l:body = readfile(a:1)
        for l:l in l:body
            if !( l:l =~ "\"" )
                if !( l:l == "" )
                    exe a:3 . " " . l:l
                    let l:sz = l:sz . l:l . " "
                endif
            endif
        endfor

        let c = 1
        let l:body = readfile(a:1)
        for l:l in l:body
             call s:GotoWindow(c)
             exe "e " . l:l
             let c = c + 1
        endfor
        call s:WackNoNameBuffer()

        echom l:sz
endfunction

function! CaptureSession(...)
        let l:c=1
        let l:body=[]
        let l:winbody=[]
        while l:c <=255 
            if (bufexists(l:c))
                let l:readable = filereadable(bufname(l:c))
"               echo bufname(l:c) . " is " . (l:readable ? "" : "not ") . "a readable file."
                if (l:readable)
                    if (getbufvar(l:c, '&buftype') == "")
                        if !(bufname(l:c) == "")
                           call add(l:body, "" . bufname(l:c) . "")
                        endif
                    endif
                endif
            endif
            let l:c += 1
        endwhile 


        for l:l in range(1, winnr('$'))
                    let l:thisbuffername = bufname(winbufnr(l:l))
                    call add(l:winbody, l:thisbuffername)
        endfor
        call writefile(l:body, a:1)
        call writefile(l:winbody, ".vimwindows")

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
