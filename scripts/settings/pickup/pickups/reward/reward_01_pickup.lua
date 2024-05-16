-- chunkname: @scripts/settings/pickup/pickups/reward/reward_01_pickup.lua

local pickup_data = {
	description = "loc_pickup_small_metal",
	game_object_type = "pickup",
	group = "rewards",
	interaction_type = "forge_material",
	name = "reward_01_pickup",
	pickup_sound = "wwise/events/player/play_pick_up_valuable",
	smart_tag_target_type = "pickup",
	spawn_weighting = 1,
	unit_name = "content/pickups/rewards/reward_pickup_01",
	unit_template_name = "pickup",
	on_pickup_func = function (pickup_unit, interactor_unit, pickup_data)
		local pickup_system = Managers.state.extension:system("pickup_system")

		pickup_system:register_material_collected(pickup_unit, interactor_unit, "reward_01_pickup", "small")
	end,
}

return pickup_data
