{
  neovim.mods = { pkgs, ... }: {
    extraPlugins = [ pkgs.vimPlugins.opencode-nvim ];
    extraConfigLua = ''
      vim.keymap.set({ "n", "x" }, "<leader>aa", function() require("opencode").ask("@this: ") end, { desc = "Ask OpenCode" })
    '';
  };
}
