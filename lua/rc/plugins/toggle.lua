return {
  "leblocks/toggle.nvim",
  config = function()
    local toggle = require("toggle")
    toggle.setup({
      defaults = false,
      mappings = {
        { "true", "false" },
      },
      mappings_by_filetype = {
        python = {
          { "True", "False" },
        },
      },
    })
    toggle.toggle_back = function()
      toggle.toggle(true)
    end

    vim.keymap.set("n", "<leader>tt", toggle.toggle)
    vim.keymap.set("n", "<leader>tT", toggle.toggle_back)
  end
}
