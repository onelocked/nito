{
  neovim.mods = {
    plugins.cord = {
      enable = true;
      lazyLoad.settings.event = "DeferredUIEnter";
      settings = {
        display = {
          flavor = "dark";
          theme = "catppuccin";
        };
        editor = {
          tooltip = "Neovim";
        };
        idle = {
          enabled = true;
          timeout = 900000;
        };
        text = {
          workspace = "";
        };
        timestamp = {
          reset_on_idle = true;
        };
      };
    };
  };
}
