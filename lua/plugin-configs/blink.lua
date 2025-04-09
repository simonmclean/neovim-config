return {
  'saghen/blink.cmp',
  dependencies = { 'rafamadriz/friendly-snippets', 'giuxtaposition/blink-cmp-copilot' },
  version = '1.*',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    sources = {
      default = { 'lsp', 'copilot', 'path', 'snippets', 'buffer' },
      providers = {
        copilot = {
          name = 'copilot',
          module = 'blink-cmp-copilot',
          score_offset = 100,
          async = true,
        },
      },
    },
    completion = { documentation = { auto_show = true } },
    signature = { enabled = true },
    cmdline = {
      completion = {
        menu = {
          auto_show = true,
        },
      },
    },
  },
  opts_extend = { 'sources.default' },
}
