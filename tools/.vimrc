" *****************************************************************************************************
                "  W e l c o m e   t o   m y  V I M R C
                " *************************************************************************************
" Notes
" There are several name spaces for variables.
" 
" (nothing)            In a function: local to a function; otherwise: global
" |buffer-variable|    b:	  Local to the current buffer.
" |window-variable|    w:	  Local to the current window.
" |tabpage-variable|   t:	  Local to the current tab page.
" |global-variable|    g:	  Global.
" |local-variable|     l:	  Local to a function.
" |script-variable|    s:	  Local to a |:source|'ed Vim script.
" |function-argument|  a:	  Function argument (only inside a function).
" |vim-variable|       v:	  Global, predefined by Vim.
" nnoremap <F4> :new<cr>:-1read $HOME/.vim/ksh.top<CR>
" *****************************************************************************************************
function! Head()
   let l:one="\" ***************************************************************************************************"
   let l:two="\"               * "
   let l:three="\"               *************************************************************************************"
   let l:szIn = input('header text >> ')
   let l:currentLine   = getline(".")
   echom l:szIn
   call setline(l:currentLine+1, l:one)
   call setline(l:currentLine+2, l:two . l:szIn)
   call setline(l:currentLine+3, l:three)
endfunction
" *****************************************************************************************************
                " External Environments Variables
                " *************************************************************************************
" VIM_VIMTIPS                     - Full pathname of the vimtips file
" VIM_COMMANDER                   - Full pathname of the vim commander file
" VIM_PDFLIB                      - Folder name of PDF library
" VIM_S3                          - S3 bucket

set splitbelow
set splitright

set cmdheight=3                   " Set the command window height to 2 lines, to avoid many cases of having to  press <Enter> to continue
set nowrap
set nocompatible
" set relativenumber
set hidden                        " Will switch to next buffer without raising an error
set foldcolumn=3
set foldmethod=marker
set foldlevelstart=20
set ruler                         " Display the cursor position on the last line of the screen or in the status line of a window
set number                        " Display line numbers on the left
set wildmenu                      " Better command-line completion
set showcmd                       " Show partial commands in the last line of the screen
set ignorecase                    " Use case insensitive search, except when using capital letters
set smartcase
" set hlsearch incsearch          " Highlight searches (use <C-L> to temporarily turn off highlighting; see the mapping of <C-L> below)
set backspace=indent,eol,start    " Allow backspacing over autoindent, line breaks and start of insert action
set nostartofline                 " Stop certain movements from always going to the first character of a line.
set laststatus=2                  " Always display the status line, even if only one window is displayed
set undodir=~/.vim/undodir
set undofile
" *****************************************************************************************************
                " Indent and Tab  Setup
                " *************************************************************************************
" There are in fact four main methods available for indentation, each one
" overrides the previous if it is enabled, or non-empty for 'indentexpr':
" 'autoindent'	uses the indent from the previous line.
"               When opening a new line and no filetype-specific indenting is enabled, keep same indent as line currently on.
" 'smartindent'	is like 'autoindent' but also recognizes some C syntax to
" 		increase/reduce the indent where appropriate.
" 'cindent'	Works more cleverly than the other two and is configurable to
" 		different indenting styles.
" 'indentexpr'	The most flexible of all: Evaluates an expression to compute
" 		the indent of a line.  When non-empty this method overrides
" 		the other ones.  See |indent-expression|.
set cindent                       
set shiftwidth=4                  " Indent settings for using 4 spaces instead of tabs.  Do not change 'tabstop' from its default value of 8 
set softtabstop=4                 " with this setup.
set expandtab
" *****************************************************************************************************
                " Syntax Highlighting
                " *************************************************************************************
syntax off

set confirm                       " Instead of failing a command because of unsaved changes, raise a dialogue asking to save changed files.
set visualbell                    " Use visual bell instead of beeping when doing something wrong
set t_vb=
                                  " reset terminal code for visual bell. 
                                  " If visualbell is set, and this line is also included, vim will neither flash nor beep.
                                  " If visualbell is unset, this does nothing.
let mapleader = " "               " Leader - ( Spacebar )
let MRU_Auto_Close = 1            " Set MRU window to close after selection
set notimeout ttimeout ttimeoutlen=200         " Quickly time out on keycodes, but never time out on mappings

" *****************************************************************************************************
                                  " The 'External Command' Command Setup
                                  " *******************************************************************
command! -nargs=* -complete=shellcmd H new  | let w:scratch = 1 | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>
command! -nargs=* -complete=shellcmd BANG botright 60vnew | let w:scratch = 1 | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>
command! -nargs=1 L silent call Redir(<f-args>)
command! -nargs=1 P !xdg-open "<f-args>" >/dev/null 2>&1
command! -nargs=1 JDOC !jdoc "<f-args>" >/dev/null 2>&1
command! -nargs=1 HH vnew <args>
command! -nargs=1 EE vnew <args>
command! -nargs=1 E vnew <args>
command! -nargs=1 VV new <args>
command! -nargs=1 V new <args>
" Usage:
"       :Redir hi ............. show the full output of command ':hi' in a scratch window
"       :Redir !ls -al ........ show the full output of command ':!ls -al' in a scratch window

" *****************************************************************************************************
                                  " Pre Vundle Setup
                                  " *******************************************************************
filetype off

" let NOVUNDLE = 1
if !exists("NOVUNDLE")
" *****************************************************************************************************
                                  " Vundle            - see :h vundle for more details or wiki for FAQ
                                  " *******************************************************************
                                  " git clone  https://github.com/VundleVim/Vundle.vim.git  ~/.vim/bundle/Vundle.vim
                                  " :PluginList       - lists configured plugins
                                  " :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
                                  " :PluginUpdate     - <leader>p
                                  " :PluginSearch foo - searches for foo; append `!` to refresh local cache
                                  " :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"         Bundle 'fxn/vim-monochrome'
                                  " *******************************************************************
set rtp+=~/.vim/bundle/Vundle.vim " Vundle BEGIN
call vundle#begin()               " Vundle BEGIN
                                  " *******************************************************************
Plugin 'VundleVim/Vundle.vim'
Plugin 'archernar/vim-map'
Plugin 'archernar/vim-utils'
Plugin 'archernar/vim-session'
Plugin 'archernar/vim-program'
Plugin 'archernar/vim-monochrome'
Plugin 'archernar/vim-mru'
Plugin 'archernar/vim-polymode'
Plugin 'archernar/vim-progsnips'
Plugin 'archernar/vimstuff'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'jeetsukumaran/vim-buffergator'
Plugin 'vim-scripts/grep.vim'      " https://github.com/vim-scripts/grep.vim
Plugin 'tpope/vim-surround'
Bundle 'Lokaltog/vim-monotone.git'
Bundle 'owickstrom/vim-colors-paramount'

"Plugin 'scrooloose/nerdtree.git'
"let g:NERDTreeNodeDelimiter = "\u00a0"
"call g:MyKeyMapper("nnoremap <Leader>nt :NERDTreeToggle<cr>","NERDTree Toggle")
"call g:MyCommandMapper("command! DOC     :NERDTree /usr/share/vim/vim74/doc")
"Plugin 'vim-airline/vim-airline'
"Plugin 'vim-airline/vim-airline-themes'
"Plugin 'kristijanhusak/vim-carbon-now-sh'
"Plugin 'Buffergator'
"Plugin 'tpope/vim-fugitive'
"Plugin 'mbbill/undotree'
"Plugin 'NLKNguyen/papercolor-theme'
"Plugin 'gmarik/github-search.vim'
"Plugin 'xolox/vim-misc'           " https://github.com/xolox/vim-misc 
"Plugin 'xolox/vim-notes'          " https://vimawesome.com/plugin/notes-vim
"Plugin 'wincent/scalpel'
"Plugin 'mhinz/vim-startify'
"Plugin 'yegappan/mru'
                                  " *******************************************************************
                                  " *******************************************************************
                                  " *******************************************************************
call vundle#end()                 " Vundle END 
endif                             " Vundle END
                                  " *******************************************************************
source ~/.vim/bundle/vim-utils/plugin/string.vim
source ~/.vim/bundle/vim-map/plugin/map.vim
                                  
                                  " *******************************************************************
filetype plugin indent on         " required, to ignore plugin indent changes, instead use: 
                                  " filetype plugin on
                                  " Put non-Plugin stuff after this line
let g:MyKeyDict = {} 
let g:MyKeyDictCT = 1000 
let g:MyCommandItemDict = {} 
let g:MyCommandItemCT = 1000 
let g:MyKeyMapperMode = "" 
"runtime plugin/vimmap.vim
call g:SetMyKeyMapperMode("STD")
" *****************************************************************************************************
                                  " Utility Functions
                                  " *******************************************************************

function! SaveQuitAll()
     execute "w"
     execute "qall!"
endfunction

function! QuitAll()
     execute "qall!"
endfunction

function! CallMan(...)
     execute "call " . a:1
     execute "call " . a:2
endfunction
function! CallMan3(...)
     execute "call " . a:1
     execute "call " . a:2
     execute "call " . a:3
endfunction
function! XMan(...)
     let l:pre = ""
     let l:x = 1
     let l:n = match(a:(l:x), '(')
     if (l:n > 0 )
          let l:pre = "call "
     endif
     execute l:pre . a:1

     let l:pre = ""
     let l:n = match(a:2, '(')
     if (l:n > 0 )
          let l:pre = "call "
     endif
     execute l:pre . a:2
endfunction

function! ExeMan(...)
     execute "" . a:1
     execute "" . a:2
endfunction
function! ExeMan3(...)
     execute "" . a:1
     execute "" . a:2
     execute "" . a:3
endfunction


function! VimKeyMap()
     redir! > ~/.vimkeymap.txt
     silent verbose map
     redir END
endfunction

function! Ls()
    ls
endfunction
function! Two() 
    vsplit 
endfunction
function! Tee() 
    split | vsplit | exe "1" . "wincmd w"
endfunction
function! TeeLeft() 
    vsplit | split | vertical resize 56 | exe "1" . "wincmd w"
endfunction

function! TwoTwo() 
    split 
endfunction
function! Three() 
    vsplit | vsplit
endfunction
function! Four() 
    new | vnew | wincmd w | wincmd w | vnew 
endfunction
                                  " *******************************************************************
                                  " END: Utility Functions

" :echo ['a', 'b', 'c', 'd', 'e'][0:2]
" Vim displays ['a', 'b', 'c'] (elements 0, 1 and 2). You can safely exceed the upper bound as well. Try this command:
" 
" :echo ['a', 'b', 'c', 'd', 'e'][0:100000]
" Vim simply displays the entire list.
" 
" Slice indexes can be negative. Try this command:
" 
" :echo ['a', 'b', 'c', 'd', 'e'][-2:-1]
" Vim displays ['d', 'e'] (elements -2 and -1).
" 
" When slicing lists you can leave off the first index to mean "the beginning" and/or the last index to mean "the end". Run the following commands:
" 
" :echo ['a', 'b', 'c', 'd', 'e'][:1]
" :echo ['a', 'b', 'c', 'd', 'e'][3:]
"  len(list)

