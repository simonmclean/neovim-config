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
		metals = 'MetalsStatusLine',
		-- cocstatus = 'coc#status',
		-- currentfunction = 'CocCurrentFunction',
		filename = 'StatusLineSmartFilename'
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
	local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
	if (count > 0) then
		return count
	end
	return ''
end

local function lsp_statusline_warnings()
	local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
	if (count > 0) then
		return count
	end
	return ''
end

local function lsp_statusline_hints()
	local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
	if (count > 0) then
		return count
	end
	return ''
end

local function metals_status()
	local status = vim.g.metals_status
	if (status == '' or status == nil) then
		return ''
	else
		return status
	end
end

local function smart_file_display()
	local relative_path = vim.fn.expand('%')
	local file_name = vim.fn.expand('%:t')
	local columns = vim.api.nvim_eval('&columns')
	local space_for_path_string = columns - 50 -- magic number
	if (vim.o.laststatus ~= 3 or (string.len(relative_path) > space_for_path_string)) then
		return file_name
	else
		return relative_path
	end
end

vim.api.nvim_exec([[
  augroup lsp_lightline_update
    autocmd!
    autocmd DiagnosticChanged * :call lightline#update()
  augroup END
]], false)

vim.g.lightline = config

return {
	lsp_statusline_errors = lsp_statusline_errors,
	lsp_statusline_warnings = lsp_statusline_warnings,
	lsp_statusline_hints = lsp_statusline_hints,
	smart_file_display = smart_file_display,
	metals_status = metals_status
}
