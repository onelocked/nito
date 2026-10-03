{
  neovim.mods =
    { pkgs, mkRaw, ... }:
    {
      extraPlugins = [ pkgs.vimPlugins.lazygit-nvim ];

      extraConfigLua = # lua
        ''
          _G.LazygitEdit = function(path, line)
            vim.defer_fn(function()
              local pos = line > 0 and { line, 0 } or nil
              if _G.focus_if_open_elsewhere(path, pos) then
                return
              end
              vim.cmd("edit " .. vim.fn.fnameescape(path))
              if pos then
                pcall(vim.api.nvim_win_set_cursor, 0, pos)
                vim.cmd("normal! zz")
              end
            end, 100)
            return 0
          end
        '';

      plugins.lz-n.plugins = [
        {
          __unkeyed-1 = "lazygit.nvim";
          cmd = [
            "LazyGit"
            "LazyGitCurrentFile"
            "LazyGitFilter"
            "LazyGitFilterCurrentFile"
          ];
          keys = [ "<leader>gg" ];
        }
      ];

      keymaps = [
        {
          mode = "n";
          key = "<leader>gg";
          action = mkRaw ''
            function()
              local buf_dir = vim.fn.expand("%:p:h")
              local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(buf_dir) .. " rev-parse --show-toplevel")[1]
              local cwd = (git_root and vim.v.shell_error == 0) and git_root or buf_dir
              vim.cmd("lcd " .. vim.fn.fnameescape(cwd))
              vim.cmd("LazyGit")
            end
          '';
          options = {
            desc = "LazyGit";
            silent = true;
            noremap = true;
          };
        }
        {
          mode = "n";
          key = "<leader>gl";
          action = "<cmd>LazyGitFilterCurrentFile<cr>";
          options = {
            desc = "Lazygit Current File History";
            silent = true;
            noremap = true;
          };
        }
      ];
    };
}
