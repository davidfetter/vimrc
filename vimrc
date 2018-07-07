" To add plugins, go to .vim and do
" git submodule add https://github.com/Raimondi/delimitMate.git bundle/delimitMate

execute pathogen#infect()

filetype plugin indent on
filetype detect
syntax on

" Make sure vim actually sees the color scheme.
set rtp+=~/.vim/bundle/vim-colors-solarized
set background=light
colorscheme solarized

" Some a few non-crazy defaults
set statusline=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%c,%l/%L\ %P
set sw=4 ts=4 expandtab autoindent smartindent smarttab spell splitright laststatus=2

" Get rid of trailing whitespace on write.
" The 'e' flag means don't error.
au BufWritePre * :%s/\s\+$//e

au FileType sql setl formatprg=/usr/local/bin/pg_format\ -p\ '%\([^)]*\)\S+'\ -
au FileType jq set sw=2 ts=2
au FileType json set sw=2 ts=2
au FileType json setl formatprg=jq\ '.'
au FileType sh set sw=2 ts=2

augroup progress_report
    autocmd BufNewFile progress_report* 0r ~/.vim/templates/progress_report
augroup END

autocmd! GUIEnter * set vb t_vb=

" Change leader from \ to comma
let mapleader = ","

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