function! Test()
        let l:sz="NO"
        let l:current_win = winnr()
        let l:current_buf = bufnr("%")
        let l:buf = bufname(bufnr("%"))
        let l:bnum = winbufnr(l:current_win)
        let l:sz= "NOTHING"

"         if getbufvar(l:bnum, '&buftype') == 'quickfix'
"             let l:sz="YES"
"         endif
"            'buftype' 'bt'          string (default: "")
"                            local to buffer
"                            {not in Vi}
"                            {not available when compiled without the |+quickfix| feature}
"            The value of this option specifies the type of a buffer:
"              <empty>       normal buffer
"              nofile        buffer which is not related to a file and will not be written
"              nowrite       buffer which will not be written
"              acwrite       buffer which will always be written with BufWriteCmd
"                            autocommands. {not available when compiled without the |+autocmd| feature}
"              quickfix      quickfix buffer, contains list of errors |:cwindow| or list of locations |:lwindow|
"              help          help buffer (you are not supposed to set this manually)
" 
        call g:NewWindow("Bottom",33)
        call PutBufferList()
endfunction

" function! Funcky()
"         call g:NewWindow("Right",33)
"         exe !gawk "'/^function/{$1="";sub(/^ /,\"\", $0);print "\" " $0}' %"
" endfunction




function! PutBufferList(...)
        let l:nn=1
        let l:c=1
        let l:sz=""
        let body=[]
        while l:c <=20 
            if (bufexists(l:c))
                let l:btyp = getbufvar(l:c, '&buftype')
                if (l:btyp == "")
                    let l:sz = bufname(l:c)
                    call add(body, l:sz)
                    call setline(l:nn, l:sz)
                    let l:nn= l:nn + 1
                endif
            endif
            let l:c += 1
        endwhile 
        call writefile(body, 'momo')
endfunction
function! SetArgs(...)
     " call SetArgs("A","B","D")
        for i in a:000
            echom i
        endfor
endfunction

" stringToCenter.PadLeft(((totalLength - stringToCenter.Length) / 2) + stringToCenter.Length)


function! Vimtips()
     call LeftWindowFile($VIM_VIMTIPS)
     nnoremap <silent> <buffer> s /^========<cr>zt
     nnoremap <silent> <buffer> d ?^========<cr>zt
     vertical resize 105 
     echom "Vimtips:   use <s> to page forward, <d> to page backward"
endfunction
" *****************************************************************************************************
                                  " MyKeyMapper 
                                  " *******************************************************************
let g:MyKeyList = []
let g:MyValueList = []
function! MyTest()
     let l:szKey = "abcd-no"
     let l:szKey = substitute(l:szKey, "^[cga]", "X", "")
     echom l:szKey
endfunction

" *****************************************************************************************************
                                  " Fast Quit All
                                  " *******************************************************************
nnoremap <silent> zz :wqa<cr>
" *****************************************************************************************************
                                  " Function Keys
                                  " *******************************************************************
" nnoremap <leader><F5> :call Colorlet(-1)<cr><esc>
" nnoremap <silent> <F5> :call SaveAndExecutePython()<CR>
" vnoremap <silent> <F5> :<C-u>call SaveAndExecutePython()<CR>
" nnoremap <leader><F6> :colorscheme pablo<cr>hi Visual   cterm=reverse<cr><esc>
" nnoremap <F8> :UndotreeToggle<cr>
" nnoremap <leader><F12> :call SaveAndExecuteGawk()<CR>
" *****************************************************************************************************
                                  " Leader Function Keys
                                  " *******************************************************************
nnoremap <silent> <leader><F2> :wincmd _<cr>:wincmd \|<cr>
nnoremap <silent> <leader><F3> :wincmd =<cr>
nnoremap <silent> <leader><F4> :CtrlPBuffer<cr>
" *****************************************************************************************************
                                  " Leader Keys
                                  " *******************************************************************
nnoremap <leader>] *
nnoremap <Leader>' diwi""<ESC>hp<ESC>
call g:MyKeyMapper("nnoremap <Leader>p  :PluginUpdate<cr>","Vundle Update")
call g:MyKeyMapper("nnoremap <Leader>d  :! rm -rf /tmp/dotfiles;git clone http://github.com/archernar/dotfiles.git /tmp/dotfiles;<cr>","fetch .vimrc update")

call g:MyKeyMapper("nnoremap <leader>ev :split $MYVIMRC<cr>","Split Edit .vimrc")
nnoremap <leader>-  :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>=  :wincmd =<cr>
call g:MyKeyMapper("nnoremap <leader>l :resize -5<cr>","Window Resize +")
call g:MyKeyMapper("nnoremap <leader>m :resize +5<cr>","Window Resize -")
nnoremap <leader>g  :silent execute "grep! -R " . shellescape(expand("<cWORD>")) . " ."<cr>:copen<cr>
nnoremap <leader>h  :silent execute "help " . expand("<cWORD>")<cr> 
nnoremap <leader>w :call Smash()<cr>



let g:greppy_mode_active = 0
function! Greppyon(...)
    execute "ccl"
    if a:0 > 0 
         let s:szIn = input('grep for >> ')
         execute "vimgrep /" . s:szIn . "/ %"
         echom "vimgrep /" . s:szIn . "/ %"
    else
         execute "vimgrep /" . expand("<cword>") . "/ %"
         echom "vimgrep /" . expand("<cword>") . "/ %"
    endif
    execute "cw"
    execute "resize 10"
    call BiModeSet(0)
    let g:greppy_mode_active = 1
endfunction
function! Greppyoff()
    execute "ccl"
    let g:greppy_mode_active = 0
endfunction
" *****************************************************************************************************
                                  " Things To Learn (TTL)  
                                  " *******************************************************************
let g:MyTTLList = []
function! MyTTLDump()
        call LeftWindowBuffer()
        nnoremap <silent> <buffer> q :close<cr>
        let l:nn=1
        call setline(l:nn, g:CenterPad("Things to Learn"))
        let l:nn=2
	for l:item in g:MyTTLList
          call setline(l:nn, l:item)
          let l:nn= l:nn + 1
	endfor
        vertical resize 120 
endfunction
" *****************************************************************************************************
                                  " MyCommandsheet 
                                  " *******************************************************************
let g:MyCommandsheetList = []
function! g:MyCommandsheet(...)
     call add(g:MyCommandsheetList, a:1)
endfunction
function! MyCommandsheetDump()
        nnoremap <silent> <buffer> q :close<cr>
        let l:nn=1
        let l:new_list = deepcopy(g:MyCommandsheetList)
        call sort(l:new_list)
	for item in l:new_list
          call setline(l:nn, item)
          let l:nn= l:nn + 1
	endfor
        vertical resize 120 
        setlocal readonly nomodifiable
endfunction
" *****************************************************************************************************
                                  " MyCheatsheet 
                                  " if (l:szCommand[0:0] == "!")
                                  " *******************************************************************
let g:MyQuickList = []
let g:MyCheatsheetList = []
function! MyCheatsheetEnter()
     let l:szLine  = getline(".")
     let l:szKey   = substitute(l:szLine, " .*", "", "")
     if ( l:szKey == "COM")
         let l:szValue = substitute(l:szLine, "COM *", "", "")
         let l:szValue = substitute(l:szValue, ">>.*", "", "")
         echom l:szValue
         execute "normal q"
         execute l:szValue
     endif
     if ( l:szKey == "TXT")
         let l:szValue = substitute(l:szLine, "TXT *", "", "")
         let l:szValue = substitute(l:szValue, ">>.*", "", "")
         call cursor(1, 1)
         execute "normal! gg"
         execute "normal! dG"
         execute "r " . l:szValue
         echom l:szValue[0:3]
         setlocal nocursorline
     endif
     if ( l:szKey == "PDF")
         let l:szValue = substitute(l:szLine, "PDF *", "", "")
         let l:szValue = substitute(l:szValue, ">>.*", "", "")
         echom l:szValue
         execute "silent !xdg-open " . l:szValue . " >/dev/null 2>&1"
         execute "redraw!"
         execute "normal q"
         setlocal nocursorline
     endif
     if ( l:szKey == "MP3")
         let l:szValue = substitute(l:szLine, "MP3 *", "", "")
         let l:szValue = substitute(l:szValue, ">>.*", "", "")
         echom l:szValue
         execute "silent !xdg-open " . l:szValue . " >/dev/null 2>&1"
         execute "redraw!"
         execute "normal q"
         setlocal nocursorline
     endif
     if ( l:szKey[0:3] == "URL")
         let l:szValue = substitute(l:szLine, "URL *", "", "")
         let l:szValue = substitute(l:szValue, ">>.*", "", "")
         echom l:szValue
         execute "silent !xdg-open " . l:szValue . " >/dev/null 2>&1"
         execute "redraw!"
         execute "normal q"
     endif

endfunction
function! g:QLA(...)
           call add(g:MyQuickList, a:1)
endfunction
function! g:QuickListAdd(...)
           call add(g:MyQuickList, a:1)
endfunction


function! g:CS(...)
     if ( a:0 == 1)
          let l:a2 = ""
     endif
     if ( a:0 == 2)
          let l:a2 = a:2
     endif
     let l:line =  a:1 . " ,,, " . l:a2 . "!!!!@@@@"
     call add(g:MyCheatsheetList, l:line)
endfunction

function! g:TTL(...)
     if ( a:0 == 1)
          call add(g:MyTTLList, a:1)
     endif
endfunction

function! g:CS1(...)
     for i in a:000
          let l:line =  i . "!!!!@@@@"
          call add(g:MyCheatsheetList, l:line)
     endfor
endfunction
function! g:CS2(p1,p2)
     let l:line =  a:p1 . "!!!!" . a:p2 ."@@@@"
     call add(g:MyCheatsheetList, l:line)
endfunction
function! g:CS3(p1,p2,p3)
     let l:line =  a:p1 . "!!!!" . a:p2 . "@@@@>>" . a:p3
     call add(g:MyCheatsheetList, l:line)
endfunction
function! g:MyCheatsheet(...)
     if ( a:0 == 3)
           let l:line =  a:1 . "!!!!" . a:2 . "@@@@>>" . a:3
     endif
     if ( a:0 == 2)
          let l:line =  a:1 . "!!!!" . a:2 ."@@@@"
     endif
     if ( a:0 == 1)
          let l:line =  a:1 . "!!!!@@@@"
     endif
     call add(g:MyCheatsheetList, l:line)
