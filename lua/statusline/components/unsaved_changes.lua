return function()
  local count = #vim.fn.getbufinfo { buflisted = 1, bufmodified = 1 }
  if count > 0 then
    -- TODO: Add click handler (quickfix)
    return '[+] ' .. count
  end
end
