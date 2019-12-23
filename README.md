# vim-session
Simple Vim session management

## Screen Shot
![alt text](https://github.com/archernar/vim-session/blob/master/images/session.png "Session.vim")

## session.vim
<pre><code>" ====================================================================================
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
    while l:c &lt;= 64 
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
" ------------------------------------------
" LoadSession(...)
" a:1 is the session file filename
" a:2 is the command to apply to files
"     default is 'e'
" ------------------------------------------
function! LoadSession(...)
    let l:filecmd = (a:0 &gt; 1) ? a:2 : "e"
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
    echom l:sz
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
    let l:filecmd = (a:0 &gt; 2) ? a:3 : "e"
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

    if (a:0 &gt; 3)
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
    while l:c &lt;= 64 
        if (bufexists(l:c))
            if (filereadable(bufname(l:c)))
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
    call writefile(l:body,    (a:0 &gt; 0) ? a:1 : ".vimsession")
    call writefile(l:winbody, (a:0 &gt; 1) ? a:2 : ".vimwindows")
    echom "session written"
endfunction
</code></pre>
<pre><code>" *****************************************************************************************************
                "  dir.vim - a Simple Directory Lister/File Opener
                " *************************************************************************************
" Notes
" There are several name spaces for variables.
" 
" (nothing)            In a function: local to a function; otherwise: global
" |buffer-variable|    b:     Local to the current buffer.
" |window-variable|    w:     Local to the current window.
" |tabpage-variable|   t:     Local to the current tab page.
" |global-variable|    g:     Global.
" |local-variable|     l:     Local to a function.
" |script-variable|    s:     Local to a |:source|'ed Vim script.
" |function-argument|  a:     Function argument (only inside a function).
" |vim-variable|       v:     Global, predefined by Vim.
" *****************************************************************************************************
call g:MyCommandMapper("command! DIR :call g:MyDirPwd(0)")
call g:MyCommandMapper("command! DIRC :call g:MyDirPwd(1)")
call g:MyCommandMapper("command! SESSIONLIST :call g:ListBuffers()")

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
    return  split(a:1," ")[-1]
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
        call g:NewWindow("Left", &amp;columns/3, "&lt;Enter&gt; :call g:MyDirAction('e')","s :call g:MyDirAction('vnew')", "b :call g:MyDirAction('split')")
        let s:DirWindow = winnr()
        nnoremap &lt;silent&gt; &lt;buffer&gt; f /^f&lt;cr&gt;
        echom "&lt;enter&gt; to edit, &lt;s&gt; to edit in Vert-Split, &lt;b&gt; to edit in Horz-Split"
    " Display Part
        setlocal cursorline
        call s:PutLineSet(1)

        call s:PutLine("[" . s:DirSet . "]")
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
        resize 155
endfunc

function! g:ListBuffers()
    let l:c=1
    call g:NewWindow("Left", &amp;columns/3, "")
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

" *****************************************************************************************************
                "  Global/Public Functions
                " *************************************************************************************
function! g:MyDirPwd(...)
    let s:DirCloseWindow = a:1
    let s:DirEditWindow = winnr()
    call s:DirSetPwd() 
    call s:MyDir("." . s:DirMask)
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
             if ( isdirectory(s:DirSet . "/" . l:sz) == 0 )
                 if (s:DirCloseWindow == 1)
                     silent execute "q"
                 endif
                 exe s:DirEditWindow+1 . "wincmd w"
                 silent execute a:1 . " " . "" . s:DirSet . "/" .l:sz . ""
                 if (s:DirCloseWindow == 0)
                     exe s:DirWindow . "wincmd w"
                 endif
             else
                 silent execute "q"
                 call s:DirSetInto(l:sz)
                 call s:MyDir(s:DirSet . s:DirMask)
             endif
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
    
    VIMSESSIONDEFAULT=~/.vimsessiondefault
    VIMSESSION=.vimsession
    VIMWINDOWS=.vimwindows
    VIMLAYOUT=.vimlayout
    VIMNOSPLITS=.vimnosplits
    
    print() {
        echo "$1"
    }
    
    while getopts "nfabcersthmx:" arg
    do
    	case $arg in
                 n) if [ -a "$VIMNOSPLITS" ] ; then
                         rm -rf "$VIMNOSPLITS"
                         print "splits"
                    else
                         touch "$VIMNOSPLITS"
                         print "no splits"
                    fi
                    exit 0
                    ;;
                f) cp "$VIMSESSION" "$VIMWINDOWS"
                   vim -c "call LoadSessionT('$VIMSESSION','$VIMSESSION','e','')"
                   exit 0
                   ;;
                a) vim -c "call LoadSessionT('$VIMSESSION','$VIMWINDOWS','e','vsplit')"
                   exit 0
                   ;;
                b) vim -c "call LoadSessionT('$VIMSESSION','$VIMWINDOWS','e','split')"
                   exit 0
                   ;;
                c) vim -c "call LoadSessionT('$VIMSESSION','$VIMWINDOWS','e','split | split')"
                   exit 0
                   ;;
                r) rm -f $VIMSESSION
                   rm -f $VIMWINDOWS
                   rm -f $VIMLAYOUT
                   exit 0
                   ;;
                s) vim -c "call LoadSession('$VIMSESSION','e')"
                   exit 0
                   ;;
                x) 
                            case $OPTARG in
                                a) vim -c "call LoadSessionT('$VIMSESSION','$VIMWINDOWS','e','vsplit')"
                                   ;;
                                b) vim -c "call LoadSessionT('$VIMSESSION','$VIMWINDOWS','e','split')"
                                   ;;
                                c) vim -c "call LoadSessionT('$VIMSESSION','$VIMWINDOWS','e','split | split')"
                                   ;;
                                *) vim -c "call LoadSessionT('$VIMSESSION','$VIMWINDOWS','e','$OPTARG')"
                                   ;;
                            esac
                   exit 0
                   ;;
                m) vim -c MRU
                   exit 0
                   ;;
                t) vim -c "call LoadSessionT()"
                   exit 0
                   ;;
                e) vim  $VIMSESSION $VIMWINDOWS
                   exit 0
                   ;;
                h) print "vit"
                   print "  -a  side/side window layout"
                   print "  -b  up/down window layout"
                   print "  -c  up/mid/down window layout"
                   print "  -e  Edit ./.vimsession ./.vimwindows"
                   print "  -f  copy ./.vimsession to ./.vimwindows (and call vit)"
                   print "  -m  Simple Mode with MRU"
                   print "  -n  Toggle no-splits flag"
                   print "  -h  Help"
                   print "  -r  Remove ./.vimsession and ./.vimwindows"
                   print "  -s  Simple Mode:Open in a single window"
                   print "  -t  Only Windows Mode: Just open blank windows"
                   print ""
                   print "  -x  <layout>"
                   print ""
                   print "      layouts:"
                   print "      a - side/side, b - up/down c - up/mid/down"
                   print ""
                   exit 0
                   ;;
    	esac
    done
    
    shift $(($OPTIND - 1))
    
    if [ $# -eq 0 ]; then
              if [ -a "$VIMNOSPLITS" ] ; then
                   vim -c "call LoadSession('$VIMSESSION','e')"
              else
                  vim -c "call LoadSessionT('$VIMSESSION','$VIMWINDOWS','e','')"
              fi
    else
        vim $1 $2 $3 $4
    fi
    
## Example Integration: vi (simple model)

    #!/bin/bash
    Tmp="/tmp/$$"
    TmpDir="/tmp/dir$$"
    trap 'rm -f "$Tmp" >/dev/null 2>&1' 0
    trap "exit 2" 1 2 3 13 15
    rm $Tmp  >/dev/null 2>&1
    
    VIMSESSIONDEFAULT=~/.vimsessiondefault
    VIMSESSION=.vimsession
    VIMWINDOWS=.vimwindows
    
    # vim -c "call LoadSessionT('$VIMSESSION','$VIMWINDOWS','e','vsplit')"
    
    if [ $# -eq 0 ] ; then
            if [ -e "$VIMSESSION" ]; then
                 vim -c "call LoadSession('.vimsession','e')"
            else
                 vim -c MRU
            fi
    else
            vim $1 $2 $3 $4
    fi
