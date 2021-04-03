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
" 🔒 🔑 ◄ ► ◅ ▻ ◀ ▶ ▲ ▼ ⯇ ⯈ ⯅ ⯆

filetype off
"packloadall " normally done after loading vimrc, uncomment to load earlier
filetype plugin indent on
syntax on

let mapleader=','
let maplocalleader=','

if !exists('g:os')
	if has('win64') || has('win32') || has('win16')
		let g:os='Windows'
	else
		let g:os=substitute(system('uname'), '\n', '', '')
	endif
endif
if !exists('g:VimUserDir')
	let g:VimUserDir=split(&rtp, ',')[0]
endif

" force py3, see https://robertbasic.com/blog/force-python-version-in-vim/
if has('python3')
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
set listchars=tab:\ \ ,trail:⌴,precedes:❮,extends:❯
"set listchars=tab:\ \ ,trail:_,precedes:❮,extends:❯
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
" don't give |ins-completion-menu| messages
set shortmess+=c
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
set textwidth=90
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
" default (4000ms) is too long and noticeable
set updatetime=1000
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

if g:os != 'Darwin'
	" c'mon terminal.app, let's get with the program
	set termguicolors
endif


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
vnoremap . :normal .<CR>
" and same for macros
vnoremap <Leader>@ :normal @

" don't move on first *
nnoremap <silent> * :let stay_star_view=winsaveview()<CR>*:call winrestview(stay_star_view)<CR>

" resize panes when window/terminal gets resize
au VimResized * :wincmd =

" folding ambilvalence
"set foldlevelstart=1


" mappings ---------------------------------------------------------------------

" if you have a macbook w/o escape key, see karabiner solution (in specifict config)
" briefly: grave_accent_and_tilde -> esc
"          fn/ctl + grave_accent_and_tilde -> grave_accent_and_tilde
" also, this always works for escape in VIM: <C-[> or <C-c>

" toggle options
nnoremap <Leader>S :setlocal spell!<CR>
nnoremap <Leader>N :setlocal number!<CR>
nnoremap <Leader>P :set paste!<CR>

" natural move
nnoremap <down> gj
nnoremap <up> gk

" recursively open whatever fold we're in
nnoremap zO zczO

" keep the cursor in place while joining lines
nnoremap J mzJ`z
" split line (sister to [J]oin lines)
nnoremap S i<CR><Esc>^mwgk:silent! s/\v +$//<CR>:noh<CR>`w

" add to local dictionary (see spellfile setting, the #2 is the local)
nnoremap zG 2zg

" display the number of matches for the last search
nmap <Leader>/ :%s:<C-R>/::gn<CR>

" half/double spaces, clear trailing spaces
noremap <Leader>W1 mz:%s;^\(\s\+\);\=repeat('	', len(submatch(0))/2);<CR>:%s/\s\+$//<CR>:let @/=''<CR>`z
noremap <Leader>W2 mz:%s;^\(\s\+\);\=repeat('	', len(submatch(0))*2);<CR>:%s/\s\+$//<CR>:let @/=''<CR>`z
noremap <Leader>W0 mz:set ts=4 sts=4 et<CR>:retab<CR>:set ts=8 sts=2 noet<CR>:%s;^\(\s\+\);\=repeat('	', len(submatch(0))/2);<CR>:%s/\s\+$//<CR>:let @/=''<CR>`z

" clean trailing whitespace in entire file
nnoremap <Leader>WW mz:%s/\s\+$//<CR>:let @/=''<CR>`z

" zip right, this should preserve your last yank/delete as well
nnoremap zl :let @z=@"<CR>x$p:let @"=@z<CR>

" underline the current line
nnoremap <Leader>1 yypVr=

" uppercase word in insert mode
inoremap <C-u> <Esc>mzgUiw`za

" panic
nnoremap <F9> mzggg?G`z

