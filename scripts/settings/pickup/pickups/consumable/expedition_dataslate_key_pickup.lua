-- chunkname: @scripts/settings/pickup/pickups/consumable/expedition_dataslate_key_pickup.lua

local ExpeditionCollectibles = require("scripts/settings/expeditions/expedition_collectibles")
local collectible_key = "dataslate_key"
local collectible = ExpeditionCollectibles[collectible_key]
local pickup_data = {
	action_text = "loc_action_interaction_pickup",
	group = "objective",
	interaction_type = "objective_pickup",
	name = "expedition_dataslate_key",
	pickup_sound = "wwise/events/player/play_pickup_metal_object",
	smart_tag_target_type = "pickup",
	unit_name = "content/pickups/consumables/side_mission/dataslate/dataslate_pickup_01",
	description = collectible.display_name,
	on_pickup_func = function (pickup_unit, interactor_unit, pickup_data)
		local amount = 1
		local collectible_id = NetworkLookup.expedition_collectibles[collectible_key]

		Managers.event:trigger("event_expedition_collectible_collected", interactor_unit, collectible_id, amount)
	end,
}

return pickup_data
