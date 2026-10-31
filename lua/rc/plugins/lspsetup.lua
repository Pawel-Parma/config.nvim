return {
  "junnplus/lsp-setup.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
  },
  config = function()
    local masonlsp = require("mason-lspconfig")
    local lsp = require("lsp-setup")

    masonlsp.setup {
      automatic_enable = false

    }


    lsp.setup({
      default_mappings = false,
      inlay_hints = {
        enabled = true,
      },
      servers = {
        -- TODO: smth broke
        bashls = {},
        clangd = {},
        gopls = {},
        texlab = {},
        jsonls = {},
        html = {},
        cssls = {},
        basedpyright = {},
        yamlls = {
          settings = {
            yaml = {
              yamlVersion = "1.2.2",
            }
          }
        },

        lua_ls = {
          on_init = function(client)
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              ---@diagnostic disable-next-line: undefined-field
              if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
                return
              end
            end
            client.config.settings.Lua = vim.tbl_deep_extend("force",
              client.config.settings.Lua, {
                runtime = { version = "LuaJIT" },
                workspace = {
                  checkThirdParty = false,
                  library = { vim.env.VIMRUNTIME },
                },
              })
          end,
          settings = {
            Lua = {
              hint = {
                enable = false,
                arrayIndex = "Auto",
                await = true,
                paramName = "All",
                paramType = true,
                semicolon = "SameLine",
                setType = false,
              },
            },
          },
        },

        zls = {
          settings = {
            zls = {
              enable_build_on_save = true,
              inlay_hints_show_builtin = true,
              inlay_hints_exclude_single_argument = true,
              inlay_hints_hide_redundant_param_names = true,
              inlay_hints_hide_redundant_param_names_last_token = true,
            }
          }
        },

        ts_ls = {
          init_options = {
            preferences = {
              quotePreference = "double",
              importModuleSpecifierEnding = "js",
            },
          },
          settings = {
            typescript = {
              format     = {
                semicolons = "remove",
                trimTrailingWhitespace = true,
              },
              inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
              },
            },
          },
        },
      },
    })

    vim.lsp.config("ebnfer", {
      cmd = { vim.fn.has("win32") == 1 and "ebnfer.exe" or "ebnfer" },
      filetypes = { "ebnf" },
      root_markers = { ".ebnfer-root", ".git" },
    })

    vim.lsp.enable("ebnfer")

    vim.diagnostic.config({
      signs = false,
      virtual_text = {
        prefix = "■",
        spacing = 2,
      },
      underline = true,
      update_in_insert = false,
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(event)
        local opts = { buffer = event.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)
        vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
      end,
    })
  end,
}
