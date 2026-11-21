return {
  "folke/twilight.nvim",
  dependencies = {
    "catppuccin/nvim",
  },
  opts = function()
    local catppuccin_mocha = require("catppuccin.palettes").get_palette("mocha")
    return {
      dimming = {
        alpha = 1,
        color = { "DiagnosticUnnecessary", catppuccin_mocha.overlay2 },
        inactive = true,
      },
    }
  end,
  keys = {
    { mode = "n", "<leader>o", ":Twilight<CR>", desc = "Toggle code dim" },
  },
}
