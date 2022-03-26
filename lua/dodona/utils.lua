local M = {}

function M.split(s, delimiter)
	local result = {}
	for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
		table.insert(result, match)
	end
	return result
end

function M.wait(seconds)
	os.execute("sleep " .. tonumber(seconds))
end

return M
