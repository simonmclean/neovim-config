local u = require 'utils'

u.options {
  termguicolors = true,
  laststatus = 3,
  clipboard = 'unnamed',
  ignorecase = true,
  smartcase = true,
  showcmd = true,
  showmode = false, -- the mode is already displayed in the statusline
  hidden = true,
  undofile = true,
  scrolloff = 10,
  smoothscroll = true,
  tabstop = 2,
  shiftwidth = 2,
  expandtab = true,
  fillchars = { fold = ' ', foldopen = '', foldclose = '' },
  foldcolumn = 'auto',
  inccommand = 'split',
  confirm = true,
  linebreak = true,
  -- Don't save empty windows or hidden or unlisted buffers in the session
  sessionoptions = vim.o.sessionoptions:gsub(',?blank,?', ''):gsub(',?buffers,?', ''),
  -- win
  signcolumn = 'yes',
  cursorline = true,
  number = true,
  relativenumber = false,
  wrap = false,
  switchbuf = 'usetab,uselast',
  startofline = true,
  winborder = vim.g.winborder,
}

vim.opt_global.shortmess:append 's'
vim.g.foldtext = function()
  local line = vim.fn.getline(vim.v.foldstart)
  local folded_line_count = vim.v.foldend - vim.v.foldstart + 1
  return '--[' .. folded_line_count .. ' lines] ' .. line
end

--- Set Ghostty's tab title to the current directory
if vim.fn.getenv 'TERM_PROGRAM' == 'ghostty' then
  vim.opt.title = true
  vim.opt.titlestring = "nvim - %{fnamemodify(getcwd(), ':t')}"
end
