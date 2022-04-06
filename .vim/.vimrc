"TODO: Bind Ctrl (s-)tab to cycle tabs
"TODO: Bind enter to insert newline in normal mode
"TODO: Make vim respect the XDG standard: https://tlvince.com/vim-respect-xdg
"TODO: Make client server alias not put vim terminal into normal mode when opening new tab.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                Vim Settings                                  "
"                                                                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"Needs to be before 'set fileformats' or this will overwrite it.
set nocompatible

syntax on
filetype plugin indent on

set backspace=indent,eol,start
set belloff=all
set clipboard=unnamedplus "On Windows it's `set clipboard=unnamed`
set confirm
set directory=~/.vim/swap//,.
set fileformats=unix,dos,mac
set hidden
set history=1000
set incsearch
set list
set listchars=precedes:<,extends:>,tab:\ \ ,trail:_
set mouse=a
set noequalalways
set nowrap
set scrolloff=0
set showcmd
set showbreak=...
set sidescroll=1
set t_Co=256
set tags=tags;
set ttimeout
set ttimeoutlen=100

"Tabs
set autoindent
set breakindent
set copyindent
set expandtab
set shiftwidth=3
set softtabstop=3
set tabstop=3

"Wildmenu
set wildignorecase
set wildmenu
set wildmode=longest:full,full

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                   Settings applied to both Vim and Netrw                     "
"                                                                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set autochdir
let g:netrw_keepdir=0

set splitright
let g:netrw_altv=1

set splitbelow
let g:netrw_alto=1

set number
let g:netrw_bufsettings='noma nomod number nobl nowrap ro' "All but 'number' are default

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               Netrw Settings                                 "
"                                                                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:netrw_liststyle=1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   Keybinds                                   "
"                                                                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = " "

"Normal, Visual, Select, Operator-pending Modes

   "- to edit directory of current file
   noremap <silent> - :e %:p:h<CR>

   "Don't want to :set ignorecase because * and # should be case-sensitive
   "Case-insensitive search
   noremap / /\c
   noremap ? ?\c
   "Case-sensitive search
   noremap <Leader>/ /
   noremap <Leader>? /

   "Search currently open file and open quickfix list
   noremap <Leader>f :vimgrep /\c/ % \| copen<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
   noremap <Leader>F :vimgrep // % \| copen<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

   "Open terminal in current window
   noremap <Leader>t :ter ++curwin<CR>

"Insert Mode

   "shift-tab to inverse tab
   inoremap <S-Tab> <C-d>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                           StatusLine and Colors                              "
"                                                                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

colorscheme slate

set laststatus=2        "set statusline visibility to 'always'

set statusline=         "clear entire statusline
set statusline+=%n      "buffer number
set statusline+=\       "space
set statusline+=%{&ff}  "file format where EOL is: dos = <CR><NL>, unix = <NL>, mac = <CR>
set statusline+=\       "space
set statusline+=%y      "file type
set statusline+=\       "space
set statusline+=%F      "full filepath
set statusline+=%=      "separation point between left and right aligned items
set statusline+=%m      "modified flag where: [+] = modified, [-] = unmodifiable
set statusline+=\       "space
set statusline+=L:      "L:
set statusline+=%l      "current line
set statusline+=/       "/
set statusline+=%L      "total lines
set statusline+=\       "space
set statusline+=C:      "C:
set statusline+=%v      "column number
set statusline+=\       "space

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                Highlighting                                  "
"                             Auto-(no)hlsearch                                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Turn off search highlighting once done searching

let g:enter_was_pressed = 0

function! s:handle_cursor_moved()
   if &hlsearch == 0 "See :h expr-option
      return
   endif

   let last_search = @/
   let cursor_pos = [line("."), col(".")]
   "Limit search to current line, starting with character under cursor
   let pos_of_next_match = searchpos(last_search, "cnz", cursor_pos[0])
   if cursor_pos != pos_of_next_match
      set nohlsearch
   endif
endfunction

function! s:handle_cmdline_leave()
   if (!g:enter_was_pressed)
      set nohlsearch
   else
      let g:enter_was_pressed = 0
      set hlsearch
   endif
endfunction

function! s:handle_enter_pressed_in_cmdline()
   let g:enter_was_pressed = 1
   return "\<CR>"
endfunction

"See :h cmdwin-char and :h file-pattern. Maps to ? and / searches.
autocmd! CmdlineChanged [\/\?] set hlsearch
autocmd! CmdlineLeave [\/\?] call <SID>handle_cmdline_leave()
autocmd! CmdwinEnter [\/\?] nnoremap <CR> :let g:enter_was_pressed = 1<CR><CR>
autocmd! CmdwinLeave [\/\?] nunmap <CR>
autocmd! CursorMoved * call <SID>handle_cursor_moved()
autocmd! InsertEnter * set nohlsearch

cnoremap <silent><expr> <CR> <SID>handle_enter_pressed_in_cmdline()

noremap <silent> n n:set hlsearch<CR>
noremap <silent> N N:set hlsearch<CR>
noremap <silent> * *:set hlsearch<CR>
noremap <silent> # #:set hlsearch<CR>
noremap <silent> g* g*:set hlsearch<CR>
noremap <silent> g# g#:set hlsearch<CR>
noremap <silent> gd gd:set hlsearch<CR>
noremap <silent> gD gD:set hlsearch<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               Gvim Settings                                  "
"                   (only aplies if using Gvim obviously)                      "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set guifont=Hack\ 14 "TODO: Can list more fonts here in case Hack isn't available.
set guioptions-=m "Hide menu bar
set guioptions-=r "Hide scrollbar
set guioptions-=T "Hide toolbar

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                  Plugins                                     "
"                                                                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"FZF fuzzy finder default plugin location on Ubuntu
if filereadable("/usr/share/doc/fzf/examples/fzf.vim")
   source /usr/share/doc/fzf/examples/fzf.vim
endif
