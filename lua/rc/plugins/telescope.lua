return {
  "nvim-telescope/telescope.nvim",
  branch = "master",
  dependencies = {
    "nvim-mini/mini.icons",
    -- "Parma/snacks.nvim",
    "nvim-lua/plenary.nvim",
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'nvim-telescope/telescope-ui-select.nvim',
  },
  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")
    local themes = require("telescope.themes")
    local previewers = require("telescope.previewers")
    local actions = require("telescope.actions")
    local icons = require("mini.icons")

    telescope.setup({
      defaults = {
        hidden = true,
        mappings = {
          i = {
            ["<A-j>"] = actions.move_selection_next,
            ["<A-k>"] = actions.move_selection_previous,
          },
          n = {
            ["<A-j>"] = actions.move_selection_next,
            ["<A-k>"] = actions.move_selection_previous,
          },
        },
        buffer_previewer_maker = function(filepath, bufnr, opts)
          local snacks = require("snacks")
          if snacks.image.supports(filepath) then
            snacks.image.buf.attach(bufnr, { src = filepath })
          else
            previewers.buffer_previewer_maker(filepath, bufnr, opts)
          end
        end,
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
      },
      devicons = {
        get = icons.mock_nvim_web_devicons()
      }
    })

    telescope.load_extension('fzf')
    telescope.load_extension('ui-select')

    vim.keymap.set("n", "<leader>fe", builtin.find_files, {})
    vim.keymap.set("n", "<leader>fs", builtin.live_grep, {})
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
    vim.keymap.set("n", "<leader>fk", builtin.keymaps, {})
    vim.keymap.set("n", "<leader>en", function()
      builtin.find_files({ cwd = "~/.config/nvim", })
    end)
  end,
}
