return {
  "folke/snacks.nvim",
  -- "Pawel-Parma/snacks.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    local snacks = require("snacks")
    -- local offset = 0
    snacks.setup({
      -- bigfile = { enabled = true },
      -- input = {
      --   enabled = false,
      --   icon_pos = false,
      --   prompt_pos = false,
      -- },
      -- TODO: remove in next commit
      -- styles = {
      --   input = {
      --     relative = "cursor",
      --     title_pos = "left",
      --     -- TODO: feel hacky, although it is used only for renaming so it might be ok?
      --     -- I guess when i will need a normal input like that I could always use this or the for as the same plugin but configure only input
      --     on_win = function(self)
      --       vim.schedule(function()
      --         vim.cmd.stopinsert()
      --         vim.cmd("normal! 0")
      --
      --         if self.win and vim.api.nvim_win_is_valid(self.win) then
      --           local input_line = vim.api.nvim_buf_get_lines(self.buf, 0, 1, false)[1] or ""
      --           local target_col = math.min(offset, math.max(#input_line - 1, 0))
      --           vim.api.nvim_win_set_cursor(self.win, { 1, target_col })
      --         end
      --       end)
      --     end,
      --     on_close = function()
      --       snacks.input.disable()
      --     end,
      --     width = 0,
      --     row = -1,
      --     col = function()
      --       local buf = vim.api.nvim_win_get_buf(0)
      --       local cursor = vim.api.nvim_win_get_cursor(0)
      --       local line = vim.api.nvim_buf_get_lines(buf, cursor[1] - 1, cursor[1], false)[1] or ""
      --       local col = cursor[2]
      --
      --       local word_start = col
      --       while word_start > 0 and line:sub(word_start, word_start):match("[%w_]") do
      --         word_start = word_start - 1
      --       end
      --       offset = col - word_start
      --
      --       return -offset - 2
      --     end,
      --     wo = {
      --       winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder,FloatTitle:FloatTitle",
      --     },
      --   }
      -- }
    })

    -- TODO: replace with plugin only for that?
    vim.keymap.set("n", "<leader>o", function()
      if (snacks.dim.enabled) then
        snacks.dim.disable()
      else
        snacks.dim.enable()
      end
    end, { desc = "Toggle code dim" })

    -- TODO: make native, remove plugin in general
    vim.api.nvim_create_autocmd("User", {
      pattern = "OilActionsPost",
      callback = function(event)
        if event.data.actions[1].type == "move" then
          snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
        end
      end,
    })
  end,
}
