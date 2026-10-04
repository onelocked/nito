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
          diagnostic = {
            "<leader>lj" = "goto_next";
            "<leader>lk" = "goto_prev";
          };
        };
      };
    };

    diagnostic.settings = {
      virtual_text = false;
      underline = true;
      signs = false;
      severity_sort = false;
      float = {
        border = "rounded";
        source = "always";
        focusable = false;
      };
    };

    plugins.lsp.keymaps.extra = [
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
