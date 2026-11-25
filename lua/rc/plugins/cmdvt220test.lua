return {
  "name",
  virtual = true,
  dependencies = {
    "m00qek/baleia.nvim",
  },
  config = function()
    local color = true

    -- TODO: ai slop, isolate the minimal poc
    local baleia = require("baleia").setup({
      strip_ansi_codes = true,
      async = false,
    })

    local SGR_PLACEHOLDER = "\u{E000}"
    local EOF_SENTINEL = "\u{E001}COMPILE_EOF\u{E001}"

    function Run_compile(cmd)
      local pty_buf = vim.api.nvim_create_buf(false, true)
      local term_chan = vim.api.nvim_open_term(pty_buf, {})

      vim.cmd("botright vnew")
      local out_buf = vim.api.nvim_get_current_buf()
      vim.bo[out_buf].buftype = "nofile"
      vim.bo[out_buf].bufhidden = "wipe"
      vim.bo[out_buf].swapfile = false

      local function sync_lines(strip_eof)
        if not (vim.api.nvim_buf_is_valid(pty_buf) and vim.api.nvim_buf_is_valid(out_buf)) then
          return false
        end

        local lines = vim.api.nvim_buf_get_lines(pty_buf, 0, -1, false)
        while #lines > 0 and lines[#lines] == "" do
          table.remove(lines)
        end

        local saw_eof = false
        if strip_eof and #lines > 0 and lines[#lines]:find(EOF_SENTINEL, 1, true) then
          saw_eof = true
          lines[#lines] = lines[#lines]:gsub(EOF_SENTINEL, "")
          if lines[#lines] == "" then
            table.remove(lines)
          end
        end

        if color then
          for i, line in ipairs(lines) do
            lines[i] = line:gsub(SGR_PLACEHOLDER, "\27")
          end
          vim.api.nvim_buf_set_lines(out_buf, 0, -1, false, lines)
          baleia.once(out_buf)
        else
          for i, line in ipairs(lines) do
            lines[i] = line:gsub(SGR_PLACEHOLDER .. "%[[0-9;]*m", "")
          end
          vim.api.nvim_buf_set_lines(out_buf, 0, -1, false, lines)
        end

        return saw_eof
      end

      local pending_chunks = 0
      local exited = false
      local exit_code = 0
      local sentinel_sent = false

      local function poll_until_flushed()
        if not vim.api.nvim_buf_is_valid(pty_buf) then
          return
        end
        if sync_lines(true) then
          -- Sentinel arrived -> libvterm has flushed every single byte!
          if vim.api.nvim_buf_is_valid(out_buf) then
            vim.api.nvim_buf_set_lines(out_buf, -1, -1, false, { "", "[Process exited with code " .. exit_code .. "]" })
          end
          vim.api.nvim_buf_delete(pty_buf, { force = true })
        else
          -- Keep yielding until libvterm finishes rendering the sentinel
          vim.defer_fn(poll_until_flushed, 5)
        end
      end

      local function maybe_send_sentinel()
        if exited and pending_chunks == 0 and not sentinel_sent then
          sentinel_sent = true
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(pty_buf) then
              vim.api.nvim_chan_send(term_chan, "\r\n" .. EOF_SENTINEL .. "\r\n")
              vim.schedule(poll_until_flushed)
            end
          end)
        end
      end

      vim.fn.jobstart(cmd, {
        pty = true,
        width = 1000,
        height = 1000,
        on_stdout = function(_, data, _)
          if not data then
            return
          end
          local raw = table.concat(data, "\n")
          if raw == "" then
            return
          end

          local masked = raw:gsub("\27(%[[0-9;]*m)", SGR_PLACEHOLDER .. "%1")

          pending_chunks = pending_chunks + 1
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(pty_buf) then
              vim.api.nvim_chan_send(term_chan, masked)
            end
            pending_chunks = pending_chunks - 1
            if exited and pending_chunks == 0 then
              maybe_send_sentinel()
            else
              vim.schedule(function()
                sync_lines(false)
              end)
            end
          end)
        end,
        on_exit = function(_, code)
          exited = true
          exit_code = code
          vim.schedule(maybe_send_sentinel)
        end,
      })
    end
  end,
  keys = {
    {
      mode = "n",
      "<leader>po",
      function()
        Run_compile({
          "sh",
          "-c",
          [[
            printf '\033(0lqqqqqqqqqqqqqqqqqqqqqqqqqqk\033(B\n'
            printf '\033(0x\033(B \033[1;36mVT100 + ANSI Color Demo\033[0m  \033(0x\033(B\n'
            printf '\033(0mqqqqqqqqqqqqqqqqqqqqqqqqqqj\033(B\n\n'
            printf '\033[1;31mERROR:\033[0m \033[4msrc/main.c:42:10\033[0m: undefined reference\n'
            printf '\033[1;33mWARNING:\033[0m unused variable \033[35m`foo`\033[0m\n'
            printf '\033[38;5;208m256-Color Orange\033[0m | \033[48;5;24;38;5;255m 256-Color Badge \033[0m\n'
            printf '\033[38;2;80;250;123mTrueColor Mint\033[0m & \033[1;38;2;255;121;198mTrueColor Pink\033[0m\n\n'
            printf '\033[33m[1/3] Compiling...\033[0m'; sleep 1
            printf '\r\033[2K\033[36m[2/3] Linking...\033[0m'; sleep 1
            printf '\r\033[2K\033[1;32m[3/3] Build succeeded!\033[0m\n'

            printf "hello"
          ]],
        })
      end,
      desc = "Run headless compile test with Baleia ANSI colors",
    },
  },
}
