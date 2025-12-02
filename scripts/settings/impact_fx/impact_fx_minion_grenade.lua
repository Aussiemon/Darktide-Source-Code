-- chunkname: @scripts/settings/impact_fx/impact_fx_minion_grenade.lua

local ImpactFxHelper = require("scripts/utilities/impact_fx_helper")
local SurfaceMaterialSettings = require("scripts/settings/surface_material_settings")
local NO_SURFACE_DECAL = false
local hit_types = SurfaceMaterialSettings.hit_types
local surface_fx = {}
local default_surface_fx = {
	[hit_types.stop] = {
		vfx = nil,
		sfx = {
			{
				append_husk_to_event_name = false,
				event = "wwise/events/weapon/play_minion_grenadier_fire_grenade_ground_impact",
				group = "surface_material",
				normal_rotation = true,
			},
		},
	},
	[hit_types.penetration_entry] = nil,
	[hit_types.penetration_exit] = nil,
}

ImpactFxHelper.create_missing_surface_fx(surface_fx, default_surface_fx)

return {
	armor = nil,
	surface_decal = nil,
	surface_overrides = nil,
	surface = surface_fx,
}
