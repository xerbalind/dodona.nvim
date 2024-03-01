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


function M.token(reset)
  local token_dir = vim.fn.stdpath("data") .. "/dodona"
  local file = io.open(token_dir .. "/token", "r")
  if file == nil or reset then
    local token = vim.fn.input("Set dodona token here: ")
    if string.len(token) > 0 then
      vim.fn.mkdir(token_dir,"p")
      local write_file = io.open(token_dir .. "/token","w")
      if write_file then
        write_file:write(token)
        vim.print("\nSaved token at " .. token_dir .. "/token")
        write_file:close()
      end
      return token
    end
  else
    local token = file:read("*a")
    file:close()
    return token
  end
end

function M.setup(vars)
  local token = M.token()
  if token then
    vars.token = M.token()
  end
	api.setup(vars)
  config = vars
end

function M.setToken()
  local token = M.token(true)
  if token then
    config.token = token
  end
  api.setup(config)
end

return M
