local DecreasingStatAchievement = require("scripts/managers/achievements/achievement_types/decreasing_stat_achievement")
local DirectUnlockAchievement = require("scripts/managers/achievements/achievement_types/direct_unlock_achievement")
local IncreasingStatAchievement = require("scripts/managers/achievements/achievement_types/increasing_stat_achievement")
local MetaAchievement = require("scripts/managers/achievements/achievement_types/meta_achievement")
local MultiStatAchievement = require("scripts/managers/achievements/achievement_types/multi_stat_achievement")
local AchievementTypes = {
	decreasing_stat = DecreasingStatAchievement,
	direct_unlock = DirectUnlockAchievement,
	increasing_stat = IncreasingStatAchievement,
	meta = MetaAchievement,
	multi_stat = MultiStatAchievement
}

return AchievementTypes
