
" little crazy, but but for PaperColor ..
" .. startup color
if g:colors_name == "PaperColor"
	color PaperColor
	hi SignColumn guibg=#FFD7FF ctermbg=15
	hi ALEWarningSign term=standout cterm=bold gui=bold guibg=#FFD7FF ctermbg=15 guifg=#00af5f ctermfg=0
	hi ALEErrorSign term=standout cterm=bold gui=bold guibg=#FFD7FF ctermbg=15 guifg=Red ctermfg=9
endif
" .. color changes (error if this is before above)
autocmd ColorScheme PaperColor
	\ | hi SignColumn guibg=#FFD7FF ctermbg=15
	\ | hi ALEWarningSign term=standout cterm=bold gui=bold guibg=#FFD7FF ctermbg=15 guifg=#00af5f ctermfg=0
	\ | hi ALEErrorSign term=standout cterm=bold gui=bold guibg=#FFD7FF ctermbg=15 guifg=Red ctermfg=9

