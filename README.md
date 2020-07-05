# session.vim - a simple vim session management plugin
## Screen Shot"
![alt text](https://github.com/archernar/vim-session/blob/master/images/session.png)
## Setup
    " ==============================================================================
    "
    " To capture sessions, add the following command to your .vimrc
    
    " command! SESSION   :call CaptureSession()
    
    " To automatically load sessions, add ithe following to your .vimrc
    " if ( argc() == 0 ) 
    "      autocmd VimEnter * :call LoadSession()
    " endif
    " Optional Environment Variables
    " name         default
    " VIMSESSION   .vimsession
    " VIMWINDOW    .vimwindow
    " VIMSPLIT     .vimsplit
    " ==============================================================================
