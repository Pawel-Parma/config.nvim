return {
  "m4xshen/hardtime.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  lazy = false,
  config = function()
    local hardtime = require("hardtime")
    hardtime.setup({
      restriction_mode = "hint",
    })
    vim.keymap.set("n", "<leader>i", "<cmd>Hardtime toggle<CR>")
  end
}
