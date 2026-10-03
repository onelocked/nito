{
  neovim.mods =
    { config, ... }:
    {
      plugins.bufferline = {
        enable = true;
        settings = {
          options = {
            diagnostics = "nvim_lsp";
            always_show_bufferline = false;
            themable = false;
          };
          highlights = {
            fill = {
              bg = "NONE";
            };
            background = {
              bg = "NONE";
            };
            buffer_visible = {
              bg = "NONE";
            };
            buffer_selected = {
              bg = "NONE";
              bold = true;
            };
            close_button = {
              bg = "NONE";
            };
            close_button_visible = {
              bg = "NONE";
            };
            close_button_selected = {
              bg = "NONE";
            };
            separator = {
              bg = "NONE";
            };
            separator_visible = {
              bg = "NONE";
            };
            separator_selected = {
              bg = "NONE";
            };
            indicator_selected = {
              bg = "NONE";
              fg = config.nito.${config.nito.theme}.base08;
            };
            indicator_visible = {
              bg = "NONE";
            };
            modified = {
              bg = "NONE";
            };
            modified_visible = {
              bg = "NONE";
            };
            modified_selected = {
              bg = "NONE";
            };
            duplicate = {
              bg = "NONE";
            };
            duplicate_visible = {
              bg = "NONE";
            };
            duplicate_selected = {
              bg = "NONE";
            };
          };
        };
      };

      keymaps = [
        {
          mode = "n";
          key = "<leader>bp";
          action = "<cmd>:BufferLinePick<cr>";
          options = {
            desc = "Buffer Line Pick";
            silent = true;
            noremap = true;
          };
        }
        {
          mode = "n";
          key = "<leader>qc";
          action = "<cmd>:bp | bd #<cr>";
          options = {
            desc = "Buffer close";
            silent = true;
            noremap = true;
          };
        }
        {
          mode = "n";
          key = "<leader>bc";
          action = "<cmd>BufferLineCloseOther<cr>";
          options = {
            desc = "Buffer close all except the current buffer";
            silent = true;
            noremap = true;
          };
        }
        {
          mode = "n";
          key = "<s-Left>";
          action = ":BufferLineCyclePrev<cr>";
          options = {
            desc = "Buffer Previous";
            silent = true;
            noremap = true;
          };
        }
        {
          mode = "n";
          key = "<s-Right>";
          action = ":BufferLineCycleNext<cr>";
          options = {
            desc = "Buffer Next";
            silent = true;
            noremap = true;
          };
        }
      ];
    };
}
