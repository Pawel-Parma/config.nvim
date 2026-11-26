vim.keymap.set("x", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("x", ">", ">gv", { desc = "Indent right and reselect" })

vim.keymap.set("n", "<leader>b", ":silent! buffer #<CR>", { desc = "Switch to alternate buffer" })

vim.keymap.set("x", "<leader>/", function()
  vim.cmd("normal \"zy")
  local content = vim.fn.getreg("z")
  if content == "" then return end
  vim.fn.setreg("/", "\\V" .. vim.fn.escape(content, [[\/]]))
end, { desc = "Set search register to visual selection" })
