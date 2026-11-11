{
  neovim.mods = { lib, mkRaw, ... }: {
    plugins.snacks.settings =
      let
        inherit (lib.nixvim) listToUnkeyedAttrs;
      in
      {
        picker =
          let
            keys = {
              "<c-d>" = (listToUnkeyedAttrs [ "preview_scroll_down" ]) // {
                mode = "n";
              };
              "<c-u>" = (listToUnkeyedAttrs [ "preview_scroll_up" ]) // {
                mode = "n";
              };
            };
          in
          {
            enabled = true;
            win = {
              input.keys = keys;
              list.keys = keys;
            };
            layouts = {
              sexy.layout = (
                listToUnkeyedAttrs [
                  {
                    win = "input";
                    height = 1;
                    border = "single";
                    title = "{title} {live} {flags}";
                    title_pos = "center";
                  }
                  (
                    listToUnkeyedAttrs [
                      {
                        win = "list";
                        border = [
                          "🭽"
                          "▔"
                          "🭾"
                          "▕"
                          "🭿"
                          "▁"
                          "🭼"
                          "▏"
                        ];
                      }
                      {
                        win = "preview";
                        border = [
                          "🭽"
                          "▔"
                          "🭾"
                          "▕"
                          "🭿"
                          "▁"
                          "🭼"
                          "▏"
                        ];
                        width = 0.6;
                      }
                    ]
                    // {
                      box = "horizontal";
                    }
                  )
                ]
                // {
                  box = "vertical";
                  width = 0.9;
                  height = 0.9;
                  border = "none";
                }
              );
            };
            sources.explorer = {
              actions.toggle_preview = mkRaw ''
                function(picker)
                  picker.preview.win:toggle()
                end
              '';
              layout.layout = (
                listToUnkeyedAttrs [
                  {
                    win = "input";
                    height = 1;
                    border = "single";
                    title = "{title} {live} {flags}";
                    title_pos = "center";
                  }
                  {
                    win = "list";
                    border = "none";
                  }
                ]
                // {
                  backdrop = false;
                  width = 40;
                  min_width = 40;
                  height = 0;
                  position = "left";
                  border = "single";
                  box = "vertical";
                }
              );
              on_show = mkRaw ''
                function(picker)
                  local show = false
                  local gap = 1
                  local min_width, max_width = 20, 100
                  --
                  local rel = picker.layout.root
                  local update = function(win) ---@param win snacks.win
                    win.opts.row = vim.api.nvim_win_get_position(rel.win)[1]
                    win.opts.col = vim.api.nvim_win_get_width(rel.win) + gap
                    win.opts.height = 0.8
                    local border = win:border_size().left + win:border_size().right
                    win.opts.width = math.max(min_width, math.min(max_width, vim.o.columns - border - win.opts.col))
                    win:update()
                  end
                  local preview_win = Snacks.win.new {
                    relative = 'editor',
                    external = false,
                    focusable = false,
                    border = 'single',
                    backdrop = false,
                    show = show,
                    bo = {
                      filetype = 'snacks_float_preview',
                      buftype = 'nofile',
                      buflisted = false,
                      swapfile = false,
                      undofile = false,
                    },
                    on_win = function(win)
                      update(win)
                      picker:show_preview()
                    end,
                  }
                  rel:on('WinResized', function()
                    update(preview_win)
                  end)
                  picker.preview.win = preview_win
                  picker.main = preview_win.win
                end
              '';
              on_close =
                # lua
                mkRaw ''
                  function(picker)
                    picker.preview.win:close()
                  end
                '';
            };
            layout.preset = "sexy";
          };
      };
    keymaps = [
      {
        mode = "n";
        key = "<leader>ff";
        action = (
          mkRaw ''
            function()
              local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
              local cwd = (git_root and vim.v.shell_error == 0) and git_root or vim.fn.getcwd()
              Snacks.picker.files({ cwd = cwd })
            end
          ''
        );
        options = {
          desc = "Find Files";
          silent = true;
          noremap = true;
        };
      }
      {
        mode = "n";
        key = "<leader>f/";
        action = (
          mkRaw ''
            function()
              local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
              local cwd = (git_root and vim.v.shell_error == 0) and git_root or vim.fn.getcwd()
              Snacks.picker.grep({ cwd = cwd })
            end
          ''
        );
        options = {
          desc = "Grep";
          silent = true;
          noremap = true;
        };
      }
    ];
  };
}
