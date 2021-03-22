local M = {}

function M.git_log_lines(lineStart, lineEnd)
	local buffer_path = vim.api.nvim_eval('expand("%")')
	local cmd = 'Git log -L' .. lineStart .. ',' .. lineEnd .. ':' .. buffer_path
	vim.cmd(cmd)
end

return M
