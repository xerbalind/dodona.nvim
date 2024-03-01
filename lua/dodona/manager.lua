local api = require("dodona.api")
local notify = require("notify")
local utils = require("dodona.utils")
local filter = require("dodona.filter")
local Job = require("plenary.job")
local comments = require("dodona.comments")

local M = {}

-- NOTE: next 3 functions can be refactored
function M.getActivities(serie)
	local response =  api.get("/series/" .. serie .. "/activities.json", false)
  if response.status == 200 then
    return response.body
  end
  return {}
end

function M.getSeries(course)
	local response = api.get("/courses/" .. course .. "/series.json", false)
  if response.status == 200 then
    return response.body
  end
  return {}
end

function M.subscribedCourses()
	local response = api.get("", false)
  if response.status == 200 and response.body.user then
    return response.body.user.subscribed_courses
  end
  return {}
end

function M.createFiles(activities)
    local dir = vim.fn.expand("%:p:h")

    for key, activity in ipairs(activities) do
        if activity.programming_language ~= nil then
            local filename = key .. "_" .. activity.name .. "." .. activity.programming_language.extension
            local file = io.open(dir .. "/" .. filename:gsub(" ", "_"), "a") 

            if file ~= nil then
                local c = comments[activity.programming_language.name]
                file:write((c ~= nil and c or "") .. string.sub(activity.url, 1, -6) .. "/\n")
                if activity.boilerplate ~= vim.NIL then
                    file:write('\n' .. activity.boilerplate)
                end
                file:close()
                notify(dir .. "/" .. filename:gsub(" ", "_") .. " file created", "info")
            end
        end
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
			local response = api.get(url, true)

			if i > 10 or response.status ~= 200 then
				timer:close() -- Always close handles to avoid leaks.
			end

			if response.body.status ~= "running" and response.body.status ~= "queued" then
				local color
				if response.body.accepted then
					color = "info"
				else
					color = "error"
				end
				timer:close()
				notify(
					response.body.status .. ": " .. tostring(response.body.summary) .. "\n" .. string.sub(response.body.url, 1, -6),
					color
				)
			end

			i = i + 1
		end)
	)
end

function M.evalSubmission(filename, ext)
	local file = io.open(filename, "r")

  if file == nil then return end

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
	if response.body.status == "ok" and response.status == 200 then
		notify("Solution has been submitted \nEvaluating...", "warn")
		check_evaluated(response.body.url)
	else
		notify("Submit failed!!!", "error")
	end
end

local function download(base_url, w)
	Job
		:new({
			command = "wget",
			args = { base_url .. string.sub(w, 2, -2) },
			cwd = vim.fn.expand("%:p:h"),
			env = { ["a"] = "b" },
			on_exit = function(_, return_val)
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
	local response = api.get(string.sub(url, url:find("https"), -1):gsub("/[^/]*$", "") .. ".json", true)

  if response.status ~= 200 then return end

	local description = api.gethtml(response.body.description_url).body
	local handled = {}
	for w in string.gmatch(description, '"media/.-"') do
		if not utils.has_value(handled, w) and not w:find(".png") and not w:find(".jpg") then
			download(response.body.description_url, w)
			table.insert(handled, w)
		end
	end
end

return M
