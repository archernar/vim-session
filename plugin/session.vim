"# session.vim
"## a simple vim session and split management plugin
"## Screen Shot
" MD-LINK ![alt text](https://github.com/archernar/vim-session/blob/master/images/session.png)
"## Setup
" MD-CODE
" ==========================================================================================
" Load the plugin with your plugin manager

" Example: I use Vundle -
" Plugin 'archernar/vim-session'
" ==========================================================================================

" To capture sessions, add the following command to your .vimrc and run the
" command when you want to save your session. 
" 
" command! SESSION   :call CaptureSession()
" 
" The command will then perform a manual snapshot of your current sessioni and
" save the session in $VIMSESSION.

" To automatically load sessions on vim startup, add the following to your .vimrc
" if ( argc() == 0 ) 
"      autocmd VimEnter * :call LoadSession()
" endif
"
" Once setup you can now use vim this way:

" say vim, by itself, and the specific session config will be loaded
" say vim <filename> [<filename> ...], just the files are loaded (no session loaded)
" 
" at any time issue the command "SESSION" (or you replacement) and the session info
" is saved.  There is no concept of auto saving session.  Saving session is manual
" by design (I prefer manual saves in my workflow).


" Environment Variables, Session Files and Split Configuration File
" name         default        description
" VIMSESSION   .vimsession    Name of the file that contains the session list
"                             This is a simple list of files
"                             This file can be manually edited or auto generated

"                             CaptureSession() writes the files associated with open
"                             buffers ( one per line ) to this file
"                             You can manually create this file too
"
" VIMWINDOW    .vimwindow     Name of the file that contains the list of files
"                             to be viewed in the splits (in the order listed)
"                             This file is typically not manually edited, but can be
"                             CaptureSession() writes the files associated visible
"                             splits/tabs to this file.  

"                             If $VIMSPLIT (see below) contains a split command string
"                             (say "split | split") then the files will be viewed in
"                             the splits in order.  If there are less splits than files
"                             then loading stops.
"
" VIMSPLIT     .vimsplit      Name of the file that contains split commands
"                             This file has one line in it
"                             Options:
"                             if the file contains "none":  No Splits of Tabs
"                             if the file contains "tab":   Use Tabs
"                             else, the file may contain a single line of "|"
"                             seperated split commands
"                             Ex.  split
"                                  split | split
"                                  split | vsplit
" ==========================================================================================
"## Plugin Code
" MD-CODE
if exists("g:loaded_plugin_session") || v:version < 700 || &cp
    finish
endif
let g:loaded_plugin_session=1

let s:MAXBUFFERS=255

" ==============================================================================
"                                     - Script Utility Function
"                                     ------------------------------------------
"                                     - s:LogMessage(...)
"                                     ------------------------------------------
function s:LogMessage(...)
    let l:ret = 0
    " return l:ret
    let l:messages=[]
    call add(l:messages, a:1)
    call writefile(l:messages, "/tmp/vimscript.log", "a")
    return l:ret
endfunction

function s:Dump(...)
    return
    let l:c = 1
    call s:LogMessage("Dump")
    while l:c <= s:MAXBUFFERS 
        call s:LogMessage("    Looking at buffer " . l:c)
        if (bufexists(l:c))
                if (getbufvar(l:c, '&buftype') == "")
                    if !(bufname(l:c) == "")
                        call s:LogMessage("    " . bufname(l:c) . "  buffer # " . l:c)
                    endif
                endif
        else
            let l:c = s:MAXBUFFERS +1
        endif
        let l:c += 1
    endwhile 
    call s:LogMessage("DumpEnd")
endfunction
" ==============================================================================
"                                     - Script Utility Function
"                                     ------------------------------------------
"                                     - s:TabsCount()
"                                     ------------------------------------------
function s:TabCount()
    let l:ret = 0
    for l:i in range(tabpagenr('$'))
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
"                                     ------------------------------------------
function! g:DeleteAllBuffers()
    silent exe "0,s:"
