return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local todo = require("todo-comments")
    todo.setup()
    vim.keymap.set("n", "<leader>ts", function() vim.cmd [[:TodoTelescope keywords=TODO,FIX]] end, {})
    vim.keymap.set("n", "<leader>ct", ":TodoQuickFix<CR>")
  end
}
