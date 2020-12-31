" To add plugins, go to .vim and do
" git submodule add https://github.com/Raimondi/delimitMate.git bundle/delimitMate

execute pathogen#infect()

filetype plugin indent on
filetype detect
syntax on
set nocompatible
packadd! matchit

" Make sure vim actually sees the color scheme.
set rtp+=~/.vim/bundle/vim-colors-solarized
set background=light
colorscheme solarized

" Some a few non-crazy defaults
set statusline=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%c,%l/%L\ %P
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set autoindent
set smarttab
set spell
set splitright
set laststatus=2
set backspace=indent,eol,start

" ctags
set tags=./tags;,.git/tags;

" cscope
if has("cscope")
    set csto=0
    set cst
    set nocsverb
    " Look upwards for a cscope DB in the .git directory
    let cscope_db=findfile("cscope.out", ".git;")
    if !empty(cscope_db) && filereadable(cscope_db)
        let cscope_path = strpart(cscope_db, 0, match(cscope_db, ".git/cscope.out"))
        set nocscopeverbose
        exe "cs add" cscope_db . " " . cscope_path
        set cscopeverbose
    elseif $CSCOPE_DB != "" && filereadable($CSCOPE_DB)
        set nocscopeverbose
        cs add $CSCOPE_DB
        set cscopeverbose
    " else
        " echo "couldn't find cscope file :("
    endif
    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>   " 0: C symbol
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>   " 1: definition
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>   " 2: functions called by this function
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>   " 3: functions calling this function
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>   " 4: find this text string
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>   " 6: find this egrep pattern
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>   " 7: find this file
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR> " 8: files #include'ing this file
    nmap <C-\>a :cs find a ^<C-R>=expand("<cfile>")<CR>$<CR> " 9: places where this symbol is assigned a value
endif

" Make K open a :terminal instead of replacing the current buffer.
" set keywordprg=:term\ ++close\ man
" Maybe this is better:
runtime ftplugin/man.vim
set keywordprg=:Man

" Things GUI
if has('gui')
    if has("gui_macvim")
        set guifont=Monaco:h14
    endif
endif

" Function to get rid of trailing whitespace:
" The 'e' flag means don't error.
fun! StripTrailingWhitespace()
	" Only strip if the b:noStripeWhitespace variable isn't set
    if exists('b:noStripWhitespace')
		return
    endif
	echom "Got to here"
    %s/\s\+$//e
endfun

" For the following types of files, set the variable.
au BufNewFile,BufRead *.out let b:noStripWhitespace=1
au BufNewFile,BufRead *.sgml let b:noStripWhitespace=1
" Call on write.
autocmd BufWritePre * call StripTrailingWhitespace()

" Don't use Ex mode, use Q for formatting
map Q gq
map c gUllguww		" Alt-c capitalizes word from present position
map <M-c> gUllguww		" Alt-c capitalizes word from present position
map <D-c> gUllguww		" Apple-c capitalizes word from present position
map u gUww		" Alt-u uppercases word from present position
map <M-u> gUww		" Alt-u uppercases word from present position
map <D-u> gUww		" Alt-u uppercases word from present position
map l guww		" Alt-l lowercases word from present position
map <M-l> guww		" Alt-l lowercases word from present position
map <D-l> guww		" Alt-l lowercases word from present position
imap </ </<C-x><C-o>

au FileType sql setl formatprg=/usr/local/bin/sqlformat\ -r\ -
" au FileType sql setl formatprg=/Users/davidfetter/go/bin/sqlfmt\ -u
au FileType json setl formatprg=jq\ '.'
au FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
au FileType c setlocal noexpandtab

augroup templates
    au BufNewFile * silent! 0r ~/.vim/templates/%:e.tpl
augroup END

autocmd! GUIEnter * set vb t_vb=

" Change leader from \ to comma
let mapleader = ","

" psql!!!
" Starts an async psql job, prompting for the psql arguments.
" Also opens a scratch buffer where output from psql is directed.
noremap <leader>po :VipsqlOpenSession<CR>

" Terminates psql (happens automatically if the scratch buffer is closed).
noremap <silent> <leader>pk :VipsqlCloseSession<CR>

" In normal-mode, prompts for input to psql directly.
nnoremap <leader>ps :VipsqlShell<CR>

" In visual-mode, sends the selected text to psql.
vnoremap <leader>ps :VipsqlSendSelection<CR>

" Sends the selected _range_ to psql.
noremap <leader>pr :VipsqlSendRange<CR>

" Sends the current line to psql.
noremap <leader>pl :VipsqlSendCurrentLine<CR>

" Sends the entire current buffer to psql.
noremap <leader>pb :VipsqlSendBuffer<CR>

" Sends `SIGINT` (C-c) to the psql process.
noremap <leader>pc :VipsqlSendInterrupt<CR>

" Paste away!
" Sharing is caring
" Sat Jul 28 14:22:47 PDT 2018
let s:uname = system("uname")
if s:uname == "Darwin\n"
	" Mac OS X
	" --------
	command! -range=% SP  <line1>,<line2>w !curl -F 'sprunge=<-' http://sprunge.us | tr -d '\n' | pbcopy
	command! -range=% CL  <line1>,<line2>w !curl -F 'clbin=<-' https://clbin.com | tr -d '\n' | pbcopy
	command! -range=% VP  <line1>,<line2>w !curl -F 'text=<-' http://vpaste.net | tr -d '\n' | pbcopy
	command! -range=% PB  <line1>,<line2>w !curl -F 'c=@-' https://ptpb.pw/?u=1 | tr -d '\n' | pbcopy
	command! -range=% IX  <line1>,<line2>w !curl -F 'f:1=<-' ix.io | tr -d '\n' | pbcopy
	command! -range=% TB  <line1>,<line2>w !nc termbin 9999 | tr -d '\n' | pbcopy
else
	" Linux (requires xclip)
	" ----------------------
	command! -range=% SP  <line1>,<line2>w !curl -F 'sprunge=<-' http://sprunge.us | tr -d '\n' | xclip -i -selection clipboard
	command! -range=% CL  <line1>,<line2>w !curl -F 'clbin=<-' https://clbin.com | tr -d '\n' | xclip -i -selection clipboard
	command! -range=% VP  <line1>,<line2>w !curl -F 'text=<-' http://vpaste.net | tr -d '\n' | xclip -i -selection clipboard
	command! -range=% PB  <line1>,<line2>w !curl -F 'c=@-' https://ptpb.pw/?u=1 | tr -d '\n' | xclip -i -selection clipboard
	command! -range=% IX  <line1>,<line2>w !curl -F 'f:1=<-' ix.io | tr -d '\n' | xclip -i -selection clipboard
	command! -range=% TB  <line1>,<line2>w !nc termbin 9999 | tr -d '\n' | xclip -i -selection clipboard
endif
