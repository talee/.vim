" Main Features:
"   * Free reign cursor - can go anywhere on screen
"   * Automatic bulleted lists
"   * Clean GUI window - maximize space for editing
"   * Screen position and size autosave
"
" Maintainer:    Thomas Lee
" Requires:      Unix for compiling, everything else should work on Windows
"                Pathogen  - plugin management
"                Gundo     - undo tree
"                Syntastic - syntax checker
"                synic     - 256 color theme;
"                            traditional syntax colors and reduces eye strain
" License:       Public domain
"
" Contents:      Jump to section by pressing * over section name in Vim
"                Type 'za' to toggle folded sections.
"
"   1. PROGRAM_OPTIONS
"   2. TEXT_FORMATTING_OPTIONS
"   3. GUI_OPTIONS
"   4. COMMAND_OPTIONS
"   4. PLUGINS
"   5. FUNCTIONS

" PROGRAM_OPTIONS --------------------------------------------------------- {{{

set nocompatible  "Don't maintain compatibility with vi.  Shouldn't be changed.
set virtualedit=all  "Allow cursor to go anywhere in the window, even if no
                     "text exists (virtualedit)

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set runtimepath+=~/.vim  "Set path for custom user plugins, colors, syntax etc.
set linebreak " Break at words boundaries instead of characters
filetype plugin on
filetype plugin indent on
set modelines=5  " Default number of modelines
set switchbuf=useopen " Jump to open buffer window instead of splitting on :sb
set pythonthreehome=/usr/local/Frameworks/Python.framework/Versions/Current
set pythonthreedll=/usr/local/Frameworks/Python.framework/Versions/Current/Python

" In many terminal emulators the mouse works just fine, thus enable it. --- {{{
if has('mouse')
  set mouse=a
endif
" }}}
" Allows bash aliases by specifying config with bash interactive mode ------ {{{
if has("unix")
    set shellcmdflag+=i
    set shell=/bin/bash\ --rcfile\ ~/.bash_aliases
endif " }}}
" Backups - Disable persistent swap files ---------------------------------- {{{
set nobackup     "Don't keep persistent backup (prevent filename~ clutter)
set writebackup  "Only create/write backup when editing the file
"set directory=~/tmp,/var/tmp,/tmp "Set director(ies) for temp/swap files }}}

"}}}
" TEXT_FORMATTING_OPTIONS ------------------------------------------------- {{{

" Comment formatting options ---------------------------------------------- {{{
" r    Automatically insert the current comment leader after hitting <Enter> in
"      Insert mode.
" o    Automatically insert the current comment leader after hitting 'o' or 'O'
"      in Normal mode
set formatoptions+=ro  "result: croql.  See fo-table for option descriptions
                 
"}}}
" Increment/decrement of value types below via CTRL-A and CTRL-X ---------- {{{
set nrformats=octal,hex,alpha

" }}}
" Indentation - Use spaces  ----------------------------------------------- {{{
set textwidth=0   "Prevents splitting lines when text begins wrapping
set wrap          "Turns on word wrapping at the end of the window
set tabstop=4     "Tabs take up 4 spaces on the screen
set shiftwidth=4  "Number of spaces for indents such as >>, <<
set noexpandtab   "Do NOT replace tab character with spaces set in 'tabstop'
au FileType html,htm,css,javascript,json,coffee,php,xhtml,scss,sass,groovy setlocal ts=4 sw=4 tw=80 expandtab nofen fdm=expr "| vertical resize 80
au FileType yaml setlocal ts=2 sw=2  tw=80 fo+=t
au FileType jsonnet setlocal et
au BufRead,BufNewFile *.json set ft=json nofen
au BufRead,BufNewFile *.es6 set ft=javascript nofen
au BufRead,BufNewFile .bashrc set ft=sh nofen
au BufRead,BufNewFile .vimrc set ft=vim
au BufRead,BufNewFile *.tag setlocal ft=jsx omnifunc=htmlcomplete#CompleteTags ts=2 sw=2 tw=80 expandtab nofen fdm=expr "| vertical resize 80
au BufRead,BufNewFile Jenkinsfile set ft=groovy
au FileType markdown setlocal tw=80
au FileType gitcommit setlocal nofen

