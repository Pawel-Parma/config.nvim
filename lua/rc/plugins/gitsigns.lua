return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    attach_to_untracked = true,
  },
  keys = {
    {
      mode = "n",
      "<leader>p",
      function()
        require("gitsigns").preview_hunk()
      end,
      desc = "Preview git hunk",
    },
  },
}
