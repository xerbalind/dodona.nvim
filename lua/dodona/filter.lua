local utils = require("dodona.utils")

local M = {}

local function javafilter(text)
	local output = ""
	for line in utils.lines(text) do
		if not string.find(line, "^package") then
			output = output .. line .. "\n"
		end
	end
	return output
end

local function pythonfilter(text)
	local output = ""
	for line in utils.lines(text) do
		if string.find(line, 'if __name__ == "__main__"') then
			return string.gsub(output, "\n+$", "")
		end
		output = output .. line .. "\n"
	end
	return output
end

local extensions = {
	java = javafilter,
	py = pythonfilter,
}

function M.filter(extension, text)
	if extensions[extension] ~= nil then
		return extensions[extension](text)
	else
		return text
	end
end

return M
