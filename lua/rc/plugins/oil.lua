return {
  {
    'stevearc/oil.nvim',
    dependencies = { "nvim-mini/mini.icons" },
    config = function()
      local oil = require("oil")
      oil.setup({
        default_file_explorer = false,
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        watch_for_changes = true,
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
    end,
  },
  {
    "malewicz1337/oil-git.nvim",
    dependencies = { "stevearc/oil.nvim" },
  },
  {
    "JezerM/oil-lsp-diagnostics.nvim",
    dependencies = { "stevearc/oil.nvim" },
    opts = {
      diagnostic_symbols = {
        error = "",
        warn = "",
        info = "",
        hint = "󰌶",
      }
    }
  },
}
