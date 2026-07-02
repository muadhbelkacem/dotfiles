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
var yellow = "#ffdd33"
var green = "#73c936"
var niagara = "#96a6c8"
var quartz = "#95a99f"
var brown = "#cc8c3c"
var red = "#f43841"
var bg_plus_1 = "#282828"
var bg_plus_2 = "#383838"
var bg_minus_1 = "#101010"

# Editor UI
exec 'hi Normal guibg=' .. bg .. ' guifg=' .. fg
exec 'hi CursorLine guibg=' .. bg_plus_1
exec 'hi CursorLineNr guifg=' .. yellow .. ' gui=bold'
exec 'hi LineNr guibg=' .. bg .. ' guifg=' .. brown
exec 'hi VertSplit guifg=' .. bg_plus_1 .. ' guibg=NONE'
exec 'hi StatusLine guibg=' .. bg_plus_1 .. ' guifg=' .. fg .. ' gui=NONE'
exec 'hi StatusLineNC guibg=' .. bg_minus_1 .. ' guifg=' .. brown .. ' gui=NONE'
exec 'hi Visual guibg=' .. fg .. ' guifg=' .. bg
exec 'hi Search guibg=' .. yellow .. ' guifg=' .. bg
exec 'hi IncSearch guibg=' .. yellow .. ' guifg=' .. bg
exec 'hi MatchParen guibg=' .. "#52494e" .. ' guifg=' .. yellow .. ' gui=bold'
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
exec 'hi Directory guifg=' .. niagara .. ' gui=bold'
exec 'hi Title guifg=' .. yellow .. ' gui=bold'

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
exec 'hi Label guifg=' .. yellow .. ' gui=bold'
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
exec 'hi Ignore guifg=' .. bg
exec 'hi Error guifg=' .. red .. ' guibg=NONE'
exec 'hi Todo guifg=' .. yellow .. ' guibg=NONE gui=bold'

# Diff
exec 'hi DiffAdd guibg=' .. green .. ' guifg=' .. bg
exec 'hi DiffChange guibg=' .. yellow .. ' guifg=' .. bg
exec 'hi DiffDelete guibg=' .. red .. ' guifg=' .. bg
exec 'hi DiffText guibg=' .. fg .. ' guifg=' .. bg .. ' gui=bold'

# Coc.nvim / Diagnostics
exec 'hi CocErrorSign guifg=' .. red .. ' guibg=' .. bg_minus_1
exec 'hi CocWarningSign guifg=' .. yellow .. ' guibg=' .. bg_minus_1
exec 'hi CocInfoSign guifg=' .. niagara .. ' guibg=' .. bg_minus_1
exec 'hi CocHintSign guifg=' .. quartz .. ' guibg=' .. bg_minus_1

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
