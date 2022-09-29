local curl = require("plenary.curl")
local fn = vim.fn

local M = {}

local config = {}

local function evaluate(result)
  if result.status ~= 200 then
    vim.notify("Cannot execute request.")
    if result.status == 401 then
      vim.notify("Unauthorized request: make sure you have working token.")
    end
    return {status=result.status,body={}}
  end
  return {body=fn.json_decode(result.body ),status=result.status}
end

function M.setup(table)
	config.token = table.token
	config.base_url = table.base_url
end

-- OPTIMIZE:these calls should be async
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
  return evaluate(output)
end

function M.gethtml(url)
	local output = curl.get({
		url = url,
		headers = {
			Authorization = config.token,
		},
	})
  return evaluate(output)
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
  return evaluate(output)
end

return M
