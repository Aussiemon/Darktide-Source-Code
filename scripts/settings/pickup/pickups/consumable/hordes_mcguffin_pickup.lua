-- chunkname: @scripts/settings/pickup/pickups/consumable/hordes_mcguffin_pickup.lua

local pickup_data = {
	description = "loc_mcguffin_pickup",
	unit_name = "content/environment/artsets/imperial/horde/props/pickup/mortis_relic_01",
	smart_tag_target_type = "pickup",
	group = "objective",
	interaction_type = "objective_pickup",
	pickup_sound = "wwise/events/player/play_pickup_metal_object",
	name = "hordes_mcguffin",
	on_pickup_func = function (pickup_unit, interactor_unit, pickup_data)
		local level = Managers.state.mission:mission_level()

		Level.trigger_event(level, "mcguffin_picked_up")
		Managers.event:trigger("hordes_mode_on_mcguffin_picked_up")
	end
}

return pickup_data
