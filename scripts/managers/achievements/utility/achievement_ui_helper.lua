local AchievementUIHelper = {
	achievement_category_label = function (category_id)
		local localization_key = string.format("loc_achievement_category_%s_label", category_id)

		return Localize(localization_key)
	end
}

return AchievementUIHelper
