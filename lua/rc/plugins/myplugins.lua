-- TODO: check if it can be a relative path
local my_plugins_path = vim.fn.expand("$HOME/.config/nvim/lua/rc/local_plugins/")
return {

  dir = my_plugins_path .. "fancyrename",
  opts = {
    enable = true,
  },
}
