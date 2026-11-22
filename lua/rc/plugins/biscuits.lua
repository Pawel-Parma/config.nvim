return {
  "code-biscuits/nvim-biscuits",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    default_config = {
      toggle_keybind = "<leader>tb",
      min_distance = 1,
      prefix_string = "",
      show_on_start = false,
      -- cursor_line_only = true,
      cursor_line_only = false,
    },
  },
  keys = {
    { "<leader>tb" },
  },
}
