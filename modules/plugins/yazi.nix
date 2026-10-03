{
  neovim.mods =
    { pkgs, ... }:
    {
      extraPlugins = [ pkgs.vimPlugins.yazi-nvim ];
      extraConfigLua = ''
        _G.focus_if_open_elsewhere = function(path, pos)
          local function real(p)
            return (vim.uv.fs_realpath(p)) or vim.fn.fnamemodify(p, ":p")
          end
          local target = real(path)

          local remote_code = [==[
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
          ]==]

          local uid = vim.fn.system("id -u"):gsub("%s+", "")
          local sockets = vim.fn.glob("/run/user/" .. uid .. "/nvim.*.0", true, true)
          for _, socket in ipairs(sockets) do
            if socket ~= vim.v.servername then
              local ok, chan = pcall(vim.fn.sockconnect, "pipe", socket, { rpc = true })
              if ok and chan > 0 then
                local req_ok, result = pcall(
                  vim.rpcrequest, chan, "nvim_exec_lua", remote_code,
                  { target, pos or false }
                )
                pcall(vim.fn.chanclose, chan)
                if req_ok and result and result ~= vim.NIL then
                  os.execute(string.format("kitty @ focus-window -m id:%s >/dev/null 2>&1", result))
                  return true
                end
              end
            end
          end
          return false
        end

        require('yazi').setup {
          yazi_command = "yazi",
          open_for_directories = true,
          floating_window_scaling_factor = 0.8,
          yazi_floating_window_border = "single",
          open_file_function = function(chosen_file, config, state)
            if focus_if_open_elsewhere(chosen_file) then
              return
            end
            vim.cmd(string.format("edit %s", vim.fn.fnameescape(chosen_file)))
          end,
        }

        vim.keymap.set('n', '<leader>y', function()
          require('yazi').yazi()
        end, { desc = 'File Explorer (Yazi)' })
      '';
    };
}
