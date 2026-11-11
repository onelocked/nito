{
  neovim.core = { lib, ... }: {
    extraConfigLua = # lua
      ''
         -- windows
        vim.o.winwidth = 10
        vim.o.winminwidth = 10
      '';
    autoCmd = [
      {
        event = [ "VimResized" ];
        desc = "Equalize split widths on editor resize, preserving heights";
        callback =
          lib.nixvim.mkRaw # lua
            ''
              function()
                local current_tab = vim.api.nvim_get_current_tabpage()
                local winfixheight = {}

                -- Temporarily pin heights so `wincmd =` only distributes width.
                -- Windows that already set 'winfixheight' (quickfix, help, ...)
                -- get their original value restored afterwards.
                for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
                  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
                    if vim.api.nvim_win_get_config(win).relative == "" then
                      winfixheight[win] =
                        vim.api.nvim_get_option_value("winfixheight", { win = win })
                      vim.api.nvim_set_option_value("winfixheight", true, { win = win })
                    end
                  end
                end

                vim.cmd("tabdo wincmd =")

                for win, value in pairs(winfixheight) do
                  if vim.api.nvim_win_is_valid(win) then
                    vim.api.nvim_set_option_value("winfixheight", value, { win = win })
                  end
                end

                -- :tabdo leaves the last tab active.
                if vim.api.nvim_get_current_tabpage() ~= current_tab then
                  vim.api.nvim_set_current_tabpage(current_tab)
                end
              end
            '';
      }
    ];
  };
}
