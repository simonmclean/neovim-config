return function()
  if vim.bo.readonly then
    return '[RO]'
  end
end


