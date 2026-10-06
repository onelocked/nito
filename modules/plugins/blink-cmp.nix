{
  neovim.mods =
    { pkgs, ... }:
    {
      extraPlugins = with pkgs.vimPlugins; [
        blink-cmp
        blink-ripgrep-nvim
      ];

      extraConfigLua = # lua
        ''
          require('blink.cmp').setup({
            sources = {
              default = { "lsp", "path", "snippets", "buffer", "ripgrep" },
              providers = {
                lsp = {
                  name = "LSP",
                  module = "blink.cmp.sources.lsp",
                  score_offset = 1000, -- High priority for LSP
                },
                snippets = {
                  score_offset = 800,
                  },
                buffer = {
                  score_offset = 500, -- Lower than LSP
                },
                ripgrep = {
                  module = "blink-ripgrep",
                  name = "Ripgrep",
                  score_offset = 100, -- Lowest
                  opts = {
                    prefix_min_len = 3,
                    context_size = 5,
                    max_filesize = "1M",
                    project_root_marker = ".git",
                    project_root_fallback = true,
                    search_casing = "--ignore-case",
                  },
                },
              },
            },
            completion = {
              list = { selection = { preselect = true } },
              menu = { border = "single" },
              documentation = {
                auto_show = false,
                auto_show_delay_ms = 0,
              },
            },
            snippets = { preset = "luasnip" },
            keymap = {
              preset = 'default',
              ['<Tab>'] = { 'accept', 'fallback' },
            },
          })
        '';
    };
}
