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

colorscheme atlantic-dark
colorscheme codedark

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <silent> <C-n> :set relativenumber!<cr>

set timeout timeoutlen=1000 ttimeoutlen=150

set mouse=n
set ignorecase
set smartcase

set splitbelow
set splitright

let t:is_transparent = 0
function! Toggle_transparent()
    if t:is_transparent == 0
        highlight Normal ctermbg=none
        highlight NonText ctermbg=none
        let t:is_transparent = 1
    else
        colorscheme codedark
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

autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/
autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/,$RUST_SRC_PATH/rusty-tags.vi

" Assumes you have a Ruby with SiB available in the PATH
" If it doesn't work, you may need to `gem install seeing_is_believing`

function! WithoutChangingCursor(fn)
  let cursor_pos     = getpos('.')
  let wintop_pos     = getpos('w0')
  let old_lazyredraw = &lazyredraw
  let old_scrolloff  = &scrolloff
  set lazyredraw

  call a:fn()

  call setpos('.', wintop_pos)
  call setpos('.', cursor_pos)
  redraw
  let &lazyredraw = old_lazyredraw
  let scrolloff   = old_scrolloff
endfun

function! SibAnnotateAll(scope)
  call WithoutChangingCursor(function('execute', [a:scope . "!seeing_is_believing --timeout 12 --line-length 500 --number-of-captures 300 --alignment-strategy chunk"]))
endfun

function! SibAnnotateMarked(scope)
  call WithoutChangingCursor(function('execute', [a:scope . "!seeing_is_believing --xmpfilter-style --timeout 12 --line-length 500 --number-of-captures 300 --alignment-strategy chunk"]))
endfun

function! SibCleanAnnotations(scope)
  call WithoutChangingCursor(function('execute', [a:scope . "!seeing_is_believing --clean"]))
endfun

function! SibToggleMark()
  let pos  = getpos('.')
  let line = getline(".")
  if line =~ '^\s*$'
    let line = '# => '
  elseif line =~ '# =>'
    let line = substitute(line, ' *# =>.*', '', '')
  else
    let line .= '  # => '
  end
  call setline('.', line)
  call setpos('.', pos)
endfun

" Enable seeing-is-believing mappings only for Ruby
augroup seeingIsBelievingSettings
  " clear the settings if they already exist (so we don't run them twice)
  autocmd!
  autocmd FileType ruby nmap <buffer> <Leader>b :call SibAnnotateAll("%")<CR>;
  autocmd FileType ruby nmap <buffer> <Leader>n :call SibAnnotateMarked("%")<CR>;
  autocmd FileType ruby nmap <buffer> <Leader>v :call SibCleanAnnotations("%")<CR>;
  autocmd FileType ruby nmap <buffer> <Enter>   :call SibToggleMark()<CR>;
  autocmd FileType ruby vmap <buffer> <Enter>   :call SibToggleMark()<CR>;

  autocmd FileType ruby vmap <buffer> <Leader>b :call SibAnnotateAll("'<,'>")<CR>;
  autocmd FileType ruby vmap <buffer> <Leader>n :call SibAnnotateMarked("'<,'>")<CR>;
  autocmd FileType ruby vmap <buffer> <Leader>v :call SibCleanAnnotations("'<,'>")<CR>;
augroup END

:nnoremap <Leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>
