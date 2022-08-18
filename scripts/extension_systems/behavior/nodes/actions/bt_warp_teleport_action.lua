require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local NavQueries = require("scripts/utilities/nav_queries")
local BtWarpTeleportAction = class("BtWarpTeleportAction", "BtNode")

BtWarpTeleportAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local teleport_in_anim_events = action_data.teleport_in_anim_events
	local teleport_in_anim_event = Animation.random_event(teleport_in_anim_events)
	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	animation_extension:anim_event(teleport_in_anim_event)

	local teleport_timing = action_data.teleport_timings[teleport_in_anim_event]
	scratchpad.teleport_timing = t + teleport_timing
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	scratchpad.perception_component = blackboard.perception
	local teleport_directions = self:_calculate_randomized_teleport_directions(action_data)
	scratchpad.teleport_directions = teleport_directions
	scratchpad.state = "teleporting_in"
	scratchpad.teleport_direction_index = 1
	local fx_system = Managers.state.extension:system("fx_system")
	local position = POSITION_LOOKUP[unit]
	local wwise_in_event = action_data.wwise_teleport_in

	fx_system:trigger_wwise_event(wwise_in_event, position)

	scratchpad.fx_system = fx_system
end

BtWarpTeleportAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local state = scratchpad.state
	local locomotion_extension = scratchpad.locomotion_extension

	if state == "teleporting_in" then
		local result = self:_find_teleport_position(unit, scratchpad, action_data)

		if result == "failed" then
			return "done"
		end

		local teleport_position = scratchpad.teleport_position and scratchpad.teleport_position:unbox()

		if teleport_position then
			local direction = Vector3.normalize(teleport_position - POSITION_LOOKUP[unit])
			local rotation = Quaternion.look(direction)

			locomotion_extension:set_wanted_rotation(rotation)
		end

		if scratchpad.teleport_timing <= t then
			if scratchpad.teleport_position then
				self:_teleport(unit, scratchpad, action_data, t)
			else
				return "done"
			end
		end
	elseif state == "teleporting_out" then
		if scratchpad.teleport_finished_timing <= t then
			return "done"
		end

		local target_unit = scratchpad.perception_component.target_unit
		local target_position = POSITION_LOOKUP[target_unit]
		local direction = Vector3.normalize(target_position - POSITION_LOOKUP[unit])
		local rotation = Quaternion.look(direction)

		locomotion_extension:set_wanted_rotation(rotation)
	end

	return "running"
end

local DEGREE_RANGE = 360

BtWarpTeleportAction._calculate_randomized_teleport_directions = function (self, action_data)
	local degree_per_direction = action_data.degree_per_direction
	local num_directions = DEGREE_RANGE / degree_per_direction
	local current_degree = -(DEGREE_RANGE / 2)
	local directions = {}

	for i = 1, num_directions do
		current_degree = current_degree + degree_per_direction
		local radians = math.degrees_to_radians(current_degree)
		local direction = Vector3(math.sin(radians), math.cos(radians), 0)
		directions[i] = Vector3Box(direction)
	end

	table.shuffle(directions)

	return directions
end

local MAX_TRIES = 10
local ABOVE = 3
local BELOW = 3
local LATERAL = 1
local DISTANCE_FROM_NAV_MESH = 0

BtWarpTeleportAction._find_teleport_position = function (self, unit, scratchpad, action_data)
	local navigation_extension = scratchpad.navigation_extension
	local nav_world = navigation_extension:nav_world()
	local traverse_logic = navigation_extension:traverse_logic()
	local target_unit = scratchpad.perception_component.target_unit
	local target_navigation_extension = ScriptUnit.extension(target_unit, "navigation_system")
	local target_position_on_nav_mesh = target_navigation_extension:latest_position_on_nav_mesh()

	if not target_position_on_nav_mesh then
		local target_position = POSITION_LOOKUP[target_unit]
		target_position_on_nav_mesh = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, target_position, ABOVE, BELOW, LATERAL, DISTANCE_FROM_NAV_MESH)

		if not target_position_on_nav_mesh then
			return "failed"
		end
	end

	local teleport_distance = action_data.teleport_distance
	local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
	local first_person_component = target_unit_data_extension:read_component("first_person")
	local look_rotation = first_person_component.rotation
	local target_forward = Vector3.flat(Quaternion.forward(look_rotation))
	local position_in_front_of_target = target_position_on_nav_mesh + target_forward * teleport_distance
	local nav_mesh_position_in_front_of_target = NavQueries.position_on_mesh(nav_world, position_in_front_of_target, ABOVE, BELOW, traverse_logic)

	if nav_mesh_position_in_front_of_target then
		scratchpad.teleport_position = Vector3Box(nav_mesh_position_in_front_of_target)

		return "success"
	end

	local teleport_directions = scratchpad.teleport_directions

	for i = 1, MAX_TRIES do
		local teleport_direction_index = scratchpad.teleport_direction_index
		local teleport_direction = teleport_directions[teleport_direction_index]:unbox()
		local teleport_test_position = target_position_on_nav_mesh + teleport_direction * teleport_distance
		local teleport_nav_mesh_position = NavQueries.position_on_mesh(nav_world, teleport_test_position, ABOVE, BELOW, traverse_logic)
		local final_position = nil

		if teleport_nav_mesh_position then
			local success, hit_position = GwNavQueries.raycast(nav_world, target_position_on_nav_mesh, teleport_nav_mesh_position, traverse_logic)
			final_position = success and teleport_nav_mesh_position or hit_position
		end

		if final_position then
			local distance_to_target = Vector3.distance(final_position, target_position_on_nav_mesh)
			local travel_distance = Vector3.distance(final_position, POSITION_LOOKUP[unit])
			local max_distance = action_data.max_distance

			if max_distance <= distance_to_target and max_distance <= travel_distance then
				if scratchpad.teleport_position then
					scratchpad.teleport_position:store(final_position)
				else
					scratchpad.teleport_position = Vector3Box(final_position)
				end

				return "success"
			else
				scratchpad.teleport_direction_index = teleport_direction_index + 1
			end
		else
			scratchpad.teleport_direction_index = teleport_direction_index + 1
		end

		if #teleport_directions == scratchpad.teleport_direction_index then
			return "failed"
		end
	end

	return "running"
end

BtWarpTeleportAction._teleport = function (self, unit, scratchpad, action_data, t)
	local fx_system = scratchpad.fx_system
	local wwise_out_event = action_data.wwise_teleport_out
	local teleport_position = scratchpad.teleport_position:unbox()

	fx_system:trigger_wwise_event(wwise_out_event, teleport_position)

	local locomotion_extension = scratchpad.locomotion_extension

	locomotion_extension:teleport_to(teleport_position)

	local teleport_out_anim_events = action_data.teleport_out_anim_events
	local teleport_out_anim_event = Animation.random_event(teleport_out_anim_events)
	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	animation_extension:anim_event(teleport_out_anim_event)

	local teleport_finished_timing = action_data.teleport_finished_timings[teleport_out_anim_event]
	scratchpad.teleport_finished_timing = t + teleport_finished_timing
	scratchpad.state = "teleporting_out"
end

return BtWarpTeleportAction
