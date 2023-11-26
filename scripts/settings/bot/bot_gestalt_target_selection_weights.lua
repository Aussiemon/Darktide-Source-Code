-- chunkname: @scripts/settings/bot/bot_gestalt_target_selection_weights.lua

local BotSettings = require("scripts/settings/bot/bot_settings")
local behavior_gestalts = BotSettings.behavior_gestalts
local DEFAULT_BREED_WEIGHT = 5
local bot_gestalt_target_selection_weights = {
	DEFAULT_BREED_WEIGHT = DEFAULT_BREED_WEIGHT,
	[behavior_gestalts.none] = {},
	[behavior_gestalts.killshot] = {
		chaos_ogryn_executor = -5,
		renegade_gunner = -5,
		renegade_executor = -5,
		chaos_ogryn_bulwark = -5
	}
}

return settings("BotGestaltTargetSelectionWeights", bot_gestalt_target_selection_weights)
