{
  neovim.mods = { pkgs, ... }: {
    plugins.highlight-colors = {
      enable = true;

      lazyLoad = {
        enable = true;
        settings = {
          event = [
            "BufReadPost"
            "BufNewFile"
          ];
        };
      };

      settings = {
        enable_named_colors = true;
        render = "background";
        virtual_symbol = "■";
      };
    };
    extraPlugins = [ pkgs.vimPlugins.nvzone-minty ];
    extraConfigLua = # lua
      ''
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
