return {
  "leblocks/toggle.nvim",
  opts = {
    defaults = false,
    mappings = {
      { "true", "false" },
    },
    mappings_by_filetype = {
      python = {
        { "True", "False" },
      },
    },
  },
  keys = {
    { mode = "n", "<leader>tt", function() require("toggle").toggle() end, desc = "Toggle value forwards" },
    { mode = "n", "<leader>tT", function() require("toggle").toggle(true) end, desc = "Toggle value backwards" },
  },
}
