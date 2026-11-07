{
  neovim.mods = {
    nito.yazi = {
      enable = true;
      settings = {
        yazi_command = "yazi";
        open_for_directories = true;
        floating_window_scaling_factor = 0.8;
        yazi_floating_window_border = "single";
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>y";
        action = "<cmd>lua require('yazi').yazi()<cr>";
        options = {
          desc = "File Explorer (Yazi)";
          silent = true;
        };
      }
    ];
  };
  neovim.core =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.nito.yazi;
    in
    {
      options.nito.yazi = {
        enable = lib.mkEnableOption "yazi-nvim";
        settings = lib.mkOption {
          type = lib.types.attrsOf lib.types.anything;
          default = { };
          description = "Table passed to require('yazi').setup";
        };
      };
      config = lib.mkIf cfg.enable {
        extraPlugins = [ pkgs.vimPlugins.yazi-nvim ];
        extraConfigLua = ''
          require('yazi').setup(${lib.nixvim.toLuaObject cfg.settings})
        '';
      };
    };
}
