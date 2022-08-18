local VisibilityInterface = require("scripts/managers/achievements/visibility/achievement_visibility_interface")
local AchievementVisibilityAlways = class("AchievementVisibilityAlways")

AchievementVisibilityAlways.is_visible = function (self, constant_achievement_data)
	return true
end

AchievementVisibilityAlways.destroy = function (self)
	return
end

implements(AchievementVisibilityAlways, VisibilityInterface)

return AchievementVisibilityAlways
