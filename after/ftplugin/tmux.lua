vim.api.nvim_create_autocmd("FileType", {
  pattern = "tmux",
  callback = function()
    vim.bo.commentstring = "# %s"
  end,
})