"}}}
" Nested bullets i.e. *, **, *** or #, ##. "n:" means nested comments  ---- {{{
set comments+=n:*,n:#

"}}}
" Prevents comment insertion after first line for certain file types ------ {{{
"            // Comment
"            int a;      <- This line won't have "// " auto-inserted
au FileType c,cpp,java setlocal comments-=:// comments+=f:// nofen

"}}}
" Text wrapping marker symbols -------------------------------------------- {{{
"In 'set list' mode:
    "tabs:xy     Show tabs as 'x', then fill tabstop with 'y' char
    "eol:c       Show end of each line as 'c' char
	"extends:c	 Show 'c' char where line continues beyond the right of the
	"  	         screen.
	"precedes:c	 Show 'c' char where line continues beyond the left of the
	"  	         screen. 
set listchars=tab:│┄,eol:¬,extends:❯,precedes:❮ 
set showbreak=↪

"}}}
" Unused/not-working(?) attempts to set automatic comment insertion ------- {{{
"set comments=sl:/*,mb:*,elx*/
"set comments=s1:/*,mb:*,ex:*/,b:#,:%,:XCOMM,n:>,fb:-
"set comments=s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-
"}}}
" Autocomplete hyphen words ------------------------------------------------ {{{
set iskeyword+=\-
" }}}

" }}}
" GUI_OPTIONS ------------------------------------------------------------- {{{

" Remove unused GUI components -------------------------------------------- {{{
set guioptions-=T  "Removes toolbar
set guioptions-=r  "Removes right scroll bar
set guioptions-=l  "Removes left scroll bar
set guioptions-=L  "Removes left scroll bar present when vsplit
set guioptions-=m  "Removes menu bar
set guioptions-=t  "Removes tearoff menu items
set guioptions-=m  "Removes GUI tabs, uses flat tabs instead
"result: guioptions=agi; auto,show grey menu items,icon
"}}}
" Fold sections ----------------------------------------------------------- {{{
au FileType vim setlocal foldmethod=marker
"set foldlevelstart=0   "Set initial depth of folded lines, zero == start folded
set foldmethod=syntax  "Use syntax files to determing which blocks to fold
"Default no folding at load
set nofen
"au FileType html,xml setlocal foldmethod=indent  " Use indents for tag based files
" Line folding utilities - stevelosh.com ---------------------------------- {{{

" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za

" Make zO recursively open whatever top level fold we're in, no matter where the
" cursor happens to be.
nnoremap zO zCzO

function! MyFoldText() " {{{
    let line = getline(v:foldstart)

    let origNu =  &nu
    let origRnu =  &rnu
    set nu
    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart
    if origNu
        set nu
    else
        set nonu
    endif
    if  origRnu
        set rnu
    else
        set nornu
    endif

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    "execute 'echo' foldedlinecount
    return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction " }}}
set foldtext=MyFoldText()
" }}}

"}}}
" Indicator lines --------------------------------------------------------- {{{
set cursorline  "Highlight the current line with hl-CursorLine in theme

"synic theme's default colorcolumn setting (is dark red)
"inside synic's file, add the following line for a non-distracting column
"hi ColorColumn ctermbg=black guibg=gray9
set colorcolumn=81  "Creates a color column at specified column number; helps
                    "maintain code readabilty by reminding coder to keep code
                    "width near 80 columns

"}}}
" Line numbering (off) ---------------------------------------------------- {{{
set nornu
set nonu
"set relativenumber "Show line numbers relative to current line. Useful for any
                    "vertical motion commands with (e.g. y d c < > gq gw =)
"set number  "Turn on line numbering. 
"textwidth == 0 so numbered list shouldn't be working.  '*' bullet lists work
"}}}
" Set statusline to emulate ':set ruler', show filetype, row/col, etc.  --- {{{
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set laststatus=2  "Always have status line, even if only one window is open

"}}}

" Display incomplete commands
set showcmd

" Resize splits when the window is resized - stevelosh.com
au VimResized * :wincmd =

" Specify longer character for the divider between vertical splits
set fillchars=vert:│

