local fn = vim.fn

local M = {}

function M.submit()
	local file = fn.expand("%:p")
	print(file)
end

function M.init()
	local course_id = fn.input("Course id: ")
	vim.cmd("!python /home/xander/test.py " .. course_id)
end

return M
