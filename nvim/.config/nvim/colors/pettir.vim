hi clear
syntax reset
let g:colors_name = "pettir"
if &background == "light"
    hi Boolean gui=NONE guifg=#707070 guibg=NONE
    hi ColorColumn gui=NONE guifg=NONE guibg=#f5f5f5
    hi Comment gui=NONE guifg=#7c7979 guibg=NONE
    hi Conceal gui=NONE guifg=#707070 guibg=NONE

    hi Character        guifg=#A05314
    hi String gui=NONE guifg=#CB5C00 guibg=NONE
    hi Define          guifg=#66D9EF
    hi Statement guifg=#00B4B4
    hi Keyword guifg=#00B4B4
    hi Function gui=NONE guifg=#3E53C3 guibg=NONE
    hi Identifier gui=NONE guifg=#1631C4 guibg=NONE

    hi Constant gui=NONE guifg=#006000 guibg=NONE
    hi Type gui=NONE guifg=#308585 guibg=NONE
    hi Special gui=NONE guifg=#A01414 guibg=NONE
    hi SpecialKey gui=NONE guifg=#c2c2c2 guibg=NONE
    hi PreProc gui=NONE guifg=#94007e guibg=NONE

    hi Cursor gui=reverse guifg=#b5b5b5 guibg=#000000
    hi CursorColumn gui=NONE guifg=NONE guibg=#f5f5f5
    hi CursorLine gui=NONE guifg=NONE guibg=#f3f2f2
    hi CursorLine cterm=NONE
    hi CursorLineNr gui=NONE guifg=#050505 guibg=#f3f2f2
    hi DiffAdd gui=NONE guifg=NONE guibg=#f0fff0
    hi DiffChange gui=NONE guifg=NONE guibg=#f5f5f5
    hi DiffDelete gui=NONE guifg=NONE guibg=#fff0f0
    hi DiffText gui=NONE guifg=NONE guibg=#c7d4ff
    hi Directory gui=NONE guifg=#4a4a4a guibg=NONE
    hi Error gui=NONE guifg=#ff0000 guibg=NONE
    hi ErrorMsg gui=NONE guifg=NONE guibg=NONE
    hi FoldColumn gui=NONE guifg=#c2c2c2 guibg=NONE
    hi Folded gui=NONE guifg=#969696 guibg=NONE
    hi Ignore gui=NONE guifg=NONE guibg=NONE
    hi IncSearch gui=NONE guifg=NONE guibg=#ffde7a
    hi LineNr gui=NONE guifg=#707070 guibg=NONE
    hi MatchParen gui=NONE guifg=NONE guibg=#e8e8e8
    hi ModeMsg gui=NONE guifg=NONE guibg=NONE
    hi MoreMsg gui=NONE guifg=NONE guibg=NONE
    hi NonText gui=NONE guifg=#c2c2c2 guibg=NONE
    hi Normal gui=NONE guifg=#000000 guibg=#ffffff
    hi Number gui=NONE guifg=#c07c07 guibg=NONE
    hi Pmenu gui=NONE guifg=NONE guibg=#f5f5f5
    hi PmenuSbar gui=NONE guifg=NONE guibg=#ededed
    hi PmenuSel gui=NONE guifg=NONE guibg=#e3e3e3
    hi PmenuThumb gui=NONE guifg=NONE guibg=#dbdbdb
    hi Question gui=NONE guifg=NONE guibg=NONE
    hi Search gui=NONE guifg=NONE guibg=#ffde7a
    hi SignColumn gui=NONE guifg=#c2c2c2 guibg=NONE
    hi SpellBad gui=undercurl guisp=NONE guifg=NONE guibg=#fff0f0
    hi SpellCap gui=undercurl guisp=NONE guifg=NONE guibg=NONE
    hi SpellLocal gui=undercurl guisp=NONE guifg=NONE guibg=#f0fff0
    hi SpellRare gui=undercurl guisp=NONE guifg=NONE guibg=#ededed
    hi StatusLine gui=NONE guifg=#262626 guibg=#ededed
    hi StatusLineNC gui=NONE guifg=#969696 guibg=#ededed
    hi StorageClass gui=NONE guifg=#003bff guibg=NONE
    hi TabLine gui=NONE guifg=#969696 guibg=#ededed
    hi TabLineFill gui=NONE guifg=NONE guibg=#ededed
    hi TabLineSel gui=NONE guifg=#262626 guibg=#ededed
    hi Title gui=NONE guifg=#707070 guibg=NONE
    hi Todo gui=standout guifg=#ff0000 guibg=#ffffff
    hi Underlined gui=NONE guifg=NONE guibg=NONE
    hi VertSplit gui=NONE guifg=#e3e3e3 guibg=NONE
    hi Visual gui=NONE guifg=NONE guibg=#e3e3e3
    hi VisualNOS gui=NONE guifg=NONE guibg=NONE
    hi WarningMsg gui=NONE guifg=#c25202 guibg=NONE
    hi WildMenu gui=NONE guifg=NONE guibg=#d1d1d1
    hi lCursor gui=NONE guifg=NONE guibg=NONE

    " Legacy groups that treesitter captures link onto but this file never set,
    " so they fell back to Neovim's own defaults instead of the palette above.
    hi Delimiter gui=NONE guifg=#707070 guibg=NONE
    hi Operator gui=NONE guifg=#707070 guibg=NONE
