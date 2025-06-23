-- chunkname: @scripts/settings/pickup/pickups/consumable/small_metal_pickup.lua

local pickup_data = {
	description = "loc_pickup_small_metal",
	name = "small_metal",
	look_at_tag = "forge_material",
	smart_tag_target_type = "pickup",
	pickup_sound = "wwise/events/player/play_pick_up_forge_material_small",
	interaction_type = "forge_material",
	group = "forge_material",
	unit_name = "content/pickups/consumables/forge_materials/forge_material_metal_small_01",
	on_pickup_func = function (pickup_unit, interactor_unit, pickup_data)
		local pickup_system = Managers.state.extension:system("pickup_system")

		pickup_system:register_material_collected(pickup_unit, interactor_unit, "plasteel", "small")
	end
}

return pickup_data
