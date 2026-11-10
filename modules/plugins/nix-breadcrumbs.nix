{
  neovim.mods =
    { lib, ... }:
    {
      extraConfigLuaPre = # lua
        ''
          do
            -- nixd's ranges miss dotted attrpaths; use treesitter instead.
            local function first_field(node, name)
              local field = node:field(name)
              if type(field) == 'table' then
                return field[1]
              end
              return field
            end

            local function nix_context(buf, row, col)
              local ok, parser = pcall(vim.treesitter.get_parser, buf, 'nix')
              if not ok then
                return ""
              end

              local tree = parser:parse()[1]
              if not tree then
                return ""
              end

              local node = tree:root():named_descendant_for_range(row, col, row, col)
              local parts = {}

              while node do
                if node:type() == 'binding' then
                  local attrpath = first_field(node, 'attrpath')
                  if attrpath then
                    local names = {}
                    for child in attrpath:iter_children() do
                      if child:named() then
                        names[#names + 1] = vim.treesitter.get_node_text(child, buf)
                      end
                    end

                    for i = #names, 1, -1 do
                      table.insert(parts, 1, names[i])
                    end
                  end
                end

                node = node:parent()
              end

              if #parts == 0 then
                return ""
              end
              if #parts == 1 then
                return parts[1]
              end

              return table.concat(parts, '.', 1, #parts - 1) .. ' > ' .. parts[#parts]
            end

            local cache = { key = nil, value = "" }

            _G.NixBreadcrumbs = function()
              local buf = vim.api.nvim_get_current_buf()
              if vim.bo[buf].filetype ~= 'nix' then
                return ""
              end

              local pos = vim.api.nvim_win_get_cursor(0)
              local key = table.concat({ buf, vim.b[buf].changedtick, pos[1], pos[2] }, ':')
              if cache.key == key then
                return cache.value
              end

              cache.key = key
              cache.value = nix_context(buf, pos[1] - 1, pos[2])
              return cache.value
            end

          end
        '';
      plugins.lualine.settings.sections.lualine_c = lib.mkAfter [
        {
          __unkeyed-1 =
            lib.nixvim.mkRaw # lua
              ''
                function()
                  local breadcrumbs = _G.NixBreadcrumbs and _G.NixBreadcrumbs() or ""
                  return (breadcrumbs:gsub("%%", "%%%%"))
                end
              '';
          cond =
            lib.nixvim.mkRaw # lua
              ''
                function()
                  return _G.NixBreadcrumbs ~= nil
                    and vim.bo.filetype == "nix"
                    and _G.NixBreadcrumbs() ~= ""
                end
              '';
        }
      ];
    };
}
