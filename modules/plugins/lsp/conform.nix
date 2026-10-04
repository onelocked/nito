{
  neovim.mods =
    { lib, pkgs, ... }:
    {
      plugins.conform-nvim = {
        enable = true;
        lazyLoad = {
          enable = true;
          settings = {
            event = [
              "BufReadPost"
              "BufNewFile"
            ];
            cmd = [ "ConformInfo" ];
          };
        };

        settings = {
          default_format_opts.lsp_format = "prefer";
          format_on_save = {
            lsp_format = "fallback";
            timeout_ms = 500;
          };
          formatters_by_ft = {
            "_" = [
              "squeeze_blanks"
              "trim_whitespace"
              "trim_newlines"
            ];
          };
          formatters.squeeze_blanks.command = lib.getExe' pkgs.coreutils "cat";
        };
      };
      plugins.lsp.keymaps.extra = [
        {
          mode = "n";
          key = "<leader>lf";
          action = "<cmd>:lua require('conform').format()<cr>";
          options = {
            desc = "Format file";
            silent = true;
            noremap = true;
          };
        }
      ];
    };
}
