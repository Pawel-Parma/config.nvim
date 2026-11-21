return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-mini/mini.icons" },
    opts = {
      default_file_explorer = false,
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      watch_for_changes = true,
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ["q"] = { mode = "n", "actions.close", nowait = true, desc = "Close oil" },
      },
      float = {
        padding = 0,
        max_height = 0.8,
        max_width = 0.8,
        border = "rounded",
      },
    },
    keys = {
      {
        mode = "n",
        "-",
        function()
          require("oil").toggle_float()
        end,
        desc = "Toggle oil float",
      },
    },
  },
  {
    "malewicz1337/oil-git.nvim",
    dependencies = { "stevearc/oil.nvim" },
    ft = "oil",
    opts = {},
  },
  {
    "JezerM/oil-lsp-diagnostics.nvim",
    dependencies = { "stevearc/oil.nvim" },
    ft = "oil",
    opts = {
      diagnostic_symbols = {
        error = "",
        warn = "",
        info = "",
        hint = "󰌶",
      },
    },
  },
}
