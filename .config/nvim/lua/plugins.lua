vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    use {
        'lewis6991/gitsigns.nvim',
        requires = {'nvim-lua/plenary.nvim'},
        config = function()
            require('gitsigns').setup()
        end
    }
    use 'ishan9299/nvim-solarized-lua'
    -- use {
    --     'nvim-treesitter/nvim-treesitter',
    --     requires = {'nvim-treesitter/nvim-treesitter-refactor', 'nvim-treesitter/nvim-treesitter-textobjects'},
    --     run = ':TSUpdate',
    --     config = function()
    --         require'nvim-treesitter.configs'.setup {
    --             ensure_installed = {"glsl", "kotlin"}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    --             highlight = {
    --                 enable = true,
    --                 disable = {"c", "rust"},
    --                 additional_vim_regex_highlighting = false
    --             }
    --         }
    --     end
    -- }
    use {
        'hrsh7th/nvim-compe',
        event = 'InsertEnter *'
    }
    use {
        'norcalli/nvim-colorizer.lua',
        ft = {'css', 'javascript', 'vim', 'html'},
        config = [[require('colorizer').setup {'css', 'javascript', 'vim', 'html'}]]
    }
    use 'unblevable/quick-scope'
    use 'vmchale/ion-vim'
    use 'neovim/nvim-lspconfig'
    use 'kosayoda/nvim-lightbulb'
    use 'nvim-lua/completion-nvim'
    use 'simrat39/rust-tools.nvim'
    use {
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
        config = function()
            require('telescope').setup {
                defaults = {
                    vimgrep_arguments = {'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case'}
                }
            }
        end
    }
    use {
        'kyazdani42/nvim-tree.lua',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function()
            require'nvim-tree'.setup {}
        end
    }
    use 'cespare/vim-toml'
    use 'gpanders/editorconfig.nvim'
    use 'stevearc/dressing.nvim'
end)
