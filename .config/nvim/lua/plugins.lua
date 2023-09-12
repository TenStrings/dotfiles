return {
    {
        'lewis6991/gitsigns.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('gitsigns').setup()
        end
    },
    { 'ishan9299/nvim-solarized-lua' },
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = { 'nvim-treesitter/nvim-treesitter-refactor', 'nvim-treesitter/nvim-treesitter-textobjects' },
        run = ':TSUpdate',
        config = function()
            require 'nvim-treesitter.configs'.setup {
                ensure_installed = { "glsl", "kotlin", "solidity" }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
                highlight = {
                    enable = true,
                    -- disable = { "c", "rust", "lua" },
                    additional_vim_regex_highlighting = false
                }
            }
        end
    },
    {
        'hrsh7th/nvim-compe',
        event = 'InsertEnter *'
    },
    {
        'norcalli/nvim-colorizer.lua',
        ft = { 'css', 'javascript', 'vim', 'html' },
        config = [[require('colorizer').setup {'css', 'javascript', 'vim', 'html'}]]
    },
    { 'unblevable/quick-scope' },
    { 'vmchale/ion-vim' },
    { 'neovim/nvim-lspconfig' },
    { 'kosayoda/nvim-lightbulb' },
    { 'nvim-lua/completion-nvim' },
    {
        'simrat39/rust-tools.nvim',
        ft = { 'rust' },
        config = function()
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
        end
    },
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('telescope').setup {
                defaults = {
                    vimgrep_arguments = { 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number',
                        '--column', '--smart-case' }
                },
                pickers = {
                    colorscheme = {
                        enable_preview = true
                    }
                }
            }
        end
    },
    {
        'kyazdani42/nvim-tree.lua',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function()
            require 'nvim-tree'.setup {}
        end
    },
    { 'cespare/vim-toml' },
    { 'gpanders/editorconfig.nvim' },
    { 'stevearc/dressing.nvim' },
    {
        'martineausimon/nvim-lilypond-suite',
        requires = 'MunifTanjim/nui.nvim',
        fs = 'lilypond',
        config = function()
            require('nvls').setup({
                -- edit config here (see "Customize default settings" in wiki)
            })
        end
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    }
}
