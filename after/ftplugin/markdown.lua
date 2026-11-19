vim.keymap.set("n", "<leader>mm", function()
  vim.wo.conceallevel = vim.wo.conceallevel == 0 and 2 or 0
end)

vim.keymap.set("n", "<leader>mn", function()
  vim.wo.conceallevel = (vim.wo.conceallevel + 1) % 3
end)
