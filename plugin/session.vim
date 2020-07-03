" ==============================================================================
" Environment Variables
"
" export VIMSESSION=.vimsession
" export VIMWINDOW=.vimwindow
"
" To capture sessions, define a vim command of the form
"
" command! SESSION  :call CaptureSession()
" 
"
" ==============================================================================
"
if exists("g:loaded_plugin_session") || v:version < 700 || &cp
    finish
endif
let g:loaded_plugin_session=1

let s:MAXBUFFERS=32
" ==============================================================================
"                                     - Script Utility Function
"                                     ------------------------------------------
"                                     - s:TabsCount()
"                                     - 
"                                     ------------------------------------------
function s:TabCount()
    let l:ret = 0
    for i in range(tabpagenr('$'))
        let l:ret = l:ret + 1
    endfor
    return l:ret
endfunction
" ==============================================================================
"                                     - Script Utility Function
"                                     ------------------------------------------
"                                     - s:WindowExists(...)
"                                     -      a:1 is the window number
"                                     ------------------------------------------
function! s:WindowExists(...)
    let l:nRet = 0
    for l:l in range(1, winnr('$'))
        if (a:1 == l:l) 
            let l:nRet = 1
        endif
    endfor
    return l:nRet
endfunction
" ==============================================================================
"                                     - Script Utility Function
"                                     ------------------------------------------
"                                     - s:BufferVisible(...)
"                                     -      a:1 is the buffer number
"                                     ------------------------------------------
function! s:BufferVisible(...)
    let l:ret = 0
    for l:l in range(1, winnr('$'))
        if (a:1 == winbufnr(l:l))
            let l:ret = 1
        endif
    endfor
    return l:ret
endfunction
" ==============================================================================
"                                     - Script Utility Function
"                                     ------------------------------------------
"                                     - s:DeleteNoNameBuffer()
"                                     -      
"                                     ------------------------------------------
function! s:DeleteNoNameBuffer()
    let l:c = 1
    while l:c <= s:MAXBUFFERS 
        if (bufexists(l:c))
            if (bufname(l:c) == "")
                if (s:BufferVisible(l:c) == 0)
                    exe "bd " . l:c
                endif
            endif
        else
            let l:c = s:MAXBUFFERS * 2 
        endif
        let l:c += 1
    endwhile 
endfunction
" ==============================================================================
"                                     - Script Utility Function
"                                     ------------------------------------------
"                                     - s:FileInSession(...)
"                                     -      a:1 is a file name
"                                     ------------------------------------------
function! s:FileInSession(...)
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

" ==============================================================================
"                                     - Script Utility Function
"                                     ------------------------------------------
"                                     - s:LoadLastBuffer(...)
"                                     -      
"                                     ------------------------------------------
function! s:LoadLastBuffer(...)
    if (filereadable(a:1))
        let l:body = readfile(a:1)
        for l:l in l:body
             if (s:FileInSession(a:3, l:l) == 1)
                 exe "e " . l:l
             endif
        endfor
    endif
    if (filereadable(a:2))
        let l:body = readfile(a:2)
        for l:l in l:body
             if (s:FileInSession(a:3, l:l) == 1)
                 exe "e " . l:l
             endif
        endfor
    endif
endfunction

" ==============================================================================
"                                     - Global Function
"                                     ------------------------------------------
"                                     - g:DeleteAllBuffers()
"                                     -      
"                                     ------------------------------------------
function! g:DeleteAllBuffers()
    silent exe "0,s:MAXBUFFERSbdelete!"
endfunction
" ==============================================================================
"                                     - Global Function
"                                     ------------------------------------------
"                                     - g:LoadNamedSession()
"                                     -      
"                                     ------------------------------------------
function! g:LoadNamedSession()
    silent exe "0,s:MAXBUFFERSbdelete!"
    let l:szIn = input('session name (.vimsession) >> ')
    if (strlen(l:szIn) > 0)
        call LoadSession(szIn,'e')
    else
        call LoadSession('.vimsession','e')
    endif
