{
  neovim.mods = {
    plugins.snacks.settings = {
      scratch = {
        enabled = true;
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>sb";
        action = "<cmd>:lua Snacks.scratch()<cr>";
        options = {
          desc = "Toggle Scratch Buffer";
          silent = true;
          noremap = true;
        };
      }
      {
        mode = "n";
        key = "<leader>ss";
        action = "<cmd>:lua Snacks.scratch.select()<cr>";
        options = {
          desc = "Select Scratch Buffer";
          silent = true;
          noremap = true;
        };
      }
    ];
  };
}