" Don't antialias fonts in GUI Vim. Prevents blurry fonts on Mac
if has ("gui_running") && has("mac")
	set noantialias
	set guifont=Monaco:h10
	"set guifont=Meslo\ LG\ S\ Regular\ for\ Powerline:h15
	set transparency=10
endif

" }}}
" COMMAND_OPTIONS --------------------------------------------------------- {{{
"cabbr <expr> %% expand('%:p:h')  "Alias for current file location

"Better Keyword Completion - stevelosh.com
set completeopt=longest,menuone,preview

"Use very 'magic' regexes. Normally \(\), \{, now (), { have special meaning
"nnoremap / /\c
"vnoremap / /\c
"Use very 'magic' regexes for substitution.
"cnoreabbrev %s %s /\v<C-R>=Eatchar('\s')<CR>
"Only match case when upper case characters exist
set ignorecase
set smartcase

"Paste from Mac clipboard
set clipboard=unnamed

"Paste from Mac clipboard
"nnoremap "+p :r !pbpaste<CR>
"TODO: Allow non Macs to paste

"Used for removing the space appended to abbreviations. From 'help map.'
function! Eatchar(pat)
    let c = nr2char(getchar(0))
    return (c =~ a:pat) ? '' : c
endfunction

"CDC = change current directory to working directory of current file
command! CDC lcd %:p:h
command! Gros lcd `groo`/src
command! -nargs=+ Grbi read !grbnci <args>

"Find stuff ending in current file ext
command! -nargs=+ Vgr execute "lvimgrep <args> src/**/*." . expand('%:e') | lopen

"Fix any broken folded sections using 'zx' whenever we write to file (may
"close other folds)
au FileType vim cnoreabbrev w w<bar>normal zx


"Abbreviate finding files containing a given string
cnoreabbrev ffc new<bar>r!ffc
cnoreabbrev rr new<bar>r!
cnoreabbrev Grb new<bar>r!grbncc
cnoreabbrev vsb vert sb

"Save with Ctrl-Space
inoremap <NUL> <Esc>:update<CR>
noremap <NUL> <Esc>:update<CR>

noremap gf :e! <cfile><CR>

"Spellon/off toggles spelling check --------------------------------------- {{{
command! Spellon  setlocal spell spelllang=en_us
command! Spelloff setlocal nospell
"}}}

