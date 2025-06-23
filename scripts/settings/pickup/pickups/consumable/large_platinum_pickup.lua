-- chunkname: @scripts/settings/pickup/pickups/consumable/large_platinum_pickup.lua

local pickup_data = {
	description = "loc_pickup_large_platinum",
	name = "large_platinum",
	look_at_tag = "forge_material",
	smart_tag_target_type = "pickup",
	pickup_sound = "wwise/events/player/play_pick_up_forge_material_platinum_large",
	interaction_type = "forge_material",
	group = "forge_material",
	unit_name = "content/pickups/consumables/forge_materials/forge_material_platinum_large_01",
	on_pickup_func = function (pickup_unit, interactor_unit, pickup_data)
		local pickup_system = Managers.state.extension:system("pickup_system")

		pickup_system:register_material_collected(pickup_unit, interactor_unit, "diamantine", "large")
	end
}

return pickup_data
