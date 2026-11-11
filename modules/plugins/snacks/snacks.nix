{
  neovim.mods =
    { mkRaw, ... }:
    {
      plugins.snacks = {
        enable = true;
        settings = {
          bigfile.enabled = true;
          scroll.enabled = false;
          quickfile.enabled = true;
          indent.enabled = true;
          words.enabled = true;
          input.enabled = true;
          terminal.enabled = true;
          scratch.enabled = false;
          image = {
            enabled = true;
            border = "single";
            doc.inline = false;
          };
          styles = {
            notification.border = "single";
            notification_history.border = "single";
          };
        };
      };
      keymaps = [
        {
          mode = "n";
          key = "<leader>.r";
          action = "<cmd>:lua Snacks.rename.rename_file()<cr>";
          options = {
            desc = "Rename file/variable +lsp";
            silent = true;
            noremap = true;
          };
        }
        {
          mode = "n";
          key = "<leader>gB";
          action = "<cmd>:lua Snacks.gitbrowse()<cr>";
          options = {
            desc = "Git Browse";
            silent = true;
            noremap = true;
          };
        }

        {
          mode = "n";
          key = "<leader>ss";
          action = "<cmd>:lua Snacks.picker.smart()<cr>";
          options = {
            desc = "Smart";
            silent = true;
            noremap = true;
          };
        }
        {
          mode = "n";
          key = "<leader>s,";
          action = "<cmd>:lua Snacks.picker.buffers({layout = 'vscode'})<cr>";
          options = {
            desc = "Buffers";
            silent = true;
            noremap = true;
          };
        }
        {
          mode = "n";
          key = "<leader>fr";
          action = "<cmd>:lua Snacks.picker.recent()<cr>";
          options = {
            desc = "Recent";
            silent = true;
            noremap = true;
          };
        }
        {
          mode = "n";
          key = "<leader>fp";
          action = "<cmd>:lua Snacks.picker.projects()<cr>";
          options = {
            desc = "Pickers";
            silent = true;
            noremap = true;
          };
        }
        {
          mode = "n";
          key = "<leader>su";
          action = (
            mkRaw ''
              function()
                Snacks.picker.undo({
                  win = {
                    input = {
                      keys = {
                        ["y"] = { "yank_add", mode =  "n" },
                        ["Y"] = { "yank_del", mode =  "n" },
                      },
                    },
                  },
                })
              end
            ''
          );
          options = {
            desc = "Undo";
            silent = true;
            noremap = true;
          };
        }
      ];
    };
}
