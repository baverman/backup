filetype off
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

syntax on
filetype indent on
set nocompatible
set background=dark


" Colors
hi ColorColumn ctermbg=darkgrey guibg=darkgrey
hi clear CursorLine
hi CursorLine ctermbg=darkgrey

if !empty($VIAL)
    colorscheme wombat256mod
    hi ColorColumn ctermbg=235 guibg=#32322e
    hi NonText ctermbg=234 guifg=#e3e0d7
endif


" Common settings
set nonumber
set numberwidth=4
set hidden
set wildmenu
set wildmode=list:longest
set ttyfast
set et sts=4 sw=4

" nnoremap / /\v
" vnoremap / /\v
nnoremap <silent> <leader>cs :noh<cr>
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch

set wrap
set textwidth=79
set formatoptions=qrn1

set sessionoptions=buffers,curdir


" Common mappings
let mapleader = ','
nnoremap <leader>ev :edit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
noremap H 0
noremap L $
nnoremap j gj
nnoremap k gk
nnoremap ; :
noremap <space> ;
nnoremap <c-n> :bmodified<cr>
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
inoremap <c-@> <c-x><c-o>

inoremap jk <esc>
inoremap <esc> <nop>

inoremap OA <nop>
inoremap OB <nop>
inoremap OC <nop>
inoremap OD <nop>
inoremap <Up> <nop>
inoremap <Left> <nop>
inoremap <Down> <nop>
inoremap <Right> <nop>
nnoremap <Up> <nop>
nnoremap <Left> <nop>
nnoremap <Down> <nop>
nnoremap <Right> <nop>
vnoremap <Up> <nop>
vnoremap <Left> <nop>
vnoremap <Down> <nop>
vnoremap <Right> <nop>


" Filetype settings
augroup MyFileTypeSettings
    au!
    au FileType python set autoindent smartindent et sts=4 sw=4 tw=80 fo=croq colorcolumn=85
    au FileType python nnoremap <buffer> <silent> <leader>d :VialPythonGotoDefinition<cr>
augroup END


" Vial
nnoremap <leader>m :VialQuickOpen<cr>


" delimitMate
imap <c-j> <Plug>delimitMateJumpMany
inoremap <c-l> <c-o>a
let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1


" Restore cursor
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END


" Session
if !empty($VIAL_SESSION) && !exists('g:session_loaded')
    if !isdirectory(expand("~/.vim/sessions/$VIAL_SESSION"))
        call mkdir(expand("~/.vim/sessions/$VIAL_SESSION"))
    endif
    set viminfo+=n~/.vim/sessions/$VIAL_SESSION/.viminfo
    silent! source ~/.vim/sessions/$VIAL_SESSION/session.vim
    command! SaveSession mksession! ~/.vim/sessions/$VIAL_SESSION/session.vim 
    noremap <leader>es :edit ~/.vim/sessions/$VIAL_SESSION/sessionx.vim<cr>
    augroup save_session_on_quit
      autocmd!
      autocmd QuitPre * SaveSession
    augroup END
    let g:session_loaded = 'true'
endif
