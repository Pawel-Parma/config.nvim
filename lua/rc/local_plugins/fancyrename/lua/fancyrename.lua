local M = {}

--- @class fancyrename.Options
--- @field enable boolean
--- @field input vim.ui.input.Opts
M.opts = {
  enable = false,
  input = {
    default = nil,
    highligh = nil,
    prompt = "",
    scope = nil,
  },
}
M.is_enabled = false
M.vim_default_rename = vim.lsp.buf.rename


--- @param opts? vim.ui.input.Opts
--- @param on_confirm fun(input?: string)
-- TODO: 50% ai slop, refactor, and expose openwin options, and a way to create mappings inside
function M.input(opts, on_confirm)
  opts = vim.tbl_deep_extend("keep", M.opts.input, opts or {})

  local src_buf = vim.api.nvim_win_get_buf(0)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local src_line = vim.api.nvim_buf_get_lines(src_buf, cursor[1] - 1, cursor[1], false)[1] or ""
  local col = cursor[2]

  local word_start = col
  while word_start > 0 and src_line:sub(word_start, word_start):match("[%w_]") do
    word_start = word_start - 1
  end
  local offset = col - word_start

  local min_width = opts.prompt and math.max(1, vim.fn.strdisplaywidth(opts.prompt) + 4) or 1
  local max_width = vim.o.columns - 4
  local initial_width = math.max(min_width, math.min(vim.fn.strdisplaywidth(opts.default) + 2, max_width))

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { opts.default })
  local ns = vim.api.nvim_create_namespace("FancyRenamePad")
  vim.api.nvim_buf_set_extmark(buf, ns, 0, 0, {
    virt_text = { { " ", "NormalFloat" } },
    virt_text_pos = "inline",
    right_gravity = false, -- keeps the space at the left edge when inserting at col 0
  })

  local title = nil
  if opts.prompt then
    title = opts.prompt ~= "" and (" " .. opts.prompt .. " ") or ""
  end

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "cursor",
    row = -1,
    col = -offset - 2,
    width = initial_width,
    height = 1,
    style = "minimal",
    border = "rounded",
    title = title,
    title_pos = title and "left" or nil,
  })

  local target_col = math.min(offset, math.max(#opts.default - 1, 0))
  vim.api.nvim_win_set_cursor(win, { 1, target_col })

  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    buffer = buf,
    callback = function()
      if not vim.api.nvim_win_is_valid(win) then
        return
      end
      local line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or ""
      local width = math.max(min_width, math.min(vim.fn.strdisplaywidth(line) + 2, max_width))
      vim.api.nvim_win_set_config(win, { width = width })
    end,
  })

  local prev_win = vim.api.nvim_get_current_win()
  local prev_cursor = vim.api.nvim_win_get_cursor(prev_win)
  local closed = false
  local function finish(value)
    if closed then
      return
    end
    closed = true
    vim.cmd("stopinsert")
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
    if vim.api.nvim_win_is_valid(prev_win) then
      vim.api.nvim_set_current_win(prev_win)
      vim.api.nvim_win_set_cursor(prev_win, prev_cursor)
    end
    if on_confirm then
      on_confirm(value)
    end
  end

  vim.keymap.set({ "i", "n" }, "<CR>", function()
    local line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or ""
    finish(line)
  end, { buffer = buf })

  vim.keymap.set("n", "<Esc>", function()
    finish(nil)
  end, { buffer = buf })

  vim.keymap.set("n", "q", function()
    finish(nil)
  end, { buffer = buf })
end

---@param new_name? string
---@param opts? vim.lsp.buf.rename.Opts
function M.rename(new_name, opts)
  if new_name ~= nil then
    return M.vim_default_rename(new_name, opts)
  end

  local restored = false
  local vim_default_input = vim.ui.input
  local function restore()
    if not restored then
      restored = true
      vim.ui.input = vim_default_input
    end
  end

  ---@diagnostic disable-next-line: duplicate-set-field
  vim.ui.input = function(input_opts, on_confirm)
    restore()
    return M.input(input_opts, on_confirm)
  end

  -- TODO: backup cleanup?

  local ok, err = pcall(M.vim_default_rename, new_name, opts)
  if not ok then
    restore()
    error(err)
  end
end

function M.enable()
  vim.lsp.buf.rename = M.rename
  M.is_enabled = true
end

function M.disable()
  vim.lsp.buf.rename = M.vim_default_rename
  M.is_enabled = false
end

function M.toggle()
  if M.is_enabled then
    M.disable()
  else
    M.enable()
  end
end

--- @param opts? fancyrename.Options
function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})

  vim.keymap.set("n", "<leader>ss", function()
    M.input({ default = vim.fn.expand "<cword>" }, function()
      vim.notify("#676767")
    end)
  end)


  if M.opts.enable then
    M.enable()
  end
end

return M
