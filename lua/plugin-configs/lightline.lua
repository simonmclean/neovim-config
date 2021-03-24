local config = {
	colorscheme = vim.g.lightline.colorscheme,
	active = {
		left = {
			{ 'mode', 'paste' },
			{ 'gitbranch', 'readonly', 'filename', 'modified' }
		},
		right = {
			{ 'percent', 'lineinfo' },
			{ 'filetype' },
			{},
		}
	},
	component_function = {
		gitbranch = 'FugitiveHead'
	},
}

vim.g.lightline = config
