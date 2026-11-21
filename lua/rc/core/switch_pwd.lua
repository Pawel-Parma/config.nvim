local arg = vim.fn.argv(0)
if type(arg) == "string" and arg ~= "" and vim.fn.isdirectory(arg) == 1 then
  vim.cmd("cd " .. vim.fn.fnameescape(arg))
  vim.cmd("silent! argdelete *")
  vim.cmd("silent! bwipeout 1")
end
