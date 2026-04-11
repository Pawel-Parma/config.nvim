vim.opt_local.shiftwidth = 2

vim.keymap.set("n", "<leader>x", ":.lua<CR>", { desc = "Execute line of lua in nvim" })
vim.keymap.set("x", "<leader>x", ":lua<CR>", { desc = "Execute selection of lua in nvim" })
vim.keymap.set("n", "<leader><leader>x", ":source %<CR>", { desc = "Execute lua file in nvim" })
