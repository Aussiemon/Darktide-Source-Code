-- chunkname: @scripts/settings/bot_character_profiles.lua

local LocalProfileBackendParser = require("scripts/utilities/local_profile_backend_parser")
local MasterItems = require("scripts/backend/master_items")
local IngameBotProfiles = require("scripts/settings/bot_profiles/ingame_bot_profiles")
local MiscBotProfiles = require("scripts/settings/bot_profiles/misc_bot_profiles")
local TrainingGroundBotProfiles = require("scripts/settings/bot_profiles/training_ground_bot_profiles")
local TutorialBotProfiles = require("scripts/settings/bot_profiles/tutorial_bot_profiles")
local bot_profiles_cached = {}

local function bot_profiles(item_definitions)
	if bot_profiles_cached[item_definitions] then
		return bot_profiles_cached[item_definitions]
	end

	local profiles = {}

	IngameBotProfiles(profiles)
	MiscBotProfiles(profiles)
	TrainingGroundBotProfiles(profiles)
	TutorialBotProfiles(profiles)

	for profile_name, profile in pairs(profiles) do
		local loadout = profile.loadout

		for slot_name, item_id in pairs(loadout) do
			local item = MasterItems.get_item_or_fallback(item_id, slot_name, item_definitions)

			loadout[slot_name] = item
		end

		LocalProfileBackendParser.parse_profile(profile, profile_name)
	end

	bot_profiles_cached[item_definitions] = profiles

	return profiles
end

return bot_profiles
