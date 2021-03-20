-- Don't show hunk changes
vim.g['airline#extensions#hunks#enabled'] = 0

-- Remove file encoding section
vim.g.airline_section_y = ''

-- Simplfy the line and column information
vim.g.airline_section_z = '%l/%L:%c'
