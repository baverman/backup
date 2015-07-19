set makeprg=./compile.sh\ %
nnoremap <leader>cc :call <SID>Compile()<cr>

function! <SID>Compile()
    silent make
    redraw!
    silent! cw
endfunction
