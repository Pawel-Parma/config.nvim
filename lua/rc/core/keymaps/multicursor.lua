vim.keymap.set("n", "<C-j>", "Q2q=j1q=", { desc = "Add cursor below" })
vim.keymap.set("n", "<C-k>", "Q2q=k1q=", { desc = "Add cursor above" })
--
vim.keymap.set("n", "<C-n>", "nQ<cmd>nohlsearch<CR>", { desc = "Move to next match and toggle cursor" })
-- FIX: § is a workaround around the fact that Windows Terminal doesn't use Kitty Keyboard Protocol for WSL so C-n is the same as C-S-n
-- to make it fully windows terminal must send § on C-S-n and nvim must respond to it
-- ghostty on windows when :(
vim.keymap.set("n", { "<C-S-N>", "§" }, "NQ2q=<cmd>nohlsearch<CR>1q=",
  { desc = "Move to previous match and toggle cursor" })
