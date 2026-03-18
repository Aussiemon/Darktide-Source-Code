-- chunkname: @scripts/settings/pickup/pickups/consumable/debug_expedition_pickup_full_heal.lua

local DamageSettings = require("scripts/settings/damage/damage_settings")
local Health = require("scripts/utilities/health")
local pickup_data = {
	description = "loc_expeditions_pickup_debug_half_health",
	group = "forge_material",
	interaction_type = "forge_material",
	name = "debug_expedition_pickup_full_heal",
	pickup_sound = "wwise/events/player/play_pick_up_forge_material_small",
	smart_tag_target_type = "pickup",
	unit_name = "content/pickups/pocketables/medical_crate/deployable_medical_crate",
	on_pickup_func = function (pickup_unit, interactor_unit, pickup_data)
		local health_extension = ScriptUnit.extension(interactor_unit, "health_system")
		local half_health = health_extension:max_health() * 0.5

		Health.add(interactor_unit, half_health, DamageSettings.heal_types.syringe)
		Health.add(interactor_unit, half_health, DamageSettings.heal_types.buff_corruption_healing)
	end,
}

return pickup_data
