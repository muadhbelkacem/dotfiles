local M = {}

function M.setup()
  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end

  vim.g.colors_name = "dark-colorscheme"
  vim.o.background = "dark"

  local palette = {
    bg = "#101010",
    fg = "#e4e4ef",
    yellow = "#ffdd33",
    green = "#73c936",
    niagara = "#96a6c8",
    quartz = "#95a99f",
    brown = "#cc8c3c",
    red = "#f43841",
    bg_plus_1 = "#282828",
    bg_plus_2 = "#383838",
    bg_plus_3 = "#484848",
    bg_plus_4 = "#585858",
    bg_minus_1 = "#101010",
  }

  local highlights = {
    -- Editor UI
    Normal = { fg = palette.fg, bg = palette.bg },
    CursorLine = { bg = palette.bg_plus_1 },
    CursorLineNr = { fg = palette.yellow, bold = true },
    LineNr = { fg = palette.niagara, bg = palette.bg },
    VertSplit = { fg = palette.bg, bg = "NONE" },
    StatusLine = { fg = palette.fg, bg = palette.bg_plus_1 },
    StatusLineNC = { fg = palette.niagara, bg = palette.bg_minus_1 },
    Visual = { fg = palette.bg, bg = palette.fg },
    Search = { fg = palette.bg, bg = palette.yellow },
    IncSearch = { fg = palette.bg, bg = palette.yellow },
    MatchParen = { fg = palette.yellow, bg = "#52494e", bold = true },
    Pmenu = { fg = palette.fg, bg = palette.bg_plus_1 },
    PmenuSel = { fg = palette.bg, bg = palette.yellow },
    PmenuSbar = { bg = palette.bg_plus_1 },
    PmenuThumb = { bg = palette.quartz },
    Folded = { fg = palette.quartz, bg = palette.bg_plus_1 },
    FoldColumn = { fg = palette.quartz, bg = palette.bg_minus_1 },
    SignColumn = { bg = palette.bg_minus_1 },
    EndOfBuffer = { fg = palette.bg },
    NonText = { fg = palette.bg_plus_2 },
    SpecialKey = { fg = palette.bg_plus_2 },
    Directory = { fg = palette.niagara, bold = true },
    Title = { fg = palette.yellow, bold = true },
    TabLine = { fg = palette.niagara, bg = palette.bg },
    TabLineSel = { fg = palette.yellow, bg = palette.bg, bold = true },
    TabLineFill = { fg = palette.bg, bg = palette.brown },

    -- Syntax
    Comment = { fg = palette.brown, italic = true },
    Constant = { fg = palette.quartz },
    String = { fg = palette.green },
    Character = { fg = palette.green },
    Number = { fg = palette.quartz },
    Boolean = { fg = palette.quartz },
    Float = { fg = palette.quartz },
    Identifier = { fg = palette.fg },
    Function = { fg = palette.fg },
    Statement = { fg = palette.yellow, bold = true },
    Conditional = { fg = palette.yellow, bold = true },
    Repeat = { fg = palette.yellow, bold = true },
    Label = { fg = palette.fg },
    Operator = { fg = palette.yellow },
    Keyword = { fg = palette.yellow, bold = true },
    Exception = { fg = palette.yellow, bold = true },
    PreProc = { fg = palette.fg },
    Include = { fg = palette.fg },
    Define = { fg = palette.fg },
    Macro = { fg = palette.fg },
    PreCondit = { fg = palette.fg },
    Type = { fg = palette.yellow },
    StorageClass = { fg = palette.yellow },
    Structure = { fg = palette.yellow },
    Typedef = { fg = palette.yellow },
    Special = { fg = palette.quartz },
    SpecialChar = { fg = palette.quartz },
    Tag = { fg = palette.quartz },
    Delimiter = { fg = palette.yellow },
    SpecialComment = { fg = palette.brown, italic = true },
    Debug = { fg = palette.red },
    Underlined = { fg = palette.niagara, underline = true },
    Bold = { bold = true },
    Italic = { italic = true },
    StrikeThrough = { strikethrough = true },
    Ignore = { fg = palette.bg },
    Error = { fg = palette.red, bg = "NONE" },
    Todo = { fg = palette.yellow, bg = "NONE", bold = true },

    -- Diff
    DiffAdd = { fg = palette.bg, bg = palette.green },
    DiffChange = { fg = palette.bg, bg = palette.yellow },
    DiffDelete = { fg = palette.bg, bg = palette.red },
    DiffText = { fg = palette.bg, bg = palette.fg, bold = true },

    -- Diagnostics
    DiagnosticError = { fg = palette.red },
    DiagnosticWarn = { fg = palette.yellow },
    DiagnosticInfo = { fg = palette.niagara },
    DiagnosticHint = { fg = palette.quartz },

    ErrorSign = { fg = palette.red, bg = palette.bg_minus_1 },
    WarningSign = { fg = palette.yellow, bg = palette.bg_minus_1 },
    InfoSign = { fg = palette.niagara, bg = palette.bg_minus_1 },
    HintSign = { fg = palette.quartz, bg = palette.bg_minus_1 },

    ErrorVirtualText = { fg = palette.red },
    WarningVirtualText = { fg = palette.yellow },
    InfoVirtualText = { fg = palette.niagara },
    HintVirtualText = { fg = palette.quartz },

    ErrorHighlight = { undercurl = true, sp = palette.red },
    WarningHighlight = { undercurl = true, sp = palette.yellow },
    InfoHighlight = { undercurl = true, sp = palette.niagara },
    HintHighlight = { undercurl = true, sp = palette.quartz },

    Floating = { bg = palette.bg_plus_1 },
    ErrorFloat = { fg = palette.red, bg = palette.bg_plus_1 },
    WarningFloat = { fg = palette.yellow, bg = palette.bg_plus_1 },
    InfoFloat = { fg = palette.niagara, bg = palette.bg_plus_1 },
    HintFloat = { fg = palette.quartz, bg = palette.bg_plus_1 },

    HighlightText = { bg = palette.bg_plus_4 },
    FadeOut = { fg = palette.bg_plus_4 },
    UnusedHighlight = { fg = palette.bg_plus_4 },
  }

  for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- Coc links
  local coc_links = {
    CocErrorSign = "ErrorSign",
    CocWarningSign = "WarningSign",
    CocInfoSign = "InfoSign",
    CocHintSign = "HintSign",
    CocErrorVirtualText = "ErrorVirtualText",
    CocWarningVirtualText = "WarningVirtualText",
    CocInfoVirtualText = "InfoVirtualText",
    CocHintVirtualText = "HintVirtualText",
    CocErrorHighlight = "ErrorHighlight",
    CocWarningHighlight = "WarningHighlight",
    CocInfoHighlight = "InfoHighlight",
    CocHintHighlight = "HintHighlight",
    CocFadeOut = "FadeOut",
    CocUnusedHighlight = "UnusedHighlight",
    CocFloating = "Floating",
    CocErrorFloat = "ErrorFloat",
    CocWarningFloat = "WarningFloat",
    CocInfoFloat = "InfoFloat",
    CocHintFloat = "HintFloat",
    CocHighlightText = "HighlightText",
    CocCodeLens = "HintVirtualText",
    CocBold = "Bold",
    CocItalic = "Italic",
    CocUnderline = "Underlined",
    CocStrikeThrough = "StrikeThrough",
    markdownCode = "String",
    markdownCodeBlock = "String",
    markdownH1 = "Title",
    markdownH2 = "Title",
    markdownLinkText = "Underlined",
    markdownUrl = "Underlined",
    markdownBold = "Bold",
    markdownItalic = "Italic",
  }

  for link, target in pairs(coc_links) do
    vim.api.nvim_set_hl(0, link, { link = target })
  end

  -- Terminal Colors
  vim.g.terminal_color_0 = palette.bg
  vim.g.terminal_color_1 = palette.red
  vim.g.terminal_color_2 = palette.green
  vim.g.terminal_color_3 = palette.brown
  vim.g.terminal_color_4 = palette.niagara
  vim.g.terminal_color_5 = palette.fg
  vim.g.terminal_color_6 = palette.quartz
  vim.g.terminal_color_7 = palette.fg
  vim.g.terminal_color_8 = palette.bg_plus_2
  vim.g.terminal_color_9 = palette.red
  vim.g.terminal_color_10 = palette.green
  vim.g.terminal_color_11 = palette.yellow
  vim.g.terminal_color_12 = palette.niagara
  vim.g.terminal_color_13 = palette.fg
  vim.g.terminal_color_14 = palette.quartz
  vim.g.terminal_color_15 = palette.fg
end

return M
