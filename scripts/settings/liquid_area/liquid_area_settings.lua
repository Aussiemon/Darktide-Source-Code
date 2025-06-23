-- chunkname: @scripts/settings/liquid_area/liquid_area_settings.lua

local liquid_area_settings = {
	nav_mesh_below = 2,
	distance_from_nav_mesh = 0.1,
	nav_mesh_lateral = 2,
	nav_mesh_above = 2
}

return settings("LiquidAreaSettings", liquid_area_settings)
