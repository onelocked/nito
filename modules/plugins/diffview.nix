{
  neovim.mods =
    { pkgs, mkRaw, ... }:
    {
      extraPlugins = with pkgs.vimPlugins; [ diffview-plus-nvim ];

      extraConfigLua = # lua
        ''
          -- split dissimilar lines into proper delete + add instead of "change"
          vim.opt.diffopt:append('linematch:60')

          ----------------------------------------------------------------
          -- Diffview palette: deep tinted backgrounds, NO fg / bold so
          -- syntax highlighting stays fully readable on top.
          ----------------------------------------------------------------
          local function diffview_hl()
            local set = vim.api.nvim_set_hl

            set(0, 'DiffviewOldLine', { bg = '#2D0000' }) -- deep red
            set(0, 'DiffviewOldText', { bg = '#5C0A0A' }) -- lighter red for changed words
            set(0, 'DiffviewNewLine', { bg = '#00230C' }) -- deep green
            set(0, 'DiffviewNewText', { bg = '#06471F' }) -- lighter green for changed words

            -- filler lines (the empty space opposite an add/delete)
            set(0, 'DiffviewFiller', { fg = '#2a2a33', bg = '#16161a' })
          end

          diffview_hl()
          vim.api.nvim_create_autocmd('ColorScheme', { callback = diffview_hl })

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
                    'DiffAdd:DiffviewOldLine',
                    'DiffDelete:DiffviewFiller',
                    'DiffChange:DiffviewOldLine',
                    'DiffText:DiffviewOldText',
                  }, ',')
                elseif ctx.symbol == 'b' then -- new / right
                  vim.wo[winid].winhl = table.concat({
                    'DiffAdd:DiffviewNewLine',
                    'DiffDelete:DiffviewFiller',
                    'DiffChange:DiffviewNewLine',
                    'DiffText:DiffviewNewText',
                  }, ',')
                end
              end,

              -- start with the file panel closed (toggle it back with your panel key)
              view_opened = function(view)
                -- only for regular diff views, leave the file history log panel alone
                local ok, DiffView = pcall(function()
                  return require('diffview.scene.views.diff.diff_view').DiffView
                end)
                if not (ok and view:instanceof(DiffView)) then return end

                vim.schedule(function()
                  pcall(function() view.panel:close() end)
                end)
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
