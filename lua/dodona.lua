local fn = vim.fn
local command = "python " .. fn.stdpath("data") .. "/site/pack/packer/start/dodona.nvim" .. "/scripts/python/main.py "

local M = {}

function M.submit()
	local file = fn.expand("%")
	local options = "--command submit --path " .. file
	vim.cmd("15split | terminal")
	vim.cmd(':call jobsend(b:terminal_job_id, " ' .. command .. options .. '")')
end

function M.initActivities()
	local series_id = fn.input("Series id: ")
	local current_dir = fn.getcwd()
	local options = "--command init --series " .. series_id .. " --path " .. current_dir
	vim.cmd("15split | terminal")
	vim.cmd(':call jobsend(b:terminal_job_id, " ' .. command .. options .. '")')
end

return M
