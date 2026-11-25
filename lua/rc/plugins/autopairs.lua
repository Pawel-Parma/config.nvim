return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    enable_check_bracket_line = true,
  },
  config = function(_, opts)
    local autopairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")
    local cond = require("nvim-autopairs.conds")
    autopairs.setup(opts)

    autopairs.add_rules({
      Rule("$", "$", { "tex", "latex", "markdown" })
          :with_pair(cond.not_before_regex("\\"))
          :with_pair(cond.not_before_regex("[%w]"))
          :with_move(function(ropts)
            return ropts.char == "$" and opts.prev_char ~= "$"
          end),
      Rule("$$", "$$", { "tex", "latex", "markdown" })
          :with_pair(cond.not_before_regex("\\"))
          :with_pair(cond.not_before_regex("[%w]"))
          :with_move(function(ropts)
            return ropts.char == "$"
          end),
      Rule("<", ">", { "cpp", "c" })
          :with_pair(function(ropts)
            local before = ropts.line:sub(1, ropts.col - 1)
            if before:match("#include%s*$") or before:match("template%s*$") or before:match("[%w_:]$") then
              return true
            end

            return false
          end)
          :with_move(function(ropts)
            return ropts.char == ">"
          end)
          :with_pair(cond.not_after_text(")"))
          :with_cr(cond.none()),
    })
  end
}
