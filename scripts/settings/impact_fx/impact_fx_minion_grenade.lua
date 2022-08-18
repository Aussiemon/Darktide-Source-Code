local ArmorSettings = require("scripts/settings/damage/armor_settings")
local SurfaceMaterialSettings = require("scripts/settings/surface_material_settings")
local ImpactFxHelper = require("scripts/utilities/impact_fx_helper")
local armor_types = ArmorSettings.types
local hit_types = SurfaceMaterialSettings.hit_types
local default_surface_fx = {
	sfx = {
		{
			group = "surface_material",
			append_husk_to_event_name = false,
			event = "wwise/events/weapon/play_minion_grenadier_fire_grenade_ground_impact",
			normal_rotation = true
		}
	}
}

return {
	surface = {
		[hit_types.stop] = default_surface_fx,
		[hit_types.penetration_entry] = nil,
		[hit_types.penetration_exit] = nil
	}
}
