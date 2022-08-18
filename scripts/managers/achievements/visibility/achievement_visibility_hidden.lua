local VisibilityInterface = require("scripts/managers/achievements/visibility/achievement_visibility_interface")
local AchievementVisibilityHidden = class("AchievementVisibilityHidden")

AchievementVisibilityHidden.init = function (self, achievement_id)
	self._achievement_id = achievement_id
end

AchievementVisibilityHidden.is_visible = function (self, constant_achievement_data)
	return constant_achievement_data.completed[self._achievement_id] ~= nil
end

AchievementVisibilityHidden.destroy = function (self)
	return
end

implements(AchievementVisibilityHidden, VisibilityInterface)

return AchievementVisibilityHidden
