local M = {}

function M.split(s, delimiter)
	local result = {}
	for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
		table.insert(result, match)
	end
	return result
end

function M.lines(s)
	if s:sub(-1) ~= "\n" then
		s = s .. "\n"
	end
	return s:gmatch("(.-)\n")
end

function M.readbuffer(s, e)
	if e == -1 then
		e = vim.api.nvim_buf_line_count(0)
	end
	local content = vim.api.nvim_buf_get_lines(0, s, e, false)
	return content
end

function M.has_value(tab, val)
	for _, value in ipairs(tab) do
		if value == val then
			return true
		end
	end

	return false
end

return M
