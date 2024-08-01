" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" -------vim-plug--------
" install vim-plug if not already installed
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" install colorschemes
if empty(glob('~/.vim/colors/desertEx.vim'))
  silent execute '!curl -fLo ~/.vim/colors/desertEx.vim --create-dirs https://raw.githubusercontent.com/mbbill/desertEx/master/colors/desertEx.vim '
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" install plugins
call plug#begin('~/.vim/plugged')

" Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown', 'do': 'yarn install'}

" highlight yanked region
Plug 'machakann/vim-highlightedyank'
" motion plugin
Plug 'easymotion/vim-easymotion'
Plug 'justinmk/vim-sneak'
Plug 'mbbill/undotree'

" Plug 'sukima/xmledit'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'akinsho/bufferline.nvim'
" Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'andymass/vim-matchup'
" Plug 'Valloric/MatchTagAlways'
" Plug 'davidhalter/jedi-vim'
Plug 'wincent/terminus'
" Plug 'vim-airline/vim-airline-themes'
" Plug 'vim-airline/vim-airline' 
" Plug 'Valloric/YouCompleteMe'
Plug 'vim-scripts/indentpython.vim'
Plug 'tmhedberg/SimpylFold'
Plug 'airblade/vim-gitgutter' 
Plug 'jiangmiao/auto-pairs'
Plug 'preservim/nerdtree'
Plug 'ParamagicDev/vim-medic_chalk'
Plug 'google/vim-searchindex'
" Plug 'henrik/vim-indexed-search'
Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'github/copilot.vim'
" Initialize plugin system
call plug#end()
" --------Easy Motion config-------
let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
nmap s <Plug>(easymotion-overwin-f)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap ss <Plug>(easymotion-overwin-f2)

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

" ---------YOuCompleteMe----------
"python with virtualenv support
"py << EOF
"import os
"import sys
"if 'VIRTUAL_ENV' in os.environ:
"  project_base_dir = os.environ['VIRTUAL_ENV']
"  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
"  execfile(activate_this, dict(__file__=activate_this))
"EOF
""
" ----------FZF---------------------
" use fzf in vim
" set rtp+=/usr/local/opt/fzf
set rtp+=/opt/homebrew/opt/fzf"
" Disable compatibility with vi which can cause unexpected issues.
set nocompatible
" incremental search
set incsearch
" highlight search results
set hlsearch
" make search smarter
set ignorecase
set smartcase
" Show partial command you type in the last line of the screen.
set showcmd
" Set the commands to save in history default number is 20.
set history=1000
" set highlight forground and background colors
hi Search cterm=NONE ctermfg=white ctermbg=darkblue
" ------- enable Ag ---------------

let g:ackprg = 'ag --nogroup --nocolor --column'

" grep
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)
set grepprg=rg\ --vimgrep

" ------------commentatory----------------
autocmd FileType xml,html setlocal commentstring=<!--%s--> 
autocmd FileType sh,python,text,in setlocal commentstring=#%s
" ------------- python file type setting -----------
autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 

"---------------KEY MAPPING---------------
let g:mapleader=' '

" show history
noremap <leader>h :History<CR>
" pretty format XML
noremap <leader>pf :%!xmllint --format -<cr>
" show history
noremap <leader>h :History<CR>
" show registers
noremap <leader>r :reg<CR>
" copy to clipboard
" vmap <C-c> "yy
" ctrl-x for cut
vmap <C-x> :!pbcopy<cr>
" ctrl-c for copy
vmap <C-c> :w !pbcopy<cr><cr>
" paste from clipboard
noremap <leader>v "*p
" quickly add a blankline below
noremap <CR> o<Esc>
" add blankline above
noremap <leader><cr> O<Esc>
" exact search
nnoremap <leader>\ /\<\><left><left>
" comment line
noremap <leader>/ :Commentary<cr>
" group comment lines that contain current words
nnoremap <leader>Cw yiw:%s/^.*<C-r>".*$/\# &/
" toggle between edit and normal mode
inoremap jj <Esc>
" copy and paste paragraph below
noremap ypp yap<S-}>p
" copy and paste tag below
noremap ytp yat<S-}>p
" quickly align current paragraph, useful to see if missing ending brackets
noremap <leader>a =ip
" control directions to change panels
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
" move cursor in edit mode
inoremap <C-l> <C-o>l
inoremap <C-h> <C-o>h
inoremap <C-j> <C-o>j
inoremap <C-k> <C-o>k
inoremap <C-e> <C-o>$
inoremap <C-a> <C-o>^
" change split window size
nnoremap <leader>+ :vertical resize +5<cr> 
nnoremap <leader>- :vertical resize -5<cr> 
" quickly close a file
noremap <leader>q :q<cr>
noremap <leader>Q :q!<cr>
noremap <leader>qa :qa<cr>

