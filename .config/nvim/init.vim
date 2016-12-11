call plug#begin('~/.vim/plugged')

" Search
Plug 'rking/ag.vim'
" Complete
Plug 'Shougo/deoplete.nvim'
Plug 'Raimondi/delimitMate'
" Snippets
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
" Git wrapper
Plug 'tpope/vim-fugitive'
" Full path fuzzy file, buffer, mru, tag finder
Plug 'ctrlpvim/ctrlp.vim'
" Explore filesystem
Plug 'scrooloose/nerdtree'
" Automated tag generation and syntax highlighting
Plug 'fntlnz/atags.vim'
" Plug 'xolox/vim-misc'
" Plug 'xolox/vim-easytags'
" Class outline viewer
" Plug 'majutsushi/tagbar'
Plug 'taglist.vim'
" Simpler way to use motions in vim
Plug 'easymotion/vim-easymotion'
" Better status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Show changes in files
Plug 'airblade/vim-gitgutter'
" Colorschemes & styles yolo swag
Plug 'chriskempson/base16-vim'
" Session management
Plug 'tpope/vim-obsession'
" Integrate vim with tmux
Plug 'christoomey/vim-tmux-runner'
Plug 'christoomey/vim-tmux-navigator'
" Easy filtering and alignment
Plug 'godlygeek/tabular'
" Edit helpers
Plug 'tpope/vim-surround'
" Testing
Plug 'janko-m/vim-test'
" Markdown preview
" Plug 'euclio/vim-markdown-composer'
" Filetypes plugins
Plug 'editorconfig/editorconfig-vim'
Plug 'xolox/vim-misc'
Plug 'fatih/vim-go'
Plug 'docteurklein/php-getter-setter.vim'
Plug 'StanAngeloff/php.vim'
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-markdown'
Plug 'kchmck/vim-coffee-script'
Plug 'mattn/emmet-vim'
Plug 'elzr/vim-json'
Plug 'pangloss/vim-javascript'
Plug 'chase/vim-ansible-yaml'
Plug 'digitaltoad/vim-jade'
Plug 'klen/python-mode'
Plug 'moll/vim-node'
Plug 'leafgarland/typescript-vim'
Plug 'xsbeats/vim-blade'
Plug 'xolox/vim-lua-ftplugin'
Plug 'stephpy/vim-yaml'

call plug#end()

" Deoplete
let g:deoplete#enable_at_startup = 1
" Use smartcase.
let g:deoplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:deoplete#sources#syntax#min_keyword_length = 2
" let g:deoplete#lock_buffer_name_pattern = '\*ku\*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Ag
" let g:ag_prg='ag --color'
let g:ag_working_path_mode="r"
nmap <silent><C-f> :Ag "<cword>" app<cr>

" Neosnippet
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB>
 \ pumvisible() ? "\<C-n>" :
 \ neosnippet#expandable_or_jumpable() ?
 \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
vmap <leader>t :Tab /=><cr>

let g:neosnippet#snippets_directory='~/.vim/mysnippets'

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
  endif

" CtrlP
let g:ctrlp_custom_ignore = '\.git$\|\.o$\|\.app$\|\.beam$\|\.dSYM\|\.ipa$\|\.csv\|tags$\|public\/images$\|public\/uploads$\|log\|tmp$\|source_maps\|app\/assets\/images\|node_modules\|bower_components\|vendor\|components'
let g:ctrlp_mruf_max = 1000
let g:ctrlp_mruf_relative = 1
map <C-[> :CtrlPBuffer<CR>

let g:ctrlp_buffer_func = { 'enter': 'CtrlPMappings' }

function! CtrlPMappings()
  nnoremap <buffer> <silent> <C-@> :call <sid>DeleteBuffer()<cr>
endfunction

function! s:DeleteBuffer()
  let path = fnamemodify(getline('.')[2:], ':p')
  let bufn = matchstr(path, '\v\d+\ze\*No Name')
  exec "bd" bufn ==# "" ? path : bufn
  exec "norm \<F5>"
endfunction

" atags
map <Leader>a :call atags#generate()<cr>
let g:atags_build_commands_list = [
    \"ctags -f tags.tmp",
    \"awk 'length($0) < 400' tags.tmp > tags",
    \"rm tags.tmp"
    \]

" EasyTags
" set tags=./tags; " look for project specific tags files
" let g:easytags_cmd = '/usr/bin/ctags'
" let g:easytags_dynamic_files = 2 " will write to the first existing tags file seen by vim
" set cpoptions+=d " create tags file in working directory
" let g:easytags_events = ['BufReadPost', 'BufWritePost'] " update tags file after you save the file
" let g:easytags_always_enabled = 1

" Tagbar
" map <Leader>' :TagbarOpenAutoClose<CR>
map <Leader>' :TlistToggle<CR>

let Tlist_Use_Right_Window = 1
let Tlist_Show_One_File = 1
let Tlist_Highlight_Tag_On_BufEnter = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_WinWidth = 45
let Tlist_Close_On_Select = 1
let tlist_php_settings = 'php;c:class;f:function'

" Nerd Tree
map <Leader>n :NERDTreeToggle<CR>

" Airline
let g:airline_powerline_fonts = 1

" Colorscheme
set background=dark
let base16colorspace=256 " Access colors present in 256 colorspace
colorscheme base16-chalk

" Vim-test
let test#strategy = "vtr"
let g:VtrPercentage = 30
let g:VtrOrientation = "h"

nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>u :TestFile<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>

let test#javascript#jasmine#executable = 'jasmine'
let test#javascript#jasmine#file_pattern = '\vapp/.*\/.spec/.(ts|js|coffee)$'

" Markdown Composer
" let g:markdown_composer_syntax_theme = "pojoaque"
" let g:markdown_composer_autostart = 0
" map <leader>co :ComposerStart<CR>:ComposerOpen<CR>

" Floobits
map <Leader>ft :FlooToggleFollowMode<CR>
map <Leader>fs :FlooSummon<CR>

" Vim-go

au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)