" JS: Surround with braces above and below
au FileType javascript nnoremap <F3> C{"}%I
au FileType javascript nnoremap <F2> :up <bar> :call RunJS()<CR>
function! RunJS()
  set shellcmdflag-=i
  execute "!babel-node %"
  redraw
  set shellcmdflag+=i
endfunction

"<F2> hotkey to run the current Go file ----------------------------------- {{{
au FileType go nnoremap <F2> :w<CR> :!echo "==== BUILD & RUN ====" && go run %<CR>
" }}}

"<F2> hotkey to test current awk file on a blank -------------------------- {{{
au FileType awk nnoremap <F2> :w<CR> :call CompileAwk()<CR>
function! CompileAwk()
    echo system('awk -f ' . expand('%:t'), " ")
endfunction
"}}}

"<F2> hotkey to compile current C/C++ file to current directory and run it
au FileType c,cc,cpp nnoremap <F2> :w<CR> :!g++ -Wall % -o ./%< && ./%<<CR>

"<F3> hotkey to compile current C/C++ file to current directory
au FileType c,cc,cpp nnoremap <F3> :w<CR> :!g++ -Wall % -o ./%<<CR>

"<F4> - Full memory check quietly with valgrind (C/C++) ------------------- {{{
"compiles with debug symbols using  '-g'
au FileType c,cc,cpp nnoremap <F4> :w<CR> :!g++ -Wall -g % -o ./%< && valgrind --leak-check=full -q ./%<<CR>
"}}}

" <F2> run shell script
au FileType sh nnoremap <F2> :w<CR> :!sh %<CR>

"<F2> - Compile Java source directory to build directory and run it ------- {{{
"Uses the same build directory structure as Netbeans
au FileType java nnoremap <F2> :call CompileJava("build/classes/", "", "", 1)<CR>
"Allow additional sourcePaths as arguments after runAfter
function! CompileJava(compilePath, sourcePath, classPath, runAfter, ...)
    set shellcmdflag-=i
    write
    silent !echo -en "\n=========================== BEGIN COMPILING ==============================="
    "Preserve original current directory
    let origDirectory = escape(getcwd(), ' ')
    lcd %:p:h                      "Change directory to current file
    let fileToRun = expand("%:r")  "Current file/buffer open; ext removed
    let fileToCompile = shellescape(expand("%:p"))  "Current buffer with ext
    "Change to root directory level above src directory if we want neat compile
    if isdirectory("../src/")
        lcd ..                         
    endif
    " Set SOURCEPATH
    let l:sourcePath = ""
    if isdirectory("src/")  "Neat compile
        let l:sourcePath = getcwd() . "/src/"
    endif
    if a:sourcePath != ""
        let l:sourcePath .=  ':' . a:sourcePath
    endif
    " Set CLASSPATH
    let l:classPath = ""
    if a:classPath != ""
        let l:classPath = $CLASSPATH . ":" . a:classPath
    endif
    " Add 'lib' to CLASSPATH if it exists
    if isdirectory("lib/")
        if l:classPath == ""
            let l:classPath = escape(getcwd(), ' ') . '/lib/'
        else
            let l:classPath .= ':' . escape(getcwd(), ' ') . '/lib/'
        endif
        
        "Add all jar files in lib
        let l:classPath .= escape(system('find . -name "*jar" | sed "s/^./:' . escape(getcwd(), '/') . '/" | tr -d "\n"'), ' ')
        let l:classPath .= ':'
    endif
    " Set additonal SOURCEPATH (s)
    let otherSourcePaths = ''
    for path in a:000
        otherSourcePaths .= ':' . escape(path, ' ')
    endfor

    "Create directory for compiled classes if we want neat compiles and the
    "the build directory doesn't exist
    let l:compilePath = a:compilePath
    if isdirectory("src/")
        if !isdirectory(a:compilePath)
            call mkdir(a:compilePath, "p")
            if !isdirectory(a:compilePath)
                execute '!echo "Failed to create build directory: "' getcwd() . '/' . a:compilePath
            endif
        endif
    else
        let l:compilePath = "."
    endif

    "Prepend '-cp' flag if classpath is specified
    let l:classPathFlag = ""
    if l:classPath != ""
        let l:classPath = "-cp " . l:classPath
    elseif l:compilePath != ""
        let l:classPathFlag = "-cp"
    endif

    if a:runAfter == 1
        "Ideas for color output. Problem: executing java only on succcessful
        "compiles / ...do it later
        "if has("unix")
        "    let runCommand = "| colorit "
        "endif
        
        if isdirectory("src/")
            let l:runCommand = "java " . l:classPathFlag . ' ' . l:classPath . l:compilePath . ' ' . l:fileToRun
        else
            let l:runCommand = "java " . l:classPath . ' ' . l:fileToRun
        endif
    endif

    "Shellescape paths to allow spaces in path.  Surrounds with '
    let l:sourcePathEnd = ""
    if l:sourcePath != " "
        let l:sourcePathFlag = "-sourcepath"
        let l:sourcePath = shellescape(l:sourcePath . l:otherSourcePaths)
    endif
    execute "!if javac -Xlint" l:sourcePathFlag l:sourcePath l:classPath fileToCompile '-d' l:compilePath . ' 2>&1 | head -16 | sed "s/^.*\(\/[^\/]\+\/[^\/]\+.java\)/\1/" | grep --color=always "\^\|[[:digit:]]\+:.\+$\|javac:.\+$" -C 8; then echo -n ' . '; else' l:runCommand . "; fi"
    redraw  "In case all the silent executes mess the screen up
    execute 'lcd' origDirectory
    set shellcmdflag+=i
endfunction
" END CompileJava function }}}

"<F3> - Compile JUnit tests and classes and run all of them --------------- {{{
au FileType java nnoremap <F3> :call RunJUnitTests()<CR>
function! RunJUnitTests()
    set shellcmdflag-=i
    "silent prevents hit-enter prompt but also messes up redraw
    silent !echo -e "\\ncompiling-src:"
    silent call CompileJava("build/classes/", "src", "",  0)

    silent !echo -e "\\ncompiling-test:"
    "Append JUnit to CLASSPATH if it's not there already
    if stridx($CLASSPATH, "junit") == -1
      let $CLASSPATH = $CLASSPATH . ":/usr/lib/default-junit:/usr/lib/default-junit/junit.jar"
    endif
    silent call CompileJava("build/test/classes/", "test", "",  0)

    let $CLASSPATH = $CLASSPATH . ':build/classes/:build/test/classes/'
    silent !echo -e "\\nrunning-tests:"
    "Deprecated: Use ant instead
    "Runs all tests in build/test/classes/
    "silent !ls build/test/classes/ | sed s/\.class// | xargs java org.junit.runner.JUnitCore

    "Run ant test target
    silent !ant test

    !echo "done."
    redraw
    set shellcmdflag+=i
endfunction
" END Compile/run JUnit tests }}}

"<F4> - Compile Javadoc to a 'javadoc' directory on the same level as 'src' {{{
au FileType java nnoremap <F4> :call CompileJavadoc()<CR>
function! CompileJavadoc()
    write
    "Preserve original current directory
    let origDirectory = escape(getcwd(), ' ')
    lcd %:p:h                      "Change directory to current file
    lcd ..  "Change to one directory level above
    "'xdg-open file' opens Nautilus?! so hardcode opening URL in browser
    silent execute '!pwd | grep --color=none -o "[^/]\+$" | xargs javadoc src/*.java -sourcepath src/ -d javadoc/ -windowtitle'
    execute '!google-chrome file://' . getcwd() . '/javadoc/index.html &> /dev/null'
    redraw
    execute 'lcd' origDirectory
endfunction
"}}}

" }}}
" PLUGINS ----------------------------------------------------------------- {{{

" COLORSCHEME - Synic  ---------------------------------------------------- {{{
"Use 'synic' coloring theme (place file in $HOME/.vim/colors)
if has("gui_running")  "is GVim?
    colors synic
"elseif ($COLORTERM == "gnome-terminal")  "inside a color terminal i.e. gnome?
else
    set t_Co=256  "Hint Vim to use 256 colors
    colors synicTerminal "Created using colorsupport plugin command
    "Use ':ColorSchemeSave <name>' with any GUI colorscheme so it looks the same in
    "the terminal as the GUI version with 256 colors
"else
"    silent execute '!export TERM=xterm-color'
"    colors default  "fall-back color theme
endif

" }}}
" COLORIZER --------------------------------------------------------------- {{{
let g:colorizer_startup = 0
" }}}
" POWERLINE --------------------------------------------------------------- {{{
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup
" }}}
" SYNTASTIC - Realtime syntax checking  ----------------------------------- {{{
"Add line # and number of errors in status line for Syntastic plugin
" Don't set these with powerline? https://github.com/vim-syntastic/syntastic/issues/1689
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"Creates column on lefthand side of window containing marks at lines with errors
let g:syntastic_enable_signs=1
"Opens and closes syntax error list if errors exist; use ":Errors" to show
let g:syntastic_auto_loc_list=1
let g:syntastic_loc_list_height=3  "Sets the height of the error list
" Ignore ng-* errors
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-", "}}\"", " proprietary attribute \"unresolved", " proprietary attribute \"fullbleed", " proprietary attribute \"layout", " proprietary attribute \"vertical", " proprietary attribute \"horizontal", " proprietary attribute \"end", " is not recognized", "discarding unexpected <core-", "discarding unexpected <paper-", "discarding unexpected <iron-", "discarding unexpected </core-", "discarding unexpected </paper-", "discarding unexpected </iron-", "discarding unexpected <template", "discarding unexpected </template", "discarding unexpected <dom-", "discarding unexpected </dom-"]
" Use JSHint instead of JSLint
" let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_go_checkers = ['go']
let g:syntastic_json_checkers = ['jsonlint']
let g:syntastic_cpp_compiler_options="-I/usr/local/include/SDL2 -D_THREAD_SAFE -L/usr/local/lib -lSDL2"
" Don't check on wq
let g:syntastic_check_on_wq = 0
" let g:syntastic_javascript_eslint_args = '--no-eslintrc -c ~/.eslintrc'
"let g:syntastic_javascript_jshint_args = '--config ~/.jshintrc'
autocmd BufNewFile,BufRead *.hbs let g:syntastic_html_tidy_ignore_errors=["missing </form>", "inserting implicit <form>", "<input> isn't allowed in <body> elements"]

