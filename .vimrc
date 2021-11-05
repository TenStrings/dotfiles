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
" Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline'
Plug 'enricobacis/vim-airline-clock'
Plug 'cespare/vim-toml'
Plug 'unblevable/quick-scope'
Plug 'vim-airline/vim-airline-themes'
Plug 'vmchale/ion-vim'
" Collection of common configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'
" Extensions to built-in LSP, for example, providing type inlay hints
Plug 'nvim-lua/lsp_extensions.nvim'
" Autocompletion framework for built-in LSP
Plug 'nvim-lua/completion-nvim'
" Plug 'yasukotelin/shirotelin'
Plug 'cormacrelf/vim-colors-github'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'editorconfig/editorconfig-vim'
call plug#end()


""""""""""""""""""""""""
"  COLORSCHEMES        "
""""""""""""""""""""""""
set t_Co=256

syntax enable
"let g:airline_theme='solarized'
set background=light
" colorscheme shirotelin

colorscheme github

" if you use airline / lightline
let g:airline_theme = "github"
let g:lightline = { 'colorscheme': 'github' }

highlight Normal ctermbg=none
highlight NonText ctermbg=none

" set hlsearch
" hi Search ctermbg=Blue
" hi Search ctermfg=White
" hi Pmenu ctermfg=White ctermbg=Black guibg=LightMagenta

"""""""""""""
"  LSP      "
"""""""""""""
"" settings

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c

" Configure LSP
" https://github.com/neovim/nvim-lspconfig#rust_analyzer
lua <<EOF

-- nvim_lsp object
local nvim_lsp = require'lspconfig'

-- function to attach completion when setting up lsp
local on_attach = function(client)
    require'completion'.on_attach(client)
end

-- Enable rust_analyzer
nvim_lsp.rust_analyzer.setup({ 
    on_attach=on_attach, 
    settings={ 
        ['rust-analyzer'] = {
            ['cargo'] = {
                ['allFeatures'] = true
            },
            ['checkOnSave'] = {
                ['command'] = 'clippy'
            },
        }
    }
})

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)
EOF

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" use <Tab> as trigger keys
imap <Tab> <Plug>(completion_smart_tab)
imap <S-Tab> <Plug>(completion_smart_s_tab)

" Code navigation shortcuts
" nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gh     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gq    <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>
" nnoremap <silent> <Space>gr    <cmd>lua vim.lsp.buf.rename()<CR>

autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 1000)

set signcolumn=yes
" not sure about this tbh
set updatetime=100

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

"" this is not a  keybinding, but I like to keep both settings together
set relativenumber
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

