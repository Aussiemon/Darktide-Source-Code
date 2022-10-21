require("scripts/extension_systems/character_state_machine/character_states/player_character_state_base")

local DisruptiveStateTransition = require("scripts/extension_systems/character_state_machine/character_states/utilities/disruptive_state_transition")
local ForceRotation = require("scripts/extension_systems/locomotion/utilities/force_rotation")
local HealthStateTransitions = require("scripts/extension_systems/character_state_machine/character_states/utilities/health_state_transitions")
local Ladder = require("scripts/extension_systems/character_state_machine/character_states/utilities/ladder")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local PlayerCharacterStateLadderClimbing = class("PlayerCharacterStateLadderClimbing", "PlayerCharacterStateBase")
local move_methods = table.enum("ladder_climbing", "ladder_idle")
local Z_MOVE_EPSILON = 0.01
local END_REACH_EPSILON = 0.05
local RUNG_DISTANCE = 0.35
local DOUBLE_RUNG_DISTANCE = RUNG_DISTANCE * 2
local INVENTORY_SLOT_TO_WIELD = "slot_unarmed"
local LADDER_TOP_NODE = "node_top"
local LADDER_BOTTOM_NODE = "node_bottom"
local LADDER_LEAVE_NODE = "node_leave"
local CLIMBING_HAND_SOUND_ALIAS = "ladder_climbing_hands"
local CLIMBING_FEET_SOUND_ALIAS = "ladder_climbing_feet"

PlayerCharacterStateLadderClimbing._on_enter_animation = function (self, unit, previous_state)
	local animation_extension = self._animation_extension

	if previous_state ~= "ladder_top_entering" then
		animation_extension:anim_event("climb_enter_ladder")
		animation_extension:anim_event_1p("arms_down")
	end
end

PlayerCharacterStateLadderClimbing.init = function (self, character_state_init_context, ...)
	PlayerCharacterStateLadderClimbing.super.init(self, character_state_init_context, ...)

	self._earliest_next_footstep = 0
end

PlayerCharacterStateLadderClimbing.on_enter = function (self, unit, dt, t, previous_state, params)
	local ladder_unit = params.ladder_unit
	local locomotion_steering = self._locomotion_steering_component
	locomotion_steering.move_method = "script_driven"
	locomotion_steering.calculate_fall_velocity = false

	if previous_state ~= "ladder_top_entering" then
		local ladder_character_state_component = self._ladder_character_state_component
		local game_session = Managers.state.game_session:game_session()

		Ladder.started_climbing(ladder_character_state_component, ladder_unit, self._is_server, game_session, self._game_object_id, self._player, unit)

		local force_rotation = Unit.world_rotation(ladder_unit, 1)
		local start_rotation = Unit.world_rotation(unit, 1)

		ForceRotation.start(self._locomotion_force_rotation_component, locomotion_steering, force_rotation, start_rotation, t, 0.25)
	end

	if self._inventory_component.wielded_slot ~= "slot_unarmed" then
		PlayerUnitVisualLoadout.wield_slot(INVENTORY_SLOT_TO_WIELD, unit, t)
	end

	self:_on_enter_animation(unit, previous_state)
end

PlayerCharacterStateLadderClimbing.on_exit = function (self, unit, t, next_state)
	if next_state ~= "ladder_top_leaving" then
		ForceRotation.stop(self._locomotion_force_rotation_component)
		self._animation_extension:anim_event("climb_end_ladder")

		local ladder_character_state_component = self._ladder_character_state_component
		local game_session = Managers.state.game_session:game_session()
		local is_jumping = next_state == "jumping"
		local constants = self._constants
		local ladder_cooldown = t + (is_jumping and constants.ladder_jumping_cooldown or constants.ladder_cooldown)

		Ladder.stopped_climbing(ladder_character_state_component, ladder_cooldown, self._is_server, game_session, self._game_object_id, self._player, unit)

		local inventory_component = self._inventory_component

		if inventory_component.wielded_slot == "slot_unarmed" then
			PlayerUnitVisualLoadout.wield_previous_slot(inventory_component, unit, t)
		end
	end
end

PlayerCharacterStateLadderClimbing.update = function (self, unit, dt, t)
	local ladder_unit = Managers.state.unit_spawner:unit(self._ladder_character_state_component.ladder_unit_id, true)
	local velocity_current = self._locomotion_component.velocity_current
	local first_person_position = self._first_person_component.position
	local locomotion_position = self._locomotion_component.position

	self:_on_ladder_footsteps(t, unit, velocity_current, first_person_position, locomotion_position, ladder_unit)
end

