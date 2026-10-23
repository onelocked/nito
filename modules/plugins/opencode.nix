{
  tack.inputs.opencode-nvim = {
    url = "gh:nickjvandyke/opencode.nvim";
    type = "fetch";
  };
  neovim.mods = { pkgs, inputs, ... }: {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        pname = "opencode.nvim";
        version = "2.0.0";
        src = inputs.opencode-nvim;
      })
    ];
    extraConfigLua = ''
      vim.keymap.set({ "n", "x" }, "<leader>aa", function() require("opencode").ask("@this: ") end, { desc = "Ask OpenCode" })
    '';
  };
}
