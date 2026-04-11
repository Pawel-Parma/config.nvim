return {
  'stevearc/oil.nvim',
  opts = {},
  dependencies = { "nvim-mini/mini.icons" },
  config = function()
    local oil = require("oil")
    oil.setup({
      default_file_explorer = false,
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ["q"] = { "actions.close", mode = "n", nowait = true },
      },
      float = {
        padding = 0,
        max_height = 0.8,
        max_width = 0.8,
        border = "rounded",
      },
    })
    vim.keymap.set("n", "-", oil.toggle_float, { desc = "Oil - toggle float" })
    vim.keymap.set("n", "<leader>o", oil.toggle_float, { desc = "Oil - toggle float" })
  end,
}
