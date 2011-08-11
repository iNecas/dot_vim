runtime macros/matchit.vim
set shell=/bin/bash
set nocompatible
set number
set ruler
syntax on

" Set encoding
set encoding=utf-8

" Whitespace stuff
set nowrap
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set list listchars=tab:\ \ ,trail:·

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc

" CTRL-n completion
set completeopt+=longest

" Status bar
set laststatus=2

" Without setting this, ZoomWin restores windows in a way that causes
" equalalways behavior to be triggered the next time CommandT is used.
" This is likely a bludgeon to solve some other issue, but it works
set noequalalways

" NERDTree configuration
let NERDTreeIgnore=['\.rbc$', '\~$']
map <Leader>n :NERDTreeToggle<CR>
let g:NERDTreeDirArrows = 1

" Command-T configuration
let g:CommandTMaxHeight=20

" ZoomWin configuration
map <Leader><Leader> :ZoomWin<CR>

" CTags
map <Leader>rt :!ctags --extra=+f -R *<CR><CR>

" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

function! s:setupWrapping()
  set wrap
  set wm=2
  set textwidth=72
endfunction

function! s:setupMarkup()
  call s:setupWrapping()
  map <buffer> <Leader>p :Mm <CR>
endfunction

" make uses real tabs
au FileType make                                     set noexpandtab

" Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru}    set ft=ruby

" md, markdown, and mk are markdown and define buffer-local preview
au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} call s:setupMarkup()

au BufRead,BufNewFile *.txt call s:setupWrapping()

" make python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
au FileType python  set tabstop=4 textwidth=79

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" load the plugin and indent settings for the detected filetype
filetype plugin indent on

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <Leader>e
map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <Leader>t
map <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Inserts the path of the currently edited file into a command
" Command mode: Ctrl+P
cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

" Unimpaired configuration
" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e
" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv

" Enable syntastic syntax checking
let g:syntastic_enable_signs=1
let g:syntastic_quiet_warnings=1

" Use modeline overrides
set modeline
set modelines=10

" Default color scheme
color desert

" Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup

" MacVIM shift+arrow-keys behavior (required in .vimrc)
let macvim_hig_shift_movement = 1

" Include user's local vim config
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

call pathogen#helptags()
call pathogen#infect()

nmap gn :NERDTreeFind<cr>

" set relativenumber
set undodir=~/.vimundo

nnoremap / /\v
vnoremap / /\v

" nnoremap j gj
" nnoremap k gk
" vnoremap j gj
" vnoremap k gk

nnoremap <leader><space> :noh<cr>

set wrap
set textwidth=79
set formatoptions=qrn1
"set colorcolumn=85

au FocusLost * :wa

