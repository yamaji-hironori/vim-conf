"""" '.vimrc'の変更を即剤に反映させたいとき----------
""    :source ~/.vimrc
"""" ------------------------------------------------

" 一旦ファイルタイプ関連を無効化する
filetype off
filetype plugin indent off
"" 表示関係
set number               " 行番号の表示
set relativenumber       " 相対行表示
set list                 " 不可視文字の可視化
set ruler                " カーソル位置が右下に表示される
set wildmenu             " コマンドライン補完が強力になる
set showcmd              " コマンドを画面の最下部に表示する
set wrap                 " 長いテキストの折返し
set textwidth=0          " 自動的に改行が入るのを無効化
set colorcolumn=80       " 80文字目にラインを入れる
set cursorline           " 80文字目にラインを入れる
set foldmethod=indent    " 折りたたみ
set foldlevel=100        " ファイルを開く際の折りたたみをしない
" 行番号の相対表示・絶対表示を切り替える
nnoremap <F3> :<C-u>setlocal relativenumber!<CR>
" ターミナルの位置・サイズ調整
set splitbelow
" set termwinsize=7x0

"" 編集関係
set infercase            " 補完時に大文字小文字を区別しない
set virtualedit=all      " カーソルを文字が存在しない部分でも動けるようにする
set hidden               " バッファを閉じる代わりに隠す（Undo履歴を残すため）
set switchbuf=useopen    " 新しく開く代わりにすでに開いてあるバッファを開く
set showmatch            " 対応する括弧などをハイライト表示する
set matchtime=3          " 対応括弧のハイライト時間を3秒にする
set autoindent           " 改行時にインデントを引き継いで改行する
set shiftwidth=4         " インデントに使われる空白の数
au BufNewFile,BufRead *.yml set shiftwidth=2
set softtabstop=4        " <Tab>押下時の空白数
set expandtab            " <Tab>押下時に<Tab>ではなく、ホワイトスペースを挿入する
set tabstop=4            " <Tab>が対応する空白の数
au BufNewFile,BufRead *.yml set tabstop=2
set shiftround           " '<'や'>'でインデントする際に'shiftwidth'の倍数に丸める
set nf=                  " インクリメント、デクリメントを10進数にする
" 不可視文字を美しく
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲
" 対応括弧に'<'と'>'のペアを追加する
set matchpairs& matchpairs+=<:>
" バックスペースでなんでも消せるようにする
set backspace=indent,eol,start
" 'txt'拡張子を認識できるようにし、syntaxを有効化させる
au BufRead,BufNewFile *.txt set filetype=txt
au BufRead,BufNewFile *.snip set filetype=snip
" クリップボードをデフォルトのレジスタとして指定。後にYankRingを使うので
" 'unnamedplus'が存在するかどうかで設定を分ける必要がある
if has('unnamedplus')
  set clipboard& clipboard+=unnamedplus, unnamed
else
  set clipboard& clipboard+=unnamed
endif
" Swapファイル, Backupファイルをすべて無効化する
set nowritebackup
set nobackup
set noswapfile
" 挿入モードにおいてhjklでの移動を可能にする
imap <C-h> <Left>
imap <C-j> <Down>
imap <C-k> <Up>
imap <C-l> <Right>
imap <C-4> <Home>
imap <C-6> <End>

"" 検索関係
set ignorecase           " 大文字小文字を区別しない
set smartcase            " 検索文字に大文字がある場合は大文字小文字を区別
set incsearch            " インクリメンタルサーチ
set hlsearch             " 検索マッチテキストにハイライト