" }}}
" GUNDO - Visualize undo tree with Gundo (F5)  ---------------------------- {{{
"http://www.vim.org/scripts/script.php?script_id=3304
nnoremap <F5> :GundoToggle<CR>

" }}}
" PATHOGEN - cleaner plugin management - plugins in their own folder  ----- {{{
let g:pathogen_disabled = []
if !has('gui_running') && (!exists('g:light_startup') || g:light_startup == 1)
  call add(g:pathogen_disabled, 'syntastic')
  call add(g:pathogen_disabled, 'nerdtree')
endif
call pathogen#infect()  "http://www.vim.org/scripts/script.php?script_id=2332
" }}}
" MUSTACHE HANDLEBARS - syntax highlighting and abbrev -------------------- {{{
let g:mustache_abbreviations = 1
" }}}
" JavaImp ----------------------------------------------------------------- {{{
" TODO: https://github.com/rustushki/JavaImp.vim#importing-your-jdk-classes
let g:JavaImpPaths = $HOME . "/.vim/bundle/java-imp/jmplst"
let g:JavaImpDataDir = $HOME. "/.vim/bundle/java-imp"
" }}}
" EMMET-VIM --------------------------------------------------------------- {{{

let g:user_emmet_install_global = 0
autocmd FileType html,css,jsx,javascript EmmetInstall | imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")
"}}}
" MISC - list/URLs of plugins - some are not called directly by this vimrc  {{{
"-------------------------------------------------------------------------------

