{
  neovim.mods =
    { pkgs, ... }:
    {
      extraPlugins = [ pkgs.vimPlugins.yazi-nvim ];
      extraConfigLua = ''
        require('yazi').setup {
          yazi_command = "yazi",
          open_for_directories = true,
          floating_window_scaling_factor = 0.8,
          yazi_floating_window_border = "single",
        }

        vim.keymap.set('n', '<leader>y', function()
          require('yazi').yazi()
        end, { desc = 'File Explorer (Yazi)' })
      '';
    };
}
