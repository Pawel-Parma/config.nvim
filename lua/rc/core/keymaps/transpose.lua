---@class WordSpan
---@field row integer
---@field start_col integer
---@field end_col integer
---@field text string

---@param buf integer
---@param row integer
---@param step -1|1
---@param n integer
---@return integer
local function find_nth_non_empty_line(buf, row, step, n)
  local limit = step > 0 and (vim.api.nvim_buf_line_count(buf) - 1) or 0
  local found, last = 0, row
  for r = row + step, limit, step do
    local line = vim.api.nvim_buf_get_lines(buf, r, r + 1, false)[1]
    if line and line:find("[%w_]") then
      last = r
      found = found + 1
      if found >= n then
        return last
      end
    end
  end
  return last
end

---@param buf integer
---@param row integer
---@param count integer
---@return WordSpan[]
local function get_nearby_words(buf, row, count)
  local first_row = find_nth_non_empty_line(buf, row, -1, math.abs(count))
  local last_row = find_nth_non_empty_line(buf, row, 1, math.abs(count))
  local lines = vim.api.nvim_buf_get_lines(buf, first_row, last_row + 1, false)

  local words = {}

  for offset, str in ipairs(lines) do
    local lrow = first_row + offset - 1
    local i = 1
    while i <= #str do
      local start_col, end_col = str:find("[%w_]+", i)
      if not start_col then
        break
      end
      words[#words + 1] = { row = lrow, start_col = start_col - 1, end_col = end_col, text = str:sub(start_col, end_col) }
      i = end_col + 1
    end
  end
  return words
end

---@param words WordSpan[]
---@param row integer
---@param col integer
---@return integer?
local function find_current_word_idx(words, row, col)
  local candidate_idx = nil
  for i, word in ipairs(words) do
    if word.row > row or (word.row == row and col < word.start_col) then
      break
    end
    if word.row == row then
      candidate_idx = i
    end
  end
  return candidate_idx
end

---@param buf integer
---@param current_word WordSpan
---@param target_word WordSpan
---@param count integer
local function swap_words(buf, current_word, target_word, count)
  local first_word, second_word = current_word, target_word
  if count < 0 then
    first_word, second_word = target_word, current_word
  end

  vim.api.nvim_buf_set_text(buf, second_word.row, second_word.start_col, second_word.row, second_word.end_col, { first_word.text })
  vim.api.nvim_buf_set_text(buf, first_word.row, first_word.start_col, first_word.row, first_word.end_col, { second_word.text })
end

---@param win integer
---@param col integer
---@param source_word WordSpan
---@param target_word WordSpan
local function place_cursor_on_swaped_word(win, col, source_word, target_word)
  local offset = math.max(0, math.min(col - source_word.start_col, #source_word.text - 1))
  local new_row = target_word.row + 1
  local new_col = target_word.start_col

  if source_word.row == target_word.row and target_word.start_col > source_word.start_col then
    new_col = target_word.start_col + (#target_word.text - #source_word.text)
  end

  vim.api.nvim_win_set_cursor(win, { new_row, new_col + offset })
end

---@param count integer
local function transpose_word(count)
  if count == 0 then return end
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(win)
  local cursor = vim.api.nvim_win_get_cursor(win)
  local row, col = cursor[1] - 1, cursor[2]

  local words = get_nearby_words(buf, row, count)

  local source_word_idx = find_current_word_idx(words, row, col)
  if not source_word_idx then return end

  local source_word = words[source_word_idx]
  local target_word = words[source_word_idx + count]
  if not target_word then return end

  swap_words(buf, source_word, target_word, count)
  place_cursor_on_swaped_word(win, col, source_word, target_word)
end

vim.keymap.set("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move block down" })
vim.keymap.set("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move block up" })
vim.keymap.set("i", "<A-j>", "<C-o><A-j>", { remap = true, desc = "Move line down" })
vim.keymap.set("i", "<A-k>", "<C-o><A-k>", { remap = true, desc = "Move line up" })

vim.keymap.set("n", "<A-h>", function() transpose_word(-vim.v.count1) end, { desc = "Transpose word left" })
vim.keymap.set("n", "<A-l>", function() transpose_word(vim.v.count1) end, { desc = "Transpose word right" })
vim.keymap.set("i", "<A-h>", "<C-o><A-h>", { remap = true, desc = "Transpose word left" })
vim.keymap.set("i", "<A-l>", "<C-o><A-l>", { remap = true, desc = "Transpose word right" })
