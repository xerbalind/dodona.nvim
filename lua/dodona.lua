local fn = vim.fn

local M = {}

function M.submit()
	local file = fn.expand("%:p")
	print(file)
end

function M.initActivities()
	local course_id = fn.input("Course id: ")
	local plugin_path = fn.stdpath("data") .. "/site/pack/packer/start/dodona.nvim"
	local current_dir = fn.getcwd()
	local options = "--command init --series " .. course_id .. " --path " .. current_dir
	vim.cmd("!python " .. plugin_path .. "/scripts/python/main.py " .. options)
end

return M
