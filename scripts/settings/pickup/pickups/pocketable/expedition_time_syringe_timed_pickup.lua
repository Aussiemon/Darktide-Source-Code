-- chunkname: @scripts/settings/pickup/pickups/pocketable/expedition_time_syringe_timed_pickup.lua

local pickup_data = {
	description = "loc_expeditions_pickup_description_syringe_timed",
	extra_description = "loc_expeditions_pickup_extra_description_syringe_timed",
	group = "timed",
	interaction_icon = "content/ui/materials/hud/interactions/icons/time_syringe",
	interaction_type = "pickup",
	look_at_tag = "none",
	name = "expedition_time_syringe_timed",
	pickup_sound = "wwise/events/player/play_pick_up_syringe_time",
	smart_tag_target_type = "pickup",
	unit_name = "content/pickups/timed/time_syringe/pup_time_syringe",
	on_pickup_func = function (interactee_unit, interactor_unit, pickup_data, t)
		if not Managers.state.game_session:is_server() then
			return
		end

		Managers.event:trigger("event_add_expedition_time_bonus", 300)
	end,
}

return pickup_data
