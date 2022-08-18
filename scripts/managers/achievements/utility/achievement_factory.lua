local AchievementDefinition = require("scripts/managers/achievements/achievement_definition")
local VisibilityChain = require("scripts/managers/achievements/visibility/achievement_visibility_chain")
local VisibilityHidden = require("scripts/managers/achievements/visibility/achievement_visibility_hidden")
local VisibilityAlways = require("scripts/managers/achievements/visibility/achievement_visibility_always")
local AchievementFactory = {}

local function _description_id_from_description(description)
	return string.format(description, "x")
end

local function _achievement_id_from_description(description, index)
	return string.format(description, index)
end

AchievementFactory.create_family_from_triggers = function (description, ui_type, category, triggers, optional_targets, optional_is_platform_map, optional_show_in_progress)
	local achievement_count = #triggers

	assert(achievement_count > 1, "A family must contain at least two values.")

	local id_array = {}

	for i = 1, achievement_count do
		id_array[i] = _achievement_id_from_description(description, i)
	end

	local show_in_progress = optional_show_in_progress == nil or optional_show_in_progress
	local is_platform_map = optional_is_platform_map or {}
	local description_id = _description_id_from_description(description)
	local achievements = {}

	for i = 1, achievement_count do
		local id = id_array[i]
		local trigger_component = triggers[i]
		local visibility_component = VisibilityChain:new(id, show_in_progress, id_array[i - 1], id_array[i + 1])
		local is_platform = table.array_contains(is_platform_map, i) or false

		if optional_targets then
			local description_table = {
				x = optional_targets[i]
			}
		end

		local previous_ids = i > 1 and table.slice(id_array, 1, i - 1) or nil
		achievements[i] = AchievementDefinition:new(id, ui_type, category, is_platform, trigger_component, visibility_component, description_id, description_table, previous_ids)
	end

	return achievements
end

AchievementFactory.create_family = function (description, ui_type, category, TriggerType, trigger, targets, optional_is_platform_map, optional_show_in_progress)
	local achievement_count = #targets

	assert(achievement_count > 1, "A family must contain at least two values.")

	local triggers = {}

	for i = 1, achievement_count do
		triggers[i] = TriggerType:new(trigger, targets[i])
	end

	return AchievementFactory.create_family_from_triggers(description, ui_type, category, triggers, targets, optional_is_platform_map, optional_show_in_progress)
end

AchievementFactory.create_unique = function (id, ui_type, category, trigger_component, optional_is_platform, optional_hidden)
	local visibility_component = optional_hidden and VisibilityHidden:new(id) or VisibilityAlways:new()
	local is_platform = optional_is_platform or false

	return AchievementDefinition:new(id, ui_type, category, is_platform, trigger_component, visibility_component)
end

return AchievementFactory
