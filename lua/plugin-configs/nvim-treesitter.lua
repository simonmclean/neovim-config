return function()
  require('nvim-treesitter.configs').setup {
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
end
