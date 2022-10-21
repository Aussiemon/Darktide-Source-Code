local InputHandlerSettings = require("scripts/managers/player/player_game_states/input_handler_settings")
local BotUnitInput = class("BotUnitInput")

BotUnitInput.init = function (self, physics_world, player)
	local ephemeral_actions = InputHandlerSettings.ephemeral_actions
	local num_ephemeral_actions = #ephemeral_actions
	self._input = {}
	self._ephemeral_input = Script.new_map(num_ephemeral_actions)
	self._move = {
		x = 0,
		y = 0
	}
	self._player = player
	self._aim_position = Vector3Box(0, 0, 0)
	self._aim_rotation = QuaternionBox(0, 0, 0, 0)
	self._aiming = false
	self._soft_aiming = false
	self._aim_with_rotation = false
	self._interact = false
	self._interact_held = false
	self._dodge = false
	self._avoiding_aoe_threat = false
	self._look_at_player_unit = nil
	self._look_at_player_rotation_allowed = false
	self._look_at_player_first_person_component = nil
	self._physics_world = physics_world
end

BotUnitInput.extensions_ready = function (self, world, unit)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	self._first_person_component = unit_data_extension:read_component("first_person")
	self._character_state_component = unit_data_extension:read_component("character_state")
	self._ladder_character_state_component = unit_data_extension:read_component("ladder_character_state")
	self._movement_state_component = unit_data_extension:read_component("movement_state")
	self._locomotion_component = unit_data_extension:read_component("locomotion")
	self._navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	self._group_extension = ScriptUnit.extension(unit, "group_system")
end

BotUnitInput.fixed_update = function (self, unit, dt, t, frame)
	local input = self._input
	local ephemeral_input = self._ephemeral_input

	table.merge(input, ephemeral_input)
	table.clear(ephemeral_input)
end

BotUnitInput.update = function (self, unit, dt, t)
	local input = self._input

	table.clear(input)
	self:_update_movement(unit, input, dt, t)
	self:_update_actions(input)
	self:_store_ephemeral_input(input)
end

BotUnitInput._update_actions = function (self, input)
	if self._interact then
		self._interact = false

		if not self._interact_held then
			self._interact_held = true
			input.interact_pressed = true
		end

		input.interact_hold = true
	elseif self._interact_held then
		self._interact_held = false
	end

	if self._dodge then
		self._dodge = false
		input.dodge = true
	end
end

BotUnitInput._store_ephemeral_input = function (self, input)
	local ephemeral_input = self._ephemeral_input
	local ephemeral_actions = InputHandlerSettings.ephemeral_actions
	local num_ephemeral_actions = #ephemeral_actions

	for i = 1, num_ephemeral_actions do
		local action_name = ephemeral_actions[i]
		local input_value = input[action_name]

		if input_value then
			ephemeral_input[action_name] = input_value
		end
	end
end

BotUnitInput.set_aim_position = function (self, position)
	self._aim_position:store(position)
end

BotUnitInput.set_aim_rotation = function (self, rotation)
	self._aim_rotation:store(rotation)
end

BotUnitInput.set_aiming = function (self, aiming, soft, use_rotation)
	self._aiming = aiming
	self._aim_with_rotation = use_rotation and aiming or false
	self._soft_aiming = soft and aiming or false
end

BotUnitInput.set_look_at_player_unit = function (self, player_unit, rotation_allowed)
	self._look_at_player_unit = player_unit
	self._look_at_player_rotation_allowed = not not rotation_allowed

	if player_unit then
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
		local first_person_component = unit_data_extension:read_component("first_person")
		self._look_at_player_first_person_component = first_person_component
	else
		self._look_at_player_first_person_component = nil
	end
end

BotUnitInput.interact = function (self, reset)
	self._interact = true

	if reset then
		self._interact_held = false
	end
end

BotUnitInput.dodge = function (self)
	self._dodge = true
end

local Quaternion_look = Quaternion.look
local Quaternion_multiply = Quaternion.multiply
local Quaternion_lerp = Quaternion.lerp
local MOVE_SCALE_START_DIST_SQ = 0.010000000000000002
local MOVE_SCALE_FACTOR = 99.995
local MOVE_SCALE_MIN = 5e-05
local STUCK_JUMP_SPEED_THRESHOLD = 0.2
local STUCK_CROUCH_SPEED_THRESHOLD = STUCK_JUMP_SPEED_THRESHOLD + 0.3
local STUCK_JUMP_SPEED_THRESHOLD_SQ = STUCK_JUMP_SPEED_THRESHOLD^2
local STUCK_CROUCH_SPEED_THRESHOLD_SQ = STUCK_CROUCH_SPEED_THRESHOLD^2
local JUMP_DOT_USE_WANTED_DIR_EPS_SQ = 1e-06
local MIN_JUMP_DIRECTION_DOT = math.cos(math.pi / 16)

