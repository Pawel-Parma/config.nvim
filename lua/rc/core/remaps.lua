-- TODO: too many in one file, break apart
-- TODO: add desc to keymaps
-- TODO: make paste move buffers so P1 for example will paste somethin that was cut befroe a cut and add manual one???
-- TODO: use require() in some plugins or opts instead of asigining it
-- TODO: add some debugging plugins
vim.keymap.set({ "n", "v" }, "<leader>", "<nop>")
vim.keymap.set({ "i", "n", "v" }, "<Down>", "<nop>")
vim.keymap.set({ "i", "n", "v" }, "<C-Down>", "<nop>")
vim.keymap.set({ "i", "n", "v" }, "<C-S-Down>", "<nop>")
vim.keymap.set({ "i", "n", "v" }, "<Up>", "<nop>")
vim.keymap.set({ "i", "n", "v" }, "<C-Up>", "<nop>")
vim.keymap.set({ "i", "n", "v" }, "<C-S-Up>", "<nop>")
vim.keymap.set({ "i", "n", "v" }, "<Left>", "<nop>")
vim.keymap.set({ "i", "n", "v" }, "<C-Left>", "<nop>")
vim.keymap.set({ "i", "n", "v" }, "<C-S-Left>", "<nop>")
vim.keymap.set({ "i", "n", "v" }, "<Right>", "<nop>")
vim.keymap.set({ "i", "n", "v" }, "<C-Right>", "<nop>")
vim.keymap.set({ "i", "n", "v" }, "<C-S-Right>", "<nop>")
vim.keymap.set("n", "q:", "<nop>")

vim.keymap.set({ "n", "x" }, "gy", '"+y')
vim.keymap.set({ "n", "x" }, "gY", '"+Y')
vim.keymap.set({ "n", "x" }, "gp", '"+p')
vim.keymap.set({ "n", "x" }, "gP", '"+P')
vim.keymap.set("n", "x", '"_x')
vim.keymap.set("n", "X", '"_X')

vim.keymap.set("n", "<leader>so", ":on<CR>")
vim.keymap.set("n", "<leader>sq", ":close<CR>")
vim.keymap.set("n", "<leader>sh", ":leftabove vsplit<CR>")
vim.keymap.set("n", "<leader>sj", ":rightbelow split<CR>")
vim.keymap.set("n", "<leader>sk", ":leftabove split<CR>")
vim.keymap.set("n", "<leader>sl", ":rightbelow vsplit<CR>")
vim.keymap.set("n", "<leader>sme", "<C-w>=")
vim.keymap.set("n", "<leader>smh", "5<C-w>>")
vim.keymap.set("n", "<leader>smj", "2<C-w>-")
vim.keymap.set("n", "<leader>smk", "2<C-w>+")
vim.keymap.set("n", "<leader>sml", "5<C-w><")
vim.keymap.set("n", "<leader>h", "<C-w>h")
vim.keymap.set("n", "<leader>j", "<C-w>j")
vim.keymap.set("n", "<leader>k", "<C-w>k")
vim.keymap.set("n", "<leader>l", "<C-w>l")

vim.keymap.set("n", "<leader>qq", ":cclose<CR>")
vim.keymap.set("n", "<leader>qo", ":copen<CR>")
vim.keymap.set("n", "<leader>qn", ":cn<CR>")
vim.keymap.set("n", "<leader>qp", ":cp<CR>")
vim.keymap.set("n", "<leader>qe", function()
  vim.diagnostic.setqflist({ open = true })
end)

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")

vim.keymap.set("n", "<C-j>", "Qj")
vim.keymap.set("n", "<C-k>", "Qk")
vim.keymap.set("n", "<C-n>", "nQ<cmd>nohlsearch<CR>", { desc = "Move the then next mach and toggle cursor" })
-- FIX: § is a workaround around the fact that windows terminal doesn't use kitty keyboard protocol for wsl so C-n is the same as C-S-n
-- to make it fully windows terminal must send § on C-S-n and nvim must respond to it
-- ghostty on windows when :(
vim.keymap.set("n", { "<C-S-N>", "§" }, "NQ<cmd>nohlsearch<CR>",
  { desc = "Move the then previous mach and toggle cursor" })

vim.keymap.set("x", "<", "<gv")
vim.keymap.set("x", ">", ">gv")

vim.api.nvim_create_user_command('Ansify', function()
  vim.cmd("enew | call termopen('cat ' . shellescape(expand('#')))")
end, {})


vim.keymap.set("n", "<leader>b", ":silent! buffer #<CR>")

vim.keymap.set("x", "<leader>/", function()
  vim.cmd("normal \"zy")
  local content = vim.fn.getreg('z')
  if content == "" then return end
  vim.fn.setreg('/', "\\V" .. vim.fn.escape(content, [[\/]]))
end)

vim.keymap.set("n", "<leader>y", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = 0 }, { bufnr = 0 })
end)

vim.keymap.set("n", "<leader>nf", function()
  local filename = vim.fn.input("New file: ")
  if filename == "" then
    return
  end

  local newpath
  if filename:match("^/") or filename:match("^~") then
    newpath = vim.fn.expand(filename)
  else
    local dir = vim.fn.expand("%:p:h")
    if dir == "" or dir == "." then
      dir = vim.fn.getcwd()
    end
    newpath = dir .. "/" .. filename
  end

  local newdir = vim.fn.fnamemodify(newpath, ":h")
  if vim.fn.isdirectory(newdir) == 0 then
    vim.fn.mkdir(newdir, "p")
  end

  vim.cmd("edit " .. vim.fn.fnameescape(newpath))
  vim.cmd("write")
end)

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
