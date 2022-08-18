require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionAttack = require("scripts/utilities/minion_attack")
local MinionMovement = require("scripts/utilities/minion_movement")
local NavQueries = require("scripts/utilities/nav_queries")
local Vo = require("scripts/utilities/vo")
local BtStepShootAction = class("BtStepShootAction", "BtNode")

BtStepShootAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")
	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")
	scratchpad.perception_component = Blackboard.write_component(blackboard, "perception")

	MinionAttack.init_scratchpad_shooting_variables(unit, scratchpad, action_data, blackboard, breed)

	local broadphase_system = Managers.state.extension:system("broadphase_system")
	scratchpad.broadphase = broadphase_system.broadphase
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[unit]
	local side_name = side:name()
	scratchpad.side_name = side_name
	local can_step = self:_start_stepping(unit, t, scratchpad, action_data, blackboard)
	local vo_event = action_data.vo_event

	if not can_step then
		scratchpad.step_failed = true
	elseif vo_event then
		Vo.enemy_generic_vo_event(unit, vo_event, breed.name)
	end
end

BtStepShootAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	scratchpad.navigation_extension:set_enabled(false)

	if not scratchpad.step_failed and not scratchpad.all_shots_fired then
		MinionAttack.stop_shooting(unit, scratchpad)
	end
end

BtStepShootAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if scratchpad.step_failed then
		return "failed"
	end

	local navigation_extension = scratchpad.navigation_extension

	MinionMovement.apply_animation_wanted_movement_speed(unit, navigation_extension, dt)

	if scratchpad.step_move_timing and scratchpad.step_move_timing <= t then
		if not navigation_extension:is_following_path() then
			return "failed"
		end

		scratchpad.step_move_timing = nil
	end

	if scratchpad.step_anim_finished_timing <= t then
		return "done"
	elseif not scratchpad.all_shots_fired then
		self:_aim_at_target(unit, scratchpad)
		self:_update_shooting(unit, t, scratchpad, action_data)
	end

	return "running"
end

local broadphase_results = {}
local BROADPHASE_SEARCH_RADIUS = 1
local NAV_MESH_ABOVE = 1
local NAV_MESH_BELOW = 1

local function _get_step_position(direction_identifier, unit, scratchpad, action_data, self_position, target_direction, nav_world, traverse_logic)
	local step_anim_distance = action_data.step_anim_distance
	local right = Vector3.cross(target_direction, Vector3.up())
	local direction = direction_identifier == "right" and right or direction_identifier == "left" and -right or target_direction
	local wanted_position = self_position + direction * step_anim_distance
	local wanted_position_on_navmesh = NavQueries.position_on_mesh(nav_world, wanted_position, NAV_MESH_ABOVE, NAV_MESH_BELOW, traverse_logic)

	if not wanted_position_on_navmesh then
		return nil, nil
	end

	local broadphase = scratchpad.broadphase
	local side_name = scratchpad.side_name
	local num_results = broadphase:query(wanted_position_on_navmesh, BROADPHASE_SEARCH_RADIUS, broadphase_results, side_name)

	for i = 1, num_results do
		local hit_unit = broadphase_results[i]

		if hit_unit ~= unit then
			return nil, nil
		end
	end

	local success = GwNavQueries.raycango(nav_world, self_position, wanted_position_on_navmesh, traverse_logic)

	if not success then
		return nil, nil
	end

	local step_anim_events = action_data.step_anim_events

	return wanted_position_on_navmesh, step_anim_events[direction_identifier]
end

BtStepShootAction._start_stepping = function (self, unit, t, scratchpad, action_data, blackboard)
	local navigation_extension = scratchpad.navigation_extension
	local nav_world = navigation_extension:nav_world()
	local traverse_logic = navigation_extension:traverse_logic()
	local target_unit = scratchpad.perception_component.target_unit
	local self_position = POSITION_LOOKUP[unit]
	local target_position = POSITION_LOOKUP[target_unit]
	local to_target_direction = Vector3.normalize(target_position - self_position)
	local try_step_right = math.random() > 0.5
	local wanted_step_position, step_anim_event = nil
	local test_forward_step_first = action_data.test_forward_step_first

	if test_forward_step_first then
		wanted_step_position, step_anim_event = _get_step_position("fwd", unit, scratchpad, action_data, self_position, to_target_direction, nav_world, traverse_logic)
	elseif try_step_right then
		wanted_step_position, step_anim_event = _get_step_position("right", unit, scratchpad, action_data, self_position, to_target_direction, nav_world, traverse_logic)
	else
		wanted_step_position, step_anim_event = _get_step_position("left", unit, scratchpad, action_data, self_position, to_target_direction, nav_world, traverse_logic)
	end

	if not wanted_step_position then
		if test_forward_step_first then
			local direction_identifier = try_step_right and "right" or "left"
			wanted_step_position, step_anim_event = _get_step_position(direction_identifier, unit, scratchpad, action_data, self_position, to_target_direction, nav_world, traverse_logic)

			if not wanted_step_position then
				local reverse_direction_identifer = direction_identifier == "right" and "left" or "right"
				wanted_step_position, step_anim_event = _get_step_position(reverse_direction_identifer, unit, scratchpad, action_data, self_position, to_target_direction, nav_world, traverse_logic)
			end
		else
			local reverse_direction_identifer = try_step_right and "left" or "right"
			wanted_step_position, step_anim_event = _get_step_position(reverse_direction_identifer, unit, scratchpad, action_data, self_position, to_target_direction, nav_world, traverse_logic)

			if not wanted_step_position then
				wanted_step_position, step_anim_event = _get_step_position("fwd", unit, scratchpad, action_data, self_position, to_target_direction, nav_world, traverse_logic)
			end
		end
	end

	if not wanted_step_position then
		return false
	end

	navigation_extension:set_enabled(true, action_data.step_speed)
	navigation_extension:stop()
	navigation_extension:move_to(wanted_step_position)
	scratchpad.animation_extension:anim_event(step_anim_event)

	scratchpad.current_aim_anim_event = step_anim_event
	scratchpad.behavior_component.move_state = "attacking"
	local step_anim_finished_timing = action_data.step_anim_durations[step_anim_event]
	scratchpad.step_anim_finished_timing = t + step_anim_finished_timing
	local step_move_timing = action_data.step_move_timing[step_anim_event]

	fassert(step_move_timing > 0, "[BtStepShootAction] Need step_move_timing to be > 0 in order to ensure we at least have one frame to update navigation (and thus be able to detect if pathfind to new destination failed).")

	scratchpad.step_move_timing = t + step_move_timing
	local shoot_timing = action_data.shoot_timing[step_anim_event]

	MinionAttack.start_shooting(unit, scratchpad, t, action_data, shoot_timing)

	return true
end

BtStepShootAction._update_shooting = function (self, unit, t, scratchpad, action_data)
	local _, fired_last_shot = MinionAttack.update_shooting(unit, scratchpad, t, action_data)

	if fired_last_shot then
		scratchpad.all_shots_fired = true
	end
end

BtStepShootAction._aim_at_target = function (self, unit, scratchpad)
	local perception_component = scratchpad.perception_component

	if not perception_component.has_line_of_sight then
		return
	end

	local target_unit = perception_component.target_unit
	local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)
	local locomotion_extension = scratchpad.locomotion_extension

	locomotion_extension:set_wanted_rotation(flat_rotation)

	local perception_extension = scratchpad.perception_extension
	local last_los_position = perception_extension:last_los_position(target_unit)

	if last_los_position then
		local target_position = last_los_position

		scratchpad.current_aim_position:store(target_position)
	end
end

return BtStepShootAction
