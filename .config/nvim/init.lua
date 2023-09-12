-- Start lazy package manager setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

require("lazy").setup("plugins")
-- End lazy package manager setup

local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn   -- to call Vim functions e.g. fn.bufnr()
local g = vim.g     -- a table to access global variables
local opt = vim.opt -- to set options
local lsp = vim.lsp -- to set options

local function map(mode, lhs, rhs, opts)
    local options = {
        noremap = true
    }
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map('', '<leader>c', '"+y')      -- Copy to clipboard in normal, visual, select and operator modes
map('i', '<C-u>', '<C-g>u<C-u>') -- Make <C-u> undo-friendly
map('i', '<C-w>', '<C-g>u<C-w>') -- Make <C-w> undo-friendly

-- <Tab> to navigate the completion menu
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {
    expr = true
})
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {
    expr = true
})

map('n', '<C-l>', '<cmd>noh<CR>')   -- Clear highlights
map('n', '<leader>o', 'm`o<Esc>``') -- Insert a newline in normal mode

-- local ts = require 'nvim-treesitter.configs'
-- ts.setup {
--     ensure_installed = 'maintained',
--     highlight = {
--         enable = true
--     }
-- }

-- Window movement
vim.keymap.set('n', '<c-h>', '<c-w>h', { desc = 'move to left tab' })
vim.keymap.set('n', '<c-j>', '<c-w>j', { desc = 'move to bottom tab' })
vim.keymap.set('n', '<c-k>', '<c-w>k', { desc = 'move to tab above' })
vim.keymap.set('n', '<c-l>', '<c-w>l', { desc = 'move to right tab' })

vim.keymap.set('n', '<c-n>', ':set relativenumber!<CR>', { desc = 'toggle rel num' })

vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('i', 'kj', '<Esc>')

-- Colorscheme
cmd('colorscheme shine')

opt.termguicolors = true
opt.background = 'dark'
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

opt.makeprg = "just"

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

-- local eslint = require "eslint"
-- local prettier = require "prettier"
--
-- nvim_lsp.efm.setup {
--     on_attach = function(client, bufnr)
--         client.resolved_capabilities.document_formatting = true
--         client.resolved_capabilities.goto_definition = false
--         on_attach(client, bufnr)
--     end,
--     init_options = {
--         documentFormatting = true
--     },
--     filetypes = {"lua", "javascript", "typescript"},
--     settings = {
--         rootMarkers = {".git/"},
--         languages = {
--             lua = {
--                 {
--                     formatCommand = "lua-format -i --no-keep-simple-function-one-line --no-break-after-operator --column-limit=150 --break-after-table-lb",
--                     formatStdin = true
--                 }
--             },
--             javascript = {eslint},
--             typescript = {eslint}
--         }
--     }
-- }

require 'lspconfig'.lua_ls.setup {
    on_init = function(client)
        local path = client.workspace_folders[1].name
        if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
            client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
                Lua = {
                    runtime = {
                        -- Tell the language server which version of Lua you're using
                        -- (most likely LuaJIT in the case of Neovim)
                        version = 'LuaJIT'
                    },
                    -- Make the server aware of Neovim runtime files
                    workspace = {
                        checkThirdParty = false,
                        library = {
                            vim.env.VIMRUNTIME
                            -- "${3rd}/luv/library"
                            -- "${3rd}/busted/library",
                        }
                        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                        -- library = vim.api.nvim_get_runtime_file("", true)
                    }
                }
            })

            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        end
        return true
    end
}

vim.keymap.set('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', { desc = 'hover [LSP]' })
vim.keymap.set('n', '<leader>gh', '<cmd>Gitsigns blame_line<CR>', { desc = 'git blame line' })
vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { desc = 'goto definition [LSP]' })
vim.keymap.set("n", "<leader>gq", "<cmd>lua vim.lsp.buf.format()<CR>", { desc = 'format [LSP]' })
-- vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
--
vim.keymap.set('n', '<leader>tt', ':NvimTreeToggle<CR>', { desc = 'nvim tree toggle' })
vim.keymap.set('n', '<leader>tf', ':NvimTreeFocus<CR>', { desc = 'nvim tree focus' })

-- telescope
--
vim.keymap.set('n', '<leader>ff', '<cmd> lua require("telescope.builtin").find_files()<cr>',
    { desc = 'find files [telescope]' });
vim.keymap.set('n', '<leader>fg', '<cmd> lua require("telescope.builtin").live_grep()<cr>',
    { desc = 'live grep [telescope]' })
vim.keymap.set('n', '<leader>fb', '<cmd> lua require("telescope.builtin").buffers()<cr>',
    { desc = 'buffer picker [telescope]' })
vim.keymap.set('n', '<leader>fh', '<cmd> lua require("telescope.builtin").help_tags()<cr>',
    { desc = 'find in help [telescope]' })
vim.keymap.set('n', '<leader>ga', '<cmd> lua vim.lsp.buf.code_action()<cr>', { desc = 'code action [LSP]' })
vim.keymap.set('n', 'gra', '<cmd> lua require("telescope.builtin").lsp_range_code_actions()<cr>',
    { desc = 'range code action [LSP]' })
vim.keymap.set('n', 'gr', '<cmd> lua require("telescope.builtin").lsp_references()<cr>',
    { desc = 'find references [LSP]' })

-- autocommands
cmd('autocmd BufWritePre *.rs lua vim.lsp.buf.format()')
cmd('autocmd BufWritePre *.c lua vim.lsp.buf.format()')
cmd('autocmd BufWritePre *.js lua vim.lsp.buf.format()')
cmd('autocmd BufWritePre *.ts lua vim.lsp.buf.format()')
cmd('autocmd BufWritePre *.lua lua vim.lsp.buf.format()')

-- vim.lsp.set_log_level("debug")

function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, { ... })
    print(unpack(objects))
end

cmd('au! BufRead,BufNewFile *.glsl,*.vert,*.frag set filetype=glsl')
