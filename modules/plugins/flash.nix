{
  neovim.mods = {
    plugins.flash = {
      enable = true;
      settings.modes.char.enabled = false;
      lazyLoad.settings.keys = [
        {
          __unkeyed-1 = "<leader>fs";
          __unkeyed-2 = "<cmd>lua require('flash').jump({ forward = true, wrap = true, multi_window = true })<CR>";
          mode = [
            "n"
            "v"
          ];
          desc = "Flash Search";
        }
      ];
    };
  };
}
