{
  neovim.visual =
    { pkgs, ... }:
    {
      extraPlugins = with pkgs.vimPlugins; [
        neoscroll-nvim
      ];

      extraConfigLua = # lua
        ''
          require('neoscroll').setup({
            mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
            hide_cursor = true,
            stop_eof = false,
            respect_scrolloff = false,
            cursor_scrolls_alone = true,
            easing_function = "linear",
            post_hook = function()
              if vim.w.neoscroll_saved_scrolloff then
                vim.wo.scrolloff = vim.w.neoscroll_saved_scrolloff
                vim.w.neoscroll_saved_scrolloff = nil
              end
            end,
          })

          local function eof_overscrolled()
            local height = vim.api.nvim_win_get_height(0)
            local last = vim.fn.line('$')
            return vim.fn.winsaveview().topline > last - height + 1
          end

          local function move_vertical(key)
            local count = vim.v.count1
            if not eof_overscrolled() then
              vim.cmd('normal! ' .. count .. key)
              return
            end

            local row = vim.fn.winline()
            local scrolloff = vim.wo.scrolloff
            vim.wo.scrolloff = 0
            vim.cmd('normal! ' .. count .. key)
            local new_row = vim.fn.winline()
            if new_row < row then
              vim.cmd('normal! ' .. (row - new_row) .. '\25')
            elseif new_row > row then
              vim.cmd('normal! ' .. (new_row - row) .. '\5')
            end
            vim.wo.scrolloff = scrolloff
          end

          vim.keymap.set('n', 'k', function() move_vertical('k') end, { desc = 'Move up, keeping EOF overscroll' })
          vim.keymap.set('n', 'j', function() move_vertical('j') end, { desc = 'Move down, keeping EOF overscroll' })
          vim.keymap.set('n', '<Up>', function() move_vertical('k') end, { desc = 'Move up, keeping EOF overscroll' })
          vim.keymap.set('n', '<Down>', function() move_vertical('j') end, { desc = 'Move down, keeping EOF overscroll' })

          local function scroll_up(scroll_fn)
            if not eof_overscrolled() then
              scroll_fn()
              return
            end
            vim.w.neoscroll_saved_scrolloff = vim.w.neoscroll_saved_scrolloff or vim.wo.scrolloff
            vim.wo.scrolloff = 0
            scroll_fn()
          end

          vim.keymap.set({ 'n', 'x' }, '<C-u>', function()
            scroll_up(function() require('neoscroll').ctrl_u({ duration = 250 }) end)
          end)
          vim.keymap.set({ 'n', 'x' }, '<C-b>', function()
            scroll_up(function() require('neoscroll').ctrl_b({ duration = 450 }) end)
          end)
        '';
    };
}
