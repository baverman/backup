if !exists("g:loaded_pathogen")
    filetype off
    runtime bundle/vim-pathogen/autoload/pathogen.vim
    execute pathogen#infect()

    syntax on
    filetype plugin on

    set nocompatible
    set background=dark
endif


" Colors
hi ColorColumn ctermbg=darkgrey guibg=darkgrey
hi clear CursorLine
hi CursorLine ctermbg=darkgrey

if !empty($VIAL)
    colorscheme wombat256mod
    hi ColorColumn ctermbg=235 guibg=#32322e
    hi NonText ctermbg=234 guifg=#e3e0d7
endif

hi ExtraWhitespace ctermbg=red guibg=red

" Common settings
set autoread
set nonumber
set numberwidth=4
set hidden
set wildmenu
set wildmode=list:longest
set ttyfast
set et sts=4 sw=4
set autoindent
set nosmartindent
set nocindent
set indentexpr=VialIndent()
set indentkeys=o

" nnoremap / /\v
" vnoremap / /\v
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
set directory=~/tmp/vim//

set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
set spelllang=en_us,ru_ru
set spellcapcheck=

syntax sync minlines=256
set synmaxcol=256

set nojoinspaces
set noshowmatch
set scrolloff=5


" Common mappings
let mapleader = ','
nnoremap <silent> <leader>cs :noh<cr>
nnoremap <leader>ev :edit $MYVIMRC<cr>
noremap H 0
noremap L $
nnoremap j gj
nnoremap k gk
nnoremap ; :
noremap <space> ;
nnoremap <esc>n :bmodified<cr>
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
inoremap <c-@> <c-x><c-o>
imap <c-j> jklysL
imap <c-k> jklys
imap <c-l> <Plug>VialCrampSkip
nnoremap Y y$
nnoremap S ddko
nnoremap <c-n> :cn<cr>
nnoremap <c-p> :cp<cr>
nnoremap <leader>o o<esc>k
nnoremap <leader>O O<esc>j
nnoremap K i<cr><esc>
nnoremap <leader>ss :syntax sync fromstart<cr>
nnoremap <leader><space> s<space><c-r>-<space><esc>h
nnoremap <leader>x *``cgn
nmap <esc>d viw<esc>bhxysw]lysw'f]
nmap <esc>p viw<esc>bi.jkds'ds]
nmap <esc>g cs])i.getjk

imap jk <Plug>VialCrampLeave
imap ОЛ <Plug>VialCrampLeave
inoremap <esc> <nop>

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

cmap w!! w !sudo tee > /dev/null %


" Filetype settings
augroup MyFileTypeSettings
    au!
    au FileType python nnoremap <buffer> <silent> <leader>d :VialPythonGotoDefinition<cr>
    au FileType python nnoremap <buffer> <silent> <leader>f :VialPythonOutline<cr>
    au FileType python setlocal et sts=4 sw=4 tw=80 fo=croq colorcolumn=85
    au FileType python match ExtraWhitespace /\s\+$/
    au FileType javascript setlocal colorcolumn=85
    au FileType qf wincmd J
augroup END


" Vial
nnoremap <leader>m :VialQuickOpen<cr>
nnoremap <silent> <leader>t :VialSearchOutline<cr>
" nnoremap <esc>p :VialPythonShowSignature<cr>
nnoremap <silent> <esc><esc> :VialEscape<cr>
nmap <leader>g <Plug>VialGrep
vmap <leader>g <Plug>VialGrep
nnoremap <leader>l :VialPythonLint<cr>
nnoremap <leader>la :VialPythonLintAll<cr>
nnoremap <leader>vg :VialGrep 
nnoremap gom :VialPythonOpenModule 

" Other plugs
let g:AutoPairsMapCR = 0
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
nnoremap <leader>v :Bufferlist<cr>


" Restore cursor
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"zz
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

command! FormatXml silent %!xmllint --encode UTF-8 --format -

" Session
if !empty($VIAL_SESSION) && !exists('g:session_loaded')
    if !isdirectory(expand("~/.vim/sessions/$VIAL_SESSION"))
        call mkdir(expand("~/.vim/sessions/$VIAL_SESSION"))
    endif
    set viminfo+=n~/.vim/sessions/$VIAL_SESSION/.viminfo
    silent! source ~/.vim/sessions/$VIAL_SESSION/session.vim
    command! SaveSession mksession! ~/.vim/sessions/$VIAL_SESSION/session.vim 
    noremap <leader>es :edit ~/.vim/sessions/$VIAL_SESSION/sessionx.vim<cr>
    noremap <leader>eV :edit ~/.vim/sessions/$VIAL_SESSION/sessionv.vim<cr>
    augroup save_session_on_quit
      autocmd!
      autocmd QuitPre * SaveSession
    augroup END
    let g:session_loaded = 'true'
endif

" echom synIDattr(synID(line("."), col("."), 0), "name")