" show syntax group(s)
nmap <Leader>ss :call <SID>SynStack()<CR>
" show highlight group(s)
nnoremap <Leader>syn :echo 'hi<'
	\ . synIDattr(synID(line('.'),col('.'),1),'name') . '> trans<'
	\ . synIDattr(synID(line('.'),col('.'),0),'name') . '> lo<'
	\ . synIDattr(synIDtrans(synID(line('.'),col('.'),1)),'name') . '>'<CR>

nnoremap <silent> <Leader>h0 :call ClearInterestingWords()<CR>
nnoremap <silent> <Leader>h1 :call HiInterestingWord(1)<CR>
nnoremap <silent> <Leader>h2 :call HiInterestingWord(2)<CR>
nnoremap <silent> <Leader>h3 :call HiInterestingWord(3)<CR>
nnoremap <silent> <Leader>h4 :call HiInterestingWord(4)<CR>
nnoremap <silent> <Leader>h5 :call HiInterestingWord(5)<CR>
nnoremap <silent> <Leader>h6 :call HiInterestingWord(6)<CR>

" listchars
nnoremap <Leader>I :set listchars+=tab:⋮\ <CR>
nnoremap <Leader>i :set listchars-=tab:⋮\ <CR>

" select (charwise) the contents of the current line, excluding indentation.
nnoremap vv ^vg_

" custom copy/paste using tmp file
vmap <Leader>C :w! ~/.tmp/.pbuf<CR>
nmap <Leader>V :r ~/.tmp/.pbuf<CR>

" quickfix/location list
noremap <Leader>cq :ccl<CR>
noremap ]q :cn<CR>
noremap [q :cp<CR>
noremap ]Q :cnew<CR>
noremap [Q :cold<CR>

noremap <Leader>cl :lcl<CR>
noremap ]l :ln<CR>
noremap [l :lp<CR>

" tags https://github.com/grassdog/dotfiles/blob/master/files/.ctags

" buffer nav, fzf
nnoremap <Leader><Space> <C-^>
nmap <Leader>, :Buffers<CR>
nmap <Leader>f :GFiles<CR>
nmap <Leader>F :Files<CR>
nmap <Leader>g :Rg<CR>
nmap <Leader>t :BTags<CR>
nmap <Leader>T :Tags<CR>
nmap <Leader>L :Lines<CR>
nmap <Leader>C :Colors<CR>

" mkdir dir(s) that contains the file in the current buffer
nnoremap <Leader>MD :!mkdir -p %:p:h<CR>

" encodings

" URL encode/decode selection
vnoremap <Leader>eu :!python -c 'import sys,urllib;print(urllib.quote(sys.stdin.read().strip()))'<CR>
vnoremap <Leader>eU :!python -c 'import sys,urllib;print(urllib.unquote(sys.stdin.read().strip()))'<CR>
" HTML encode/decode selection
vnoremap <Leader>eh :!python -c 'import sys,html;print(html.escape(sys.stdin.read().strip()))'<CR>
vnoremap <Leader>eH :!python -c 'import sys,html;print(html.unescape(sys.stdin.read().strip()))'<CR>
" JSON formating: jq is fast and leaves key order, py is slower and sorts the keys
" underscore is compact and has lots of options: https://github.com/ddopson/underscore-cli
vnoremap <Leader>ejq :!jq '.'<CR>
vnoremap <Leader>ejr :!jq -r '.'<CR>
vnoremap <Leader>ejp :!python -mjson.tool<CR>
vnoremap <Leader>eju :!underscore print<CR>
" XML formatting:
vnoremap <Leader>ex :!python -c 'import sys;import xml.dom.minidom;s=sys.stdin.read();print(xml.dom.minidom.parseString(s).toprettyxml())'<CR>

" Insert Abbreviations
iabbrev <buffer> :mdash: —
iabbrev <buffer> :shrug: ¯\_(ツ)_/¯


" functions --------------------------------------------------------------------

function! <SID>SynStack()
	echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), " > ")
endfunc

