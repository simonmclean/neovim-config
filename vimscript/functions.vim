func Eatchar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc

" Paste clipboard contents over something based on text-object or motion
" e.g. <leader>pi"
function! ReplaceMotion(type)
  let sel_save = &selection
  let &selection = "inclusive"

  if a:type == 'line'
    execute "normal! '[V']"
    silent normal "_dp
  elseif a:type == 'char'
    execute "normal! `[v`]"
    silent normal "_d
    execute "normal! \<s-p>"
  endif

  let &selection = sel_save
endfunction
