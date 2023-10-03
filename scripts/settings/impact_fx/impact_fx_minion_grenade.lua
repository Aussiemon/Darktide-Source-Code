local SurfaceMaterialSettings = require("scripts/settings/surface_material_settings")
local ImpactFxHelper = require("scripts/utilities/impact_fx_helper")
local hit_types = SurfaceMaterialSettings.hit_types
local surface_fx = {}
local default_surface_fx = {
	[hit_types.stop] = {
		sfx = {
			{
				group = "surface_material",
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_minion_grenadier_fire_grenade_ground_impact",
				normal_rotation = true
			}
		}
	},
	[hit_types.penetration_entry] = nil,
	[hit_types.penetration_exit] = nil
}

ImpactFxHelper.create_missing_surface_fx(surface_fx, default_surface_fx)

return {
	surface = surface_fx
}
