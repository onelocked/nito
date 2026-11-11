{
  neovim.mods = { mkRaw, ... }: {
    plugins.snacks.settings = {
      notifier = {
        enabled = true;
        style = "compact";
        top_down = false;
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>un";
        action = "<cmd>lua Snacks.notifier.show_history()<cr>";
        options = {
          desc = "Notification History";
          silent = true;
          noremap = true;
        };
      }
    ];
    autoCmd = [
      {
        desc = "Show LSP progress in the Snacks notifier";
        event = [ "LspProgress" ];
        callback = mkRaw ''
          (function()
            local progress = vim.defaulttable()
            return function(ev)
              local client = vim.lsp.get_client_by_id(ev.data.client_id)
              local value = ev.data.params.value
              if not client or type(value) ~= "table" then
                return
              end

              local p = progress[client.id]
              for i = 1, #p + 1 do
                if i == #p + 1 or p[i].token == ev.data.params.token then
                  p[i] = {
                    token = ev.data.params.token,
                    msg = ("[%3d%%] %s%s"):format(
                      value.kind == "end" and 100 or value.percentage or 100,
                      value.title or "",
                      value.message and (" **%s**"):format(value.message) or ""
                    ),
                    done = value.kind == "end",
                  }
                  break
                end
              end

              local msg = {}
              progress[client.id] = vim.tbl_filter(function(v)
                return table.insert(msg, v.msg) or not v.done
              end, p)

              local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
              vim.notify(table.concat(msg, "\n"), "info", {
                id = "lsp_progress_" .. client.id,
                title = client.name,
                opts = function(notif)
                  notif.icon = #progress[client.id] == 0 and "✓ "
                    or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
                end,
              })
            end
          end)()
        '';
      }
      {
        desc = "Pre init Function";
        event = [ "VimEnter" ];
        callback = mkRaw ''
          function()
            _G.dd = function(...)
              Snacks.debug.inspect(...)
            end
            _G.bt = function()
              Snacks.debug.backtrace()
            end
            vim.print = _G.dd

            Snacks.toggle.diagnostics():map("<leader>ud")
            Snacks.toggle.line_number():map("<leader>ul")
            Snacks.toggle.inlay_hints():map("<leader>uh")
            Snacks.toggle.treesitter():map("<leader>uT")
            Snacks.toggle.option("spell",
              { name = "Spelling" }):map("<leader>us")
            Snacks.toggle.option("wrap",
              { name = "Wrap" }):map("<leader>uw")
            Snacks.toggle.option("relativenumber",
              { name = "Relative Number" }):map("<leader>uL")
            Snacks.toggle.option("conceallevel",
              { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
            Snacks.toggle.option("background",
              { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          end
        '';
      }
    ];
  };
}
