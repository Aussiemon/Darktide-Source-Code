-- chunkname: @scripts/managers/achievements/achievement_tweak_data.lua

local achievement_tweak_data = {}

achievement_tweak_data.broker_stimm_durability_potency = {
	min_potency = 0.5,
}
achievement_tweak_data.broker_stimm_combat_potency = {
	min_potency = 0.5,
}
achievement_tweak_data.broker_stimm_celerity_potency = {
	min_potency = 0.5,
}

return settings("AchievementSettings", achievement_tweak_data)
