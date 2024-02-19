local api = require("dodona.api")
local telescope = require("dodona.telescope")
local manager = require("dodona.manager")
local utils = require("dodona.utils")

local fn = vim.fn

local config = {}

local M = {}

function M.test()
	telescope.telescope()
end

function M.submit()
	local file = fn.expand("%")
	local extension = fn.expand("%:e")
	manager.evalSubmission(file, extension)
end

function M.initActivities()
	telescope.initActivities()
end

function M.download()
	manager.downloadData(utils.readbuffer(0, 1)[1])
end

function M.go()
	local first_line = vim.fn.escape(utils.readbuffer(0, 1)[1],"#")

	vim.cmd("silent !" .. (config.go_cmd ~= nil and config.go_cmd or "gio open") .. " " .. string.sub(first_line, first_line:find("https"), -1))
end

function M.setup(vars)
	api.setup(vars)
  config = vars
end

return M
