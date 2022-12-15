local AchievementCategories = require("scripts/settings/achievements/achievement_categories")
local MasterItems = require("scripts/backend/master_items")
local UISettings = require("scripts/settings/ui/ui_settings")
local _item_type_group_lookup = UISettings.item_type_group_lookup
local AchievementUIHelper = {
	achievement_category_label = function (category_id)
		local localization_key = AchievementCategories[category_id].display_name

		return Localize(localization_key)
	end,
	get_reward_item = function (achievement)
		local reward_item, item_group = nil
		local rewards = achievement.rewards

		if rewards and #rewards > 0 then
			local reward_id = rewards[1].masterId
			reward_item = MasterItems.get_item(reward_id)
			local item_type = reward_item and reward_item.item_type
			item_group = item_type and _item_type_group_lookup[item_type]
		end

		return reward_item, item_group
	end
}

return AchievementUIHelper
