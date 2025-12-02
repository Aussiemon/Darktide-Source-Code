-- chunkname: @scripts/utilities/scanning.lua

local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local Scanning = {}

Scanning.get_scannable_units_position = function (scannable_unit, scannable_extension)
	scannable_extension = scannable_extension or ScriptUnit.has_extension(scannable_unit, "mission_objective_zone_scannable_system")

	return scannable_extension and scannable_extension:center_poisition() or POSITION_LOOKUP[scannable_unit]
end

Scanning.calculate_score = function (scannable_unit, first_person_component, scan_settings, scannable_extension)
	local rotation = first_person_component.rotation
	local player_forward = rotation and Quaternion.forward(rotation)
	local player_position = first_person_component.position
	local scannable_unit_position = Scanning.get_scannable_units_position(scannable_unit, scannable_extension)
	local from_player = scannable_unit_position - player_position
	local distance = Vector3.length(from_player)
	local near_distance = scan_settings.distance.near
	local far_distance = scan_settings.distance.far
	local distance_score = math.ilerp(far_distance, 0, distance)
	local inner_near_angle = scan_settings.angle.inner.near
	local inner_far_angle = scan_settings.angle.inner.far
	local inner_angle = math.lerp(inner_far_angle, inner_near_angle, distance_score)
	local outer_angle = scan_settings.angle.outer
	local angle = Vector3.angle(from_player, player_forward, true)
	local angle_score = math.ilerp(outer_angle, inner_angle, angle)
	local angle_distribution = scan_settings.score_distribution.angle
	local distance_distribution = scan_settings.score_distribution.distance
	local total_score = angle_distribution * angle_score + distance_distribution * distance_score

	return total_score, angle_score, distance_score, angle, distance
end

local INDEX_DISTANCE = 2
local INDEX_ACTOR = 4
local INTERACTABLE_FILTER = "filter_interactable_overlap"
local LINE_OF_SIGHT_FILTER = "filter_interactable_line_of_sight_check"

Scanning.check_direct_line_of_sight = function (physics_world, first_person_component, scan_distance)
	local rotation = first_person_component.rotation
	local look_forward = rotation and Quaternion.forward(rotation)
	local look_pos = first_person_component.position
	local los_hit, _, los_dist, _ = PhysicsWorld.raycast(physics_world, look_pos, look_forward, scan_distance, "closest", "collision_filter", LINE_OF_SIGHT_FILTER)
	local hits, _ = PhysicsWorld.raycast(physics_world, look_pos, look_forward, scan_distance, "all", "collision_filter", INTERACTABLE_FILTER)

	if hits then
		for i = 1, #hits do
			local hit = hits[i]
			local hit_distance = hit[INDEX_DISTANCE]
			local hit_actor = hit[INDEX_ACTOR]
			local target_unit = hit_actor and Actor.unit(hit_actor)
			local los_is_blocked = los_hit and los_dist < hit_distance

			if target_unit and not los_is_blocked then
				local scannable_extension = ALIVE[target_unit] and ScriptUnit.has_extension(target_unit, "mission_objective_zone_scannable_system")
				local is_active = scannable_extension and scannable_extension:is_active()

				if is_active then
					return target_unit
				end
			end
		end
	end

	return nil
end

Scanning.check_line_of_sight_to_unit = function (physics_world, first_person_component, scannable_unit, scan_settings, scannable_extension)
	local look_pos = first_person_component.position
	local rotation = first_person_component.rotation
	local look_forward = rotation and Quaternion.forward(rotation)
	local look_right = rotation and Quaternion.right(rotation)
	local scannable_unit_position = Scanning.get_scannable_units_position(scannable_unit, scannable_extension)
	local to_scannable_unit = scannable_unit_position - look_pos
	local to_scan_direction = Vector3.normalize(to_scannable_unit)
	local check_angle_horizontal = scan_settings.angle.line_of_sight_check.horizontal
	local check_angle_vertical = scan_settings.angle.line_of_sight_check.vertical
	local to_scan_horizontal = Vector3.normalize(Vector3.flat(to_scannable_unit))
	local look_forward_horizontal = Vector3.normalize(Vector3.flat(look_forward))
	local angle_horizontal = Vector3.angle(to_scan_horizontal, look_forward_horizontal)
	local to_scan_vertical = Vector3.normalize(Vector3.project_on_plane(to_scan_direction, look_right))
	local look_forward_vertical = Vector3.normalize(Vector3.project_on_plane(look_forward, look_right))
	local angle_vertical = Vector3.angle(to_scan_vertical, look_forward_vertical)

	if check_angle_horizontal < angle_horizontal or check_angle_vertical < angle_vertical then
		return false
	end

	local scan_distance = scan_settings.distance.near
	local los_hit, _, los_dist, _ = PhysicsWorld.raycast(physics_world, look_pos, to_scan_direction, scan_distance, "closest", "collision_filter", LINE_OF_SIGHT_FILTER)
	local hits, _ = PhysicsWorld.raycast(physics_world, look_pos, to_scan_direction, scan_distance, "all", "collision_filter", INTERACTABLE_FILTER)

	if hits then
		for i = 1, #hits do
			local hit = hits[i]
			local hit_distance = hit[INDEX_DISTANCE]
			local hit_actor = hit[INDEX_ACTOR]
			local target_unit = hit_actor and Actor.unit(hit_actor)
			local los_is_blocked = los_hit and los_dist < hit_distance

			if target_unit == scannable_unit and not los_is_blocked then
				return true
			end
		end
	end

	return false
