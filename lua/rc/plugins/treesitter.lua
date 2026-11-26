return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    opts = {
      -- stylua: ignore start
      "bash",
      "c", "cpp",
      "csv",
      "css", "html", "javascript", "typescript",
      "ebnf",
      "json", "yaml", "toml", "xml",
      "git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore", "diff",
      "go", "gomod", "gosum",
      "lua", "luadoc",
      "markdown", "markdown_inline",
      "php",
      "python",
      "rust",
      "sql",
      "query",
      "vim", "vimdoc",
      "zig",
      -- stylua: ignore end
    },
    init = function(plugin)
      local mtl_path = vim.fn.expand("~/personal/coding/mtl/mtl/grammar/tree-sitter-mtl")
      if vim.fn.isdirectory(mtl_path) == 1 then
        table.insert(plugin.opts, "mtl")
        vim.api.nvim_create_autocmd("User", {
          pattern = "TSUpdate",
          callback = function()
            require("nvim-treesitter.parsers").mtl = {
              install_info = {
                path = vim.fn.expand("~/personal/coding/mtl/mtl/grammar/tree-sitter-mtl"),
                queries = "queries",
              },
            }
          end,
        })
      end
    end,
    config = function(_, opts)
      local treesitter = require("nvim-treesitter")
      treesitter.setup({})
      treesitter.install(opts)

      local prompted_langs = {}
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if vim.treesitter.language.add(lang or args.match) then
            vim.treesitter.start(args.buf)
            vim.schedule(function()
              if vim.api.nvim_buf_is_valid(args.buf) then
                vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                vim.wo.foldmethod = "expr"
                vim.bo[args.buf].indentexpr = [[v:lua.require("nvim-treesitter").indentexpr()]]
              end
            end)
            return
          end

          if not lang or prompted_langs[lang] then
            return
          end
          prompted_langs[lang] = true

          local parser = require("nvim-treesitter.parsers")[lang]
          if not parser then
            return
          end

          vim.schedule(function()
            vim.ui.select({ "Yes", "No" }, { prompt = "Install treesitter parser for " .. lang .. "?" }, function(choice)
              if choice == "Yes" then
                require("nvim-treesitter").install({ lang })
              end
            end)
          end)
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    opts = {
      select = {
        lookahead = true,
      },
      move = {
        set_jumps = true,
      },
    },
    keys = {
      {
        mode = { "x", "o" },
        "af",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
        end,
        desc = "Select outer function",
      },
      {
        mode = { "x", "o" },
        "if",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
        end,
        desc = "Select inner function",
      },
    },
  },
}
