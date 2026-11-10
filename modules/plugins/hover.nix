{
  neovim.mods =
    { pkgs, ... }:
    {
      extraPlugins = [ pkgs.vimPlugins.hover-nvim ];

      extraConfigLua = /* lua */ ''
        require('hover').config({
          providers = {
            'hover.providers.diagnostic',
            'hover.providers.lsp',
            'hover.providers.dap',
            'hover.providers.man',
            'hover.providers.dictionary',
            -- Optional, disabled by default:
            'hover.providers.gh',
            'hover.providers.gh_user',
            -- 'hover.providers.fold_preview',
            -- 'hover.providers.highlight',
          },
        })

        -- nixd sometimes leaves 4+ spaces of indentation in docs, which
        -- Markdown renders as a code block (raw fences); dedent before display.
        do
          local util = require('hover.util')
          local open_floating_preview = util.open_floating_preview

          util.open_floating_preview = function(contents, bufnr, syntax, opts)
            if contents and syntax == 'markdown' then
              local base
              for _, line in ipairs(contents) do
                if line:match('%S') then
                  base = #(line:match('^%s*'))
                  break
                end
              end

              if base and base >= 4 then
                local dedented = {}
                for i, line in ipairs(contents) do
                  if line:match('^%s*$') then
                    dedented[i] = ""
                  else
                    local indent = #(line:match('^%s*'))
                    dedented[i] = line:sub(math.min(base, indent) + 1)
                  end
                end
                contents = dedented
              end
            end

            return open_floating_preview(contents, bufnr, syntax, opts)
          end
        end

        -- Setup keymaps
        vim.keymap.set('n', 'K', function()
          require('hover').open()
        end, { desc = 'hover.nvim (open)' })

        vim.keymap.set('n', 'gK', function()
          require('hover').enter()
        end, { desc = 'hover.nvim (enter)' })

        vim.keymap.set('n', '<C-j>', function()
            require('hover').switch('previous')
        end, { desc = 'hover.nvim (previous source)' })

        vim.keymap.set('n', '<C-l>', function()
            require('hover').switch('next')
        end, { desc = 'hover.nvim (next source)' })

      '';
    };
}
