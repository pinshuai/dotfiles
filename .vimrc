" -------vim-plug--------
call plug#begin('~/.vim/plugged')
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
"
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
set rtp+=/usr/local/opt/fzf

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
" quickly add a blankline below
noremap <CR> o<Esc>
" add blankline above
noremap <C-CR> O<Esc>
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
nnoremap <leader>so :so ~/github/dotfiles/.vimrc<cr>
" save and quit
noremap <leader>z ZZ
" finding files using FZF
"nnoremap <silent> <C-f> :Files<CR>  
nnoremap <silent> <leader>f :FZF<cr>
nnoremap <silent> <leader>F :FZF ~<cr>
"quickly switch buffers
nnoremap <Leader>b :ls<CR>:b<Space>
" open terminal in verical window
nnoremap <leader>t :vert term<CR>
" install Plugin using vim-plug
noremap <leader>pi :PlugInstall<CR>
" toggle GitGutter
noremap <C-g> :GitGutterToggle<CR>
" toggle undotree
nnoremap <C-u> :UndotreeToggle<CR>
" toggle nerdtree
nnoremap <C-t> :NERDTreeToggle<CR>
" -----  other options----------
syntax on
let python_highlight_all=1
let g:SimpylFold_docstring_preview = 1
" Jedi-vim auto completion commands
let g:jedi#environment_path = "/opt/anaconda3/bin/python"
let g:jedi#completions_command = "<C-n>"
let g:jedi#goto_command = ""
let g:jedi#goto_assignments_command = ""
let g:jedi#goto_stubs_command = ""
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = ""
let g:jedi#usages_command = ""
let g:jedi#rename_command = ""
" fold xml tags
let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax foldlevel=1 foldnestmax=10 nofoldenable
" auto saving
autocmd TextChanged,TextChangedI <buffer> silent write
"colorscheme desertEx
"set hlsearch
"hi Search cterm=NONE ctermfg=grey ctermbg=blue
" --------use with vimdiff--------
if &diff
  colorscheme medic_chalk
  highlight! link DiffText MatchParen
endif
" ---- syntastic setting ---
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
