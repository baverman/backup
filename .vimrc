set nocompatible
set background=light
python3 1+1

call plug#begin('~/.vim/bundle')
Plug 'git@github.com:baverman/vial.git'
Plug 'git@github.com:baverman/vial-cash.git'
Plug 'git@github.com:baverman/vial-cramp.git'
Plug 'git@github.com:baverman/vial-http.git'
Plug 'git@github.com:baverman/vial-pipe.git'
Plug 'git@github.com:baverman/vial-pytest.git'
Plug 'git@github.com:baverman/vial-python.git'
Plug 'git@github.com:baverman/vial-quick-open.git'
Plug 'git@github.com:baverman/vial-mail.git'
Plug 'git@github.com:baverman/vim-babymate256.git'
Plug 'digitaltoad/vim-jade'
Plug 'gkz/vim-ls'
Plug 'Lokaltog/vim-easymotion'
Plug 'AndrewRadev/linediff.vim'
Plug 'garbas/vim-snipmate'
" Plug 'godlygeek/tabular'
Plug 'honza/vim-snippets'
Plug 'junegunn/vim-easy-align'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'nvie/vim-flake8'
Plug 'rhysd/clever-f.vim'
Plug 'takac/vim-hardtime'
Plug 'tomtom/tlib_vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/tComment'
Plug 'wavded/vim-stylus'
Plug 'wellle/targets.vim'
Plug 'Wolfy87/vim-enmasse'
" Plug 'dhruvasagar/vim-table-mode'
Plug 'stefandtw/quickfix-reflector.vim'
Plug 'dbmrq/vim-ditto'
Plug '~/.vim/bundle/vial-draw'
Plug 'aklt/plantuml-syntax'
Plug 'dleonard0/pony-vim-syntax'
Plug 'ziglang/zig.vim'
Plug 'jlanzarotta/bufexplorer'
Plug 'AndrewRadev/sideways.vim'
" Plug 'vim-airline/vim-airline'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'andymass/vim-matchup'
call plug#end()

filetype plugin on
filetype indent off

" Colors
hi ColorColumn ctermbg=darkgrey guibg=darkgrey
hi clear CursorLine
hi CursorLine ctermbg=darkgrey

if !empty($VIAL)
colorscheme solarized
endif

hi ExtraWhitespace ctermbg=red guibg=red
hi RightMargin ctermbg=red guibg=red
hi SpellBad ctermbg=red ctermfg=white
call matchadd('RightMargin', '.\%85v')
call matchadd('ExtraWhitespace', '\s\+$')

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
set display+=lastline
set fileencodings=utf-8,cp1251
set backspace=indent,eol,start
set ruler

" nnoremap / /\v
" vnoremap / /\v
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
set showtabline=0

set wrap
set textwidth=79
set formatoptions=qrn1

set sessionoptions=buffers,curdir
set backupdir=/tmp
set directory=~/tmp/vim//
set iconstring=%f%(\ %M%R%H%)
set clipboard=exclude:cons\|linux

set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯЖ;ABCDEFGHIJKLMNOPQRSTUVWXYZ:,фисвуапршолдьтщзйкыегмцчняж;abcdefghijklmnopqrstuvwxyz:
set spelllang=en_gb,ru_ru
set spellcapcheck=

syntax sync minlines=256
set synmaxcol=5000

set nojoinspaces
set noshowmatch
set scrolloff=5

set updatetime=2000
set shortmess-=S


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
nnoremap <leader>P "+P
vnoremap <leader>P "+P
nnoremap <leader>p "+p
vnoremap <leader>p "+p
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y "+y$
vnoremap <leader>Y "+y$
nnoremap <leader>u :put +<cr>
nnoremap S cc
nnoremap <c-n> :cn<cr>
nnoremap <c-p> :cp<cr>
nnoremap <esc>N :lnext<cr>
nnoremap <esc>P :lprev<cr>
nnoremap <leader>o o<esc>k
nnoremap <leader>O O<esc>j
nnoremap K i<cr><esc>
nnoremap <leader>ss :syntax sync fromstart<cr>
nnoremap <leader><space> s<space><c-r>-<space><esc>h
nnoremap <leader>x *``cgn
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>
nnoremap <silent> <leader>W :w !sudo tee > /dev/null %<cr>:e!<cr>
nnoremap <leader>w :w<cr>
nmap <esc>d viw<esc>bhxysw]lysw'f]
nmap <esc>p viw<esc>bi.jkds'ds]
nmap <esc>g cs])i.getjk
map <silent> <leader>aa :Tab /=<cr>
map <silent> <leader>a: :Tab /:\zs/l0l1<cr>
map <silent> <leader>a, :Tab /,\zs/l0l1<cr>
nnoremap ,si :echom synIDattr(synID(line("."), col("."), 0), "name")<cr>
nnoremap <leader>bw :bw<cr>
nnoremap <leader>bd :bd<cr>
vnoremap <leader>. :norm .<cr>
nnoremap <leader>ee O<c-a> = <c-r><c-o>"<esc>
nnoremap <leader>z :setlocal invspell<cr>
vmap <leader>d ygpr 
nnoremap <leader>r 1v"0p
nnoremap <silent> <leader>ed :setlocal virtualedit=all cursorcolumn cursorline<cr>
nnoremap <silent> <leader>eD :setlocal virtualedit= nocursorcolumn nocursorline<cr>

