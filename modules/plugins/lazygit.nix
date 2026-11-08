{
  neovim.mods =
    { pkgs, mkRaw, ... }:
    {
      extraPlugins = [ pkgs.vimPlugins.lazygit-nvim ];
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
              local cwd
              local ok, lib = pcall(require, "diffview.lib")
              if ok then
                local view = lib.get_current_view()
                cwd = view and view.adapter and view.adapter.ctx and view.adapter.ctx.toplevel
              end

              if not cwd then
                local bufname = vim.api.nvim_buf_get_name(0)
                local is_path = bufname ~= "" and not bufname:match("^%a[%w+.-]*://")
                local buf_dir = is_path and vim.fn.fnamemodify(bufname, ":p:h")

                if buf_dir and vim.fn.isdirectory(buf_dir) == 1 then
                  local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(buf_dir) .. " rev-parse --show-toplevel")[1]
                  cwd = (git_root and vim.v.shell_error == 0) and git_root or buf_dir
                end
              end

              cwd = cwd or vim.fn.getcwd()
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
