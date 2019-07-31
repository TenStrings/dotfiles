autocmd BufWritePost .vimrc source %

set nu
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab

set nocompatible
set path+=**

call plug#begin()
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'w0rp/ale'
Plug 'leshill/vim-json'
Plug 'tomasiser/vim-code-dark'
Plug 'vim-airline/vim-airline'
Plug 'enricobacis/vim-airline-clock'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'
Plug 'cespare/vim-toml'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes'
Plug 'unblevable/quick-scope'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'vmchale/ion-vim'
call plug#end()

if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'javascript support using typescript-language-server',
      \ 'cmd': { server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
      \ 'root_uri': { server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git/..'))},
      \ 'whitelist': ['javascript', 'javascript.jsx']
      \ })
endif

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
    \ 'name': 'file',
    \ 'whitelist': ['*'],
    \ 'priority': 10,
    \ 'completor': function('asyncomplete#sources#file#completor')
    \ }))

let g:asyncomplete_smart_completion = 1
let g:asyncomplete_auto_popup = 1

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"

let g:ale_fixers = {
\ 'javascript': ['prettier', 'eslint'],
\  '*': ['remove_trailing_lines', 'trim_whitespace']
\}
let g:ale_linters = {'javascript': ['eslint']}
let g:ale_fix_on_save = 1
let g:ale_linters_explicit = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

imap jk <Esc>
imap kj <Esc>

nnoremap <silent> <C-n> :set relativenumber!<cr>

set timeout timeoutlen=200 ttimeoutlen=150

set mouse=n
set ignorecase
set smartcase

set splitbelow
set splitright

colorscheme dracula
highlight Normal ctermbg=none
highlight NonText ctermbg=none

let t:is_transparent = 0
function! Toggle_transparent()
    if t:is_transparent == 0
        let t:is_transparent = 1
    else
        let t:is_transparent = 0
    endif
endfunction
nnoremap <C-t> : call Toggle_transparent()<CR>

if has("autocmd")
  augroup templates
    autocmd BufNewFile *.sh 0r ~/.vim/templates/skeleton.sh
  augroup END
endif

nnoremap ,rcomp :-1read $HOME/.vim/templates/component.jsx<CR>/SkeletonName<CR>vgn
nnoremap ,jest :-1read $HOME/.vim/templates/component.test.jsx<CR>7j
nnoremap ,sh :-1read $HOME/.vim/templates/skeleton.sh<CR>o<Esc>o
autocmd FileType javascript nnoremap ;d :LspDefinition<CR>
autocmd FileType javascript nnoremap ;vd :vsplit<CR>:LspDefinition<CR>
autocmd FileType javascript nnoremap ;sd :split<CR>:LspDefinition<CR>
autocmd FileType javascript nnoremap ;r :LspRename<CR>

":command Datetime :put =strftime('%Y/%m/%d %T')<CR>kJ

nmap <silent> ;F <Plug>(ale_previous_wrap)
nmap <silent> ;f <Plug>(ale_next_wrap)

set ruler

nnoremap <Leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>
