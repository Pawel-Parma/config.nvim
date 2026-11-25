return {
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      ensure_installed = {
        "basedpyright",
        "bashls",
        "clangd",
        "cssls",
        "gopls",
        "html",
        "jsonls",
        "lua_ls",
        "markdown_oxide",
        "texlab",
        "ts_query_ls",
        "ts_ls",
        "yamlls",
        "zls",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      auto = {
        clangd = {
          init_options = {
            fallbackFlags = { "--std=c++23" },
          },
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
              format = {
                enable = true,
                defaultConfig = {
                  max_line_length = tostring(vim.o.textwidth),
                },
              },
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
        ts_query_ls = {
          settings = {
            parser_install_directories = {
              vim.fn.stdpath("data") .. "/site/parser",
              vim.fn.expand("~/personal/coding/mtl/mtl/grammar"),
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
        yamlls = {
          settings = {
            yaml = {
              yamlVersion = "1.2.2",
            }
          }
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
      },
      manual = {
        ebnfer = {
          cmd = { vim.fn.has("win32") == 1 and "ebnfer.exe" or "ebnfer" },
          filetypes = { "ebnf" },
          root_markers = { ".ebnfer-root", ".git" },
        }
      },
    },

    config = function(_, servers)
      for server, config in pairs(servers.auto) do
        vim.lsp.config(server, config)
      end

      for server, config in pairs(servers.manual) do
        if vim.fn.executable(config.cmd[1]) == 1 then
          vim.lsp.config(server, config)
          vim.lsp.enable(server)
        end
      end

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
          local buf = event.buf

          vim.lsp.inlay_hint.enable(true, { buffer = buf })
          vim.keymap.set("n", "<leader>y", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { buffer = event.buf })
          end, { buffer = buf, desc = "Toggle inlay hints" })

          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "Go to definition" })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = buf, desc = "Go to declaration" })
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = buf, desc = "Go to implementation" })
          vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = buf, desc = "Go to references" })
          vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = buf, desc = "Go to type definition" })
          vim.keymap.set("n", "R", vim.lsp.buf.hover, { buffer = buf, desc = "Show as if hover" })
          vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help, { buffer = buf, desc = "Show signature help" })

          vim.keymap.set("n", "ca", vim.lsp.buf.code_action, { buffer = buf, desc = "Code action" })
          vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { buffer = buf, desc = "Rename" })

          vim.keymap.set("n", { "<leader>qd", "<leader>dq" }, function()
            vim.diagnostic.setqflist({ open = true })
          end, { buffer = buf, desc = "Send diagnostics to quickfix" })
          vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float, { buffer = buf, desc = "Show line diagnostic" })
        end,
      })
    end,
  },
}
