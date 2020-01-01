" vimrc ------------------------------------------------------------------------
"
" See README.md for setup and basic history
"
" tips:
"  http://rayninfo.co.uk/vimtips.html (copied locally)
"  https://github.com/romainl/idiomatic-vimrc/blob/master/idiomatic-vimrc.vim
"  https://stevelosh.com/blog/2010/09/coming-home-to-vim/
"  https://begriffs.com/posts/2012-09-10-bespoke-vim.html
"
" nice digraph help page:
"  :help digraph-table
"
" ⯅ ⯆ ⯇ ⯈
" 🔒  🔑  + ∄ Ξ

filetype off
"packloadall " normally done after loading vimrc, uncomment to load earlier
filetype plugin indent on
syntax on

let mapleader=","
let maplocalleader=","

if !exists("g:os")
	if has("win64") || has("win32") || has("win16")
		let g:os="Windows"
	else
		let g:os=substitute(system('uname'), '\n', '', '')
	endif
endif
if !exists("g:VimUserDir")
	let g:VimUserDir=split(&rtp, ',')[0]
endif

" base options, see `:options {{{
"  1 important
set nocompatible
"  2 moving around, searching and patterns
set wrap
set incsearch
set ignorecase
set smartcase
"  3 tags
set tags+=tags;/
"  4 displaying text
set scrolloff=5
set nolinebreak
set showbreak=↵
set sidescroll=1
set sidescrolloff=10
set lazyredraw
set list
"set listchars=tab:\ \ ,trail:⌴,precedes:❮,extends:❯
set listchars=tab:\ \ ,trail:_,precedes:❮,extends:❯
set listchars+=tab:⋮\ 
set nonumber
set norelativenumber
"  5 syntax, highlighting and spelling
set synmaxcol=333
set hlsearch
set colorcolumn=+1
let &spellfile="$HOME/.dict.utf-8.add,.dict.utf-8.add"
"  6 multiple windows
set laststatus=2
set hidden " buffers hidden when abandoned
set splitbelow
set splitright
"  7 multiple tab pages
"  8 terminal
set ttyfast
set title
"  9 using the mouse
" 10 GUI
" 11 printing
" 12 messages and info
set showcmd
set noshowmode " lightline makes this redundant
set ruler
set visualbell
" 13 selecting text
set clipboard=unnamed
" 14 editing text
set undofile
set undodir=~/.tmp/undo/
set undoreload=20000 " save the reload unless > #lines
set textwidth=100
set backspace=indent,eol,start
set formatoptions=cqrn1j
set dictionary=/usr/share/dict/words
set showmatch
set matchtime=3
" 15 tabs and indenting
set tabstop=8
set shiftwidth=8
set softtabstop=8
set shiftround
set noexpandtab
set autoindent
" 16 folding
set foldmethod=marker
set foldmarker={{{,}}}
" 17 diff mode
" 18 mapping
" time out on key codes but not mappings
set notimeout
set ttimeout
set ttimeoutlen=10
" 19 reading and writing files
set modelines=2
set backup
set backupskip=/tmp/*,/private/tmp/*,~/.tmp/*
set backupdir=~/.tmp/backup/
set autowriteall
set noautoread
" 20 the swap file
set directory=~/.tmp/swap/
set swapfile
" 21 command line editing
set history=9999
set wildmode=full
set wildignore+=.hg,.git,.svn
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg
set wildignore+=*.class,*.jar,*.war
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest
set wildignore+=*.spl
set wildignore+=*.sw?
set wildignore+=*.DS_Store
set wildignore+=*.pyc
set wildmenu
" 22 executing external commands
" 23 running make and jumping to errors
" 24 language specific
" 25 multi-byte characters
" 26 various
set virtualedit+=block
set gdefault
set viminfo=%,'999,/99,:999
" }}}


" behavior ---------------------------------------------------------------------

" make sure vim returns to the same line when you reopen a file
augroup line_return
	au!
	au BufReadPost *
		\ if line("'\"") > 0 && line("'\"") <= line("$") |
		\     execute 'normal! g`"zvzz' |
		\ endif
augroup END

" save all buffers when focus is lost
au FocusLost * :silent! wa

" treat buffers from stdin (e.g.: echo foo | vim -) as scratch
au StdinReadPost * :set buftype=nofile

" the . to execute once for each line of a visual selection
vnoremap . :normal .<cr>
" and same for macros
vnoremap <Leader>@ :normal @

" don't move on first *
nnoremap <silent> * :let stay_star_view=winsaveview()<cr>*:call winrestview(stay_star_view)<cr>

" resize panes when window/terminal gets resize
au VimResized * :wincmd =

" folding is overrated imo
set foldlevelstart=0
set foldtext=MyFoldText()
" recursively open whatever fold we're in
nnoremap zO zczO

function! MyFoldText()
	let line=getline(v:foldstart)

	let nucolwidth=&fdc + &number * &numberwidth
	let windowwidth=winwidth(0) - nucolwidth - 3
	let foldedlinecount=v:foldend - v:foldstart

	" expand tabs into spaces
	let onetab=strpart('          ', 0, &tabstop)
	let line=substitute(line, '\t', onetab, 'g')

	let line=strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
	let fillcharcount=windowwidth - len(line) - len(foldedlinecount)
	return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction


" mappings ---------------------------------------------------------------------

" if you have a macbook w/o escape key, see karabiner solution (in specifict config)
" briefly: grave_accent_and_tilde -> esc
"          fn/ctl + grave_accent_and_tilde -> grave_accent_and_tilde
" also, this always works for escape in VIM: <C-[> or <C-c>

" toggle options
nnoremap <Leader>S :setlocal spell!<cr>
nnoremap <Leader>N :setlocal number!<cr>
nnoremap <Leader>P :set paste!<cr>

" natural move
nnoremap <down> gj
nnoremap <up> gk

" keep the cursor in place while joining lines
nnoremap J mzJ`z
" split line (sister to [J]oin lines)
nnoremap S i<cr><Esc>^mwgk:silent! s/\v +$//<cr>:noh<cr>`w

" add to local dictionary (see spellfile setting, the #2 is the local)
nnoremap zG 2zg

" display the number of matches for the last search
nmap <Leader>/ :%s:<C-R>/::gn<cr>

nnoremap <Leader>L :call FocusLine()<cr>

" half/double spaces, clear trailing spaces
noremap <Leader>W1 mz:%s;^\(\s\+\);\=repeat('	', len(submatch(0))/2);<cr>:%s/\s\+$//<cr>:let @/=''<cr>`z
noremap <Leader>W2 mz:%s;^\(\s\+\);\=repeat('	', len(submatch(0))*2);<cr>:%s/\s\+$//<cr>:let @/=''<cr>`z
noremap <Leader>W0 mz:set ts=4 sts=4 et<cr>:retab<cr>:set ts=8 sts=2 noet<cr>:%s;^\(\s\+\);\=repeat('	', len(submatch(0))/2);<cr>:%s/\s\+$//<cr>:let @/=''<cr>`z

" clean trailing whitespace in entire file
nnoremap <Leader>WW mz:%s/\s\+$//<cr>:let @/=''<cr>`z

" zip right, this should preserve your last yank/delete as well
nnoremap zl :let @z=@"<cr>x$p:let @"=@z<cr>

" underline the current line
nnoremap <Leader>1 yypVr=

" uppercase word in insert mode
inoremap <C-u> <Esc>mzgUiw`za

" panic
nnoremap <F9> mzggg?G`z

command! RemoveFancyCharacters :call RemoveFancyCharacters()

" show syntax group(s)
nmap <Leader>ss :call <SID>SynStack()<cr>
" show highlight group(s)
nnoremap <Leader>syn :echo "hi<"
	\ . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
	\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
	\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<cr>

nnoremap <silent> <Leader>h0 :call ClearInterestingWords()<cr>
nnoremap <silent> <Leader>h1 :call HiInterestingWord(1)<cr>
nnoremap <silent> <Leader>h2 :call HiInterestingWord(2)<cr>
nnoremap <silent> <Leader>h3 :call HiInterestingWord(3)<cr>
nnoremap <silent> <Leader>h4 :call HiInterestingWord(4)<cr>
nnoremap <silent> <Leader>h5 :call HiInterestingWord(5)<cr>
nnoremap <silent> <Leader>h6 :call HiInterestingWord(6)<cr>

" listchars
nnoremap <Leader>I :set listchars+=tab:⋮\ <cr>
nnoremap <Leader>i :set listchars-=tab:⋮\ <cr>
"nnoremap <Leader>I :set listchars+=tab:▸‧<cr>
"nnoremap <Leader>i :set listchars-=tab:▸‧<cr>

" select (charwise) the contents of the current line, excluding indentation.
nnoremap vv ^vg_

" custom copy/paste using tmp file
vmap <Leader>C :w! ~/.tmp/.pbuf<cr>
nmap <Leader>V :r ~/.tmp/.pbuf<cr>

" quickfix/location list
noremap ]q :cn<cr>
noremap [q :cp<cr>
noremap ]Q :cnew<cr>
noremap [Q :col<cr>
noremap ]l :ln<cr>
noremap [l :lp<cr>

" tags https://github.com/grassdog/dotfiles/blob/master/files/.ctags

" buffer nav, fzf
nnoremap <Leader><Space> <C-^>
nmap <Leader>, :Buffers<cr>
nmap <Leader>f :GFiles<cr>
nmap <Leader>F :Files<cr>
nmap <Leader>g :Find<cr>
nmap <Leader>t :BTags<cr>
nmap <Leader>T :Tags<cr>
" https://medium.com/@crashybang/supercharge-vim-with-fzf-and-ripgrep-d4661fc853d2
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

" mkdir dir(s) that contains the file in the current buffer
nnoremap <Leader>MD :!mkdir -p %:p:h<cr>

" URL encode/decode selection
vnoremap <leader>e :!python -c 'import sys,urllib;print urllib.quote(sys.stdin.read().strip())'<cr>
vnoremap <leader>E :!python -c 'import sys,urllib;print urllib.unquote(sys.stdin.read().strip())'<cr>


" functions --------------------------------------------------------------------

" Focus/pulse the current line wiping out z mark, moves line 25 above center.
" Closes all folds and opens the folds containing the current line.

function! FocusLine()
	let oldscrolloff=&scrolloff
	set scrolloff=0
	execute "keepjumps normal! mzzMzvzt25\<c-y>`z:call PulseCursorLine()\<cr>"
	let &scrolloff=oldscrolloff
endfunction

" Pulse cursor line
" https://github.com/JessicaKMcIntosh/Vim/blob/master/plugin/pulse.vim

hi CursorLine guibg=NONE ctermbg=NONE

if has("termguicolors") || has('gui_running')
	let g:PulseColorList=['#ff0000','#00ff00','#0000ff','#ff0000']
	"let g:PulseColorList=['#2a2a2a','#333333','#3a3a3a','#444444','#4a4a4a' ]
	let g:PulseColorattr='guibg'
else
	let g:PulseColorList=['160','40','123','160']
	"let g:PulseColorList=['233','234','235','236','237']
	let g:PulseColorattr='ctermbg'
endif

function! PulseCursorLine()
	set cursorline
	for pulse in g:PulseColorList
		execute 'hi CursorLine ' . g:PulseColorattr . '=' . pulse
		redraw
		sleep 12m
	endfor
	"for pulse in reverse(copy(g:PulseColorList))
	"	execute 'hi CursorLine ' . g:PulseColorattr . '=' . pulse
	"	redraw
	"	sleep 9m
	"endfor
	execute 'hi CursorLine ' . g:PulseColorattr . '=NONE'
	set nocursorline
endfunction

function! <SID>SynStack()
	echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), " > ")
endfunc

function! RemoveFancyCharacters()
	let typo={}
	let typo["“"]='"'
	let typo["”"]='"'
	let typo["‘"]="'"
	let typo["’"]="'"
	let typo["–"]='--'
	let typo["—"]='---'
	let typo["…"]='...'
	:exe ":%s/".join(keys(typo), '\|').'/\=typo[submatch(0)]/ge'
endfunction

" Highlight words temporarily
" http://vim.wikia.com/wiki/Highlight_multiple_words

function! HiInterestingWordDef()
	hi def InterestingWord1 guifg=#000000 ctermfg=16 guibg=#aeee00 ctermbg=154
	hi def InterestingWord2 guifg=#000000 ctermfg=16 guibg=#ff9eb8 ctermbg=211
	hi def InterestingWord3 guifg=#000000 ctermfg=16 guibg=#ffa724 ctermbg=214
	hi def InterestingWord4 guifg=#000000 ctermfg=16 guibg=#b88853 ctermbg=137
	hi def InterestingWord5 guifg=#000000 ctermfg=16 guibg=#8cffba ctermbg=121
	hi def InterestingWord6 guifg=#000000 ctermfg=16 guibg=#ff2c4b ctermbg=195
endfunction

function! HiInterestingWord(n)
	call HiInterestingWordDef()

	" Save our location.
	normal! mz

	" Yank the current word into the z register.
	normal! "zyiw

	" Calculate an arbitrary match ID.  Hopefully nothing else is using it.
	let mid=86750 + a:n

	" Clear existing matches, but don't worry if they don't exist.
	silent! call matchdelete(mid)

	" Construct a literal pattern that has to match at boundaries.
	let pat='\V\<' . escape(@z, '\') . '\>'

	" Actually match the words.
	call matchadd("InterestingWord" . a:n, pat, 1, mid)

	" Move back to our original location.
	normal! `z
endfunction

function! ClearInterestingWords()
	silent! call matchdelete(86751)
	silent! call matchdelete(86752)
	silent! call matchdelete(86753)
	silent! call matchdelete(86754)
	silent! call matchdelete(86755)
	silent! call matchdelete(86756)
endfunction

" abbrev helpers

function! EatChar(pat)
	let c=nr2char(getchar(0))
	return (c =~ a:pat) ? '' : c
endfunction

" delete the space after, so: abbrev<space> -> expansion
function! MakeSpacelessIabbrev(from, to) " global
	execute "iabbrev <silent> ".a:from." ".a:to."<C-R>=EatChar('\\s')<cr>"
endfunction
function! MakeSpacelessBufferIabbrev(from, to) " buffer local
	execute "iabbrev <silent> <buffer> ".a:from." ".a:to."<C-R>=EatChar('\\s')<cr>"
endfunction


" settings/plugins -------------------------------------------------------------

set complete=.,w,b,u,t,i
set completeopt=menuone,preview

" complete-functions ins-completion
inoremap <C-]> <C-x><C-]>
" http://tilvim.com/2016/01/06/fzf.html
imap <C-l> <Plug>(fzf-complete-line)

" windows movements
nmap <silent> <C-h> :wincmd h<cr>
nmap <silent> <C-l> :wincmd l<cr>
nmap <silent> <C-j> :wincmd j<cr>
nmap <silent> <C-k> :wincmd k<cr>
nnoremap <Esc>l :redraw!<cr> " remap default <C-l>

" supertab
let g:SuperTabDefaultCompletionType="context"
let g:SuperTabMappingForward='<C-n>'
let g:SuperTabMappingBackward='<C-p>'
let g:SuperTabClosePreviewOnPopupClose=1

" fzf
set rtp+=~/bin/.fzf/bin

" ack
let g:ackprg='rg --vimgrep --smart-case --no-heading'
"let g:ackprg='ag --vimgrep'
let g:ack_apply_qmappings=1
let g:ackhighlight=1

nnoremap <Leader>G :Ack!<Space>""<left>
xnoremap <Leader>G y:Ack!<Space>"<C-r>""
xnoremap <silent> <Leader>g y:Ack!<Space>"<C-r>"" -w<cr>

"netrw
" The directory for bookmarks and history (.netrwbook, .netrwhist)
let g:netrw_home='$HOME/.tmp'
let g:netrw_liststyle=3

" Kwbd
nmap <Leader>q <Plug>Kwbd

" `%%` is (command mode) abbrev for current directory
cabbr <expr> %% expand('%:p:h')

" http://eclim.org/vim/core/eclim.html
let g:EclimQuickfixSignText='⯈'
let g:EclimLoclistSignText='⯈'

let g:EclimHighlightError='ErrorMsg'     " (Default: “Error”)
let g:EclimHighlightWarning='WarningMsg' " (Default: “WarningMsg”)
let g:EclimHighlightInfo='Statement'     " (Default: “Statement”)
let g:EclimHighlightDebug='Normal'       " (Default: “Normal”)
let g:EclimHighlightTrace='Normal'       " (Default: “Normal”)

" eclim mappings
au FileType java nnoremap <buffer> <silent> <Leader>v :silent! w<cr>:Validate<cr>
au FileType java inoremap <buffer> <silent> <Leader>v <Esc>:silent! w<cr>:Validate<cr>
au FileType java nnoremap <silent> <Leader>jc :JavaCorrect<cr>
au FileType java nnoremap <silent> <Leader>jd :JavaDocSearch -x declarations<cr>
au FileType java nnoremap <silent> <Leader>jh :JavaCallHierarchy<cr>
au FileType java nnoremap <silent> <Leader>ji :JavaImport<cr>
au FileType java nnoremap <silent> <Leader>jI :JavaImportOrganize<cr>

" Customize compiler options and code assists of the server under your project folder.
"  Modify the file `.settings/org.eclipse.jdt.core.prefs` with options presented at:
"  https://help.eclipse.org/neon/topic/org.eclipse.jdt.doc.isv/reference/api/org/eclipse/jdt/core/JavaCore.html.
"let g:ale_java_javalsp_executable=expand('~/bin/eclipse-jdtls')

" ale-java-eclipselsp using eclipse.jdt.ls
"let g:ale_java_eclipselsp_path=expand('~/bin/eclipse.jdt.ls')
"let g:ale_java_eclipselsp_config_path=expand('~/bin/eclipse.jdt.ls/config_linux')
"let g:ale_java_eclipselsp_workspace_path=expand('~/workspace')
"let g:ale_disable_lsp=1

" go
let g:go_fmt_command="goimports"
let g:go_fmt_experimental=1
let g:go_doc_keywordprg_enabled=0

" clam
let g:clam_autoreturn=1
let g:clam_debug=1
let g:clam_winpos='botright'

nnoremap ! :Clam<Space>
vnoremap ! :ClamVisual<Space>

" dbext
let g:dbext_default_prompt_for_parameters=0 " globally turn off input prompt
let g:dbext_default_buffer_lines=27 " size of Result buffer window (default is 5)
let g:dbext_default_history_file='$HOME/.tmp/.dbext_history'
let g:dbext_default_type='PGSQL'
let g:dbext_default_profile_PG='type=PGSQL'

" fugitive
au BufNewFile,BufRead .git/index setlocal nolist

" ale

let g:polyglot_disabled=['java']

" using eclim for java
let g:ale_linters={
	\ 'java': [],
	\ 'python': ['flake8', 'mypy']
	\ }

"let g:ale_lint_on_save=1
"let g:ale_lint_on_text_changed=0
"let g:ale_lint_on_enter=0

"let g:ale_sign_error='>>'
"let g:ale_sign_warning='>'
let g:ale_sign_error='⦿'
let g:ale_sign_warning='⦿'

"let g:ale_echo_msg_error_str='E'
"let g:ale_echo_msg_warning_str='W'
"let g:ale_echo_msg_format='[%linter%] %s [%severity%]'

"nmap <silent> <Leader>k <Plug>(ale_previous_wrap)
"nmap <silent> <Leader>j <Plug>(ale_next_wrap)


" filetype/plugins -------------------------------------------------------------

" only set (local) this if you want something different
set textwidth=99

" highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

au Filetype qf setlocal number colorcolumn=0 nolist nowrap tw=0 scrolloff=1

autocmd FileType diff setlocal foldmethod=expr
autocmd FileType diff setlocal foldexpr=DiffFoldLevel()

" https://github.com/sgeb/vim-diff-fold/ without the extra settings crap. Ie just the folding expr
function! DiffFoldLevel()
	let l:line=getline(v:lnum)

	if l:line =~# '^\(diff\|Index\)'     " file
		return '>1'
	elseif l:line =~# '^\(@@\|\d\)'  " hunk
		return '>2'
	elseif l:line =~# '^\*\*\* \d\+,\d\+ \*\*\*\*$' " context: file1
		return '>2'
	elseif l:line =~# '^--- \d\+,\d\+ ----$' " context: file2
		return '>2'
	else
		return '='
	endif
endfunction

" JSON formating is generally useful, jq leaves order and is fast, py is slow and sorts the keys
vnoremap <leader>jq :!jq '.'<cr>
vnoremap <leader>jr :!jq -r '.'<cr>
vnoremap <leader>jp :!python -mjson.tool<cr>

augroup ft_text
	au!
	au Filetype text setlocal spell
augroup END

augroup ft_vim
	au!
	au FileType vim inoremap <c-n> <c-x><c-n>
augroup END

augroup ft_java
	au!
	au FileType java setlocal foldmethod=marker
	au FileType java setlocal foldmarker={{{,}}}

	au FileType java call MakeSpacelessBufferIabbrev('LOG.', 'private static final Logger LOG = LogManager.getLogger();<left><left>')

	au FileType java call MakeSpacelessBufferIabbrev('pr.', 'org.apache.logging.log4j.LogManager.getLogger(this.getClass()).info(">>> {}", );<left><left>')
	au FileType java call MakeSpacelessBufferIabbrev('slf.', 'org.slf4j.LoggerFactory.getLogger(this.getClass()).info(">>> {}", );<left><left>')
	au FileType java call MakeSpacelessBufferIabbrev('sb.', 'org.apache.commons.lang3.builder.ReflectionToStringBuilder.toString()<left>')

	" abbreviations
	au FileType java call MakeSpacelessBufferIabbrev('lm.', 'List<Map<>><left><left>')
	au FileType java iabbrev <buffer> lmso. List<Map<String, Object>>
	au FileType java iabbrev <buffer> mso. Map<String, Object>
	au FileType java iabbrev <buffer> implog. import org.apache.logging.log4j.Logger;import org.apache.logging.log4j.LogManager;<esc><down>
	au FileType java iabbrev <buffer> imppre. import static com.google.common.base.Preconditions.checkArgument;import static com.google.common.base.Preconditions.checkNotNull;import static com.google.common.base.Preconditions.checkState;<esc><down>
	au FileType java iabbrev <buffer> tostr.  @Overridepublic String toString() {return ReflectionToStringBuilder.toString(this, ToStringStyle.SHORT_PREFIX_STYLE);<esc><down>
augroup END

augroup ft_javascript
	au!
	au FileType javascript call MakeSpacelessBufferIabbrev('pr.', "console.log(`>>> ${}`);<left><left><left><left>")
augroup END

augroup ft_python
	au!
	" pep8 settings (except tw=78)
	au FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
	au FileType python setlocal nowrap
	"au FileType python setlocal define=^\s*\\(def\\\\|class\\)

	" simpylfold
	let g:SimpylFold_fold_docstring=1
	let g:SimpylFold_fold_import=1

	au FileType python nnoremap <localleader>e :w<cr>:Clam python %:p<cr>
	au FileType python nnoremap <localleader>E :w<cr>:Clam python <C-R>=expand("%:p")<cr>

	" yapf doesn't work w/ gq generally (only formats complete blocks)
	let g:yapf_style="pep8"
	au FileType python nnoremap <buffer> <localleader>p ^vg_:!yapf<cr>
	au FileType python vnoremap <buffer> <localleader>p :!yapf<cr>

	au FileType python call MakeSpacelessBufferIabbrev('pr.', "print(f'>>> {}')<left><left><left>")
augroup END

augroup ft_ipynb
	au!
	au FileType ipynb setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab

	au Filetype ipynb nnoremap <buffer> <localleader>p :w<cr>:!gfm % \|bcat<cr>
augroup END

augroup ft_go
	au!
	au FileType go setlocal foldmethod=syntax
	au FileType go nnoremap <buffer> <silent> M :GoDoc<cr>
	" this language is incredible
	au FileType go iabbrev <buffer> ernil if err != nil {<cr>return nil, err<esc>jA
	" }
augroup END

augroup ft_postgres
	au!
	au BufNewFile,BufRead *.sql set filetype=pgsql
	au BufNewFile,BufRead *.pgsql set filetype=pgsql

	au FileType pgsql setlocal foldmethod=marker
	au FileType pgsql setlocal foldmarker={{{,}}}

	au FileType pgsql setlocal commentstring=--\ %s comments=:--

	au FileType pgsql setl formatprg=pg_format\ -

	" send to tmux with localleader e
	"au FileType pgsql nnoremap <buffer> <silent> <localleader>e :let psql_tslime_view=winsaveview()<cr>vip"ry:call SendToTmux(@r)<cr>:call winrestview(psql_tslime_view)<cr>

	" kill pager with q
	"au FileType pgsql nnoremap <buffer> <silent> <localleader>q :call SendToTmuxRaw("q")<cr>
augroup END

augroup ft_html
	au!
	au FileType html setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	au Filetype html nnoremap <buffer> <localleader>p :w<cr>:!open %<cr>
	au FileType html.mustache setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	au Filetype html.mustache nnoremap <buffer> <localleader>p :w<cr>:!open %<cr>
augroup END

augroup ft_markdown
	au!
	au Filetype markdown setlocal spell
	au FileType markdown setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab

	" Linkify selected text inline to contents of pasteboard.
	au Filetype markdown vnoremap <buffer> <localleader>l <esc>`>a]<esc>`<i[<esc>`>lla()<esc>"+P

	au Filetype markdown nnoremap <buffer> <localleader>p :w<cr>:!gfm % \|bcat<cr>
augroup END

augroup ft_json
	au!
	au FileType json setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

	au FileType json setlocal formatprg=jq\ '.'
augroup END

augroup ft_xml
	au!
	au FileType xml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

	au FileType xml setlocal foldmethod=manual
	" use <localleader>F to fold the current tag
	au FileType xml nnoremap <buffer> <localleader>F Vatzf
	" Indent tag
	au FileType xml nnoremap <buffer> <localleader>= Vat=
augroup END

augroup ft_yaml
	au!
	au FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
augroup END

augroup ft_muttrc
	au!
	au BufRead,BufNewFile *.muttrc set ft=muttrc
	au FileType muttrc setlocal foldmethod=marker foldmarker={{{,}}}
augroup END

" clojure/fireplace/paredit -----

let g:clojure_fold_extra=[
	\ 'defgauge',
	\ 'defsketch'
	\ ]

let g:fireplace_no_maps=1

let g:paredit_smartjump=1
let g:paredit_shortmaps=0
let g:paredit_electric_return=1

let g:paredit_matchlines=200
let g:paredit_disable_lisp=1
let g:paredit_disable_clojure=1

augroup ft_clojure
	au!

	au BufNewFile,BufRead *.edn set filetype=clojure

	au FileType clojure silent! call TurnOnClojureFolding()
	au FileType clojure compiler clojure
	au FileType clojure setlocal isk-=.

	au FileType clojure iabbrev <buffer> defun defn

	" Things that should be indented 2-spaced
	au FileType clojure setlocal lispwords+=when-found,defform,when-valid,try,while-let,try+,throw+

	"au FileType clojure RainbowParenthesesActivate
	"au syntax clojure RainbowParenthesesLoadRound

	" Paredit
	au FileType clojure call EnableParedit()
	au FileType clojure nnoremap <buffer> <localleader>( :call PareditToggle()<cr>
	" )

	" Duplicate
	au FileType clojure nnoremap <buffer> [] :call DuplicateLispForm()<cr>

	" Indent top-level form.
	au FileType clojure nmap <buffer> gi mz99[(v%='z
augroup END

function! EnableParedit()
	call PareditInitBuffer()

	" Quit fucking with my split-line mapping, paredit.
	nunmap <buffer> S

	" Also quit fucking with my save file mapping.
	nunmap <buffer> s

	" Please just stop
	nunmap <buffer> <leader>W
	nunmap <buffer> <leader>O
	nunmap <buffer> <leader>S

	" Oh my god will you fuck off already
	" nnoremap <buffer> dp :diffput<cr>
	" nnoremap <buffer> do :diffobtain<cr>

	" Eat shit
	nunmap <buffer> [[
	nunmap <buffer> ]]

	" Better mappings
	noremap <buffer> () :<c-u>call PareditWrap("(", ")")<cr>
	noremap <buffer> )( :<c-u>call PareditSplice()<cr>
	noremap <buffer> (( :<c-u>call PareditMoveLeft()<cr>
	noremap <buffer> )) :<c-u>call PareditMoveRight()<cr>
	noremap <buffer> (j :<c-u>call PareditJoin()<cr>
	noremap <buffer> (s :<c-u>call PareditSplit()<cr>
	noremap <buffer> )j :<c-u>call PareditJoin()<cr>
	noremap <buffer> )s :<c-u>call PareditSplit()<cr>
	" ))
endfunction


" ui/colorscheme ---------------------------------------------------------------
" note, other config/plugins can change the colors

" show trailing spaces in non-insert mode
augroup trailing
	au!
	"au InsertEnter * :set listchars-=trail:⌴
	"au InsertLeave * :set listchars+=trail:⌴
	au InsertEnter * :set listchars-=trail:_
	au InsertLeave * :set listchars+=trail:_
augroup END

" lightline

let g:lightline={
	\ 'colorscheme': 'my',
	\ 'separator': { 'left': '', 'right': '' },
	\ 'subseparator': { 'left': '│', 'right': '⋮' }
	\ }

" ----- colors/highlights/cursors

"set notermguicolors " not available for terminal.app :(

" tmux, see :h xterm-true-color
let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"

" italics, check if your terminal supports italics: echo -e "\e[3mfoo\e[23m"
" https://www.reddit.com/r/vim/comments/24g8r8/italics_in_terminal_vim_and_tmux/
" https://apple.stackexchange.com/a/267261
set t_ZH=[3m
set t_ZR=[23m

hi Comment gui=italic cterm=italic
hi SpellBad cterm=undercurl,italic guifg=#d33682

" 117 matches lightline (also can use 24, 31)
autocmd InsertEnter * hi ColorColumn ctermbg=117 guibg=#87dfff
autocmd InsertLeave * hi ColorColumn ctermbg=7 guibg=#eee8d5

" colorscheme settings
let ayucolor='light'
let g:monokai_term_italic=1
let g:monokai_gui_italic=1
let g:nord_italic=1
let g:sublimemonokai_term_italic=1
let g:sublimemonokai_gui_italic=1

" gui options
set guicursor=n-c:block-Cursor-blinkon0
set guicursor+=v:block-blinkon0
set guicursor+=i-ci:ver20
" default windows (new term): n-v-c:block-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,sm:block-Cursor-blinkwait175-blinkoff150-blinkon175
"set guioptions=e
" default windows (new term): aegimrLtT

function! ColorSet(...)
	if a:0 > 0
		execute 'colorscheme ' . a:1
	endif

	" NonText for [eol, extends, precedes]; SpecialKey for [nbsp, tab, trail]
	hi! link SignColumn LineNr
	" ale
	hi! link ALEErrorSign ErrorMsg
	hi! link ALEWarningSign WarningMsg
endfunction
function! ColorSolarized()
	" for terminal.app, use https://github.com/tomislav/osx-terminal.app-colors-solarized
	let g:solarized_contrast='normal' " normal/high/low
	let g:solarized_visibility='low'  " normal/high/low
	colorscheme solarized8
	hi Cursor guibg=#f92672
	hi Search guifg=#f0c674
	if &background == 'light'
		hi SpecialKey ctermfg=6 guifg=#ded8b5
		hi NonText ctermfg=178 guifg=#ffd885
		hi WarningMsg ctermbg=7 guibg=#eee8d5
	else
		hi SpecialKey ctermfg=10 guifg=#586e75
		hi NonText ctermfg=10 guifg=#4996a2
		hi SignColumn ctermbg=0 guibg=#073642
	endif
	call ColorSet()
endfunction
function! ColorNord()
	call ColorSet('nord')
	hi! link SignColumn Folded
endfunction
function! ColorIceberg()
	call ColorSet('iceberg')
	" reverse ErrorMsg
	hi ErrorMsg guibg=#e27878 guifg=#161821
	hi SpecialKey guifg=#444b71
	hi NonText guifg=#89b8c2
endfunction
function! ColorToNBlue()
	call ColorSet('Tomorrow-Night-Blue')
	hi SpecialKey ctermfg=67 guifg=#7285b7
	hi NonText ctermfg=14 guifg=Yellow
	hi LineNr ctermbg=19 ctermfg=67 guifg=#7285b7
endfunction

if &diff
	" better diff colorscheme
	set background=dark
	colorscheme gruvbox
else
	if $TERM_PROFILE == 'Ocean'
		set background=dark
		call ColorToNBlue()

	elseif $TERM_PROFILE == 'Silver_Aerogel'
		set background=light
		call ColorNord()

	elseif !exists("g:colors_name")
		set background=light
		if has("gui_running")
			call ColorSolarized()
		else
			color PaperColor
		endif
	endif
endif

if has("gui_running")
	set mouse=a
endif

if has("transparency")
	set blurradius=15
	au FocusLost * :set transparency=15
	au FocusGained * :set transparency=0
endif

if g:os == "Darwin"
	"set guifont=AnkaCoder-C87-r:h11
	set guifont=SometypeMono-Regular:h11
elseif g:os == "Linux"
	set guifont=Monospace\ 9
	set clipboard=unnamedplus
elseif g:os == "Windows"
	set guifont=monofur:h10
	set guioptions+=a
endif

" http://vim.wikia.com/wiki/Change_cursor_shape_in_different_modes
" DECSCUSR 1/2, 3/4, 5/6 -> blinking/steady block, underline, bar
let &t_SI.="\e[5 q"
"let &t_SR.="\e[4 q"
let &t_EI.="\e[2 q"

" http://vim.wikia.com/wiki/Xterm256_color_names_for_console_Vim
function! CtermColors()
	let num=255
	while num >= 0
		exec 'hi col_'.num.' ctermbg='.num.' ctermfg=white'
		exec 'syn match col_'.num.' "ctermbg='.num.':...." containedIn=ALL'
		call append(0, 'cterm='.num.':....')
		let num=num - 1
	endwhile
endfunction
