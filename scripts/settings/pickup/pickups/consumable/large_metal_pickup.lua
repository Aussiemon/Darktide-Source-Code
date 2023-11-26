-- chunkname: @scripts/settings/pickup/pickups/consumable/large_metal_pickup.lua

local pickup_data = {
	description = "loc_pickup_large_metal",
	name = "large_metal",
	smart_tag_target_type = "pickup",
	spawn_weighting = 1,
	game_object_type = "pickup",
	interaction_type = "forge_material",
	look_at_tag = "forge_material",
	unit_name = "content/pickups/consumables/forge_materials/forge_material_metal_large_01",
	pickup_sound = "wwise/events/player/play_pick_up_forge_material_large",
	unit_template_name = "pickup",
	group = "forge_material",
	on_pickup_func = function (pickup_unit, interactor_unit, pickup_data)
		local pickup_system = Managers.state.extension:system("pickup_system")

		pickup_system:register_material_collected(pickup_unit, interactor_unit, "plasteel", "large")
	end
}

return pickup_data
