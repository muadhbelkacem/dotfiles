vim9script

# Dark colorscheme for Vim

set background=dark
hi clear
if exists("syntax_on")
    syntax reset
endif

g:colors_name = "dark-colorscheme"

var bg = "#181818"
var fg = "#e4e4ef"
var yellow = "#FCF75E"
var green = "#00FF80"
var niagara = "#96a6c8"
var quartz = "#95a99f"
var brown = "#cc8c3c"
var red = "#f43841"
var bg_plus_1 = "#292929"
var bg_plus_2 = "#3a3a3a"
var bg_plus_3 = "#4b4b4b"
var bg_plus_4 = "#5c5c5c"
var bg_minus_1 = "#111111"

# Editor UI
exec 'hi Normal guibg=' .. bg .. ' guifg=' .. fg
exec 'hi CursorLine guibg=' .. bg_plus_1
exec 'hi CursorLineNr guifg=' .. yellow .. ' gui=bold'
exec 'hi LineNr guibg=' .. bg .. ' guifg=' .. niagara
exec 'hi VertSplit guifg=' .. bg .. ' guibg=NONE'
exec 'hi StatusLine guibg=' .. bg .. ' guifg=' .. yellow .. ' gui=NONE'
exec 'hi StatusLineNC guibg=' .. bg .. ' guifg=' .. yellow .. ' gui=NONE'
exec 'hi Visual guibg=' .. fg .. ' guifg=' .. bg
exec 'hi Search guibg=' .. yellow .. ' guifg=' .. bg
exec 'hi IncSearch guibg=' .. yellow .. ' guifg=' .. bg
exec 'hi MatchParen guibg=' .. bg .. ' guifg=' .. yellow .. ' gui=bold'
exec 'hi Pmenu guibg=' .. bg_plus_1 .. ' guifg=' .. fg
exec 'hi PmenuSel guibg=' .. yellow .. ' guifg=' .. bg
exec 'hi PmenuSbar guibg=' .. bg_plus_1
exec 'hi PmenuThumb guibg=' .. quartz
exec 'hi Folded guibg=' .. bg_plus_1 .. ' guifg=' .. quartz
exec 'hi FoldColumn guibg=' .. bg_minus_1 .. ' guifg=' .. quartz
exec 'hi SignColumn guibg=' .. bg_minus_1
exec 'hi EndOfBuffer guifg=' .. bg
exec 'hi NonText guifg=' .. bg_plus_2
exec 'hi SpecialKey guifg=' .. bg_plus_2
exec 'hi Directory guifg=' .. yellow .. ' gui=bold'
exec 'hi Title guifg=' .. yellow .. ' gui=bold'
exec 'hi TabLine guibg=' .. bg .. ' guifg=' .. niagara .. ' gui=NONE'
exec 'hi TabLineSel guibg=' .. bg .. ' guifg=' .. yellow .. ' gui=bold'
exec 'hi TabLineFill guibg=' .. brown .. ' guifg=' .. bg .. ' gui=NONE'

# Syntax
exec 'hi Comment guifg=' .. brown .. ' gui=italic'
exec 'hi Constant guifg=' .. quartz
exec 'hi String guifg=' .. green
exec 'hi Character guifg=' .. green
exec 'hi Number guifg=' .. quartz
exec 'hi Boolean guifg=' .. quartz
exec 'hi Float guifg=' .. quartz

exec 'hi Identifier guifg=' .. fg
exec 'hi Function guifg=' .. fg
exec 'hi Statement guifg=' .. yellow .. ' gui=bold'
exec 'hi Conditional guifg=' .. yellow .. ' gui=bold'
exec 'hi Repeat guifg=' .. yellow .. ' gui=bold'
exec 'hi Label guifg=' .. fg
exec 'hi Operator guifg=' .. yellow
exec 'hi Keyword guifg=' .. yellow .. ' gui=bold'
exec 'hi Exception guifg=' .. yellow .. ' gui=bold'

exec 'hi PreProc guifg=' .. fg
exec 'hi Include guifg=' .. fg
exec 'hi Define guifg=' .. fg
exec 'hi Macro guifg=' .. fg
exec 'hi PreCondit guifg=' .. fg

exec 'hi Type guifg=' .. yellow
exec 'hi StorageClass guifg=' .. yellow
exec 'hi Structure guifg=' .. yellow
exec 'hi Typedef guifg=' .. yellow

exec 'hi Special guifg=' .. quartz
exec 'hi SpecialChar guifg=' .. quartz
exec 'hi Tag guifg=' .. quartz
exec 'hi Delimiter guifg=' .. yellow
exec 'hi SpecialComment guifg=' .. brown .. ' gui=italic'
exec 'hi Debug guifg=' .. red

