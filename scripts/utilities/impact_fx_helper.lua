local SurfaceMaterialSettings = require("scripts/settings/surface_material_settings")
local hit_types = SurfaceMaterialSettings.hit_types
local surface_types = SurfaceMaterialSettings.surface_types
local ImpactFxHelper = {}
local default_surface_decal = {
	Vector3(0.2, 0.2, 0.2),
	Vector3(0.2, 0.2, 0.2),
	{
		"content/fx/units/weapons/small_caliber_concrete_small_01",
		"content/fx/units/weapons/small_caliber_concrete_medium_01",
		"content/fx/units/weapons/small_caliber_concrete_large_01"
	}
}

local function _create_surface_decal(surface_decals, surface_type, hit_type, min_extents, max_extents, decal_units)
	if not surface_decals[surface_type] then
		surface_decals[surface_type] = {}
	end

	if not surface_decals[surface_type][hit_type] then
		surface_decals[surface_type][hit_type] = {
			extents = {
				min = {
					x = min_extents.x,
					y = min_extents.y,
					z = min_extents.z
				},
				max = {
					x = max_extents.x,
					y = max_extents.y,
					z = max_extents.z
				}
			},
			units = {}
		}

		for i = 1, #decal_units, 1 do
			surface_decals[surface_type][hit_type].units[i] = decal_units[i]
		end
	end
end

ImpactFxHelper.create_missing_surface_decals = function (surface_decals)
	for surface_type, _ in pairs(surface_types) do
		_create_surface_decal(surface_decals, surface_type, hit_types.stop, unpack(default_surface_decal))
		_create_surface_decal(surface_decals, surface_type, hit_types.penetration_entry, unpack(default_surface_decal))
		_create_surface_decal(surface_decals, surface_type, hit_types.penetration_exit, unpack(default_surface_decal))
	end
end

return ImpactFxHelper
