-- chunkname: @scripts/extension_systems/payload/payload_extension.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local MainPathQueries = require("scripts/utilities/main_path_queries")
local MinionAttack = require("scripts/utilities/minion_attack")
local Navigation = require("scripts/extension_systems/navigation/utilities/navigation")
local NavQueries = require("scripts/utilities/nav_queries")
local NetworkLookup = require("scripts/network_lookup/network_lookup")
local PayloadSettings = require("scripts/settings/payload/payload_settings")
local Push = require("scripts/extension_systems/character_state_machine/character_states/utilities/push")
local Bezier = require("scripts/utilities/spline/bezier")
local PayloadExtension = class("PayloadExtension")
local STATES = PayloadSettings.states
local MOVEMENT_TYPES = PayloadSettings.movement_types
local PI = math.pi
local HALF_PI = math.pi * 0.5
local SPEED_CONTROLLERS = PayloadSettings.payload_speed_controllers
local NAV_MESH_CHECK_ABOVE = 0.75
local NAV_MESH_CHECK_BELOW = 0.5

PayloadExtension.init = function (self, extension_init_context, unit, extension_init_component)
	self._physics_world = extension_init_context.physics_world
	self._is_server = extension_init_context.is_server
	self._unit = unit
	self._payload_path_system = Managers.state.extension:system("payload_path_system")

	if self._is_server then
		self._nav_world = extension_init_context.nav_world
		self._running_astar = false
		self._path_name = "default"
		self._path_nodes = nil
		self._path_index = 0
		self._stalled_pathing = false
	end

	self._running_terrain_raycasts = 0
	self._terrain_raycast_cb = callback(self, "_terrain_hit_callback")
	self._terrain_raycast = Managers.state.game_mode:create_safe_raycast_object("closest", "types", "statics", "collision_filter", "filter_minion_mover")
	self._state = STATES.idle
	self._target_index = 1
	self._target_positions = {}
	self._target_path_nodes = {}
	self._target_normals = {}

	local current_rotation = Unit.local_rotation(unit, 1)

	self._movement_type = "linear"
	self._rotation_type_in_movement = "constant"
	self._rotation_speed_in_movement = 0
	self._speed_controller = SPEED_CONTROLLERS.proximity
	self._max_speed = 0
	self._speed = 0
	self._speed_passive = 0
	self._speed_active = 0
	self._speed_additional_player = 0
	self._acceleration = 0
	self._deceleration = 0
	self._turning_parameters = {
		node_turning_speed_override_or_nil = nil,
		turn_type = "constant",
		turning_speed = 0,
		wanted_rotation = QuaternionBox(current_rotation),
	}
	self._timed_bezier_turning = {
		current_turning_progress = 0,
		full_turn_time = 15,
		time_for_turning_pi = 15,
		total_turn_angle = 0,
		starting_rotation = QuaternionBox(current_rotation),
	}

	local starting_flat_forward = Vector3.normalize(Vector3.flat(Quaternion.forward(current_rotation)))

	self._smooth_movement_parameters = {
		horizontal_movement_speed_multiplier = 0.5,
		look_rotation_speed = 0.5,
		normal_adjustment_raycast_origin_offsets = nil,
		normal_adjustment_rotation_speed = 1,
		vertical_movement_speed_multiplier = 0.15,
	}
	self._smooth_movement = {
		horizontal_movement_locked = false,
		last_ahead_target_index = 1,
		current_horizontal_direction = Vector3Box(starting_flat_forward),
		previous_node_position = Vector3Box(Unit.local_position(unit, 1)),
	}
	self._secondary_aim_target = {
		aim_constraint_target = nil,
		aim_constraint_target_name = nil,
		is_targeting_world_position_override = false,
		locked_to_movement = true,
		target_node_index = nil,
		target_node_name = "",
		use_aim_constraint = false,
		stationary_aim_world_position_state = {
			aiming_progress = 0,
			reached_desired_rotation = false,
			target_position = Vector3Box(Vector3(0, 0, 0)),
			target_rotation = QuaternionBox(Quaternion.identity()),
			starting_aim_rotation = QuaternionBox(Quaternion.identity()),
		},
		current_aim_rotation = QuaternionBox(Quaternion.identity()),
	}
	self._nav_cost_volume_id = nil
	self._in_proximity_local = 0
	self._in_proximity_networked = 0
	self._networked_proximity_history = {}
	self._proximity_distance = 0
	self._main_path_local = 0
	self._main_path_networked = 0
	self._networked_main_path_history = {}
	self._main_path_distance = 10
	self._push_template = {
		speed = 0,
	}
	self._player_push_distance = 0
	self._last_fixed_frame = 0
end

PayloadExtension.setup_from_component = function (self, path_name, movement_type, rotation_type_in_movement, rotation_speed_in_movement, speed_controller, speed_passive, speed_active, speed_additional_player, acceleration, deceleration, floor_normal_adjustment_speed, normal_adjustment_square_half_extents, turn_type, turning_speed, time_for_turning_pi, optional_aiming_node_name, optional_aiming_constraint_target, proximity_distance, player_push_power, player_push_distance, random_spawn_radius)
	local payload_unit = self._unit

	self._path_name = path_name
	self._movement_type = movement_type
	self._rotation_type_in_movement = rotation_type_in_movement
	self._rotation_speed_in_movement = rotation_speed_in_movement
	self._speed_controller = speed_controller
	self._max_speed = speed_active + speed_additional_player * 3
	self._speed_passive = speed_passive
	self._speed_active = speed_active
	self._speed_additional_player = speed_additional_player
	self._acceleration = acceleration
	self._deceleration = deceleration
	self._random_spawn_radius = random_spawn_radius

	local smooth_movement_parameters = self._smooth_movement_parameters

	smooth_movement_parameters.normal_adjustment_rotation_speed = floor_normal_adjustment_speed
	smooth_movement_parameters.normal_adjustment_raycast_origin_offsets = {
		{
			0,
			0,
			0,
		},
		{
			normal_adjustment_square_half_extents.x,
			normal_adjustment_square_half_extents.y,
			0,
		},
		{
			-normal_adjustment_square_half_extents.x,
			normal_adjustment_square_half_extents.y,
			0,
		},
		{
			normal_adjustment_square_half_extents.x,
			-normal_adjustment_square_half_extents.y,
			0,
		},
		{
			-normal_adjustment_square_half_extents.x,
			-normal_adjustment_square_half_extents.y,
			0,
		},
	}

	local turning_parameters = self._turning_parameters

	turning_parameters.turn_type = turn_type
	turning_parameters.turning_speed = turning_speed
	self._timed_bezier_turning.time_for_turning_pi = time_for_turning_pi

	local secondary_aim_target = self._secondary_aim_target

	if optional_aiming_node_name ~= "" then
		secondary_aim_target.target_node_name = optional_aiming_node_name
		secondary_aim_target.target_node_index = Unit.node(payload_unit, optional_aiming_node_name)

		secondary_aim_target.current_aim_rotation:store(Unit.world_rotation(payload_unit, secondary_aim_target.target_node_index))
	end

	if optional_aiming_constraint_target ~= "" then
		secondary_aim_target.use_aim_constraint = true
		secondary_aim_target.aim_constraint_target_name = optional_aiming_constraint_target
		secondary_aim_target.aim_constraint_target = Unit.animation_find_constraint_target(self._unit, optional_aiming_constraint_target)
	end

	self._push_template.speed = player_push_power
	self._player_push_distance = player_push_distance
	self._proximity_distance = proximity_distance
	self._prop_collider_extension = ScriptUnit.has_extension(payload_unit, "prop_collision_system")

	self:_setup_nav_cost(payload_unit)
end

PayloadExtension._setup_nav_cost = function (self, unit)
	local transform = Unit.world_pose(unit, 1)
	local cost_multiplier = 50
	local cost_map_id = Managers.state.nav_mesh:nav_cost_map_id("payload")
	local _, size = Unit.box(unit)

	self._nav_cost_volume_id = Managers.state.nav_mesh:add_nav_cost_map_box_volume(transform, size, cost_multiplier, cost_map_id)
