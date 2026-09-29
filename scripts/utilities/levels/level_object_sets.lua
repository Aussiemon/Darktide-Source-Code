-- chunkname: @scripts/utilities/levels/level_object_sets.lua

local LevelObjectSetsSettings = require("scripts/settings/level_object_sets/level_object_sets_settings")
local MissionTemplates = require("scripts/settings/mission/mission_templates")
local LevelObjectSets = {}
local OBJECT_SET_TYPES = LevelObjectSetsSettings.object_set_types

local function _object_set_type(object_set_name, mission_name)
	local mission_template = MissionTemplates[mission_name]
	local controllable_object_set_prefixes = mission_template.controllable_object_set_prefixes

	if not controllable_object_set_prefixes then
		return OBJECT_SET_TYPES.static, ""
	end

	for ii = 1, #controllable_object_set_prefixes do
		local prefix = controllable_object_set_prefixes[ii]
		local prefix_match = string.match(object_set_name, string.format("^%s_", prefix))

		if prefix_match then
			return OBJECT_SET_TYPES.controllable, prefix
		end
	end

	return OBJECT_SET_TYPES.static, ""
end

LevelObjectSets.object_sets_from_level = function (level_name, mission_name)
	local object_sets = {}
	local num_nested_levels = LevelResource.nested_level_count(level_name, mission_name)

	if num_nested_levels > 0 then
		for ii = 1, num_nested_levels do
			local available_level_sets = LevelResource.nested_level_object_set_names(level_name, ii)

			for object_set_index, object_set_name in ipairs(available_level_sets) do
				local object_set_type, object_set_prefix = _object_set_type(object_set_name, mission_name)

				if not object_sets[object_set_name] then
					object_sets[object_set_name] = {}
				end

				object_sets[object_set_name][#object_sets[object_set_name] + 1] = {
					name = object_set_name,
					object_set_index = object_set_index,
					nested_level_name = LevelResource.nested_level_resource_name(level_name, ii),
					units_indices = LevelResource.nested_level_unit_indices_in_object_set(level_name, ii, object_set_name),
					object_set_type = object_set_type,
					object_set_prefix = object_set_prefix,
				}
			end
		end
	end

	local available_level_sets = LevelResource.object_set_names(level_name)

	for object_set_index, object_set_name in ipairs(available_level_sets) do
		local object_set_type, object_set_prefix = _object_set_type(object_set_name, mission_name)

		if not object_sets[object_set_name] then
			object_sets[object_set_name] = {}
		end

		object_sets[object_set_name][#object_sets[object_set_name] + 1] = {
			name = object_set_name,
			object_set_index = object_set_index,
			units_indices = LevelResource.unit_indices_in_object_set(level_name, object_set_name),
			object_set_type = object_set_type,
			object_set_prefix = object_set_prefix,
		}
	end

	return object_sets
end

return LevelObjectSets
