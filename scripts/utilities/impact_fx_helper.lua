-- chunkname: @scripts/utilities/impact_fx_helper.lua

local MaterialQuerySettings = require("scripts/settings/material_query_settings")
local SurfaceMaterialSettings = require("scripts/settings/surface_material_settings")
local hit_types = SurfaceMaterialSettings.hit_types
local surface_materials = MaterialQuerySettings.surface_materials
local ImpactFxHelper = {}
local default_surface_decal = {
	Vector3(0.2, 0.2, 0.2),
	Vector3(0.2, 0.2, 0.2),
	{
		"content/fx/units/weapons/small_caliber_concrete_small_01",
		"content/fx/units/weapons/small_caliber_concrete_medium_01",
		"content/fx/units/weapons/small_caliber_concrete_large_01",
	},
}

local function _create_surface_decal(destination, ignore_decals, surface_material, hit_type, min_extents, max_extents, decal_units)
	if not destination[surface_material] then
		destination[surface_material] = {}
	end

	if not destination[surface_material][hit_type] then
		destination[surface_material][hit_type] = {
			extents = {
				min = {
					x = min_extents.x,
					y = min_extents.y,
				},
				max = {
					x = max_extents.x,
					y = max_extents.y,
				},
			},
			units = {},
		}

		if not ignore_decals then
			for i = 1, #decal_units do
				destination[surface_material][hit_type].units[i] = decal_units[i]
			end
		end
	end
end

local function _create_surface_fx(destination, surface_material, hit_type, default_surface_fx)
	local has_material_defined = destination[surface_material] ~= nil

	if not has_material_defined then
		destination[surface_material] = table.clone(default_surface_fx)
	else
		local wants_hit_type = default_surface_fx[hit_type] ~= nil
		local has_hit_type_defined = destination[surface_material][hit_type] ~= nil

		if wants_hit_type and not has_hit_type_defined then
			destination[surface_material][hit_type] = table.clone(default_surface_fx[hit_type])
		end
	end
end

ImpactFxHelper.create_missing_surface_decals = function (surface_decals)
	for ii = 1, #surface_materials do
		local surface_material = surface_materials[ii]
		local ignore_decals = surface_decals[surface_material] == false

		for hit_type, _ in pairs(hit_types) do
			_create_surface_decal(surface_decals, ignore_decals, surface_material, hit_type, unpack(default_surface_decal))
		end
	end
end

ImpactFxHelper.create_missing_surface_fx = function (surface_fx, default_surface_fx)
	for ii = 1, #surface_materials do
		local surface_material = surface_materials[ii]

		for hit_type, _ in pairs(hit_types) do
			_create_surface_fx(surface_fx, surface_material, hit_type, default_surface_fx)
		end
	end
end

return ImpactFxHelper
