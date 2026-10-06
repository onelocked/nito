{
  neovim.mods = {
    plugins = {
      render-markdown = {
        enable = true;
        lazyLoad.settings.ft = "markdown";
      };
      markdown-preview = {
        enable = true;
        lazyLoad.settings = {
          ft = "markdown";
          cmd = [
            "MarkdownPreview"
            "MarkdownPreviewStop"
            "MarkdownPreviewToggle"
          ];
        };
      };
      glow = {
        enable = true;
        lazyLoad.settings = {
          ft = "markdown";
          cmd = "Glow";
        };
      };
    };
  };
}
