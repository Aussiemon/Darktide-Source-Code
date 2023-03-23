local AchievementDefinition = require("scripts/managers/achievements/achievement_definition")
local AchievementCategories = require("scripts/settings/achievements/achievement_categories")
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

AchievementFactory.create_family_from_triggers = function (description, ui_type, icon, category, triggers, optional_show_in_progress, optional_description_table, optional_unique_descriptions)
	local achievement_count = #triggers
	local id_array = {}

	for i = 1, achievement_count do
		id_array[i] = _achievement_id_from_description(description, i)
	end

	local show_in_progress = optional_show_in_progress == nil or optional_show_in_progress
	local unique_descriptions = optional_unique_descriptions ~= false
	local family_description_id = _description_id_from_description(description)
	local achievements = {}

	for i = 1, achievement_count do
		local id = id_array[i]
		local description_id = unique_descriptions and id or family_description_id
		local trigger_component = triggers[i]
		local visibility_component = VisibilityChain:new(id, show_in_progress, id_array[i - 1], id_array[i + 1])
		local description_table = optional_description_table and table.clone(optional_description_table)
		achievements[i] = AchievementDefinition:new(id, ui_type, icon, category, trigger_component, visibility_component, description_id, description_table, id_array)
	end

	return achievements
end

AchievementFactory.create_family = function (description, ui_type, icon, category, TriggerType, trigger, targets, optional_show_in_progress, optional_description_table)
	local achievement_count = #targets
	local triggers = {}

	for i = 1, achievement_count do
		triggers[i] = TriggerType:new(trigger, targets[i])
	end

	return AchievementFactory.create_family_from_triggers(description, ui_type, icon, category, triggers, optional_show_in_progress, optional_description_table, false)
end

AchievementFactory.create_unique = function (id, ui_type, icon, category, trigger_component, optional_hidden, optional_description_table, optional_label_table)
	local visibility_component = optional_hidden and VisibilityHidden:new(id) or VisibilityAlways:new()

	return AchievementDefinition:new(id, ui_type, icon, category, trigger_component, visibility_component, nil, optional_description_table, nil, optional_label_table)
end

return AchievementFactory
