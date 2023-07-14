" -------vim-plug--------
" install vim-plug if not already installed
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
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
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'akinsho/bufferline.nvim'
" Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'andymass/vim-matchup'
" Plug 'Valloric/MatchTagAlways'
" Plug 'davidhalter/jedi-vim'
Plug 'vim-airline/vim-airline'
" Plug 'powerline/powerline'
Plug 'nvie/vim-flake8'
Plug 'tmhedberg/SimpylFold'
Plug 'vim-syntastic/syntastic'
" Plug 'Valloric/YouCompleteMe'
Plug 'airblade/vim-gitgutter'
Plug 'jiangmiao/auto-pairs'
Plug 'preservim/nerdtree'
Plug 'ParamagicDev/vim-medic_chalk'
Plug 'google/vim-searchindex'
Plug 'mileszs/ack.vim'
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
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
" incremental search
set incsearch
" highlight search results
set hlsearch
" make search smarter
set ignorecase
set smartcase
" set highlight forground and background colors
hi Search cterm=NONE ctermfg=white ctermbg=darkblue
" ------- enable Ag ---------------
let g:ackprg = 'ag --nogroup --nocolor --column'

" grep
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)
set grepprg=rg\ --vimgrep
" --------vim-commentary------------------
autocmd FileType xml setlocal commentstring=<!--%s-->
autocmd FileType sh,python,text setlocal commentstring=#%s
autocmd FileType vim setlocal commentstring=\"%s


" ----------key mapping------------
let g:mapleader=' '
" pretty format XML
noremap <leader>pf :%!xmllint --format -<cr>
" show history
noremap <leader>h :History<CR>
" show registers
noremap <leader>r :reg<CR>
" copy to clipboard
vmap <C-c> "yy
" paste from clipboard
noremap <leader>v "*p
" quickly add a blankline below
noremap <CR> o<Esc>
" add blankline above
noremap <leader><cr> O<Esc>
" exact search
nnoremap <leader>\ /\<\><left><left>
" comment line or block
noremap <leader>/ :Commentary<cr>
inoremap jj <Esc>
" copy and paste paragraph below
noremap cp yap<S-}>p
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
nnoremap <leader>c :close
" quickly close a file
noremap <leader>q :q<cr>
" close all files
noremap <leader>qa :qa<cr>
"" force close a file
noremap <leader>Q :q!<cr>
" quickly save a file in both normal and insert mode
nnoremap <leader>s :w<cr>
" source vimrc
nnoremap <leader>so :so ~/.vimrc<cr>
" save and quit
noremap <leader>z ZZ
" finding files using FZF
"nnoremap <silent> <C-f> :Files<CR>  
nnoremap <silent> <leader>f :FZF<cr>
nnoremap <silent> <leader>F :FZF ~<cr>
"quickly switch buffers
nnoremap <Leader>bu :ls<CR>:b<Space>
" open terminal in verical window
nnoremap <leader>t :vert term<CR>
" install Plugin using vim-plug
noremap <leader>pi :PlugInstall<CR>
" toggle GitGutter
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
" quickly move to the begining and end of line; this will override the cursor
" motion for top/bottom
nmap H ^
nmap L $
" remove search highlight
nmap <F9> :nohl

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
"colorscheme desertEx
" --------use with vimdiff--------
if &diff
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
