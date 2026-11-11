{
  neovim.mods =
    { mkRaw, ... }:
    {
      keymaps = [
        {
          mode = "n";
          key = "<leader>li";
          action = mkRaw "function() require('tiny-inline-diagnostic').toggle() end";
          options = {
            desc = "Toggle inline diagnostics";
            silent = true;
            noremap = true;
          };
        }
      ];

      plugins.tiny-inline-diagnostic = {
        enable = true;
        settings = {
          signs.diag = "";
          options = {
            # set_arrow_to_diag_color = true;
            # use_icons_from_diagnostic = true;
            multilines = {
              enabled = true;
              always_show = true;
              # Only pin errors to every line of a multiline diagnostic.
              # Warnings/info/hints only show on the cursor line.
              severity = [ (mkRaw "vim.diagnostic.severity.ERROR") ];
            };
            format = mkRaw /* lua */ ''
              function(diagnostic)
                local icons = {
                  [vim.diagnostic.severity.ERROR] = '󰅚',
                  [vim.diagnostic.severity.WARN] = '⚠',
                  [vim.diagnostic.severity.INFO] = 'ⓘ',
                  [vim.diagnostic.severity.HINT] = '󰌶',
                }
                local message = diagnostic.message

                -- Show the source when it disambiguates between multiple LSPs,
                -- and always for nix so you can tell nixd/nixf diagnostics apart.
                local function should_show_source()
                  if vim.bo.filetype == 'nix' then
                    return true
                  end
                  local seen, count = {}, 0
                  for _, d in ipairs(vim.diagnostic.get(0, { lnum = diagnostic.lnum })) do
                    if d.source and not seen[d.source] then
                      seen[d.source] = true
                      count = count + 1
                    end
                  end
                  return count > 1
                end

                -- nixd/nixf diagnostics also carry a useful code. Show it only
                -- for nix, and shorten the noisy `sema-`/`parse-` prefix.
                if vim.bo.filetype == 'nix' then
                  local code = diagnostic.code and tostring(diagnostic.code) or nil
                  if code then
                    code = code:gsub('^%a+%-', "")
                  end
                  if code and #code > 0 and #code <= 24 then
                    message = string.format('%s [%s]', message, code)
                  end
                end

                if diagnostic.source and should_show_source() then
                  message = string.format('%s (%s)', message, diagnostic.source)
                end

                local icon = icons[diagnostic.severity] or '■'
                return string.format('%s %s', icon, message)
              end
            '';

          };
        };
      };
    };
}
