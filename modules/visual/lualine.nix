{
  neovim.visual =
    { lib, ... }:
    let
      diff_component = {
        __unkeyed-1 = "diff";
        symbols = {
          added = " ";
          modified = " ";
          removed = " ";
        };
        source =
          lib.nixvim.mkRaw # lua
            ''
              function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end
            '';
      };
    in
    {
      plugins.lualine = {
        enable = true;
        settings = {
          options = {
            icons_enabled = true;
            # Colors come from the lualine_* highlight groups in colorscheme.nix.
            theme = "auto";
            component_separators = {
              left = "│";
              right = "│";
            };
            section_separators = {
              left = "▌";
              right = "";
            };
            disabled_filetypes = {
              statusline = [
                "alpha"
                "dashboard"
                "snacks_dashboard"
              ];
              winbar = [ ];
            };
            ignore_focus = [ ];
            always_divide_middle = true;
            globalstatus = true;
            refresh = {
              statusline = 1000;
              tabline = 1000;
              winbar = 1000;
            };
          };

          sections = {
            lualine_a = [ "mode" ];
            lualine_b = [
              "branch"
              "diagnostics"
            ];
            lualine_c = [ diff_component ];
            lualine_x = [
              "encoding"
              "fileformat"
              "filetype"
            ];
            lualine_y = [ "progress" ];
            lualine_z = [ "location" ];
          };

          inactive_sections = {
            lualine_a = [ ];
            lualine_b = [ ];
            lualine_c = [ ];
            lualine_x = [ "location" ];
            lualine_y = [ ];
            lualine_z = [ ];
          };
        };
      };
    };
}