endfunction
function! MyQuickListDump()
        call LeftWindowBuffer()
        nnoremap <silent> <buffer> q :close<cr>
        nnoremap <silent> <buffer> <F10> :close<cr>
        let l:nn=1
	for item in g:MyQuickList
             call setline(l:nn, item)
             let l:nn= l:nn + 1
	endfor
        vertical resize 120 
endfunction

function! MyCheatsheetDump()
        call LeftWindowBuffer()
        nnoremap <silent> <buffer> q :close<cr>
        nnoremap <silent> <buffer> <F10> :close<cr>
        let l:nn=1
	for item in g:MyCheatsheetList
          let l:szKey   = substitute(item, "!!!!.*", "", "")
          let l:szDesc  = substitute(item, ".*@@@@", "", "")
          let l:szValue = substitute(item, ".*!!!!", "", "")
          let l:szValue  = substitute(l:szValue, "@@@@.*", "", "")

          if (l:szValue == "" )
               let l:n = match(l:szKey,',,,')
               if (l:n > 0 )
                    let l:szPart1 = strpart(l:szKey, 0, n)
                    let l:szPart2 = strpart(l:szKey, n)
                    let l:szPart1 = Trimmer(l:szPart1, ",,," )
                    let l:szPart2 = Trimmer(l:szPart2, ",,," )
                    let l:line=g:Pad(l:szPart1,(g:LW/2)-3) . " | " . l:szPart2
               else
                    let l:line=l:szKey
               endif
          else
               let l:line=l:szKey . repeat(' ', 6-len(l:szKey)) . l:szValue . repeat('%', 52-len(l:szValue)) . l:szDesc
          endif
          let l:n = match(l:line,'-------')
          if (l:n == -1 )
               let l:line = strpart(l:line, 0, g:LW-2)
          endif
          call setline(l:nn, l:line)
          let l:nn= l:nn + 1
	endfor
        vertical resize 120 
        nnoremap <silent> <buffer> <Enter> :call MyCheatsheetEnter()<cr>
"       setlocal readonly nomodifiable
endfunction
let g:LW = 110
let s:barline = repeat('-', g:LW)
" *****************************************************************************************************
                                  " TTL Items
                                  " *******************************************************************
call g:TTL("zt   puts current line to top of screen")
call g:TTL("z.   puts current line to center of screen ")
call g:TTL("zz   puts current line to center of screen ")
call g:TTL("zb   puts current line to bottom of screen")
call g:TTL("y$   yank till the end of line")
call g:TTL("ys<motion><char>   Surround")
call g:TTL("yss<char>          Surround current line")
call g:TTL("VMODE S<char>      Surround current selection")




" *****************************************************************************************************
                                  " My Cheat Sheet Items
                                  " *******************************************************************
call g:MyCheatsheet(g:CenterPad(""))
call g:MyCheatsheet(g:CenterPad("My Cheat Sheet"))
call g:MyCheatsheet(g:CenterPad(" "))
call g:MyCheatsheet(s:barline)
call g:MyCheatsheet(g:CenterPad("i3wm"))
call g:MyCheatsheet(g:CenterPad(" "))
call g:MyCheatsheet("Controlling i3")
call g:MyCheatsheet("$mod+Shift+r            Reload i3")
call g:MyCheatsheet("$mod+Shift+e            Exit i3")
call g:MyCheatsheet("-")
call g:MyCheatsheet("Manage Windows")
call g:MyCheatsheet("$mod+Shift+q            Kill current window")
call g:MyCheatsheet("$mod+Shift+num          Move current window to workspace number num")
call g:MyCheatsheet("$mod+Shift+f            Set window to floating mode")
call g:MyCheatsheet("$mod+j                  Focus on window to the left")
call g:MyCheatsheet("$mod+k                  Focus on window above")
call g:MyCheatsheet("$mod+l                  Focus on window below")
call g:MyCheatsheet("$mod+;                  Focus on window to the right")
call g:MyCheatsheet("$mod+Shift+j            Move window left")
call g:MyCheatsheet("$mod+Shift+k            Move window up")
call g:MyCheatsheet("$mod+Shift+l            Move window down")
call g:MyCheatsheet("$mod+Shift+;            Move window right")
call g:MyCheatsheet("-")
call g:MyCheatsheet("Workspaces")
call g:MyCheatsheet("$mod+num                Switch to workspace num")
call g:MyCheatsheet("$mod+Shift+num          Move current window to workspace number num")
call g:MyCheatsheet("-")
call g:MyCheatsheet("Containers")
call g:MyCheatsheet("$mod+e                  Default container")
call g:MyCheatsheet("$mod+h                  Horizontal split container")
call g:MyCheatsheet("$mod+v                  Vertical split container")
call g:MyCheatsheet("$mod+w                  Tabbed container")
call g:MyCheatsheet("$mod+f                  Toggle fullscreen mode")
call g:MyCheatsheet("$mod+s                  Toggle stacking mode")
call g:MyCheatsheet("$mod+Shift+Space        Toggle floating mode")
call g:MyCheatsheet("-")
call g:MyCheatsheet("Applications")
call g:MyCheatsheet("$mod+enter              Open new terminal window")
call g:MyCheatsheet("$mod+d                  Open dmenu")

call g:MyCheatsheet(s:barline)

call g:MyCheatsheet(g:CenterPad("Plaintext Text Objects - Words"))
call g:MyCheatsheet(g:CenterPad("<number><command><text object or motion>"))
call g:CS("aw   a word (with white space)",           "iw   inner word")
call g:CS("ab   a block from [( to ]) (with braces)", "ib   inner block")
call g:CS("ap   a paragraph (with white space)",      "ip   inner paragraph")
call g:CS("as   a sentence (with white space)",       "is   inner sentance")
call g:CS("at   a tag block (with white space)",      "it   inner tag")

call g:CS("a\"   double quoted string",               "i\"   double quoted string without the quotes")
call g:CS("a\'   single quoted string",                "i\'   single quoted string without the quotes")


call g:MyCheatsheet(s:barline)
call g:MyCheatsheet("zt  puts current line to top of screen             ,,,    z. or zz puts current line to center of screen")
call g:MyCheatsheet("zb  puts current line to bottom of screen          ,,,")
call g:MyCheatsheet(s:barline)
call g:MyCheatsheet("i   Enter insert mode at cursor                    ,,,    I   Enter insert mode at first non-blank char")
call g:MyCheatsheet("s   Delete char under cursor enter i-mode          ,,,    S   Delete line & insert @ begin of same line")
call g:MyCheatsheet("a   Enter insert mode _after_ cursor               ,,,    A   Enter insert mode at the end of the line")
call g:MyCheatsheet("o   Enter insert mode on the next line             ,,,    O   rEenter insert mode on the above line")
call g:MyCheatsheet("C   Delete from cursor to EOL & begin insert       ,,,")
call g:MyCheatsheet(s:barline)
call g:MyCheatsheet("dw  delete to the next word                        ,,,    dt  delete until next comma on the curline")
call g:MyCheatsheet("de  delete to the end of the current word          ,,,    d2e delete to the end of next word")
call g:MyCheatsheet("dj  delete down a line (current and one below      ,,,    dt) delete up until next closing parenthesis")
call g:MyCheatsheet(s:barline)
call g:MyCheatsheet("                     d/rails delete up until the first of 'rails'")
call g:MyCheatsheet(s:barline)
call g:MyCheatsheet(g:CenterPad("Motions"))
call g:MyCheatsheet("h,l  move left/right by character                  ,,,    w   move forward one (w)ord")
call g:MyCheatsheet("b    move (b)ackward one word                      ,,,    e   move forward to the (e)nd of a word")
call g:MyCheatsheet("aw   a word (surrounding white space)              ,,,    iw  inner word (not surrounding white space)")
call g:MyCheatsheet(s:barline)
call g:MyCheatsheet("()    Sentences (delimited words)                  ,,, {}   Paragraphs (Next empty line)")
call g:MyCheatsheet(";     Repeat last motion forward                   ,,, ,    Repeat last motion backward")
call g:MyCheatsheet("<#>G  Go to Line #                                 ,,, gg   Go to the top of the file")
call g:MyCheatsheet("]]    Next section                                 ,,, [[   Previous section")
call g:MyCheatsheet("0     Front of line                                ,,, ^    Front of line (first non-blank)")
call g:MyCheatsheet("%     Matching brace/bracket/paren/tag             ,,, $    End of line")

call g:MyCheatsheet(g:CenterPad("Variable Scope"))
call g:MyCheatsheet("nothing      In a function: local to a function; otherwise: global")
call g:MyCheatsheet("buffer  b:   Local to the current buffer           ,,,window   w:   Local to the current window")
call g:MyCheatsheet("vim     v:   Global, predefined by Vim             ,,,tabpage  t:   Local to the current tab page")
call g:MyCheatsheet("global  g:   Global                                ,,,local    l:   Local to a function")
call g:MyCheatsheet("script  s:   Local to |:src|'ed Vim script         ,,,fun-arg  a:   Function argument (inside a function)")
call g:MyCheatsheet(s:barline)

call g:MyCheatsheet(g:CenterPad("Commands"))
call g:MyCheatsheet("COM", "call CommanderList()")
call g:MyCheatsheet("COM", "call CommanderListEdit()")
call g:MyCheatsheet(s:barline)
call g:MyCheatsheet(g:CenterPad("Documents"))
call g:MyCheatsheet("PDF","~/pdfs/vim-sq.pdf", "The Vim Tutorial and Reference")
call g:MyCheatsheet("PDF","~/vimdocs/gnuplot4_6.pdf", "GnuPlot 4.6 Documentation")
call g:MyCheatsheet("PDF","~/vimdocs/progit.pdf","Pro Git Book")
call g:MyCheatsheet("PDF","~/vimdocs/SpringBootInAction.pdf")
call g:MyCheatsheet("TXT","/usr/share/vim/vim74/doc/motion.txt","VIM Doc")
call g:MyCheatsheet("TXT","/usr/share/vim/vim74/doc/pattern.txt")
call g:MyCheatsheet("TXT","/usr/share/vim/vim74/doc/usr_27.txt")
call g:MyCheatsheet("TXT","/usr/share/vim/vim74/doc/usr_40.txt")
call g:MyCheatsheet("TXT","/usr/share/vim/vim74/doc/usr_41.txt","Write a VIM Script")
call g:MyCheatsheet("URL","https://www.youtube.com/watch?v=XA2WjJbmmoM","How to Do 90% of What Plugins Do (With Just Vim)")
call g:MyCheatsheet("URL","https://devhints.io/vimscript-functions","VimScript Functions")
call g:MyCheatsheet("URL","https://technotales.wordpress.com/2010/04/29/vim-splits-a-guide-to-doing-exactly-what-you-want/","spliting the way you want")

call g:MyCheatsheet(s:barline)
 

