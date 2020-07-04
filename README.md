<h2>Setup</h2>

<h2>MD-BLOCK</h2>

<h2>==============================================================================</h2>

<h1>#</h1>

<h2>To capture sessions, add the following command to your .vimrc</h2>

<h1>#</h1>

<h2>command! SESSION   :call CaptureSession()</h2>

<h1>#</h1>

<h2>To automatically load sessions, add ithe following to your .vimrc</h2>

<h2>if ( argc() == 0 )</h2>

<h2>autocmd VimEnter * :call LoadSession()</h2>

<h2>endif</h2>

<h2>Optional Environment Variables</h2>

<h2>name         default</h2>

<h2>VIMSESSION   .vimsession</h2>

<h2>VIMWINDOW    .vimwindow</h2>

<h2>VIMSPLIT     .vimsplit</h2>

<h2>==============================================================================</h2>

<pre><code>if exists("g:loaded_plugin_session") || v:version &lt; 700 || &amp;cp
finish
endif
let g:loaded_plugin_session=1

let s:MAXBUFFERS=32
==============================================================================
- Script Utility Function
------------------------------------------
- s:TabsCount()
-
------------------------------------------
function s:TabCount()
let l:ret = 0
for i in range(tabpagenr('$'))
let l:ret = l:ret + 1
endfor
return l:ret
endfunction
==============================================================================
- Script Utility Function
------------------------------------------
- s:WindowExists(...)
-      a:1 is the window number
------------------------------------------
function! s:WindowExists(...)
let l:nRet = 0
for l:l in range(1, winnr('$'))
if (a:1 == l:l)
let l:nRet = 1
endif
endfor
return l:nRet
endfunction
==============================================================================
- Script Utility Function
------------------------------------------
- s:BufferVisible(...)
-      a:1 is the buffer number
------------------------------------------
function! s:BufferVisible(...)
let l:ret = 0
for l:l in range(1, winnr('$'))
if (a:1 == winbufnr(l:l))
let l:ret = 1
endif
endfor
return l:ret
endfunction
==============================================================================
- Script Utility Function
------------------------------------------
- s:DeleteNoNameBuffer()
-
------------------------------------------
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
==============================================================================
- Script Utility Function
------------------------------------------
- s:FileInSession(...)
-      a:1 is a file name
------------------------------------------
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

==============================================================================
- Script Utility Function
------------------------------------------
- s:LoadLastBuffer(...)
-
------------------------------------------
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

==============================================================================
- Global Function
------------------------------------------
- g:DeleteAllBuffers()
-
------------------------------------------
function! g:DeleteAllBuffers()
silent exe "0,s:"
endfunction
==============================================================================
- Global Function
------------------------------------------
- LoadSession()
-
------------------------------------------
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

==============================================================================
- Global Function
------------------------------------------
- CaptureSession()
-
------------------------------------------
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
