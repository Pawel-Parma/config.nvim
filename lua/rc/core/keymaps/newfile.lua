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
end, { desc = "Create and open new file" })
