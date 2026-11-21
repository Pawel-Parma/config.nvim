return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "TodoTelescope", "TodoQuickFix" },
  opts = {},
  keys = {
    { mode = "n", "<leader>ts", "<cmd>TodoTelescope keywords=TODO,FIX<CR>", desc = "Search TODO/FIX comments" },
    { mode = "n", "<leader>qt", ":TodoQuickFix<CR>",                        desc = "Open TODOs in quickfix" }
  },
}
