return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    local treesitter = require("nvim-treesitter")

    treesitter.setup({})

    -- TODO: check if exists first
    vim.api.nvim_create_autocmd('User', {
      pattern = 'TSUpdate',
      callback = function()
        require('nvim-treesitter.parsers').mtl = {
          install_info = {
            path = vim.fn.expand('~/personal/coding/mtl/mtl/grammar/tree-sitter-mtl'),
            queries = 'queries',
          },
        }
      end
    })

    treesitter.install {
      "bash",
      "c", "cpp",
      "csv",
      "css", "html", "javascript", "typescript",
      "ebnf",
      "toml", "xml", "yaml",
      "git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore",
      "go", "gomod", "gosum",
      "lua", "luadoc",
      -- TODO: line:23
      "mtl",
      "markdown", "markdown_inline",
      "php",
      "python",
      "rust",
      "sql",
      "query",
      "vim", "vimdoc",
      "zig",
    }

    local prompted_langs = {}
    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if vim.treesitter.language.add(lang or args.match) then
          vim.treesitter.start(args.buf)
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(args.buf) then
              vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
              vim.wo.foldmethod = 'expr'
              vim.bo[args.buf].indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
            end
          end)
        else
          if not lang or prompted_langs[lang] then
            return
          end
          prompted_langs[lang] = true

          local parser = require('nvim-treesitter.parsers')[lang]
          if not parser then
            return
          end

          vim.schedule(function()
            vim.ui.select({ 'Yes', 'No' },
              { prompt = string.format('Install treesitter parser for "%s"?', lang) },
              function(choice)
                if choice == 'Yes' then
                  require('nvim-treesitter').install({ lang })
                end
              end)
          end)
        end
      end,
    })
  end,
}
