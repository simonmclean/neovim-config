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
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = false },
    dashboard = { enabled = false },
    explorer = { enabled = false },
    indent = { enabled = false },
    input = { enabled = true },
    picker = {
      enabled = true,
      layouts = {
        default = {
          layout = {
            -- backdrop = false,
            width = 0.7,
            min_width = 80,
            height = 0.8,
            min_height = 30,
            box = 'vertical',
            border = 'rounded',
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
    scope = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },
  },
  keys = {
    {
      '<leader>sh',
      function()
        picker().help()
      end,
      '[S]earch [H]elp',
    },
    {
      '<leader>sf',
      function()
        picker().smart()
      end,
      desc = 'Smart Find Files',
    },
    {
      '<leader>sp',
      function()
        picker()()
      end,
      '[S]earch [P]ickers',
    },
    {
      '<leader>sg',
      function()
        picker().grep()
      end,
      '[S]earch [G]rep',
    },
    {
      '<leader>sd',
      function()
        picker().diagnostics()
      end,
      '[S]earch [D]iagnostics',
    },
    {
      '<leader>sr',
      function()
        picker().resume()
      end,
      '[S]earch [R]esume',
    },
    -- { '<leader>spf', function ()
    --  picker().
    -- end, '[S]earch [P]lugin [F]iles' },
    {
      'gd',
      function()
        picker().lsp_definitions()
      end,
      '[G]oto [D]efinition',
    },
    {
      'gr',
      function()
        picker().lsp_references()
      end,
      '[G]oto [R]eferences',
    },
    {
      '<leader>ss',
      function()
        picker().lsp_symbols()
      end,
      '[S]earch [D]ocument Symbols',
    },
    {
      '<leader>sws',
      function()
        picker().lsp_workspace_symbols()
      end,
      '[S]earch [W]orkspace [S]ymbols',
    },
  },
}
