vim.g.mapleader = " "

local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn -- to call Vim functions e.g. fn.bufnr()
local g = vim.g -- a table to access global variables
local opt = vim.opt -- to set options
local lsp = vim.lsp -- to set options

local function map(mode, lhs, rhs, opts)
    local options = {
        noremap = true
    }
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map('', '<leader>c', '"+y') -- Copy to clipboard in normal, visual, select and operator modes
map('i', '<C-u>', '<C-g>u<C-u>') -- Make <C-u> undo-friendly
map('i', '<C-w>', '<C-g>u<C-w>') -- Make <C-w> undo-friendly

-- <Tab> to navigate the completion menu
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {
    expr = true
})
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {
    expr = true
})

map('n', '<C-l>', '<cmd>noh<CR>') -- Clear highlights
map('n', '<leader>o', 'm`o<Esc>``') -- Insert a newline in normal mode

-- local ts = require 'nvim-treesitter.configs'
-- ts.setup {
--     ensure_installed = 'maintained',
--     highlight = {
--         enable = true
--     }
-- }

-- Window movement
map('n', '<c-h>', '<c-w>h')
map('n', '<c-j>', '<c-w>j')
map('n', '<c-k>', '<c-w>k')
map('n', '<c-l>', '<c-w>l')

map('n', '<c-n>', ':set relativenumber!<CR>')

map('i', 'jk', '<Esc>')
map('i', 'kj', '<Esc>')

-- Commands
-- cmd [[command! WhatHighlight :call util#syntax_stack()]]
cmd [[command! PackerInstall packadd packer.nvim | lua require('plugins').install()]]
cmd [[command! PackerUpdate packadd packer.nvim | lua require('plugins').update()]]
cmd [[command! PackerSync packadd packer.nvim | lua require('plugins').sync()]]
cmd [[command! PackerClean packadd packer.nvim | lua require('plugins').clean()]]
cmd [[command! PackerCompile packadd packer.nvim | lua require('plugins').compile()]]

-- Autocommands
-- autocmd('start_screen', [[VimEnter * ++once lua require('start').start()]], true)
-- autocmd('misc_aucmds', { [[BufWinEnter * checktime]], [[TextYankPost * silent! lua vim.highlight.on_yank()]] }, true)

-- Colorscheme
-- cmd('colorscheme solarized')

opt.termguicolors = true
opt.background = 'light'
opt.number = true
opt.relativenumber = true

opt.softtabstop = 0
opt.expandtab = true
opt.shiftwidth = 4
opt.smarttab = true

opt.timeout = true
opt.timeoutlen = 200
opt.ttimeoutlen = 150
opt.mouse = 'n'
opt.ignorecase = true
opt.smartcase = true
opt.splitbelow = true
opt.splitright = true
opt.ruler = true
opt.wildmenu = true
opt.visualbell = false
opt.hlsearch = true
opt.incsearch = true

local nvim_lsp = require('lspconfig')
local on_attach = function(_, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    local opts = {
        noremap = true,
        silent = true
    }

    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gh', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>gn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
end

local servers = {
    {
        command = "rust_analyzer",
        format = true,
        settings = {
            ["rust_analyzer"] = {
                cargo = {
                    allFeatures = true
                },
                procMacro = {
                    enable = true
                },
                checkOnSave = {
                    command = "clippy"
                }
            }
        }
    }, {
        command = "hls",
        format = true
    }, {
        command = "tsserver",
        format = false
    }
}

for _, server in ipairs(servers) do
    nvim_lsp[server.command].setup {
        on_attach = function(client, bufnr)
            client.resolved_capabilities.document_formatting = server.format
            on_attach(client, bufnr)
        end,
        -- settings = servers.settings,
        flags = {
            debounce_text_changes = 150
        }
    }
end

local eslint = require "eslint"
local prettier = require "prettier"

nvim_lsp.efm.setup {
    on_attach = function(client, bufnr)
        client.resolved_capabilities.document_formatting = true
        client.resolved_capabilities.goto_definition = false
        on_attach(client, bufnr)
    end,
    init_options = {
        documentFormatting = true
    },
    filetypes = {"lua", "javascript", "typescript"},
    settings = {
        rootMarkers = {".git/"},
        languages = {
            lua = {
                {
                    formatCommand = "lua-format -i --no-keep-simple-function-one-line --no-break-after-operator --column-limit=150 --break-after-table-lb",
                    formatStdin = true
                }
            },
            javascript = {eslint},
            typescript = {eslint}
        }
    }
}

local system_name
if fn.has("mac") == 1 then
    system_name = "macOS"
elseif fn.has("unix") == 1 then
    system_name = "Linux"
elseif fn.has('win32') == 1 then
    system_name = "Windows"
else
    print("Unsupported system for sumneko")
end

local HOME = fn.expand('$HOME')
local sumneko_root_path = HOME .. '/lua-lsp'
local sumneko_binary = sumneko_root_path .. "/bin/" .. "/lua-language-server"

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require'lspconfig'.sumneko_lua.setup {
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
                path = runtime_path
            },
            diagnostics = {
                globals = {'vim'}
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true)
            },
            telemetry = {
                enable = false
            }
        }
    }
}

map('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>')
map('n', '<leader>gh', '<cmd>Gitsigns blame_line<CR>')
map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
map("n", "<leader>gq", "<cmd>lua vim.lsp.buf.formatting()<CR>")
-- map('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
--
map('n', '<leader>tt', ':NvimTreeToggle<CR>')
map('n', '<leader>tf', ':NvimTreeFocus<CR>')

-- telescope
--
map('n', '<leader>ff', '<cmd> lua require("telescope.builtin").find_files()<cr>');
map('n', '<leader>fg', '<cmd> lua require("telescope.builtin").live_grep()<cr>')
map('n', '<leader>fm', '<cmd> lua require("telescope.builtin").live_grep()<cr>')
map('n', '<leader>fb', '<cmd> lua require("telescope.builtin").buffers()<cr>')
map('n', '<leader>fh', '<cmd> lua require("telescope.builtin").help_tags()<cr>')
map('n', '<leader>ga', '<cmd> lua vim.lsp.buf.code_action()<cr>')
map('n', 'gra', '<cmd> lua require("telescope.builtin").lsp_range_code_actions()<cr>')
map('n', 'gr', '<cmd> lua require("telescope.builtin").lsp_references()<cr>')

-- autocommands
cmd('autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 1000)')
cmd('autocmd BufWritePre *.c lua vim.lsp.buf.formatting_sync(nil, 1000)')
cmd('autocmd BufWritePre *.js lua vim.lsp.buf.formatting_sync(nil, 1000)')
cmd('autocmd BufWritePre *.ts lua vim.lsp.buf.formatting_sync(nil, 1000)')
cmd('autocmd BufWritePre *.lua lua vim.lsp.buf.formatting_sync(nil, 1000)')

-- vim.lsp.set_log_level("debug")

function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end

cmd('au! BufRead,BufNewFile *.glsl,*.vert,*.frag set filetype=glsl')

require('rust-tools').setup({
    server = {
        ["rust_analyzer"] = {
            cargo = {
                allFeatures = true
            },
            procMacro = {
                enable = true
            },
            checkOnSave = {
                command = "clippy"
            }
        }
    }
})
