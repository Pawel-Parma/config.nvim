local function exists(dir, names)
  return vim.fs.find(names, {
    path = dir,
    upward = true,
    stop = vim.fs.dirname(dir),
    type = "file",
  })[1]
end

local function is_exec(dir, name)
  local path = exists(dir, name)
  return path ~= nil and vim.fn.executable(path) == 1
end

local function match_cmd(dir, rules)
  for _, rule in ipairs(rules) do
    local check = rule[1]
    if check(dir, rule[2]) then
      return rule[3]
    end
  end
  return ""
end

return {
  -- dir = "~/personal/coding/compile-mode.nvim",
  "ej-shafran/compile-mode.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "m00qek/baleia.nvim",
  },
  cmd = {
    "Compile",
    "Recompile",
    "NextError",
    "PrevError",
    "CurrentError",
    "FirstError",
    "QuickfixErrors",
    "NextErrorFollow",
  },
  opts = {
    default_command = function()
      local cwd = vim.fn.getcwd()
      local ft_commands = {
        zig = "zig build",
        cpp = function()
          return match_cmd(cwd, {
            { is_exec, "build.sh", "./build.sh" },
            { exists, { "Makefile", "makefile" }, "make" },
          })
        end,
        c = function()
          return match_cmd(cwd, {
            { is_exec, "build.sh", "./build.sh" },
            { is_exec, "nob", "./nob" },
            { exists, "nob.c", "cc -o nob nob.c && ./nob" },
            { exists, { "Makefile", "makefile" }, "make" },
          })
        end,
      }

      local cmd = ft_commands[vim.bo.filetype] or ""
      return vim.is_callable(cmd) and cmd() or cmd
    end,
    ansi_color = {
      kind = "render",
      baleia_options = {},
    },
    error_regexp_table = {},
    auto_jump_to_first_error = false,
    error_locus_highlight = 500,
    recompile_no_fail = true,
    ask_about_save = true,
    hidden_output = {
      -- TODO: doens't work
      -- [[\x1bM]],
      -- [[\eM]],
      -- [[^[M]],
      -- [[\r]],
    },
    input_word_completion = false,
    auto_scroll = false,
    use_circular_error_navigation = true,
    use_pseudo_terminal = true,
    -- use_terminal = "neovim",
  },
  keys = {
    { mode = "n", "<leader>cc", ":belowright vert Compile<CR>", desc = "Compile" },
    { mode = "n", "<leader>cr", ":belowright vert Recompile<CR>", desc = "Recompile" },
    { mode = "n", "<leader>cn", ":NextError<CR>", desc = "Next error" },
    { mode = "n", "<leader>cp", ":PrevError<CR>", desc = "Prevoius error" },
    { mode = "n", "<leader>cq", ":QuickfixErrors<CR>", desc = "Send errors to quickfix" },
  },
  config = function(_, opts)
    vim.g.compile_mode = opts
  end,
}