end

PayloadExtension.on_gameplay_post_init = function (self, unit)
	if not self._is_server then
		return
	end

	self:_setup_astar()

	local side_system = Managers.state.extension:system("side_system")

	side_system:on_add_extension(nil, self._unit, nil, {
		is_human_unit = false,
		is_player_unit = false,
		side_id = 1,
	})

	if self._random_spawn_radius > 0 then
		local target_pos = POSITION_LOOKUP[self._unit]
		local spawn_point_positions = Managers.state.main_path:spawn_point_positions()
		local selected_spawn_point
		local selected_distance = 0

		for _, group in pairs(spawn_point_positions) do
			for _, sub_group in pairs(group) do
				for _, pos_box in pairs(sub_group) do
					local pos = pos_box:unbox()
					local distance = Vector3.distance(pos, target_pos)

					if selected_distance < distance and distance < self._random_spawn_radius then
						selected_spawn_point = pos
						selected_distance = distance
					end
				end
			end
		end

		if selected_spawn_point then
			local nav_world, traverse_logic = self._nav_world, self._traverse_logic

			self:_update_position(NavQueries.position_on_mesh(nav_world, selected_spawn_point, NAV_MESH_CHECK_ABOVE, NAV_MESH_CHECK_BELOW, traverse_logic))
		end
	end

	if self._is_server then
		self._path_nodes = self._payload_path_system:get_nodes_for_path(self._path_name)
		self._path_index = 0

		if self._path_nodes then
			self:_continue_navigate_path(true)
		end
	end
end

PayloadExtension.hot_join_sync = function (self, unit, sender, channel)
	local unit_level_index = Managers.state.unit_spawner:level_index(unit)
	local targets = self._target_positions
	local normals = self._target_normals
	local nodes = self._target_path_nodes

	for i = 1, #targets do
		local normal = normals[i]

		normal = normal and normal:unbox()

		local node_level_id

		if nodes[i] then
			local node_unit = nodes[i]:unit()

			node_level_id = Managers.state.unit_spawner:level_index(node_unit)
		end

		RPC.rpc_payload_add_target(channel, unit_level_index, targets[i]:unbox(), normal, node_level_id ~= nil, node_level_id or 1)
	end

	local position = Unit.local_position(unit, 1)
	local rotation = Unit.local_rotation(unit, 1)
	local state_lookup_id = NetworkLookup.payload_states[self._state]
	local speed_controller_lookup_id = NetworkLookup.payload_speed_controllers[self._speed_controller]
	local smooth_movement_state = self._smooth_movement
	local last_ahead_index = smooth_movement_state.last_ahead_target_index or self._target_index
	local current_node_node_id = self._current_node_extension and self._current_node_extension:node_id() or 0
	local current_horizontal_direction = self.current_horizontal_direction and smooth_movement_state.current_horizontal_direction:unbox() or Vector3.normalize(Vector3.flat(Quaternion.forward(rotation)))
	local previous_node_position = smooth_movement_state.previous_node_position and smooth_movement_state.previous_node_position:unbox() or self._target_positions[self._target_index]
	local smooth_movement_parameters = self._smooth_movement_parameters
	local horizontal_movement_speed_multiplier = smooth_movement_parameters.horizontal_movement_speed_multiplier
	local vertical_movement_speed_multiplier = smooth_movement_parameters.vertical_movement_speed_multiplier
	local look_rotation_speed = smooth_movement_parameters.look_rotation_speed

	if self._state == STATES.turning and self._turning_parameters.turn_type == "timed_bezier" then
		local timed_bezier_turning = self._timed_bezier_turning

		RPC.rpc_payload_set_bezier_turning(timed_bezier_turning.starting_rotation:unbox(), timed_bezier_turning.current_turning_progress, timed_bezier_turning.full_turn_time)
	end

	local secondary_aim_target = self._secondary_aim_target

	if secondary_aim_target.is_targeting_world_position_override then
		local stationary_aiming_state = secondary_aim_target.stationary_aim_world_position_state

		RPC.rpc_payload_set_aim_constraint_target_override(channel, unit_level_index, stationary_aiming_state.starting_aim_rotation:unbox(), stationary_aiming_state.aiming_progress, stationary_aiming_state.target_position:unbox())
	end

	RPC.rpc_payload_update(channel, unit_level_index, state_lookup_id, speed_controller_lookup_id, self._last_fixed_frame, position, rotation, self._speed, self._target_index, last_ahead_index, current_node_node_id, current_horizontal_direction, previous_node_position, smooth_movement_state.horizontal_movement_locked, horizontal_movement_speed_multiplier, vertical_movement_speed_multiplier, look_rotation_speed)
	RPC.rpc_payload_add_proximity_history(channel, unit_level_index, self._last_fixed_frame, self._in_proximity_networked)
	RPC.rpc_payload_add_main_path_history(channel, unit_level_index, self._last_fixed_frame, self._main_path_networked)
end

PayloadExtension.start_pathing = function (self, from_payload)
	if not self._is_server then
		return
	end

	self:_continue_navigate_path(from_payload)
end

PayloadExtension.start_moving = function (self)
	if not self._is_server then
		return
	end

	self:set_state(STATES.moving)
end

PayloadExtension._setup_astar = function (self)
	local nav_tag_allowed_layers = {
		bot_damage_drops = 0,
		bot_drops = 0,
		bot_jumps = 0,
		bot_ladders = 0,
		bot_leap_of_faith = 0,
		cover_ledges = 0,
		cover_vaults = 0,
		doors = 1,
		jumps = 0,
		ledges = 0,
		ledges_with_fence = 0,
		monster_walls = 0,
		teleporters = 0,
	}
	local nav_cost_map_multipliers = {}
	local traverse_logic, nav_tag_cost_table, nav_cost_map_multiplier_table = Navigation.create_traverse_logic(self._nav_world, nav_tag_allowed_layers, nav_cost_map_multipliers, false)

	self._traverse_logic, self._nav_tag_cost_table, self._nav_cost_map_multiplier_table = traverse_logic, nav_tag_cost_table, nav_cost_map_multiplier_table
	self._astar = GwNavAStar.create()
end

PayloadExtension.destroy = function (self)
	local astar = self._astar

	if astar then
		GwNavAStar.destroy(astar)
		GwNavTraverseLogic.destroy(self._traverse_logic)
		GwNavTagLayerCostTable.destroy(self._nav_tag_cost_table)
		GwNavCostMapMultiplierTable.destroy(self._nav_cost_map_multiplier_table)
	end

	if self._nav_cost_volume_id then
		local cost_map_id = Managers.state.nav_mesh:nav_cost_map_id("payload")

		Managers.state.nav_mesh:remove_nav_cost_map_volume(self._nav_cost_volume_id, cost_map_id)
	end
end

PayloadExtension.allow_nav_tag_layer = function (self, layer_name, layer_allowed)
	local layer_id = Managers.state.nav_mesh:nav_tag_layer_id(layer_name)
	local nav_tag_cost_table = self._nav_tag_cost_table

	if not nav_tag_cost_table then
		return
	end

	if layer_allowed then
		GwNavTagLayerCostTable.allow_layer(nav_tag_cost_table, layer_id)
	else
		GwNavTagLayerCostTable.forbid_layer(nav_tag_cost_table, layer_id)
	end
end

