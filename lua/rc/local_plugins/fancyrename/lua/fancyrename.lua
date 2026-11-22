---@class FancyRenameOpts
---@field enable boolean
---@field rename_input_cleanup_timeout integer
---@field input vim.ui.input.Opts
---@field mappings table<integer, {
--- [1]: string|string[],
--- [2]: string|string[],
--- [3]: false|string|function,
--- [4]: vim.keymap.set.Opts,
--- }>
local gopts = {
  enable = false,
  rename_input_cleanup_timeout = 1500,
  input = {
    default = nil,
    highlight = nil,
    prompt = "",
    scope = nil,
  },
  mappings = {
    {
      { "i", "n" },
      "<CR>",
      function(buf, finish)
        local line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or ""
        finish(line)
      end,
      {
        desc = "Confirm rename",
      },
    },
    {
      "n",
      { "<Esc>", "q" },
      function(_, finish)
        finish(nil)
      end,
      {
        desc = "Cancel rename",
      },
    },
  },
}

---@class FancyRename
---@field default_opts FancyRenameOpts
---@field opts FancyRenameOpts
---@field is_enabled boolean
local M = {
  default_opts = vim.deepcopy(gopts),
  opts = vim.deepcopy(gopts),
  is_enabled = false,
}
local vim_default_rename = vim.lsp.buf.rename

---@param win integer
---@return integer
local function get_cursor_offset(win)
  local buf = vim.api.nvim_win_get_buf(win)
  local cursor = vim.api.nvim_win_get_cursor(win)
  local line = vim.api.nvim_buf_get_lines(buf, cursor[1] - 1, cursor[1], false)[1] or ""
  local col = cursor[2]

  local word_start = col
  while word_start > 0 and line:sub(word_start, word_start):match("[%w_]") do
    word_start = word_start - 1
  end

  return col - word_start
end

---@param text string
---@param prompt? string
---@return integer
local function calc_width(text, prompt)
  local min_width = prompt and math.max(1, vim.fn.strdisplaywidth(prompt) + 4) or 1
  local max_width = vim.o.columns - 4
  return math.max(min_width, math.min(vim.fn.strdisplaywidth(text) + 2, max_width))
end

---@param default string
---@return integer
local function create_prompt_buf(default)
  local ns = vim.api.nvim_create_namespace("FancyRenamePad")
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { default })
  vim.api.nvim_buf_set_extmark(buf, ns, 0, 0, {
    virt_text = { { " ", "NormalFloat" } },
    virt_text_pos = "inline",
    right_gravity = false,
  })
  return buf
end

---@param buf integer
---@param offset integer
---@param width integer
---@param prompt? string
---@return integer
local function create_prompt_win(buf, offset, width, prompt)
  local title = nil
  if prompt then
    title = prompt ~= "" and (" " .. prompt .. " ") or ""
  end

  return vim.api.nvim_open_win(buf, true, {
    relative = "cursor",
    row = -1,
    col = -offset - 2,
    width = width,
    height = 1,
    style = "minimal",
    border = "rounded",
    title = title,
    title_pos = title and "left" or nil,
  })
end

---@param buf integer
---@param finish fun(value?: string)
local function bind_keymaps(buf, finish)
  if not M.opts.mappings then
    return
  end

  if type(M.opts.mappings) == "function" then
    M.opts.mappings(buf, finish)
    return
  end

  for _, map in ipairs(M.opts.mappings) do
    local mode, lhs, rhs, opts = map[1], map[2], map[3], map[4]
    if rhs == false then
      return
    end
    local fn = type(rhs) == "function" and function() rhs(buf, finish) end or rhs

    vim.keymap.set(mode, lhs, fn, vim.tbl_extend("force", opts or {}, { buffer = buf }))
  end
end

---@param opts? vim.ui.input.Opts
---@param on_confirm fun(input?: string)
function M.input(opts, on_confirm)
  opts = vim.tbl_deep_extend("keep", M.opts.input, opts or {})

  local prev_win = vim.api.nvim_get_current_win()
  local prev_cursor = vim.api.nvim_win_get_cursor(prev_win)

  local offset = get_cursor_offset(prev_win)
  local initial_width = calc_width(opts.default, opts.prompt)

  local buf = create_prompt_buf(opts.default)
  local win = create_prompt_win(buf, offset, initial_width, opts.prompt)
  vim.api.nvim_win_set_cursor(win, { 1, math.min(offset, math.max(#opts.default - 1, 0)) })

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

  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    buffer = buf,
    callback = function()
      if not vim.api.nvim_win_is_valid(win) then
        return
      end
      local line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or ""
      vim.api.nvim_win_set_config(win, { width = calc_width(line, opts.prompt) })
    end,
  })

  vim.api.nvim_create_autocmd("WinLeave", {
    buffer = buf,
    once = true,
    callback = function()
      finish(nil)
    end,
  })

  bind_keymaps(buf, finish)
end

---@param new_name? string
---@param opts? vim.lsp.buf.rename.Opts
function M.rename(new_name, opts)
  if new_name ~= nil then
    return vim_default_rename(new_name, opts)
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

  vim.defer_fn(restore, M.opts.rename_input_cleanup_timeout)

  local ok, err = pcall(vim_default_rename, new_name, opts)
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
  vim.lsp.buf.rename = vim_default_rename
  M.is_enabled = false
end

function M.toggle()
  if M.is_enabled then
    M.disable()
  else
    M.enable()
  end
end

---@param opts? FancyRenameOpts
function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})

  if M.opts.enable then
    M.enable()
  end
end

return M
