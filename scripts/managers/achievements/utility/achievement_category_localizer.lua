local AchievementLocKeys = require("scripts/settings/achievements/achievement_loc_keys")
local AchievementCategoryLocalizer = {
	get_localized = function (category_id)
		local category = AchievementLocKeys.categories[category_id]

		return Localize(category)
	end
}

return AchievementCategoryLocalizer