" Php.vim

nmap <silent> <leader>pp :InsertBothGetterSetter<CR>
nmap <silent> <leader>pg :InsertGetterOnly<CR>
nmap <silent> <leader>ps :InsertSetterOnly<CR>
nmap <silent> <leader>pb :InsertBothGetterSetter<CR>

let g:no_plugin_maps = 1 
let g:no_php_maps = 1

let g:phpgetset_getterTemplate =
  \ "\t\n" .
  \ "\tpublic function %varname%()\n" .
  \ "\t{\n" .
  \ "\t\treturn $this->%varname%;\n" .
  \ "\t}"

let g:phpgetset_setterTemplate =
  \ "\t\n" .
  \ "\tpublic function %funcname%($%varname%)\n" .
  \ "\t{\n" .
  \ "\t\t$this->%varname% = $%varname%;\n" .
  \ "\t}"

" Lua
let g:lua_compiler_name = '/usr/bin/luac'
let g:lua_check_syntax = 0

" Typescript
autocmd FileType typescript map <buffer> <leader>m :!tsc<cr>

" 2. Moving around, searching and patterns
set incsearch 	" show match for partly typed search command
set ignorecase	" ignore case when using a search pattern
set smartcase	" override 'ignorecase' when pattern has upper case characters

" 4. Displaying text
set relativenumber " show the relative line number for each line
set wrap	" long lines wrap
set linebreak	" wrap long lines at a character in 'breakat'
set showbreak=>\
set scrolloff=5	" number of screen lines to show around the cursor
set hlsearch	" highlight all matches for the last used search pattern

" 6. Multiple windows
set splitright	" a new window is put right of the current one
set laststatus=2	" 0, 1 or 2; when to use a status line for the last window

" 11. Messages and info
set  showcmd	" show (partial) command keys in the status line

" 13. Editing text
set undolevels=1000 " maximum number of changes that can be undone
set undoreload=10000 " maximum number lines to save for undo on a buffer reload

" 14. Tabs and indenting
set ts=4 	" number of spaces a <Tab> in the text stands for
set sw=4	" number of spaces used for each step of (auto)indent
set sts=4	" if non-zero, number of spaces to insert for a <Tab>
set expandtab	" expand <Tab> to spaces in Insert mode
set smarttab	" a <Tab> in an indent inserts 'shiftwidth' spaces
set ai		" automatically set the indent of a new line

au FileType python set softtabstop=2 tabstop=2 shiftwidth=2
au FileType python3 set softtabstop=2 tabstop=2 shiftwidth=2
au FileType ruby set softtabstop=2 tabstop=2 shiftwidth=2
au FileType coffee set softtabstop=2 tabstop=2 shiftwidth=2 noexpandtab ai
au FileType jade set softtabstop=4 tabstop=4 shiftwidth=4 noexpandtab ai
au FileType slim set softtabstop=2 tabstop=2 shiftwidth=2
au FileType haml set softtabstop=2 tabstop=2 shiftwidth=2
au FileType erb set softtabstop=2 tabstop=2 shiftwidth=2
"au FileType ujs set softtabstop=2 tabstop=2 shiftwidth=2
"au FileType javascript setlocal ts=2 sts=2 sw=2 noexpandtab
"au FileType json setlocal ts=2 sts=2 sw=2 noexpandtab
"au FileType typescript setlocal ts=2 sts=2 sw=2 noexpandtab
au FileType j2 setlocal ts=2 sts=2 sw=2
au FileType php set softtabstop=4 tabstop=4 shiftwidth=4
au FileType lua setlocal ts=2 sts=2 sw=2
au FileType apib setlocal ts=4 sts=4 sw=4 noexpandtab ai
au FileType yaml setlocal ts=2 sts=2 sw=2 expandtab ai

