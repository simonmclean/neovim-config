return function()
  vim.keymap.set("n", "<leader>T", function()
    require("trouble").toggle()
  end)

  return require("trouble").setup({
    auto_fold = true,
    auto_preview = false
  })
end