"" マクロ及びキー設定
" 大きくキー移動させる
map J 10j
map K 10k
map H 10h
map L 10l
" ESCを２回押すことでハイライトを消す
nmap <silent> <Esc><Esc> :nohlsearch<CR>
" カーソル下の単語を * で検索
vnoremap <silent> * vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR><CR>
" 検索後にジャンプした際に検索単語を画面中央に持ってくる
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
" j,k による移動を折り返されたテキストでも自然に振る舞うように変更
nnoremap j gj
nnoremap k gk
" TABにて対応ペアにジャンプ
nnoremap <Tab> %
vnoremap <Tab> %
" [ と打ったら [] って入力されてしかも括弧の中にいる(以下同様)
" inoremap [ []<left>
" inoremap ( ()<left>
" inoremap { {}<left>
" inoremap < <><left>
" inoremap " ""<left>
" inoremap ' ''<left>
" インサートモードのEscをjjにバインド
inoremap <silent> jj <ESC>
" inoremap <silent> っｊ <ESC>
" Ctrl + hjkl でウィンドウ間を移動
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Shift + 矢印でウィンドウサイズを変更
nnoremap <S-Left> <C-w>5><CR>
nnoremap <S-Right> <C-w>5<<CR>
nnoremap <S-Up> <C-w>5-<CR>
nnoremap <S-Down> <C-w>5+<CR>

"" タブ設定
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tc 新しいタブを一番右に作る
map <silent> [Tag]x :tabclose<CR>
" tx タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ


"NeoBundle Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif
set runtimepath+=/Users/hironori-yamaji/.vim/bundle/neobundle.vim/
call neobundle#begin(expand('/Users/hironori-yamaji/.vim/bundle'))

NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'Shougo/neosnippet.vim'      " vimのsnippet機能。:NeoSnippetEditで編集可能
NeoBundle 'Shougo/neosnippet-snippets' " 基本的なsnippetのセット
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neocomplcache.vim'
NeoBundle 'Shougo/vimproc.vim', {
\ 'build' : {
\     'windows' : 'tools\\update-dll-mingw',
\     'cygwin' : 'make -f make_cygwin.mak',
\     'mac' : 'make -f make_mac.mak',
\     'linux' : 'make',
\     'unix' : 'gmake',
\    },
\ }
NeoBundle 'tpope/vim-fugitive'         " vim内でgitを扱えるようにする
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'scrooloose/nerdtree'        " ディレクトリをツリー表示できる
NeoBundle 'slim-template/vim-slim'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'mxw/vim-jsx'
NeoBundle 'vim-airline/vim-airline'
NeoBundle 'vim-airline/vim-airline-themes'
NeoBundle 'thewtex/tmux-mem-cpu-load'
NeoBundle 'edkolev/tmuxline.vim'
NeoBundle 'Quramy/tsuquyomi'
"NeoBundle 'typescript-vim'
autocmd BufRead,BufNewFile *.ts set filetype=typescript

" You can specify revision/branch/tag.
" NeoBundle 'Shougo/vimshell', { 'rev' : '3787e5' }

call neobundle#end()
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
"End NeoBundle Scripts-------------------------


" *********************************************
" NERDTree
" *********************************************
" ブックマーク初期表示
let g:NERDTreeShowBookmarks=1
"
let g:NERDTreeChDirMode=2
" windowサイズ設定
let g:NERDTreeWinSize=20
" 表示したくないファイル、ディレクトリ
let g:NERDTreeIgnore=['\.DS_Store$', '\.swp$', '\~$', '\.so']
nnoremap <silent><C-e> :NERDTreeToggle<CR>
" vim起動時に常に表示
" autocmd vimenter * NERDTree
" NERDTreeだけが残る場合はvim終了
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" *********************************************
" Powerline系フォントを利用する
" *********************************************
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 1
let g:airline_theme = 'papercolor'
" let g:tmuxline_theme = 'papercolor'
" let g:airline_solarized_bg='light'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.maxlinenr = '㏑'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.maxlinenr = ''

" tmuxline.vim
 let g:tmuxline_preset = {
  \'a'    : '#S',
  \'c'    : ['#(whoami)', '#(uptime | cud -d " " -f 1,2,3)'],
  \'win'  : ['#I', '#W'],
  \'cwin' : ['#I', '#W', '#F'],
  \'x'    : '#(date)',
  \'y'    : ['%R', '%a', '%Y'],
  \'z'    : '#H'}

