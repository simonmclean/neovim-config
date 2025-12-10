local u = require 'utils'

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local nvim_ts = require 'nvim-treesitter'

    local parsers = {
      'bash',
      'css',
      'csv',
      'diff',
      'ecma',
      'go',
      'helm',
      'html',
      'javascript',
      'json',
      'jsx',
      'lua',
      'markdown',
      'nix',
      'python',
      'scala',
      'typescript',
      'yaml',
    }

    -- ensure the listed parsers are installed
    for _, parser in ipairs(parsers) do
      if not u.list_contains(nvim_ts.get_installed(), parser) then
        if u.list_contains(nvim_ts.get_available(), parser) then
          nvim_ts.install(parser)
        else
          u.warn(string.format('treesitter parser does not exist: %s', parser))
        end
      end
    end

    -- auto start treesitter
    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        if vim.list_contains(nvim_ts.get_installed(), vim.treesitter.language.get_lang(args.match)) then
          vim.treesitter.start(args.buf)
        end
      end,
    })
  end,
}