" *****************************************************************************************************
                                  " Command Words/Aliases
                                  " *******************************************************************
call g:MyCheatsheet(s:barline)
call g:MyCheatsheet(g:CenterPad("My Commands"))
call g:SetMyKeyMapperMode("SES")


call g:SetMyKeyMapperMode("COM")
call g:MyCommandMapper("command! CHEAT   :call MyCheatsheetDump()")
call g:MyCommandMapper("command! MI      :call MyCheatsheetDump()")
call g:MyCommandMapper("command! RC      :e ~/.vimrc")
call g:MyCommandMapper("command! LIB     :call PDFList()")
call g:MyCommandMapper("command! PDF     :call PDFList()")
call g:MyCommandMapper("command! MP3     :call MP3List()")
call g:MyCommandMapper("command! UMOTION :e /usr/share/vim/vim74/doc/motion.txt")
call g:MyCommandMapper("command! USER40  :e /usr/share/vim/vim74/doc/usr_40.txt")
call g:MyCommandMapper("command! U40     :e /usr/share/vim/vim74/doc/usr_40.txt")
call g:MyCommandMapper("command! USER41  :e /usr/share/vim/vim74/doc/usr_41.txt")
call g:MyCommandMapper("command! U41     :e /usr/share/vim/vim74/doc/usr_41.txt")
call g:MyCommandMapper("command! U27     :e /usr/share/vim/vim74/doc/usr_27.txt")
call g:MyCommandMapper("command! S3PUT   :call S3put()")
call g:MyCommandMapper("command! C       :call CommanderList()")
call g:MyCommandMapper("command! CE      :call CommanderListEdit()")
call g:MyCommandMapper("command! TEST    :call Test()")
call g:MyCommandMapper("command! XXCSD   :call CallMan('LeftWindowBuffer()', 'MyCommandsheetDump()')")
call g:MyCommandMapper("command! CSD     :call XMan('botright new', 'MyCommandsheetDump()')")
call g:MyCommandMapper("command! SNIPS   :call g:DD0(\"~/.vim/Snips/*\")"          )
call g:MyCommandMapper("command! REPOS   :call RepoList()")
call g:MyCommandMapper("command! TEE     :call Tee()")
call g:MyCommandMapper("command! TEELEFT :call TeeLeft()")
call g:MyCommandMapper("command! TWO     :call Two()")
call g:MyCommandMapper("command! TWOTWO  :call TwoTwo()")
call g:MyCommandMapper("command! THREE   :call Three()")
call g:MyCommandMapper("command! FOUR    :call Four()")
call g:MyCommandMapper("command! LS      :call Ls()")
call g:MyCommandMapper("command! GETVUNDLE     :!git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim")
call g:MyCommandMapper("command! TIPS    :call Vimtips()")
call g:MyCommandMapper("command! VT      :call Vimtips()")
call g:MyCommandMapper("command! TERM    :call Terminal()")
call g:MyCommandMapper("command! JAVAMAIN   :call JavaMain()")
call g:MyCommandMapper("command! XGAWK    :call SaveAndExecuteGawk()")
call g:MyCommandMapper("command! COLORLET :call Colorlet(-1)")
call g:MyCommandMapper("command! BE :call SetRegistersBE()")
call g:MyCommandMapper("command! KITEM    :call MyDictionaryDump(g:MyCommandItemDict)")
call g:MyCommandMapper("command! KALL     :call MyKeyMapperDump(g:MyKeyDict)")
call g:MyCommandMapper("command! KSTD     :call MyKeyMapperDump(g:MyKeyDict,'STD')")
call g:MyCommandMapper("command! KCOM     :call MyKeyMapperDump(g:MyKeyDict,'COM')")
call g:MyCommandMapper("command! KMRU     :call MyKeyMapperDump(g:MyKeyDict,'MRU')")
call g:MyCommandMapper("command! KPOLY    :call MyKeyMapperDump(g:MyKeyDict,'POLY')")
" Do the static entries here
call g:MyStaticMapper("R", "Execute command, output horozontal")
call g:MyStaticMapper("L", "Execute command, output vertical")
" blue.vim      default.vim  desert.vim evening.vim  morning.vim  pablo.vim
" README.txt  shine.vim torte.vim
" darkblue.vim  delek.vim    elflord.vim    koehler.vim  murphy.vim
" peachpuff.vim  ron.vim     slate.vim  zellner.vim
call g:SetMyKeyMapperMode("COLOR")
call g:MyCommandMapper("command! DARKBLUE :colorscheme darkblue")
call g:MyCommandMapper("command! MYCOLOR  :colorscheme pablo")
call g:MyCommandMapper("command! PABLO    :colorscheme pablo")
call g:MyCommandMapper("command! BLUE     :colorscheme blue")
call g:MyCommandMapper("command! SLATE    :colorscheme slate")
call g:MyCommandMapper("command! RON      :colorscheme ron")
call g:MyCommandMapper("command! DESERT   :colorscheme desert")
call g:MyCommandMapper("command! SHINE    :colorscheme shine")
call g:MyCommandMapper("command! EVENING  :colorscheme evening")
call g:MyCommandMapper("command! MONO     :colorscheme monochrome")
call g:MyCommandMapper("command! PARA     :set background=dark | colorscheme paramount")

call g:SetMyKeyMapperMode("MRU")
call g:MyStaticMapper("<Enter>","Select a file name to edit") 
call g:MyStaticMapper("o",        "Open file under cursor in new win")
call g:MyStaticMapper("<Sft-Ent>","Open file under cursor in new win")
call g:MyStaticMapper("w","Open a file in  read-only mode")
call g:MyStaticMapper("t","Open a file in a new tab")
call g:MyStaticMapper("u","Refresh MRU list")
call g:MyStaticMapper("q","Close the MRU window")
call g:MyStaticMapper("<Esc>","Close the MRU window")
call g:SetMyKeyMapperMode("STD")
function! Moe()
    set splitbelow splitright
    wincmd _ | wincmd |
    vsplit
    1wincmd h
    wincmd w
    wincmd _ | wincmd |
    split
    1wincmd k
    wincmd w
    set nosplitbelow
    set nosplitright
    wincmd t
    set winheight=1 winwidth=1
    exe 'vert 1resize ' . ((&columns * 79 + 79) / 159)
    exe '2resize ' . ((&lines * 18 + 20) / 41)
    exe 'vert 2resize ' . ((&columns * 79 + 79) / 159)
    exe '3resize ' . ((&lines * 18 + 20) / 41)
    exe 'vert 3resize ' . ((&columns * 79 + 79) / 159)
endfunction
" *****************************************************************************************************
                                  " Polymode Keys
                                  " *******************************************************************
call g:MyKeyMapper("nnoremap <Home> :call PolyMode(-1)<cr>",       "PolyMode On")
call g:MyKeyMapper("nnoremap <End>  :call PolyModeReset()<cr>",    "PolyMode Off")
let g:BiWindowMax = -1 
function! BiWindowMode()
     if (g:BiWindowMax == -1)
           let g:BiWindowMax = winwidth(0)
     endif
     if (winwidth(0) > g:BiWindowMax)
         vertical resize g:BiWindowMax
     else
         vertical resize 
     endif
         echo g:BiWindowMax
endfunction
let g:BiModeState = 1 
function! BiMode()
     if (g:BiModeState == 0)
          call BiModeSet(1)
     else
          call BiModeSet(0)
     endif
endfunction
function! BiModeSet(...)
     if (a:1 == 1)
          echo "BiModeSet(1) to Buffer"
          let g:BiModeState = 1 
          call g:MyKeyMapper("nnoremap <F1> :bnext<cr>", "Next Buffer")
          call g:MyKeyMapper("nnoremap <leader><F1>  <Nop>","Nothing")

          call g:MyKeyMapper("nnoremap <F2> :bprev<cr>", "Previous Buffer")
          call g:MyKeyMapper("nnoremap <leader><F2>  <Nop>","Nothing")

          call g:MyKeyMapper("nnoremap <F3> <Nop>","Nothing")
          call g:MyKeyMapper("nnoremap <leader><F3>  <Nop>","Nothing")
     endif
     if (a:1 == 0)
          echom "BiModeSet(0) to Window"
          let g:BiModeState = 0 
          call g:MyKeyMapper("nnoremap <F1> <C-W>w",     "Next Window")
          call g:MyKeyMapper("nnoremap <leader><F1>  :botright  new<CR>","Split Window Down")

          call g:MyKeyMapper("nnoremap <F2> <C-W>W",     "Previous Window")
          call g:MyKeyMapper("nnoremap <leader><F2>  :botright  new<CR>","Split Window Down")

          call g:MyKeyMapper("nnoremap <F3> <C-W>w",     "Next Window")
          call g:MyKeyMapper("nnoremap <leader><F3>  :vnew<CR>","Split Window Right")


"           call g:MyKeyMapper("nnoremap <leader>sw<left>  :topleft  vnew<CR>","Split Window Left")
"           call g:MyKeyMapper("nnoremap <leader>sw<right> :botright vnew<CR>","Split Window Right")
"           call g:MyKeyMapper("nnoremap <leader>sw<up>    :topleft  new<CR>","Split Window Up")
"           call g:MyKeyMapper("nnoremap <leader>sw<down>  :botright new<CR>","Split Window Down")
     endif
endfunction

function! PolyModeMapReset()
          "  call g:MyKeyMapper("nnoremap <F3> :MRU<cr>:call PolyModeReset()<cr>:call BufferLocalF3Quit()<cr>",   "MRU")
          " call g:MyKeyMapper("nnoremap <F3> :call SaveQuitAll()<cr>",             "Save and Quit All")
          let g:help0 = "<F1> NxB <F2> NxW <F3> SvQt <F4> Cmdr <F5> Cmd <F6> Grep <F9> PasteM <F10> Cht <F12> Bld <S-F1> TTL"
          let g:help1 = ""
          let g:help2 = ""
          call g:SetMyKeyMapperMode("STD")
          call g:MyKeyMapper("inoremap jj <esc>",                                 "Escape ReMapped",1)
"           call g:MyKeyMapper("nnoremap <F1> :bnext<cr>:call PolyModeReset()<cr>", "Next Buffer")
"           call g:MyKeyMapper("nnoremap <F2> <C-W>w:call PolyModeReset()<cr>",     "Next Window")
"           call g:MyKeyMapper("nnoremap <F3> :bnext<cr>:call PolyModeReset()<cr>", "Next Buffer")

          call g:MyKeyMapper("nnoremap <F4> :call BiMode()<cr>",                  "Window or Buffer Mode")
          call g:MyKeyMapper("nnoremap <F5> :CtrlPBuffer<cr>",                    "CtrlP Buffer List/Search")

"           call g:MyKeyMapper("nnoremap <F12> :wa<cr>:!build<cr>",                 "!build")
          call g:MyKeyMapper("nnoremap <F12> :call BiWindowMode()<cr>",               "BiWindowMode")


