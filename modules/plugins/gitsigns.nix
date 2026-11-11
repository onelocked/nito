{
  neovim.mods =
    { mkRaw, ... }:
    {
      plugins.gitsigns = {
        enable = true;
        settings = {
          current_line_blame = true;
          current_line_blame_opts = {
            delay = 300;
            virt_text_pos = "eol";
            ignore_whitespace = false;
          };
          current_line_blame_formatter = "<author>, <author_time:%R> • <summary>";
          attach_to_untracked = true; # show signs in new files too
          signs_staged_enable = true; # different signs for staged vs unstaged

          word_diff = false;
          signs = {
            add.text = "▏";
            change.text = "▏";
            delete.text = "▏";
            topdelete.text = "󰐊";
            changedelete.text = "▎";
          };
          preview_config = {
            border = "single";
            style = "minimal";
            relative = "cursor";
            row = 0;
            col = 1;
          };
        };
      };

      keymaps = [
        {
          mode = "n";
          key = "<leader>gk";
          action = (mkRaw "function() require('gitsigns').blame_line({ full = true }) end");
          options = {
            desc = "Blame Line (Full)";
            silent = true;
            noremap = true;
          };
        }
        {
          mode = "n";
          key = "<leader>gf";
          action = (
            mkRaw "function() require('gitsigns').toggle_linehl(); require('gitsigns').toggle_deleted() end"
          );
          options = {
            desc = "Toggle Inline Diff";
            silent = true;
            noremap = true;
          };
        }
      ];
    };
}