"colorsupport  - autoconverts 256 color GUI themes in terminal
"https://github.com/vim-scripts/colorsupport.vim

"gundo  - undo history tree with branching
"http://sjl.bitbucket.org/gundo.vim

"NERDtree  - powerful file/directory tree browser
"https://github.com/scrooloose/nerdtree

"pathogen  - allows each plugin to be in its own folder + management
"https://github.com/tpope/vim-pathogen

"rename  - renames current file
"http://www.vim.org/scripts/script.php?script_id=1928

"syntastic  - checks syntax without compiling the whole thing
"https://github.com/scrooloose/syntastic

"tabmerge  - merges tabs together
"http://www.vim.org/scripts/script.php?script_id=1961
" }}}

" }}}
" FUNCTIONS --------------------------------------------------------------- {{{


" Use eslint ------------------------------------------------------------- {{{
function! UseEslint()
  let g:syntastic_javascript_checkers = ['eslint']
endfunction
" }}}
" Font size -------------------------------------------------------------- {{{
function! LargeFont()
  set guifont=Monaco:h44
endfunction
function! NormalFont()
  set guifont=Monaco:h10
endfunction
" }}}
" Enable saving and restoring of screen positions.  ----------------------- {{{
"See http://vim.wikia.com/wiki/Restore_screen_size_and_position
if has("gui_running")
  function! ScreenFilename()
    if has('amiga')
      return "s:.vimsize"
    elseif has('win32')
      return $HOME.'\_vimsize'
    else
      return $HOME.'/.vimsize'
    endif
  endfunction

  function! ScreenRestore()
    " Restore window size (columns and lines) and position
    " from values stored in vimsize file.
    " Must set font first so columns and lines are based on font size.
    let f = ScreenFilename()
    if has("gui_running") && g:screen_size_restore_pos && filereadable(f)
      let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
      for line in readfile(f)
        let sizepos = split(line)
        if len(sizepos) == 5 && sizepos[0] == vim_instance
          silent! execute "set columns=".sizepos[1]." lines=".sizepos[2]
          silent! execute "winpos ".sizepos[3]." ".sizepos[4]
          return
        endif
      endfor
    endif
  endfunction

  function! ScreenSave()
    " Save window size and position.
    if has("gui_running") && g:screen_size_restore_pos
      let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
      let data = vim_instance . ' ' . &columns . ' ' . &lines . ' ' .
            \ (getwinposx()<0?0:getwinposx()) . ' ' .
            \ (getwinposy()<0?0:getwinposy())
      let f = ScreenFilename()
      if filereadable(f)
        let lines = readfile(f)
        call filter(lines, "v:val !~ '^" . vim_instance . "\\>'")
        call add(lines, data)
      else
        let lines = [data]
      endif
      call writefile(lines, f)
    endif
  endfunction

  if !exists('g:screen_size_restore_pos')
    let g:screen_size_restore_pos = 1
  endif
  if !exists('g:screen_size_by_vim_instance')
    let g:screen_size_by_vim_instance = 1
  endif
  autocmd VimEnter * if g:screen_size_restore_pos == 1 | call ScreenRestore() | endif
  autocmd VimLeavePre * if g:screen_size_restore_pos == 1 | call ScreenSave() | endif