" ********************************************
" neosnnippet
" ********************************************
 " Plugin key-mappings.
imap <C-s> <Plug>(neosnippet_expand_or_jump)
smap <C-s> <Plug>(neosnippet_expand_or_jump)
xmap <C-s> <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

 " Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1
"set snippet file dir
" let g:neosnippet#snippets_directory='~/.vim/bundle/neosnippet-snippets/snippets/,~/.vim/snippets'
let g:neosnippet#snippets_directory='~/.vim/snippets'


" *************************************
" neocomplcache
" *************************************
""Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
"" Disable AutoComplPop.
"let g:acp_enableAtStartup = 0
"" Use neocomplcache.
"let g:neocomplcache_enable_at_startup = 1
"" Use smartcase.
"let g:neocomplcache_enable_smart_case = 1
"" Set minimum syntax keyword length.
"let g:neocomplcache_min_syntax_length = 3
"let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
"
"" Enable heavy features.
"" Use camel case completion.
""let g:neocomplcache_enable_camel_case_completion = 1
"" Use underbar completion.
""let g:neocomplcache_enable_underbar_completion = 1
"
"" Define dictionary.
"let g:neocomplcache_dictionary_filetype_lists = {
"    \ 'default' : '',
"    \ 'vimshell' : $HOME.'/.vimshell_hist',
"    \ 'scheme' : $HOME.'/.gosh_completions'
"        \ }
"
"" Define keyword.
"if !exists('g:neocomplcache_keyword_patterns')
"    let g:neocomplcache_keyword_patterns = {}
"endif
"let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
"
"" Plugin key-mappings.
"inoremap <expr><C-g>     neocomplcache#undo_completion()
"" inoremap <expr><C-l>     neocomplcache#complete_common_string()
"
"" Recommended key-mappings.
"" <CR>: close popup and save indent.
"inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
"function! s:my_cr_function()
"  return neocomplcache#smart_close_popup() . "\<CR>"
"  " For no inserting <CR> key.
"  "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
"endfunction
"" <TAB>: completion.
"inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
"" <C-h>, <BS>: close popup and delete backword char.
"" inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
"inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
"inoremap <expr><C-y>  neocomplcache#close_popup()
"inoremap <expr><C-e>  neocomplcache#cancel_popup()
"" Close popup by <Space>.
""inoremap <expr><Space> pumvisible() ? neocomplcache#close_popup() : "\<Space>"
"
"" For cursor moving in insert mode(Not recommended)
""inoremap <expr><Left>  neocomplcache#close_popup() . "\<Left>"
""inoremap <expr><Right> neocomplcache#close_popup() . "\<Right>"
""inoremap <expr><Up>    neocomplcache#close_popup() . "\<Up>"
""inoremap <expr><Down>  neocomplcache#close_popup() . "\<Down>"
"" Or set this.
""let g:neocomplcache_enable_cursor_hold_i = 1
"" Or set this.
""let g:neocomplcache_enable_insert_char_pre = 1
"
"" AutoComplPop like behavior.
""let g:neocomplcache_enable_auto_select = 1
"
"" Shell like behavior(not recommended).
""set completeopt+=longest
""let g:neocomplcache_enable_auto_select = 1
""let g:neocomplcache_disable_auto_complete = 1
""inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"
"
"" Enable omni completion.
"autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
"autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
"autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
"autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
"autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
"
"" Enable heavy omni completion.
"if !exists('g:neocomplcache_force_omni_patterns')
"  let g:neocomplcache_force_omni_patterns = {}
"endif
"let g:neocomplcache_force_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplcache_force_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplcache_force_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
"
"" For perlomni.vim setting.
"" https://github.com/c9s/perlomni.vim
"let g:neocomplcache_force_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
