-- When performing a jump between files (e.g. `gd`), if that file is already open in another window,
-- then ask the user if they wany to switch to that window instead deplicating the buffer in multiple windows.

local au_group = vim.api.nvim_create_augroup('goto_existing', { clear = true })

---Check if a given buffer is already open, searching all wins, except the specified exclusion
---If a match is found, returns the window ID
---@param excluded_win number
---@param buf number
---@return integer?
local function get_existing_buf_win(excluded_win, buf)
  for _, tabnr in ipairs(vim.api.nvim_list_tabpages()) do
    for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(tabnr)) do
      local bufnr = vim.api.nvim_win_get_buf(winid)
      if bufnr == buf and winid ~= excluded_win then
        return winid
      end
    end
  end
end

local prev_buf = -1
local prev_tab = -1

vim.api.nvim_create_autocmd('BufLeave', {
  group = au_group,
  callback = function(data)
    prev_buf = data.buf
    prev_tab = vim.api.nvim_get_current_tabpage()
  end,
})

---Flag to prevent the BufEnter logic triggering itself repeatedly
local suspend = false

vim.api.nvim_create_autocmd('BufEnter', {
  group = au_group,
  callback = function(data)
    -- This logic only makes sense if we've jumped within the existing tabpage
    if suspend or vim.api.nvim_get_current_tabpage() ~= prev_tab then
      return
    end

    local current_win = vim.api.nvim_get_current_win()
    local other_win = get_existing_buf_win(current_win, data.buf)

    if other_win then
      local filename = vim.fn.fnamemodify(data.file, ':t')
      local jump_to_other = vim.fn.confirm(
        '"' .. filename .. '" is already open. Jump to existing window?',
        '&Yes\n&No',
        2
      ) == 1

      if jump_to_other then
        suspend = true
        -- Wait for the jump to finish
        vim.schedule(function()
          local row, col = unpack(vim.api.nvim_win_get_cursor(0))
          -- Jump to the other window
          vim.api.nvim_set_current_win(other_win)
          vim.api.nvim_win_set_cursor(other_win, { row, col })
          -- Wait for the above jump to complete
          vim.schedule(function()
            -- Restore the other window
            vim.api.nvim_win_set_buf(current_win, prev_buf)
            vim.schedule(function()
              suspend = false
            end)
          end)
        end)
      end
    end
  end,
})
