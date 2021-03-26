local config = {
	colorscheme = vim.g.lightline.colorscheme,
	active = {
		left = {
			{ 'mode', 'paste' },
			{ 'gitbranch', 'readonly', 'filename', 'modified' },
			{ 'lsp' }
		},
		right = {
			{ 'percent', 'lineinfo' },
			{ 'filetype' },
			{},
		}
	},
	component_function = {
		gitbranch = 'FugitiveHead',
		lsp = 'LspStatusline'
	},
}

local function lsp_statusline()
	local error_count = vim.lsp.diagnostic.get_count(0, 'Error')
	local error_count_display = 'Errors[' .. error_count .. ']'

	local warning_count = vim.lsp.diagnostic.get_count(0, 'Warning')
	local warning_count_display = 'Warnings[' .. warning_count .. ']'

	if (error_count > 0 and warning_count > 0) then
		return error_count_display .. ' ' .. warning_count_display
	end

	if (error_count > 0) then
		return error_count_display
	end

	if (warning_count > 0) then
		return warning_count_display
	end

	return ''
end

vim.g.lightline = config

return {
	lsp_statusline = lsp_statusline
}
