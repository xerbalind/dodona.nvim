local fn = vim.fn
local plugin_path = fn.stdpath("data") .. "/site/pack/packer/start/dodona.nvim"

local M = {}

function M.submit()
	local file = fn.expand("%")
	local options = "--command submit --path " .. file
	vim.cmd("!python " .. plugin_path .. "/scripts/python/main.py " .. options)
end

function M.initActivities()
	local series_id = fn.input("Series id: ")
	local current_dir = fn.getcwd()
	local options = "--command init --series " .. series_id .. " --path " .. current_dir
	vim.cmd("!python " .. plugin_path .. "/scripts/python/main.py " .. options)
end

return M
