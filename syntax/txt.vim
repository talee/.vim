" Vim syntax file
" Language:     text file

if exists("b:current_syntax")
    finish
endif

set linebreak

" mapping to make movements operate on 1 screen line in wrap mode
function! ScreenMovement(movement)
    if &wrap
        return "g" . a:movement
    else
        return a:movement
    endif
endfunction

function! GMoveOn()
    onoremap <silent> <expr> j ScreenMovement("j")
    onoremap <silent> <expr> k ScreenMovement("k")
    onoremap <silent> <expr> 0 ScreenMovement("0")
    onoremap <silent> <expr> ^ ScreenMovement("^")
    onoremap <silent> <expr> $ ScreenMovement("$")

    nnoremap <silent> <expr> j ScreenMovement("j")
    nnoremap <silent> <expr> k ScreenMovement("k")
    nnoremap <silent> <expr> 0 ScreenMovement("0")
    nnoremap <silent> <expr> ^ ScreenMovement("^")
    nnoremap <silent> <expr> $ ScreenMovement("$")
endfunction

function! GMoveOff()
    unmap <silent> <expr> j
    unmap <silent> <expr> k
    unmap <silent> <expr> 0
    unmap <silent> <expr> ^
    unmap <silent> <expr> $
endfunction
