" Install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" -------vim-plug--------
call plug#begin('~/.vim/plugged')
" highlight yanked region
Plug 'machakann/vim-highlightedyank'
" motion plugin
Plug 'easymotion/vim-easymotion'
Plug 'justinmk/vim-sneak'
Plug 'mbbill/undotree'
Plug 'Valloric/MatchTagAlways'
Plug 'sukima/xmledit'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'davidhalter/jedi-vim'
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
" Initialize plugin system
call plug#end()
" --------Easy Motion config-------
let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
" nmap s <Plug>(easymotion-overwin-f)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap s <Plug>(easymotion-overwin-f2)

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

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
" -------- other settings---------
filetype plugin indent on       " load file type plugins + indentation
set showcmd
syntax on
colorscheme desertEx

" set number " show line number
set hlsearch  "highlight search results"
set splitbelow "split window below
set splitright " split window to the right
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter"
set tabstop=2 shiftwidth=2      " a tab is two spaces (or set this to 4)
set expandtab                   " use spaces, not tabs (optional)
set backspace=indent,eol,start  " backspace through everything in insert mode"

" " setting for py files
" au BufNewFile,BufRead *.py
"     \ set encoding=utf-8
"     \ set tabstop=4
"     \ set softtabstop=4
"     \ set shiftwidth=4
"     \ set textwidth=79
"     " \ set expandtab
"     \ set autoindent
"     \ set fileformat=unix
      
"  mark extral whitespace
" au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
" --------use with vimdiff--------
if &diff
	colorscheme medic_chalk
	highlight! link DiffText MatchParen
endif

" ----------FZF---------------------
" use fzf in vim
set rtp+=/global/homes/p/pshuai/.fzf/bin/fzf

" enable Ag 
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
" exact match
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
" quickly save a file in both normal and insert mode
nnoremap <leader>s :w<cr>
" source vimrc
nnoremap <leader>so :so ~/.vimrc<cr>
"inoremap <leader>s <C-c>:w<cr>
"save and quit
noremap <leader>z ZZ
" hide current file
" noremap <leader>h :hide<cr>
" pretty format XML
noremap <leader>pf :%!xmllint --format -<cr>
" finding files using FZF
nnoremap <silent> <leader>f :FZF<cr>
nnoremap <silent> <leader>F :FZF ~<cr>
" toggle line number
noremap <leader>n :set number!<cr>
" copy to register y
vmap <C-c> "yy
" paste from register y
nnoremap <leader>v "yp
" quickly switch buffers
nnoremap <Leader>b :ls<CR>:b<Space>
" toggle undotree; show changes in history
nnoremap <C-u> :UndotreeToggle<CR>
" toggle NERDTree
nnoremap <C-t> :NERDTreeToggle<CR>
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
" quickly move cursor
" noremap jj 12j
" noremap kk 12k
" noremap hh 12h
" noremap ll 12l
"----------- jedi-autocompletion ------
let g:jedi#popup_on_dot = 0
let g:jedi#completions_command = "<C-n>"
let g:jedi#auto_vim_configuration = 0
let g:jedi#use_tabs_not_buffers = 1
let g:jedi#use_splits_not_buffers = "right"
let g:jedi#goto_command = "<leader>g"
let g:jedi#goto_assignments_command = ""
let g:jedi#goto_stubs_command = ""
let g:jedi#goto_definitions_command = "<leader>d"
let g:jedi#documentation_command = ""
let g:jedi#usages_command = "<leader>u"
let g:jedi#rename_command = "<leader>r"

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

" ----git gutter setting---
:au VimEnter * :GitGutterDisable
