-- chunkname: @scripts/settings/pickup/pickups/consumable/small_platinum_pickup.lua

local pickup_data = {
	description = "loc_pickup_small_platinum",
	unit_name = "content/pickups/consumables/forge_materials/forge_material_platinum_small_01",
	smart_tag_target_type = "pickup",
	group = "forge_material",
	interaction_type = "forge_material",
	pickup_sound = "wwise/events/player/play_pick_up_forge_material_platinum_small",
	name = "small_platinum",
	on_pickup_func = function (pickup_unit, interactor_unit, pickup_data)
		local pickup_system = Managers.state.extension:system("pickup_system")

		pickup_system:register_material_collected(pickup_unit, interactor_unit, "diamantine", "small")
	end
}

return pickup_data
