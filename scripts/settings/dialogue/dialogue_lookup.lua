local DialogueSettings = require("scripts/settings/dialogue/dialogue_settings")
DialogueLookup = DialogueLookup or {}

setmetatable(DialogueLookup, nil)
table.clear(DialogueLookup)

DialogueLookup_n = 0

local function _add_to_lookup(path)
	require(path)
end

_add_to_lookup(DialogueSettings.default_lookup_path .. "lookup_asset_vo")
_add_to_lookup(DialogueSettings.default_lookup_path .. "lookup_circumstance_vo_nurgle_rot")
_add_to_lookup(DialogueSettings.default_lookup_path .. "lookup_conversations_core")
_add_to_lookup(DialogueSettings.default_lookup_path .. "lookup_conversations_hub")
_add_to_lookup(DialogueSettings.default_lookup_path .. "lookup_enemy_vo")
_add_to_lookup(DialogueSettings.default_lookup_path .. "lookup_event_vo_delivery")
_add_to_lookup(DialogueSettings.default_lookup_path .. "lookup_event_vo_demolition")
_add_to_lookup(DialogueSettings.default_lookup_path .. "lookup_event_vo_fortification")
_add_to_lookup(DialogueSettings.default_lookup_path .. "lookup_event_vo_hacking")
_add_to_lookup(DialogueSettings.default_lookup_path .. "lookup_event_vo_kill")
_add_to_lookup(DialogueSettings.default_lookup_path .. "lookup_event_vo_scan")
_add_to_lookup(DialogueSettings.default_lookup_path .. "lookup_event_vo_survive")
_add_to_lookup(DialogueSettings.default_lookup_path .. "lookup_gameplay_vo")
_add_to_lookup(DialogueSettings.default_lookup_path .. "lookup_guidance_vo")
_add_to_lookup(DialogueSettings.default_lookup_path .. "lookup_mission_giver_vo")
_add_to_lookup(DialogueSettings.default_lookup_path .. "lookup_mission_vo_dm_forge")
_add_to_lookup(DialogueSettings.default_lookup_path .. "lookup_mission_vo_km_enforcer")
_add_to_lookup(DialogueSettings.default_lookup_path .. "lookup_mission_vo_lm_cooling")
_add_to_lookup(DialogueSettings.default_lookup_path .. "lookup_mission_vo_lm_rails")
_add_to_lookup(DialogueSettings.default_lookup_path .. "lookup_on_demand_vo")
_add_to_lookup(DialogueSettings.default_lookup_path .. "lookup_training_grounds")

return DialogueLookup
