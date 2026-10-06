{
  neovim.visual =
    { pkgs, ... }:
    {
      extraPlugins = with pkgs.vimPlugins; [
        neoscroll-nvim
      ];

      extraConfigLua = # lua
        ''
          -- Setup smooth scrolling
          require('neoscroll').setup({
            mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
            hide_cursor = true,
            stop_eof = false,
            respect_scrolloff = false,
            cursor_scrolls_alone = true,
            easing_function = "linear",
          })
        '';
    };
}