PlayerCharacterStateLadderClimbing.fixed_update = function (self, unit, dt, t, next_state_params, fixed_frame)
	local ladder_unit = Managers.state.unit_spawner:unit(self._ladder_character_state_component.ladder_unit_id, true)
	local velocity_current = self._locomotion_component.velocity_current

	self:_on_ladder_animation(unit, velocity_current, ladder_unit, self._animation_extension)

	local move = self._input_extension:get("move")
	local move_x = move.x
	local move_y = move.y
	local player_rotation = self._first_person_component.rotation
	local ladder_rotation = Unit.world_rotation(ladder_unit, 1)
	local _, velocity = self:_move_on_ladder(move_x, move_y, player_rotation, ladder_rotation, unit, ladder_unit)
	self._locomotion_steering_component.velocity_wanted = velocity
	local transition = self:_check_transition(unit, ladder_unit, t, next_state_params)

	return transition
end

PlayerCharacterStateLadderClimbing._check_transition = function (self, unit, ladder_unit, t, next_state_params)
	local unit_data_extension = self._unit_data_extension
	local health_transition = HealthStateTransitions.poll(unit_data_extension, next_state_params)

	if health_transition then
		return health_transition
	end

	local disruptive_transition = DisruptiveStateTransition.poll(unit, unit_data_extension, next_state_params)

	if disruptive_transition then
		if disruptive_transition == "catapulted" then
			return "catapulted"
		end

		next_state_params.ladder_unit = ladder_unit
		next_state_params.is_distrupted = true

		return "jumping"
	end

	local locomotion = self._locomotion_component
	local velocity_current = locomotion.velocity_current
	local mover = Unit.mover(unit)

	if Mover.collides_down(mover) and velocity_current.z < 0 then
		return "walking"
	end

	local input_ext = self._input_extension

	if input_ext:get("jump") then
		next_state_params.ladder_unit = ladder_unit

		return "jumping"
	end

	local locomotion_position = locomotion.position
	local position = locomotion_position
	local climb_rotation = Unit.world_rotation(ladder_unit, 1)
	local reached_top = self:_have_reached_top(position, ladder_unit, velocity_current, climb_rotation)

	if reached_top then
		next_state_params.ladder_unit = ladder_unit

		return "ladder_top_leaving"
	end

	local colliding = self:_should_climb_ladder(unit, t)

	if not colliding then
		local ladder_top_pos = Unit.world_position(ladder_unit, Unit.node(ladder_unit, LADDER_TOP_NODE))
		local above_climb_off_height = ladder_top_pos.z < position.z

		if above_climb_off_height and velocity_current.z > 0 then
			next_state_params.ladder_unit = ladder_unit

			return "ladder_top_leaving"
		else
			return "falling"
		end
	end

	return nil
end

PlayerCharacterStateLadderClimbing._move_on_ladder = function (self, move_x, move_y, player_rotation, ladder_rotation, unit, ladder_unit)
	local bottom_pos = Unit.world_position(ladder_unit, Unit.node(ladder_unit, LADDER_BOTTOM_NODE))
	local top_pos = Unit.world_position(ladder_unit, Unit.node(ladder_unit, LADDER_TOP_NODE))
	local first_person_position = self._first_person_component.position
	local closest_point_on_climb_line = Geometry.closest_point_on_line(first_person_position, bottom_pos, top_pos)
	local ladder_rot = Unit.world_rotation(ladder_unit, 1)
	local ladder_forward = Quaternion.forward(ladder_rot)
	local plane_normal = Quaternion.forward(ladder_rot)
	local vector = closest_point_on_climb_line - first_person_position
	local projected_vector = Vector3.project_on_plane(vector, plane_normal)
	local distance_from_center = Vector3.length(projected_vector)
	local move_x_sign = math.sign(move_x)
	local percentage_to_increase_x_input = distance_from_center / 0.75
	local is_left = Vector3.cross(vector, ladder_forward).z > 0

	if is_left and move_x_sign == -1 then
		percentage_to_increase_x_input = 0
	elseif not is_left and move_x_sign == 1 then
		percentage_to_increase_x_input = 0
	end

	local first_person_to_climb_line = closest_point_on_climb_line - first_person_position
	local climb_line_dir = Vector3.normalize(first_person_to_climb_line)
	local player_forward = Quaternion.forward(player_rotation)
	local facing_ladder = Vector3.dot(player_forward, climb_line_dir) > 0
	local constants = self._constants
	local player_pitch = Quaternion.pitch(player_rotation)
	local pitch_value = player_pitch + constants.climb_pitch_offset
	local speed_lerp_interval = math.degrees_to_radians(constants.climb_speed_lerp_interval)
	pitch_value = math.clamp(math.auto_lerp(-speed_lerp_interval, speed_lerp_interval, -1, 1, pitch_value), -1, 1)
	local looking_down = pitch_value < 0
	local has_movement_x = math.abs(move_x) > 0
	local has_movement_y = math.abs(move_y) > 0
	local has_movement = has_movement_x or has_movement_y
	local moving_forward = move_y > 0
	local moving_backward = not moving_forward
	local mover_collides_down = Mover.collides_down(Unit.mover(unit))
	local on_ground = mover_collides_down and (looking_down and moving_forward or moving_backward)
	local x_input, y_input = nil

	if on_ground then
		x_input = move_x * percentage_to_increase_x_input
		y_input = move_y
	else
		x_input = move_x * percentage_to_increase_x_input

		if not facing_ladder then
			x_input = -x_input
		end

		if has_movement_y then
			local percentage_to_increase_y_input = nil

			if not looking_down then
				percentage_to_increase_y_input = 1 - (1 - pitch_value) * (1 - pitch_value)
			else
				percentage_to_increase_y_input = -1 + (-1 - pitch_value) * (-1 - pitch_value)
			end

			y_input = move_y * percentage_to_increase_y_input

			if not has_movement_x then
				x_input = is_left and 1 * percentage_to_increase_x_input or -1 * percentage_to_increase_x_input
			end
		else
			y_input = move_y
		end
	end

	local direction = nil

	if on_ground then
		local flat_player_rotation = Quaternion.look(Vector3.flat(Quaternion.forward(player_rotation)), Vector3.up())
		direction = Quaternion.rotate(flat_player_rotation, Vector3(x_input, y_input, 0))
	else
		direction = Quaternion.rotate(ladder_rotation, Vector3(x_input, 0, y_input))
	end

	local max_speed = constants.climb_speed
	local velocity = direction * max_speed

	return has_movement, velocity
