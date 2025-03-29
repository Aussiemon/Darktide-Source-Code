-- chunkname: @scripts/settings/pickup/pickups/consumable/small_metal_pickup.lua

local pickup_data = {
	description = "loc_pickup_small_metal",
	group = "forge_material",
	interaction_type = "forge_material",
	look_at_tag = "forge_material",
	name = "small_metal",
	pickup_sound = "wwise/events/player/play_pick_up_forge_material_small",
	smart_tag_target_type = "pickup",
	unit_name = "content/pickups/consumables/forge_materials/forge_material_metal_small_01",
	on_pickup_func = function (pickup_unit, interactor_unit, pickup_data)
		local pickup_system = Managers.state.extension:system("pickup_system")

		pickup_system:register_material_collected(pickup_unit, interactor_unit, "plasteel", "small")
	end,
}

return pickup_data
