{
  neovim.visual =
    { pkgs, ... }:
    {
      extraPlugins = with pkgs.vimPlugins; [ neoscroll-nvim ];

      extraConfigLua = # lua
        ''
          -- Tracks whether neoscroll's fake EOF overscroll is active per window.
          local eof_state = {}

          local function eof_overscrolled()
            local height = vim.api.nvim_win_get_height(0)
            local last = vim.fn.line('$')
            local max_topline = math.max(1, last - height + 1)
            return vim.fn.winsaveview().topline > max_topline
          end

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
              eof_state[vim.api.nvim_get_current_win()] = eof_overscrolled()
            end,
          })

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

          vim.keymap.set({ 'n', 'x' }, 'k', function() move_vertical('k') end, { desc = 'Move up, keeping EOF overscroll' })
          vim.keymap.set({ 'n', 'x' }, 'j', function() move_vertical('j') end, { desc = 'Move down, keeping EOF overscroll' })
          vim.keymap.set({ 'n', 'x' }, '<Up>', function() move_vertical('k') end, { desc = 'Move up, keeping EOF overscroll' })
          vim.keymap.set({ 'n', 'x' }, '<Down>', function() move_vertical('j') end, { desc = 'Move down, keeping EOF overscroll' })

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

          -- Re-center after motions that clamp the EOF overscroll.
          local function recenter()
            local win = vim.api.nvim_get_current_win()
            local height = vim.api.nvim_win_get_height(win)
            local scrolloff = vim.wo.scrolloff
            local target_row
            if scrolloff >= math.floor(height / 2) then
              target_row = math.floor((height + 1) / 2)
            else
              target_row = height - scrolloff
            end
            local row = vim.fn.winline()
            if row > target_row then
              -- <C-e> scrolls past EOF without being clamped.
              vim.cmd('normal! ' .. (row - target_row) .. '\5')
            end
            eof_state[win] = eof_overscrolled()
          end

          vim.api.nvim_create_autocmd('CursorMoved', {
            callback = function()
              local win = vim.api.nvim_get_current_win()
              local was_overscrolled = eof_state[win]
              if eof_overscrolled() then
                eof_state[win] = true
              elseif was_overscrolled then
                eof_state[win] = false
                recenter()
              else
                eof_state[win] = false
              end
            end,
          })
        '';
    };
}
