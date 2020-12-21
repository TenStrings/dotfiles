"""""""""""""
"  PLUGINS  "
"""""""""""""
" including plugin-related mappings and autocmds
"" Install vim-plug if not installed 
" commands for plugins -> :PlugInstall, :PlugUpdate [name], :PlugClean
" upgrade vim-plug     -> :PlugUpgrade

" download and install vim-plug if it is not installed yet
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

"" List of plugins
call plug#begin()
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'leshill/vim-json'
Plug 'tomasiser/vim-code-dark'
Plug 'vim-airline/vim-airline'
Plug 'enricobacis/vim-airline-clock'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'
Plug 'cespare/vim-toml'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes'
Plug 'unblevable/quick-scope'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'vmchale/ion-vim'
Plug 'vim-airline/vim-airline-themes'
Plug 'chrisbra/Colorizer'
Plug 'rakr/vim-one'
Plug 'yasukotelin/shirotelin'
Plug 'chrisbra/Colorizer'
Plug 'tpope/vim-fugitive'
Plug 'kana/vim-fakeclip'
call plug#end()

""""""""""""""""""""""""
"  ASYNC COMPLETE      "
""""""""""""""""""""""""
let g:asyncomplete_smart_completion = 1
let g:asyncomplete_auto_popup = 1

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
"""""""""""""
"  LSP      "
"""""""""""""
"" settings
let g:lsp_signs_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_highlight_references_enabled = 1
"" typescript language server
if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'javascript support using typescript-language-server',
      \ 'cmd': { server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
      \ 'root_uri': { server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git/..'))},
      \ 'whitelist': ['javascript', 'javascript.jsx']
      \ })
endif

autocmd FileType javascript nnoremap ;d :LspDefinition<CR>
autocmd FileType javascript nnoremap ;vd :vsplit<CR>:LspDefinition<CR>
autocmd FileType javascript nnoremap ;sd :split<CR>:LspDefinition<CR>
autocmd FileType javascript nnoremap ;r :LspRename<CR>

let g:lsp_settings_filetype_rust = ['rust-analyzer', 'rls']

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"

""""""""""""""""""""""""
"  CUSTOM KEYBINDINGS  "
""""""""""""""""""""""""
"" Splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"" Escape
imap jk <Esc>
imap kj <Esc>

nnoremap <silent> <C-n> :set relativenumber!<cr>

""" Transparent function
let t:is_transparent = 0
function! Toggle_transparent()
    if t:is_transparent == 0
        let t:is_transparent = 1
    else
        let t:is_transparent = 0
    endif
endfunction
nnoremap <C-t> : call Toggle_transparent()<CR>


""""""""""""""""""""""""
"  PERSONAL SETTINGS   "
""""""""""""""""""""""""

set nu
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab

set nocompatible
set path+=**

" Ignore the public directory when using :find with wildmenu
set wildignore+=**/public/**

set timeout timeoutlen=200 ttimeoutlen=150

set mouse=n
set ignorecase
set smartcase

set splitbelow
set splitright

set ruler

"" netrw
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_winsize = 25
" open new files in a new tab
let g:netrw_browse_split = 3

"" fuzzy finding
set path+=**
set wildmenu

set visualbell noerrorbells

set autoread

if executable("rg")
    set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
endif

set shell=/usr/bin/sh

"" netrw
" tree like view
let g:netrw_liststyle = 3
let g:netrw_banner = 0
" open in previous window (1 = hsplit, vsplit, tab, previous window)
let g:netrw_browse_split = 4
" keep at % size
let g:netrw_winsize = 20

augroup netrw_mapping
    autocmd!
    autocmd FileType netrw nnoremap <c-l> <C-w>l<CR>
augroup END

function! NetrwMapping()
    noremap <buffer> <c-l> <c-w>l<CR>
endfunction

""""""""""""""""""""""""
"  COLORSCHEMES        "
""""""""""""""""""""""""
" colorscheme shirotelin
highlight Normal ctermbg=none
highlight NonText ctermbg=none

""""""""""""""""""""""""
"  SNIPPETS            "
""""""""""""""""""""""""
"" Auto
""" Bash
if has("autocmd")
  augroup templates
    autocmd BufNewFile *.sh 0r ~/.vim/templates/skeleton.sh
  augroup END
