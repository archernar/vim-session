# vim-session
Simple Vim session management

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
    
    print() {
        echo "$1"
    }
    
    
    while getopts "fabcersthmx:" arg
    do
    	case $arg in
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
                r) rm ./.vimsession
                   rm ./.vimwindows
                   exit 0
                   ;;
                s) vim -c "call LoadSession('.vimsession','e')"
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
                e) vim  ./.vimsession ./.vimwindows
                   exit 0
                   ;;
                h) print "vit"
                   print "  -a  side/side window layout"
                   print "  -b  up/down window layout"
                   print "  -c  up/mid/down window layout"
                   print "  -e  Edit ./.vimsession ./.vimwindows"
                   print "  -f  copy ./.vimsession to ./.vimwindows (and call vit)"
                   print "  -m  Simple Mode with MRU"
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
        vim -c "call LoadSessionT('$VIMSESSION','$VIMWINDOWS','e','')"
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
## session.vim
<pre><code>" ====================================================================================
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
    while l:c &lt;= 16
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
    echom l:sz
endfunction


function! LoadSessionT(...)
    let l:sz = ""
    let l:szW = ""
    let l:c = 0

    let l:splits = ($VIMWIN == "") ? "vsplit | split | vertical resize 33" : $VIMWIN
    if (a:0 &gt; 3)
        let l:splits = ((a:4 == "") ? l:splits : a:4)
    endif
    exe l:splits . " | exe '1wincmd w'"

    if (a:0 == 0)
        return
    endif

    let l:sz = "No " . a:1
    let l:readable = filereadable(a:1)
    if ( l:readable )
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
            let l:readable = filereadable(a:2)
            if ( l:readable )
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
    while l:c &lt;= 16
        if (bufexists(l:c))
            let l:readable = filereadable(bufname(l:c))
            if (l:readable)
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