BotUnitInput._update_movement = function (self, unit, input, dt, t)
	local navigation_extension = self._navigation_extension
	local current_goal = navigation_extension:current_goal()
	local is_on_nav_mesh = navigation_extension.is_on_nav_mesh
	local unit_position = POSITION_LOOKUP[unit]
	local position_on_navmesh = is_on_nav_mesh and navigation_extension:latest_position_on_nav_mesh() or unit_position
	local transition_jump = nil
	local first_person_component = self._first_person_component
	local camera_position = first_person_component.position
	local camera_rotation = first_person_component.rotation
	local wanted_rotation = nil
	local character_state_component = self._character_state_component
	local character_state_name = character_state_component.state_name
	local on_ladder = character_state_name == "ladder_climbing"
	local look_at_player_unit = ALIVE[self._look_at_player_unit] and self._look_at_player_unit or nil
	local look_at_player_has_moved = look_at_player_unit and ScriptUnit.extension(look_at_player_unit, "locomotion_system").has_moved_from_start_position
	local has_cinematic_finished = not Managers.state.cinematic:active()
	local up = Vector3.up()

	if current_goal and on_ladder then
		local ladder_character_state_component = self._ladder_character_state_component
		local ladder_unit_id = ladder_character_state_component.ladder_unit_id
		local ladder_unit = Managers.state.unit_spawner:unit(ladder_unit_id, true)
		local ladder_up = Quaternion.up(Unit.local_rotation(ladder_unit, 1))
		local direction = current_goal - unit_position
		local z = direction.z

		if math.abs(z) < 0.05 then
			wanted_rotation = camera_rotation
		elseif z < 0 then
			wanted_rotation = Quaternion_look(-ladder_up, up)
		else
			wanted_rotation = Quaternion_look(ladder_up, up)
		end
	elseif self._aiming and self._aim_with_rotation then
		wanted_rotation = self._aim_rotation:unbox()
	elseif self._aiming and self._soft_aiming then
		local direction = self._aim_position:unbox() - camera_position
		wanted_rotation = Quaternion_lerp(camera_rotation, Quaternion_look(direction, up), math.min(dt * 5, 1))
	elseif self._aiming then
		wanted_rotation = Quaternion_look(self._aim_position:unbox() - camera_position, up)
	elseif look_at_player_unit and (has_cinematic_finished or look_at_player_has_moved) and (not current_goal or not navigation_extension:is_in_transition()) then
		local look_rotation = self:_calculate_look_at_player_rotation(unit, camera_position, up)
		wanted_rotation = Quaternion_lerp(camera_rotation, look_rotation, math.min(dt * 5, 1))
	elseif current_goal then
		local direction = current_goal - position_on_navmesh
		local look_rotation = Quaternion_look(direction, up)

		if navigation_extension:is_in_transition() then
			transition_jump = navigation_extension:transition_requires_jump(position_on_navmesh)
			wanted_rotation = look_rotation
		else
			wanted_rotation = Quaternion_lerp(camera_rotation, look_rotation, math.min(dt * 5, 1))
		end
	else
		local unit_rotation = Unit.local_rotation(unit, 1)
		wanted_rotation = Quaternion_lerp(camera_rotation, unit_rotation, math.min(dt * 2, 1))
	end

	local player = self._player
	local wanted_yaw, wanted_pitch, wanted_roll = Quaternion.to_yaw_pitch_roll(wanted_rotation)

	player:set_orientation(wanted_yaw, wanted_pitch, wanted_roll)

	local flat_goal_vector, flat_goal_direction = nil

	if current_goal then
		local goal_vector = current_goal - position_on_navmesh
		flat_goal_vector = Vector3.flat(goal_vector)
		flat_goal_direction = Vector3.normalize(flat_goal_vector)

		if Vector3.length_squared(flat_goal_direction) > 0 and not on_ladder then
			local locomotion_component = self._locomotion_component
			local velocity_current = locomotion_component.velocity_current
			local current_speed_sq = Vector3.length_squared(velocity_current)
			local flat_velocity_current = Vector3.flat(velocity_current)
			local flat_velocity_current_direction = Vector3.normalize(flat_velocity_current)
			local movement_state_component = self._movement_state_component
			local is_crouching = movement_state_component.is_crouching
			local lower_hit, upper_hit = self:_obstacle_check(unit_position, current_speed_sq, goal_vector, flat_goal_direction, up)
			local transition_jump_valid = false

			if transition_jump then
				local bot_direction = current_speed_sq < JUMP_DOT_USE_WANTED_DIR_EPS_SQ and flat_goal_direction or flat_velocity_current_direction
				transition_jump_valid = MIN_JUMP_DIRECTION_DOT <= Vector3.dot(bot_direction, flat_goal_direction)
			end

			if lower_hit and not upper_hit or transition_jump_valid then
				input.jump = true
			elseif not lower_hit and upper_hit and (is_crouching or current_speed_sq <= STUCK_CROUCH_SPEED_THRESHOLD_SQ) then
				input.crouching = true
			end
		end
	end

	local group_extension = self._group_extension
	local bot_group_data = group_extension:bot_group_data()
	local threat_data = bot_group_data.aoe_threat
	local move = self._move

	if on_ladder then
		if current_goal then
			move.x = 0
			move.y = 1
		else
			input.jump = true
			move.x = 0
			move.y = 0
		end
	elseif t < threat_data.expires and threat_data.dodge_t < t then
		self:dodge()

		self._avoiding_aoe_threat = true
		local direction = threat_data.escape_direction:unbox()
		move.x = Vector3.dot(Quaternion.right(wanted_rotation), direction)
		move.y = Vector3.dot(Quaternion.forward(wanted_rotation), direction)
	elseif not current_goal then
		move.x = 0
		move.y = 0
	else
		local is_last_goal = navigation_extension:is_following_last_goal()
		local move_scale = 1

		if is_last_goal and not navigation_extension:is_in_transition() then
			local goal_dist_sq = Vector3.length_squared(flat_goal_vector)

			if goal_dist_sq < MOVE_SCALE_START_DIST_SQ then
				move_scale = MOVE_SCALE_FACTOR * goal_dist_sq + MOVE_SCALE_MIN
			end
		end

		local flat_right = Vector3.flat(Quaternion.right(wanted_rotation))
		local flat_forward = Vector3.flat(Quaternion.forward(wanted_rotation))
		move.x = move_scale * Vector3.dot(flat_right, flat_goal_direction)
		move.y = move_scale * Vector3.dot(flat_forward, flat_goal_direction)
	end

	if self._avoiding_aoe_threat and threat_data.expires <= t then
		if navigation_extension:destination_reached() then
			navigation_extension:stop()
		end

		self._avoiding_aoe_threat = false
	end
