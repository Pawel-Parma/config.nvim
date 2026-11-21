return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    event = "VeryLazy",
    opts = {
      ensure_installed = {
        "sleek",
        "beautysh",
        "clang-format"
      },
    },
  },
  {
    "stevearc/conform.nvim",
    dependencies = {
      "mason-org/mason.nvim",
    },
    event = { "BufWritePre" },
    opts = {
      formatters_by_ft = {
        sql = { "sleek" },
        sh = { "beautysh" },
        c = { "clang-format" },
        cpp = { "clang-format" },
      },
      formatters = {
        ["clang-format"] = {
          prepend_args = {
            "--style=file",
            "--fallback-style={BasedOnStyle: LLVM, ColumnLimit: "
            .. vim.o.textwidth
            .. ", UseTab: Never, IndentWidth: 4, TabWidth: 4}",
          },
        },
      },
      format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
      },
    },
    keys = {
      {
        mode = "n",
        "<leader>fo",
        function()
          require("conform").format({
            async = true,
            lsp_format = "fallback",
          })
        end,
        desc = "Format buffer"
      },
    }
  },
}
