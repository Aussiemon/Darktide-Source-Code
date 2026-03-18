-- chunkname: @scripts/settings/pickup/pickups/consumable/expedition_loot_player_drop.lua

local pickup_data = {
	auto_tag_on_spawn = true,
	description = "loc_expeditions_pickup_loot_player_drop",
	group = "expeditions_loot",
	interaction_type = "expeditions_loot",
	look_at_tag = "healthstation",
	name = "expedition_loot_player_drop",
	pickup_sound = "wwise/events/player/play_pick_up_expeditions_player_loot_drop",
	smart_tag_target_type = "pickup",
	unit_name = "content/pickups/consumables/expeditions/loot_player_drop",
	on_pickup_func = function (pickup_unit, interactor_unit, pickup_data)
		Managers.event:trigger("event_expedition_player_loot_collected", interactor_unit, pickup_unit)
	end,
}

return pickup_data
