{
  neovim.visual = {
    plugins = {
      fidget = {
        enable = true;
        settings = {
          progress.display.progress_icon = [ "moon" ];
          notification.window = {
            relative = "editor";
            winblend = 0;
            border = "single";
          };
        };
      };
    };
  };
}