exec 'hi Underlined guifg=' .. niagara .. ' gui=underline'
exec 'hi Bold gui=bold'
exec 'hi Italic gui=italic'
exec 'hi StrikeThrough gui=strikethrough'
exec 'hi Ignore guifg=' .. bg
exec 'hi Error guifg=' .. red .. ' guibg=NONE'
exec 'hi Todo guifg=' .. yellow .. ' guibg=NONE gui=bold'

# Diff
exec 'hi DiffAdd guibg=' .. green .. ' guifg=' .. bg
exec 'hi DiffChange guibg=' .. yellow .. ' guifg=' .. bg
exec 'hi DiffDelete guibg=' .. red .. ' guifg=' .. bg
exec 'hi DiffText guibg=' .. fg .. ' guifg=' .. bg .. ' gui=bold'

# Diagnostics
exec 'hi DiagnosticError guifg=' .. red
exec 'hi DiagnosticWarn guifg=' .. yellow
exec 'hi DiagnosticInfo guifg=' .. niagara
exec 'hi DiagnosticHint guifg=' .. quartz

exec 'hi ErrorSign guifg=' .. red .. ' guibg=' .. bg_minus_1
exec 'hi WarningSign guifg=' .. yellow .. ' guibg=' .. bg_minus_1
exec 'hi InfoSign guifg=' .. niagara .. ' guibg=' .. bg_minus_1
exec 'hi HintSign guifg=' .. quartz .. ' guibg=' .. bg_minus_1

exec 'hi ErrorVirtualText guifg=' .. red
exec 'hi WarningVirtualText guifg=' .. yellow
exec 'hi InfoVirtualText guifg=' .. niagara
exec 'hi HintVirtualText guifg=' .. quartz

exec 'hi ErrorHighlight gui=undercurl guisp=' .. red
exec 'hi WarningHighlight gui=undercurl guisp=' .. yellow
exec 'hi InfoHighlight gui=undercurl guisp=' .. niagara
exec 'hi HintHighlight gui=undercurl guisp=' .. quartz

exec 'hi Floating guibg=' .. bg_plus_1
exec 'hi ErrorFloat guifg=' .. red .. ' guibg=' .. bg_plus_1
exec 'hi WarningFloat guifg=' .. yellow .. ' guibg=' .. bg_plus_1
exec 'hi InfoFloat guifg=' .. niagara .. ' guibg=' .. bg_plus_1
exec 'hi HintFloat guifg=' .. quartz .. ' guibg=' .. bg_plus_1

exec 'hi HighlightText guibg=' .. bg_plus_4
exec 'hi FadeOut guifg=' .. bg_plus_4
exec 'hi UnusedHighlight guifg=' .. bg_plus_4

# Coc
exec 'hi link CocErrorSign ErrorSign'
exec 'hi link CocWarningSign WarningSign'
exec 'hi link CocInfoSign InfoSign'
exec 'hi link CocHintSign HintSign'

exec 'hi link CocErrorVirtualText ErrorVirtualText'
exec 'hi link CocWarningVirtualText WarningVirtualText'
exec 'hi link CocInfoVirtualText InfoVirtualText'
exec 'hi link CocHintVirtualText HintVirtualText'

exec 'hi link CocErrorHighlight ErrorHighlight'
exec 'hi link CocWarningHighlight WarningHighlight'
exec 'hi link CocInfoHighlight InfoHighlight'
exec 'hi link CocHintHighlight HintHighlight'

exec 'hi link CocFadeOut FadeOut'
exec 'hi link CocUnusedHighlight UnusedHighlight'

exec 'hi link CocFloating Floating'
exec 'hi link CocErrorFloat ErrorFloat'
exec 'hi link CocWarningFloat WarningFloat'
exec 'hi link CocInfoFloat InfoFloat'
exec 'hi link CocHintFloat HintFloat'

exec 'hi link CocHighlightText HighlightText'
exec 'hi link CocCodeLens HintVirtualText'

exec 'hi link CocBold Bold'
exec 'hi link CocItalic Italic'
exec 'hi link CocUnderline Underlined'
exec 'hi link CocStrikeThrough StrikeThrough'

# Markdown
exec 'hi link markdownCode String'
exec 'hi link markdownCodeBlock String'
exec 'hi link markdownH1 Title'
exec 'hi link markdownH2 Title'
exec 'hi link markdownLinkText Underlined'
exec 'hi link markdownUrl Underlined'
exec 'hi link markdownBold Bold'
exec 'hi link markdownItalic Italic'

# Terminal Colors
g:terminal_ansi_colors = [
    bg,         # black
    red,        # red
    green,      # green
    brown,      # yellow
    niagara,    # blue
    fg,         # magenta
    quartz,     # cyan
    fg,         # white
    bg_plus_2,  # bright black
    red,        # bright red
    green,      # bright green
    yellow,     # bright yellow
    niagara,    # bright blue
    fg,         # bright magenta
    quartz,     # bright cyan
    fg          # bright white
]