elseif &background == "dark"
    hi Boolean gui=NONE guifg=#808080 guibg=NONE
    hi ColorColumn gui=NONE guifg=NONE guibg=#1a1a1a
    hi Comment gui=NONE guifg=#707070 guibg=NONE
    hi Conceal gui=NONE guifg=#808080 guibg=NONE
    hi Conditional gui=NONE guifg=#8f8f8f guibg=NONE
    hi Constant gui=NONE guifg=#808080 guibg=NONE
    hi Cursor gui=reverse guifg=NONE guibg=NONE
    hi CursorColumn gui=NONE guifg=NONE guibg=#1a1a1a
    hi CursorLine gui=NONE guifg=NONE guibg=#1a1a1a
    hi CursorLineNr gui=NONE guifg=#707070 guibg=NONE
    hi DiffAdd gui=NONE guifg=NONE guibg=#082608
    hi DiffChange gui=NONE guifg=NONE guibg=#1a1a1a
    hi DiffDelete gui=NONE guifg=NONE guibg=#260808
    hi DiffText gui=NONE guifg=NONE guibg=#333333
    hi Directory gui=NONE guifg=#8f8f8f guibg=NONE
    hi Error gui=NONE guifg=NONE guibg=#260808
    hi ErrorMsg gui=NONE guifg=NONE guibg=#260808
    hi FoldColumn gui=NONE guifg=#616161 guibg=NONE
    hi Folded gui=NONE guifg=#707070 guibg=NONE
    hi Ignore gui=NONE guifg=NONE guibg=NONE
    hi IncSearch gui=NONE guifg=NONE guibg=#FFA500
    hi LineNr gui=NONE guifg=#616161 guibg=NONE
    hi MatchParen gui=NONE guifg=NONE guibg=#333333
    hi ModeMsg gui=NONE guifg=NONE guibg=NONE
    hi MoreMsg gui=NONE guifg=NONE guibg=NONE
    hi NonText gui=NONE guifg=#616161 guibg=NONE
    hi Normal gui=NONE guifg=#b0b0b0 guibg=#0a0a0a
    hi Number gui=NONE guifg=#808080 guibg=NONE
    hi Pmenu gui=NONE guifg=NONE guibg=#1a1a1a
    hi PmenuSbar gui=NONE guifg=NONE guibg=#262626
    hi PmenuSel gui=NONE guifg=NONE guibg=#333333
    hi PmenuThumb gui=NONE guifg=NONE guibg=#424242
    hi Question gui=NONE guifg=NONE guibg=NONE
    hi Search gui=NONE guifg=NONE guibg=#FFB510
    hi SignColumn gui=NONE guifg=#616161 guibg=NONE
    hi Special gui=NONE guifg=#808080 guibg=NONE
    hi SpecialKey gui=NONE guifg=#616161 guibg=NONE
    hi SpellBad gui=undercurl guisp=NONE guifg=NONE guibg=#260808
    hi SpellCap gui=undercurl guisp=NONE guifg=NONE guibg=NONE
    hi SpellLocal gui=undercurl guisp=NONE guifg=NONE guibg=#082608
    hi SpellRare gui=undercurl guisp=NONE guifg=NONE guibg=#262626
    hi Statement gui=NONE guifg=#8f8f8f guibg=NONE
    hi StatusLine gui=NONE guifg=#9e9e9e guibg=#262626
    hi StatusLineNC gui=NONE guifg=#707070 guibg=#262626
    hi StorageClass gui=NONE guifg=#8f8f8f guibg=NONE
    hi String gui=NONE guifg=#808080 guibg=NONE
    hi TabLine gui=NONE guifg=#707070 guibg=#262626
    hi TabLineFill gui=NONE guifg=NONE guibg=#262626
    hi TabLineSel gui=NONE guifg=#9e9e9e guibg=#262626
    hi Title gui=NONE guifg=#808080 guibg=NONE
    hi Todo gui=standout guifg=NONE guibg=NONE
    hi Type gui=NONE guifg=#8f8f8f guibg=NONE
    hi Underlined gui=NONE guifg=NONE guibg=NONE
    hi VertSplit gui=NONE guifg=#333333 guibg=NONE
    hi Visual gui=NONE guifg=NONE guibg=#333333
    hi VisualNOS gui=NONE guifg=NONE guibg=NONE
    hi WarningMsg gui=NONE guifg=NONE guibg=#260808
    hi WildMenu gui=NONE guifg=NONE guibg=#525252
    hi lCursor gui=NONE guifg=NONE guibg=NONE
    hi Identifier gui=NONE guifg=NONE guibg=NONE
    hi PreProc gui=NONE guifg=NONE guibg=NONE

    hi Delimiter gui=NONE guifg=#616161 guibg=NONE
    hi Operator gui=NONE guifg=#616161 guibg=NONE
