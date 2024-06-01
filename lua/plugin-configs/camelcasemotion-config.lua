-- Motions for camelcase jumps

return {
  'bkad/camelcasemotion',
  config = function()
    vim.g.camelcasemotion_key = '<leader>'
  end,
  event = 'VeryLazy',
}
