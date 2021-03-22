source ~/.config/nvim/vimscript/functions.vim
source ~/.config/nvim/vimscript/coc.vim

" Source init.lua
command! -nargs=0 Source :luafile ~/.config/nvim/init.lua

" Open init.lua
command! -nargs=0 Config :e ~/.config/nvim/init.lua

" Show git log for current or highlighted lines
" command! -range Glines :call <SID>GitLogLines(<line1>, <line2>)
command! -range Glines :lua require('functions').git_log_lines(<line1>, <line2>)

" Shorthand for console.log()
iabbr clog console.log();<Left><Left><C-R>=Eatchar('\s')<CR>

" Auto remove trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

" Disable cursorline in quickfix
autocmd FileType qf set nocursorline

" Checkout up to date master branch
command! Master :Git checkout master | Git fetch --prune | Git pull

" Exclude block navigation from the jumplist
nnoremap <silent> } :<C-u>execute "keepjumps norm! " . v:count1 . "}"<CR>
nnoremap <silent> { :<C-u>execute "keepjumps norm! " . v:count1 . "{"<CR>

" Tryptic
augroup TrypticBindings
  autocmd!

  " Navigation
  autocmd FileType tryptic nnoremap <silent> <buffer> h :call tryptic#HandleMoveLeft()<cr>
  autocmd FileType tryptic nnoremap <silent> <buffer> l :call tryptic#HandleMoveRight()<cr>

  " Close Tryptic
  autocmd FileType tryptic nnoremap <silent> <buffer> q :tabclose<cr>

  " Toggle hidden files
  autocmd FileType tryptic nnoremap <silent> <buffer> <leader>. :call tryptic#ToggleHidden()<cr>

  " Add or remove from arglist
  autocmd FileType tryptic nnoremap <silent> <buffer> x :call tryptic#ToggleArglist()<cr>

  " Refresh view
  autocmd FileType tryptic nnoremap <silent> <buffer> R :call tryptic#Refresh()<cr>

augroup END
