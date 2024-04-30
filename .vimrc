" UTF8 by default
set encoding=utf8

" Allow lines to extend off the side of the screen
set nowrap

" Highlight matching rows when searching
set hlsearch

" Start scrolling when we're 5 chars from the edge of the screen
set sidescrolloff=5

" Start scrolloing when we're 5 lines from the top/bottom of the screen
set scrolloff=5

" Indicate that a line is wider than the page with a >
set listchars+=precedes:<,extends:>

" Don't bother setting the screen title
set notitle

" Always display the statusbar
set laststatus=2

" now set it up to change the status line based on mode
if version >= 700
    au InsertEnter * hi StatusLine term=reverse ctermbg=green gui=undercurl guisp=white
    au InsertLeave * hi StatusLine term=reverse ctermfg=0 ctermbg=white gui=bold,reverse 
endif

" set default status bar
hi StatusLine term=reverse ctermfg=0 ctermbg=white gui=bold,reverse

" Status bar
set statusline=%t       "tail of the filename
"set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
"set statusline+=%{&ff}] "file format
"set statusline+=%h      "help file flag
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
"set statusline+=%y      "filetype
set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total line
set statusline+=\ %P    "percent through file

" Display cursor coordinates
set ruler

" Allow backspace to delete onto the previous line
set backspace=indent,eol,start

" Don't care about case when searching...
set ignorecase

" ...Unless we include capitals
set smartcase

" Indicate that we have a fast terminal
set ttyfast

" Colours for dark backgrounds
set background=dark

" Display line numbers
set number

" Keep the cursor in the same column...
"set autoindent

" ...Unless the previous line ended with a brace
"set smartindent

" Comment in the same column as the previous row
"inoremap # X#

" Always replace all occurences on current line
set gdefault

" Display search matches as you type
" set incsearch

" Tab == 4 spaces
set softtabstop=4

" Replace tabs with spaces
set expandtab

" 4 spaces with autoindent and >>
set shiftwidth=4

" Round indents to multiples of shiftwidth
set shiftround

" Highlight partner bracket when typing
set showmatch

" When we split, give focus to the new window
set splitbelow
set splitright

" We don't want to include underscores in words
"set iskeyword=@,48-57,192-255

" Look for tagfile here
set tags=~/.tags

" Highlight syntax
syntax on

" Tab completion of variables
inoremap <tab> <c-r>=InsertTabWrapper ("forward")<cr>
inoremap <S-tab> <c-r>=InsertTabWrapper ("backward")<cr>

function! InsertTabWrapper(direction)
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    elseif "backward" == a:direction
        return "\<c-p>"
    else
        return "\<c-n>"
    endif
endfunction

" custom command to save file opened as read only
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!

" Comment/uncomment block
map <F5> : s/^/#/<CR>
map <F6> : s/^#//<CR>

" dont create back-up files
"set nobackup

