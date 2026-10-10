{
  neovim.mods = {
    extraConfigLua = # lua
      ''
        local function send_to_agy(include_snippet)
            vim.cmd('noau normal! "vy"')
            local code = vim.fn.getreg('v')

            local filepath = vim.fn.expand('%:p')
            if filepath == "" then filepath = "Untitled" end
            local mode = vim.fn.visualmode()
            local from = vim.api.nvim_buf_get_mark(0, "<")
            local to = vim.api.nvim_buf_get_mark(0, ">")

            if from[1] > to[1] or (from[1] == to[1] and from[2] > to[2]) then
                from, to = to, from
            end

            local loc_str = ""
            if mode == "V" then
                loc_str = string.format(":L%d", from[1])
                if to[1] ~= from[1] then
                    loc_str = loc_str .. string.format("-L%d", to[1])
                end
            else
                if from[1] == to[1] and from[2] ~= to[2] then
                    loc_str = string.format(":L%d:C%d-C%d", from[1], from[2] + 1, to[2] + 1)
                elseif from[1] ~= to[1] then
                    loc_str = string.format(":L%d:C%d-L%d:C%d", from[1], from[2] + 1, to[1], to[2] + 1)
                else
                    loc_str = string.format(":L%d:C%d", from[1], from[2] + 1)
                end
            end

            vim.ui.input({ prompt = "Ask ❯ " }, function(user_input)
                if not user_input or user_input == "" then return end

                local payload = ""
                if include_snippet then
                    payload = string.format(
                        "%s\n\n```\n%s\n```\n",
                        user_input, code
                    )
                else
                    payload = string.format(
                        "@%s %s %s",
                        filepath, loc_str, user_input
                    )
                end

                vim.fn.system({'kitten', '@', 'send-text', '--match', 'title:agy', '--bracketed-paste=auto', '--stdin'}, payload)
                vim.fn.system({'kitten', '@', 'send-text', '--match', 'title:agy', '\r'})

                vim.notify("Sent to Antigravity window!", vim.log.levels.INFO)
            end)
        end

        vim.keymap.set("v", "<leader>aa", function() send_to_agy(false) end, { desc = "Send file context" })
        vim.keymap.set("v", "<leader>as", function() send_to_agy(true) end, { desc = "Send snippet" })
      '';
  };
}
