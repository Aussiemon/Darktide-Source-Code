-- chunkname: @scripts/settings/expeditions/expedition_generator.lua

local CANNOT_GENERATE = BUILD == "release" or IS_XBS or IS_PLAYSTATION or IS_FILESERVER_CLIENT

local function _get_relative_path()
	local path = debug.getinfo(1, "S").source:sub(2)

	return path and path:match("(.*/)") or ""
end

local function _get_file_storage_path()
	if CANNOT_GENERATE then
		return ""
	else
		local source_dir_path = Application.source_directory()

		if not source_dir_path then
			return ""
		end

		local dir = source_dir_path .. "/" .. _get_relative_path() .. "configs/"

		dir = string.gsub(dir, "/", "\\")

		return dir
	end
end

local function recursive_get_files(fs, dir, file_type, output)
	for _, path in pairs(FileSystem.entries(fs, dir)) do
		if FileSystem.is_directory(fs, path) then
			recursive_get_files(fs, path, file_type, output)
		elseif string.ends_with(path, file_type) then
			output[#output + 1] = path
		end
	end
end

local function _get_files_in_directory(directory, file_type)
	if CANNOT_GENERATE then
		return {}
	else
		local file_paths = {}
		local fs = FileSystem(directory)

		recursive_get_files(fs, "", file_type, file_paths)
		FileSystem.close(fs)

		return file_paths
	end
end

local ExpeditionGenerator = {}

ExpeditionGenerator.generate = function (optional_number_of_locations)
	if CANNOT_GENERATE then
		return
	else
		local Expedition = require("scripts/utilities/expedition")
		local ExpeditionTemplates = require("scripts/settings/expeditions/expedition_templates")
		local seed = math.random(0, 9999999)
		local expedition_template_name = "wastes"
		local expedition_template = ExpeditionTemplates[expedition_template_name]
		local expedition_layout = Expedition.generate_expedition_layout(expedition_template, seed, optional_number_of_locations, true)
		local file_name = "generated_expedition_" .. math.random(0, 9999999) .. ".lua"
		local dir = _get_file_storage_path() .. file_name
		local file = io and io.open and io.open(dir, "w+")

		if file then
			local save_string = "return " .. table.tostring(expedition_layout, math.huge, false)

			file:write(save_string)
			file:close()
		end
	end
end

ExpeditionGenerator.load_local_config_file = function (file_name)
	if CANNOT_GENERATE then
		return
	else
		local dir = _get_file_storage_path() .. file_name .. ".lua"
		local file = io and io.open and io.open(dir, "r")

		if file then
			local content = file:read("*all")

			file:close()

			local expedition = assert(loadstring(content))()

			for _, segment in ipairs(expedition) do
				local levels_data = segment.levels_data

				for _, level_data in ipairs(levels_data) do
					level_data.segment = segment
				end
			end

			return expedition
		end
	end
end

ExpeditionGenerator.get_local_file_names = function ()
	local paths = {}

	return paths
end

return ExpeditionGenerator