"         call g:MyKeyMapper("nnoremap <F5> :call Tcmd()<cr>",                    "TCmd")
"         call g:MyKeyMapper("nnoremap <F6> :call Greppyon()<cr>",                "Greppy First Form, word under cursor")
"         call g:MyKeyMapper("nnoremap <F7> :call Greppyon(1)<cr>",               "Greppy Second Form, prompt for word")
          call g:MyKeyMapper("nnoremap <F8> :call MyKeyMapperDump(g:MyKeyDict)<cr>/^SNIP<cr>zt","MyKeyMapper Help")
          call g:MyKeyMapper("nnoremap <F9> :set paste!<cr>",                     "Toggle Paste Setting")
          call g:MyKeyMapper("nnoremap <F10> :CHEAT<cr>",                         "My Cheat Sheet")
          call g:MyKeyMapper("nnoremap <leader><F10> :DOC<cr>",                   "Vim Doc")
          call g:MyKeyMapper("nnoremap <leader><F1> :call MyTTLDump()<cr>",       "My Help",1)
          call g:MyKeyMapper("nnoremap <leader><F8> :call MyCheatsheetDump()<cr>","My Cheatsheet")
          call g:MyKeyMapper("nnoremap <leader><F9> :call MyQuickListDump()<cr>", "My QuickList")
          " call g:MyKeyMapper("nnoremap <leader><F12> lmaj0d$`ahp`ah",             "grabandtuck")
          call g:MyKeyMapper("nnoremap <leader><F12> lmaj0:s/^ *//<cr>0:s/ *$//<cr>0d$`ahpj0dd",            "grabandtuck")
          call g:MyKeyMapper("nnoremap <leader>` ys$\`",               "surround till EOL")
          call g:MyKeyMapper("nnoremap <silent> <End>  :call PolyModeReset()<cr>","PolyMode Off")
          " Window
"           call g:MyKeyMapper("nnoremap <leader>sw<left>  :topleft  vnew<CR>","Split Window Left")
"           call g:MyKeyMapper("nnoremap <leader>sw<right> :botright vnew<CR>","Split Window Right")
"           call g:MyKeyMapper("nnoremap <leader>sw<up>    :topleft  new<CR>","Split Window Up")
"           call g:MyKeyMapper("nnoremap <leader>sw<down>  :botright new<CR>","Split Window Down")
"           call g:MyKeyMapper("nnoremap <leader>sw<left>  :topleft  vnew<CR>","Split Window Left")
"           call g:MyKeyMapper("nnoremap <leader>sw<up>    :topleft  new<CR>","Split Window Up")

          call g:MyKeyMapper("nnoremap <leader>sw<right> :vsplit<CR>","Split Window Right")
          call g:MyKeyMapper("nnoremap <leader>sw<down>  :split<CR>","Split Window Down")
          call g:MyKeyMapper("nnoremap <leader>mw<left>  :vertical resize +20<cr>","Resize Window") 
          call g:MyKeyMapper("nnoremap <leader>mw<right> :vertical resize -20<cr>","Resize Window") 
          " Buffer  
          call g:MyKeyMapper("nnoremap <leader>sb<left>  :leftabove  vnew<CR>","Split Buffer Left")
          call g:MyKeyMapper("nnoremap <leader>sb<right> :rightbelow vnew<CR>","Split Buffer Right")
          call g:MyKeyMapper("nnoremap <leader>sb<up>    :leftabove  new<CR>","Split Buffer Up")
          call g:MyKeyMapper("nnoremap <leader>sb<down>  :rightbelow new<CR>","Split Buffer Down")
          call g:MyKeyMapper("nnoremap <leader>kb<down>  :bdelete!<CR>","Buffer Delete")
          " Close  
          call g:MyKeyMapper("nnoremap <leader>c  :close<CR>","Close Window")
          call g:MyKeyMapper("nnoremap <leader>q  :quit<CR>","Close Window")
          " Visual Mode  
          call g:MyKeyMapper("vnoremap <silent> <End> y:call BottomBuffer('~/snips.java')<cr>:set paste<cr>G$a<cr>===<cr>===<cr><esc>pG$a<cr><esc>:w<cr>:set nopaste<cr>","snip")
          nnoremap <silent> 1 1
          nnoremap <silent> 2 2
          nnoremap <silent> 3 3
          nnoremap <silent> a a
          nnoremap <silent> b b
          nnoremap <silent> c c
          nnoremap <silent> d d
          nnoremap <silent> e e
          nnoremap <silent> f f
          nnoremap <silent> g g
          nnoremap <silent> h h
          nnoremap <silent> j j
          nnoremap <silent> k k
          nnoremap <silent> l l
          nnoremap <silent> m m
          nnoremap <silent> o o
          nnoremap <silent> p p
          nnoremap <silent> q q
          nnoremap <silent> O O
          nnoremap <silent> r r
          nnoremap <silent> v v
          nnoremap <silent> s s
          nnoremap <silent> t t
          nnoremap <silent> n n
          nnoremap <silent> w w
          nnoremap <silent> ? ?
          nnoremap <silent> <Insert>   <Nop>
          nnoremap <silent> <Right>    <right>
          nnoremap <silent> <Left>     <left>
          nnoremap <silent> <Up>       <up>
          nnoremap <silent> <Down>     <down>
          nnoremap <silent> <PageUp>   <pageup>
          nnoremap <silent> <PageDown> <pagedown>
          nnoremap <silent> <Delete>   <delete>
          call g:MyKeyMapper("nnoremap <silent> = :vertical resize +2<cr>","Vertical Resize +")
          call g:MyKeyMapper("nnoremap <silent> + :vertical resize -2<cr>","Vertical Resize -")
          call g:MyKeyMapper("nnoremap <silent> - :resize +2<cr>","Horozontal Resize +")
          call g:MyKeyMapper("nnoremap <silent> _ :resize -2<cr>","Horozontal Resize -")
endfunction
call PolyModeMapReset()


runtime plugin/polymode.vim
if !exists('polymode_loaded')
     echo "Some polymode initializations will be ignored"
else
     call PolyModeZeroMappings()
endif

call PolyModeMapReset()
" *****************************************************************************************************

