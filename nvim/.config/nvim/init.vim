" vim:fileencoding=utf-8:foldmethod=marker:softtabstop=2:shiftwidth=2
"
"          N/VIM Configuration File
"
" Author: personinblack
" GitHub: https://github.com/personinblack/dotfiles
"

        "' PLUGINS '" {{{


call plug#begin('~/.config/nvim/plugins')


  " Usability Stuff
" Vim tmux movement integration
Plug 'christoomey/vim-tmux-navigator'
" Git wrapper
Plug 'tpope/vim-fugitive'
" Editorconfig
Plug 'editorconfig/editorconfig-vim'
" Correct project root
Plug 'airblade/vim-rooter'
" Surroundings
Plug 'tpope/vim-surround'


  " UI Stuff
" Color Theme
Plug 'bluz71/vim-moonfly-colors'
" Tree view sidebar
Plug 'scrooloose/nerdtree'
Plug 'xuyuanp/nerdtree-git-plugin'
" Git diff visualizer
Plug 'airblade/vim-gitgutter'
" Statusbar
Plug 'vim-airline/vim-airline'
" Indent guides
Plug 'yggdroot/indentline'
" Distraction-free writing
Plug 'junegunn/goyo.vim'
" FZF
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'


  " Semantic Language
" Intellisense && completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dense-analysis/ale'


  " Syntactic Language
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'plasticboy/vim-markdown'
" Ruby end stuff
Plug 'tpope/vim-endwise'
" Auto close brackets, quotes, paranthesis
Plug 'raimondi/delimitmate'
" Match open/close and jump between (key: %)
Plug 'andymass/vim-matchup'
" Commenter
Plug 'scrooloose/nerdcommenter'

call plug#end()


" }}}

        "' KEYBINDINGS '" {{{


" Leader key
let mapleader = ' '


  " Navigation
" New pane (these are not regular dash and comma chars, they are made with the CTRL-v)
nnoremap - :new<CR>
nnoremap , :vnew<CR>

" Previous buffer
map <Leader><Leader> <c-^>

" git-gutter next/previous hunk
nmap >h <Plug>GitGutterNextHunk
nmap <h <Plug>GitGutterPrevHunk

" Fzf search file contents
noremap <leader>a :Rg<cr>

" Fzf search file names
noremap <leader>s :Files<cr>

" Coc references
nmap <leader>r <Plug>(coc-references)
nmap <leader>f <Plug>(coc-rename)


  " Remapping
" >/< keys (pardon my language)
map ç >
map ö <

" Copy to/paste from clipboard shortcuts
map <C-y> "+y
map <C-p> "+p

" Tab intellisense
inoremap <silent><expr> <S-Tab> coc#refresh()

" Unmap arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>


  " Plugin Toggle
" ALEHover
nnoremap <silent> K :ALEHover<CR>
" NERDTree toggle
map <C-n> :NERDTreeToggle<CR>

" Goyo toggle
map <C-z> :Goyo<CR>


" }}}

        "' COMMANDS '" {{{


" Bind :Q to :q
command! Q q


"}}}

        "' GENERAL CONFIGURATION '" {{{


" This is needed for so much stuff but I don't really understand it
filetype plugin indent on


  " Visual
" Set colorscheme
colorscheme moonfly
" Use GUI colors
if (has("termguicolors"))
  set termguicolors
endif

" Syntax highlighting
syntax on
set synmaxcol=180

" Enable line numbers
set rnu

" Highlight line limit
set colorcolumn=90

" Highlight cursor line
set cursorline

" Show matching brackets/parenthesis
set showmatch

" Show invisible chars
set list
set listchars=
set listchars+=tab:⭾.
set listchars+=trail:·
set listchars+=extends:»
set listchars+=precedes:«
set listchars+=nbsp:░

" Natural split behavior
set splitbelow
set splitright


  " Code Style
" Tabs to spaces
set expandtab

" Default tab size
set softtabstop=4
set shiftwidth=4


  " Editor Improvements
" Keep the undo history
set undofile
set undodir=~/.nvim/undo

" Make some space around the cursor
set scrolloff=10

" Ripgrep as default grep
set grepprg=rg\ --no-heading\ --vimgrep
set grepformat=%f:%l:%c:%m

" Add current dir to path and allow fuzzy finding
set path+=**
set wildmode=list:full
set wildmenu
set wildignorecase

" Case insensitive search
set ignorecase
set smartcase


  " Fixes
" Vim update faster (for git-gutter, syntax checks, etc.)
set updatetime=100

" Keypress wait time
set timeoutlen=500

" Don't know if this is still useful
set conceallevel=0


" }}}

        "' PLUGIN CONFIGURATIONS '" {{{


  " NERDTree
" Show NERDTree while working with a directory
augroup NERDTREE_AUTO_RUN
    au!
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
augroup END


  " IndentLine
" IndentColor
let g:indentLine_color_term = 0

" Fix JSON
augroup JSON_NO_INDENT
    au!
    autocmd BufEnter *.json IndentLinesDisable
augroup END


  " Editorconfig
" Fix Fugitive
let g:EditorConfig_exclude_patterns = ['fugitive://.\*']


  " Goyo
" Width
let g:goyo_width = 100

function! s:goyo_enter()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set noshowmode
  set noshowcmd
  set scrolloff=999
  set nu
endfunction

function! s:goyo_leave()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set showmode
  set showcmd
  set scrolloff=5
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()


  " Ale
let g:ale_lint_on_text_changed = 'always'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_save = 0
let g:ale_lint_on_enter = 1
let g:ale_virtualtext_cursor = 1
highlight link ALEWarningSign Todo
highlight link ALEErrorSign WarningMsg
highlight link ALEVirtualTextWarning Todo
highlight link ALEVirtualTextInfo Todo
highlight link ALEVirtualTextError WarningMsg
highlight ALEError guibg=None
highlight ALEWarning guibg=None
let g:ale_sign_error = "✖"
let g:ale_sign_warning = "⚠"
let g:ale_sign_info = "i"
let g:ale_sign_hint = "➤"

" Rust
let g:ale_rust_rls_config = {
        \ 'rust': {
                \ 'all_targets': 1,
                \ 'build_on_save': 0,
                \ 'clippy_preference': 'on'
        \ }
        \ }
let g:ale_linters = {'rust': ['rls']}


  " fzf with ripgrep
" At the bottom with 40% size
let g:fzf_layout = { 'down': '~40%' }

" File content search format
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '
  \    .shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:40%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" File name search format
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }


" }}}