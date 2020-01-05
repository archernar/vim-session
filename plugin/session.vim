" ====================================================================================
" Required Environment Variables
"
" export VIMSESSION=.vimsession
" export VIMWINDOWS=.vimwindows
"
" To capture sessions, define a vim command of the form
"
" command! SESSION  :call CaptureSession('$VIMSESSION', '$VIMWINDOWS')   or
" command! SESSION  :call CaptureSession('$VIMSESSION')   or
" command! SESSION  :call CaptureSession()
"
" ====================================================================================
"
if exists("g:loaded_plugin_session") || v:version < 700 || &cp
  finish
endif
let g:loaded_plugin_session=1

"
" ------------------------------------------
" s:WindowExists(...)
" a:1 is the window  number
" ------------------------------------------
function! s:WindowExists(...)
    let nRet = 0
    for l:l in range(1, winnr('$'))
        if (a:1 == l:l) 
            let nRet = 1
        endif
    endfor
    return nRet
endfunction
" ------------------------------------------
" s:BufferVisible(...)
" a:1 is the buffer number
" ------------------------------------------
function! s:BufferVisible(...)
    " a:1 is the buffer number
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
    while l:c <= 64 
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
function! FileInSession(...)
    let nRet = 0
    if (filereadable(a:1))
        let l:body = readfile(a:1)
        for l:l in l:body
            if (l:l == a:2)
                let nRet = 1
            endif
        endfor
    endif
    return l:nRet
endfunction
" ------------------------------------------
" LoadSession(...)
" a:1 is the session file filename
" a:2 is the command to apply to files
"     default is 'e'
" ------------------------------------------
function! LoadSession(...)
    let l:filecmd = (a:0 > 1) ? a:2 : "e"
    let l:sz = ""
    let l:c = 0
    let l:sz = a:1
    if (filereadable(a:1))
        let l:body = readfile(a:1)
        for l:l in l:body
            if !( l:l =~ "\"" )
                if !( l:l == "" )
                    exe l:filecmd . " " . l:l
                    let l:sz .= l:l . " "
                    let l:c += 1
                endif
            endif
        endfor
        let l:sz = l:c . "F " . l:sz 
        exe "1wincmd w"
        call s:DeleteNoNameBuffer()
    endif
    call s:LoadLastBuffer(".vimbuffer",a:1)
    echom l:sz
    autocmd Filetype,BufEnter * call CaptureBuffer()
endfunction


" ------------------------------------------
" LoadSessionT(...)
" a:1 is the session file filename
" a:2 is the window file filename
" a:3 is the command to apply to files
"     def: 'e'
" a:4 a set of split commands
"     def: vsplit | split | vert resize 33
"
" ------------------------------------------
function! LoadSessionT(...)
    let l:filecmd = (a:0 > 2) ? a:3 : "e"
    let l:splits = ""
    let l:sz = ""
    let l:szW = ""
    let l:c = 0

    let l:splits = "vsplit | split | vertical resize 53"

    if (filereadable(".vimlayout"))
        let l:splits = ""
        let l:delim = ""
        let l:layout = readfile(".vimlayout")
        for l:l in l:layout
            let l:splits .= (l:delim . l:l)
            let l:delim = " | "
        endfor
    endif

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
                    exe l:filecmd . " " . l:l
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
                    if !(l:l == "")
                             if ( s:WindowExists(l:c) == 1 )
                                 exe l:c . "wincmd w"
                                 exe "e " . l:l
                             endif
                             let l:c += 1
                    endif
                endfor
            endif
            exe "1wincmd w"
        endif
    endif
    echom "T " . l:sz
    call s:DeleteNoNameBuffer()
    call s:LoadLastBuffer(".vimbuffer", a:1)
    autocmd Filetype,BufEnter * call CaptureBuffer()
endfunction

":echo @%                def/my.txt      directory/name of file (relative to the current working directory of /abc)
":echo expand('%:t')     my.txt  name of file ('tail')
":echo expand('%:p')     /abc/def/my.txt full path
":echo expand('%:p:h')   /abc/def        directory containing file ('head')
":echo expand('%:p:h:t') def     First get the full path with :p (/abc/def/my.txt), then get the head of that with :h (/abc/def), then get the tail of that with :t (def)
":echo expand('%:r')     def/my  name of file less one extension ('root')
":echo expand('%:e')     txt     name of file's extension ('extension')
"For more info run :help expand

function! CaptureBuffer()
    let l:body=[]
    if (! (expand('%:t') == ".vimbuffer") )
        call add(l:body, bufname(expand('%:p')))
        call writefile(l:body, ".vimbuffer")
    endif
endfunction
function! s:LoadLastBuffer(...)
    if (filereadable(a:1))
        let l:body = readfile(a:1)
        for l:l in l:body
             if (FileInSession(a:2, l:l) == 1)
                 exe "e " . l:l
             endif
        endfor
    endif
endfunction

" ------------------------------------------
" CaptureSession(...)
" a:1 is the session file filename
"     def: .vimsession
" a:2 is the window file filename
"     def: .vimwindows
" ------------------------------------------
function! CaptureSession(...)
    let l:c=1
    let l:body=[]
    let l:winbody=[]
    while l:c <= 64 
        if (bufexists(l:c))
            if (filereadable(bufname(l:c)))
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