" 18. Reading and writing files
set modeline 	" enable using settings from modelines when reading a file
set modelines=5	" number of lines to check for modelins
set backupdir=~/.vim/backups

" 19. The swap file
set noswapfile
set dir=~/.vim/backups

" 24. Multi-byte characters
" set enc=utf-8

" =========
" Filetypes
" =========

" Editorconfig
let g:EditorConfig_core_mode = 'external_command'

" Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile}    set ft=ruby
" Json
au BufNewFile,BufRead *.json set ft=json
" Ejs and Blade
au BufNewFile,BufRead *.ejs *.blade.php set filetype=html
" Html
au BufNewFile,BufRead *.html.slim set ft=slim
" Votl
au BufNewFile,BufRead *.txt set ft=votl
au BufNewFile,BufRead *.taskpaper set ft=votl
" Yml
au BufNewFile,BufRead *.yml set ft=ansible
au BufNewFile,BufRead *.j2 set ft=j2

" ============
" Key Bindings
" ============

nmap j gj
nmap k gk

vmap <F7> :<Esc>`>a<CR><Esc>mx`<i<CR><Esc>my'xk$v'y!xclip -selection c<CR>u
map <S-F7> :set paste<CR>i<CR><CR><Esc>k:.!xclip -o<CR>JxkJx:set nopaste<CR>

" ===========================
" Language Specific Functions
" ===========================
nnoremap <leader>ru <Esc>:TestSuite --testsuite=unit<CR>
nnoremap <leader>ra <Esc>:TestSuite --testsuite=acceptance<CR>
nnoremap <leader>ri <Esc>:TestSuite --testsuite=integration<CR>

" laravel mapping for unit testing
" nnoremap <leader>ru <Esc>:!clear; vendor/bin/phpunit %<CR>
" nnoremap <leader>rt :call RunSinglePhpunitTest()<CR>
" nnoremap <leader>ra <Esc>:!clear; vendor/bin/phpunit --testsuite="unit"<CR>
" nnoremap <leader>rf <Esc>:!clear; vendor/bin/phpunit --testsuite="functional"<CR>
" nnoremap <leader>rb <Esc>:!clear; vendor/bin/behat<CR>
" 
" nnoremap <leader>re <Esc>:!clear; ./protractor.sh<CR>
" nnoremap <leader>rc <Esc>:!clear; vendor/bin/codecept run<CR>
" nnoremap <leader>rs <Esc>:!clear; vendor/bin/phpspec run<CR>
" nnoremap <leader>rr <Esc>:!clear; vendor/bin/phpspec --config=phpspec.yml run %<CR>

map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
highlight link cMember Function

abbrev gm !php artisan generate:model
abbrev gc !php artisan generate:controller

" ===========================
" Dependencies on new install
"
" apt-get install silversearcher-ag
" apt-get install vim-nox
"

if &term =~ '256color'
    " Disable Background Color Erase (BCE) so that color schemes work
    " properly when Vim is used inside tmux and GNU screen.
    " See also http://snk.tuxfamily.org/log/vim-256color-bce.html
    set t_ut=
endif

if &term =~ '^screen'
    " Page up/down keys
    " http://sourceforge.net/p/tmux/tmux-code/ci/master/tree/FAQ
    execute "set t_kP=\e[5;*~"
    execute "set t_kN=\e[6;*~"

    " Home/end keys
    map <Esc>OH <Home>
    map! <Esc>OH <Home>
    map <Esc>OF <End>
    map! <Esc>OF <End>

    " Arrow keys
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

nmap <silent> <leader>x :!xrdb ~/.Xresources<cr>
" let $NVIM_TUI_ENABLE_TRUE_COLOR=1

let g:python3_host_prog = '/usr/bin/python3'

function! HighlightSpechail()
    if &list
        set nolist
    else
        set list
        set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<,space:.
    endif
endfunction

nnoremap <leader>h <Esc>:call HighlightSpechail()<cr>
