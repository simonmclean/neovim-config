return function()
  require('notify').setup {
    render = 'minimal',
    fps = 60,
    timeout = 1000, -- This excludes the animation time
    max_height = 3,
    max_width = function ()
      local col_count = vim.o.columns
      return math.min(60, math.ceil(col_count * 0.33))
    end
  }
end