endfunction
" ==============================================================================
"                                     - Global Function
"                                     ------------------------------------------
"                                     - LoadSession(...)
"                                     -
"                                     ------------------------------------------
function! LoadSession(...)
    let l:sfile   = ($VIMSESSION == "") ? ".vimsession" : $VIMSESSION
    let l:wfile   = ($VIMWINDOW == "")  ? ".vimwindow"  : $VIMWINDOW
    let l:splfile = ($VIMSPLIT == "")   ? ".vimsplit"   : $VIMSPLIT
    let l:tfile = ($VIMTAB == "")     ? ".vimtab"     : $VIMTAB
    let l:filecmd = "e"
    let l:splits = ""

    if (filereadable(splfile))
        let l:splits = ""
        let l:splits = readfile(splfile)[0]
    endif

    if (l:splits == "tab")
        let l:filecmd = "tabedit"
    endif

    if (l:splits != "tab") 
        if (l:splits != "none")
            if (l:splits != "")
                exe l:splits . " | exe '1wincmd w'"
            endif
        endif
    endif


    let l:sz = ""
    let l:c = 0
    let l:sz = l:sfile
    if (filereadable(l:sfile))
        let l:body = readfile(l:sfile)
        for l:l in l:body
            if !( l:l =~ "\"" )
                if !( l:l == "" )
                    exe l:filecmd . " " . l:l
                    if (line("'\"") > 0 && line("'\"") <= line("$"))
                        exe "normal! g'\"" 
                    endif
                    let l:sz .= l:l . " "
                    let l:c += 1
                endif
            endif
        endfor
        call s:DeleteNoNameBuffer()

        let l:sz = l:c . "F " . l:sz . "  SL/FORCE/UNFORCE" 
        if (filereadable(l:tfile))
            exe "tabfirst"
        else
            exe "1wincmd w"
        endif
    endif

        let l:c = 1
        if (filereadable(l:splfile))
            if (filereadable(l:wfile))
                let l:body = readfile(l:wfile)
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


"    call s:LoadLastBuffer(".vimbuffer",".vimforcebuffer",l:sfile)
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


" ==============================================================================
"                                     - Global Function
"                                     ------------------------------------------
"                                     - CaptureBuffer() 
"                                     -      
"                                     ------------------------------------------
function! CaptureBuffer()
    let l:body=[]
    if (! (expand('%:t') == ".vimbuffer") )
        call add(l:body, bufname(expand('%:p')))
        call writefile(l:body, ".vimbuffer")
    endif
endfunction
" ==============================================================================
"                                     - Global Function
"                                     ------------------------------------------
"                                     - EmptyCaptureBuffer()
"                                     -      
"                                     ------------------------------------------
command! ECB  :call EmptyCaptureBuffer()
function! EmptyCaptureBuffer()
    let l:body=[]
    call writefile(l:body, ".vimbuffer")
endfunction
" ==============================================================================
"                                     - Global Function
"                                     ------------------------------------------
"                                     - CaptureForceBuffer()
"                                     -      
"                                     ------------------------------------------
command! FORCE :call CaptureForceBuffer()
function! CaptureForceBuffer()
    let l:body=[]
    if (! (expand('%:t') == ".vimforcebuffer") )
        call add(l:body, bufname(expand('%:p')))
        call writefile(l:body, ".vimforcebuffer")
    endif
endfunction
" ==============================================================================
"                                     - Global Function
"                                     ------------------------------------------
"                                     - EmptyForceBuffer()
"                                     -      
"                                     ------------------------------------------
command! UNFORCE :call EmptyForceBuffer()
function! EmptyForceBuffer()
    let l:body=[]
    call writefile(l:body, ".vimforcebuffer")
endfunction

" ==============================================================================
"                                     - Global Function
"                                     ------------------------------------------
"                                     - CaptureSession()
"                                     - 
"                                     ------------------------------------------
function! CaptureSession()
    let l:c=1
    let l:body=[]
    let l:winbody=[]
    echom "capturing up to " . s:MAXBUFFERS . " buffers"
    while l:c <= s:MAXBUFFERS 
        if (bufexists(l:c))
            " if (filereadable(bufname(l:c)))
            if ( 1 == 1 )
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

    call writefile(l:body,    ($VIMSESSION == "") ? ".vimsession" : $VIMSESSION)
    call writefile(l:winbody, ($VIMWINDOW == "") ? ".vimwindow" : $VIMWINDOW)

echom "session written"
endfunction
" ------------------------------------------
" ==============================================================================
"                                     - Script Utility Function
"                                     ------------------------------------------
"                                     - 
"                                     -      
"                                     ------------------------------------------
" ==============================================================================
"                                     - Global Function
"                                     ------------------------------------------
"                                     - 
"                                     -      
"                                     ------------------------------------------
