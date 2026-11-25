return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    build = ":MasonToolsInstall",
    cmd = {
      "MasonToolsClean",
      "MasonToolsInstall",
      "MasonToolsInstallSync",
      "MasonToolsUpdate",
      "MasonToolsUpdateSync",
    },
    opts = {
      ensure_installed = {
        "beautysh",
        "clang-format",
        "sleek",
        "stylua",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    dependencies = { "mason-org/mason.nvim" },
    event = { "BufWritePre" },
    opts = {
      formatters_by_ft = {
        sh = { "beautysh" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        sql = { "sleek" },
        lua = { "stylua " },
      },
      formatters = {
        ["clang-format"] = {
          prepend_args = {
            -- TODO: do it ig it can be a function
            -- "--style=file",
            -- "--fallback-style={"
            "--style={"
              .. "BasedOnStyle: LLVM,"
              .. "Language: Cpp,"
              .. "Standard: c++23,"
              .. "ColumnLimit: "
              .. vim.o.textwidth
              .. ","
              .. "UseTab: Never,"
              .. "IndentWidth: 4,"
              .. "TabWidth: 4,"
              .. "AllowShortFunctionsOnASingleLine: None,"
              .. "}",
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
        desc = "Format buffer",
      },
    },
  },
}