inoremap jj <esc>
nnoremap <leader>w <C-w>v<C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Statusline {{{
"statusline setup
set statusline=%f "tail of the filename

"display a warning if fileformat isnt unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

"display a warning if file encoding isnt utf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

set statusline+=%h "help file flag
set statusline+=%y "filetype
set statusline+=%r "read only flag
set statusline+=%m "modified flag

" display current git branch
set statusline+=%{fugitive#statusline()}

"display a warning if &et is wrong, or we have mixed-indenting
set statusline+=%#error#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%*

"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"display a warning if &paste is set
set statusline+=%#error#
set statusline+=%{&paste?'[paste]':''}
set statusline+=%*

set statusline+=%= "left/right separator
"set statusline+=%{StatuslineCurrentHighlight()}\ \ "current highlight
set statusline+=%c, "cursor column
set statusline+=%l/%L "cursor line/total lines
set statusline+=\ %P "percent through file
set statusline+=%{rvm#statusline()}
"return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
  let name = synIDattr(synID(line('.'),col('.'),1),'name')
  if name == ''
    return ''
  else
    return '[' . name . ']'
  endif
endfunction

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
  if !exists("b:statusline_trailing_space_warning")
    if search('\s\+$', 'nw') != 0
      let b:statusline_trailing_space_warning = '[\s]'
    else
      let b:statusline_trailing_space_warning = ''
    endif
  endif
  return b:statusline_trailing_space_warning
endfunction

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
  if !exists("b:statusline_tab_warning")
    let tabs = search('^\t', 'nw') != 0
    let spaces = search('^ ', 'nw') != 0

    if tabs && spaces
      let b:statusline_tab_warning = '[mixed-indenting]'
    elseif (spaces && !&et) || (tabs && &et)
      let b:statusline_tab_warning = '[&et]'
    else
      let b:statusline_tab_warning = ''
    endif
  endif
  return b:statusline_tab_warning
endfunction

"return a warning for "long lines" where "long" is either &textwidth or 80 (if
"no &textwidth is set)
"
"return '' if no long lines
"return '[#x,my,$z] if long lines are found, were x is the number of long
"lines, y is the median length of the long lines and z is the length of the
"longest line
function! StatuslineLongLineWarning()
  if !exists("b:statusline_long_line_warning")
    let long_line_lens = s:LongLines()

    if len(long_line_lens) > 0
      let b:statusline_long_line_warning = "[" .
            \ '#' . len(long_line_lens) . "," .
            \ 'm' . s:Median(long_line_lens) . "," .
            \ '$' . max(long_line_lens) . "]"
    else
      let b:statusline_long_line_warning = ""
    endif
  endif
  return b:statusline_long_line_warning
endfunction

"return a list containing the lengths of the long lines in this buffer
function! s:LongLines()
  let threshold = (&tw ? &tw : 80)
  let spaces = repeat(" ", &ts)

  let long_line_lens = []

  let i = 1
  while i <= line("$")
    let len = strlen(substitute(getline(i), '\t', spaces, 'g'))
    if len > threshold
      call add(long_line_lens, len)
    endif
    let i += 1
  endwhile

  return long_line_lens
endfunction

"find the median of the given array of numbers
function! s:Median(nums)
  let nums = sort(a:nums)
  let l = len(nums)

  if l % 2 == 1
    let i = (l-1) / 2
    return nums[i]
  else
    return (nums[l/2] + nums[(l/2)-1]) / 2
  endif
endfunction


"returns the count of how many words are in the entire file excluding the current line
"updates the buffer variable Global_Word_Count to reflect this
fu! OtherLineWordCount()
  let data = []
  "get lines above and below current line unless current line is first or last
  if line(".") > 1
    let data = getline(1, line(".")-1)
  endif
  if line(".") < line("$")
    let data = data + getline(line(".")+1, "$")
  endif
  let count_words = 0
  let pattern = "\\<\\(\\w\\|-\\|'\\)\\+\\>"
  for str in data
    let count_words = count_words + NumPatternsInString(str, pattern)
  endfor
  let b:Global_Word_Count = count_words
  return count_words
endf    

"returns the word count for the current line
"updates the buffer variable Current_Line_Number
"updates the buffer variable Current_Line_Word_Count
fu! CurrentLineWordCount()
  if b:Current_Line_Number != line(".") "if the line number has changed then add old count
    let b:Global_Word_Count = b:Global_Word_Count + b:Current_Line_Word_Count
  endif
  "calculate number of words on current line
  let line = getline(".")
  let pattern = "\\<\\(\\w\\|-\\|'\\)\\+\\>"
  let count_words = NumPatternsInString(line, pattern)
  let b:Current_Line_Word_Count = count_words "update buffer variable with current line count
  if b:Current_Line_Number != line(".") "if the line number has changed then subtract current line count
    let b:Global_Word_Count = b:Global_Word_Count - b:Current_Line_Word_Count
  endif
  let b:Current_Line_Number = line(".") "update buffer variable with current line number
  return count_words
endf    

"returns the word count for the entire file using variables defined in other procedures
"this is the function that is called repeatedly and controls the other word
"count functions.
fu! WordCount()
  if exists("b:Global_Word_Count") == 0
    let b:Global_Word_Count = 0
    let b:Current_Line_Word_Count = 0
    let b:Current_Line_Number = line(".")
    call OtherLineWordCount()
  endif
  call CurrentLineWordCount()
  return b:Global_Word_Count + b:Current_Line_Word_Count
endf

fu! NormoStrany()
  let normo_pages = line2byte(line("$"))/str2float('1800.0')
  return printf("%.2f",normo_pages)
endfu

"returns the number of patterns found in a string
fu! NumPatternsInString(str, pat)
  let i = 0
  let num = -1
  while i != -1
    let num = num + 1
    let i = matchend(a:str, a:pat, i)
  endwhile
  return num
endf
autocmd FileType tex                    setlocal statusline+=\ wc:%{WordCount()}\ ns:%{NormoStrany()} " nounting wordcoutn and normo pages
autocmd FileType tex                    setlocal autoindent " autoindent in tex
autocmd FileType tex                    setlocal spelllang=en " autoindent in tex
autocmd FileType tex                    setlocal spell " autoindent in tex
autocmd FileType tex                    highlight SpellBad NONE
autocmd FileType tex                    highlight SpellBad gui=none guifg=Red
autocmd FileType ruby                    setlocal spelllang=en " autoindent in tex
autocmd FileType ruby                    setlocal spell " autoindent in tex
set laststatus=2 " Always show status line
" }}}

" Spell Chekcing {{{
highlight SpellBad NONE
highlight SpellBad gui=none guifg=Red
" }}}
"
" sudo save
cmap w!! w !sudo tee % >/dev/null

" Cucumeber table bar {{{

inoremap <silent> <Bar> <Bar><Esc>:call <SID>align()<CR>a

    function! s:align()
      let p = '^\s*|\s.*\s|\s*$'
      if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
        let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
        let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
        Tabularize/|/l1
        normal! 0
        call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
      endif
    endfunction
" }}}
"
set autowriteall

" Specky {{{"
    let g:speckyBannerKey        = "<C-S>b"
    let g:speckyQuoteSwitcherKey = "<C-S>'"
    let g:speckyRunRdocKey       = "<C-S>r"
    let g:speckySpecSwitcherKey  = "<C-S>x"
    let g:speckyRunSpecKey       = "<C-S>s"
    let g:speckyRunRdocCmd       = "fri -L -f plain"
    let g:speckyWindowType       = 2
    let g:speckyRunSpecCmd = "bundle exec rspec -r ~/.vim/ruby/specky_formatter.rb -f SpeckyFormatter"
" }}}"

" RunSpec  {{{"

" Run current spec (rspec current)
" noremap <Leader>rc :RunSpec<CR>

" Run all specs (rspec all)
noremap <Leader>ra :RunSpecs<CR>

" }}}"


" CamelCase vs snake_case {{{"
vnoremap <leader>C :s/_\([a-z]\)/\u\1/g<CR>
vnoremap <leader>c :s/\([A-Z]\)/_\l\1/g<CR>
" }}}"


" Folding {{{ "
autocmd FileType ruby setlocal foldcolumn=1

" }}}"

map <Leader>rt :!ctags --extra=+f --exclude=.git --exclude=log -R * `rvm gemdir`/gems/*<CR><CR>

" disable terrible sound effects
set noerrorbells visualbell t_vb=

command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
  echo a:cmdline
  let expanded_cmdline = a:cmdline
  for part in split(a:cmdline, ' ')
     if part[0] =~ '\v[%#<]'
        let expanded_part = fnameescape(expand(part))
        let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
     endif
  endfor
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1, 'You entered:    ' . a:cmdline)
  call setline(2, 'Expanded Form:  ' .expanded_cmdline)
  call setline(3,substitute(getline(2),'.','=','g'))
  execute '$read !'. expanded_cmdline
  setlocal nomodifiable
  1
endfunction

" Show current changes
noremap <Leader>cp :call Svndiff("prev")<CR>
noremap <Leader>cn :call Svndiff("next")<CR>
noremap <Leader>cc :call Svndiff("clear")<CR>
noremap <Leader>l :Rlog<CR>

" Show split in new tab and close afterwards
noremap <Leader>to :tabedit %<CR>
noremap <Leader>tc :tabclose<CR>

" Remove trailing spaces
noremap <Leader>rs :%s/\s*$//g<CR>:noh<CR>

" Split always redistribute
set equalalways

" Split unless opened {{{
function! MySplit( cmd, file )
    let bufnum=bufnr(expand(a:file))
    let winnum=bufwinnr(bufnum)
    if winnum != -1
        " Jump to existing split
        exe winnum . "wincmd w"
    else
        " Make new split as usual
        exe a:cmd . a:file
    endif
endfunction


command! -nargs=1 Split :call MySplit("split ", "<args>")
" }}}

" GUI {{{
 set guioptions-=r
 set guioptions-=l
 set guioptions-=R
 set guioptions-=L
" }}} 

" Git
map <Leader>g :r!git log --format=format:\%s HEAD^..HEAD<CR>kJ

" QuickfixSign
noremap <Leader>q :QuickfixsignsSet<cr>

" ConqueTerm experiments

fu! MyConqueStartup(term)
  stopinsert!
endfu

call conque_term#register_function("after_startup","MyConqueStartup")

let g:term_commands = {}
fu! s:RunInTerm(name, command)
  if ! has_key(g:term_commands,a:name)
    let term = conque_term#open("/bin/bash --init-file ~/.bash_profile", ['botright split'],1)
    let g:term_commands[a:name] = term
  endif
  let term = g:term_commands[a:name]
  call term.focus()
  call term.write(a:command)
endfu

command! -nargs=+ Term :call s:RunInTerm(<args>)

map <leader>rc :Term "test", "cucumber -r features <C-R>%\n"<cr>
