-- chunkname: @scripts/extension_systems/perception/target_selection_templates/cultist_ritualist_target_selection_template.lua

local target_selection_template = {}
local _sorted_shields = {}

target_selection_template.cultist_ritualist = function (unit, side, perception_component, buff_extension, breed, target_units, line_of_sight_lookup, t, threat_units, force_new_target_attempt, force_new_target_attempt_config_or_nil, debug_target_weighting_or_nil)
	table.clear(_sorted_shields)

	local position = POSITION_LOOKUP[unit]
	local best_target_unit, closest_distance_sq, closest_z_distance = nil, math.huge, math.huge
	local vector3_distance_squared = Vector3.distance_squared
	local component_system = Managers.state.extension:system("component_system")
	local shield_units = component_system:get_units_from_component_name("RitualShield")

	table.sort(shield_units, function (a, b)
		local local_scale_a = Unit.local_scale(a, 1)
		local _, half_extents_a = Unit.box(a)
		local local_scale_b = Unit.local_scale(b, 1)
		local _, half_extents_b = Unit.box(b)
		local radius_a = math.max(half_extents_a.x, half_extents_a.y) * math.max(local_scale_a.x, local_scale_a.y)
		local radius_b = math.max(half_extents_b.x, half_extents_b.y) * math.max(local_scale_b.x, local_scale_b.y)

		return radius_a < radius_b
	end)

	for ii = 1, #shield_units do
		local shield_unit = shield_units[ii]
		local local_scale = Unit.local_scale(shield_unit, 1)
		local pose, half_extents = Unit.box(shield_unit)
		local target_position = Matrix4x4.translation(pose)
		local distance_sq = vector3_distance_squared(Vector3.flat(position), Vector3.flat(target_position))
		local radius_sq = math.pow(math.max(half_extents.x, half_extents.y) * math.max(local_scale.x, local_scale.y), 2)

		if radius_sq < distance_sq or ii == #shield_units and not best_target_unit and Unit.alive(best_target_unit) then
			best_target_unit = shield_unit
			closest_distance_sq = distance_sq
			closest_z_distance = math.abs(position.z - target_position.z)
		end
	end

	if best_target_unit then
		perception_component.has_line_of_sight = true
		perception_component.target_distance = math.sqrt(closest_distance_sq)
		perception_component.target_distance_z = closest_z_distance
		perception_component.target_speed_away = 0
	end

	return best_target_unit
end

return target_selection_template
