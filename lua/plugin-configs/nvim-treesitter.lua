return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  dependencies = { 'windwp/nvim-ts-autotag' },
  config = function()
    require('nvim-treesitter.configs').setup {
      indent = {
        enable = true, -- without this JSX auto-indentation doesn't work as expected
      },
      autotag = { -- This requires the 'windwp/nvim-ts-autotag' plugin
        enable = true,
      },
      highlight = {
        enable = true,
        custom_captures = {
          -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
          -- ["foo.bar"] = "Identifier",
        },
      },
      auto_install = true,
    }

    vim.treesitter.language.register('terraform', 'terraform-vars')
  end,
}