endif
"END screen pos/size saving function

" }}}
" Maximizes current window while saving window sizes and splits ----------- {{{
"Call function again to restore sizes and locations
"http://vim.wikia.com/wiki/Maximize_window_and_return_to_previous_split_structure
function! MaximizeToggle()
  if exists("s:maximize_session")
    exec "source " . s:maximize_session
    call delete(s:maximize_session)
    unlet s:maximize_session
    let &hidden=s:maximize_hidden_save
    unlet s:maximize_hidden_save
  else
    let s:maximize_hidden_save = &hidden
    let s:maximize_session = tempname()
    set hidden
    exec "mksession! " . s:maximize_session
    only
  endif
endfunction

" }}}
" Shows line by line difference between files with colors. Modified example {{{
"that wasn't really working all the time in Linux.  If I recall correctly,
"the packaged eg works in Windows
set diffexpr=Diff()
function! Diff()
    "Turn off interactive shell mode to prevent diff from requiring user input
    set shellcmdflag-=i

    "file options??
    let opt = '-a --binary '  "'-a' is text, --binary for exec?
    "diff options
    if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
    if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
    "set buffers to use in diff
    let arg1 = v:fname_in
    if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
    let arg2 = v:fname_new
    if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
    let arg3 = v:fname_out
    if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
    let eq = '' "no idea??
    let cmd = 'diff'  "use 'diff' command to diff
    "if no Vim directory?
    "if $VIMRUNTIME =~ ' '
    "  "if Windows??
    "  "if &sh =~ '\<cmd'
    "  "  let cmd = '""' . $VIMRUNTIME . '\diff"'
    "  "  let eq = '"'
    "  "else
    "    let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    "  "endif
    "else
    "  let cmd = $VIMRUNTIME . '\diff'
    "endif
    silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq

    "Reenable interactive shell for bash aliases after diff
    set shellcmdflag+=i
    redraw!
endfunction
"END diff function

" }}}
" Copy matches of the last search to a register (default is the clipboard). {{{
" Accepts a range (default is whole file).
" 'CopyMatches'   copy matches to clipboard (each match has \n added).
" 'CopyMatches x' copy matches to register x (clears register first).
" 'CopyMatches X' append matches to register x.
" We skip empty hits to ensure patterns using '\ze' don't loop forever.
" http://vim.wikia.com/wiki/Copy_the_search_results_into_clipboard
command! -range=% -register CopyMatches call s:CopyMatches(<line1>, <line2>, '<reg>')
function! s:CopyMatches(line1, line2, reg)
  let hits = []
  for line in range(a:line1, a:line2)
    let txt = getline(line)
    let idx = match(txt, @/)
    while idx >= 0
      let end = matchend(txt, @/, idx)
      if end > idx
	call add(hits, strpart(txt, idx, end-idx))
      else
	let end += 1
      endif
      if @/[0] == '^'
        break  " to avoid false hits
      endif
      let idx = match(txt, @/, end)
    endwhile
  endfor
  if len(hits) > 0
    let reg = empty(a:reg) ? '+' : a:reg
    execute 'let @'.reg.' = join(hits, "\n") . "\n"'
  else
    echo 'No hits'
  endif
