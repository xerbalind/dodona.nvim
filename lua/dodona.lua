local fn = vim.fn

local M = {}

function M.submit()
	local file = fn.expand("%:p")
	print(file)
end

return M
