-- chunkname: @scripts/settings/pickup/pickups/consumable/small_metal_pickup.lua

local pickup_data = {
	description = "loc_pickup_small_metal",
	game_object_type = "pickup",
	group = "forge_material",
	interaction_type = "forge_material",
	look_at_tag = "forge_material",
	name = "small_metal",
	pickup_sound = "wwise/events/player/play_pick_up_forge_material_small",
	smart_tag_target_type = "pickup",
	spawn_weighting = 1,
	unit_name = "content/pickups/consumables/forge_materials/forge_material_metal_small_01",
	unit_template_name = "pickup",
	on_pickup_func = function (pickup_unit, interactor_unit, pickup_data)
		local pickup_system = Managers.state.extension:system("pickup_system")

		pickup_system:register_material_collected(pickup_unit, interactor_unit, "plasteel", "small")
	end,
}

return pickup_data
