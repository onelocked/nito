{
  neovim.visual =
    { pkgs, config, ... }:
    let
      c = config.nito.${config.nito.theme};
    in
    {
      extraPlugins = [ pkgs.vimPlugins.lualine-nvim ];
      extraConfigLua = # lua
        ''
          local symbols = nil
          local function get_symbols()
            if not symbols and package.loaded["trouble"] then
              symbols = require("trouble").statusline({
                mode = "symbols",
                groups = {},
                title = false,
                filter = { range = true },
                format = "{kind_icon}{symbol.name:Normal}",
                hl_group = "lualine_c_normal",
              })
            end
            return symbols
          end

          local custom_theme = {
            normal = {
              a = { fg = "${c.base01}", bg = "${
                if config.nito.theme == "light" then c.base0D else c.base17
              }", gui = "bold" },
              b = { fg = "${c.base05}", bg = "${c.base02}" },
              c = { fg = "${c.base05}", bg = "${c.base00}" },
            },
            insert = {
              a = { fg = "${c.base01}", bg = "${c.base0B}", gui = "bold" },
              b = { fg = "${c.base05}", bg = "${c.base02}" },
              c = { fg = "${c.base05}", bg = "${c.base00}" },
            },
            visual = {
              a = { fg = "${c.base01}", bg = "${c.base0E}", gui = "bold" },
              b = { fg = "${c.base05}", bg = "${c.base02}" },
              c = { fg = "${c.base05}", bg = "${c.base00}" },
            },
            replace = {
              a = { fg = "${c.base01}", bg = "${c.base08}", gui = "bold" },
              b = { fg = "${c.base05}", bg = "${c.base02}" },
              c = { fg = "${c.base05}", bg = "${c.base00}" },
            },
            command = {
              a = { fg = "${c.base01}", bg = "${c.base09}", gui = "bold" },
              b = { fg = "${c.base05}", bg = "${c.base02}" },
              c = { fg = "${c.base05}", bg = "${c.base00}" },
            },
            inactive = {
              a = { fg = "${c.base03}", bg = "${c.base00}" },
              b = { fg = "${c.base03}", bg = "${c.base00}" },
              c = { fg = "${c.base03}", bg = "${c.base00}" },
            },
          }

          require('lualine').setup({
            options = {
              icons_enabled = true,
              theme = custom_theme,
              component_separators = {
                left = "│",
                right = "│",
              },
              section_separators = {
                left = "▌",
                right = "",
              },
              disabled_filetypes = {
                statusline = { "alpha", "dashboard", "snacks_dashboard" },
                winbar = { },
              },
              ignore_focus = { },
              always_divide_middle = true,
              always_show_tabline = true,
              globalstatus = true,
              refresh = {
                statusline = 1000,
                tabline = 1000,
                winbar = 1000,
              },
            },
            sections = {
              lualine_a = { "mode" },
              lualine_b = {
                "branch",
                "diff",
                "diagnostics",
              },
              lualine_c = {
                {
                  'diff',
                  symbols = {
                    added = ' ',
                    modified = ' ',
                    removed = ' ',
                  },
                  source = function()
                    local gitsigns = vim.b.gitsigns_status_dict
                    if gitsigns then
                      return {
                        added = gitsigns.added,
                        modified = gitsigns.changed,
                        removed = gitsigns.removed,
                      }
                    end
                  end,
                },

                'filename',
                {
                  symbols and symbols.get,
                  cond = function()
                    return vim.b.trouble_lualine ~= false and symbols.has()
                  end,
                },
              },
              lualine_x = {
                "encoding",
                "fileformat",
                "filetype",
              },
              lualine_y = { "progress" },
              lualine_z = { "location" },
            },
            inactive_sections = {
              lualine_a = { },
              lualine_b = { },
              lualine_c = { "filename" },
              lualine_x = { "location" },
              lualine_y = { },
              lualine_z = { },
            },
            tabline = { },
            winbar = { },
            inactive_winbar = { },
            extensions = { },
          })
        '';
    };
}