"" force close a file
noremap <leader>Q :q!<cr>
" quickly save a file in both normal and insert mode
nnoremap <leader>s :w<cr>
" source vimrc
nnoremap <leader>so :so ~/.vimrc<cr>
" save and quit
noremap <leader>z ZZ
" hide current file
" noremap <leader>h :hide<cr>
" pretty format XML
noremap <leader>pf :%!xmllint --format -<cr>
" finding files using FZF
nnoremap <silent> <leader>f :FZF<cr>
nnoremap <silent> <leader>F :FZF ~<cr>

" toggle line number
noremap <leader>l :set number!<cr>
" copy to register y
vmap <C-c> "yy
" paste from register y
nnoremap <leader>v "yp
" replace current word with default register (*)
noremap pw viwp
" quickly switch buffers
nnoremap <Leader>b :ls<CR>:b<Space>
" toggle undotree; show changes in history
nnoremap <Leader>u :UndotreeToggle<CR>
" toggle NERDTree
nnoremap <C-t> :NERDTreeToggle<CR>
"quickly switch buffers
nnoremap <Leader>bu :ls<CR>:b<Space>

" open terminal in verical window
nnoremap <leader>t :vert term<CR>
" install Plugin using vim-plug
noremap <leader>pi :PlugInstall<CR>
" toggle GitGutter

noremap <leader>git :GitGutterToggle<CR>
" add blankline above
noremap <leader><cr> O<Esc>
" quickly add a blankline
noremap <CR> o<Esc>
" open registers
noremap <leader>r :registers<CR>
" search yanked texts
vmap / y:/<C-r>"<CR>

noremap <C-g> :GitGutterToggle<CR>
" toggle undotree; show changes in history
nnoremap <Leader>u :UndotreeToggle<CR>
" toggle nerdtree
nnoremap <C-t> :NERDTreeToggle<CR>
" toggle line number
noremap <C-n> :set number!<cr>
" toggle syntastic
nnoremap <C-s> :SyntasticCheck<CR>

" search and replace current word, go to the word to be replaced and type the
" command below
nnoremap <leader>Rw yiw:%s#<C-r>"##g<left><left>
nnoremap <leader>Rwc yiw:%s#<C-r>"##gc<left><left><left>
" search and replace current characters within quotes with yanked text from
" register y (use command "yy)

nnoremap <leader>Ry yi":%s#<C-r>"#<C-r>y#g<CR>
nnoremap <leader>Ryc yi":%s#<C-r>"#<C-r>y#gc<CR>
nnoremap <leader>Rs yi":%s#<C-r>"##g<left><left>
nnoremap <leader>Rsc yi":%s#<C-r>"##gc<left><left><left>

" fold based on skip-noskip
noremap ski :setlocal foldmethod=expr foldexpr=FoldOnKeyword()<CR>

" replace all highlighted texts
nnoremap <Leader>Rh :%s///g<left><left>
" quickly move to the begining and end of line; this will override the cursor
" motion for top/bottom
nmap H ^
nmap L $

" remove search highlight
nmap <F9> :nohl

" Center the cursor vertically when moving to the next word during a search.
nnoremap n nzz
nnoremap N Nzz

" jump between diffs
noremap [ [c
noremap ] ]c

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>w <Plug>(easymotion-w)
map <Leader>W <Plug>(easymotion-W)
map <Leader>b <Plug>(easymotion-b)
map <Leader>B <Plug>(easymotion-B)
map <Leader>e <Plug>(easymotion-e)
map <Leader>E <Plug>(easymotion-E)
map <Leader>n <Plug>(easymotion-n)
map <Leader>N <Plug>(easymotion-N)


