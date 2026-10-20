{
  neovim.mods =
    { pkgs, mkRaw, ... }:
    {
      extraPlugins = with pkgs.vimPlugins; [ diffview-plus-nvim ];

      extraConfigLua = # lua
        ''
          -- split dissimilar lines into proper delete + add instead of "change"
          vim.opt.diffopt:append('linematch:60')

          -- red for old side, green for new side (tweak to match your theme)
          vim.api.nvim_set_hl(0, 'DiffviewOldLine', { bg = '#3b1f2b' })
          vim.api.nvim_set_hl(0, 'DiffviewOldText', { bg = '#6e2a3c' })
          vim.api.nvim_set_hl(0, 'DiffviewNewLine', { bg = '#1f3b2b' })
          vim.api.nvim_set_hl(0, 'DiffviewNewText', { bg = '#2a6e3c' })

          require('diffview').setup({
            enhanced_diff_hl = true,
            use_icons = true,
            view = {
              default = { layout = 'diff2_horizontal' },
              merge_tool = { layout = 'diff3_horizontal' },
            },
            file_panel = {
              listing_style = 'tree',
              win_config = { position = 'left', width = 35 },
            },
            hooks = {
              -- attach treesitter so diff buffers keep syntax highlighting
              diff_buf_read = function(bufnr)
                pcall(vim.treesitter.start, bufnr)
              end,

              -- old side = red, new side = green, even for "changed" lines
              diff_buf_win_enter = function(bufnr, winid, ctx)
                if not ctx.layout_name:match('^diff2') then return end
                if ctx.symbol == 'a' then -- old / left
                  vim.wo[winid].winhl = table.concat({
                    'DiffAdd:DiffviewDiffAddAsDelete',
                    'DiffDelete:DiffviewDiffDeleteDim',
                    'DiffChange:DiffviewOldLine',
                    'DiffText:DiffviewOldText',
                  }, ',')
                elseif ctx.symbol == 'b' then -- new / right
                  vim.wo[winid].winhl = table.concat({
                    'DiffChange:DiffviewNewLine',
                    'DiffText:DiffviewNewText',
                  }, ',')
                end
              end,
            },
          })
        '';

      keymaps = [
        {
          mode = "n";
          key = "<leader>gd";
          action = (
            mkRaw ''
              function()
                local lib = require('diffview.lib')
                if lib.get_current_view() then
                  vim.cmd('DiffviewClose')
                  -- if only a panel closed and the view is still there, close its tab
                  if lib.get_current_view() then
                    pcall(vim.cmd, 'tabclose')
                  end
                else
                  vim.cmd('DiffviewOpen')
                end
              end
            ''
          );
          options = {
            desc = "Diffview Toggle";
            silent = true;
            noremap = true;
          };
        }
        {
          mode = "n";
          key = "<leader>gD";
          action = ":DiffviewClose<CR>";
          options = {
            desc = "Diffview Close";
            silent = true;
            noremap = true;
          };
        }
        {
          mode = "n";
          key = "<leader>gh";
          action = ":DiffviewFileHistory %<CR>";
          options = {
            desc = "Diffview File History (current file)";
            silent = true;
            noremap = true;
          };
        }
      ];
    };
}