endif

" Treesitter captures. Neovim links most of them onto the legacy groups above
" already, so only the gaps and the ones that read badly are set here. Vim 9
" warns with W18 on these group names, hence the guard.
if has("nvim")
    if &background == "light"
        hi @variable gui=NONE guifg=#000000 guibg=NONE
        hi @punctuation.delimiter gui=NONE guifg=#707070 guibg=NONE
        hi @punctuation.bracket gui=NONE guifg=#707070 guibg=NONE
        hi @constructor gui=NONE guifg=#3E53C3 guibg=NONE
        " Docstrings read as prose rather than as strings
        hi @string.documentation gui=NONE guifg=#7c7979 guibg=NONE
        hi @tag.attribute gui=NONE guifg=#308585 guibg=NONE
        hi @tag.delimiter gui=NONE guifg=#707070 guibg=NONE

        hi @markup.heading gui=bold guifg=#1631C4 guibg=NONE
        hi @markup.strong gui=bold guifg=NONE guibg=NONE
        hi @markup.italic gui=italic guifg=NONE guibg=NONE
        hi @markup.strikethrough gui=strikethrough guifg=NONE guibg=NONE
        hi @markup.link gui=underline guifg=#3E53C3 guibg=NONE
        hi @markup.link.label gui=NONE guifg=#3E53C3 guibg=NONE
        hi @markup.link.url gui=underline guifg=#707070 guibg=NONE
        hi @markup.quote gui=NONE guifg=#7c7979 guibg=NONE
        hi @markup.raw gui=NONE guifg=#CB5C00 guibg=NONE
        hi @markup.list gui=NONE guifg=#00B4B4 guibg=NONE
        hi @markup.math gui=NONE guifg=#94007e guibg=NONE
    else
        hi @variable gui=NONE guifg=#b0b0b0 guibg=NONE
        hi @punctuation.delimiter gui=NONE guifg=#616161 guibg=NONE
        hi @punctuation.bracket gui=NONE guifg=#616161 guibg=NONE
        hi @string.documentation gui=NONE guifg=#707070 guibg=NONE
        hi @tag.delimiter gui=NONE guifg=#616161 guibg=NONE

        hi @markup.heading gui=bold guifg=#9e9e9e guibg=NONE
        hi @markup.strong gui=bold guifg=NONE guibg=NONE
        hi @markup.italic gui=italic guifg=NONE guibg=NONE
        hi @markup.strikethrough gui=strikethrough guifg=NONE guibg=NONE
        hi @markup.link gui=underline guifg=#8f8f8f guibg=NONE
        hi @markup.quote gui=NONE guifg=#707070 guibg=NONE
        hi @markup.raw gui=NONE guifg=#808080 guibg=NONE
        hi @markup.list gui=NONE guifg=#8f8f8f guibg=NONE
    endif
endif
