return {
  "rcarriga/nvim-notify",
  lazy = true,
  opts = {
    top_down = false,
  },
  init = function()
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.notify = function(...)
      vim.notify = require("notify")
      return vim.notify(...)
    end
  end,
}
