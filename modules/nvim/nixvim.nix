{
  neovim.core =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      luaLoader.enable = false;
      dependencies = {
        gcc.enable = true;
      };
      performance.byteCompileLua = {
        enable = true;
        plugins = true;
        nvimRuntime = true;
      };
      vimAlias = true;
      clipboard.providers.wl-copy = {
        enable = true;
        package = pkgs.wl-clipboard;
      };
      globals = {
        mapleader = " ";
        floating_window_options.border = "rounded";
        loaded_netrw = 1;
        loaded_netrwPlugin = 1;
        loaded_gzip = 1;
        loaded_tar = 1;
        loaded_tarPlugin = 1;
        loaded_zip = 1;
        loaded_zipPlugin = 1;
        loaded_tutor_mode_plugin = 1;
        loaded_2html_plugin = 1;
        loaded_matchparen = 1;
        loaded_spellfile_plugin = 1;
      };

      opts = {

        clipboard = "unnamedplus";
        cursorline = true;
        cursorlineopt = "number";

        pumblend = 0;
        pumheight = 10;

        expandtab = true;
        shiftwidth = 2;
        smartindent = true;
        tabstop = 2;
        softtabstop = 2;

        ignorecase = true;
        smartcase = true;
        mouse = "";
        cmdheight = 0;

        number = true;
        relativenumber = true;
        numberwidth = 2;
        ruler = false;

        signcolumn = "yes";
        splitbelow = true;
        splitright = true;
        splitkeep = "screen";
        termguicolors = true;

        conceallevel = 2;

        undofile = true;

        wrap = false;

        virtualedit = "block";
        winminwidth = 5;
        fileencoding = "utf-8";
        list = true;
        smoothscroll = true;
        autoread = true;
        fillchars = {
          eob = " ";
        };

        updatetime = 500;
      };

      autoCmd = [
        {
          desc = "Highlight on yank";
          event = [ "TextYankPost" ];
          callback =
            lib.nixvim.mkRaw # lua
              ''
                function()
                  vim.highlight.on_yank()
                end
              '';
        }
        {
          event = [
            "FocusGained"
            "BufEnter"
            "CursorHold"
            "CursorHoldI"
          ];
          pattern = "*";
          command = "if mode() !~ '\\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif";
        }
        {
          event = [ "FileChangedShellPost" ];
          pattern = "*";
          command = "echohl WarningMsg | echo 'File changed on disk. Buffer reloaded.' | echohl None";
        }
      ];

      extraLuaPackages = lp: with lp; [ luarocks ];
      extraConfigLua = # lua
        ''
          vim.opt.title = true
          vim.opt.titlestring = "nvim - %F%( %M%)"

          vim.opt.whichwrap:append("<>[]hl")
          vim.opt.listchars:append("space:·")
          vim.api.nvim_set_hl(0, "Whitespace", { fg = "${
            if config.nito.theme == "light" then "#aaaaaa" else "#434343"
          }" })
        '';
    };
}
