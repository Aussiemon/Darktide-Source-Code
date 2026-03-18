-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_nurgle_flies_chase_target_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local NavQueries = require("scripts/utilities/nav_queries")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local BtConditions = require("scripts/extension_systems/behavior/utilities/bt_conditions")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")

local function _get_position_on_navmesh(nav_world, target_position)
	return NavQueries.position_on_mesh_with_outside_position(nav_world, nil, target_position, 2, 1, 1)
end

local PADDING = 0.1

local function _raycast(physics_world, from, to, collision_filter)
	local to_target = to - from
	local direction, distance = Vector3.normalize(to_target), Vector3.length(to_target) - PADDING

	return PhysicsWorld.raycast(physics_world, from, direction, distance, "closest", "collision_filter", collision_filter or "filter_player_mover")
end

local function _update_direct_distance_to_target(unit, scratchpad)
	local target_unit = scratchpad.chase_target_component.target_unit

	if not target_unit or not HEALTH_ALIVE[target_unit] then
		scratchpad.direct_distance_to_target = false

		return
	end

	local nurgle_flies_ext = scratchpad.nurgle_flies_ext
	local vfx_pos = nurgle_flies_ext:vfx_pos():unbox()
	local vfx_ground_offset = scratchpad.chase_target_template.vfx_ground_offset
	local offset = Vector3(0, 0, vfx_ground_offset)
	local to_target = POSITION_LOOKUP[target_unit] - (vfx_pos + offset)

	scratchpad.direct_distance_to_target = Vector3.length(to_target)
end

local path = {}

local function _find_trajectory(world, nav_world, unit_pos, destinations, collision_filter)
	table.clear(path)

	local offset = Vector3.zero()
	local physics_world = World.physics_world(world)

	for i = 1, #destinations do
		local to = destinations[i]

		for height_offset = 0, 5 do
			offset.z = height_offset

			local is_offset = height_offset > 0
			local from = unit_pos + offset
			local hit

			if is_offset then
				hit = _raycast(physics_world, unit_pos, from)
			end

			hit = hit or _raycast(physics_world, from, to)

			if hit then
				local forward = Vector3.normalize(to - from)

				forward.z = 0

				local offset_position = from + forward

				if not _raycast(physics_world, from, offset_position) then
					hit = _raycast(physics_world, offset_position, to)
					from = offset_position
					is_offset = true
				end
			end

			if not hit then
				return from, to, is_offset
			end
		end
	end

	return false
end

local THRESHOLD_MULTIPLIER = 2

local function _is_conditions_for_flying_met(navigation_ext, target_pos, unit_pos)
	if not navigation_ext:is_following_path() then
		return false
	end

	local nav_path_dist = navigation_ext:remaining_distance_from_progress_to_end_of_path()
	local direct_dist_sq = Vector3.distance_squared(unit_pos, target_pos)

	return nav_path_dist^2 > direct_dist_sq * THRESHOLD_MULTIPLIER
end

local BTNurgleFliesChaseTargetAction = class("BTNurgleFliesChaseTargetAction", "BtNode")

BTNurgleFliesChaseTargetAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local chase_target_component = Blackboard.write_component(blackboard, "chase_target")

	scratchpad.chase_target_component = chase_target_component
	chase_target_component.wander_state = "recalc_path"
	chase_target_component.num_players_inside = 0
	chase_target_component.idle_time = 0
	chase_target_component.wander_time = 0
	chase_target_component.new_target_time = 0
	chase_target_component.target_unit = nil

	local chase_target_template = breed.chase_target_template
	local new_target_wait_time = chase_target_template and chase_target_template.new_target_wait_time or 10

	scratchpad.chase_target_template = chase_target_template
	scratchpad.new_target_wait_time = new_target_wait_time
	scratchpad.chase_target_template = chase_target_template
	scratchpad.start_t = t
	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")

	local navigation_ext = ScriptUnit.extension(unit, "navigation_system")
	local nurgle_flies_ext = ScriptUnit.extension(unit, "minion_nurgle_flies_system")

	scratchpad.nurgle_flies_ext = nurgle_flies_ext
	scratchpad.navigation_ext = navigation_ext

	local nav_world = navigation_ext:nav_world()

	scratchpad.nav_world = nav_world

	local speed = breed.run_speed

	navigation_ext:set_enabled(true, speed)

	if not chase_target_component.target_unit then
		local target_unit = self:_get_randomize_new_target_unit(unit, scratchpad, t)

		if target_unit then
			chase_target_component.target_unit = target_unit
			chase_target_component.new_target_time = t + scratchpad.new_target_wait_time
		end
	end
end

BTNurgleFliesChaseTargetAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	scratchpad.new_target_wait_time = nil
	scratchpad.chase_target_template = nil
