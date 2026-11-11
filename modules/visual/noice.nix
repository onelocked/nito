{
  neovim.visual = {
    plugins = {
      noice = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";
        settings = {
          presets.bottom_search = true;
          notify.enabled = false;
          views = {
            cmdline_popup = {
              border.style = "single";
              position = {
                row = -2;
                col = "50%";
              };
            };
            cmdline_popupmenu.position = {
              row = -5;
              col = "50%";
            };
            popupmenu.border.style = "single";
            cmdline_input.border.style = "single";
            confirm.border.style = "single";
          };
          lsp = {
            override = {
              "vim.lsp.util.convert_input_to_markdown_lines" = true;
              "vim.lsp.util.stylize_markdown" = true;
              "cmp.entry.get_documentation" = true;
            };
            hover.enabled = false;
            message.enabled = false;
            signature.enabled = false;
            progress = {
              enabled = false;
              view = "mini";
            };
          };
        };
      };
    };
  };
}
