local my_plugins_path = vim.fn.stdpath("config") .. "/lua/rc/local_plugins/"
return {
  dir = my_plugins_path .. "fancyrename",
  opts = {
    enable = true,
  },
}
