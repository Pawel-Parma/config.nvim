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
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "q:", "<nop>")

vim.keymap.set({ "n", "x" }, "gy", '"+y')
vim.keymap.set({ "n", "x" }, "gp", '"+p')
vim.keymap.set({ "n", "x" }, "gP", '"+P')
vim.keymap.set({ "n", "x" }, "gx", '"+x')
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

vim.keymap.set("n", "<leader>cq", ":cclose<CR>")
vim.keymap.set("n", "<leader>cn", ":cn<CR>")
vim.keymap.set("n", "<leader>cb", ":cp<CR>")
vim.keymap.set("n", "<leader>ce", function()
  vim.diagnostic.setqflist({ open = true })
end)

vim.api.nvim_create_user_command('Ansify', function()
  vim.cmd("enew | call termopen('cat ' . shellescape(expand('#')))")
end, {})


vim.keymap.set("n", "<leader>b", function()
  if vim.fn.expand("#") ~= "" then
    vim.cmd("buffer #")
  else
    print("No alternate buffer")
  end
end)

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
