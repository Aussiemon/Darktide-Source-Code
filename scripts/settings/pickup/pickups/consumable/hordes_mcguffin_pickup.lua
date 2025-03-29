-- chunkname: @scripts/settings/pickup/pickups/consumable/hordes_mcguffin_pickup.lua

local pickup_data = {
	description = "loc_mcguffin_pickup",
	group = "objective",
	interaction_type = "objective_pickup",
	name = "hordes_mcguffin",
	pickup_sound = "wwise/events/player/play_pickup_metal_object",
	smart_tag_target_type = "pickup",
	unit_name = "content/environment/artsets/imperial/horde/props/pickup/mortis_relic_01",
	on_pickup_func = function (pickup_unit, interactor_unit, pickup_data)
		local level = Managers.state.mission:mission_level()

		Level.trigger_event(level, "mcguffin_picked_up")
		Managers.event:trigger("hordes_mode_on_mcguffin_picked_up")
	end,
}

return pickup_data
