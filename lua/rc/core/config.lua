vim.opt.compatible = false

vim.g.netrw_banner = 0
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.opt.mouse = ""

vim.opt.scrolloff = 12

vim.opt.rnu = true
vim.opt.nu = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showmatch = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

vim.opt.inccommand = "nosplit"

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.vim/undodir")
vim.opt.updatetime = 150

vim.opt.termguicolors = true

vim.opt.colorcolumn = "130"
vim.opt.signcolumn = "yes"

vim.opt.cursorline = true

vim.opt.completeopt = { "menu", "menuone", "noselect" }
