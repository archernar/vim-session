# session.vim
## a simple vim session and split management plugin
## Screen Shot
![alt text](https://github.com/archernar/vim-session/blob/master/images/session.png)
## Setup
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
    " VIMSESSION   vim.vimsession Name of the file that contains the session list
    "                             This is a simple list of files
    "                             This file can be manually edited or auto generated
    
    "                             CaptureSession() writes the files associated with open
    "                             buffers ( one per line ) to this file
    "                             You can manually create this file too
    "
    " VIMWINDOW    vim.vimwindow  Name of the file that contains the list of files
    "                             to be viewed in the splits (in the order listed)
    "                             This file is typically not manually edited, but can be
    "                             CaptureSession() writes the files associated visible
    "                             splits/tabs to this file.  
    
    "                             If $VIMSPLIT (see below) contains a split command string
    "                             (say "split | split") then the files will be viewed in
    "                             the splits in order.  If there are less splits than files
    "                             then loading stops.
    "
    " VIMSPLIT     vim.vimsplit   Name of the file that contains split commands
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
## Plugin Code
    if exists("g:loaded_plugin_session") || v:version < 700 || &cp
        finish
    endif
    let g:loaded_plugin_session=1
    
    let s:MAXBUFFERS=255
    
    
    
    " ==============================================================================
    "                                     - Notes
    "                                     ------------------------------------------
    
    " gawk to set first and second row in a text file and leave rest the same
    " gawk -v s=E -v f=P 'BEGIN {d="";n="\n";} (f==$0) {ff=$0; next;} (s==$0) {sf=$0; next;} {l=l d $0; d=n; next;} END {print ((ff!="") ? ff n:ff) ((sf!="") ? sf n:sf) l}'
    " gawk to set first row in a text file and leave rest the same
    " gawk -v f=P 'BEGIN {d="";n="\n";} (f==$0) {ff=$0; next;} {l=l d $0; d=n; next;} END {print ((ff!="") ? ff n:ff) l}'
    
    
    " ==============================================================================
    "                                     - Script Utility Function
    "                                     ------------------------------------------
    "                                     - s:LogMessage(...)
    "                                     ------------------------------------------
    function s:LogMessage(...)
        let l:ret = 0
        return l:ret
        let l:messages=[]
        call add(l:messages, a:1)
        call writefile(l:messages, "/tmp/vimscript.log", "a")
        return l:ret
    endfunction
    
    function s:Dump(...)
        let l:c = 1
        call s:LogMessage("Dump")
        while l:c <= s:MAXBUFFERS 
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
    "                                     - Read Master Index
    "                                     ------------------------------------------
    "                                     ------------------------------------------
    let s:master = []
    let s:masterindex = "~/.vimsession.masterone"
    function! s:readMasterIndex()
        if (filereadable(s:masterindex))
            let s:master = readfile(s:masterindex)
        endif
        return s:master
    endfunction
    " ==============================================================================
    "                                     - Write Master Index
    "                                     ------------------------------------------
    "                                     ------------------------------------------
    function! s:writeMasterIndex()
        call writefile(s:master, masterindex)
        return s:master
    endfunction
    " ==============================================================================
    "                                     - Add To Master Index
    "                                     ------------------------------------------
    "                                     ------------------------------------------
    function! s:addToMasterIndex(...)
        call add(s:master, a:1)
        return s:master
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
    "                                     - g:CopyFiles()
    "                                     ------------------------------------------
    function! g:CopyFiles()
        let l:sfile   = ($VIMSESSION == "") ? ".vim.vimsession" : $VIMSESSION . ".vimsession"
        if (filereadable(l:sfile))
            call s:LogMessage("Reading " . fnamemodify(l:sfile, ':p'))
            let l:body = readfile(l:sfile)
            call system("mkdir -p ./.vim.fileset")
            call system("rm -rf   ./.vim.fileset")
            call system("mkdir -p ./.vim.fileset")
            call system("mkdir -p ./.vim.fileset.tars")
            for l:l in l:body
                let l:dq="\""
                let l:sz = "cp " . l:dq . l:l . l:dq . "   ./.vim.fileset"
                call system(l:sz)
            endfor
            let l:fn = "./.vim.fileset.tars/fileset." . strftime("%Y%m%d%H%M%S") . ".tar"
            call system("tar cvf " . l:fn .  " ./.vim.fileset")
        endif
    endfunction
    " ==============================================================================
    "                                     - Global Function
    "                                     ------------------------------------------
    "                                     - LoadSession()
    "                                     ------------------------------------------
    function! g:LoadSessionGlobal(...)
        call LoadSession(a:1)
    endfunction
    
    function! s:BuildTags(...)
            silent execute "!ctags -L " . (($VIMSESSION == "") ? ".vim.vimsession" : $VIMSESSION . ".vimsession")
            redraw!
    endfunction
    
    
    function! LoadSession(...)
    
    "   if exists("g:session_loaded")
    "       return
    "   endif
    
            let l:sfile   = ($VIMSESSION == "") ? ".vim.vimsession" : $VIMSESSION . ".vimsession"
            let l:wfile   = ($VIMWINDOW == "")  ? ".vim.vimwindow"  : $VIMWINDOW .  ".vimwindow"
            let l:splfile = ($VIMSPLIT == "")   ? ".vim.vimsplit"   : $VIMSPLIT .   ".vimsplit"
            call s:LogMessage("Loading implicit session file ". l:sfile)
            let l:sfolder = fnamemodify(fnamemodify(l:sfile, ':p'), ':h')
    
            " Tags Support
            call s:BuildTags()
            command! TAGS call s:BuildTags()
            
    
    
            let l:filecmd = "e"
            let l:splits = ""
            let g:session_loaded=1 
            call s:LogMessage($VIMSESSION . " " . l:sfile)
            call s:LogMessage($VIMWINDOW  . " " . l:wfile)
            call s:LogMessage($VIMSPLIT   . " " . l:splfile)
            call s:LogMessage(l:sfolder)
    
            if (filereadable(splfile))
                if ( len(readfile(splfile)) == 0)
                    let l:body=[]
                    call add(l:body, "none")
                    call writefile(l:body, splfile)
                endif
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
        call s:LogMessage("Loading Begin")
        call s:Dump()
        let l:tlist=[]
        let l:body = []
        if (filereadable(l:sfile))
            call s:LogMessage("Reading " . fnamemodify(l:sfile, ':p'))
            let l:tlist = readfile(l:sfile)
            let l:readmore = 1
            for l:l in l:tlist
                if ( l:l == "STOP")
                    let l:readmore = 0
                endif
                if ( l:readmore == 1 )
                    call add(l:body, l:l)
                endif
            endfor
    
            "let l:body = readfile(l:sfile)
    
    
            for l:l in l:body
                if !( l:l =~ "\"" )
                    if !( l:l == "" )
                        exe l:filecmd . " " . l:l
                        call s:LogMessage("Loading Body Element " . l:l . " from " . l:sfile)
                        if (line("'\"") > 0 && line("'\"") <= line("$"))
                            exe "normal! g'\"" 
                        endif
                        let l:sz .= l:l . " "
                        let l:c += 1
                    endif
                endif
            endfor
            call s:DeleteNoNameBuffer()
            call s:Dump()
            call s:LogMessage("Loading Complete")
    
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
                                 call s:LogMessage("Loading " . l:l)
                                 exe "e " . l:l
                             endif
                             let l:c += 1
                    endif
                endfor
            endif
            exe "1wincmd w"
        endif
    
    if (!( $VIMFIRSTFILE == ""))
        exe "bwipeout! " . $VIMFIRSTFILE
    endif
    
    call s:Dump()
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
    
    function! SetSession(...)
        if (a:0 == 0)
            let l:sz = input('Session Name>> ')
        else
            let l:sz = a:1
        endif
        let $VIMSESSION=l:sz
        let $VIMWINDOW=l:sz
        let $VIMSPLIT=l:sz
        call ShowSession()
    endfunction
    function! ReSetSession(...)
        if (a:0 == 0)
            let l:sz = ".vim"
        else
            let l:sz = a:1
        endif
        let $VIMSESSION=l:sz
        let $VIMWINDOW=l:sz
        let $VIMSPLIT=l:sz
        call ShowSession()
    endfunction
    function! ShowSession(...)
        echom "[" . $VIMSESSION . "/" . $VIMWINDOW . "/" . $VIMSPLIT . "]"
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
    
        call writefile(l:body,    ($VIMSESSION == "") ? "vim.vimsession" : $VIMSESSION . ".vimsession")
        call writefile(l:winbody, ($VIMWINDOW == "") ? "vim.vimwindow" : $VIMWINDOW   . ".vimwindow")
        " https://stackoverflow.com/questions/7236315/how-can-i-view-the-filepaths-to-all-vims-open-buffers
        let l:mm=map(filter(range(0,bufnr('$')), 'buflisted(v:val)'), 'fnamemodify(bufname(v:val), ":p")')
        for l:l in l:mm
            call add(l:global, FullPathFileName(l:l))
        endfor
        call writefile(l:global, l:gfn)
        echom "session written to " . (($VIMSESSION == "") ? "vim.vimsession" : $VIMSESSION . ".vimsession")
    endfunction
