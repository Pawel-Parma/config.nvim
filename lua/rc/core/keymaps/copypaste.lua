vim.keymap.set("x", "p", '"_dP', { desc = "Paste over selection without yanking" })
vim.keymap.set({ "n", "x" }, "gp", '"+p', { desc = "Paste after from system clipboard" })
vim.keymap.set({ "n", "x" }, "gP", '"+P', { desc = "Paste before from system clipboard" })

vim.keymap.set({ "n", "x" }, "gy", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set({ "n", "x" }, "gY", '"+Y', { desc = "Yank line to system clipboard" })

vim.keymap.set("n", "x", '"_x', { desc = "Delete character without yanking" })
vim.keymap.set("n", "X", '"_X', { desc = "Delete character before cursor without yanking" })
