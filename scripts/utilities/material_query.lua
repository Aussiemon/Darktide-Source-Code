local MaterialQuerySettings = require("scripts/settings/material_query_settings")
local surface_materials_lookup = MaterialQuerySettings.surface_materials_lookup
local MaterialQuery = {}
local QUERY_DISTANCE = 0.6
local HALF_QUERY_DISTANCE = QUERY_DISTANCE * 0.5
local QUERY_MATERIAL_CONTEXTS = {
	"surface_material"
}

MaterialQuery.query_material = function (physics_world, from, to, debug_name)
	local ray_vector = to - from
	local range = Vector3.length(ray_vector)
	local direction = ray_vector / range
	local hit, position, _, normal, hit_actor = PhysicsWorld.raycast(physics_world, from, direction, range, "closest", "types", "both", "collision_filter", "filter_ground_material_check")
	local hit_unit = hit and Actor.unit(hit_actor)

	if hit_unit then
		local material, material_id = MaterialQuery.query_unit_material(hit_unit, position, -normal)

		return true, material, position, normal, hit_unit, hit_actor
	else
		return false
	end
end

local _query_material_buffer = {}

MaterialQuery.query_unit_material = function (hit_unit, query_position, query_direction)
	local query_offset = query_direction * HALF_QUERY_DISTANCE
	local query_start = query_position - query_offset
	local query_end = query_position + query_offset
	local material_ids = Unit.query_material(hit_unit, query_start, query_end, QUERY_MATERIAL_CONTEXTS, _query_material_buffer)
	local material_id = material_ids[1]

	if material_id then
		local material = surface_materials_lookup[material_id]

		return material, material_id
	end

	return nil, nil
end

return MaterialQuery
