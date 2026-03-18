-- chunkname: @scripts/settings/pickup/pickups/consumable/expedition_loot_small_tier_2.lua

local pickup_data = {
	description = "loc_expeditions_pickup_loot_quality_medium",
	group = "expeditions_loot",
	interaction_type = "expeditions_loot",
	look_at_tag = "healthstation",
	name = "expedition_loot_small_tier_2",
	pickup_sound = "wwise/events/player/play_pick_up_expeditions_loot_quality_medium",
	smart_tag_target_type = "pickup",
	unit_name = "content/pickups/pocketables/expedition_loot_crate/expedition_loot_crate_02_pickup",
	on_pickup_func = function (pickup_unit, interactor_unit, pickup_data)
		local loot_type = "small"
		local loot_tier = 2

		Managers.event:trigger("event_expedition_loot_collected", interactor_unit, loot_type, loot_tier)
		Managers.state.pacing:add_heat_by_type("small", pickup_unit, "pickups", interactor_unit)
	end,
}

return pickup_data
