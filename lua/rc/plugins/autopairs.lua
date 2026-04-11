return {
  'windwp/nvim-autopairs',
  event = "InsertEnter",
  config = function()
    local autopairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")
    local cond = require('nvim-autopairs.conds')

    -- TODO:
    autopairs.setup({
      enable_check_bracket_line = true,
    })

    autopairs.add_rules({
      Rule("$", "$", { "tex", "markdown" }),
      Rule("$$", "$$", { "tex", "markdown" }),
      Rule("<", ">", { "cpp" })
      -- :with_pair(cond.before_regex("/\v([a-zA-Z]+(<+)?|)"))
          :with_pair(cond.not_after_regex("="))
          :with_pair(cond.not_after_regex(" "))
      --           :replace_endpair(function(opts)
      --             print(vim.inspect(opts))
      --             local next = opts.char
      --             if next == "=" or next == " " then
      --               return ""
      --             end
      --             return ">"
      --           end),
      --       Rule(" ", "", { "cpp" })
      --       :replace_endpair(
      -- function(opts)
      --             print(vim.inspect(opts))
      --             local next = opts.char
      --             if next == "=" or next == " " then
      --               return ""
      --             end
      --             return ">"
      --           end
      --       )

    })
  end
}
