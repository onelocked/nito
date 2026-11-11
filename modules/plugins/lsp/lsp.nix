{
  neovim.mods = {
    plugins = {
      trim = {
        enable = true;
        lazyLoad = {
          enable = true;
          settings = {
            event = [ "BufWritePre" ];
          };
        };
      };

      lsp = {
        enable = true;
        inlayHints = true;
        servers = {
          harper_ls.enable = false;
          typos_lsp = {
            enable = true;
            extraOptions.init_options.diagnosticSeverity = "Hint";
          };
        };
        keymaps = {
          silent = true;
          # Don't use `keymaps.diagnostic` here: nixvim still generates the
          # deprecated `vim.diagnostic.goto_next()`/`goto_prev()` functions.
          # Use `vim.diagnostic.jump()` explicitly instead.
        };
      };
    };

    diagnostic.settings = {
      virtual_text = false;
      underline = true;
      signs = false;
      severity_sort = false;
      float = {
        border = "single";
        source = "always";
        focusable = false;
      };
    };

    plugins.lsp.keymaps.extra = [
      {
        mode = "n";
        key = "<leader>lj";
        action = "<cmd>lua vim.diagnostic.jump({ count = 1, float = true })<cr>";
        options = {
          desc = "Next diagnostic";
          silent = true;
          noremap = true;
        };
      }
      {
        mode = "n";
        key = "<leader>lk";
        action = "<cmd>lua vim.diagnostic.jump({ count = -1, float = true })<cr>";
        options = {
          desc = "Previous diagnostic";
          silent = true;
          noremap = true;
        };
      }
      {
        mode = "n";
        key = "<leader>lD";
        action = "<cmd>:lua Snacks.picker.lsp_definitions()<cr>";
        options = {
          desc = "Definitions list";
          silent = true;
          noremap = true;
        };
      }
      {
        mode = "n";
        key = "<leader>ls";
        action = "<cmd>:lua Snacks.picker.lsp_symbols()<cr>";
        options = {
          desc = "Definitions list";
          silent = true;
          noremap = true;
        };
      }
      {
        mode = "n";
        key = "<leader>lf";
        action = "<cmd>:lua require('conform').format()<cr>";
        options = {
          desc = "Format file";
          silent = true;
          noremap = true;
        };
      }
    ];
  };
}
