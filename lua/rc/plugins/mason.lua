return {
  "mason-org/mason.nvim",
  cmd = {
    "Mason",
    "MasonUpdate",
    "MasonInstall",
    "MasonUninstall",
    "MasonUninstallAll",
    "MasonLog",
  },
  build = ":MasonUpdate",
  opts = {},
}
