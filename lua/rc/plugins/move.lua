return {
  "fedepujol/move.nvim",
  keys = {
    { "<A-j>",      ":MoveLine(1)<CR>",    mode = { "n" }, desc = "Move Line Up" },
    { "<A-k>",      ":MoveLine(-1)<CR>",   mode = { "n" }, desc = "Move Line Down" },
    { "<A-h>",      ":MoveHChar(-1)<CR>",  mode = { "n" }, desc = "Move Character Left" },
    { "<A-l>",      ":MoveHChar(1)<CR>",   mode = { "n" }, desc = "Move Character Right" },
    { "<leader>wf", ":MoveWord(-1)<CR>",   mode = { "n" }, desc = "Move Word Left" },
    { "<leader>wb", ":MoveWord(1)<CR>",    mode = { "n" }, desc = "Move Word Right" },
    { "<A-j>",      ":MoveBlock(1)<CR>",   mode = { "x" }, desc = "Move Block Up" },
    { "<A-k>",      ":MoveBlock(-1)<CR>",  mode = { "x" }, desc = "Move Block Down" },
    { "<A-h>",      ":MoveHBlock(-1)<CR>", mode = { "x" }, desc = "Move Block Left" },
    { "<A-l>",      ":MoveHBlock(1)<CR>",  mode = { "x" }, desc = "Move Block Right" },
  },
  opts = {
    -- TODO:
    char = {
      enable = true,
    }
  },
}
