local function has_config(ctx, names)
  return vim.fs.find(names, {
    path = ctx.dirname,
    upward = true,
    stop = vim.fn.expand("$HOME"),
  })[1] ~= nil
end

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
        lua = { "stylua" },
      },
      formatters = {
        ["clang-format"] = {
          prepend_args = function(_, ctx)
            if has_config(ctx, { ".clang-format" }) then
              return {}
            end

            return {
              -- stylua: ignore start
              "--style={"
                .. "BasedOnStyle: LLVM,"
                .. "Language: Cpp,"
                .. "Standard: c++23,"

                .. "ColumnLimit: " .. vim.o.textwidth .. ","
                .. "UseTab: Never,"
                .. "IndentWidth: 4,"
                .. "TabWidth: 4,"

                .. "BreakBeforeBraces: Attach,"

                .. "AllowShortFunctionsOnASingleLine: None,"
                .. "AllowShortIfStatementsOnASingleLine: WithoutElse,"
                .. "AllowShortCaseLabelsOnASingleLine: true,"

                .. "MaxEmptyLinesToKeep: 2,"
                .. "SpacesBeforeTrailingComments: 1,"
                .. "SortIncludes: CaseInsensitive,"
             .. "}",
              -- stylua: ignore end
            }
          end,
        },
        stylua = {
          prepend_args = function(_, ctx)
            if has_config(ctx, { "stylua.toml", ".stylua.toml" }) then
              return {}
            end

            return {
              "--column-width=" .. vim.o.textwidth,
              "--indent-type=Spaces",
              "--indent-width=2",
              "--quote-style=ForceDouble",
              "--collapse-simple-statement=Input",
              "--sort-requires",
            }
          end,
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
