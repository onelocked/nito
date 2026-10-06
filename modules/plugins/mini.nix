{
  neovim.mods = {
    plugins.mini = {
      enable = true;
      modules = {
        comment = {
          mappings = {
            comment = "<leader>/";
            comment_line = "<leader>/";
            comment_visual = "<leader>/";
            ignore_blank_line = true;
          };
        };
        icons = { };
        pairs = { };
        surround = { };
        operators = { };
        bufremove = { };
        ai = { };
        bracketed = { };
      };
      lazyLoad = {
        enable = true;
        settings = {
          keys = [ "<leader>/" ];
          event = [
            "BufReadPost"
            "BufNewFile"
          ];
        };
      };
    };
  };
}
