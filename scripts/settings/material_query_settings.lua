-- chunkname: @scripts/settings/material_query_settings.lua

local material_query_settings = {}
local surface_materials = {
	"brick",
	"cloth",
	"concrete",
	"dirt_gravel",
	"dirt_mud",
	"dirt_sand",
	"dirt_soil",
	"dirt_trash",
	"dead_body",
	"nurgle_flesh",
	"glass_breakable",
	"glass_unbreakable",
	"ice_solid",
	"snow",
	"snow_frosty",
	"metal_catwalk",
	"metal_sheet",
	"metal_solid",
	"psychic_shield",
	"vegetation",
	"water_deep",
	"water_puddle",
	"wood_plywood",
	"wood_solid",
}
local surface_materials_lookup = {}
local Unit_material_id = Unit.material_id

for ii = 1, #surface_materials do
	local material_name = surface_materials[ii]
	local material_id = Unit_material_id(material_name)

	surface_materials_lookup[material_id] = material_name
end

local surface_material_groups = {
	default = {
		"cloth",
		"concrete",
		"ice_solid",
		"psychic_shield",
	},
	dirt = {
		"dirt_sand",
		"dirt_mud",
		"dirt_gravel",
		"dirt_soil",
		"dirt_trash",
		"vegetation",
	},
	flesh = {
		"dead_body",
		"nurgle_flesh",
	},
	glass = {
		"glass_breakable",
		"glass_unbreakable",
	},
	metal = {
		"metal_solid",
		"metal_sheet",
		"metal_catwalk",
	},
	water = {
		"water_deep",
		"water_puddle",
	},
	wood = {
		"wood_solid",
		"wood_plywood",
	},
}
local surface_material_groups_lookup = {}

for surface_material_group, materials in pairs(surface_material_groups) do
	for _, material in pairs(materials) do
		surface_material_groups_lookup[material] = surface_material_group
	end
end

material_query_settings.surface_materials = surface_materials
material_query_settings.surface_materials_lookup = surface_materials_lookup
material_query_settings.surface_material_groups = surface_material_groups
material_query_settings.surface_material_groups_lookup = surface_material_groups_lookup

return settings("MaterialQuerySettings", material_query_settings)