function! RemoveFancyCharacters()
	let typo={}
	let typo['“"]='"'
	let typo['”']='"'
	let typo['‘']="'"
	let typo['’']="'"
	let typo['–']='--'
	let typo['—']='---'
	let typo["…']='...'
	:exe ":%s/".join(keys(typo), '\|').'/\=typo[submatch(0)]/ge'
endfunction
command! RemoveFancyCharacters :call RemoveFancyCharacters()

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
	call matchadd('InterestingWord' . a:n, pat, 1, mid)

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
	execute "iabbrev <silent> ".a:from." ".a:to."<C-R>=EatChar('\\s')<CR>"
endfunction
function! MakeSpacelessBufferIabbrev(from, to) " buffer local
	execute "iabbrev <silent> <buffer> ".a:from." ".a:to."<C-R>=EatChar('\\s')<CR>"
endfunction


" https://stackoverflow.com/a/5519588
function! DiffLineWithNext()
    let f1=tempname()
    let f2=tempname()

    exec ".write " . f1
    exec ".+1write " . f2

    exec "tabedit " . f1
    exec "vert diffsplit " . f2
endfunction


" https://stackoverflow.com/a/5519588
function! DiffLineWithNext()
    let f1=tempname()
    let f2=tempname()

    exec ".write " . f1
    exec ".+1write " . f2

    exec "tabedit " . f1
    exec "vert diffsplit " . f2
endfunction


" settings/plugins -------------------------------------------------------------

set complete=.,w,b,u,t,i
set completeopt=menuone,preview

" complete-functions ins-completion
inoremap <C-]> <C-x><C-]>
" http://tilvim.com/2016/01/06/fzf.html
imap <C-l> <Plug>(fzf-complete-line)

augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END
"nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>

" windows movements
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-l> :wincmd l<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-k> :wincmd k<CR>

" windows redraw
nnoremap <Leader>l :call popup_clear()<CR>:redraw!<CR>


" fzf
set rtp+=~/bin/.fzf/bin

" ack
let g:ackprg='rg --vimgrep --smart-case --no-heading'
"let g:ackprg='ag --vimgrep'
let g:ack_apply_qmappings=1
let g:ackhighlight=1

nnoremap <Leader>G :Ack!<Space>""<left>
xnoremap <Leader>G y:Ack!<Space>"<C-r>""
xnoremap <silent> <Leader>g y:Ack!<Space>"<C-r>"" -w<CR>

"netrw
" The directory for bookmarks and history (.netrwbook, .netrwhist)
let g:netrw_home='$HOME/.tmp'
let g:netrw_list_hide='\(^\|\s\s\)\zs\.\S\+'

" Kwbd
nmap <Leader>Q :up<CR><Plug>Kwbd

" `%%` is (command mode) abbrev for current directory
cabbr <expr> %% expand('%:p:h')

" sneak
let g:sneak#label = 1

" clam
let g:clam_autoreturn=1
let g:clam_debug=1
let g:clam_winpos='botright'

nnoremap ! :Clam<Space>
vnoremap ! :ClamVisual<Space>

" sql
let g:sql_type_default="pgsql"

" fugitive
au BufNewFile,BufRead .git/index setlocal nolist

" polyglot
let g:polyglot_disabled=[]

" ALE

let g:ale_sign_error='▶'
let g:ale_sign_warning='▷'
let g:ale_echo_msg_format='[%linter%] %s'

" ALE provides an omni-completion function you can use for triggering completion manually with <C-x><C-o>
set omnifunc=ale#completion#OmniFunc

" https://www.vimfromscratch.com/articles/vim-and-language-server-protocol/
nmap gd :ALEGoToDefinition<CR>
nmap gr :ALEFindReferences<CR>
nmap K :ALEHover<CR>

" mucomplete
" see: help ft-syntax-omni
autocmd Filetype *
	\ if &omnifunc == "" |
	\	setlocal omnifunc=syntaxcomplete#Complete |
	\ endif


" filetype/plugins -------------------------------------------------------------

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

