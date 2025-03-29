-- chunkname: @scripts/extension_systems/perception/target_selection_templates/chaos_mutator_ritualist_target_selection_template.lua

local BOLSTERING_RADIUS = 8
local target_selection_template = {}
local RESULTS = {}

target_selection_template.chaos_mutator_ritualist = function (unit, side, perception_component, buff_extension, breed, target_units, line_of_sight_lookup, t, threat_units, force_new_target_attempt, force_new_target_attempt_config_or_nil, debug_target_weighting_or_nil)
	local best_target_unit, closest_distance_sq, closest_z_distance = nil, math.huge, math.huge
	local target_side_names = side:relation_side_names("allied")

	table.clear(RESULTS)

	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local position = POSITION_LOOKUP[unit]
	local num_results = broadphase.query(broadphase, position, BOLSTERING_RADIUS, RESULTS, target_side_names)

	for i = 1, num_results do
		local nearby_ally = RESULTS[i]
		local unit_data = ScriptUnit.extension(nearby_ally, "unit_data_system")
		local breed_name = unit_data:breed().name

		if breed_name == "chaos_mutator_daemonhost" then
			best_target_unit = nearby_ally
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
