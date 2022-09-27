local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local manager = require("dodona.manager")

local current_search

local M = {}

local attach_mappings = function(prompt_bufnr, _)
	actions.select_default:replace(function()
		actions.close(prompt_bufnr)
		local selection = action_state.get_selected_entry()
		if current_search == "courses" then
			current_search = "series"
			M.show(manager.getSeries(selection.value.id))
		elseif current_search == "series" then
			manager.createFiles(manager.getActivities(selection.value.id))
		end
	end)
	return true
end

local show = function(opts, finder)
	opts = opts or {}
	pickers.new(opts, {
		prompt_title = M.current_search,
		finder = finder,
		attach_mappings = attach_mappings,
		sorter = conf.generic_sorter(opts),
	}):find()
end

function M.initActivities()
	current_search = "courses"
	M.show(manager.subscribedCourses())
end

function M.show(results)
	show(
		{},
		finders.new_table({
			results = results,
			entry_maker = function(entry)
				return {
					value = entry,
					display = entry.name,
					ordinal = entry.name,
				}
			end,
		})
	)
end

return M
