local api = require("dodona.api")
local notify = require("notify")
local utils = require("dodona.utils")
local filter = require("dodona.filter")
local Job = require("plenary.job")

local M = {}

function M.getActivities(serie)
	return api.get("/series/" .. serie .. "/activities.json", false)
end

function M.getSeries(course)
	return api.get("/courses/" .. course .. "/series.json", false)
end

function M.subscribedCourses()
	return api.get("", false).user.subscribed_courses
end

function M.createFiles(activities)
	local dir = vim.fn.getcwd()
	for key, activity in ipairs(activities) do
		local filename = key .. "_" .. activity.name .. "." .. activity.programming_language.extension
		local file = io.open(dir .. "/" .. filename:gsub(" ", "_"), "a")
		file:write(string.sub(activity.url, 1, -6) .. "/\n")
		file:close()

		notify(activity.name .. " file created", "info")
	end
end

local function check_evaluated(url)
	local timer = vim.loop.new_timer()
	local i = 0
	-- Waits 2000ms, then repeats every 1000ms until timer:close().
	timer:start(
		2000,
		2000,
		vim.schedule_wrap(function()
			local result = api.get(url, true)

			if result.status ~= "running" and result.status ~= "queued" then
				local color
				if result.accepted then
					color = "info"
				else
					color = "error"
				end
				notify(result.status .. ": " .. result.summary .. "\n" .. string.sub(result.url, 1, -6), color)
				timer:close()
			end

			if i > 10 then
				timer:close() -- Always close handles to avoid leaks.
			end
			i = i + 1
		end)
	)
end

function M.evalSubmission(filename, ext)
	local file = io.open(filename, "r")
	local url = utils.split(file:read():reverse(), "/")
	local filtered = filter.filter(ext, file:read("*a"))
	local body = {
		submission = {
			code = filtered,
			course_id = tonumber(url[6]:reverse()),
			series_id = tonumber(url[4]:reverse()),
			exercise_id = tonumber(url[2]:reverse()),
		},
	}
	file:close()

	local response = api.post("/submissions.json", body)
	if response.status == "ok" then
		notify("Solution has been submitted \nEvaluating...", "warn")
		check_evaluated(response.url)
	else
		notify("Submit failed!!!", "error")
	end
end

local function download(base_url, w)
	Job
		:new({
			command = "wget",
			args = { base_url .. string.sub(w, 2, -2) },
			cwd = vim.fn.getcwd(),
			env = { ["a"] = "b" },
			on_exit = function(j, return_val)
				if return_val == 0 then
					notify(string.sub(w, w:find("/[^/]*$") + 1, -2) .. " downloaded", "info")
				else
					notify("error when getting " .. string.sub(w, w:find("/[^/]*$") + 1, -2), "error")
				end
			end,
		})
		:sync() -- or start()
end

function M.downloadData(url)
	local response = api.get(string.sub(url, url:find("https"), -2) .. ".json", true)

	local description = api.gethtml(response.description_url)
	local handled = {}
	for w in string.gmatch(description, '"media/.-"') do
		if not utils.has_value(handled, w) and not w:find(".png") then
			download(response.description_url, w)
			table.insert(handled, w)
		end
	end
end

return M
