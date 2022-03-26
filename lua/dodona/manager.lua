local api = require("dodona.api")
local notify = require("notify")
local utils = require("dodona.utils")

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
	-- Waits 1000ms, then repeats every 750ms until timer:close().
	timer:start(
		2000,
		1000,
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

function M.evalSubmission(filename)
	local file = io.open(filename, "r")
	local url = utils.split(file:read(), "/")
	local body = {
		submission = {
			code = file:read("*a"),
			course_id = tonumber(url[6]),
			series_id = tonumber(url[8]),
			exercise_id = tonumber(url[10]),
		},
	}
	file:close()
	local response = api.post("/submissions.json", body)
	if response.status == "ok" then
		notify("Solution has been submitted \nEvaluating...", "warn")
	else
		notify("Submit failed!!!", "error")
	end

	check_evaluated(response.url)
end

return M
