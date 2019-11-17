# vim-session
Simple Vim session management

## Example Integration:  vit

    #!/bin/bash
    Tmp="/tmp/$$"
    TmpDir="/tmp/dir$$"
    trap 'rm -f "$Tmp" >/dev/null 2>&1' 0
    trap "exit 2" 1 2 3 13 15
    rm $Tmp  >/dev/null 2>&1
    
    VIMSESSIONDEFAULT=~/.vimsessiondefault
    VIMSESSION=.vimsession
    VIMWINDOWS=.vimwindows
    
    while getopts "abcersthmx:" arg
    do
    	case $arg in
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
                   print " -a  layout a"
                   print " -b  layout b"
                   print " -c  layout c"
                   print " -e  Edit ./.vimsession ./.vimwindows"
                   print " -m  Simple Mode with MRU"
                   print " -h  Help"
                   print " -r  Remove ./.vimsession and ./.vimwindows"
                   print " -s  Simple Mode:Open in a single window"
                   print " -t  T Window Mode: Just open T window panes"
                   print " -x  <layout>"
                   print ""
                   print "     layouts:"
                   print "     a - side/side, b - up/down c - up/mid/down"
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
    
## Example Integration: simple model

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
