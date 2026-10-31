return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    local treesitter = require("nvim-treesitter")
    -- local treesitter_parsers = require('nvim-treesitter.parsers')

    treesitter.setup({})

    -- Works:
    vim.treesitter.language.add('mtl', {
      path = vim.fn.expand('~/personal/coding/mtl/mtl/grammar/libtree-sitter-mtl.so'),
    })
    vim.opt.runtimepath:append(vim.fn.expand('~/personal/coding/mtl/mtl/grammar'))

    -- Doesn't work:
    -- vim.api.nvim_create_autocmd('User', {
    --   pattern = 'TSUpdate',
    --   callback = function()
    --     treesitter_parsers.mtl = {
    --       install_info = {
    --         path = vim.fn.expand('~/personal/coding/mtl/mtl/grammar'),
    --         queries = 'queries',
    --       },
    --     }
    --   end
    -- })

    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'mtl' },
      callback = function() vim.treesitter.start() end,
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
      -- "mtl",
      "markdown", "markdown_inline",
      "php",
      "python",
      "rust",
      "sql",
      "query",
      "vim", "vimdoc",
      "zig",
    }

    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if vim.treesitter.language.add(lang or args.match) then
          vim.treesitter.start(args.buf)
          -- vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          -- vim.wo[0][0].foldmethod = 'expr'
          -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
