{
  neovim.core = { mkRaw, ... }: {
    opts = {
      clipboard = mkRaw "vim.env.SSH_CONNECTION and '' or 'unnamedplus'"; # Sync with system clipboard

      pumblend = 10;
      pumheight = 10;
      completeopt = "menu,menuone,noselect";

      expandtab = true;
      shiftwidth = 2;
      smartindent = true;
      tabstop = 2;
      softtabstop = 2;

      ignorecase = true;
      smartcase = true;
      mouse = "";
      cmdheight = 0;

      numberwidth = 2;
      ruler = false;

      signcolumn = "yes";
      splitbelow = true;
      splitright = true;
      splitkeep = "screen";
      termguicolors = true; # True color support

      conceallevel = 2;

      undofile = true;

      wrap = false;

      virtualedit = "block";
      winborder = "single";
      winminwidth = 5;
      fileencoding = "utf-8";
      list = true;
      smoothscroll = true;
      autoread = true;
      fillchars = {
        eob = " ";
      };
      updatetime = 300;
      timeoutlen = 300;

      scrolloff = 999;
      sidescrolloff = 8;

      confirm = true;
      autowrite = true;
      showmode = false;
      wildmode = "longest:full,full";
      wildignorecase = true;
      shortmess = "ltToOCFI";

      jumpoptions = "view";

      grepformat = "%f:%l:%c:%m";
      grepprg = "rg --vimgrep";

      spell = false;
      spelllang = "en";

      number = true;
      relativenumber = true;
      cursorline = true; # Enable highlighting of the current line
      showmatch = true; # Highlight matching parentheses, etc
      incsearch = true;
      hlsearch = true;

      showbreak = "   󱞵 ";
    };
  };
}
