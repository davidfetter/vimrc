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
set sw=4 ts=4 expandtab autoindent smartindent smarttab
set spell

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
