{
  neovim.visual =
    { lib, ... }:
    let
      filename_component = {
        __unkeyed-1 =
          lib.nixvim.mkRaw # lua
            ''
              function()
                local name = vim.fn.expand("%:t")
                if name == "" then
                  return nil
                end
                local icon = ""
                local ok, devicons = pcall(require, "nvim-web-devicons")
                if ok then
                  icon = devicons.get_icon(name, vim.bo.filetype, { default = true }) or ""
                end
                return icon ~= "" and (icon .. " " .. name) or name
              end
            '';
        cond =
          lib.nixvim.mkRaw # lua
            ''
              function()
                return vim.fn.expand("%:t") ~= ""
              end
            '';
      };

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
              filename_component
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
            lualine_b = [ filename_component ];
            lualine_c = [ "filename" ];
            lualine_x = [ "location" ];
            lualine_y = [ ];
            lualine_z = [ ];
          };
        };
      };
    };
}
