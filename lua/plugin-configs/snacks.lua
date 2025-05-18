---@return snacks.picker
local function picker()
  return require('snacks').picker
end

return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@module 'snacks'
  ---@type snacks.Config
  opts = {
    image = { enabled = true },
    bigfile = { enabled = false },
    dashboard = { enabled = false },
    explorer = { enabled = false },
    indent = { enabled = true, animate = { enabled = false } },
    input = { enabled = true },
    gitbrowse = {},
    picker = {
      enabled = true,
      layouts = {
        default = {
          layout = {
            backdrop = false,
            width = 0.7,
            min_width = 80,
            height = 0.8,
            min_height = 30,
            box = 'vertical',
            border = vim.g.winborder,
            title = '{title} {live} {flags}',
            title_pos = 'center',
            { win = 'input', height = 1, border = 'bottom' },
            { win = 'list', border = 'none' },
            { win = 'preview', title = '{preview}', height = 0.5, border = 'top' },
          },
        },
      },
    },
    notifier = { enabled = false },
    quickfile = { enabled = false },
    scope = { enabled = true },
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = true },
    terminal = {
      win = {
        style = 'floating_terminal',
      },
    },
    styles = {
      ['floating_terminal'] = {
        relative = 'editor',
        position = 'float',
        backdrop = 100,
        height = 0.8,
        width = 0.8,
        zindex = 50,
        border = vim.g.winborder,
      },
    },
  },
  keys = {
    {
      '<c-t>',
      function()
        require('snacks.terminal').toggle()
      end,
      desc = 'Toggle floating terminal',
      mode = { 'n', 't' },
    },
    {
      'gn',
      function()
        require('snacks.words').jump(1, true)
      end,
      desc = '[G]o [N]ext LSP reference',
    },
    {
      '<leader>sh',
      function()
        picker().help()
      end,
      desc = '[S]earch [H]elp',
    },
    {
      '<leader>sf',
      function()
        picker().files()
      end,
      desc = '[S]earch [F]iles',
    },
    {
      '<leader>sp',
      function()
        picker()()
      end,
      desc = '[S]earch [P]ickers',
    },
    {
      '<leader>sb',
      function()
        picker().lines()
      end,
      '[S]earch [B]uffer',
    },
    {
      '<leader>sg',
      function()
        picker().grep()
      end,
      desc = '[S]earch [G]rep',
    },
    {
      '<leader>sc',
      function()
        picker().commands()
      end,
      desc = '[S]earch [C]ommands',
    },
    {
      '<leader>sd',
      function()
        picker().diagnostics()
      end,
      desc = '[S]earch [D]iagnostics',
    },
    {
      '<leader>sr',
      function()
        picker().resume()
      end,
      desc = '[S]earch [R]esume',
    },
    -- { '<leader>spf', function ()
    --  picker().
    -- end, '[S]earch [P]lugin [F]iles' },
    {
      'gd',
      function()
        picker().lsp_definitions()
      end,
      desc = '[G]oto [D]efinition',
    },
    {
      'gr',
      function()
        picker().lsp_references()
      end,
      desc = '[G]oto [R]eferences',
      nowait = true,
    },
    {
      '<leader>ss',
      function()
        picker().lsp_symbols()
      end,
      desc = '[S]earch Document [S]ymbols',
    },
    {
      '<leader>sws',
      function()
        picker().lsp_workspace_symbols()
      end,
      desc = '[S]earch [W]orkspace [S]ymbols',
    },
  },
}