augroup ft_vim
	au!
	au FileType vim inoremap <c-n> <c-x><c-n>
augroup END

augroup ft_java
	au!
	au FileType java setlocal foldmethod=marker
	au FileType java setlocal foldmarker={{{,}}}

	au FileType java call MakeSpacelessBufferIabbrev(':log:', 'private static final Logger LOG = LogManager.getLogger();<left><left>')
	au FileType java call MakeSpacelessBufferIabbrev(':pr:', 'org.apache.logging.log4j.LogManager.getLogger(this.getClass()).info(">>> {}", );<left><left>')
	au FileType java call MakeSpacelessBufferIabbrev(':slf:', 'org.slf4j.LoggerFactory.getLogger(this.getClass()).info(">>> {}", );<left><left>')
	au FileType java call MakeSpacelessBufferIabbrev(':sb:', 'org.apache.commons.lang3.builder.ReflectionToStringBuilder.toString()<left>')

	" abbreviations
	au FileType java iabbrev <buffer> :implog: import org.apache.logging.log4j.Logger;import org.apache.logging.log4j.LogManager;<esc><down>
	au FileType java iabbrev <buffer> :imppre: import static com.google.common.base.Preconditions.checkArgument;import static com.google.common.base.Preconditions.checkNotNull;import static com.google.common.base.Preconditions.checkState;<esc><down>
	au FileType java iabbrev <buffer> :tostr:  @Overridepublic String toString() {return ReflectionToStringBuilder.toString(this, ToStringStyle.SHORT_PREFIX_STYLE);<esc><down>
augroup END

augroup ft_kotlin
	au!
	au FileType kotlin set tw=100
	au FileType kotlin set makeprg=gw\ build
	au FileType kotlin set errorformat=
		\ "%E%f:%l:%c: error: %m," .
		\ "%W%f:%l:%c: warning: %m," .
		\ "%Eerror: %m," .
		\ "%Wwarning: %m," .
		\ "%Iinfo: %m,"
augroup END

augroup ft_javascript
	au!
	au FileType javascript call MakeSpacelessBufferIabbrev(':pr:', 'console.log(`>>> ${}`);<left><left><left><left>')
augroup END

augroup ft_python
	au!
	" pep8 settings, black is line len of 88
	au FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
	au FileType python setlocal tw=88 nowrap
	"au FileType python setlocal define=^\s*\\(def\\\\|class\\)

	au FileType python nnoremap <localleader>e :up<CR>:Clam python %:p<CR>
	au FileType python nnoremap <localleader>E :up<CR>:Clam python <C-R>=expand("%:p")<CR>

	" yapf doesn't work w/ gq generally (only formats complete blocks)
	let g:yapf_style="pep8"
	"au FileType python nnoremap <buffer> <localleader>f ^vg_:!yapf<CR>
	au FileType python vnoremap <buffer> <localleader>f :!yapf<CR>
augroup END

augroup ft_ipynb
	au!
	au FileType ipynb setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
augroup END

" go
let g:go_fmt_command='goimports'
let g:go_fmt_experimental=1
let g:go_doc_keywordprg_enabled=0

augroup ft_go
	au!
	au FileType go setlocal foldmethod=syntax
	au FileType go nnoremap <buffer> <silent> M :GoDoc<CR>
	" this language is incredible
	au FileType go iabbrev <buffer> ernil if err != nil {<CR>return nil, err<esc>jA
	" }
augroup END

augroup ft_postgres
	au!
	"au FileType pgsql setlocal foldmethod=marker
	"au FileType pgsql setlocal foldmarker={{{,}}}

	"au FileType pgsql setlocal commentstring=--\ %s comments=:--

	"au FileType pgsql setl formatprg=pg_format\ -

	" send to tmux with localleader e
	"au FileType pgsql nnoremap <buffer> <silent> <localleader>e :let psql_tslime_view=winsaveview()<CR>vip"ry:call SendToTmux(@r)<CR>:call winrestview(psql_tslime_view)<CR>

	" kill pager with q
	"au FileType pgsql nnoremap <buffer> <silent> <localleader>q :call SendToTmuxRaw("q")<CR>
augroup END

augroup ft_html
	au!
	au FileType html setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	au Filetype html nnoremap <buffer> <localleader>p :up<CR>:!open %<CR>
	au FileType html.mustache setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	au Filetype html.mustache nnoremap <buffer> <localleader>p :up<CR>:!open %<CR>
augroup END

augroup ft_markdown
	au!
	au Filetype markdown setlocal spell
	au FileType markdown setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab

	" Linkify selected text inline to contents of pasteboard.
	au Filetype markdown vnoremap <buffer> <localleader>l <esc>`>a]<esc>`<i[<esc>`>lla()<esc>"+P

	if g:os == 'Darwin'
		au Filetype markdown nnoremap <buffer> <localleader>p :up<CR>:!gfm % \|bcat<CR>
	else
		au Filetype markdown nnoremap <buffer> <localleader>p :up<CR>:silent !gfm % >~/public_html/tmp.md.html<CR>
			\ :silent redraw!<CR>
			\ :echom "Open http://".system('hostname')[:-2]."/~".$USER."/tmp.md.html"<CR>
	endif
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
	au FileType clojure nnoremap <buffer> <localleader>( :call PareditToggle()<CR>
	" )

	" Duplicate
	au FileType clojure nnoremap <buffer> [] :call DuplicateLispForm()<CR>

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
	nunmap <buffer> <Leader>W
	nunmap <buffer> <Leader>O
	nunmap <buffer> <Leader>S

	" Oh my god will you fuck off already
	" nnoremap <buffer> dp :diffput<CR>
	" nnoremap <buffer> do :diffobtain<CR>

	" Eat shit
	nunmap <buffer> [[
	nunmap <buffer> ]]

	" Better mappings
	noremap <buffer> () :<c-u>call PareditWrap('(', ')')<CR>
	noremap <buffer> )( :<c-u>call PareditSplice()<CR>
	noremap <buffer> (( :<c-u>call PareditMoveLeft()<CR>
	noremap <buffer> )) :<c-u>call PareditMoveRight()<CR>
	noremap <buffer> (j :<c-u>call PareditJoin()<CR>
	noremap <buffer> (s :<c-u>call PareditSplit()<CR>
	noremap <buffer> )j :<c-u>call PareditJoin()<CR>
	noremap <buffer> )s :<c-u>call PareditSplit()<CR>
	" ))
endfunction


" ui/colorscheme ---------------------------------------------------------------
" note, other config/plugins can change the colors

" show trailing spaces in non-insert mode
augroup trailing
	au!
	au InsertEnter * :set listchars-=trail:⌴
	au InsertLeave * :set listchars+=trail:⌴
augroup END

" lightline

let g:lightline={
	\ 'colorscheme': 'myscheme',
	\ 'separator': { 'left': '', 'right': '' },
	\ 'subseparator': { 'left': '│', 'right': '⋮' }
	\ }

" ----- colors/highlights/cursors
" color names: https://codeyarns.github.io/tech/2011-07-29-vim-chart-of-color-names.html
" try: `:h sign`

"set notermguicolors " not available for mac terminal.app :(

" tmux, see :h xterm-true-color
"let &t_8f="\<Esc>[38:2:%lu:%lu:%lum"
"let &t_8b="\<Esc>[48:2:%lu:%lu:%lum"

" italics, check if your terminal supports italics: echo -e "\e[3mfoo\e[23m"
" https://www.reddit.com/r/vim/comments/24g8r8/italics_in_terminal_vim_and_tmux/
" https://apple.stackexchange.com/a/267261
set t_ZH=[3m
set t_ZR=[23m

hi Comment gui=italic cterm=italic
hi SpellBad cterm=undercurl,italic guifg=#d33682

" See http://vim.wikia.com/wiki/Xterm256_color_names_for_console_Vim

" 117 matches lightline (also can use 24, 31)
autocmd InsertEnter * hi ColorColumn ctermbg=117 guibg=#87dfff
" for dark bg, use 236
autocmd InsertLeave * hi ColorColumn ctermbg=254 guibg=#eee8d5

" gui options
set guicursor=n-c:block-Cursor-blinkon0
set guicursor+=v:block-blinkon0
set guicursor+=i-ci:ver20
" default windows (new term): n-v-c:block-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,sm:block-Cursor-blinkwait175-blinkoff150-blinkon175
"set guioptions=e
" default windows (new term): aegimrLtT
set guioptions=egm

" colorscheme settings
let ayucolor='light'
let g:monokai_term_italic=1
let g:monokai_gui_italic=1
let g:nord_italic=1

let g:PaperColor_Theme_Options = {
	\ 'theme': {
	\   'default': {
	\     'transparent_background': 1,
	\     'allow_bold': 1,
	\     'allow_italic': 1
	\   },
	\   'default.light': {
	\     'override' : {
	\       'linenumber_bg' : ['#E9E9E9', '15']
	\     }
	\   }
	\ }
\ }

function! _hiSelenized()
	hi! link SignColumn LineNr
	hi! link AleWarning SpellRare
	if &background == 'light'
		hi ALEErrorSign guibg=#e9e4e0 guifg=Red
		hi ALEWarningSign guibg=#e9e4e0 guifg=Blue
	else
		hi ALEErrorSign guibg=#184956 guifg=Red
		hi ALEWarningSign guibg=#184956 guifg=Blue
	endif
endfunction

" https://gist.github.com/romainl/379904f91fa40533175dfaec4c833f2f
" NonText for [eol, extends, precedes]; SpecialKey for [nbsp, tab, trail]
augroup my_colors
	autocmd!
	autocmd ColorScheme selenized call _hiSelenized()

	autocmd ColorScheme nord
		\   hi LineNr guibg=#434c5e
		\ | hi SignColumn guibg=#434c5e
		\ | hi ALEErrorSign guibg=#434c5e guifg=Red
		\ | hi ALEWarningSign guibg=#434c5e guifg=Blue
	autocmd ColorScheme iceberg
		\   hi ErrorMsg guifg=#161821 guibg=#e27878
		\ | hi SpecialKey guifg=#444b71
		\ | hi NonText guifg=#89b8c2
	autocmd ColorScheme Tomorrow-Night-Blue
		\   hi SpecialKey ctermfg=67 guifg=#7285b7
		\ | hi NonText ctermfg=14 guifg=Yellow
		\ | hi LineNr ctermbg=19 ctermfg=67 guifg=#7285b7
augroup END

" -- set the initial color/background --
set background=light
" override for console in ~/.vimrc: if !has('gui_running') ..
if has('gui_running')
	color PaperColor
else
	set notermguicolors " not available for mac terminal.app :(
	color gruvbox
	hi Normal ctermbg=NONE
end

" better diff colorscheme
if &diff
	colorscheme summerfruit256
endif

if has('transparency')
	set blurradius=15
	au FocusLost * :set transparency=15
	au FocusGained * :set transparency=0
endif

if has('gui_running')
	set mouse=a
endif

" -- set guifont per os
if g:os == 'Darwin'
	"set guifont=AnkaCoder-C87-r:h11
	"set guifont=SometypeMono-Regular:h11
	"set guifont=JetBrains_Mono:h10
	set guifont=SFMonto-Regular:h10
elseif g:os == 'Linux'
	set guifont=Monospace\ 9
	set clipboard=unnamedplus
elseif g:os == 'Windows'
	set guifont=JetBrains_Mono:h9
	set guioptions+=a
endif

" http://vim.wikia.com/wiki/Change_cursor_shape_in_different_modes
" DECSCUSR 1/2 (block), 3/4 (underline), 5/6 (bar) [blinking/steady]
let &t_SI="\e[5 q"
let &t_EI="\e[2 q"
