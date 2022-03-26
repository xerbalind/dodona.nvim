local curl = require("plenary.curl")
local fn = vim.fn

local M = {}

local config = {}

function M.setup(table)
	config.token = table.token
	config.base_url = table.base_url
end

function M.get(url, full_url)
	if not full_url then
		url = config.base_url .. url
	end

	local output = curl.get({
		url = url,
		accept = "application/json",
		headers = {
			content_type = "application/json",
			Authorization = config.token,
		},
	})
	return fn.json_decode(output.body)
end

function M.post(url, body)
	local json = fn.json_encode(body)
	local output = curl.post({
		body = json,
		url = config.base_url .. url,
		headers = {
			content_type = "application/json",
			Authorization = config.token,
		},
	})
	return fn.json_decode(output.body)
end

return M
