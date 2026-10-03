{
  neovim.visual =
    {
      pkgs,
      config,
      mkRaw,
      ...
    }:
    let
      chafa = "${pkgs.chafa}/bin/chafa";
      retro-image = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/onelocked/images/refs/heads/main/neovim/retro.jpg";
        sha256 = "sha256-c9xwiFTicLGnIlUwE5xaHXGr15QK96uWQWCiOIR82as=";
      };
    in
    {
      plugins.snacks.settings.dashboard = {
        enabled = true;
        sections =
          # lua
          mkRaw ''
            {
              {
                section = "terminal",
                cmd = "${chafa} ${
                  if config.nito.theme == "dark" then ./aemeath.jpg else retro-image
                } --format symbols --symbols vhalf --size 60x17; sleep .1",
                padding = 2,
              },
              { icon = " ", key = "ff", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
              { icon = " ", key = "f/", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
              {
                icon = " ",
                desc = "Browse Repo",
                key = "b",
                action = function()
                  Snacks.gitbrowse()
                end,
              },
              { icon = " ", key = "q", desc = "Quit", padding = 2, action = ":qa" },

            { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 2 },
              function()
                local in_git = Snacks.git.get_root() ~= nil
                local cmds = {
                  {
                    icon = " ",
                    title = "Git Status",
                    cmd = "git --no-pager diff --stat -B -M -C",
                    height = 7,
                  },
                  {
                    title = "Open Issues",
                    cmd = "PAGER= gh issue list -L 3",
                    key = "i",
                    action = function()
                      vim.fn.jobstart("gh issue list --web", { detach = true })
                    end,
                    icon = " ",
                    height = 7,
                  },
                  {
                    icon = " ",
                    title = "Open PRs",
                    cmd = "PAGER= gh pr list -L 3",
                    key = "P",
                    action = function()
                      vim.fn.jobstart("gh pr list --web", { detach = true })
                    end,
                    height = 7,
                  },
                }
                return vim.tbl_map(function(cmd)
                  return vim.tbl_extend("force", {
                    section = "terminal",
                    enabled = in_git,
                    padding = 1,
                    ttl = 5 * 60,
                    indent = 3,
                  }, cmd)
                end, cmds)
              end,
            }
          '';
      };
    };
}
