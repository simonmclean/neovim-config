local config = {
	colorscheme = vim.g.lightline.colorscheme,
	active = {
		left = {
			{ 'mode', 'paste' },
			{ 'gitbranch', 'readonly', 'filename', 'modified' },
			{ 'lsp_errors', 'lsp_warnings' }
		},
		right = {
			{ 'percent', 'lineinfo' },
			{ 'filetype' },
			{},
		}
	},
	component_function = {
		gitbranch = 'FugitiveHead',
	},
	component_expand = {
		lsp_errors = 'LspStatuslineErrors',
		lsp_warnings = 'LspStatuslineWarnings'
	},
	component_type = {
		lsp_errors = 'error',
		lsp_warnings = 'warning'
	}
}

local function lsp_statusline_errors()
	local error_count = vim.lsp.diagnostic.get_count(0, 'Error')
	local error_count_display = error_count

	if (error_count > 0) then
		return error_count_display
	end

	return ''
end

local function lsp_statusline_warnings()
	local warning_count = vim.lsp.diagnostic.get_count(0, 'Warning')
	local warning_count_display = warning_count

	if (warning_count > 0) then
		return warning_count_display
	end

	return ''
end

vim.api.nvim_exec([[
  augroup lsp_lightline_update
    autocmd!
    autocmd User LspDiagnosticsChanged :call lightline#update()
  augroup END
]], false)

vim.g.lightline = config

return {
	lsp_statusline_errors = lsp_statusline_errors,
	lsp_statusline_warnings = lsp_statusline_warnings
}
