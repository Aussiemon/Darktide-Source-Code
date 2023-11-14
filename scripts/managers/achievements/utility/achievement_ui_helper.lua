local AchievementCategories = require("scripts/settings/achievements/achievement_categories")
local MasterItems = require("scripts/backend/master_items")
local TextUtils = require("scripts/utilities/ui/text")
local UISettings = require("scripts/settings/ui/ui_settings")
local _item_type_group_lookup = UISettings.item_type_group_lookup
local AchievementUIHelper = {
	achievement_category_label = function (category_id)
		local localization_key = AchievementCategories[category_id].display_name

		return Localize(localization_key)
	end,
	get_reward_item = function (achievement_definition)
		local reward_item, item_group = nil
		local rewards = achievement_definition.rewards

		if rewards and #rewards > 0 then
			local reward_id = rewards[1].masterId
			reward_item = MasterItems.get_item(reward_id)
			local item_type = reward_item and reward_item.item_type
			item_group = item_type and _item_type_group_lookup[item_type]
		end

		return reward_item, item_group
	end,
	get_acheivement_by_reward_item = function (item)
		local achievements = Managers.achievements:achievement_definitions()

		for _, achievement in pairs(achievements) do
			local rewards = achievement.rewards

			if rewards and #rewards > 0 then
				local reward_id = rewards[1].masterId
				local reward_item = MasterItems.get_item(reward_id)

				if reward_item.name == item.name then
					return achievement
				end
			end
		end
	end,
	localized_title = function (achievement_definition)
		local flags = achievement_definition.flags
		local loc_title_variables = achievement_definition.loc_title_variables
		local localized_title = Localize(achievement_definition.title, loc_title_variables ~= nil, loc_title_variables)

		if flags.private_only then
			localized_title = string.format("%s %s", localized_title, TextUtils.apply_color_to_text("", Color.terminal_text_warning_light(255, true)))
		end

		return localized_title
	end
}
local _loc_variables = {}

AchievementUIHelper.localized_description = function (achievement_definition)
	local flags = achievement_definition.flags
	local _loc_variables = achievement_definition.loc_variables or _loc_variables
	local has_target = _loc_variables.target ~= nil

	if not has_target then
		_loc_variables.target = achievement_definition.target
	end

	local localized_description = Localize(achievement_definition.description, true, _loc_variables)

	if not has_target then
		_loc_variables.target = nil
	end

	if flags.private_only then
		local private_description = string.format("\n %s: %s", Localize("loc_private_tag_name"), Localize("loc_private_tag_description"))
		localized_description = string.format("%s%s", localized_description, TextUtils.apply_color_to_text(private_description, Color.terminal_text_warning_dark(255, true)))
	end

	return localized_description
end

AchievementUIHelper.get_family = function (achievement_definition)
	local definitions = Managers.achievements:achievement_definitions()
	local at = achievement_definition

	while at.previous do
		at = definitions[at.previous]
	end

	local family = {}

	while at ~= nil do
		family[#family + 1] = at
		at = definitions[at.next]
	end

	return family
end

return AchievementUIHelper
