{
  neovim.mods = { mkRaw, ... }: {
    plugins.snacks.settings = {
      scratch = {
        enabled = true;
      };
    };
    lsp.servers.nixd = {
      # Skip LSP for Snacks scratch buffers
      config.root_dir = mkRaw ''
        function(bufnr, on_dir)
          local name = vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))
          local scratch = vim.fs.normalize(vim.fn.stdpath("data") .. "/scratch")
          if vim.startswith(name, scratch .. "/") then
            return
          end
          on_dir(vim.fs.root(bufnr, { "flake.nix", ".git" }))
        end
      '';
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