PayloadExtension._continue_navigate_path = function (self, from_payload)
	if self._running_astar then
		Log.error("PayloadExtension", "Trying to navigate again when already looking for path, ignored")

		return false
	end

	local from_position, previous_node

	if self._path_index == 0 or from_payload then
		from_position = Unit.local_position(self._unit, 1)
	else
		previous_node = self._path_nodes[self._path_index]
		from_position = previous_node:location()

		local branches = previous_node:branching_paths()

		if #branches > 0 then
			local branch = branches[math.random(1, #branches)]

			self._path_name = branch
			self._path_nodes = self._payload_path_system:get_nodes_for_path(branch)
			self._path_index = 0
		end
	end

	local next_path_index = self._path_index + 1

	if next_path_index > #self._path_nodes then
		Log.error("PayloadExtension", "Path ended")

		return false
	end

	self._path_index = next_path_index

	local current_node = self._path_nodes[self._path_index]
	local destination_position = current_node:location()

	if previous_node and previous_node:reach_event() == "teleport" then
		self:add_target(current_node:location(), nil, current_node)

		if previous_node:continue_pathing() then
			self:_continue_navigate_path()
		end

		return true
	end

	local nav_world, traverse_logic = self._nav_world, self._traverse_logic
	local position_on_mesh = NavQueries.position_on_mesh(nav_world, from_position, NAV_MESH_CHECK_ABOVE, NAV_MESH_CHECK_BELOW, traverse_logic)

	if position_on_mesh then
		from_position = position_on_mesh
	end

	if Vector3.equal(from_position, destination_position) then
		Log.error("PayloadExtension", "Payload tried to move to its current position (%s), AStar will probably fail.", from_position)
	end

	local astar = self._astar

	GwNavAStar.start(astar, nav_world, from_position, destination_position, traverse_logic)

	self._running_astar = true

	return true
end

local DELAY_TIMER = {}

PayloadExtension.fixed_update = function (self, unit, dt, t, fixed_frame, context)
	self._last_fixed_frame = fixed_frame

	if self._is_server and self._running_astar and self._running_terrain_raycasts == 0 then
		self:_update_astar()
	end

	if self._movement_type == MOVEMENT_TYPES.smooth then
		self:_update_smooth_movement(unit, dt)
	else
		self:_update_movement(unit, dt)
	end

	self:_update_optional_secondary_aim_target(unit, dt)
	self:_update_proximity(unit, fixed_frame)
	self:_update_main_path(unit, fixed_frame)
	self:_update_speed(unit, dt)

	if self._speed > 0 then
		local target_node = Unit.node(unit, "front_push_origin")
		local front_position = Unit.world_position(unit, target_node)
		local players = Managers.player:players()

		for _, player in pairs(players) do
			local player_unit = player.player_unit

			if player_unit and not Managers.state.unit_spawner:is_husk(player_unit) then
				local player_position = POSITION_LOOKUP[player_unit]
				local distance = Vector3.distance(front_position, player_position)

				if distance < self._player_push_distance and (not DELAY_TIMER[player_unit] or t - DELAY_TIMER[player_unit] >= 0.1) then
					DELAY_TIMER[player_unit] = t

					local push_direction = Vector3.normalize(player_position - front_position)
					local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
					local locomotion_push_component = unit_data_extension:write_component("locomotion_push")

					Push.add(player_unit, locomotion_push_component, push_direction, self._push_template, "attack")
				end
			end
		end
	end
end

local LAST_NODE_NAV_MESH_CHECK_ABOVE = 0.5
local LAST_NODE_NAV_MESH_CHECK_BELOW = 0.3

PayloadExtension._update_astar = function (self)
	local astar = self._astar
	local result = GwNavAStar.processing_finished(astar)

	if result then
		self._running_astar = false

		local path_node = self._path_nodes[self._path_index]

		if GwNavAStar.path_found(astar) then
			local num_nodes = GwNavAStar.node_count(astar)
			local nav_world, traverse_logic = self._nav_world, self._traverse_logic
			local path_last_node_position = GwNavAStar.node_at_index(astar, num_nodes)
			local last_node_position = NavQueries.position_on_mesh(nav_world, path_last_node_position, LAST_NODE_NAV_MESH_CHECK_ABOVE, LAST_NODE_NAV_MESH_CHECK_BELOW, traverse_logic)
			local GwNavAStar_node_at_index = GwNavAStar.node_at_index
			local targets = self._target_positions
			local previous_pos = Unit.local_position(self._unit, 1)

			if #targets > 0 then
				previous_pos = targets[#targets]:unbox()
			end

			for i = 2, num_nodes - 1 do
				local position = GwNavAStar_node_at_index(astar, i)

				self:_path_on_terrain(previous_pos, position, not last_node_position and i == num_nodes - 1 and path_node or nil)

				previous_pos = position
			end

			if last_node_position then
				local position = last_node_position

				self:_path_on_terrain(previous_pos, position, path_node)
			end
		else
			self:add_target(path_node:location(), nil, path_node)
		end

		if path_node:continue_pathing() then
			if self:_should_stall_pathing() then
				self._stalled_pathing = true
			else
				self:_continue_navigate_path()
			end
		end
	end
end

local NAVIGATION_TARGET_LENGTH = 20

PayloadExtension._should_stall_pathing = function (self)
	local num_target_positions = #self._target_positions

	return num_target_positions <= 0 or #self._target_positions - self._target_index > NAVIGATION_TARGET_LENGTH
end

local TERRAIN_CHECK_INTERVAL = 2

PayloadExtension._path_on_terrain = function (self, from, to, path_node_or_nil)
	local intervals = math.ceil(Vector3.distance(from, to) / TERRAIN_CHECK_INTERVAL)

	for i = 1, intervals do
		local interval_position = Vector3.lerp(from, to, i / intervals)

		self._running_terrain_raycasts = self._running_terrain_raycasts + 1

		Managers.state.game_mode:add_safe_raycast(self._terrain_raycast, interval_position + Vector3.up(), Vector3.down(), 3, self._terrain_raycast_cb, Vector3Box(interval_position), i == intervals and path_node_or_nil or nil)
	end
end

PayloadExtension._terrain_hit_callback = function (self, id, data, hit, position, distance, normal, actor)
	self._running_terrain_raycasts = self._running_terrain_raycasts - 1

	local path_node_or_nil = data[2]

	if hit then
		self:add_target(position, normal, path_node_or_nil)
	else
		local interval_position = data[1]:unbox()

		self:add_target(interval_position, normal, path_node_or_nil)
	end
end

PayloadExtension._set_turning_parameters = function (self, unit, node_extension, target_rotation, total_rotation_angle_needed)
	local turning_parameters = self._turning_parameters
	local node_turning_speed_override_or_nil = node_extension:turning_speed_override()

	turning_parameters.node_turning_speed_override_or_nil = node_turning_speed_override_or_nil
	turning_parameters.wanted_rotation = QuaternionBox(target_rotation)

	local turn_type = turning_parameters.turn_type

	if turn_type == "timed_bezier" then
		local starting_rotation = Unit.local_rotation(self._unit, 1)
		local timed_bezier_turning = self._timed_bezier_turning

		timed_bezier_turning.starting_rotation = QuaternionBox(starting_rotation)
		timed_bezier_turning.total_turn_angle = total_rotation_angle_needed
		timed_bezier_turning.current_turning_progress = 0

		local target_turning_speed = node_turning_speed_override_or_nil or 1
		local time_per_pi = timed_bezier_turning.time_for_turning_pi * target_turning_speed
		local full_turn_angle_needed = timed_bezier_turning.total_turn_angle
		local full_turn_time = full_turn_angle_needed / PI * time_per_pi

		timed_bezier_turning.full_turn_time = full_turn_time
	else
		Log.error("PayloadExtension", "[_turn_towards] No handle for turn type: %s", turn_type)
	end
end

PayloadExtension._look_towards = function (self, unit, dt, turn_type, wanted_rotation, turning_speed)
	local target_rotation_speed = turning_speed or self._rotation_speed_in_movement
	local new_rotation
	local current_rotation = Unit.local_rotation(unit, 1)

	if turn_type == "constant" then
		new_rotation = math.quat_rotate_towards(current_rotation, wanted_rotation, target_rotation_speed * dt)
	elseif turn_type == "lerp" then
		new_rotation = Quaternion.lerp(current_rotation, wanted_rotation, target_rotation_speed * dt)
	else
		Log.error("PayloadExtension", "[_look_towards] No handle for turn type: %s", turn_type)
	end

	Unit.set_local_rotation(unit, 1, new_rotation)

	return new_rotation
end

PayloadExtension._turn_towards = function (self, unit, dt, turn_type, wanted_rotation, turning_speed)
	local turning_parameters = self._turning_parameters
	local target_rotation_speed = turning_speed or turning_parameters.turning_speed
	local new_rotation
	local current_rotation = Unit.local_rotation(unit, 1)

	if turn_type == "constant" then
		new_rotation = math.quat_rotate_towards(current_rotation, wanted_rotation, target_rotation_speed * dt)
	elseif turn_type == "lerp" then
		new_rotation = Quaternion.lerp(current_rotation, wanted_rotation, target_rotation_speed * dt)
	elseif turn_type == "timed_bezier" then
		local timed_bezier_turning = self._timed_bezier_turning
		local starting_rotation = timed_bezier_turning.starting_rotation:unbox()
		local turning_progress = timed_bezier_turning.current_turning_progress or 0
		local full_turn_time = timed_bezier_turning.full_turn_time
		local new_progress = math.clamp01(turning_progress + dt / full_turn_time)

		timed_bezier_turning.current_turning_progress = new_progress

		local curve_position = Bezier.calc_point(new_progress, Vector3(0, 0, 0), Vector3(1.175, -0.042, 0), Vector3(0.15, 1.064, 0), Vector3(1, 1, 0))
		local turning_easing = math.clamp01(curve_position.y)

		new_rotation = Quaternion.lerp(starting_rotation, wanted_rotation, turning_easing)
	else
		Log.error("PayloadExtension", "[_turn_towards] No handle for turn type: %s", turn_type)
	end

	Unit.set_local_rotation(unit, 1, new_rotation)

	return new_rotation
end

PayloadExtension._is_turn_completed = function (self, current_rotationm, wanted_rotation)
	local turning_parameters = self._turning_parameters
	local turn_type = turning_parameters.turn_type

	if turn_type == "constant" or turn_type == "lerp" then
		return math.quat_angle(wanted_rotation, current_rotationm) <= PayloadSettings.rotation_complete_treshold
	elseif turn_type == "timed_bezier" then
		return self._timed_bezier_turning.current_turning_progress >= 1
	else
		Log.error("PayloadExtension", "[_turn_towards] No handle for turn type: %s", turn_type)
	end
end

PayloadExtension._set_smooth_movement_parameters_with_node_overrides = function (self, current_path_node_extension)
	if current_path_node_extension then
		local smooth_movement_parameters = self._smooth_movement_parameters
		local horizontal_movement_lerping_speed_multiplier_override = current_path_node_extension:horizontal_movement_lerping_speed_multiplier_override()

		smooth_movement_parameters.horizontal_movement_speed_multiplier = horizontal_movement_lerping_speed_multiplier_override or smooth_movement_parameters.horizontal_movement_speed_multiplier

		local vertical_movement_lerping_speed_multiplier_override = current_path_node_extension:vertical_movement_lerping_speed_multiplier_override()

		smooth_movement_parameters.vertical_movement_speed_multiplier = vertical_movement_lerping_speed_multiplier_override or smooth_movement_parameters.vertical_movement_speed_multiplier

		local movement_look_rotation_speed_override = current_path_node_extension:movement_look_rotation_speed_override()

		smooth_movement_parameters.look_rotation_speed = movement_look_rotation_speed_override or smooth_movement_parameters.look_rotation_speed
	end
end

PayloadExtension._update_smooth_translation = function (self, unit, dt, current_position, target_position)
	local target_index = self._target_index
	local target_positions = self._target_positions
	local smooth_movement_state = self._smooth_movement
	local previous_path_node_position = smooth_movement_state.previous_node_position:unbox()
	local smooth_movement_parameters = self._smooth_movement_parameters
	local horizontal_movement_speed_multiplier = smooth_movement_parameters.horizontal_movement_speed_multiplier
	local vertical_movement_speed_multiplier = smooth_movement_parameters.vertical_movement_speed_multiplier
	local segment_start_target_index = target_index - 1
	local target_ahead_position = not smooth_movement_state.horizontal_movement_locked
	local target_position_ahead_index = smooth_movement_state.horizontal_movement_locked and target_index <= smooth_movement_state.last_ahead_target_index and smooth_movement_state.last_ahead_target_index or math.clamp(target_index + (target_ahead_position and 3 or 0), 1, #target_positions)

	smooth_movement_state.last_ahead_target_index = target_position_ahead_index

	local target_position_ahead = target_positions[target_position_ahead_index] and target_positions[target_position_ahead_index]:unbox() or target_position
	local current_segment_start_position = target_positions[segment_start_target_index] and target_positions[segment_start_target_index]:unbox() or previous_path_node_position
	local start_segment_to_end_vector = target_position - current_segment_start_position
	local start_segment_to_current_position_vector = current_position - current_segment_start_position
	local direction_to_target = Vector3.normalize(target_position - current_position)
	local direction_to_target_ahead = Vector3.normalize(target_position_ahead - current_position)
	local direction_to_target_flat = Vector3.normalize(Vector3.flat(direction_to_target_ahead))
	local current_horizontal_direction = smooth_movement_state.current_horizontal_direction:unbox()

	smooth_movement_state.horizontal_movement_locked = smooth_movement_state.horizontal_movement_locked and Vector3.dot(direction_to_target_flat, current_horizontal_direction) > 0.95

	local target_horizontal_direction

	if smooth_movement_state.horizontal_movement_locked then
		target_horizontal_direction = direction_to_target_flat
	else
		local direction_to_target_flat_cross = Vector3(-direction_to_target_flat.y, direction_to_target_flat.x, 0)

		target_horizontal_direction = Vector3.normalize(Vector3.lerp(current_horizontal_direction, direction_to_target_flat, horizontal_movement_speed_multiplier * dt))

		local has_overshot = math.sign(Vector3.dot(direction_to_target_flat_cross, target_horizontal_direction)) ~= math.sign(Vector3.dot(direction_to_target_flat_cross, current_horizontal_direction))

		if has_overshot or Vector3.dot(current_horizontal_direction, direction_to_target_flat) > 0.99 then
			smooth_movement_state.horizontal_movement_locked = true
			target_horizontal_direction = direction_to_target_flat
		end

		smooth_movement_state.current_horizontal_direction:store(target_horizontal_direction)
	end

	local distance_to_travel = self._speed * dt
	local horizontal_direction = target_horizontal_direction
	local horizontal_translation = horizontal_direction * distance_to_travel
	local vertical_direction = Vector3.normalize(Vector3(0, 0, direction_to_target.z))
	local vertical_distance_to_travel = distance_to_travel * vertical_movement_speed_multiplier
	local vertical_translation = vertical_direction * vertical_distance_to_travel
	local new_vertical_position = current_position + vertical_translation
	local will_overshoot_vertically = vertical_translation.z * vertical_translation.z > (target_position.z - current_position.z)^2

	if will_overshoot_vertically then
		new_vertical_position.z = target_position.z
	end

	local new_position = new_vertical_position + horizontal_translation
	local current_segment_progress = 0
	local start_segment_to_end_vector_length = Vector3.length(start_segment_to_end_vector)

	if start_segment_to_end_vector_length <= 0.1 then
		current_segment_progress = 1
	elseif start_segment_to_end_vector_length < Vector3.dot(start_segment_to_current_position_vector, start_segment_to_end_vector) then
		local segment_vector_reduced = Vector3.multiply(start_segment_to_end_vector, 0.95)

		current_segment_progress = Vector3.dot(start_segment_to_current_position_vector, segment_vector_reduced) / Vector3.dot(segment_vector_reduced, segment_vector_reduced)
		current_segment_progress = math.clamp01(current_segment_progress)
	end

	return new_position, target_horizontal_direction, current_segment_progress, distance_to_travel
end

PayloadExtension._update_payload_floor_normal_adjustment = function (self, unit, dt, new_position, target_horizontal_direction, path_target_normal)
	local current_rotation = Unit.local_rotation(unit, 1)
	local target_normal = Vector3.normalize(path_target_normal)
	local current_rotation_up = Quaternion.up(current_rotation)
	local raycast_start_point = new_position + current_rotation_up
	local normal_raycast_hits_average
	local num_hits = 0

	for i = 1, 5 do
		local offset = self._smooth_movement_parameters.normal_adjustment_raycast_origin_offsets[i]
		local raycast_square_corner_spawn_point = raycast_start_point + (Quaternion.forward(current_rotation) * offset[2] + Quaternion.right(current_rotation) * offset[1])
		local hit_raycast, hit_position, _, normal_of_hit, _ = PhysicsWorld.raycast(self._physics_world, raycast_square_corner_spawn_point, -current_rotation_up, 1.5, "closest", "types", "statics", "collision_filter", "filter_minion_mover")

		if hit_raycast then
			num_hits = num_hits + 1

			if normal_raycast_hits_average then
				normal_raycast_hits_average = normal_raycast_hits_average + normal_of_hit
			else
				normal_raycast_hits_average = normal_of_hit
			end
		end
	end

	if num_hits > 0 then
		normal_raycast_hits_average = normal_raycast_hits_average / num_hits
		target_normal = normal_raycast_hits_average
	end

	local target_normal_adjustment_speed = self._smooth_movement_parameters.normal_adjustment_rotation_speed
	local target_normal_lerped = Vector3.lerp(Quaternion.up(current_rotation), target_normal, target_normal_adjustment_speed * dt)
	local target_position_in_horizontal_direction = new_position + target_horizontal_direction
	local target_position_projected_in_normal_plane = target_position_in_horizontal_direction - Vector3.dot(target_position_in_horizontal_direction - new_position, target_normal_lerped) * target_normal_lerped
	local target_floor_normal_oriented_rotation = Quaternion.look(Vector3.normalize(target_position_projected_in_normal_plane - new_position), target_normal_lerped)

	self:_look_towards(unit, dt, self._rotation_type_in_movement, target_floor_normal_oriented_rotation, self._smooth_movement_parameters.look_rotation_speed * math.min(self._speed, 1))
end

local function _vector3_slerp(from, to, t)
	local dot = math.clamp(Vector3.dot(from, to), -1, 1)
	local theta = math.acos(dot) * t
	local relative_vector = Vector3.normalize(to - from * dot)

	return from * math.cos(theta) + relative_vector * math.sin(theta)
end

PayloadExtension._update_smooth_movement = function (self, unit, dt)
	local payload_state = self._state

	if payload_state == STATES.moving then
		local target_index = self._target_index
		local target_positions = self._target_positions
		local target_normals = self._target_normals

		if target_index > #target_positions then
			Log.error("PayloadExtension", "Trying to move but have no target. index %s out of %s", target_index, #target_positions)
			self:set_state(STATES.idle)

			return
		end

		local current_position = Unit.local_position(unit, 1)
		local target_position = target_positions[target_index]:unbox()
		local new_position, target_horizontal_direction, current_segment_progress, distance_to_travel = self:_update_smooth_translation(unit, dt, current_position, target_position)

		self:_update_payload_floor_normal_adjustment(unit, dt, new_position, target_horizontal_direction, target_normals[target_index]:unbox())

		local has_reached_target = current_segment_progress >= 0.98

		if has_reached_target then
			self:_reach_target_position(target_position, false)
		elseif distance_to_travel > 0 then
			self:_update_position(new_position)
		end
	elseif self._state == STATES.turning then
		local turning_parameters = self._turning_parameters
		local node_turning_speed_override_or_nil = turning_parameters.node_turning_speed_override_or_nil
		local wanted_rotation = self._turning_parameters.wanted_rotation:unbox()
		local new_rotation = self:_turn_towards(unit, dt, self._turning_parameters.turn_type, wanted_rotation, node_turning_speed_override_or_nil)
		local completed_turn = self:_is_turn_completed(new_rotation, wanted_rotation)
		local position = Unit.local_position(unit, 1)

		if completed_turn then
			local smooth_movement_state = self._smooth_movement

			smooth_movement_state.current_horizontal_direction:store(Vector3.normalize(Vector3.flat(Quaternion.forward(new_rotation))))

			smooth_movement_state.horizontal_movement_locked = true
			smooth_movement_state.last_ahead_target_index = self._target_index

			local update_payload_position = false
			local finished_turning = true

			self:_reach_target_position(position, update_payload_position, finished_turning)
		else
			self:_update_position(position)
		end
	end
end

PayloadExtension._update_movement = function (self, unit, dt)
	if self._state == STATES.moving then
		local target_index = self._target_index
		local target_positions = self._target_positions
		local target_normals = self._target_normals

		if target_index > #target_positions then
			Log.error("PayloadExtension", "Trying to move but have no target. index %s out of %s", target_index, #target_positions)
			self:set_state(STATES.idle)

			return
		end

		local current_position = Unit.local_position(unit, 1)
		local target_position = target_positions[target_index]:unbox()
		local direction = Vector3.normalize(target_position - current_position)
		local distance = Vector3.length(target_position - current_position)
		local next_normal = target_normals[target_index]:unbox()
		local target_normal = next_normal
		local look_direction = direction
		local wanted_rotation = Quaternion.look(look_direction, target_normal)

		self:_look_towards(unit, dt, self._rotation_type_in_movement, wanted_rotation)

		local distance_to_travel = self._speed * dt

		if distance < distance_to_travel then
			self:_reach_target_position(target_position, true)
		elseif distance_to_travel > 0 then
			self:_update_position(current_position + direction * distance_to_travel)
		end
	elseif self._state == STATES.turning then
		local turning_parameters = self._turning_parameters
		local node_turning_speed_override_or_nil = turning_parameters.node_turning_speed_override_or_nil
		local wanted_rotation = turning_parameters.wanted_rotation:unbox()
		local new_rotation = self:_turn_towards(unit, dt, self._turning_parameters.turn_type, wanted_rotation, node_turning_speed_override_or_nil)
		local completed_turn = self:_is_turn_completed(new_rotation, wanted_rotation)
		local position = Unit.local_position(unit, 1)

		if completed_turn then
			self:_reach_target_position(position, true)
		else
			self:_update_position(position)
		end
	end
end

PayloadExtension._reset_movement_from_node = function (self, path_node_extension)
	local node_unit = path_node_extension:unit()
	local node_position = Unit.local_position(node_unit, 1)
	local node_rotation = Unit.local_rotation(node_unit, 1)

	self._current_node_extension = path_node_extension

	local smooth_movement_state = self._smooth_movement

	smooth_movement_state.horizontal_movement_locked = true

	smooth_movement_state.current_horizontal_direction:store(Vector3.normalize(Vector3.flat(Quaternion.forward(node_rotation))))

	smooth_movement_state.last_ahead_target_index = self._target_index

	smooth_movement_state.previous_node_position:store(node_position)
	self:_set_smooth_movement_parameters_with_node_overrides(path_node_extension)
end

PayloadExtension._stationary_aim_towards_world_position_override = function (self, unit, dt)
	local secondary_aim_target = self._secondary_aim_target
	local stationary_aiming_state = secondary_aim_target.stationary_aim_world_position_state
	local current_aim_progress = stationary_aiming_state.aiming_progress
	local new_aim_progress = math.clamp01(current_aim_progress + dt * 0.2)

	stationary_aiming_state.aiming_progress = new_aim_progress

	local payload_rotation = Unit.world_rotation(unit, 1)
	local payload_up_vector = Quaternion.up(payload_rotation)
	local turret_aim_node_index = secondary_aim_target.target_node_index
	local target_aim_rotation = stationary_aiming_state.target_rotation:unbox()
	local eased_anim_progress = math.ease_in_out_sine(new_aim_progress)
	local new_rotation = Quaternion.lerp(stationary_aiming_state.starting_aim_rotation:unbox(), target_aim_rotation, eased_anim_progress)

	secondary_aim_target.current_aim_rotation:store(new_rotation)

	local turret_aim_origin_position = Unit.world_position(unit, turret_aim_node_index)

	if secondary_aim_target.use_aim_constraint then
		local target_position = turret_aim_origin_position + Vector3.multiply(Quaternion.forward(new_rotation), 5)

		Unit.animation_set_constraint_target(self._unit, secondary_aim_target.aim_constraint_target, target_position)
	else
		local new_rotation_object_space = Quaternion.multiply(Quaternion.inverse(payload_rotation), new_rotation)

		Unit.set_local_rotation(unit, turret_aim_node_index, new_rotation_object_space)
	end

	if not DEDICATED_SERVER and not stationary_aiming_state.reached_desired_rotation and new_aim_progress >= 1 then
		stationary_aiming_state.reached_desired_rotation = true

		Unit.flow_event(self._unit, "lua_payload_aim_stop")
	end
end

PayloadExtension._aim_follow_payload_movement = function (self, unit, dt)
	local secondary_aim_target = self._secondary_aim_target
	local turret_aim_node_index = secondary_aim_target.target_node_index
	local payload_rotation = Unit.world_rotation(unit, 1)
	local payload_up_vector = Quaternion.up(payload_rotation)
	local payload_forward = Vector3.normalize(Quaternion.forward(payload_rotation))
	local turret_aim_origin_position = Unit.world_position(unit, turret_aim_node_index)
	local current_aim_rotation = secondary_aim_target.current_aim_rotation:unbox()
	local turret_aim_target_position = turret_aim_origin_position + Vector3.multiply(payload_forward, 5)
	local target_aim_target_projected_in_normal_plane = turret_aim_target_position - Vector3.dot(turret_aim_target_position - turret_aim_origin_position, payload_up_vector) * payload_up_vector
	local target_aim_target_direction_object_space = Vector3.normalize(target_aim_target_projected_in_normal_plane - turret_aim_origin_position)
	local target_aim_rotation_object_space = Quaternion.look(target_aim_target_projected_in_normal_plane - turret_aim_origin_position, payload_up_vector)
	local turret_aim_speed = secondary_aim_target.locked_to_movement and 2 or 0.3
	local lerping_function = not secondary_aim_target.is_targeting_world_position_override and Quaternion.lerp or math.quat_rotate_towards
	local new_rotation = lerping_function(current_aim_rotation, target_aim_rotation_object_space, turret_aim_speed * dt)

	secondary_aim_target.current_aim_rotation:store(new_rotation)

	if secondary_aim_target.use_aim_constraint then
		local target_position = turret_aim_origin_position + Vector3.multiply(Quaternion.forward(new_rotation), 5)

		Unit.animation_set_constraint_target(self._unit, secondary_aim_target.aim_constraint_target, target_position)
	else
		local new_rotation_object_space = Quaternion.multiply(Quaternion.inverse(payload_rotation), new_rotation)

		Unit.set_local_rotation(unit, turret_aim_node_index, new_rotation_object_space)
	end

	local angle_to_target = Quaternion.angle(new_rotation, target_aim_rotation_object_space)

	if not secondary_aim_target.is_targeting_world_position_override and not secondary_aim_target.locked_to_movement and angle_to_target <= PI * 0.027 then
		secondary_aim_target.locked_to_movement = true
	end
end

PayloadExtension._update_optional_secondary_aim_target = function (self, unit, dt)
	local secondary_aim_target = self._secondary_aim_target
	local is_targeting_override_position = secondary_aim_target.is_targeting_world_position_override

	if is_targeting_override_position and secondary_aim_target.stationary_aim_world_position_state.reached_desired_rotation then
		return
	end

	local turret_aim_node_index = secondary_aim_target.target_node_index

	if turret_aim_node_index then
		if is_targeting_override_position then
			self:_stationary_aim_towards_world_position_override(unit, dt)
		else
			self:_aim_follow_payload_movement(unit, dt)
		end
	end
end

PayloadExtension._check_reached_node_configuration = function (self, path_node_extension, target_index)
	local set_speed_controller = path_node_extension:set_speed_controller()

	if set_speed_controller ~= "unchanged" then
		self._speed_controller = set_speed_controller
	end

	local reach_event = path_node_extension:reach_event()

	if reach_event == "teleport" then
		local target_node_extension = self._target_path_nodes[target_index]
		local target_position = self._target_positions[target_index]:unbox()
		local update_payload_position = true

		self:_reach_target_position(target_position, update_payload_position)
		self:_reset_movement_from_node(target_node_extension)
	elseif reach_event == "stop" then
		self:set_state(STATES.idle)
	elseif reach_event == "continue" and self._state == STATES.idle then
		self:set_state(STATES.moving)
	elseif self._state == STATES.turning then
		self:set_state(STATES.moving)
	end
end

PayloadExtension._reach_target_position = function (self, target_position, set_payload_position_to_target, finished_turning)
	if set_payload_position_to_target then
		self:_update_position(target_position)
	end

	local last_index = self._target_index
	local path_node_extension = self._target_path_nodes[last_index]

	if path_node_extension then
		local unit = self._unit

		self._smooth_movement.previous_node_position:store(Unit.local_position(unit, 1))

		self._current_node_extension = path_node_extension

		self:_set_smooth_movement_parameters_with_node_overrides(path_node_extension)

		local turn_when_reached = path_node_extension:turn_when_reached()
		local node_rotation = Unit.local_rotation(path_node_extension:unit(), 1)
		local total_rotation_angle_needed = math.quat_angle(Unit.local_rotation(unit, 1), node_rotation)

		if turn_when_reached and not finished_turning then
			self:_set_turning_parameters(unit, path_node_extension, node_rotation, total_rotation_angle_needed)
			self:set_state(STATES.turning)

			return
		end
	end

	local target_index = self._target_index + 1

	self._target_index = target_index

	if path_node_extension then
		Unit.flow_event(path_node_extension:unit(), "lua_node_reached")
		self:_check_reached_node_configuration(path_node_extension, target_index)
	end

	if self._stalled_pathing and not self:_should_stall_pathing() then
		self._stalled_pathing = false

		self:_continue_navigate_path()
	end
end

PayloadExtension._update_position = function (self, position)
	local unit = self._unit

	Unit.set_local_position(unit, 1, position)

	local transform = Unit.world_pose(unit, 1)
	local cost_map_id = Managers.state.nav_mesh:nav_cost_map_id("payload")
	local offset = self._speed
	local payload_rotation = Unit.local_rotation(unit, 1)
	local forward = Quaternion.forward(payload_rotation)

	Matrix4x4.set_translation(transform, Matrix4x4.translation(transform) + offset * forward)
	Managers.state.nav_mesh:set_nav_cost_map_volume_transform(self._nav_cost_volume_id, cost_map_id, transform)

	local _, size = Unit.box(unit)

	size.y = size.y + offset

	Managers.state.nav_mesh:set_nav_cost_map_volume_scale(self._nav_cost_volume_id, cost_map_id, size)

	local prop_collider_extension = self._prop_collider_extension

	if prop_collider_extension then
		prop_collider_extension:update_position()
	end
end

PayloadExtension._update_proximity = function (self, unit, fixed_frame)
	local payload_position = Unit.local_position(unit, 1)
	local players = Managers.player:players()
	local proximity_distance = self._proximity_distance
	local in_proximity = 0

	for _, player in pairs(players) do
		local player_unit = player.player_unit
		local player_unit_position = player_unit and Unit.local_position(player_unit, 1) or nil
		local is_in_proximity = player_unit_position and proximity_distance > Vector3.distance(payload_position, player_unit_position)

		if is_in_proximity then
			in_proximity = in_proximity + 1
		end
	end

	if in_proximity ~= self._in_proximity_local then
		self._in_proximity_local = in_proximity

		if in_proximity == 0 then
			Unit.flow_event(unit, "lua_payload_proximity_inactive")
		else
			Unit.flow_event(unit, "lua_payload_proximity_active")
		end

		if self._is_server then
			self:add_proximity_history(fixed_frame + 60, in_proximity)
		end
	end

	local proximity_history = self._networked_proximity_history

	if proximity_history[fixed_frame] then
		self._in_proximity_networked = proximity_history[fixed_frame]
	end

	if proximity_history[fixed_frame - 60] then
		proximity_history[fixed_frame - 60] = nil
	end
end

PayloadExtension.add_proximity_history = function (self, fixed_frame, value)
	self._networked_proximity_history[fixed_frame] = value

	if self._is_server then
		local unit = self._unit
		local unit_level_index = Managers.state.unit_spawner:level_index(unit)

		Managers.state.game_session:send_rpc_clients("rpc_payload_add_proximity_history", unit_level_index, fixed_frame, value)
	end
end

PayloadExtension._update_main_path = function (self, unit, fixed_frame)
	if self._is_server then
		local payload_position = Unit.local_position(unit, 1)
		local main_path_local = 0
		local _, _, payload_percentage, _, _ = MainPathQueries.closest_position(payload_position)
		local players = Managers.player:players()

		for _, player in pairs(players) do
			local player_unit = player.player_unit

			if player_unit then
				local _, _, player_percentage, _, _ = MainPathQueries.closest_position(Unit.local_position(player_unit, 1))

				if payload_percentage < player_percentage then
					main_path_local = main_path_local + 1
				end
			end
		end

		if main_path_local ~= self._main_path_local then
			self._main_path_local = main_path_local

			self:add_main_path_history(fixed_frame + 60, main_path_local)
		end
	end

	local main_path_history = self._networked_main_path_history

	if main_path_history[fixed_frame] then
		self._main_path_networked = main_path_history[fixed_frame]
	end

	if main_path_history[fixed_frame - 60] then
		main_path_history[fixed_frame - 60] = nil
	end
end

PayloadExtension.add_main_path_history = function (self, fixed_frame, value)
	self._networked_main_path_history[fixed_frame] = value

	if self._is_server then
		local unit = self._unit
		local unit_level_index = Managers.state.unit_spawner:level_index(unit)

		Managers.state.game_session:send_rpc_clients("rpc_payload_add_main_path_history", unit_level_index, fixed_frame, value)
	end
end

PayloadExtension._update_speed = function (self, unit, dt)
	local target_speed = 0

	if self._state == STATES.idle then
		target_speed = 0
	elseif self._state == STATES.moving then
		local speed_controller = self._speed_controller

		if speed_controller == SPEED_CONTROLLERS.proximity then
			if self._in_proximity_networked > 0 then
				target_speed = self._speed_active + self._speed_additional_player * (self._in_proximity_networked - 1)
			else
				target_speed = self._speed_passive
			end
		elseif speed_controller == SPEED_CONTROLLERS.main_path then
			if self._main_path_networked > 0 then
				target_speed = self._speed_active + self._speed_additional_player * (self._main_path_networked - 1)
			else
				target_speed = self._speed_passive
			end
		elseif speed_controller == SPEED_CONTROLLERS.max then
			target_speed = self._max_speed
		elseif speed_controller == SPEED_CONTROLLERS.flow then
			target_speed = Unit.flow_variable(unit, "payload_wanted_speed")
		end

		local distance = 0
		local from_pos = Unit.local_position(self._unit, 1)
		local targets = self._target_positions
		local break_distance = 0

		for speed = self._speed, self._deceleration, -self._deceleration do
			break_distance = break_distance + speed
		end

		for i = self._target_index, #targets do
			local to_pos = targets[i]:unbox()

			distance = distance + Vector3.distance(from_pos, to_pos)
			from_pos = to_pos

			if break_distance < distance then
				break
			end

			local path_node = self._target_path_nodes[i]

			if path_node and (path_node:reach_event() == "stop" or path_node:turn_when_reached()) then
				target_speed = 0

				break
			end
		end
	else
		target_speed = self._state == STATES.turning and 0 or target_speed
	end

	if target_speed == self._speed then
		return
	end

	local new_speed = self._speed

	if new_speed < target_speed then
		new_speed = new_speed + self._acceleration * dt

		if target_speed < new_speed then
			new_speed = target_speed
		end
	else
		new_speed = new_speed - self._deceleration * dt

		if new_speed < target_speed then
			new_speed = target_speed
		end
	end

	if new_speed ~= self._speed then
		self._speed = math.clamp(new_speed, 0, self._max_speed)

		Unit.set_flow_variable(unit, "lua_payload_percentage_speed", math.clamp01(self._speed / self._max_speed))
		Unit.flow_event(unit, "lua_payload_on_speed_change")
	end
end

local SCRATCHPAD = {
	pushed_enemies = {},
}
local ACTION_DATA = {
	push_enemies_power_level = 3000,
	push_enemies_radius = 2.5,
	push_enemies_damage_profile = DamageProfileTemplates.ogryn_charge_impact,
}

PayloadExtension.update = function (self, unit, dt, t)
	if self._is_server and self._speed > 0 then
		table.clear(SCRATCHPAD.pushed_enemies)
		MinionAttack.push_nearby_enemies(unit, SCRATCHPAD, ACTION_DATA)
	end
end

PayloadExtension.set_state = function (self, state)
	self._state = state

	if self._is_server then
		local unit = self._unit
		local unit_level_index = Managers.state.unit_spawner:level_index(unit)
		local game_session_manager = Managers.state.game_session
		local position = Unit.local_position(unit, 1)
		local rotation = Unit.local_rotation(unit, 1)
		local state_lookup_id = NetworkLookup.payload_states[self._state]
		local speed_controller_lookup_id = NetworkLookup.payload_speed_controllers[self._speed_controller]
		local smooth_movement_state = self._smooth_movement
		local last_ahead_index = smooth_movement_state.last_ahead_target_index or self._target_index
		local current_node_node_id = self._current_node_extension and self._current_node_extension:node_id() or 0
		local current_horizontal_direction = self.current_horizontal_direction and smooth_movement_state.current_horizontal_direction:unbox() or Vector3.normalize(Vector3.flat(Quaternion.forward(rotation)))
		local previous_node_position = smooth_movement_state.previous_node_position and smooth_movement_state.previous_node_position:unbox() or self._target_positions[self._target_index]
		local smooth_movement_parameters = self._smooth_movement_parameters
		local horizontal_movement_speed_multiplier = smooth_movement_parameters.horizontal_movement_speed_multiplier
		local vertical_movement_speed_multiplier = smooth_movement_parameters.vertical_movement_speed_multiplier
		local look_rotation_speed = smooth_movement_parameters.look_rotation_speed

		game_session_manager:send_rpc_clients("rpc_payload_update", unit_level_index, state_lookup_id, speed_controller_lookup_id, self._last_fixed_frame, position, rotation, self._speed, self._target_index, last_ahead_index, current_node_node_id, current_horizontal_direction, previous_node_position, smooth_movement_state.horizontal_movement_locked, horizontal_movement_speed_multiplier, vertical_movement_speed_multiplier, look_rotation_speed)
		self:clear_targets_before(self._target_index)
	end
end

PayloadExtension.add_target = function (self, target_location, target_normal_or_nil, path_node_or_nil)
	local targets = self._target_positions
	local normals = self._target_normals
	local new_target_index = #targets + 1

	targets[new_target_index] = Vector3Box(target_location)

	local target_normal = target_normal_or_nil or Vector3.up()

	normals[new_target_index] = Vector3Box(target_normal)
	self._target_path_nodes[new_target_index] = path_node_or_nil

	if self._is_server then
		local unit = self._unit
		local unit_level_index = Managers.state.unit_spawner:level_index(unit)
		local game_session_manager = Managers.state.game_session
		local node_level_id

		if path_node_or_nil then
			node_level_id = Managers.state.unit_spawner:level_index(path_node_or_nil:unit())
		end

		game_session_manager:send_rpc_clients("rpc_payload_add_target", unit_level_index, target_location, target_normal, node_level_id ~= nil, node_level_id or 1)
	end
end

PayloadExtension.clear_targets_before = function (self, index)
	self._target_index = self._target_index - index + 1

	local target_positions = self._target_positions
	local target_normals = self._target_normals
	local target_path_nodes = self._target_path_nodes
	local targets = #target_positions

	for i = index, targets do
		local new_index = i - index + 1

		target_positions[new_index] = target_positions[i]
		target_normals[new_index] = target_normals[i]
		target_path_nodes[new_index] = target_path_nodes[i]
	end

	for i = targets - index + 2, targets do
		target_positions[i] = nil
		target_normals[i] = nil
		target_path_nodes[i] = nil
	end

	if self._is_server then
		local unit = self._unit
		local unit_level_index = Managers.state.unit_spawner:level_index(unit)
		local game_session_manager = Managers.state.game_session

		game_session_manager:send_rpc_clients("rpc_payload_clear_targets_before", unit_level_index, index)
	end
end

PayloadExtension.clear_targets = function (self)
	self._target_index = 1

	table.clear(self._target_positions)
	table.clear(self._target_normals)
	table.clear(self._target_path_nodes)

	if self._is_server then
		local unit = self._unit
		local unit_level_index = Managers.state.unit_spawner:level_index(unit)
		local game_session_manager = Managers.state.game_session

		game_session_manager:send_rpc_clients("rpc_payload_clear_targets", unit_level_index)
	end
end

PayloadExtension.teleport_to_node = function (self, path, node_id)
	self:clear_targets()

	self._path_name = path
	self._path_nodes = self._payload_path_system:get_nodes_for_path(self._path_name)
	self._path_index = nil

	for i = 1, #self._path_nodes do
		if self._path_nodes[i]:node_id() == node_id then
			self._path_index = i

			break
		end
	end

	local path_node_extension = self._path_nodes[self._path_index]
	local position = path_node_extension:location()
	local rotation = Unit.local_rotation(path_node_extension:unit(), 1)

	Unit.set_local_rotation(self._unit, 1, rotation)
	self:_reset_movement_from_node(path_node_extension)
	self:_update_position(position)
	self:_continue_navigate_path(true)

	if self._movement_type == MOVEMENT_TYPES.smooth then
		self:_check_reached_node_configuration(path_node_extension)
	end

	self:set_state(STATES.idle)
end

PayloadExtension.set_payload_aim_target_position_override = function (self, target_position, optional_start_rotation, optional_progress_override)
	local unit = self._unit
	local secondary_aim_target = self._secondary_aim_target

	secondary_aim_target.locked_to_movement = false
	secondary_aim_target.is_targeting_world_position_override = true

	local stationary_aiming_state = secondary_aim_target.stationary_aim_world_position_state

	stationary_aiming_state.target_position:store(target_position)

	stationary_aiming_state.aiming_progress = optional_progress_override or 0
	stationary_aiming_state.reached_desired_rotation = false

	local start_rotation = optional_start_rotation or Unit.world_rotation(unit, secondary_aim_target.target_node_index)

	stationary_aiming_state.starting_aim_rotation:store(start_rotation)

	local payload_rotation = Unit.world_rotation(unit, 1)
	local payload_up_vector = Quaternion.up(payload_rotation)
	local turret_aim_origin_node_index = secondary_aim_target.target_node_index
	local turret_aim_origin_position = Unit.world_position(unit, turret_aim_origin_node_index)
	local target_aim_target_projected_in_normal_plane = target_position - Vector3.dot(target_position - turret_aim_origin_position, payload_up_vector) * payload_up_vector
	local target_aim_rotation_object_space = Quaternion.look(target_aim_target_projected_in_normal_plane - turret_aim_origin_position, payload_up_vector)

	stationary_aiming_state.target_rotation:store(target_aim_rotation_object_space)

	if not DEDICATED_SERVER then
		Unit.flow_event(self._unit, "lua_payload_aim_start")
	end

	if self._is_server then
		local unit_level_index = Managers.state.unit_spawner:level_index(unit)
		local game_session_manager = Managers.state.game_session

		game_session_manager:send_rpc_clients("rpc_payload_set_aim_constraint_target_override", unit_level_index, start_rotation, stationary_aiming_state.aiming_progress, target_position)
	end
end

PayloadExtension.clear_payload_aim_target_position_override = function (self)
	local secondary_aim_target = self._secondary_aim_target

	secondary_aim_target.locked_to_movement = false
	secondary_aim_target.is_targeting_world_position_override = false

	if not secondary_aim_target.stationary_aim_world_position_state.reached_desired_rotation then
		secondary_aim_target.stationary_aim_world_position_state.reached_desired_rotation = true

		Unit.flow_event(self._unit, "lua_payload_aim_stop")
	end

	if self._is_server then
		local unit = self._unit
		local unit_level_index = Managers.state.unit_spawner:level_index(unit)
		local game_session_manager = Managers.state.game_session

		game_session_manager:send_rpc_clients("rpc_payload_clear_aim_constraint_target_override", unit_level_index)
	end
end

PayloadExtension.rpc_payload_update = function (self, state_id, speed_controller_id, fixed_frame, position, rotation, speed, target_index, last_ahead_index, current_node_id, current_horizontal_direction, previous_node_position, horizontal_movement_locked, horizontal_movement_speed_multiplier, vertical_movement_speed_multiplier, look_rotation_speed)
	local unit = self._unit
	local client_current_node_id = self._current_node_extension and self._current_node_extension:node_id() or -1

	if current_node_id < client_current_node_id then
		return
	end

	self:set_state(NetworkLookup.payload_states[state_id])

	self._current_node_extension = self._payload_path_system:get_node_for_path_and_id(self._path_name, current_node_id)
	self._speed_controller = NetworkLookup.payload_speed_controllers[speed_controller_id]

	local smooth_movement_state = self._smooth_movement
	local current_position = Unit.local_position(unit, 1)
	local position_difference = Vector3.distance_squared(current_position, position)

	if position_difference >= 0.09 then
		self:_update_position(position)
		Unit.set_local_rotation(unit, 1, rotation)

		smooth_movement_state.last_ahead_target_index = last_ahead_index
		smooth_movement_state.horizontal_movement_locked = horizontal_movement_locked

		smooth_movement_state.current_horizontal_direction:store(current_horizontal_direction)
		smooth_movement_state.previous_node_position:store(previous_node_position)
	end

	local smooth_movement_parameters = self._smooth_movement_parameters

	smooth_movement_parameters.horizontal_movement_speed_multiplier = horizontal_movement_speed_multiplier
	smooth_movement_parameters.vertical_movement_speed_multiplier = vertical_movement_speed_multiplier
	smooth_movement_parameters.look_rotation_speed = look_rotation_speed
	self._speed = speed
	self._target_index = target_index

	Unit.set_flow_variable(unit, "lua_payload_percentage_speed", math.clamp01(self._speed / self._max_speed))
	Unit.flow_event(unit, "lua_payload_on_speed_change")

	local last_frame = 0

	for frame, value in pairs(self._networked_proximity_history) do
		if frame < fixed_frame then
			self._networked_proximity_history[fixed_frame] = nil

			if last_frame < frame then
				last_frame = frame
				self._in_proximity_networked = value
			end
		end
	end

	local fixed_frame_time = Managers.state.game_session.fixed_time_step
	local update_movement_function = self._movement_type == MOVEMENT_TYPES.smooth and self._update_smooth_movement or self._update_movement

	for i = fixed_frame, self._last_fixed_frame - 1 do
		update_movement_function(self, unit, fixed_frame_time)
		self:_update_optional_secondary_aim_target(unit, fixed_frame_time)
		self:_update_proximity(unit, fixed_frame)
		self:_update_main_path(unit, fixed_frame)
		self:_update_speed(unit, fixed_frame_time)
	end
end

PayloadExtension.rpc_payload_set_bezier_turning = function (self, starting_rotation, current_turning_progress, full_turn_time)
	local timed_bezier_turning = self._timed_bezier_turning

	timed_bezier_turning.starting_rotation:store(starting_rotation)

	timed_bezier_turning.current_turning_progress = current_turning_progress
	timed_bezier_turning.full_turn_time = full_turn_time
end

PayloadExtension.rpc_payload_set_aim_constraint_target_override = function (self, starting_rotation, aiming_progress, aim_target_position_override)
	local secondary_aim_target = self._secondary_aim_target

	if not secondary_aim_target.is_targeting_world_position_override then
		self:set_payload_aim_target_position_override(aim_target_position_override, starting_rotation, aiming_progress)
	end
end

PayloadExtension.rpc_payload_clear_aim_constraint_target_override = function (self)
	self:clear_payload_aim_target_position_override()
end

return PayloadExtension
