return {
  "ej-shafran/compile-mode.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "m00qek/baleia.nvim",
  },
  config = function()
    local compilemode = require("compile-mode")
    -- TODO: report bugs and features to repo
    -- terminal escape sequences
    --   lS and cD hang for a coulple of seconds
    --   box drawing mode ^[(0mq^[(
    --   no \r or ^[M
    --   i guess no VT100 escape codes at all?
    --   VT52?
    -- TODO: make control f enter normal mode? is it input? can i hook snacks input to it?
    vim.g.compile_mode = {
      default_command = function()
        local ft_commands = {
          zig = "zig build",
          c = "aasdad"
          -- TODO: propose for it to be string | function
          -- c = function()
          --   local cwd = vim.fn.getcwd()
          --
          --   local function exists(file)
          --     return vim.fn.filereadable(cwd .. "/" .. file) == 1
          --   end
          --
          --   local function is_exec(file)
          --     return exists(file) and vim.fn.executable(cwd .. "/" .. file) == 1
          --   end
          --
          --   if is_exec("build.sh") then
          --     return "./build.sh"
          --   elseif is_exec("nob") then
          --     return "./nob"
          --   elseif exists("nob.c") then
          --     return "cc -o nob nob.c && ./nob"
          --   elseif exists("Makefile") or exists("makefile") or exists("GNUmakefile") then
          --     return "make"
          --   end
          --
          --   return ""
          -- end
        }
        local default_command = ""
        return ft_commands[vim.bo.filetype] or default_command
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
    }
    vim.keymap.set("n", "<leader>cc", ":belowright vert Compile<CR>")
    vim.keymap.set("n", "<leader>cr", ":belowright vert Recompile<CR>")
    vim.keymap.set("n", "<leader>cn", ":NextError<CR>")
    vim.keymap.set("n", "<leader>cp", ":PrevError<CR>")
    vim.keymap.set("n", "<leader>cq", compilemode.send_to_qflist)
  end
}