endfunction
" }}}
" Format Chrome cURL ------------------------------------------------------ {{{
function! FormatCurlFile()
    %s/ -H/ \\\r-H/g
	"%s/"/\\"/g
	"%s/^curl '/url "/
	"%s/ -H '/\r-H "/g
	"%s/'$/"/g
	"%s/\v' --([a-z-]{2,})/"\r--\1/g
	"%s/\v^(--[a-z-]{2,}) '/\1 "/g
endfunction "}}}
function! FormatXml2()
  %s/></>\r</g
endfunction
" Format XML -------------------------------------------------------------- {{{
function! FormatXml()
	set syntax=xml
	%s/\n\n/\r/g
	"%s/\/\w\+>/&/g
	set fdm=indent
	normal gg=Ggg
	%s/\r//g
endfunction "}}}
" Format single line XML -------------------------------------------------- {{{
function! FormatXmlLine()
	set syntax=xml
	%s/\n\n/\r/g
	%s/\(\/\w\+>\)[^\r\n<]*\(<\)/\1\r\2/g
	set fdm=indent
	normal gg=Ggg
	%s/\r//g
endfunction "}}}
" Format CDATA XML -------------------------------------------------------------- {{{
function! FormatCDATA()
	%s/<\w/\r&/g
	%s/<\//\r&/g
	%s/<!\[/\r&/g
	set ft=xml
	set fdm=indent
	normal gg=Ggg
endfunction "}}}
" Replace Epoch times with readable times --------------------------------- {{{
function! FormatEpoch()
	%s/\(\d\{10}\)/\=strftime('%Y %b %d %X', str2nr(submatch(1)))/g
endfunction "}}}
" Format JSON with double quotes ------------------------------------------ {{{
function! FormatJSON()
    %s/:\({\)/:\1\r/ge | %s/{"/{\r"/ge | %s/\(:\w\+\)\("\=\),"/\1\2,\r"/ge | %s/\(":"\w\+",\)"/\1\r"/ge | %s/},"/},\r"/ge | %s/","/",\r"/ge | %s/\],"/],\r"/ge | %s/"},/"\r},/ge | %s/}]}/}]\r}/ge | %s/"}$/"\r}/ge | %s/\(\d\+,\)"/\1\r"/ge | %s/\(:\w\+\)}/\1\r}/ge | %s/}}]/}\r}]/ge | %s/}}$/\r}\r}/ge | %s/":/& /ge
    " Clean up
    %s/}}/}\r}/ge
    %s/}}/}\r}/ge
    %s/}}/}\r}/ge
    set ft=json
    normal gg=G
endfunction "}}}
" QBO cookies only -------------------------------------------------------- {{{
function! GetQBOCookies()
    %s/; /;\r/g
    %s/\v^((^(qbo|qbn))@!.)*\n//g
    %s/;\n/; /g
endfunction
" }}}
" Diff between current buffer and the file it's loaded from --------------- {{{
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif
" }}}
" Resize all buffers to 80 given number of columns (vsplit windows) -------- {{{
" NOTE: Won't exceed device screen width
command -nargs=1 ResizeCols call ResizeCols(<f-args>)
function! ResizeCols(numCols)
	let &columns=a:numCols * 81 - 1
endfunction
" }}}
" Resize height of window to number of lines in the file ------------------- {{{
command MaxHeight call MaxHeight()
function! MaxHeight()
	execute "resize " . line('$')
endfunction
" }}}
" Set 4 spaces for window -------------------------------------------------- {{{
function! FourSpaces()
  setlocal ts=4 sw=4
endfunction
function! TwoSpaces()
  setlocal ts=2 sw=2
endfunction
" }}}
" Grep all buffers --------------------------------------------------------- {{{
function! BuffersList()
  let all = range(0, bufnr('$'))
  let res = []
  for b in all
    if buflisted(b)
      call add(res, bufname(b))
    endif
  endfor
  return res
endfunction

function! GrepBuffers (expression)
  exec 'vimgrep/'.a:expression.'/ '.join(BuffersList())
endfunction

command! -nargs=+ GrepBufs call GrepBuffers(<q-args>)
" }}}
" }}}
" Must be after autocommands https://stackoverflow.com/questions/1291955/very-strange-behavior-with-vim-syntax-and-filetype-detection
syntax on
" vim:set foldmethod=marker:set foldlevelstart=0:
