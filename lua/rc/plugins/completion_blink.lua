return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets" },
  version = "1.*",
  event = "VeryLazy",
  opts = {
    keymap = {
      preset = "super-tab",
      ["<A-j>"] = { "select_next", "fallback" },
      ["<A-k>"] = { "select_prev", "fallback" },
    },
    completion = {
      accept = {
        auto_brackets = {
          enabled = true
        },
      },
      menu = {
        border = "rounded",
        direction_priority = function()
          local ctx = require("blink.cmp").get_context()
          local item = require("blink.cmp").get_selected_item()
          if ctx == nil or item == nil then return { "s", "n" } end

          local item_text = item.textEdit ~= nil and item.textEdit.newText or item.insertText or item.label
          local is_multi_line = item_text:find("\n") ~= nil

          if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
            vim.g.blink_cmp_upwards_ctx_id = ctx.id
            return { "n", "s" }
          end
          return { "s", "n" }
        end,
        draw = {
          columns = { { "item_idx" }, { "kind_icon" }, { "label", "label_description", gap = 1 } },
          components = {
            item_idx = {
              text = function(ctx)
                return tostring(ctx.idx)
              end,
            }
          }
        },
      },
      documentation = {
        auto_show = true,
        window = {
          border = "rounded",
        },
      },
      ghost_text = {
        enabled = true,
      },
    },
    signature = {
      enabled = true,
      window = {
        border = "rounded",
        show_documentation = false,
      },
    },
    -- sources = {
    --   providers = {
    --     buffer = {
    --       opts = {
    --         -- buffer completion from all open buffers
    --         get_bufnrs = function()
    --           return vim.tbl_filter(function(bufnr)
    --             return vim.bo[bufnr].buftype == ""
    --           end, vim.api.nvim_list_bufs())
    --         end,
    --       },
    --     },
    --   },
    -- },
    cmdline = {
      keymap = {
        preset = "inherit",
        ["<Tab>"] = { "show_and_insert_or_accept_single", "select_next" },
      },
      completion = {
        menu = {
          auto_show = function()
            return vim.fn.getcmdtype() == ":" and #vim.fn.getcmdline() >= 4
          end,
        },
      },
    },
  },
}
