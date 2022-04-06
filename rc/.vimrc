" Initialize
set nocompatible                  " do not preserve compatibility with Vi
set modifiable                    " buffer contents can be modified
set encoding=utf-8                " default character encoding
set autoread                      " detect when a file has been modified externally
set spelllang=en,es               " languages to check for spelling (english, spanish)
set spellsuggest=10               " number of suggestions for correct spelling
set updatetime=500                " time of idleness is milliseconds before saving swapfile
set undolevels=1000               " how many undo levels to keep in memory
set showcmd                       " show command in last line of the screen
set nostartofline                 " keep cursor in the same column when moving between lines
set errorbells                    " ring the bell for errors
set visualbell                    " then use a flash instead of a beep sound
set belloff=esc                   " hitting escape in normal mode does not constitute an error
set confirm                       " ask for confirmation when quitting a file that has changes
set hidden                        " hide buffers
set autoindent                    " indent automatically (useful for formatoptions)
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set shiftwidth=4                  " needs to be the same as tabstop
set smartcase                     " ignore case if the search contains majuscules
set hlsearch                      " highlight all matches of last search
set incsearch                     " enable incremental searching (get feedback as you type)
set backspace=indent,eol,start   " backspace key should delete indentation, line ends, characters
"set whichwrap=s,b                " which motion keys should jump to the above/below wrapped line
set textwidth=72                  " hard wrap at this column
set joinspaces                    " insert two spaces after puncutation marks when joining multiple lines into one
set wildmenu                      " enable tab completion with suggestions when executing commands
set wildmode=list:longest,full    " settings for how to complete matched strings
set nomodeline                    " vim reads the modeline to execute commands for the current file
set modelines=0                   " how many lines to check in the top/bottom of the file. 0=off
set number                        " show line numbers
set relativenumber                " show relative line numbers
set tabpagemax=15                 " Max tabs for each vim page
set clipboard=unnamedplus         " Yank to clipboard
set cursorline                    " Display an underline where the cursor is located
set showmatch                     " Highlight the matching part of the brackets, (), {} and []
set fileformat=unix               " It is used to inform vim about the file format and how to read the file
set mouse=a						  " It enables mouse usage

" defines how automatic formatting should be done (see :h fo-table)
set formatoptions-=t formatoptions-=o formatoptions+=crqjnl1
filetype plugin on                " load syntax options for different file types
filetype indent on                " load indent options for different file types

" invisible characters to display (with :set list)
set listchars=tab:›\ ,nbsp:␣,trail:•,precedes:«,extends:»
""""set listchars=tab:›\ ,space:·,nbsp:␣,trail:•,eol:¬,precedes:«,extends:»

syntax enable

" Vundle config
set rtp+=~/.vim/bundle/Vundle.vim
so ~/.vim/plugins.vim
so ~/.vim/plugins-config.vim
so ~/.vim/maps.vim

" Python
let python_highlight_all = 1
au BufNewFile,BufRead *.py set ts=4 softtabstop=4 shiftwidth=4 textwidth=79 expandtab

" Bash
au BufNewFile,BufRead *.sh set ts=4 softtabstop=4 shiftwidth=4 textwidth=79 expandtab

" Bash
au BufNewFile,BufRead *.ts set syntax=typescript.tsx

" abbreviations (try not to use common words)
iab medate <c-r>=strftime('%Y-%m-%d')<cr>

