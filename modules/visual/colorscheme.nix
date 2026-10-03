{
  neovim.visual =
    { lib, config, ... }:
    let
      c = config.nito.${config.nito.theme};
    in
    {
      config = {
        extraConfigLua = ''
          vim.cmd("highlight clear")
          if vim.fn.exists("syntax_on") == 1 then vim.cmd("syntax reset") end
          vim.g.colors_name = "mytheme"
          vim.opt.termguicolors = true

          local c = {
            bg                   = "${c.base00}",
            fg                   = "${c.base05}",
            cursor_line          = "${c.base01}",
            line_nr              = "${c.base03}",
            line_nr_active       = "${c.base04}",
            selection            = "${c.base02}",
            border               = "${c.base01}",
            tabline_bg           = "${c.base01}",
            tabline_fg           = "${c.base04}",
            tabline_active_bg    = "${c.base00}",
            tabline_active_fg    = "${c.base05}",
            sl_bg                = "${c.base01}",
            sl_fg                = "${c.base05}",
            sl_mode_n            = "${c.base0F}",
            sl_mode_i            = "${c.base0B}",
            sl_mode_v            = "${c.base11}",
            sl_mode_c            = "${c.base09}",
            sl_mode_t            = "${c.base14}",
            comment              = "${c.base03}",
            keyword              = "${c.base08}",
            string               = "${c.base0B}",
            fn                   = "${c.base12}",
            type                 = "${c.base14}",
            constant             = "${c.base09}",
            number               = "${c.base16}",
            operator             = "${c.base10}",
            parameter            = "${c.base0E}",
            builtin              = "${c.base0C}",
            special              = "${c.base0F}",
            variable             = "${c.base0D}",
            float_bg             = "${c.base00}",
            float_border         = "${c.base17}",
            pmenu_sel            = "${c.base02}",
            error                = "${c.base08}",
            warning              = "${c.base09}",
            info                 = "${c.base14}",
            hint                 = "${c.base15}",
            dashboard            = "${c.base17}",
          }

          -- ── Editor ───────────────────────────────────────────────────────────────────
          vim.api.nvim_set_hl(0, "Normal",          { fg = c.fg,               bg = "NONE" })
          vim.api.nvim_set_hl(0, "NormalNC",        { fg = c.fg,               bg = "NONE" })
          vim.api.nvim_set_hl(0, "NormalFloat",     { fg = c.fg,               bg = c.float_bg })
          vim.api.nvim_set_hl(0, "FloatBorder",     { fg = c.float_border,     bg = c.float_bg })
          vim.api.nvim_set_hl(0, "FloatTitle",      { fg = c.float_border,     bg = c.float_bg,  bold = true })
          vim.api.nvim_set_hl(0, "CursorLine",      { bg = c.cursor_line })
          vim.api.nvim_set_hl(0, "CursorLineNr",    { fg = c.line_nr_active,   bold = true })
          vim.api.nvim_set_hl(0, "LineNr",          { fg = c.line_nr })
          vim.api.nvim_set_hl(0, "SignColumn",      { fg = c.line_nr,          bg = "NONE" })
          vim.api.nvim_set_hl(0, "FoldColumn",      { fg = c.line_nr,          bg = "NONE" })
          vim.api.nvim_set_hl(0, "Folded",          { fg = c.comment,          bg = c.cursor_line })
          vim.api.nvim_set_hl(0, "Visual",          { bg = c.selection })
          vim.api.nvim_set_hl(0, "Search",          { fg = c.bg,               bg = c.keyword })
          vim.api.nvim_set_hl(0, "IncSearch",       { fg = c.bg,               bg = c.string })
          vim.api.nvim_set_hl(0, "CurSearch",       { fg = c.bg,               bg = c.special })
          vim.api.nvim_set_hl(0, "Substitute",      { fg = c.bg,               bg = c.error })
          vim.api.nvim_set_hl(0, "MatchParen",      { fg = c.special,          bold = true, underline = true })
          vim.api.nvim_set_hl(0, "NonText",         { fg = c.line_nr })
          vim.api.nvim_set_hl(0, "EndOfBuffer",     { fg = "NONE" })
          vim.api.nvim_set_hl(0, "Whitespace",      { fg = c.border })
          vim.api.nvim_set_hl(0, "SpecialKey",      { fg = c.line_nr })
          vim.api.nvim_set_hl(0, "Conceal",         { fg = c.comment })
          vim.api.nvim_set_hl(0, "Directory",       { fg = c.fn })
          vim.api.nvim_set_hl(0, "Title",           { fg = c.keyword,          bold = true })
          vim.api.nvim_set_hl(0, "Question",        { fg = c.string })
          vim.api.nvim_set_hl(0, "MoreMsg",         { fg = c.string })
          vim.api.nvim_set_hl(0, "MsgArea",         { fg = c.fg,               bg = "NONE" })
          vim.api.nvim_set_hl(0, "ErrorMsg",        { fg = c.error })
          vim.api.nvim_set_hl(0, "WarningMsg",      { fg = c.warning })
          vim.api.nvim_set_hl(0, "WildMenu",        { fg = c.fg,               bg = c.selection })

          -- ── Chrome ───────────────────────────────────────────────────────────────────
          vim.api.nvim_set_hl(0, "StatusLine",      { fg = c.sl_fg,            bg = c.sl_bg })
          vim.api.nvim_set_hl(0, "StatusLineNC",    { fg = c.line_nr,          bg = c.sl_bg })
          vim.api.nvim_set_hl(0, "TabLine",         { fg = c.tabline_fg,       bg = "NONE" })
          vim.api.nvim_set_hl(0, "TabLineSel",      { fg = c.tabline_active_fg, bg = c.base02, bold = true })
          vim.api.nvim_set_hl(0, "TabLineFill",     { bg = "NONE" })
          vim.api.nvim_set_hl(0, "WinSeparator",    { fg = c.border })
          vim.api.nvim_set_hl(0, "VertSplit",       { fg = c.border })
          vim.api.nvim_set_hl(0, "Pmenu",           { fg = c.fg,               bg = c.float_bg })
          vim.api.nvim_set_hl(0, "PmenuSel",        { fg = c.fg,               bg = c.pmenu_sel,  bold = true })
          vim.api.nvim_set_hl(0, "PmenuSbar",       { bg = c.float_bg })
          vim.api.nvim_set_hl(0, "PmenuThumb",      { bg = c.line_nr })

          -- ── Diffs ────────────────────────────────────────────────────────────────────
          vim.api.nvim_set_hl(0, "DiffAdd",         { fg = c.string,           bg = "NONE" })
          vim.api.nvim_set_hl(0, "DiffChange",      { fg = c.warning,          bg = "NONE" })
          vim.api.nvim_set_hl(0, "DiffDelete",      { fg = c.error,            bg = "NONE" })
          vim.api.nvim_set_hl(0, "DiffText",        { fg = c.bg,               bg = c.warning })

          -- ── Diagnostics ──────────────────────────────────────────────────────────────
          vim.api.nvim_set_hl(0, "DiagnosticError",              { fg = c.error })
          vim.api.nvim_set_hl(0, "DiagnosticWarn",               { fg = c.warning })
          vim.api.nvim_set_hl(0, "DiagnosticInfo",               { fg = c.info })
          vim.api.nvim_set_hl(0, "DiagnosticHint",               { fg = c.hint })
          vim.api.nvim_set_hl(0, "DiagnosticUnderlineError",     { undercurl = true, sp = c.error })
          vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn",      { undercurl = true, sp = c.warning })
          vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo",      { undercurl = true, sp = c.info })
          vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint",      { undercurl = true, sp = c.hint })
          vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError",   { fg = c.error,   bg = "NONE" })
          vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn",    { fg = c.warning, bg = "NONE" })
          vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo",    { fg = c.info,    bg = "NONE" })
          vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint",    { fg = c.hint,    bg = "NONE" })

          -- ── Syntax ───────────────────────────────────────────────────────────────────
          vim.api.nvim_set_hl(0, "Comment",         { fg = c.comment,          italic = true })
          vim.api.nvim_set_hl(0, "Keyword",         { fg = c.keyword,          bold = true })
          vim.api.nvim_set_hl(0, "Statement",       { fg = c.keyword,          bold = true })
          vim.api.nvim_set_hl(0, "Conditional",     { fg = c.keyword,          bold = true })
          vim.api.nvim_set_hl(0, "Repeat",          { fg = c.keyword,          bold = true })
          vim.api.nvim_set_hl(0, "Exception",       { fg = c.keyword,          bold = true })
          vim.api.nvim_set_hl(0, "String",          { fg = c.string })
          vim.api.nvim_set_hl(0, "Character",       { fg = c.string })
          vim.api.nvim_set_hl(0, "Function",        { fg = c.fn })
          vim.api.nvim_set_hl(0, "Identifier",      { fg = c.variable })
          vim.api.nvim_set_hl(0, "Type",            { fg = c.type })
          vim.api.nvim_set_hl(0, "StorageClass",    { fg = c.type })
          vim.api.nvim_set_hl(0, "Structure",       { fg = c.type })
          vim.api.nvim_set_hl(0, "Typedef",         { fg = c.type })
          vim.api.nvim_set_hl(0, "Constant",        { fg = c.constant })
          vim.api.nvim_set_hl(0, "Boolean",         { fg = c.constant })
          vim.api.nvim_set_hl(0, "Number",          { fg = c.number })
          vim.api.nvim_set_hl(0, "Float",           { fg = c.number })
          vim.api.nvim_set_hl(0, "Operator",        { fg = c.operator })
          vim.api.nvim_set_hl(0, "Delimiter",       { fg = c.fg })
          vim.api.nvim_set_hl(0, "Special",         { fg = c.special })
          vim.api.nvim_set_hl(0, "SpecialChar",     { fg = c.special })
          vim.api.nvim_set_hl(0, "Tag",             { fg = c.special })
          vim.api.nvim_set_hl(0, "PreProc",         { fg = c.builtin })
          vim.api.nvim_set_hl(0, "Include",         { fg = c.builtin })
          vim.api.nvim_set_hl(0, "Define",          { fg = c.builtin })
          vim.api.nvim_set_hl(0, "Macro",           { fg = c.builtin })
          vim.api.nvim_set_hl(0, "Error",           { fg = c.error })
          vim.api.nvim_set_hl(0, "Todo",            { fg = c.bg,               bg = c.warning,   bold = true })
          vim.api.nvim_set_hl(0, "Underlined",      { underline = true })

          -- ── Treesitter ───────────────────────────────────────────────────────────────
          vim.api.nvim_set_hl(0, "@comment",                { link = "Comment" })
          vim.api.nvim_set_hl(0, "@keyword",                { link = "Keyword" })
          vim.api.nvim_set_hl(0, "@keyword.function",       { fg = c.keyword,          bold = true })
          vim.api.nvim_set_hl(0, "@keyword.return",         { fg = c.keyword,          bold = true })
          vim.api.nvim_set_hl(0, "@keyword.operator",       { fg = c.operator })
          vim.api.nvim_set_hl(0, "@conditional",            { link = "Conditional" })
          vim.api.nvim_set_hl(0, "@repeat",                 { link = "Repeat" })
          vim.api.nvim_set_hl(0, "@string",                 { link = "String" })
          vim.api.nvim_set_hl(0, "@string.escape",          { fg = c.special })
          vim.api.nvim_set_hl(0, "@string.special",         { fg = c.special })
          vim.api.nvim_set_hl(0, "@string.regexp",          { fg = c.special })
          vim.api.nvim_set_hl(0, "@character",              { link = "Character" })
          vim.api.nvim_set_hl(0, "@number",                 { link = "Number" })
          vim.api.nvim_set_hl(0, "@float",                  { link = "Float" })
          vim.api.nvim_set_hl(0, "@boolean",                { link = "Boolean" })
          vim.api.nvim_set_hl(0, "@function",               { link = "Function" })
          vim.api.nvim_set_hl(0, "@function.builtin",       { fg = c.builtin })
          vim.api.nvim_set_hl(0, "@function.call",          { fg = c.fn })
          vim.api.nvim_set_hl(0, "@method",                 { fg = c.fn })
          vim.api.nvim_set_hl(0, "@method.call",            { fg = c.fn })
          vim.api.nvim_set_hl(0, "@constructor",            { fg = c.type })
          vim.api.nvim_set_hl(0, "@type",                   { link = "Type" })
          vim.api.nvim_set_hl(0, "@type.builtin",           { fg = c.builtin })
          vim.api.nvim_set_hl(0, "@type.definition",        { fg = c.type,             bold = true })
          vim.api.nvim_set_hl(0, "@constant",               { link = "Constant" })
          vim.api.nvim_set_hl(0, "@constant.builtin",       { fg = c.constant,         bold = true })
          vim.api.nvim_set_hl(0, "@constant.macro",         { fg = c.constant })
          vim.api.nvim_set_hl(0, "@operator",               { link = "Operator" })
          vim.api.nvim_set_hl(0, "@variable",               { fg = c.variable })
          vim.api.nvim_set_hl(0, "@variable.builtin",       { fg = c.builtin })
          vim.api.nvim_set_hl(0, "@variable.parameter",     { fg = c.parameter })
          vim.api.nvim_set_hl(0, "@variable.member",        { fg = c.variable })
          vim.api.nvim_set_hl(0, "@field",                  { fg = c.variable })
          vim.api.nvim_set_hl(0, "@property",               { fg = c.variable })
          vim.api.nvim_set_hl(0, "@namespace",              { fg = c.type })
          vim.api.nvim_set_hl(0, "@module",                 { fg = c.type })
          vim.api.nvim_set_hl(0, "@punctuation.bracket",    { fg = c.fg })
          vim.api.nvim_set_hl(0, "@punctuation.delimiter",  { fg = c.fg })
          vim.api.nvim_set_hl(0, "@punctuation.special",    { fg = c.special })
          vim.api.nvim_set_hl(0, "@tag",                    { fg = c.keyword })
          vim.api.nvim_set_hl(0, "@tag.attribute",          { fg = c.type })
          vim.api.nvim_set_hl(0, "@tag.delimiter",          { fg = c.fg })


          -- ── GitSigns ─────────────────────────────────────────────────────────────────
          vim.api.nvim_set_hl(0, "GitSignsAdd",             { fg = c.string,           bg = "NONE" })
          vim.api.nvim_set_hl(0, "GitSignsChange",          { fg = c.warning,          bg = "NONE" })
          vim.api.nvim_set_hl(0, "GitSignsDelete",          { fg = c.error,            bg = "NONE" })
          vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame",{ fg = c.line_nr,          italic = true })

          -- ── Which-key ────────────────────────────────────────────────────────────────
          vim.api.nvim_set_hl(0, "WhichKey",                { fg = c.variable })
          vim.api.nvim_set_hl(0, "WhichKeyGroup",           { fg = c.fn })
          vim.api.nvim_set_hl(0, "WhichKeyDesc",            { fg = c.fg })
          vim.api.nvim_set_hl(0, "WhichKeySeparator",       { fg = c.fg })
          vim.api.nvim_set_hl(0, "WhichKeyBorder",          { fg = c.float_border,     bg = c.float_bg })
          vim.api.nvim_set_hl(0, "WhichKeyFloat",           { bg = c.float_bg })
          vim.api.nvim_set_hl(0, "WhichKeyValue",           { fg = c.comment })

          -- ── Indent Blankline (v3) ─────────────────────────────────────────────────────
          vim.api.nvim_set_hl(0, "IblIndent",               { fg = c.border })
          vim.api.nvim_set_hl(0, "IblScope",                { fg = c.line_nr })
          vim.api.nvim_set_hl(0, "IndentBlanklineChar",      { fg = c.border })

          -- ── Snacks Indent ─────────────────────────────────────────────────────────────
          vim.api.nvim_set_hl(0, "SnacksIndent",            { fg = c.border })
          vim.api.nvim_set_hl(0, "SnacksIndentScope",       { fg = c.line_nr })

          -- ── Snacks Dashboard ───────────────────────────────────────────────────────
          vim.api.nvim_set_hl(0, "SnacksDashboardDesc",      { fg = c.dashboard })
          vim.api.nvim_set_hl(0, "SnacksDashboardIcon",      { fg = c.dashboard })
          vim.api.nvim_set_hl(0, "SnacksDashboardKey",       { fg = c.dashboard })
          vim.api.nvim_set_hl(0, "SnacksDashboardTitle",     { fg = c.dashboard,        bold = true })
          vim.api.nvim_set_hl(0, "SnacksDashboardFile",      { fg = c.dashboard })

          -- ── Snacks Picker ──────────────────────────────────────────────────────────
          vim.api.nvim_set_hl(0, "SnacksPickerBorder",        { fg = c.dashboard,        bg = c.float_bg })
          vim.api.nvim_set_hl(0, "SnacksPickerInputBorder",   { fg = c.dashboard,        bg = c.float_bg })
          vim.api.nvim_set_hl(0, "SnacksPickerListBorder",    { fg = c.dashboard,        bg = c.float_bg })
          vim.api.nvim_set_hl(0, "SnacksPickerPreviewBorder", { fg = c.dashboard,        bg = c.float_bg })
          vim.api.nvim_set_hl(0, "SnacksPickerTitle",         { fg = c.dashboard,        bg = c.float_bg,  bold = true })
          vim.api.nvim_set_hl(0, "SnacksPickerInputTitle",    { fg = c.dashboard,        bg = c.float_bg,  bold = true })

          -- ── nvim-cmp ─────────────────────────────────────────────────────────────────
          vim.api.nvim_set_hl(0, "CmpItemAbbr",             { fg = c.fg })
          vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated",   { fg = c.line_nr,          strikethrough = true })
          vim.api.nvim_set_hl(0, "CmpItemAbbrMatch",        { fg = c.keyword,          bold = true })
          vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy",   { fg = c.keyword,          bold = true })
          vim.api.nvim_set_hl(0, "CmpItemMenu",             { fg = c.comment,          italic = true })
          vim.api.nvim_set_hl(0, "CmpItemKindDefault",      { fg = c.type })
          vim.api.nvim_set_hl(0, "CmpItemKindFunction",     { fg = c.fn })
          vim.api.nvim_set_hl(0, "CmpItemKindMethod",       { fg = c.fn })
          vim.api.nvim_set_hl(0, "CmpItemKindVariable",     { fg = c.fg })
          vim.api.nvim_set_hl(0, "CmpItemKindField",        { fg = c.fg })
          vim.api.nvim_set_hl(0, "CmpItemKindKeyword",      { fg = c.keyword })
          vim.api.nvim_set_hl(0, "CmpItemKindConstant",     { fg = c.constant })
          vim.api.nvim_set_hl(0, "CmpItemKindClass",        { fg = c.type })
          vim.api.nvim_set_hl(0, "CmpItemKindInterface",    { fg = c.type })
          vim.api.nvim_set_hl(0, "CmpItemKindModule",       { fg = c.type })
          vim.api.nvim_set_hl(0, "CmpItemKindSnippet",      { fg = c.special })

          -- ── Neo-tree ─────────────────────────────────────────────────────────────────
          vim.api.nvim_set_hl(0, "NeoTreeNormal",           { fg = c.fg,               bg = "NONE" })
          vim.api.nvim_set_hl(0, "NeoTreeNormalNC",         { fg = c.fg,               bg = "NONE" })
          vim.api.nvim_set_hl(0, "NeoTreeBorder",           { fg = c.border,           bg = "NONE" })
          vim.api.nvim_set_hl(0, "NeoTreeDirectoryIcon",    { fg = c.fn })
          vim.api.nvim_set_hl(0, "NeoTreeDirectoryName",    { fg = c.fg,               bold = true })
          vim.api.nvim_set_hl(0, "NeoTreeFileName",         { fg = c.fg })
          vim.api.nvim_set_hl(0, "NeoTreeGitAdded",         { fg = c.string })
          vim.api.nvim_set_hl(0, "NeoTreeGitModified",      { fg = c.warning })
          vim.api.nvim_set_hl(0, "NeoTreeGitDeleted",       { fg = c.error })

          -- ── Noice / Notify ───────────────────────────────────────────────────────────
          vim.api.nvim_set_hl(0, "NoicePopup",              { fg = c.fg,               bg = c.float_bg })
          vim.api.nvim_set_hl(0, "NoicePopupBorder",        { fg = c.float_border,     bg = c.float_bg })
          vim.api.nvim_set_hl(0, "NoiceCmdlinePopup",       { fg = c.fg,               bg = c.float_bg })
          vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = c.float_border })
          vim.api.nvim_set_hl(0, "NoiceMini",               { fg = c.fg,               bg = c.cursor_line })
          vim.api.nvim_set_hl(0, "NotifyERRORBorder",       { fg = c.error })
          vim.api.nvim_set_hl(0, "NotifyWARNBorder",        { fg = c.warning })
          vim.api.nvim_set_hl(0, "NotifyINFOBorder",        { fg = c.info })
          vim.api.nvim_set_hl(0, "NotifyERRORTitle",        { fg = c.error,            bold = true })
          vim.api.nvim_set_hl(0, "NotifyWARNTitle",         { fg = c.warning,          bold = true })
          vim.api.nvim_set_hl(0, "NotifyINFOTitle",         { fg = c.info,             bold = true })
          vim.api.nvim_set_hl(0, "NotifyERRORBody",         { fg = c.fg,               bg = c.float_bg })
          vim.api.nvim_set_hl(0, "NotifyWARNBody",          { fg = c.fg,               bg = c.float_bg })
          vim.api.nvim_set_hl(0, "NotifyINFOBody",          { fg = c.fg,               bg = c.float_bg })

          -- ── Flash ────────────────────────────────────────────────────────────────────
          vim.api.nvim_set_hl(0, "FlashBackdrop",           { fg = c.comment })
          vim.api.nvim_set_hl(0, "FlashLabel",              { fg = c.bg,               bg = c.special,    bold = true })
          vim.api.nvim_set_hl(0, "FlashMatch",              { fg = c.bg,               bg = c.keyword })
          vim.api.nvim_set_hl(0, "FlashCurrent",            { fg = c.bg,               bg = c.string })

          -- ── Lualine ──────────────────────────────────────────────────────────────────
          -- lualine_a: mode badge (colored background, dark text)
          vim.api.nvim_set_hl(0, "lualine_a_normal",            { fg = c.sl_bg, bg = c.sl_mode_n, bold = true })
          vim.api.nvim_set_hl(0, "lualine_a_insert",            { fg = c.sl_bg, bg = c.sl_mode_i, bold = true })
          vim.api.nvim_set_hl(0, "lualine_a_visual",            { fg = c.sl_bg, bg = c.sl_mode_v, bold = true })
          vim.api.nvim_set_hl(0, "lualine_a_command",           { fg = c.sl_bg, bg = c.sl_mode_c, bold = true })
          vim.api.nvim_set_hl(0, "lualine_a_terminal",          { fg = c.sl_bg, bg = c.sl_mode_t, bold = true })
          vim.api.nvim_set_hl(0, "lualine_a_replace",           { fg = c.sl_bg, bg = c.error,     bold = true })
          vim.api.nvim_set_hl(0, "lualine_a_inactive",          { fg = c.line_nr, bg = "NONE" })
          -- lualine_b: branch / diff section
          vim.api.nvim_set_hl(0, "lualine_b_normal",            { fg = c.sl_fg, bg = c.cursor_line })
          vim.api.nvim_set_hl(0, "lualine_b_insert",            { fg = c.sl_fg, bg = c.cursor_line })
          vim.api.nvim_set_hl(0, "lualine_b_visual",            { fg = c.sl_fg, bg = c.cursor_line })
          vim.api.nvim_set_hl(0, "lualine_b_command",           { fg = c.sl_fg, bg = c.cursor_line })
          vim.api.nvim_set_hl(0, "lualine_b_terminal",          { fg = c.sl_fg, bg = c.cursor_line })
          vim.api.nvim_set_hl(0, "lualine_b_replace",           { fg = c.sl_fg, bg = c.cursor_line })
          vim.api.nvim_set_hl(0, "lualine_b_inactive",          { fg = c.line_nr, bg = "NONE" })
          -- lualine_c: filename / middle section
          vim.api.nvim_set_hl(0, "lualine_c_normal",            { fg = c.sl_fg, bg = "NONE" })
          vim.api.nvim_set_hl(0, "lualine_c_insert",            { fg = c.sl_fg, bg = "NONE" })
          vim.api.nvim_set_hl(0, "lualine_c_visual",            { fg = c.sl_fg, bg = "NONE" })
          vim.api.nvim_set_hl(0, "lualine_c_command",           { fg = c.sl_fg, bg = "NONE" })
          vim.api.nvim_set_hl(0, "lualine_c_terminal",          { fg = c.sl_fg, bg = "NONE" })
          vim.api.nvim_set_hl(0, "lualine_c_replace",           { fg = c.sl_fg, bg = "NONE" })
          vim.api.nvim_set_hl(0, "lualine_c_inactive",          { fg = c.line_nr, bg = "NONE" })

        '';
      };
      options.nito = {
        theme = lib.mkOption {
          type = lib.types.str;
          default = "dark";
          description = "The theme to use for neovim";
        };
        light = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          default = {
            base00 = "#F4EAE1";
            base01 = "#e0d8ce";
            base02 = "#C4B09E";
            base03 = "#8a8078";
            # Foregrounds (Grey)
            base04 = "#4a4640";
            base05 = "#1c1a18";
            base06 = "#1c1a18";
            base07 = "#000000";
            # Accents
            base08 = "#D32F2F";
            base09 = "#D84315";
            base0A = "#B07D00";
            base0B = "#278536";
            base0C = "#00897B";
            base0D = "#8E4D2F";
            base0E = "#6A1B9A";
            base0F = "#1565C0";

            # Extended (Brights
            base10 = "#C2185B";
            base11 = "#D81B60";
            base12 = "#4527A0";
            base13 = "#283593";
            base14 = "#0277BD";
            base15 = "#00695C";
            base16 = "#558B2F";
            base17 = "#4E342E";
          };
        };
        dark = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          default = {
            # Backgrounds
            base00 = "#131316";
            base01 = "#221c2c";
            base02 = "#313245";
            base03 = "#4D415F";

            # Foregrounds
            base04 = "#8c92aa";
            base05 = "#cfd3e7";
            base06 = "#e4e8f5";
            base07 = "#f0f2fa";

            # Accents
            base08 = "#ff7a6b";
            base09 = "#f2b8a0";
            base0A = "#f6d88a";
            base0B = "#b8db8c";
            base0C = "#7cb8d4";
            base0D = "#c5c0ff";
            base0E = "#d4a8c0";
            base0F = "#7d75c0";

            # Extended
            base10 = "#8fd4b5";
            base11 = "#c8b0e8";
            base12 = "#a8c8f0";
            base13 = "#f6d88a";
            base14 = "#f6d88a";
            base15 = "#7cb8d4";
            base16 = "#f2b8a0";
            base17 = "#7d75c0";
          };
        };
      };
    };
}
