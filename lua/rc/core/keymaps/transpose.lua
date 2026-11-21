local function transpose_word(dir)
  -- TODO: it works ig but it is ai slop, review
  local bufnr = 0
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1 -- convert to 0-indexed

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  -- local line = lines[row + 1]

  -- Helper: find all word spans (0-indexed [s, e) byte ranges) on a given 0-indexed row
  local function line_words(r)
    local str = lines[r + 1]
    if not str then return {} end
    local res, i = {}, 1
    while i <= #str do
      local s, e = str:find("[%w_]+", i)
      if not s then break end
      table.insert(res, { row = r, s = s - 1, e = e, text = str:sub(s, e) })
      i = e + 1
    end
    return res
  end

  -- 1. Find current word (under cursor, or immediately before cursor if on whitespace/punctuation)
  local cur_words = line_words(row)
  local cur
  for _, w in ipairs(cur_words) do
    if col >= w.s and col < w.e then
      cur = w
      break
    end
  end
  if not cur then
    -- Fallback: grab the nearest word before the cursor (Emacs behavior when cursor is after a word)
    for i = #cur_words, 1, -1 do
      if cur_words[i].e <= col then
        cur = cur_words[i]
        break
      end
    end
  end
  if not cur then return end

  -- 2. Find the adjacent word in `dir` (searching across line breaks if needed)
  local target
  if dir == "right" then
    for _, w in ipairs(cur_words) do
      if w.s > cur.s then
        target = w; break
      end
    end
    if not target then
      for r = row + 1, #lines - 1 do
        local next_words = line_words(r)
        if #next_words > 0 then
          target = next_words[1]; break
        end
      end
    end
  else
    for i = #cur_words, 1, -1 do
      if cur_words[i].s < cur.s then
        target = cur_words[i]; break
      end
    end
    if not target then
      for r = row - 1, 0, -1 do
        local prev_words = line_words(r)
        if #prev_words > 0 then
          target = prev_words[#prev_words]; break
        end
      end
    end
  end
  if not target then return end

  -- 3. Order spans (first, second) and replace second first so first's byte offsets stay valid
  local first, second = cur, target
  if dir == "left" then
    first, second = target, cur
  end

  vim.api.nvim_buf_set_text(bufnr, second.row, second.s, second.row, second.e, { first.text })
  vim.api.nvim_buf_set_text(bufnr, first.row, first.s, first.row, first.e, { second.text })

  -- 4. Keep cursor on the moved word so repeated presses keep dragging it
  local new_row, new_col
  if dir == "right" then
    new_row = second.row + 1
    if first.row == second.row then
      new_col = second.s + (#second.text - #first.text)
    else
      new_col = second.s
    end
  else
    new_row = first.row + 1
    new_col = first.s
  end
  vim.api.nvim_win_set_cursor(0, { new_row, math.max(0, new_col) })
end


vim.keymap.set("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Line Down" })
vim.keymap.set("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Line Up" })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
vim.keymap.set("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Block Down" })
vim.keymap.set("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Block Up" })

vim.keymap.set("n", "<A-l>", function() transpose_word("right") end, { desc = "Transpose Word Right" })
vim.keymap.set("n", "<A-h>", function() transpose_word("left") end, { desc = "Transpose Word Left" })
