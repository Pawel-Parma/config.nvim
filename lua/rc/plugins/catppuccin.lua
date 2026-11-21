return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  opts = {
    term_colors = true,
    flavour = "mocha",
    transparent_background = true,
    float = {
      transparent = true,
    },
    show_end_of_buffer = true,
    custom_highlights = function(colors)
      return {
        MyHeaderHighlight = { fg = colors.blue, bg = "none" },
        LineNr = { fg = colors.overlay0 },
      }
    end,
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}