endif

nnoremap ,rcomp :-1read $HOME/.vim/templates/component.jsx<CR>/SkeletonName<CR>vgn
nnoremap ,jest :-1read $HOME/.vim/templates/component.test.jsx<CR>7j
nnoremap ,sh :-1read $HOME/.vim/templates/skeleton.sh<CR>o<Esc>o

""" JS
autocmd FileType javascript nnoremap ;d :LspDefinition<CR>
autocmd FileType javascript nnoremap ;vd :vsplit<CR>:LspDefinition<CR>
autocmd FileType javascript nnoremap ;sd :split<CR>:LspDefinition<CR>
autocmd FileType javascript nnoremap ;r :LspRename<CR>

""" Rust
autocmd FileType rust nnoremap gd :LspDefinition<CR>
autocmd FileType rust nnoremap gh :LspHover<CR>
autocmd FileType rust nnoremap gh :LspHover<CR>
" Setting rustfmt as a formatter may also be an option
autocmd FileType rust nnoremap gq :LspDocumentFormat<CR>

":command Datetime :put =strftime('%Y/%m/%d %T')<CR>kJ

nnoremap <Leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>


"""""""""""""""""""""""""""""""""""""""""""
"  AUTOCOMMANDS, incl. FILETYPE SETTINGS  "
"""""""""""""""""""""""""""""""""""""""""""
"" Autofolding .vimrc
" see http://vimcasts.org/episodes/writing-a-custom-fold-expression/
""" defines a foldlevel for each line of code
function! VimFolds(lnum)
  let s:thisline = getline(a:lnum)
  if match(s:thisline, '^"" ') >= 0
    return '>2'
  endif
  if match(s:thisline, '^""" ') >= 0
    return '>3'
  endif
  let s:two_following_lines = 0
  if line(a:lnum) + 2 <= line('$')
    let s:line_1_after = getline(a:lnum+1)
    let s:line_2_after = getline(a:lnum+2)
    let s:two_following_lines = 1
  endif
  if !s:two_following_lines
      return '='
    endif
  else
    if (match(s:thisline, '^"""""') >= 0) &&
       \ (match(s:line_1_after, '^"  ') >= 0) &&
       \ (match(s:line_2_after, '^""""') >= 0)
      return '>1'
    " elseif (match(s:thisline, '^"---') >= 0) &&
    "    \ (match(s:line_1_after, '^"- ') >= 0) &&
    "    \ (match(s:line_2_after, '^"---') >= 0)
    "   return '>2'
    else
      return '='
    endif
  endif
endfunction

""" defines a foldtext
function! VimFoldText()
  " handle special case of normal comment first
  let s:info = '('.string(v:foldend-v:foldstart).' l)'
  if v:foldlevel == 1
    let s:line = ' ◇ '.getline(v:foldstart+1)[3:-2]
  elseif v:foldlevel == 2
    let s:line = '   ●  '.getline(v:foldstart)[3:]
  elseif v:foldlevel == 3
    let s:line = '     ▪ '.getline(v:foldstart)[4:]
  endif
  if strwidth(s:line) > 80 - len(s:info) - 3
    return s:line[:79-len(s:info)-3+len(s:line)-strwidth(s:line)].'...'.s:info
  else
    return s:line.repeat(' ', 80 - strwidth(s:line) - len(s:info)).s:info
  endif
endfunction

""" set foldsettings automatically for vim files
augroup fold_vimrc
  autocmd!
  " autocmd FileType vim
  autocmd BufReadPre $MYVIMRC
                   \ setlocal foldmethod=expr |
                   \ setlocal foldexpr=VimFolds(v:lnum) |
                   \ setlocal foldtext=VimFoldText() |
     "              \ set foldcolumn=2 foldminlines=2
augroup END

"" Auto reload .vimrc when editing
autocmd BufWritePost .vimrc source %
"" colors
let g:colorizer_auto_filetype='scss,css,html'


"" gitcommit
au FileType gitcommit setlocal tw=72

