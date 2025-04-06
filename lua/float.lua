local MAX_HEIGHT = 45
local MAX_WIDTH = 140
local PADDING = 4

local M = {}

local function calc_height()
  local height_and_padding = MAX_HEIGHT + (PADDING * 2)
  if height_and_padding > vim.o.lines then
    local diff = height_and_padding - vim.o.lines
    return MAX_HEIGHT - diff
  end
  return MAX_HEIGHT
end

local function calc_width()
  local width_and_padding = MAX_WIDTH + (PADDING * 2)
  if width_and_padding > vim.o.columns then
    local diff = width_and_padding - vim.o.columns
    return MAX_WIDTH - diff
  end
  return MAX_WIDTH
end

---create a new floating window, and run the given function
---@param fn fun(data: { float_win: integer, create_autoclose: function })
---@param title string
M.create = function(fn, title)
  local buf = vim.api.nvim_create_buf(false, true)
  local height = calc_height()
  local width = calc_width()
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    height = height,
    width = width,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    border = vim.g.winborder,
    title = title,
    title_pos = 'center',
  })
  vim.api.nvim_set_option_value('winblend', vim.g.winblend, { win = win })

  local function close()
    vim.api.nvim_win_close(win, true)
  end

  vim.keymap.set('n', 'gq', close, { buffer = true })

  local create_autoclose = function()
    vim.api.nvim_create_autocmd('WinEnter', {
      callback = function()
        if vim.api.nvim_win_is_valid(win) then
          if vim.api.nvim_get_current_win() ~= win then
            close()
            return true
          end
        end
        return true
      end,
    })
  end

  fn {
    float_win = win,
    create_autoclose = create_autoclose,
  }
end

return M
