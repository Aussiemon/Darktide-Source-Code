-- chunkname: @scripts/settings/pickup/pickups/consumable/expedition_currency_small_tier_2.lua

local pickup_data = {
	description = "loc_expeditions_pickup_currency_quality_medium",
	group = "expeditions_currency",
	interaction_type = "expeditions_currency",
	look_at_tag = "salvage",
	name = "expedition_currency_small_tier_2",
	pickup_sound = "wwise/events/player/play_pick_up_expeditions_currency_quality_medium",
	smart_tag_target_type = "pickup",
	unit_name = "content/pickups/consumables/expeditions/salvage_pickups/salvage_pickup_large",
	on_pickup_func = function (pickup_unit, interactor_unit, pickup_data)
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local player = player_unit_spawn_manager:owner(interactor_unit)

		if player then
			local currency_type = "small"
			local currency_tier = 2

			Managers.event:trigger("event_expedition_currency_collected", interactor_unit, currency_type, currency_tier)
		end
	end,
}

return pickup_data