end

local EPSILON = 0.001

BotUnitInput._calculate_look_at_player_rotation = function (self, unit, camera_position, up)
	local look_at_player_first_person_component = self._look_at_player_first_person_component
	local player_camera_position = look_at_player_first_person_component.position
	local direction = player_camera_position - camera_position
	local look_rotation = Quaternion_look(direction, up)

	if not self._look_at_player_rotation_allowed then
		local unit_rotation = Unit.local_rotation(unit, 1)
		local delta_rotation = Quaternion_multiply(Quaternion.inverse(unit_rotation), look_rotation)
		local max_yaw = math.half_pi - EPSILON
		local yaw = math.clamp(Quaternion.yaw(delta_rotation), -max_yaw, max_yaw)
		local pitch = Quaternion.pitch(delta_rotation)
		local capped_delta_rotation = Quaternion.from_yaw_pitch_roll(yaw, pitch, 0)
		look_rotation = Quaternion_multiply(unit_rotation, capped_delta_rotation)
	end

	return look_rotation
end

BotUnitInput._obstacle_check = function (self, position, current_speed_sq, goal_vector, goal_direction, up)
	local physics_world = self._physics_world
	local collision_filter = "filter_player_mover"
	local forward_offset = 0.25
	local jump_range_check_epsilon = 0.05
	local width = 0.4
	local depth = math.abs(math.min(0.5, Vector3.length(goal_vector) - jump_range_check_epsilon))
	local height, half_extra_upper_depth, half_extra_upper_height = nil

	if STUCK_JUMP_SPEED_THRESHOLD_SQ < current_speed_sq then
		height = 0.4
		half_extra_upper_depth = 0.55
		half_extra_upper_height = (0.8 - height) * 0.5
	else
		height = 0.8
		half_extra_upper_depth = 0.1
		half_extra_upper_height = 0
	end

	local half_width = width * 0.5
	local half_depth = depth * 0.5
	local half_height = height * 0.5
	local half_upper_height = 0.25 + half_extra_upper_height
	local half_upper_depth = half_depth + half_extra_upper_depth
	local lower_check_pos = position + goal_direction * (half_depth + forward_offset) + Vector3(0, 0, 0.4 + half_height)
	local upper_check_pos = lower_check_pos + goal_direction * (half_upper_depth - half_depth) + Vector3(0, 0, half_upper_height + half_height)
	local lower_extents = Vector3(half_width, half_depth, half_height)
	local upper_extents = Vector3(half_width, half_upper_depth, half_upper_height)
	local rotation = Quaternion_look(goal_direction, up)
	local _, num_low_hit_actors = PhysicsWorld.immediate_overlap(physics_world, "shape", "oobb", "position", lower_check_pos, "rotation", rotation, "size", lower_extents, "types", "statics", "collision_filter", collision_filter)
	local lower_hit = num_low_hit_actors > 0
	local _, num_high_hit_actors = PhysicsWorld.immediate_overlap(physics_world, "shape", "oobb", "position", upper_check_pos, "rotation", rotation, "size", upper_extents, "types", "statics", "collision_filter", collision_filter)
	local upper_hit = num_high_hit_actors > 0

	return lower_hit, upper_hit
end

BotUnitInput.get_orientation = function (self)
	local player = self._player
	local orientation = player:get_orientation()

	return orientation.yaw, orientation.pitch, orientation.roll
end

BotUnitInput.get = function (self, action)
	if action == "move" then
		return Vector3(self._move.x, self._move.y, 0)
	elseif self._input[action] ~= nil then
		return self._input[action]
	end
end

return BotUnitInput