nnoremap ,cc ciw<c-r>=system('/usr/bin/python2 ~/bin/colorpicker "<c-r>-" 2> /dev/null')<cr><esc>
inoremap <c-x>c <c-r>=system('/usr/bin/python2 ~/bin/colorpicker "#fff" 2> /dev/null')<cr>
inoremap <c-x>C <c-r>=system('/usr/bin/python2 ~/bin/colorpicker fff 0> /dev/null')<cr>

imap jk <Plug>VialCrampLeave
imap ОЛ <Plug>VialCrampLeave

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

nnoremap <esc>h :SidewaysLeft<cr>
nnoremap <esc>l :SidewaysRight<cr>

cmap w!! w !sudo tee > /dev/null %
cmap %/ <c-r>=expand('%:p:h')<cr>/

nmap <silent> <leader>hs <plug>(matchup-hi-surround)

" Filetype settings
function! InitPythonBuf()
    nnoremap <buffer> <silent> <leader>d :VialPythonGotoDefinition<cr>
    nnoremap <buffer> <silent> <leader>f :VialPythonOutline<cr>
    nnoremap <buffer> <leader>l :VialPythonLint<cr>
    nnoremap <buffer> <leader>lf :call Flake8()<cr>
    nmap <buffer> <leader><cr> <Plug>VialPipeExecuteAll
    setlocal et sts=4 sw=4 tw=80 fo=croq

    syntax keyword pythonBuiltin self
    syntax keyword pythonKeyword print None
    syntax match pythonDotExpr "\.\w\+" contains=pythonKeyword
endfunction

function! InitLsBuf()
    syntax keyword Keyword require
    syntax match Function "->\|!->\|\~>\|<-\|<\~\|-->"
    syntax match lsAt "@"
    syntax match lsColon ":" containedin=lsProp
    syntax match lsDollar "\$" containedin=lsIdentifier
    hi! link lsProp Normal
    hi! link lsIdentifier Normal
    hi! link lsBoolean Keyword
    hi! link lsColon String
    hi! link lsDollar String
    hi! link lsAt String
    nnoremap <buffer> <leader>l :belowright vnew<cr>:setlocal buftype=nofile<cr>:read !lsc -cp #<cr>
endfunction

function! InitMongoBuf()
    setfiletype javascript
    nmap <buffer> <leader><cr> <Plug>VialPipeExecute
    vmap <buffer> <leader><cr> <Plug>VialPipeExecute
endfunction

function! InitPipeBuf()
    nmap <buffer> <leader><cr> <Plug>VialPipeExecute
    vmap <buffer> <leader><cr> <Plug>VialPipeExecute
endfunction

function! InitPipeBufAll()
    nmap <buffer> <leader><cr> <Plug>VialPipeExecuteAll
endfunction

function! GitDiff()
    silent keepalt edit __vial__gitdiff__
    setlocal buftype=nofile noswapfile
    setfiletype diff
    norm! ggVGD
    0read !git diff HEAD^ -p --stat --no-color --abbrev --stat-graph-width=5 --stat-name-width=200
    norm! gg
endfunction

augroup MyFileTypeSettings
    au!
    au FileType python call InitPythonBuf()
    au FileType ls call InitLsBuf()
    au FileType qf wincmd J
    au FileType sql nmap <buffer> <leader><cr> <Plug>VialPipeExecute
    au FileType sql vmap <buffer> <leader><cr> <Plug>VialPipeExecute
    au FileType c call InitPipeBufAll()
    au CursorHold * checktime
    au FileType vialcash nmap <buffer> <leader><cr> <Plug>VialPipeExecuteAll
    au BufNewFile,BufRead *.mongo call InitMongoBuf()
    au BufNewFile,BufRead *.clickhouse setfiletype sql
    au BufNewFile,BufRead *.pipe call InitPipeBuf()
    au BufNewFile,BufRead *.csd nmap <buffer> <leader><cr> <Plug>VialPipeExecuteAll
    au BufNewFile,BufRead *.cir call InitPipeBufAll()
    au BufNewFile,BufRead * setlocal iskeyword+=-
    au WinEnter,BufWinEnter __vial_* let w:airline_disabled=1
augroup END


" Vial
let g:vial_plugins = ['vial.plugins.grep', 'vial.plugins.misc', 'vial.plugins.bufhist']
let g:vial_python = 'python3'
nnoremap <leader>m :VialQuickOpen<cr>
nnoremap <silent> <leader>t :VialSearchOutline<cr>
" nnoremap <esc>p :VialPythonShowSignature<cr>
nnoremap <silent> <esc><esc> :VialEscape<cr>
nmap <leader>g <Plug>VialGrep
vmap <leader>g <Plug>VialGrep
nnoremap <leader>vg :VialGrep 
nnoremap <leader>la :VialPythonLintAll<cr>
nnoremap <leader>lt :VialPytestRun<cr>
nnoremap <leader>om :VialPythonOpenModule 
nnoremap <leader>cm :VialPythonCreateModule 
nmap <c-k> <Plug>VialBufHistPrev
nmap <c-j> <Plug>VialBufHistNext

let g:coc_global_extensions = ['coc-tsserver', 'coc-vetur']

" Other plugs
let g:AutoPairsMapCR = 0
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:qf_modifiable = 1
let g:table_mode_map_prefix = '<leader>b'
let g:zig_fmt_autosave = 0

let g:matchup_matchparen_deferred = 1

nnoremap <leader>v :Bufferlist<cr>
vnoremap <leader>ld :Linediff<cr>
nnoremap <leader>lr :LinediffReset<cr>

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
command! Vb normal! <C-v>

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