vmap \q c()<ESC>P
" nnoremap <PageDown> viwo<esc>i[<esc>lviw<esc>a]<esc>
          nnoremap <PageDown> viWo<esc>i"<esc>lviW<esc>a"<esc>
          let @c = "\""
          nnoremap <PageDown> viWo<esc>"cP<esc>lviW<esc>"cp<esc>
          vnoremap <PageUp> o<esc>^i# ------------------------------------------------------------------<cr>#  <cr><esc>kll
          vnoremap <silent> <Home> :s/^/# /<cr>
          vnoremap <silent> <leader><Home> :s/^[#][ ]//<cr>
nnoremap <Insert> <Nop>

" *****************************************************************************************************
                                  " Auto Commands
                                  " *******************************************************************
if !exists("myautocommands_loaded")
     let myautocommands_loaded = 1
     autocmd FileType qf resize 25 
     autocmd FileType qf nnoremap <silent> <buffer> q :ccl<cr



     " au BufNewFile,BufRead *.awk vnoremap <silent> <Home> :s/^/\/\/ /<cr>gv
     " au BufNewFile,BufRead *.awk vnoremap <silent> <leader><Home> :s/^[/][/][ ]//<cr>
     au BufNewFile,BufRead *.java vnoremap <silent> <Home> :s/^/\/\/ /<cr>gv
     au BufNewFile,BufRead *.java vnoremap <silent> <leader><Home> :s/^[/][/][ ]//<cr>
     au BufNewFile,BufRead *.js vnoremap <silent> <Home> :s/^/\/\/ /<cr>gv
     au BufNewFile,BufRead *.js vnoremap <silent> <leader><Home> :s/^[/][/][ ]//<cr>
     au BufNewFile,BufRead .vimrc vnoremap <silent> <Home> :s/^/" /<cr>gv
     au BufNewFile,BufRead .vimrc vnoremap <silent> <leader><Home> :s/^["] //<cr>
     au BufNewFile,BufRead .vimrc vnoremap <silent> <leader><PageUp> o<esc>^i" ------------------------------------------------------------------<cr>"  <cr><esc>kll
     au BufNewFile,BufRead *.vim vnoremap <silent> <Home> :s/^/" /<cr>gv
     au BufNewFile,BufRead *.vim vnoremap <silent> <leader><Home> :s/^["] //<cr>
     
     
     
     au BufNewFile,BufRead *.lst nnoremap <silent> <buffer> q :quit<cr>




endif
" *****************************************************************************************************
                                  " Powerline
                                  " *******************************************************************
" let NOPOWERLINE = 1
if !exists("NOPOWERLINE")
     set  rtp+=/usr/local/lib/python2.7/dist-packages/powerline/bindings/vim/
     set laststatus=2
     set t_Co=256
endif
" *****************************************************************************************************
                                  " For Status Line
                                  " *******************************************************************
set laststatus=2
set t_Co=256

                                  " *******************************************************************
                                  " Quick Customizations
nnoremap <leader>x  $a<br><esc>0j<esc>
nnoremap <leader>w viw<esc>a"<esc>bi"<esc>lel
let @b = "<li><kbd>"
let @e = "</kbd>"
let @t = "</li>"
nnoremap <leader>1 "bP<esc>
nnoremap <leader>2 "ep<esc>
nnoremap <leader>3 $"tp<esc>0jw


function! SaveAndExecutePython()
    " https://stackoverflow.com/questions/18948491/running-python-code-in-vim
    " SOURCE [reusable window]: https://github.com/fatih/vim-go/blob/master/autoload/go/ui.vim
    call MakeTempBuffer()

    " add the console output
    silent execute ".!python " . shellescape(s:current_buffer_file_path, 1)
    setlocal readonly nomodifiable
    wincmd k
endfunction


function! Tcmd()
    call SetRegisterI()
    let l:cWord = @i
    silent execute "update | edit"
    call MakeTempBuffer()

    let l:szCommand = ".!" .  l:cWord
    silent execute  l:szCommand

    setlocal readonly nomodifiable

endfunction

function! BufferLocalF3Quit()
        nnoremap <silent> <buffer> <F3> :close<cr>
endfunction
   
" *****************************************************************************************************
                                  " Repo List Functions
                                  " *******************************************************************
function! RepoList()
        call LeftWindowBuffer("", "r !curl -s 'https://api.github.com/users/archernar/repos?per_page=100' | grep ssh_url")
endfunction
function! GetUrl()
        exe "!curl -s 'https://api.github.com/users/archernar/repos?per_page=100' | grep ssh_url > /tmp/zed"
        execute "redraw!"
endfunction
" *****************************************************************************************************
                                  " Commander Functions
                                  " *******************************************************************
function! CommanderEnterAction()
     let l:szKey = substitute(getline("."), " .*$", "", "g")
     let l:szCommand = substitute(getline("."), "^[a-z]* ", "", "")
     let l:szCommand = substitute(l:szCommand, "^[ ]*", "", "")
     execute "1"
     execute "normal! gg"
     execute "normal! dG"
     if (l:szCommand[0:0] == "!")
          silent execute "r " . l:szCommand
     else
          silent execute l:szCommand
     endif
     execute "nnoremap <silent> <buffer> <Enter> <Nop>"
endfunction
function! CommanderList()
    call LeftWindowBuffer(":call CommanderEnterAction()<cr>", "r !cat " . $VIM_COMMANDER)
endfunction
function! CommanderListEdit()
    silent execute  "e " . $VIM_COMMANDER
endfunction

" *****************************************************************************************************
                                  " PDF View Functions
                                  " *******************************************************************
function! ListEnterAction()
     let currentLine   = getline(".")
     echom currentLine
     execute "silent !xdg-open " . currentLine . " >/dev/null 2>&1"
     execute "redraw!"
     setlocal readonly nomodifiable
endfunction
function! PDFList()
          call LeftWindowBuffer(":call ListEnterAction()<cr>", "r !ls " . $VIM_PDFLIB . "/*.pdf")
endfunction
function! MP3List()
          call LeftWindowBuffer(":call ListEnterAction()<cr>", "r !ls " . $VIM_MP3LIB . "/*.mp3")
endfunction

" *****************************************************************************************************
                                  " Left Window-Buffer Functions
                                  " *******************************************************************
function! LeftWindowFile(...)
        execute "vnew " . a:1
        wincmd H
        setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile readonly nomodifiable | nnoremap <silent> <buffer> q :close<cr>
        let w:scratch = 1
        vertical resize 80 
        call cursor(1, 1)
endfunction
function! BottomBuffer(...)
        execute "rightbelow new " . a:1
        call cursor(1, 1)
endfunction
function! LeftWindowBuffer(...)
    " a:1    Enter Action
    " a:2    Content Action
    " *******************************************************************
    " Reuse existing buffer window if it exists otherwise create a new one
    if !exists("s:buf_nr") || !bufexists(s:buf_nr)
        vnew
        wincmd L
        let s:buf_nr = bufnr('%')
        setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
        nnoremap <silent> <buffer> q :close<cr>
    elseif bufwinnr(s:buf_nr) == -1
        vnew
        silent execute s:buf_nr . 'buffer'
    elseif bufwinnr(s:buf_nr) != bufwinnr('%')
        silent execute bufwinnr(s:buf_nr) . 'wincmd w'
    endif
    " *******************************************************************
    if ( a:0 > 0)
         execute "nnoremap <silent> <buffer> <Enter> " . a:1
    endif
    " let w:scratch = 1
    vertical resize 80 
    call cursor(1, 1)
    execute "normal! gg"
    execute "normal! dG"
    if ( a:0 > 0)
         execute a:2
    endif
    call cursor(1, 1)
endfunction

function! OpenInTempBuffer(...)
     call MakeTempBuffer()
     execute "edit ". a:1
     nnoremap <silent> <buffer> <Home>   :close<cr>:call PolyModeReset()<cr>
     nnoremap <silent> <buffer> <Insert> :close<cr>:call PolyModeReset()<cr>
     nnoremap <silent> <buffer> <End>    :close<cr>:call PolyModeReset()<cr>
     nnoremap <silent> <buffer> <PageUp> :close<cr>:call PolyModeReset()<cr>
     nnoremap <silent> <buffer> <PageDown> :close<cr>:call PolyModeReset()<cr>
     nnoremap <silent> <buffer> <Delete> :close<cr>:call PolyModeReset()<cr>
     setlocal readonly nomodifiable
endfunction
function! EditInTempBuffer(...)
     call MakeTempBuffer()
     execute "edit ". a:1
     nnoremap <silent> <buffer> <Home>   :close<cr>:call PolyModeReset()<cr>
     nnoremap <silent> <buffer> <Insert> :close<cr>:call PolyModeReset()<cr>
     nnoremap <silent> <buffer> <End>    :close<cr>:call PolyModeReset()<cr>
     nnoremap <silent> <buffer> <PageUp> :close<cr>:call PolyModeReset()<cr>
     nnoremap <silent> <buffer> <PageDown> :close<cr>:call PolyModeReset()<cr>
     nnoremap <silent> <buffer> <Delete> :close<cr>:call PolyModeReset()<cr>
endfunction
function! MakeTempBuffer()
    let s:current_buffer_file_path = expand("%")
    let s:output_buffer_name = g:RandomString()
    let s:output_buffer_filetype = "output"
    if !exists("s:buf_nr") || !bufexists(s:buf_nr)
        silent execute 'botright new ' . s:output_buffer_name
        let s:buf_nr = bufnr('%')
    elseif bufwinnr(s:buf_nr) == -1
        silent execute 'botright new'
        silent execute s:buf_nr . 'buffer'
    elseif bufwinnr(s:buf_nr) != bufwinnr('%')
        silent execute bufwinnr(s:buf_nr) . 'wincmd w'
    endif
    silent execute "setlocal filetype=" . s:output_buffer_filetype
    setlocal bufhidden=delete
    setlocal buftype=nofile
    setlocal noswapfile
    setlocal nobuflisted
    setlocal winfixheight
"    setlocal cursorline " make it easy to distinguish
    setlocal nonumber
    setlocal norelativenumber
    setlocal showbreak=""

    " clear the buffer
    setlocal noreadonly
    setlocal modifiable
    %delete _
    

endfunction




function! SetRegisterI()
      let szIn = input('$ ')
      let @i = szIn
      echo "\r"
      echo ""
endfunction
function! Terminal()
    execute "silent !gnome-terminal --title=vimsterTerm --geometry 195x50+25+25 &"
    redraw!
endfunction

function! JavaMain()
     call BotPut("public static void main(String[] args) {")
     call BotPut("     System.out.println( \"Hello World!\" );")
     call BotPut("}")
endfunction

" *****************************************************************************************************
                                  " KSH Topper Functions
                                  " *******************************************************************
function! TopPut(...)
    call append(line('0'), a:1)
endfunction
function! Bp(...)
    call append(line('$'), a:1)
endfunction
function! BotPut(...)
    call append(line('$'), a:1)
endfunction



function! S3put()
    echom   "R cuu -a  -b ecd3pub -F -c VIMS3PUT -D " . @%
    execute "R cuu -a  -b ecd3pub -F -c VIMS3PUT -D " . @%
endfunction

function! SaveAndExecuteGawk()
    let s:current_buffer_file_path = expand("%")
    silent execute "update | edit"
    call MakeTempBuffer()
    silent execute ".!gawk -f " . shellescape(s:current_buffer_file_path, 1) . " input.txt"
    setlocal readonly nomodifiable
endfunction


function! KillScratchWindows()
        for win in range(1, winnr('$'))
                if getwinvar(win, 'scratch')
                        execute win . 'windo close'
                endif
        endfor
endfunction

" winnr([{arg}])  The result is the number of the current window.
"                 The top window has number 1.
"                 When the opt-argument is "$", the last window is returned (the window count).  
" 		  Let window_count = winnr('$')
"  		  When the optional argument is "#", the number of the last
" 		  accessed window is returned (where |CTRL-W_p| goes to).
" 		  If there is no previous window or it is in another tab page 0
" 		  is returned.
function! Redir(cmd)
        for win in range(1, winnr('$'))
                if getwinvar(win, 'scratch')
                        execute win . 'windo close'
                endif
        endfor
        let s:thiscmd= "!" . a:cmd
        if s:thiscmd =~ '^!'
                execute "let output = system('" . substitute(s:thiscmd, '^!', '', '') . "')"
        else
                redir => output
                execute s:thiscmd
                redir END
        endif
        vnew
        let w:scratch = 1
        setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
        nnoremap <silent> <buffer> q :close<cr>
        nnoremap <silent> <buffer> m :vertical resize +20<cr>
        nnoremap <silent> <buffer> l :vertical resize -20<cr>
        call setline(1, split(output, "\n"))
endfunction

function! Redir2(...)
        call g:NewWindow("Bottom",8)
        redir => output
        silent execute a:1
        redir END
        nnoremap <silent> <buffer> q :close<cr>
        call setline(1, split(output, "\n"))
        resize 8
endfunction
function! Redir2a(...)
        call g:NewWindow("Bottom",8)
        if a:1 =~ '^!'
           execute "let output = system('" . substitute(a:1, '^!', '', '') . "')"
        else
            redir => output
            silent execute a:1
            redir END
        endif
        nnoremap <silent> <buffer> q :close<cr>
        call setline(1, split(output, "\n"))
        resize 8
endfunction
command! -nargs=1 B silent call Redir2a(<f-args>)


function! Redir3(...)
        call g:NewWindow("Right",18)
        if a:1 =~ '^!'
           execute "let output = system('" . substitute(a:1, '^!', '', '') . "')"
        else
            redir => output
            silent execute a:1
            redir END
        endif
        nnoremap <silent> <buffer> q :close<cr>
        call setline(1, split(output, "\n"))
        vertical resize 44 
endfunction
command! -nargs=1 BR silent call Redir3(<f-args>)
function! Redir4()
        let l:sz = "grep -n ^func " . @%  . " | grep Two"
        " silent execute "let output = system('" . "grep -n ^func " . @%  . "')"
        silent execute "let output = system('" . l:sz  . "')"
        call g:NewWindow("Right",18)
        nnoremap <silent> <buffer> q :close<cr>
        call setline(1, split(output, "\n"))
        vertical resize 44 
endfunction
command! BF silent call Redir4()


function! RedirEchoRtp()
        let output = ""
        call g:NewWindow("Bottom",8)
        redir => output
        silent execute "echom &rtp"
        redir END
        nnoremap <silent> <buffer> q :close<cr>
        call setline(1, split(output, ","))
        resize 12 
endfunction
command! RTP silent call RedirEchoRtp()

" https://stackoverflow.com/questions/11176159/how-to-jump-to-start-end-of-visual-selection
"
"
" Swap window buffers.
" function! SwapWindowBuffers()
"     if !exists("g:markedWinNum")
"         " set window marked for swap
"         let g:markedWinNum = winnr()
"         :echo "window marked for swap"
"     else
"         " mark destination
"         let curNum = winnr()
"         let curBuf = bufnr( "%" )
"         if g:markedWinNum == curNum
"             :echo "window unmarked for swap"
"         else
"             exe g:markedWinNum . "wincmd w"
"             " switch to source and shuffle dest->source
"             let markedBuf = bufnr( "%" )
"             " hide and open so that we aren't prompted and keep history
"             exe 'hide buf' curBuf
"             " switch to dest and shuffle source->dest
"             exe curNum . "wincmd w"
"             " hide and open so that we aren't prompted and keep history
"             exe 'hide buf' markedBuf
"             :echo "windows swapped"
"         endif
"         " unset window marked for swap
"         unlet g:markedWinNum
"     endif
" endfunction
" 
" noremap <F10> :call SwapWindowBuffers()<CR>
"
"
"
"
function! s:GetBufferList() 
  redir =>buflist 
  silent! ls 
  redir END 
  return buflist 
endfunction

function! ToggleQuickFixList()
  " SOURCE: https://github.com/milkypostman/vim-togglelist/blob/master/plugin/togglelist.vim
  for bufnum in map(filter(split(s:GetBufferList(), '\n'), 'v:val =~ "Quickfix List"'), 'str2nr(matchstr(v:val, "\\d\\+"))') 
    if bufwinnr(bufnum) != -1
      cclose
      return
    endif
  endfor
  let winnr = winnr()
  copen 
  resize 10
"   if winnr() != winnr
"     wincmd p
"   endif
endfunction




nmap <leader>spc :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

"             \    highlight Comment ctermbg=Black ctermfg=LightBlue <BAR>
nnoremap <silent> <Leader>ts
             \ : if exists("syntax_on") <BAR>
             \    syntax off <BAR>
             \    set nonumber <BAR>
             \ else <BAR>  
             \    syntax enable <BAR>
             \    set number <BAR>
             \ endif<CR>   

" *****************************************************************************************************
                                  " Set Color Scheme
                                  " *******************************************************************
                                  "  https://alvinalexander.com/linux/vi-vim-editor-color-scheme-syntax
                                  "  https://jordanelver.co.uk/blog/2015/05/27/working-with-vim-colorschemes/
                                  "  COLOR NAME 
                                  "  Black, White, Brown
                                  "  LightGray, LightGrey, Gray, Grey, DarkGray, DarkGrey
                                  "  Blue, LightBlue, DarkBlue
                                  "  Green, LightGreen, DarkGreen
                                  "  Cyan, LightCyan, DarkCyan
                                  "  Red, LightRed, DarkRed
                                  "  Magenta, LightMagenta, DarkMagenta
                                  "  Yellow, LightYellow, DarkYellow
" colorscheme darkblue
" colorscheme onehalflight
" let g:airline_theme='onehalfdark'
" let g:gruvbox_italic=1
" colorscheme gruvbox
" let g:monotone_color = [120, 100, 70] " Sets theme color to bright green
" let g:monotone_secondary_hue_offset = 200 " Offset secondary colors by 200 degrees
" let g:monotone_emphasize_comments = 0 " Emphasize comments
" colorscheme paramount
" colorscheme pablo
" set background=dark
" hi Visual   cterm=reverse
" highlight Comment ctermbg=Black ctermfg=LightBlue
set background=dark
colorscheme monochrome
let g:loaded_matchparen=1

function! JSnip(t)
    let s:szIn = input('value >> ')
    execute "e ~/scm/figg/templates/" . a:t
    execute "%s/NNAME/" . s:szIn . "/g"
    normal ggyG
    bdelete!
    normal p
endfunction
function! JSnipSimple(t)
    execute "e ~/scm/figg/templates/" . a:t
    normal ggyG
    bdelete!
    normal p
endfunction
function! Snipper(t)
    execute "e ~/scm/figg/templates/" . a:t
    normal ggyG
    bdelete!
    normal p
endfunction

" *****************************************************************************************************
                                  " Snipper
                                  " *******************************************************************
let g:SnipperEdit = 0 
let g:SnipperHome =  "~/.vim/Snips/"
function! SnipperEditOn()
    let g:SnipperEdit = 1 
endfunction
function! SnipperEditOff()
    let g:SnipperEdit = 0 
endfunction
function! SnipperPromptAndEdit()
     let szIn = input('Edit New Snip File>> ')
     execute "edit " . g:SnipperHome . szIn
endfunction
function! Snipperls()
    call LeftWindowBuffer()
    execute "r !ls -li " . g:SnipperHome 
endfunction
call g:SetMyKeyMapperMode("SNIPX")
call g:MyCommandMapper("command! SNIPEDIT        :call SnipperEditOn()")
call g:MyCommandMapper("command! SNIPEDITON      :call SnipperEditOn()")
call g:MyCommandMapper("command! SNIPEDITOFF     :call SnipperEditOff()")
call g:MyCommandMapper("command! SNIPPEREDITON   :call SnipperEditOn()")
call g:MyCommandMapper("command! SNIPPEREDITOFF  :call SnipperEditOff()")
call g:MyCommandMapper("command! SNIPPERNEW      :call SnipperPromptAndEdit()")
call g:MyCommandMapper("command! SNIPNEW         :call SnipperPromptAndEdit()")
call g:MyCommandMapper("command! SNIPLS          :call Snipperls()")
function! Snp(t,c)
    execute "e " . g:SnipperHome . a:t
    if g:SnipperEdit == 0 
        normal ggyG
        bdelete!
        normal p
    endif
endfunction
function! SnpFull(t,c)
    execute "e " . a:t
    if g:SnipperEdit == 0 
        normal ggyG
        bdelete!
        normal p
    endif
endfunction
function! SnipperStuff(t,c)
    execute "e " . g:SnipperHome . a:t
    if g:SnipperEdit == 0 
        normal ggyG
        bdelete!
        normal p
    endif
endfunction





" *****************************************************************************************************
                                  " Command Mapper
                                  " *******************************************************************

func! s:SnipfileItem(...)
    let l:t = -1
    let l:l = -1
    let l:c = 0 
    call g:SetMyKeyMapperMode(a:1)
    for l:file in split(glob(a:2),'\n')
        let c = c + 1
    endfor
    if ( c > 0 )
        for l:file in split(glob(a:2),'\n')
             let l:l = len(toupper(split(l:file,"/")[-1]))
             if (l:l > l:t) 
                 let l:t = l:l
             endif
        endfor
        let l:t = l:t + 2
        for l:file in split(glob(a:2),'\n')
             let l:f1 = l:file
             let l:f2 = split(l:file,"/")[-1]
             let l:f2 = l:file
             let l:f1 = g:Strreplace(l:f1,'xxxxxxxxxwdd.','XX')
             "call g:MyCommandItemMapper(g:Pad(a:1,6) . " " . g:Pad(toupper(split(l:f1,"/")[-1]),l:t) . " :e " . l:f2 )
                     let l:szKey = "ITEM" . g:MyCommandItemCT 
                     let g:MyCommandItemDict[ l:szKey ] = g:Pad(a:1,6) . " :e " . l:f2 
                     let g:MyCommandItemCT = g:MyCommandItemCT +1
        endfor
    endif
endfunc

func! g:Setupsniplocal(...)
    call  g:MyCommandItemMapperReset()
    call  s:SnipfileItem("FILE", a:1)
endfunc
func! g:Setupsnip()
    call  g:MyCommandItemMapperReset()
    call  s:SnipfileItem("FILE", "./*.java")
    call  s:SnipfileItem("FILE", "~/.vim/Snips/*.java")
    call  s:SnipfileItem("FILE", "~/.vim/Snips/*.txt")
    call g:SetMyKeyMapperMode("SNIPTXT")
     for l:file in split(glob('~/.vim/Snips/*.txt'), '\n')
          let l:f1 = l:file
          let l:f1 = g:Strreplace(l:f1,'.','')
          let l:f2 = split(l:file,"/")[-1]
          call g:MyCommandMapper("command! " . toupper(split(l:f1,"/")[-1]) . " :call Snp('" . l:f2 .    "','')")
     endfor
endfunc

func! s:Setupsnip2()
    call g:SetMyKeyMapperMode("SNIP")
    for l:file in split(glob('~/.vim/Snips/*.java'), '\n')
         let l:f1 = l:file
         let l:f1 = g:Strreplace(l:f1,'.','')
         let l:f2 = split(l:file,"/")[-1]
         call g:MyCommandMapper("command! " . toupper(split(l:f1,"/")[-1]) . " :call Snp('" . l:f2 .    "','')")
    endfor
    call g:SetMyKeyMapperMode("SNIPTXT")
    for l:file in split(glob('~/.vim/Snips/*.txt'), '\n')
         let l:f1 = l:file
         let l:f1 = g:Strreplace(l:f1,'.','')
         let l:f2 = split(l:file,"/")[-1]
         call g:MyCommandMapper("command! " . toupper(split(l:f1,"/")[-1]) . " :call Snp('" . l:f2 .    "','')")
    endfor
    call g:SetMyKeyMapperMode("SNIPEJ")
    for l:file in split(glob('./*.java'), '\n')
         let l:f1 = l:file
         let l:f1 = g:Strreplace(l:f1,'.','')
         let l:f2 = split(l:file,"/")[-1]
         call g:MyCommandMapper("command! " . toupper(split(l:f1,"/")[-1]) . " :e " . "./" . l:f2 )
    endfor
    call g:SetMyKeyMapperMode("SNIPET")
    for l:file in split(glob('./*.txt'), '\n')
         let l:f1 = l:file
         let l:f1 = g:Strreplace(l:f1,'.','')
         let l:f2 = split(l:file,"/")[-1]
         call g:MyCommandMapper("command! " . toupper(split(l:f1,"/")[-1]) . " :e " . "./" . l:f2 )
    endfor
    call g:SetMyKeyMapperMode("SNIPJJJ")
    for l:file in split(glob('~/.vim/Snips/*.java'), '\n')
         let l:f1 = l:file
         let l:f2 = l:file
         let l:f1 = g:Strreplace(l:f1,'.','XX')
         call g:MyCommandNoMap("command! " . toupper(split(l:f1,"/")[-1]) . " :e " . l:f2 )
    endfor
endfunc

call g:Setupsnip()
call g:MyCommandMapper("command! PWD     :!pwd")
" call g:MyCommandMapper("command! KSH     :call  SnipperStuff('KSH.txt','')")
" call g:MyCommandMapper("command! PSETONE :call  SnipperStuff('PSetOne.txt','')")
" call g:MyCommandMapper("command! APPL    :call  SnipperStuff('Appl.txt','')")
" call g:MyCommandMapper("command! GAWK    :call  SnipperStuff('Gawk.txt','')")
" call g:MyCommandMapper("command! GSPLIT  :call  SnipperStuff('GSplit.txt','')")
" call g:MyCommandMapper("command! SPLIT   :call  SnipperStuff('GSplit.txt','')")
" call g:MyCommandMapper("command! QCLASS  :call  SnipperStuff('QuickClass.txt','')")
" call g:MyCommandMapper("command! PCLASS  :call  SnipperStuff('PrivateClass.java','')")
" call g:MyCommandMapper("command! CLASS   :call  SnipperStuff('Class.java','')")
" call g:MyCommandMapper("command! RUNNER  :call  SnipperStuff('Runner.txt','')")
" call g:MyCommandMapper("command! FOREX   :call  SnipperStuff('forexamples.java','')")
" call g:MyCommandMapper("command! SB      :call  SnipperStuff('Sb.txt','')")
" call g:MyCommandMapper("command! SCANNER :call  SnipperStuff('Scanner.txt','')")
" call g:MyCommandMapper("command! SVM     :call  SnipperStuff('StaticVoidMain.txt','')")
" call g:MyCommandMapper("command! SWITCH  :call  SnipperStuff('Switch.txt','')")
" call g:MyCommandMapper("command! SYSOUT  :call  SnipperStuff('SysOut.txt','')")
" call g:MyCommandMapper("command! STRING  :call  SnipperStuff('VarString.txt','')")
" call g:MyCommandMapper("command! DOUBLE  :call  SnipperStuff('VarDouble.txt','')")
" call g:MyCommandMapper("command! INT     :call  SnipperStuff('Varint.txt','')")
" call g:MyCommandMapper("command! INTCIRCLE :call  SnipperStuff('IntCircle.txt','')")
" call g:MyCommandMapper("command! SCORES  :call  SnipperStuff('Scores.txt','')")
" call g:MyCommandMapper("command! FLOAT   :call  SnipperStuff('VarFloat.txt','')")
" call g:MyCommandMapper("command! PRIM    :call  SnipperStuff('Prim.txt','')")
" call g:MyCommandMapper("command! VAR     :call  SnipperStuff('Var.txt','')")
" call g:MyCommandMapper("command! TRY     :call  SnipperStuff('Try.txt','')")
" call g:MyCommandMapper("command! EX1     :call  SnipperStuff('ex1.java','')")
" call g:MyCommandMapper("command! EX2     :call  SnipperStuff('ex2.java','')")
" call g:MyCommandMapper("command! EX3     :call  SnipperStuff('ex3.java','')")
" call g:MyCommandMapper("command! EX4     :call  SnipperStuff('ex4.java','')")
" call g:MyCommandMapper("command! EX5     :call  SnipperStuff('ex5.java','')")
" call g:MyCommandMapper("command! EX5A    :call  SnipperStuff('ex5a.java','')")
" call g:MyCommandMapper("command! EX5B    :call  SnipperStuff('ex5b.java','')")
" call g:MyCommandMapper("command! EX5C    :call  SnipperStuff('ex5c.java','')")
" call g:MyCommandMapper("command! EX5D    :call  SnipperStuff('ex5d.java','')")
" call g:MyCommandMapper("command! EX6     :call  SnipperStuff('ex6.java','')")
" call g:MyCommandMapper("command! EX8     :call  SnipperStuff('ex8.java','')")
" call g:MyCommandMapper("command! EX9     :call  SnipperStuff('ex9.java','')")
" call g:MyCommandMapper("command! EX10    :call  SnipperStuff('ex10.java','')")
" call g:MyCommandMapper("command! EX11    :call  SnipperStuff('ex11.java','')")
" call g:MyCommandMapper("command! EX12A   :call  SnipperStuff('ex12a.java','')")
" call g:MyCommandMapper("command! EX12B   :call  SnipperStuff('ex12b.java','')")

" call g:MyCommandMapper("command! XXX  :call      SnipperStuff('IntCircle.java','')")
" call g:MyCommandMapper("command! XXX  :call      SnipperStuff('ex5bnew.java','')")
" call g:MyCommandMapper("command! XXX  :call      SnipperStuff('ex6b.java','')")
" call g:MyCommandMapper("command! XXX  :call      SnipperStuff('FileTest2.java','')")
" call g:MyCommandMapper("command! XXX  :call      SnipperStuff('FileTest.java','')")
" call g:MyCommandMapper("command! XXX  :call      SnipperStuff('PlayList.java','')")
" call g:MyCommandMapper("command! XXX  :call      SnipperStuff('PlayListTest.java','')")
" call g:MyCommandMapper("command! XXX  :call      SnipperStuff('Scores.java','')")
" call g:MyCommandMapper("command! XXX  :call      SnipperStuff('Song.java','')")
" call g:MyCommandMapper("command! XXX  :call      SnipperStuff('songs.txt','')")
" call g:MyCommandMapper("command! XXX  :call      SnipperStuff('Template.txt','')")
" call g:MyCommandMapper("command! XXX  :call      SnipperStuff('Uni.txt','')")
" call g:MyCommandMapper("command! XXX  :call      SnipperStuff('VarChar.txt','')")
" call g:MyCommandMapper("command! XXX  :call      SnipperStuff('VarDouble.txt','')")
" call g:MyCommandMapper("command! XXX  :call      SnipperStuff('VarFloat.txt','')")
" call g:MyCommandMapper("command! XXX  :call      SnipperStuff('Varint.txt','')")


call g:SetMyKeyMapperMode("JAVA")
call g:MyCommandMapper("command! JDDATE   :silent !jdoc java.util.Date")
call g:MyCommandMapper("command! DIC      :call MyDictionaryDump(g:MyCommandItemDict)")
call g:MyCommandMapper("command! JJ       :call JavaRun()")
call g:MyCommandMapper("command! CC       :call JavaCompile()")
call g:MyCommandMapper("command! QQ       :call ToggleQuickFixList()")
call g:MyCommandMapper("command! JTRY     :call JSnipSimple('Try.txt')")
call g:MyCommandMapper("command! JDOUBLE  :call JSnip('VarDouble.txt')")
call g:MyCommandMapper("command! JCHAR    :call JSnip('VarChar.txt')")
call g:MyCommandMapper("command! JSTRING  :call JSnip('VarString.txt')")
call g:MyCommandMapper("command! JSTR     :call JSnip('VarString.txt')")
call g:MyCommandMapper("command! JSCAN    :call JSnipSimple('Scanner.txt')")
call g:MyCommandMapper("command! JMAIN    :call JSnipSimple('StaticVoidMain.txt')")
call g:MyCommandMapper("command! JAPPL    :call JSnip('Appl.txt')")
call g:MyCommandMapper("command! JAPP     :call JSnip('Appl.txt')")
call g:MyCommandMapper("command! JPRIM    :call JSnipSimple('Prim.txt')")
call g:MyCommandMapper("command! JSWICH   :call JSnipSimple('Switch.txt')")
call g:MyCommandMapper("command! JSYSOUT  :call JSnipSimple('SysOut.txt')")

nnoremap <silent> <leader>n  i<cr><esc>
" au BufAdd,BufNewFile * nested tab sball

silent call BiModeSet(1)

set makeprg=javac\ %
set errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#
" setl        efm=%A%f:%l:\ %m,%-Z%p^,%-C%.%#
" setl        efm=%A%f:%l:\ %m,%+Z%p^,%+C%.%#,%-G%.%#
"  vim quickfix stuff
"  :copen " Open the quickfix window
"  :ccl   " Close it
"  :cw    " Open it if there are "errors", close it otherwise (some people prefer this)
"  :cn    " Go to the next error in the window
"  :cnf   " Go to the first error in the next file
"
"
" setl        efm=%A%f:%l:\ %m,%-Z%p^,%-C%.%#
" setl        efm=%A%f:%l:\ %m,%+Z%p^,%+C%.%#,%-G%.%#
" set makeprg=javac\ %

function! s:Max(...)
        let l:n = a:1
        if ( a:1 > a:2 )
            let l:n = a:2
        endif
        return l:n
endfunction
function! IsQuickFixOpen()
        let l:n=0
        let l:bnum = winbufnr(winnr())
        if getbufvar(l:bnum, '&buftype') == 'quickfix'
            let l:n=1
        endif
        return l:n
endfunction

" cexpr system('javac -nowarn -cp ~/classes -d ~/classes ' . shellescape(expand('%:p')))
" Set desired java options below
" silent let l:cmd = "java -d64  " . "" . g:Strreplace(expand("%:r"),"./","") . " " . arg

function! g:DD0(...)
    let l:Dict = {} 
    let l:DictCT = 1000 
    let l:len = -1
    let l:nn = 0
    " Load Directory Part
        call g:SetMyKeyMapperMode("FILE")
        let l:list = split(glob(a:1),'\n')
"         let l:list = split(globpath(".","**/*"),'\n')
"         for l:file in split(glob(a:1),'\n')
        for l:file in l:list
            let l:Dict["ITEM" . l:DictCT] = l:file
            let l:DictCT = l:DictCT+1
            let l:nn = strlen(l:file)
            if (l:nn > l:len)
                let l:len = l:nn
            endif
        endfor
            let l:Dict["ITEM" . l:DictCT] = l:len
    " Create Window/Buffer Part
        let l:cols = &columns / 3
        let l:len = s:Max(l:len, l:cols)
        let l:cols = 38
        let g:thatwin = winnr()
        call g:NewWindow("Left", l:cols, "<Enter> :call g:DD4('e')","s :call g:DD4('vnew')", "b :call g:DD4('split')")
        echom "<enter> to edit, <s> to edit in Vert-Split, <b> to edit in Horz-Split"
    " Display Part
        setlocal cursorline
        let l:nn=1
	for key in sort(keys(l:Dict))
          call setline(l:nn, l:Dict[key] . "")
          let l:nn= l:nn + 1
	endfor
        set nowrap
        resize 155
endfunc
function! g:DD4(...)
     let l:sz   = getline(".")
     if (strlen(l:sz) > 0)
         silent execute "q"
         exe g:thatwin . "wincmd w"
         echom "execute " . a:1 . " " . "" . l:sz . ""
         silent execute a:1 . " " . "" . l:sz . ""
     endif
endfunction


function! g:DDD10()
call g:NewWindow("Bottom",33)
    exe "!ls .vimsession"
endfunction
"redir @">|silent call s:LS()|redir END|enew|put

nnoremap <F5> :call ProgramCompile()<cr>
nnoremap <F6> :call ProgramRun()<cr>
nnoremap <leader><F6> <esc>:e out<cr>
nnoremap <F7> :call g:setupsnip()<cr>:call MyDictionaryDump(g:MyCommandItemDict)<cr>
nnoremap <leader><F7> :call g:setupsniplocal("./*.java")<cr>:call MyDictionaryDump(g:MyCommandItemDict)<cr>
nnoremap <leader><F7> :call g:DD0("./*.*")<cr>
call g:MyCommandMapper("command! GREP   :call Greppyon(1)")

nnoremap <F3> :w<CR>:1<cr>i<cr><esc>k:r !gawk '/^function/{$1="";sub(/^ /,"", $0);print "\" " $0}' %<CR>:1<cr>dd


" *****************************************************************************************************
                                  " Jump to Last Position When Reopening a File
                                  " *******************************************************************
if has("autocmd")
   au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
   \| exe "normal! g'\"" | endif
endif