end

Scanning.find_scannable_unit = function (physics_world, first_person_component, scan_settings)
	local scannable_units = Managers.state.extension:system("mission_objective_zone_system"):scannable_units()
	local line_of_sight_unit = Scanning.check_direct_line_of_sight(physics_world, first_person_component, scan_settings.distance.near)

	if line_of_sight_unit then
		return line_of_sight_unit, true
	end

	local best_score = -math.huge
	local best_unit, best_scan_exension

	for i = 1, #scannable_units do
		local scannable_unit = scannable_units[i]
		local scannable_extension = ScriptUnit.has_extension(scannable_unit, "mission_objective_zone_scannable_system")
		local is_active = scannable_extension:is_active()

		if is_active then
			local total_score = Scanning.calculate_score(scannable_unit, first_person_component, scan_settings, scannable_extension)

			if best_score < total_score then
				best_score = total_score
				best_unit = scannable_unit
				best_scan_exension = scannable_extension
			end
		end
	end

	local line_of_sight = best_unit ~= nil and Scanning.check_line_of_sight_to_unit(physics_world, first_person_component, best_unit, scan_settings, best_scan_exension)

	return best_unit, line_of_sight
end

Scanning.calculate_current_scores = function (scanning_compomnent, weapon_action_component, first_person_component)
	local total_score, angle_score, distance_score, angle, distance = 0, 0, 0, math.huge, math.huge
	local is_active = scanning_compomnent.is_active
	local line_of_sight = scanning_compomnent.line_of_sight
	local scannable_unit = scanning_compomnent.scannable_unit
	local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
	local current_action_name = weapon_action_component.current_action_name
	local weapon_actions = weapon_template and weapon_template.actions
	local action_settings = current_action_name and weapon_actions and weapon_actions[current_action_name]
	local scan_settings = action_settings and action_settings.scan_settings

	if is_active and line_of_sight then
		total_score, angle_score, distance_score, angle, distance = 1, 1, 1, 0, 0
	elseif scan_settings and scannable_unit then
		total_score, angle_score, distance_score, angle, distance = Scanning.calculate_score(scannable_unit, first_person_component, scan_settings)
	end

	return is_active, line_of_sight, total_score, angle_score, distance_score, scannable_unit, angle, distance
end

Scanning.scan_confirm_progression = function (scanning_compomnent, weapon_action_component, t)
	local scanning_unit = scanning_compomnent.scannable_unit
	local line_of_sight = scanning_compomnent.line_of_sight
	local has_valid_target = scanning_unit and line_of_sight
	local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)

	if not weapon_template then
		return nil
	end

	local current_action_name = weapon_action_component.current_action_name
	local weapon_actions = weapon_template.actions
	local action_settings = current_action_name and weapon_actions[current_action_name]
	local scan_settings = action_settings and action_settings.scan_settings

	if scan_settings and action_settings.kind == "scan_confirm" then
		local start_time = weapon_action_component.start_t
		local time_in_action = t - start_time
		local confirm_time = has_valid_target and scan_settings.confirm_time or scan_settings.fail_time_time
		local progress = math.clamp01(time_in_action / confirm_time)

		return progress
	end

	return nil
end

Scanning.calculate_color_lerp = function (lerp_value)
	return math.ilerp(0.25, 1, lerp_value)
end

Scanning.has_active_scanning_zone = function ()
	local mission_objective_zone_system = Managers.state.extension:system("mission_objective_zone_system")

	return mission_objective_zone_system:any_active_scanning_zone()
end

return Scanning