endfunction
" ==============================================================================
"                                     - Global Function
"                                     ------------------------------------------
"                                     - LoadSession()
"                                     ------------------------------------------
function! LoadSession(...)

    if exists("g:session_loaded")
        return
    endif

    call s:Dump()
    if ( a:0 == 1)
        let l:sfile   = a:1
        let g:session_loaded=1 
        call s:LogMessage("Loading explicit session file ". l:sfile)
        let l:sfolder = fnamemodify(fnamemodify(l:sfile, ':p'), ':h')
        let l:wfile   = ""
        let l:splfile = ""
        let l:filecmd = "e"
        let l:splits = ""
    else
        let l:sfile   = ($VIMSESSION == "") ? ".vimsession" : $VIMSESSION
        call s:LogMessage("Loading implicit session file ". l:sfile)
        let l:sfolder = fnamemodify(fnamemodify(l:sfile, ':p'), ':h')
        let l:wfile   = ($VIMWINDOW == "")  ? ".vimwindow"  : $VIMWINDOW
        let l:splfile = ($VIMSPLIT == "")   ? ".vimsplit"   : $VIMSPLIT
        let l:wfile   = l:sfolder . "/.vimwindow"
        let l:splfile = l:sfolder . "/.vimsplit"
        let l:filecmd = "e"
        let l:splits = ""
        let g:session_loaded=1 
    endif



    if (filereadable(splfile))
        let l:splits = ""
        let l:splits = readfile(splfile)[0]
    else
        let l:body=[]
        call add(l:body, "none")
        call writefile(l:body, splfile)
        let l:splits = "none"
    endif

    if (l:splits == "tab")
        let l:filecmd = "tabedit"
    endif

    if (l:splits != "tab") 
        if (l:splits != "none")
            if (l:splits == "four")
              execute "split | vsplit | wincmd w | vsplit | wincmd w | wincmd w | wincmd w"
            else
              if (l:splits != "")
                  exe l:splits . " | exe '1wincmd w'"
              endif
            endif
        endif
    endif


    let l:sz = ""
    let l:c = 0
    let l:sz = l:sfile
    if (filereadable(l:sfile))
        call s:LogMessage("Reading " . fnamemodify(l:sfile, ':p'))
        let l:body = readfile(l:sfile)
        for l:l in l:body
            call s:LogMessage("Body Element " . l:l . " from " . l:sfile)
            if !( l:l =~ "\"" )
                if !( l:l == "" )
                    exe l:filecmd . " " . l:l
                    call s:Dump()
                    if (line("'\"") > 0 && line("'\"") <= line("$"))
                        exe "normal! g'\"" 
                    endif
                    let l:sz .= l:l . " "
                    let l:c += 1
                endif
            endif
        endfor
        call s:DeleteNoNameBuffer()

        if (l:splits != "tab") 
            exe "tabfirst"
        else
            exe "1wincmd w"
        endif
    endif
    " ============
    " For SPLITS
    " ============
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

call s:LogMessage("END LoadSession()")
endfunction

" ==============================================================================
"                                     - Global Function
"                                     ------------------------------------------
"                                     - FullPathFileName()
"                                     ------------------------------------------
function! FullPathFileName(...)
     return fnamemodify(a:1, ':p')
endfunction

" ==============================================================================
"                                     - Global Function
"                                     ------------------------------------------
"                                     - CaptureSession()
"                                     ------------------------------------------
function! CaptureSession()
    let l:c=1
    let l:global=[]
    let l:body=[]
    let l:winbody=[]
    let l:gfn = $HOME . "/.vimsessionglobal"

    if (filereadable(l:gfn)) 
        let l:global = readfile(l:gfn)
    endif

    echom "capturing up to " . s:MAXBUFFERS . " buffers"
    while l:c <= s:MAXBUFFERS 
        if (bufexists(l:c))
            if ( 1 == 1 )
                if (getbufvar(l:c, '&buftype') == "")
                    if !(bufname(l:c) == "")
                       call add(l:body, FullPathFileName(bufname(l:c)))
                    endif
                endif
            endif
        endif
        let l:c += 1
    endwhile 

    for l:l in range(1, winnr('$'))
                call add(l:winbody, FullPathFileName(bufname(winbufnr(l:l))))
    endfor

    call writefile(l:body,    ($VIMSESSION == "") ? ".vimsession" : $VIMSESSION)
    call writefile(l:winbody, ($VIMWINDOW == "") ? ".vimwindow" : $VIMWINDOW)
    " https://stackoverflow.com/questions/7236315/how-can-i-view-the-filepaths-to-all-vims-open-buffers
    let l:mm=map(filter(range(0,bufnr('$')), 'buflisted(v:val)'), 'fnamemodify(bufname(v:val), ":p")')
    for l:l in l:mm
        call add(l:global, FullPathFileName(l:l))
    endfor
    call writefile(l:global, l:gfn)


echom "session written to " . (($VIMSESSION == "") ? ".vimsession" : $VIMSESSION)
endfunction