" define a general fold method
set foldmethod=indent   " fold based on indent
" autocmd FileType vim setlocal foldmethod=marker  " fold using marker (e.g., comments)

" fold using custom expression for PFLOTRAN.in file
au BufNewFile,BufRead *.in set filetype=in
" au FileType in setlocal foldmethod=expr
" au FileType in setlocal foldexpr=InFolds()   " fold lines starting with #
" au FileType in setlocal foldexpr=getline(v:lnum)[0]=='\#'   " fold lines starting with #
" define a new function for the fold method: 1) fold when line starts with #;
" 2) fold when indent

function! InFolds()
  let thisline = getline(v:lnum)
  " when line is empty, use the fold level before or after this line
  " if thisline =~? '\v^\s*$'  
  "   return '-1'
  " endif
  " fold when line starts with #
  if thisline =~ '^\#\ .*$'
    return 1
  " elseif thisline =~ '^skip.*$'
  "   return '>1'
  " elseif thisline =~ '^noskip.*$'
  "   return '<1'
  else
    " fold when indent
    return indent(v:lnum) / &shiftwidth
  endif
endfunction

" fold based on keywords (skip --> noskip)
function! FoldOnKeyword()
    let line = getline(v:lnum)
    if a:line == 'skip'
        " A level 1 fold starts here; cp :help fold-expr
        return '>1'
    elseif a:line == 'noskip'
        " A level 1 fold ends here
        return '<1'
    else
        " Use fold level from previous line
        return '='
    endif
endfunction
" setlocal foldmethod=expr foldexpr=FoldOnKeyword()

" fold xml tags (foldlevel default to 1; max fold =10; nofoldenable, do not
" fold by default)
let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax foldlevel=1 foldnestmax=10 nofoldenable
" show filepath
set laststatus=2
set statusline+=%F
set clipboard+=unnamed


" jump to diff in vimdiff
nmap [ [c
nmap ] ]c
" place current line to top of screen
nnoremap T zt
" -----  other options----------
syntax on
let python_highlight_all=1
let g:SimpylFold_docstring_preview = 1
" " Jedi-vim auto completion commands
" let g:jedi#environment_path = "/opt/anaconda3/bin/python"
" let g:jedi#completions_command = "<C-n>"
" let g:jedi#goto_command = ""
" let g:jedi#goto_assignments_command = ""
" let g:jedi#goto_stubs_command = ""
" let g:jedi#goto_definitions_command = "<leader>to"
" let g:jedi#documentation_command = ""
" let g:jedi#usages_command = ""
" let g:jedi#rename_command = ""
" fold xml tags
let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax foldlevel=1 foldnestmax=10 nofoldenable
au BufRead * normal zR
" auto saving
autocmd TextChanged,TextChangedI <buffer> silent write
colorscheme desertEx
" --------use with vimdiff--------
if &diff
  colorscheme medic_chalk
  highlight! link DiffText MatchParen
endif
" ---- syntastic setting ---
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 0
" let g:syntastic_check_on_wq = 0
"
" ---- gitgutter setting ---
:au VimEnter * :GitGutterDisable
" ----match it setting---
hi MatchWord ctermfg=red guifg=blue cterm=underline gui=underline
" --- instant markdown setting----
"Uncomment to override defaults:
"this will set interactive bash as the default vim shell
" autocmd FileType md set shell=bash\ -i  
"let g:instant_markdown_slow = 1
"let g:instant_markdown_autostart = 0
"let g:instant_markdown_open_to_the_world = 1
"let g:instant_markdown_allow_unsafe_content = 1
"let g:instant_markdown_allow_external_content = 0
"let g:instant_markdown_mathjax = 1
"let g:instant_markdown_mermaid = 1
"let g:instant_markdown_logfile = '/tmp/instant_markdown.log'
"let g:instant_markdown_autoscroll = 0
" let g:instant_markdown_port = 8855
"let g:instant_markdown_python = 1