end

BTNurgleFliesChaseTargetAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if scratchpad.about_to_despawn then
		return "running"
	end

	local nurgle_flies_ext = scratchpad.nurgle_flies_ext

	scratchpad.about_to_despawn = nurgle_flies_ext:about_to_despawn(t)

	_update_direct_distance_to_target(unit, scratchpad)
	self:_wander_around(unit, t, dt, blackboard, scratchpad, action_data)

	return "running"
end

BTNurgleFliesChaseTargetAction._need_to_teleport = function (self, unit, blackboard, scratchpad, condition_args, action_data, is_running)
	local condition = BtConditions.at_teleport_smart_object

	return condition(unit, blackboard, scratchpad, condition_args, action_data, is_running)
end

local traversal_condition = {
	"at_jump_smart_object",
	"at_climb_smart_object",
}

BTNurgleFliesChaseTargetAction._need_to_traverse = function (self, unit, blackboard, scratchpad, condition_args, action_data, is_running)
	for i = 1, #traversal_condition do
		local condition_name = traversal_condition[i]
		local condition = BtConditions[condition_name]

		if condition(unit, blackboard, scratchpad, condition_args, action_data, is_running) then
			return true
		end
	end
end

local DESTINATION_POSITIONS = {}

BTNurgleFliesChaseTargetAction._try_to_fly = function (self, unit, t, dt, blackboard, scratchpad, action_data)
	local chase_target_component = scratchpad.chase_target_component
	local target_unit = chase_target_component.target_unit

	if not target_unit or not ALIVE[target_unit] then
		return false
	end

	local navigation_ext = scratchpad.navigation_ext
	local unit_position = Unit.local_position(unit, 1)
	local target_unit_position = Unit.world_position(target_unit, 1)
	local need_to_traverse = self:_need_to_traverse(unit, blackboard, scratchpad, nil, action_data, true)
	local flying_ok = _is_conditions_for_flying_met(navigation_ext, target_unit_position, unit_position)

	if not flying_ok and not need_to_traverse then
		return false
	end

	table.clear(DESTINATION_POSITIONS)

	DESTINATION_POSITIONS[#DESTINATION_POSITIONS + 1] = target_unit_position
	DESTINATION_POSITIONS[#DESTINATION_POSITIONS + 1] = need_to_traverse and blackboard.nav_smart_object.exit_position:unbox() or nil

	local start_position, end_position
	local successful, has_direct_path = false, false
	local ray_start, destination, is_offset = _find_trajectory(Unit.world(unit), scratchpad.nav_world, unit_position, DESTINATION_POSITIONS)

	if ray_start then
		local pos_on_nav_mesh = _get_position_on_navmesh(scratchpad.nav_world, destination)

		if pos_on_nav_mesh then
			successful = true
			start_position = unit_position
			end_position = is_offset and ray_start or destination
			has_direct_path = true
			scratchpad.cached_end_position = is_offset and Vector3Box(target_unit_position) or nil
		end
	end

	if successful then
		chase_target_component.wander_state = "flying"

		navigation_ext:stop()

		scratchpad.flight_update_time = nil
		scratchpad.flight_velocity = nil
		scratchpad.flight_start_position = Vector3Box(start_position)
		scratchpad.flight_end_position = Vector3Box(end_position)
		scratchpad.has_direct_flight_path = has_direct_path

		local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

		locomotion_extension:set_gravity(0)
		navigation_ext:set_enabled(false)
		locomotion_extension:set_wanted_rotation(nil)
		locomotion_extension:set_movement_type("script_driven")

		return true
	end
end

BTNurgleFliesChaseTargetAction._wander_around = function (self, unit, t, dt, blackboard, scratchpad, action_data)
	local behavior_component = scratchpad.behavior_component
	local chase_target_component = scratchpad.chase_target_component
	local chase_target_template = scratchpad.chase_target_template
	local wander_state = chase_target_component.wander_state
	local num_players_inside = chase_target_component.num_players_inside
	local navigation_ext = scratchpad.navigation_ext
	local is_following_path = navigation_ext:is_following_path()

	behavior_component.move_state = (is_following_path or wander_state == "flying") and "moving" or "idle"

	local stop_and_process_player = chase_target_template and chase_target_template.stop_and_process_player

	if stop_and_process_player and num_players_inside > 0 and wander_state ~= "walking" then
		chase_target_component.wander_state = "recalc_path"
		chase_target_component.target_unit = nil

		navigation_ext:stop()
	elseif num_players_inside == 0 and chase_target_component.wander_state == "standing_still" then
		chase_target_component.wander_state = "recalc_path"
	end

	if self:_in_range_of_target(scratchpad, unit) then
		self:_resolve_hit(unit, scratchpad, navigation_ext, t)
	elseif wander_state == "flying" then
		self:_update_flying(unit, blackboard, scratchpad, navigation_ext, action_data, t, dt)
	elseif wander_state == "walking" then
		self:_update_walking(unit, blackboard, scratchpad, navigation_ext, action_data, t, dt)
	elseif wander_state == "calculating_path" then
		self:_calculate_path(unit, blackboard, scratchpad, navigation_ext, action_data, t, dt)
	elseif wander_state == "recalc_random_path" then
		self:_recalculate_random_path(unit, blackboard, scratchpad, navigation_ext, action_data, t, dt)
	elseif wander_state == "recalc_path" then
		self:_recalculate_path(unit, blackboard, scratchpad, navigation_ext, action_data, t, dt)
	elseif wander_state == "teleport_to_smart_object" then
		self:_teleport_to_smart_object(unit, blackboard, scratchpad, navigation_ext, action_data, t, dt)
	elseif wander_state == "no_path_found" then
		self:_update_no_path_found(unit, blackboard, scratchpad, navigation_ext, action_data, t, dt)
	elseif wander_state == "standing_still" then
		-- Nothing
	end

	local nav_smart_object_component = blackboard.nav_smart_object
end

BTNurgleFliesChaseTargetAction._in_range_of_target = function (self, scratchpad, unit)
	local attach_range = scratchpad.chase_target_template.attach_range
	local direct_distance = scratchpad.direct_distance_to_target or math.huge

	return attach_range >= math.abs(direct_distance)
end

BTNurgleFliesChaseTargetAction._resolve_hit = function (self, unit, scratchpad, navigation_ext, t)
	if scratchpad.nurgle_flies_ext:is_fizzling_out(t) then
		return
	end

	local target_unit = scratchpad.chase_target_component.target_unit
	local buff_ext = ScriptUnit.has_extension(target_unit, "buff_system")

	if buff_ext then
		buff_ext:add_internally_controlled_buff("expedition_nurgle_flies", t)
	end

	scratchpad.about_to_despawn = true
end

BTNurgleFliesChaseTargetAction._update_flying = function (self, unit, blackboard, scratchpad, navigation_ext, action_data, t, dt, breed)
	local chase_target_component = scratchpad.chase_target_component
	local flight_start_position = scratchpad.flight_start_position:unbox()
	local flight_end_position = scratchpad.flight_end_position:unbox()
	local unit_position = Unit.local_position(unit, 1)
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	local to_target = flight_end_position - flight_start_position
	local direction = Vector3.normalize(to_target)
	local distance_left = flight_end_position - unit_position
	local velocity = direction * scratchpad.chase_target_template.flight_speed

	scratchpad.velocity = velocity

	locomotion_extension:set_external_velocity(velocity)
	locomotion_extension:set_wanted_velocity(velocity)

	local distance_to_destination = Vector3.length(distance_left)

	if math.abs(distance_to_destination) <= 0.2 then
		if scratchpad.cached_end_position then
			scratchpad.flight_end_position = scratchpad.cached_end_position
			scratchpad.flight_start_position = Vector3Box(unit_position)
			scratchpad.cached_end_position = nil
		else
			chase_target_component.new_target_time = t + scratchpad.new_target_wait_time

			locomotion_extension:set_movement_type("snap_to_navmesh")

			chase_target_component.wander_state = "walking"

			locomotion_extension:set_gravity(nil)
			navigation_ext:set_enabled(true, 2.5)
		end
	end
end

BTNurgleFliesChaseTargetAction._update_walking = function (self, unit, blackboard, scratchpad, navigation_ext, action_data, t, dt)
	local chase_target_component = scratchpad.chase_target_component
	local has_reached_destination = navigation_ext:has_reached_destination()

	if has_reached_destination or t > chase_target_component.wander_time then
		chase_target_component.wander_state = "recalc_path"
	elseif self:_need_to_teleport(unit, blackboard, scratchpad, nil, action_data, true) then
		chase_target_component.wander_state = "teleport_to_smart_object"
	else
		self:_try_to_fly(unit, t, dt, blackboard, scratchpad, action_data)
	end
end

BTNurgleFliesChaseTargetAction._update_no_path_found = function (self, unit, blackboard, scratchpad, navigation_ext, action_data, t, dt)
	local chase_target_component = scratchpad.chase_target_component

	if t > chase_target_component.idle_time then
		chase_target_component.wander_state = "recalc_random_path"
	end
end

BTNurgleFliesChaseTargetAction._calculate_path = function (self, unit, blackboard, scratchpad, navigation_ext, action_data, t, dt)
	local chase_target_component = scratchpad.chase_target_component
	local is_computing_path = navigation_ext:is_computing_path()
	local has_path = navigation_ext:has_path()
	local is_following_path = navigation_ext:is_following_path()

	if not is_computing_path and (is_following_path or not has_path) then
		if has_path then
			chase_target_component.wander_state = "walking"
			chase_target_component.wander_time = t + 1
		else
			chase_target_component.wander_state = "no_path_found"
			chase_target_component.idle_time = t + 2 + math.random()
		end
	end
end

BTNurgleFliesChaseTargetAction._recalculate_random_path = function (self, unit, blackboard, scratchpad, navigation_ext, action_data, t, dt)
	local chase_target_component = scratchpad.chase_target_component
	local position = Unit.local_position(unit, 1)
	local nav_world = scratchpad.nav_world
	local traverse_logic = navigation_ext:traverse_logic()
	local random_max_distance = 100
	local offset_x = -random_max_distance + math.random() * random_max_distance * 2
	local offset_y = -random_max_distance + math.random() * random_max_distance * 2
	local random_pos = position and NavQueries.position_on_mesh_guaranteed(nav_world, position + Vector3(offset_x, offset_y, 0), 5, 10, traverse_logic)

	if random_pos then
		navigation_ext:move_to(random_pos)

		chase_target_component.wander_state = "calculating_path"
	else
		chase_target_component.idle_time = t + 0.5
		chase_target_component.wander_state = "no_path_found"
	end
end

BTNurgleFliesChaseTargetAction._recalculate_path = function (self, unit, blackboard, scratchpad, navigation_ext, action_data, t, dt)
	local chase_target_component = scratchpad.chase_target_component
	local target_unit = chase_target_component.target_unit
	local chase_target_template = scratchpad.chase_target_template

	if not target_unit or t > chase_target_component.new_target_time then
		chase_target_component.new_target_time = t + scratchpad.new_target_wait_time

		local new_target_unit = self:_get_randomize_new_target_unit(unit, scratchpad, t)

		if new_target_unit then
			target_unit = new_target_unit
			chase_target_component.target_unit = new_target_unit
			chase_target_component.new_target_time = t + scratchpad.new_target_wait_time
		else
			target_unit = nil
		end
	end

	local nav_world = scratchpad.nav_world
	local position = Unit.local_position(unit, 1)
	local random_wander = not target_unit or chase_target_template and chase_target_template.random_wander
	local target_alive = Unit.alive(target_unit)
	local target_pos = target_alive and POSITION_LOOKUP[target_unit]

	if random_wander then
		chase_target_component.wander_state = "recalc_random_path"
	elseif target_alive and target_pos then
		local target_position = POSITION_LOOKUP[target_unit]
		local nav_position = _get_position_on_navmesh(nav_world, target_position)

		if nav_position then
			local target_distance_sq = Vector3.length_squared(nav_position - position)

			if target_distance_sq > 0.25 then
				navigation_ext:move_to(nav_position)

				chase_target_component.wander_state = "calculating_path"
			end
		else
			chase_target_component.idle_time = t + math.random() * 0.5
			chase_target_component.wander_state = "no_path_found"
		end
	else
		chase_target_component.idle_time = t + 2 + math.random()
		chase_target_component.wander_state = "no_path_found"
	end
end

BTNurgleFliesChaseTargetAction._teleport_to_smart_object = function (self, unit, blackboard, scratchpad, navigation_ext, action_data, t, dt)
	local chase_target_component = scratchpad.chase_target_component
	local nav_smart_object_component = blackboard.nav_smart_object
	local exit_position = nav_smart_object_component.exit_position:unbox()

	Unit.set_local_position(unit, 1, exit_position)

	chase_target_component.wander_state = "walking"
end

BTNurgleFliesChaseTargetAction._get_randomize_new_target_unit = function (self, unit, scratchpad, t)
	local player_manager = Managers.player
	local human_players = player_manager:human_players()
	local chase_target_component = scratchpad.chase_target_component
	local vortex_position = Unit.local_position(unit, 1)
	local target_unit
	local shortest_distance = math.huge

	for _, player in pairs(human_players) do
		local player_unit = player.player_unit

		if player_unit and Unit.alive(player_unit) and chase_target_component.target_unit ~= player_unit then
			local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
			local disabled_character_state_component = unit_data_extension:read_component("disabled_character_state")
			local character_state_component = unit_data_extension:read_component("character_state")

			if not PlayerUnitStatus.is_vortex_grabbed(disabled_character_state_component) and not PlayerUnitStatus.is_disabled(character_state_component) then
				local player_position = Unit.local_position(player_unit, 1)
				local distance = Vector3.distance(vortex_position, player_position)

				if distance < shortest_distance then
					shortest_distance = distance
					target_unit = player_unit
				end
			end
		end
	end

	return target_unit
end
