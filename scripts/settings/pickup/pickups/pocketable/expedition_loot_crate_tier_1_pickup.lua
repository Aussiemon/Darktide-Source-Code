-- chunkname: @scripts/settings/pickup/pickups/pocketable/expedition_loot_crate_tier_1_pickup.lua

local loot_data = {
	is_expedition_loot = true,
	tier = 1,
	type = "crate",
}
local pickup_data = {
	description = "loc_pickup_side_mission_pocketable_02",
	group = "side_mission_collect",
	interaction_type = "pocketable",
	inventory_item = "content/items/pocketable/expedition_loot_crate_tier_1_pocketable",
	inventory_slot_name = "slot_pocketable",
	is_side_mission_pickup = false,
	look_at_tag = "none",
	name = "expedition_loot_crate_tier_1",
	pickup_sound = "wwise/events/player/play_pick_up_expeditions_loot_crate_quality_low",
	smart_tag_target_type = "pickup",
	unit_name = "content/pickups/pocketables/expedition_loot_crate/expedition_loot_crate_01_pickup",
	loot_data = loot_data,
	on_pickup_func = function (pickup_unit, interactor_unit, pickup_data, t, interactor_is_server)
		local loot_type = loot_data.type
		local loot_tier = loot_data.tier
		local show_notification = false

		Managers.event:trigger("event_expedition_pocketable_collected", interactor_unit, loot_type, loot_tier, show_notification)

		if interactor_is_server then
			Managers.state.pacing:add_heat_by_type("small", pickup_unit, "pickups", interactor_unit)
		end
	end,
	on_drop_func = function (pickup_unit, interactor_unit)
		local loot_type = loot_data.type
		local loot_tier = loot_data.tier
		local show_notification = false

		Managers.event:trigger("event_expedition_pocketable_dropped", interactor_unit, loot_type, loot_tier, show_notification)
	end,
}

return pickup_data