end

PlayerCharacterStateLadderClimbing._have_reached_top = function (self, position, ladder_unit, velocity, climb_rotation)
	local top_pos = Unit.world_position(ladder_unit, Unit.node(ladder_unit, LADDER_TOP_NODE))
	local first_person_position = self._first_person_component.position
	local delta = top_pos.z - first_person_position.z
	local has_reached_top = delta <= END_REACH_EPSILON
	local velocity_dir = Vector3.normalize(velocity)
	local climbing_up = Quaternion.up(climb_rotation)
	local dot = Vector3.dot(velocity_dir, climbing_up)
	local moving_in_climbing_direction = dot > 0.7

	if has_reached_top and moving_in_climbing_direction then
		return true
	end
end

PlayerCharacterStateLadderClimbing._on_ladder_animation = function (self, unit, velocity, ladder_unit, animation_extension)
	local movement_state = self._movement_state_component
	local move_method = movement_state.method
	local moving = Z_MOVE_EPSILON < math.abs(velocity.z)

	if not moving and move_method ~= move_methods.ladder_idle then
		movement_state.method = move_methods.ladder_idle

		animation_extension:anim_event("climb_idle")
	elseif moving and move_method ~= move_methods.ladder_climbing then
		movement_state.method = move_methods.ladder_climbing

		animation_extension:anim_event("climb_move_ladder")
	end
end

local FOOTSTEP_MIN_INTERVAL = 0.1

PlayerCharacterStateLadderClimbing._on_ladder_footsteps = function (self, t, unit, velocity, position_1p, position_3p, ladder_unit)
	if self._earliest_next_footstep <= t then
		local bottom_pos = Unit.world_position(ladder_unit, Unit.node(ladder_unit, LADDER_BOTTOM_NODE))
		local distance_from_bottom = position_3p.z - bottom_pos.z
		local closest_rung_index = math.round(distance_from_bottom / DOUBLE_RUNG_DISTANCE)
		local closest_rung_height = closest_rung_index * DOUBLE_RUNG_DISTANCE
		local distance_to_closest_rung = distance_from_bottom - closest_rung_height
		local is_on_rung = math.abs(distance_to_closest_rung) < RUNG_DISTANCE * 0.05

		if not is_on_rung and self._was_on_rung then
			self._earliest_next_footstep = t + FOOTSTEP_MIN_INTERVAL
			local hand_position = bottom_pos + Vector3.up() * (position_1p.z - bottom_pos.z)
			local foot_position = bottom_pos + Vector3.up() * (position_3p.z - bottom_pos.z + DOUBLE_RUNG_DISTANCE)

			self:_trigger_climb_sound("ladder_climbing_hands", hand_position)
			self:_trigger_climb_sound("ladder_climbing_feet", foot_position)
		end

		self._was_on_rung = is_on_rung
	end
end

PlayerCharacterStateLadderClimbing._trigger_climb_sound = function (self, sound_alias, position)
	local _, event_name, has_husk_events = self._visual_loadout_extension:resolve_gear_sound(sound_alias)
	local is_predicted = true

	self._fx_extension:trigger_wwise_event_synced(event_name, has_husk_events, is_predicted, nil, nil, nil, position, nil, nil, nil, nil, nil)
end

PlayerCharacterStateLadderClimbing._should_climb_ladder = function (self, unit, t)
	local collision_filter = "filter_ladder_climb_collision"
	local colliding, ladder_unit = self:_is_colliding_with_gameplay_collision_box(unit, collision_filter)

	if not colliding then
		return false
	end

	return true, ladder_unit
end

return PlayerCharacterStateLadderClimbing
