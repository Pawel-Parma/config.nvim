return {
  "nvim-telescope/telescope.nvim",
  branch = "master",
  dependencies = {
    "nvim-mini/mini.icons",
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-ui-select.nvim",
  },
  lazy = false,
  opts = function()
    local actions = require("telescope.actions")
    local actions_layout = require("telescope.actions.layout")
    local themes = require("telescope.themes")
    return {
      defaults = {
        hidden = true,
        mappings = {
          i = {
            ["<A-j>"] = { actions.move_selection_next, opts = { desc = "Move selection next" } },
            ["<A-k>"] = { actions.move_selection_previous, opts = { desc = "Move selection previous" } },
            ["<M-p>"] = { actions_layout.toggle_preview, opts = { desc = "Toggle preview" } },
          },
          n = {
            ["<A-j>"] = { actions.move_selection_next, opts = { desc = "Move selection next" } },
            ["<A-k>"] = { actions.move_selection_previous, opts = { desc = "Move selection previous" } },
            ["<M-p>"] = { actions_layout.toggle_preview, opts = { desc = "Toggle preview" } },
          },
        },
      },
      pickers = {
        find_files = {
          find_command = {
            "rg", "--files",
            "--hidden",
            "--glob", "!**/.git",
            "--glob", "!**/venv/*",
            "--glob", "!**/.venv/*",
          },
        },
      },
      extensions = {
        fzf = {},
        ["ui-select"] = {
          themes.get_dropdown({}),
        },
      }
    }
  end,
  keys = {
    { mode = "n", "<leader>fe", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    { mode = "n", "<leader>fs", "<cmd>Telescope live_grep<CR>",  desc = "Live grep" },
    { mode = "n", "<leader>fh", "<cmd>Telescope help_tags<CR>",  desc = "Find Help tags" },
    { mode = "n", "<leader>fk", "<cmd>Telescope keymaps<CR>",    desc = "Find keymaps" },
    {
      mode = "n",
      "<leader>en",
      function() require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") }) end,
      desc = "Find nvim files"
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")
  end,
}
