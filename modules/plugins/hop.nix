{
  neovim.mods =
    { config, lib, ... }:
    {
      extraConfigLua = # lua
        ''
          ${lib.optionalString (config.nito.theme == "light") # lua
            ''
              vim.api.nvim_set_hl(0, "HopUnmatched", { fg = "#000000" })
              vim.api.nvim_create_autocmd("ColorScheme", {
                pattern = "*",
                callback = function()
                  vim.api.nvim_set_hl(0, "HopUnmatched", { fg = "#000000" })
                end,
              })
            ''
          }
        '';

      plugins.hop = {
        enable = true;
        settings = {
          virtual_cursor = true;
          quit_key = "<Esc>";
          teasing = true;
        };

        lazyLoad = {
          enable = true;
          settings = {
            cmd = [
              "HopWord"
              "HopLine"
              "HopChar1"
              "HopChar2"
              "HopPattern"
            ];
          };
        };
      };

      keymaps = [
        {
          mode = "n";
          key = "<leader>hw";
          action = "<cmd>HopWord<cr>";
          options = {
            desc = "Hop to Word";
            silent = true;
            noremap = true;
          };
        }
        {
          mode = "v";
          key = "<leader>hw";
          action = "<cmd>HopWord<cr>";
          options = {
            desc = "Hop to Word";
            silent = true;
            noremap = true;
          };
        }
      ];
    };
}
