local config = {
	colorscheme = vim.g.lightline.colorscheme,
	active = {
		left = {
			{ 'mode', 'paste' },
			{ 'gitbranch', 'readonly', 'filename', 'modified' },
			{ 'lsp_errors', 'lsp_warnings', 'lsp_hints', 'metals' }
		},
		right = {
			{ 'percent', 'lineinfo' },
			{ 'filetype' },
			{},
		}
	},
	component_function = {
		gitbranch = 'FugitiveHead',
		metals = 'metals#status'
	},
	component_expand = {
		lsp_errors = 'LspStatuslineErrors',
		lsp_warnings = 'LspStatuslineWarnings',
		lsp_hints = 'LspStatuslineHints'
	},
	component_type = {
		lsp_errors = 'error',
		lsp_warnings = 'warning',
		lsp_hints = 'hint'
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

local function lsp_statusline_hints()
	local hint_count = vim.lsp.diagnostic.get_count(0, 'Hint')
	local hint_count_display = hint_count

	if (hint_count > 0) then
		return hint_count_display
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
	lsp_statusline_warnings = lsp_statusline_warnings,
	lsp_statusline_hints = lsp_statusline_hints
}
