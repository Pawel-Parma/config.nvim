# Nvim Config
My personal Nvim config

> [!important] 
> Requires Neovim v0.13.0

## Table of Contents
- [Installation](#installation)
  - [Install Requirements](#1-install-requirements)
  - [Backup Old Config](#2-backup-old-nvim-config)
  - [Install](#3-install)
  - [Activate](#4-activate)
- [List of plugins](#list-of-plugins)

# Installation
## 1. Install requirements:
There are some basic ones like:  
a C compiler, wget, curl, git, diff, tar, gzip, zip/unzip, python3.
And the ones you probably need to install:
- [ripgrep](https://github.com/BurntSushi/ripgrep#Installation) 
- [fd](https://github.com/sharkdp/fd) 
- [node](https://github.com/nodejs/node)
- [tree-sitter-cli](https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md)

## 2. Backup old config:  
```sh
mv ~/.config/nvim ~/.config/nvim.ancient
```

## 3. Install:
```sh
git clone https://github.com/Pawel-Parma/nvim-config ~/.config/nvim
```

## 4. Activate:
The packages and linters will be automatically downloaded the next time you open neovim
```sh
nvim
```

## 5. Health check:
To ensure that the installation procceded as expected, inside neovim run
```vim
:checkhealth
```

# List of Plugins
- [goolord/alpha-nvim](https://github.com/goolord/alpha-nvim)  
- [windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs)
- [saghen/blink.cmp](https://github.com/saghen/blink.cmp)
- [catppuccin/nvim](https://github.com/catppuccin/nvim)
- [laytan/cloak.nvim](https://github.com/laytan/cloak.nvim)  
- [ej-shafran/compile-mode.nvim](https://github.com/ej-shafran/compile-mode.nvim)
- [stevearc/conform.nvim](https://github.com/stevearc/conform.nvim)
- [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- [m4xshen/hardtime.nvim](https://github.com/m4xshen/hardtime.nvim)
- [theprimeagen/harpoon](https://github.com/theprimeagen/harpoon)  
- [junnplus/lsp-setup.nvim](https://github.com/junnplus/lsp-setup.nvim)
- [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)  
- [OXY2DEV/markview.nvim](https://github.com/OXY2DEV/markview.nvim)
- [nvim-mini/mini.icons](https://github.com/nvim-mini/mini.icons)
- [rcarriga/nvim-notify](https://github.com/rcarriga/nvim-notify)
- [stevearc/oil.nvim](https://github.com/stevearc/oil.nvim)  
- [malewicz1337/oil-git.nvim](https://github.com/malewicz1337/oil-git.nvim)
- [JezerM/oil-lsp-diagnostics.nvim](https://github.com/JezerM/oil-lsp-diagnostics.nvim) 
- [stevearc/quicker.nvim](https://github.com/stevearc/quicker.nvim)
- [folke/snacks.nvim](https://github.com/folke/snacks.nvim)
- [kylechui/nvim-surround](https://github.com/kylechui/nvim-surround)
- [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)  
- [folke/todo-comments.nvim](https://github.com/folke/todo-comments.nvim)  
- [leblocks/toggle.nvim](https://github.com/leblocks/toggle.nvim)
- [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)  
- [mbbill/undotree](https://github.com/mbbill/undotree)  
- [romainl/vim-cool](https://github.com/romainl/vim-cool)  
- [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [m00qek/baleia.nvim](https://github.com/m00qek/baleia.nvim)
- [MunifTanjim/nui.nvim](https://github.com/MunifTanjim/nui.nvim)
- [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [mason-org/mason.nvim](https://github.com/mason-org/mason.nvim)
- [mason-org/mason.nvim](https://github.com/mason-org/mason.nvim)
- [mason-org/mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim)
- [nvim-telescope/telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim)
- [nvim-telescope/telescope-ui-select.nvim](https://github.com/nvim-telescope/telescope-ui-select.nvim)
 

