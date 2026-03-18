-- chunkname: @scripts/settings/pickup/pickups/consumable/debug_expedition_pickup_full_ammo.lua

local Ammo = require("scripts/utilities/ammo")
local pickup_data = {
	description = "loc_pickup_small_metal",
	group = "forge_material",
	interaction_type = "forge_material",
	name = "debug_expedition_pickup_full_ammo",
	pickup_sound = "wwise/events/player/play_pick_up_forge_material_small",
	smart_tag_target_type = "pickup",
	unit_name = "content/pickups/pocketables/ammo_crate/deployable_ammo_crate",
	on_pickup_func = function (pickup_unit, interactor_unit, pickup_data)
		local unit_data_extension = ScriptUnit.extension(interactor_unit, "unit_data_system")
		local visual_loadout_extension = ScriptUnit.extension(interactor_unit, "visual_loadout_system")
		local weapon_slot_configuration = visual_loadout_extension:slot_configuration_by_type("weapon")

		for slot_name, config in pairs(weapon_slot_configuration) do
			local inventory_slot_component = unit_data_extension:write_component(slot_name)
			local max_ammunition_reserve = inventory_slot_component.max_ammunition_reserve
			local max_ammunition_clip = Ammo.max_ammo_in_clips(inventory_slot_component)
			local current_ammunition_clip = Ammo.current_ammo_in_clips(inventory_slot_component)
			local new_ammo = max_ammunition_reserve + max_ammunition_clip - current_ammunition_clip

			inventory_slot_component.current_ammunition_reserve = new_ammo
		end
	end,
}

return pickup_data
