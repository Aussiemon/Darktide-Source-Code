-- chunkname: @scripts/managers/achievements/achievement_types.lua

local DecreasingStatAchievement = require("scripts/managers/achievements/achievement_types/decreasing_stat_achievement")
local DirectUnlockAchievement = require("scripts/managers/achievements/achievement_types/direct_unlock_achievement")
local IncreasingStatAchievement = require("scripts/managers/achievements/achievement_types/increasing_stat_achievement")
local MetaAchievement = require("scripts/managers/achievements/achievement_types/meta_achievement")
local MultiStatAchievement = require("scripts/managers/achievements/achievement_types/multi_stat_achievement")
local AchievementTypes = {}

AchievementTypes.decreasing_stat = DecreasingStatAchievement
AchievementTypes.direct_unlock = DirectUnlockAchievement
AchievementTypes.increasing_stat = IncreasingStatAchievement
AchievementTypes.meta = MetaAchievement
AchievementTypes.multi_stat = MultiStatAchievement

return AchievementTypes
