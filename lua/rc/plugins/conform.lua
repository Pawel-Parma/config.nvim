return {
  "stevearc/conform.nvim",
  dependencies = {
    "mason-org/mason.nvim",
  },
  config = function()
    local conform = require("conform")
    conform.setup({
      formatters_by_ft = {
        sql = { "sleek" },
        sh = { "beautysh" },
      },
      format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
      },
    })
    vim.keymap.set("n", "<leader>fo", function()
      conform.format({
        async = true,
        lsp_fallback = true,
      })
    end)
  end
}
