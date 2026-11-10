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

            local function node_contains(node, row, col)
              local start_row, start_col, end_row, end_col = node:range()
              return (row > start_row or (row == start_row and col >= start_col))
                and (row < end_row or (row == end_row and col <= end_col))
            end

            local function callee_name(node, buf)
              while node do
                local kind = node:type()
                if kind == 'apply_expression' then
                  node = first_field(node, 'function')
                elseif kind == 'parenthesized_expression' then
                  node = first_field(node, 'expression')
                elseif kind == 'variable_expression' or kind == 'select_expression' then
                  return vim.treesitter.get_node_text(node, buf)
                else
                  return nil
                end
              end
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
              local segments = {}

              while node do
                local kind = node:type()

                if kind == 'binding' then
                  local attrpath = first_field(node, 'attrpath')
                  if attrpath then
                    local names = {}
                    for child in attrpath:iter_children() do
                      if child:named() then
                        names[#names + 1] = vim.treesitter.get_node_text(child, buf)
                      end
                    end

                    if #names > 0 then
                      table.insert(segments, 1, {
                        kind = 'attr',
                        text = table.concat(names, '.'),
                      })
                    end
                  end
                elseif kind == 'apply_expression' then
                  local arg = first_field(node, 'argument')
                  if arg and node_contains(arg, row, col) then
                    local fn = first_field(node, 'function')
                    local name = fn and callee_name(fn, buf)
                    if name then
                      table.insert(segments, 1, { kind = 'call', text = name })
                    end
                  end
                end

                node = node:parent()
              end

              if #segments == 0 then
                return ""
              end
              if #segments == 1 then
                return segments[1].text
              end

              local out = segments[1].text
              for i = 2, #segments - 1 do
                local previous = segments[i - 1]
                local segment = segments[i]
                if segment.kind == 'attr' and previous.kind == 'attr' then
                  out = out .. '.' .. segment.text
                else
                  out = out .. ' > ' .. segment.text
                end
              end

              return out .. ' > ' .. segments[#segments].text
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
