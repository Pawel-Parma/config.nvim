return {
  'windwp/nvim-autopairs',
  event = "InsertEnter",
  config = function()
    local autopairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")
    local cond = require('nvim-autopairs.conds')

    autopairs.setup({
      enable_check_bracket_line = true,
    })

    autopairs.add_rules({
      Rule("$", "$", { "tex", "latex", "markdown" })
          :with_pair(cond.not_before_regex("\\"))
          :with_pair(cond.not_before_regex("[%w]"))
          :with_move(function(opts)
            return opts.char == "$" and opts.prev_char ~= "$"
          end),
      Rule("$$", "$$", { "tex", "latex", "markdown" })
          :with_pair(cond.not_before_regex("\\"))
          :with_pair(cond.not_before_regex("[%w]"))
          :with_move(function(opts)
            return opts.char == "$"
          end),
      Rule("<", ">", { "cpp", "c" })
          :with_pair(function(opts)
            local before = opts.line:sub(1, opts.col - 1)
            if before:match("#include%s*$") or before:match("template%s*$") or before:match("[%w_:]$") then
              return true
            end

            return false
          end)
          :with_move(function(opts)
            return opts.char == ">"
          end)
          :with_pair(cond.not_after_text(")"))
          :with_cr(cond.none()),
    })
  end
}
