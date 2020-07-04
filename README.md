# Simple Vim session and split management

## Screen Shot
![alt text](https://github.com/archernar/vim-session/blob/master/images/session.png)

## session.vim
<pre><code>" ==============================================================================
" Environment Variables
"
" export VIMSESSION=.vimsession
" export VIMWINDOW=.vimwindow
" export VIMSPLIT=.vimsplit
"
" To capture sessions, define a vim command of the form
"
" command! SESSION  :call CaptureSession()
" 
"
" ==============================================================================
"
if exists("g:loaded_plugin_session") || v:version &lt; 700 || &amp;cp
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
    while l:c &lt;= s:MAXBUFFERS 
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
    silent exe "0,s:"
endfunction
" ==============================================================================
"                                     - Global Function
"                                     ------------------------------------------
"                                     - LoadSession()
"                                     -
"                                     ------------------------------------------
function! LoadSession()
    let l:sfile   = ($VIMSESSION == "") ? ".vimsession" : $VIMSESSION
    let l:wfile   = ($VIMWINDOW == "")  ? ".vimwindow"  : $VIMWINDOW
    let l:splfile = ($VIMSPLIT == "")   ? ".vimsplit"   : $VIMSPLIT
    let l:filecmd = "e"
    let l:splits = ""

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
                    if (line("'\"") &gt; 0 &amp;&amp; line("'\"") &lt;= line("$"))
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
    while l:c &lt;= s:MAXBUFFERS 
        if (bufexists(l:c))
            " if (filereadable(bufname(l:c)))
            if ( 1 == 1 )
                if (getbufvar(l:c, '&amp;buftype') == "")
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
</code></pre>


## DIR Command (simple file selector)
![alt text](https://github.com/archernar/vim-session/blob/master/images/dirsession.png)

## dir.vim
<pre><code>" *****************************************************************************************************
                "  dir.vim - a Simple Directory Lister/File Opener
                " *************************************************************************************
if exists("g:loaded_plugin_dir") || v:version &lt; 700 || &amp;cp
  finish
endif
let g:loaded_plugin_dir=1

" *****************************************************************************************************
                "  Command definitions
                " *************************************************************************************
command! CODE          :call s:MyDirCode(0)
command! SNIPS         :call s:MyDirSnips(0)
command! DIRE          :call s:MyDirSelect($VIMSELECTEDDIR,0)
command! JSNIPS        :call s:MyDirJSnips(0)
command! CLASSES      :call s:MyDirClasses(0)
command! DIR           :call s:MyDirPwd(1)
command! DIRC          :call s:MyDirPwd(0)
command! DDIR          :call s:MyDirPwd(0)

command! SESSIONLIST   :call g:ListBuffers()
command! SESSIONEDIT   :e .vimsession
command! SESSIONFILES  :call g:SessionFiles()
command! SL            :call g:SessionFiles()

command! LOADNAMEDSESSION  :call g:LoadNamedSession()
command! LOADSESSION       :call g:LoadNamedSession()

" *****************************************************************************************************
                "  Local/Script Functions
                " *************************************************************************************
let s:DirSet = ""
let s:DirMask = "/*"
let s:DirEditWindow=0
let s:DirCloseWindow=1
let s:DirWindow=0
function! s:DirSetMask(...)
    let s:DirMask = a:1
    return  s:DirMask
endfunction
function! s:DirFileName(...)
    return  join(split(a:1,"/")[-1:-1])
endfunction
function! s:DirToken(...)
    let l:ret = ""
    if (strlen(a:1) &gt; 0)
        let l:ret = split(a:1," ")[-1]
    endif
    return l:ret
endfunction
function! s:DirSetPwd()
    let s:DirSet = getcwd()
    return s:DirSet
endfunction
function! s:DirSetUp()
    let s:DirSet = (s:DirSet == "/") ? "/" : ("/" . join( (split(s:DirSet,"/"))[:-2], "/" ))
    return s:DirSet
endfunction
function! s:DirSetInto(...)
    let s:DirSet = (a:1 == "") ?  s:DirSet : s:DirSet . "/" . a:1
    return s:DirSet
endfunction
let s:PutLineRow=0
function! s:PutLineSet(...)
    let s:PutLineRow = a:1 
endfunction
function! s:PutLine(...)
    call setline(s:PutLineRow, a:1)
    let s:PutLineRow = s:PutLineRow + 1
endfunction

function! s:MyDir(...)
    call s:PutLineSet(0)
    " Load Directory Part
        let l:list = split(glob(a:1),'\n')
    " Create Window/Buffer Part
        call s:NewWindow("Left", &amp;columns/4, "&lt;Enter&gt; :call g:MyDirAction('e')","s :call g:MyDirAction('vnew')", "b :call g:MyDirAction('split')")
        let s:DirWindow = winnr()
        nnoremap &lt;silent&gt; &lt;buffer&gt; f /^f&lt;cr&gt;
        echom "&lt;enter&gt; to edit, &lt;s&gt; to edit in Vert-Split, &lt;b&gt; to edit in Horz-Split"
    " Display Part
        setlocal cursorline
        call s:PutLineSet(1)

        " call s:PutLine("[" . s:DirSet . "]")
        call s:PutLine("[" . g:Strreplace(s:DirSet,$HOME,"$HOME") . "]")
        call s:PutLine("..")
        let l:templ = []

    for key in l:list
          let l:sz = s:DirFileName(key)
          let l:type="f"
          if (isdirectory(s:DirSet . "/" . l:sz) &gt; 0)
               let l:type="d"
          endif
          call add(l:templ, l:type . " " . l:sz)
    endfor

    for key in sort(l:templ)
          call s:PutLine(key)
    endfor
        set nowrap
endfunc

function! s:NewWindow(...)
        " for wincmdH is Left  L is Right  K is Top  J is Bottom
        " H is Left  L is Right  K is Top  J is Bottom
        vnew
        let l:sz = tolower(a:1)
        if (l:sz == "left")
             wincmd H
        endif
        if (l:sz == "right")
             wincmd L
        endif
        if (l:sz == "top")
             wincmd K
        endif
        if (l:sz == "bottom")
             wincmd J
        endif
        setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
        nnoremap &lt;silent&gt; &lt;buffer&gt; q :close&lt;cr&gt;
        nnoremap &lt;silent&gt; &lt;buffer&gt; = :vertical resize +5&lt;cr&gt;
        nnoremap &lt;silent&gt; &lt;buffer&gt; - :vertical resize -5&lt;cr&gt;
        call cursor(1, 1)
        execute "vertical resize " . a:2
        if ( a:0 &gt; 2)
            execute "nnoremap &lt;silent&gt; &lt;buffer&gt; " . a:3 . "&lt;cr&gt;"
        endif
        if ( a:0 &gt; 3)
            execute "nnoremap &lt;silent&gt; &lt;buffer&gt; " . a:4 . "&lt;cr&gt;"
        endif
        if ( a:0 &gt; 4)
            execute "nnoremap &lt;silent&gt; &lt;buffer&gt; " . a:5 . "&lt;cr&gt;"
        endif
endfunction


" *****************************************************************************************************
                "  Global/Public Functions
                " *************************************************************************************
function! g:ListBuffers()
    let l:c=1
    call s:NewWindow("Left", &amp;columns/4)
    call s:PutLine(1)
    while l:c &lt;= 64 
        if (bufexists(l:c))
            if (filereadable(bufname(l:c)))
                if (getbufvar(l:c, '&amp;buftype') == "")
                    if !(bufname(l:c) == "")
                       call s:PutLine( l:c . " " . bufname(l:c) ) 
                    endif
                endif
            endif
        endif
        let l:c += 1
    endwhile 
endfunction
function! s:MyDirSelect(...)
    let  s:DirCloseWindow = a:2
    let  s:DirEditWindow = winnr()
    call s:DirSetSpecific(a:1) 
    call s:MyDir(a:1 . s:DirMask)
endfunction
function! s:MyDirPwd(...)
    let s:DirCloseWindow = a:1
    let s:DirEditWindow = winnr()
    call s:DirSetPwd() 
    call s:MyDir("." . s:DirMask)
endfunction
function! s:DirSetSpecific(...)
    let s:DirSet = a:1
    return s:DirSet
endfunction
function! s:MyDirCode(...)
    let  s:DirCloseWindow = a:1
    let  s:DirEditWindow = winnr()
    call s:DirSetSpecific($HOME . "/CODE") 
    call s:MyDir($HOME . "/CODE" . s:DirMask)
endfunction
function! s:MyDirSnips(...)
    let  s:DirCloseWindow = a:1
    let  s:DirEditWindow = winnr()
    call s:DirSetSpecific($HOME . "/.vim/Snips") 
    call s:MyDir($HOME . "/.vim/Snips" . s:DirMask)
endfunction
function! s:MyDirClasses(...)
    let  s:DirCloseWindow = a:1
    let  s:DirEditWindow = winnr()
    call s:DirSetSpecific($HOME . "/classes") 
    call s:MyDir($HOME . "/classes/*.class")
endfunction
function! s:MyDirJSnips(...)
    let  s:DirCloseWindow = a:1
    let  s:DirEditWindow = winnr()
    call s:DirSetSpecific($HOME . "/.vim/Snips") 
    call s:MyDir($HOME . "/.vim/Snips" . "/J*.txt")
endfunction

function! g:MyDirAction(...)
     let l:sz   = s:DirToken(getline("."))
     if (line(".") &gt; 1) 
         if (strlen(l:sz) &gt; 0)
             if (l:sz == "..")
                 silent execute "q"
                 let l:sz = s:DirSetUp()
                 call s:MyDir(s:DirSet . s:DirMask)
                 return
             endif
             let l:fs = s:DirSet . "/" . l:sz
             if ( isdirectory(s:DirSet . "/" . l:sz) == 0 )
                 echom l:fs . "   "  .  filereadable(l:fs)
                 if (filereadable(l:fs))
                             if (s:DirCloseWindow == 1)
                                 silent execute "q"
                             endif
                             exe s:DirEditWindow+1 . "wincmd w"
                             silent execute a:1 . " " . l:fs
                             if (s:DirCloseWindow == 0)
                                 exe s:DirWindow . "wincmd w"
                             endif
                 endif
             else
                 silent execute "q"
                 call s:DirSetInto(l:sz)
                 call s:MyDir(s:DirSet . s:DirMask)
             endif
         endif
     endif
endfunction

let s:bb=[]
function! g:BodyBuilderReset()
    let s:bb=[]
endfunction

function! g:BodyBuilderDump()
    let l:n = 0
    for l:l in s:bb
        let l:n = l:n + 1 
        call setline(l:n, l:l)
    endfor
endfunction

function! g:BodyBuilderln(...)
    call add(s:bb, "")
    call g:BodyBuilder(a:1)
endfunction
function! g:BodyBuilder(...)
    call add(s:bb, "[" . a:1 . "]")
    if (filereadable(a:1))
        for l:l in readfile(a:1)
            call add(s:bb, l:l)
        endfor
    endif
endfunction

function! g:SessionFiles()
    call g:BodyBuilderReset()
    call g:BodyBuilder(".vimsession")
    call g:BodyBuilderln(".vimwindows")
    call g:BodyBuilderln(".vimbuffer")
    call g:BodyBuilderln(".vimforcebuffer")
    call s:NewWindow("Left", &amp;columns/4, "&lt;Enter&gt; :call g:MyDirAction('e')")
    call g:BodyBuilderDump()
endfunction

" Hello New Comment!
"
function! g:FindBuffer()
    let l:szIn = input('buffer &gt;&gt; ')
    if (l:szIn == "ls")
        exe "ls"
    else
        let l:c = 1
        while l:c &lt;= 64 
            if (bufexists(l:c))
                    let l:m = stridx(bufname(l:c), l:szIn)
                    if (l:m &gt; -1 )
                         exe "buffer " . l:c
                         let l:c = 100
                    endif
            endif
            let l:c += 1
        endwhile 
    endif
endfunction

function! g:EditNewBuffer()
    let l:szIn = input('new buffer &gt;&gt; ')
    let l:name = g:RandomString()
    if (strlen(l:szIn) &gt; 0)
        if (l:szIn == "r")
            exe "e " . name
        else
            exe "e " . l:szIn
        endif
    endif
endfunction
"Get Windows let l:list = range(1,winnr('$'))
</code></pre>
## Example Integration:  vit (Adv. model)

    #!/bin/bash
    Tmp="/tmp/$$"
    TmpDir="/tmp/dir$$"
    trap 'rm -f "$Tmp" >/dev/null 2>&1' 0
    trap "exit 2" 1 2 3 13 15
    rm $Tmp  >/dev/null 2>&1
    
    
    
    HOST=`hostname -s`
    EPOCHTIME=`date --rfc-3339=seconds |gawk '{sz= $1 "." $2;gsub(/(:)|(-)|([.])/,"", sz);   print sz}'`
    RANDNAME=${HOST}_${EPOCHTIME}
    
    
    print() {
        echo "$1"
    }
    
    if [ "$VIMSPLIT" == "" ]; then 
        export VIMSPLIT=.vimsplit
    fi
    if [ "$VIMTAB" == "" ]; then 
        export VIMTAB=.vimtab
    fi
    while getopts "xACDRSKGabcerstohm:" arg
    do
    	case $arg in
                s) rm -rf "$VIMSPLIT"
                   echo "split" > "$VIMSPLIT"
                   exit 0
                   ;;
                t) rm -rf "$VIMSPLIT"
                   echo "tab" > "$VIMSPLIT"
                   exit 0
                   ;;
                o) rm -rf "$VIMSPLIT"
                   echo "none" > "$VIMSPLIT"
                   exit 0
                   ;;
                x) vim -c "call LoadSession()"
                   exit 0
                   ;;
                a) rm -rf "$VIMSPLIT"
                   echo "vsplit" > "$VIMSPLIT"
                   exit 0
                   ;;
                b) rm -rf "$VIMSPLIT"
                   echo "split" > "$VIMSPLIT"
                   exit 0
                   ;;
                c) rm -rf "$VIMSPLIT"
                   echo "split | split" > "$VIMSPLIT"
                   exit 0
                   ;;
                C) vi -c CODE
                   exit 0
                   ;;
                S) 
                   export VIMSELECTEDDIR=~/.vim/Snips 
                   vi -c DIRE
                   exit 0
                   ;;
                D) vi -c DIR
                   exit 0
                   ;;
                A) vi $RANDNAME -c AWK
                   exit 0
                   ;;
                G) vi $RANDNAME -c AWK
                   exit 0
                   ;;
                K) vi $RANDNAME -c KSH
                   exit 0
                   ;;
                R) vi $RANDNAME
                   exit 0
                   ;;
                r) rm -f $VIMSESSION
                   rm -f $VIMWINDOW
                   rm -f $VIMLAYOUT
                   rm -f $VIMSPLIT
                   exit 0
                   ;;
                m) vim -c MRU
                   exit 0
                   ;;
                e) vim  $VIMSESSION $VIMWINDOW
                   exit 0
                   ;;
                h) print "vit"
                   print "  -D      open with pwd directory pane"
                   print "  -S      open with snips directory pane"
                   print "  -R      open random name file"
                   print "  -K      open KSH snip file"
                   print "  -A, -G  open AWK snip file"
                   print "  -a      side/side window layout"
                   print "  -b      up/down window layout"
                   print "  -c      up/mid/down window layout"
                   print "  -e      Edit ./.vimsession ./.vimwindows"
                   print "  -m      Simple Mode with MRU"
                   print "  -n      Toggle no-splits flag"
                   print "  -h      Help"
                   print "  -r      Remove ./.vimsession and ./.vimwindows"
                   print "  -s      Simple Mode:Open in a single window"
                   print "  -t      Only Windows Mode: Just open blank windows"
                   print ""
                   exit 0
                   ;;
    	esac
    done
    
    shift $(($OPTIND - 1))
    
## Example Integration: vi (simple model)

    #!/bin/bash
    Tmp="/tmp/$$"
    TmpDir="/tmp/dir$$"
    trap 'rm -f "$Tmp" >/dev/null 2>&1' 0
    trap "exit 2" 1 2 3 13 15
    rm $Tmp  >/dev/null 2>&1
    
    
    if [ $# -eq 0 ] ; then
            if [ -e "$VIMSESSION" ]; then
                 # vim -c "call LoadSession()"
                 vim 
            else
                 vim -c MRU
            fi
    else
            vim $1 $2 $3 $4
    fi
