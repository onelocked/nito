{
  neovim.visual =
    { pkgs, ... }:
    {

      extraPlugins = [
        pkgs.vimPlugins.windows-nvim
        pkgs.vimPlugins.nvzone-minty
      ];
      extraConfigLua = # lua
        ''
          vim.o.winwidth = 10
          vim.o.winminwidth = 10
          vim.o.equalalways = false
          require('windows').setup({
            ignore = {
              filetype = { "snacks_picker_list", "snacks_layout_box" },
            },
          })

          require('minty').setup({
            huefy = {
              border = "single",
              mappings = function(buf)
                local api = require("minty.shades.api")
                vim.keymap.set("n", "s", api.save_color, { buffer = buf })
              end
            }
          })
        '';

    };
}
