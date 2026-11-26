return {
  "m4xshen/hardtime.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  cmd = "Hardtime",
  opts = {
    enabled = false,
    -- restriction_mode = "hint",
  },
  keys = {
    {
      mode = "n",
      "<leader>th",
      function()
        require("hardtime").toggle()
      end,
      desc = "Toggle hardtime.nvim",
    },
  },
}
