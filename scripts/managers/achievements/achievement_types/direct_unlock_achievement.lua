-- chunkname: @scripts/managers/achievements/achievement_types/direct_unlock_achievement.lua

local DirectUnlockAchievement = {}

DirectUnlockAchievement.trigger_type = nil
DirectUnlockAchievement.trigger = nil
DirectUnlockAchievement.get_triggers = nil
DirectUnlockAchievement.get_progress = nil

DirectUnlockAchievement.setup = function ()
	return false
end

DirectUnlockAchievement.verifier = function (achievement_definition)
	return true
end

return DirectUnlockAchievement
