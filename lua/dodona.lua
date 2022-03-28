local api = require("dodona.api")
local telescope = require("dodona.telescope")
local manager = require("dodona.manager")
local utils = require("dodona.utils")

local fn = vim.fn

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
	local first_line = utils.readbuffer(0, 1)[1]

	vim.cmd("silent !firefox " .. string.sub(first_line, first_line:find("https"), -2))
end

function M.setup(vars)
	api.setup(vars)
end

return M
