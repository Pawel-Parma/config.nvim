local group = vim.api.nvim_create_augroup("URestoreCursorPosition", { clear = true })

vim.api.nvim_create_autocmd("BufLeave", {
  group = group,
  callback = function(args)
    local buf = args.buf
    if vim.api.nvim_win_get_buf(0) ~= buf then
      return
    end

    vim.b[buf].u_rcp_cursor_position = vim.api.nvim_win_get_cursor(0)
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  callback = function(args)
    local buf = args.buf
    if vim.api.nvim_win_get_buf(0) ~= buf then
      return
    end
    if vim.api.nvim_win_get_config(0).relative ~= "" then
      return
    end

    local pos = vim.b[buf].u_rcp_cursor_position
    if pos then
      local line_count = vim.api.nvim_buf_line_count(buf)
      local line = math.min(pos[1], line_count)
      local line_len = #vim.api.nvim_buf_get_lines(buf, line - 1, line, false)[1]
      local col = math.min(pos[2], line_len)
      vim.api.nvim_win_set_cursor(0, { line, col })
      return
    end

    if not vim.b[buf].u_rcp_was_read then
      vim.b[buf].u_rcp_was_read = true
      vim.cmd([[silent! normal! g`"]])
    end
  end,
})
