return {
  "ej-shafran/compile-mode.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "m00qek/baleia.nvim",
  },
  cmd = { "Compile", "Recompile" },
  -- TODO: report bugs and features to repo
  -- terminal escape sequences
  --   lS and cD hang for a coulple of seconds
  --   box drawing mode ^[(0mq^[(
  --   no \r or ^[M
  --   i guess no VT100 escape codes at all?
  --   VT52?
  -- TODO: make control f enter normal mode? is it input? can i hook snacks input to it?
  opts = {
    default_command = function()
      local cwd = vim.fn.getcwd()
      local function find(names)
        return vim.fs.find(names, { path = cwd, type = "file" })[1]
      end

      local function is_exec(name)
        local path = find(name)
        return path ~= nil and vim.fn.executable(path) == 1
      end

      local ft_commands = {
        zig = "zig build",
        c = function()
          if is_exec("build.sh") then
            return "./build.sh"
          elseif is_exec("nob") then
            return "./nob"
          elseif find("nob.c") then
            return "cc -o nob nob.c && ./nob"
          elseif find({ "Makefile", "makefile", "GNUmakefile" }) then
            return "make"
          end
          return ""
        end
      }
      local cmd = ft_commands[vim.bo.filetype] or ""
      return vim.is_callable(cmd) and cmd() or cmd
    end,
    ansi_color = {
      kind = "render",
      baleia_options = {},
    },
    auto_jump_to_first_error = false,
    error_locus_highlight = 500,
    recompile_no_fail = true,
    ask_about_save = true,
    hidden_output = {},            -- :h compile-mode.hidden_output
    input_word_completion = false, -- :h compile-mode.input_word_completion
    auto_scroll = false,           -- :h compile-mode.auto_scroll
    use_circular_error_navigation = true,
    use_pseudo_terminal = true,
  },
  keys = {
    { mode = "n", "<leader>cc", ":belowright vert Compile<CR>",   desc = "Compile" },
    { mode = "n", "<leader>cr", ":belowright vert Recompile<CR>", desc = "Recompile" },
    { mode = "n", "<leader>cn", ":NextError<CR>",                 desc = "Next error" },
    { mode = "n", "<leader>cp", ":PrevError<CR>",                 desc = "Prevoius error" },
    {
      mode = "n",
      "<leader>cq",
      function()
        require("compile-mode").send_to_qflist()
      end,
      desc = "Send errors to quickfix"
    }
  },
  config = function(_, opts)
    vim.g.compile_mode = opts
  end,
}
