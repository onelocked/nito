{
  neovim.mods = { mkRaw, ... }: {
    extraConfigLua = # lua
      ''
        _G.open_in_kitty = function(file, line, col)
          -- Expand to absolute path to ensure kitty finds it
          local path = vim.fn.fnamemodify(file, ":p")
          local cmd = "kitty -1 nvim"
          if line and col then
            cmd = cmd .. string.format(" '+call cursor(%d, %d)'", line, col)
          elseif line then
            cmd = cmd .. string.format(" '+%d'", line)
          end
          -- Escape the path properly
          cmd = cmd .. string.format(" %s", vim.fn.shellescape(path))

          -- Spawn the kitty window asynchronously
          os.execute(cmd .. " >/dev/null 2>&1 &")
        end

        -- Provide a command to manually open a file in a new kitty window
        vim.api.nvim_create_user_command("Kedit", function(opts)
          _G.open_in_kitty(opts.args)
        end, { nargs = 1, complete = "file" })

        _G.move_buf_to_kitty = function()
          local buf = vim.api.nvim_get_current_buf()
          local name = vim.api.nvim_buf_get_name(buf)

          if name == "" or vim.bo[buf].buftype ~= "" then
            vim.notify("Nothing to move: not a file buffer", vim.log.levels.WARN)
            return
          end

          local others = vim.tbl_filter(function(b)
            return b.bufnr ~= buf
          end, vim.fn.getbufinfo({ buflisted = 1 }))
          if #others == 0 then
            return
          end

          if vim.bo[buf].modified then
            vim.cmd("silent update")
          end

          local pos = vim.api.nvim_win_get_cursor(0)
          _G.open_in_kitty(name, pos[1], pos[2] + 1)

          if _G.Snacks and Snacks.bufdelete then
            Snacks.bufdelete(buf)
          else
            vim.cmd("bnext | bdelete " .. buf)
          end
        end

        vim.api.nvim_create_user_command("Kmove", function()
          _G.move_buf_to_kitty()
        end, {})
      '';

    keymaps = [
      {
        mode = "n";
        key = "W";
        action = "<cmd>lua _G.move_buf_to_kitty()<cr>";
        options = {
          desc = "Move buffer to new kitty window";
          silent = true;
        };
      }
    ];

    plugins.snacks.settings.picker.actions = {
      hypr_focus_or_edit = mkRaw ''
        function(picker, item, action)
          local confirm = require("snacks.picker.actions").confirm
          if not item or not (item.file or item._path) then
            return confirm(picker, item, action)
          end

          local function real(p)
            return (vim.uv.fs_realpath(p)) or vim.fn.fnamemodify(p, ":p")
          end

          local raw = item._path or item.file
          local path
          if raw:sub(1, 1) == "/" or raw:sub(1, 1) == "~" then
            path = vim.fn.fnamemodify(raw, ":p")
          else
            local base = item.cwd or picker.cwd or vim.fn.getcwd()
            path = vim.fn.fnamemodify(base .. "/" .. raw, ":p")
          end
          local target = real(path)

          local main_win = picker.main
          if main_win and vim.api.nvim_win_is_valid(main_win) then
            local cur_name = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(main_win))
            if cur_name ~= "" and real(cur_name) == target then
              picker:close()
              if item.pos then
                pcall(vim.api.nvim_win_set_cursor, main_win, { item.pos[1], item.pos[2] })
                vim.api.nvim_win_call(main_win, function() vim.cmd("normal! zz") end)
              end
              return
            end
          end

          local remote_code = [[
            local target, pos = ...
            local function real(p)
              return (vim.uv.fs_realpath(p)) or vim.fn.fnamemodify(p, ":p")
            end
            for _, b in ipairs(vim.api.nvim_list_bufs()) do
              local name = vim.api.nvim_buf_get_name(b)
              if name ~= "" and vim.bo[b].buflisted and real(name) == target then
                local wins = vim.fn.win_findbuf(b)
                if #wins > 0 then
                  vim.api.nvim_set_current_win(wins[1])
                else
                  vim.api.nvim_set_current_buf(b)
                end
                if pos then
                  pcall(vim.api.nvim_win_set_cursor, 0, { pos[1], pos[2] })
                  vim.cmd("normal! zz")
                end
                return vim.env.KITTY_WINDOW_ID or false
              end
            end
            return false
          ]]

          local kitty_window_id = nil
          local self_socket = vim.v.servername
          local uid = vim.fn.system("id -u"):gsub("%s+", "")
          local sockets = vim.fn.glob("/run/user/" .. uid .. "/nvim.*.0", true, true)

          for _, socket in ipairs(sockets) do
            if socket ~= self_socket then
              local connect_ok, chan_id = pcall(vim.fn.sockconnect, "pipe", socket, { rpc = true })
              if connect_ok and chan_id > 0 then
                local req_ok, result = pcall(
                  vim.rpcrequest, chan_id, "nvim_exec_lua", remote_code,
                  { target, item.pos and { item.pos[1], item.pos[2] } or false }
                )
                pcall(vim.fn.chanclose, chan_id)
                if req_ok and result and result ~= vim.NIL then
                  kitty_window_id = result
                  break
                end
              end
            end
          end

          if kitty_window_id then
            os.execute(string.format("kitty @ focus-window -m id:%s >/dev/null 2>&1", kitty_window_id))
            picker:close()
            return
          end

          return confirm(picker, item, action)
        end
      '';
    };

  };
}
