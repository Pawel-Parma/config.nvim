vim.keymap.set("n", "<C-j>", function()
  vim.cmd.normal("Q2q=j1q=")
end, { desc = "Add cursor below" })
-- vim.keymap.set("n", "<C-j>", "Q2q=j1q=", { desc = "Add cursor below"})
vim.keymap.set("n", "<C-k>", function()
  vim.cmd.normal("Q2q=k1q=")
end, { desc = "Add cursor above" })
-- vim.keymap.set("n", "<C-k>", "2q=Q2q=k1q=", { desc = "Add cursor above"})
--
vim.keymap.set("n", "<C-n>", "nQ<cmd>nohlsearch<CR>", { desc = "Move to next match and toggle cursor" })
-- FIX: § is a workaround around the fact that windows terminal doesn't use kitty keyboard protocol for wsl so C-n is the same as C-S-n
-- to make it fully windows terminal must send § on C-S-n and nvim must respond to it
-- ghostty on windows when :(
vim.keymap.set("n", { "<C-S-N>", "§" }, "NQ2q=<cmd>nohlsearch<CR>1q=",
  { desc = "Move to previous match and toggle cursor" })
