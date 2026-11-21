return {
  "theprimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  lazy = false,
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Append to harpoon list" })
    vim.keymap.set("n", "<leader>A", function() harpoon:list():prepend() end, { desc = "Prepend to harpoon list" })
    vim.keymap.set("n", "<C-e>", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      { desc = "Toggle harpoon quick menu" }
    )

    vim.keymap.set("n", "<leader>0", function() harpoon:list():select(10) end, { desc = "Switch to buffer 10 in harpoon list" })
    for i = 1, 9 do
      vim.keymap.set("n", "<leader>" .. i, function()
        harpoon:list():select(i)
      end, { desc = "Switch to buffer " .. i .. " in harpoon list" })
    end
  end
}
