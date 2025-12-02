-- chunkname: @scripts/settings/pickup/pickups/consumable/paper_pickup_03.lua

local pickup_data = {
	description = "loc_paper_pickup",
	group = "objective",
	interaction_type = "objective_pickup_hidden_hold",
	name = "paper_pickup_03",
	pickup_sound = "wwise/events/player/play_pick_up_paper",
	smart_tag_target_type = "pickup",
	unit_name = "content/pickups/consumables/objective/intel_prop_03",
	on_pickup_func = function (pickup_unit, interactor_unit, pickup_data)
		local level = Managers.state.mission:mission_level()

		Level.trigger_event(level, "paper_grabbed")
	end,
}

return pickup_data
