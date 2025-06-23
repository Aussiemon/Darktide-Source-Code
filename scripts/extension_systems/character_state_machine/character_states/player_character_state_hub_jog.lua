-- chunkname: @scripts/extension_systems/character_state_machine/character_states/player_character_state_hub_jog.lua

require("scripts/extension_systems/character_state_machine/character_states/player_character_state_base")

local HubMovementLocomotion = require("scripts/extension_systems/locomotion/utilities/hub_movement_locomotion")
local ScriptGui = require("scripts/foundation/utilities/script_gui")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local Crouch = require("scripts/extension_systems/character_state_machine/character_states/utilities/crouch")
local PI = math.pi
local TAU = PI * 2
local TAU_16TH = TAU / 16
local _anims_from_angle, _move_speed
local PlayerCharacterStateHubJog = class("PlayerCharacterStateHubJog", "PlayerCharacterStateBase")

PlayerCharacterStateHubJog.init = function (self, character_state_init_context, ...)
	PlayerCharacterStateHubJog.super.init(self, character_state_init_context, ...)

	local unit_data = self._unit_data_extension
	local hub_jog_character_state_component = unit_data:write_component("hub_jog_character_state")

	hub_jog_character_state_component.method = "idle"
	hub_jog_character_state_component.move_state = "walk"
	hub_jog_character_state_component.previous_move_state = "walk"
	hub_jog_character_state_component.move_state_start_t = 0
	hub_jog_character_state_component.force_old_input_end_t = 0
	hub_jog_character_state_component.force_old_input_start_t = 0
	hub_jog_character_state_component.move_start_delay_t = 0
	self._hub_jog_character_state_component = hub_jog_character_state_component
	self._movement_method = hub_jog_character_state_component.method

	local hub_movement = self._constants.hub_movement

	self._move_method_anims = hub_movement.move_method_anims
end

PlayerCharacterStateHubJog.on_enter = function (self, unit, dt, t, previous_state, params)
	PlayerCharacterStateHubJog.super.on_enter(self, unit, dt, t, previous_state, params)

	local locomotion_steering = self._locomotion_steering_component

	locomotion_steering.move_method = "script_driven_hub"
	locomotion_steering.calculate_fall_velocity = true
	locomotion_steering.rotation_based_on_wanted_velocity = false
	locomotion_steering.hub_active_stopping = false

	local mover = Unit.mover(unit)
	local hub_movement_settings = HubMovementLocomotion.fetch_movement_settings(self._unit, self._constants, self._hub_jog_character_state_component)
	local movement_settings_shared, _ = hub_movement_settings.shared, hub_movement_settings.current_move_state
	local max_slope_angle = math.degrees_to_radians(movement_settings_shared.mover_max_slope_angle)

	Mover.set_max_slope_angle(mover, max_slope_angle)
end

PlayerCharacterStateHubJog.on_exit = function (self, unit, t, next_state)
	PlayerCharacterStateHubJog.super.on_exit(self, unit, t, next_state)
end

PlayerCharacterStateHubJog.fixed_update = function (self, unit, dt, t, next_state_params, fixed_frame)
	local anim_extension = self._animation_extension
	local locomotion_steering = self._locomotion_steering_component
	local locomotion = self._locomotion_component
	local input_extension = self._input_extension
	local first_person = self._first_person_component
	local hub_jog_character_state = self._hub_jog_character_state_component
	local velocity_current = locomotion.velocity_current
	local hub_movement_settings = HubMovementLocomotion.fetch_movement_settings(self._unit, self._constants, hub_jog_character_state)
	local move_state_movement_settings = hub_movement_settings.current_move_state
	local shared_movement_settings = hub_movement_settings.shared
	local old_move_x, old_move_y = locomotion_steering.local_move_x, locomotion_steering.local_move_y
	local move_direction, move_speed, new_x, new_y, wants_move, stopping, active_stopping, wants_turn_on_spot = self:_wanted_movement(unit, move_state_movement_settings, shared_movement_settings, input_extension, velocity_current, first_person, hub_jog_character_state, old_move_x, old_move_y, dt, t)
	local velocity_wanted = move_direction * move_speed

	locomotion_steering.velocity_wanted = velocity_wanted
	locomotion_steering.local_move_x = new_x
	locomotion_steering.local_move_y = new_y
	locomotion_steering.hub_active_stopping = active_stopping

	if wants_turn_on_spot then
		locomotion_steering.target_rotation = Quaternion.look(move_direction)
	elseif self._movement_method == "idle" then
		local current_speed_sq = Vector3.length_squared(velocity_current)

		if current_speed_sq > 0.01 then
			locomotion_steering.target_rotation = locomotion.rotation
		end
	end

	local move_state = self:_update_move_state(hub_jog_character_state, input_extension, anim_extension, move_speed, stopping, dt, t)
	local method_changed, move_method = self:_update_move_method(move_state, hub_jog_character_state, locomotion, locomotion_steering, stopping, wants_move, wants_turn_on_spot, anim_extension, velocity_wanted, velocity_current, t)
	local next_state = self:_check_transition(unit, t, next_state_params, input_extension)

	return next_state
end

local move_state_anim_events = {
	sprint = "to_sprint",
	jog = "to_jog",
	walk = "to_walk"
}

PlayerCharacterStateHubJog._update_move_state = function (self, hub_jog_character_state, input_extension, anim_extension, move_speed, wants_to_stop, dt, t)
	local hub_movement_settings = HubMovementLocomotion.fetch_movement_settings(self._unit, self._constants, hub_jog_character_state)
	local shared_movement_settings = hub_movement_settings.shared
	local current_movement_method = self._movement_method
	local current_move_state = hub_jog_character_state.move_state
	local move_state_start_t = hub_jog_character_state.move_state_start_t
	local time_in_move_state = t - move_state_start_t
	local move_state_force_timings = shared_movement_settings.move_state_force_timings
	local force_timing = move_state_force_timings[current_move_state]
	local forced_move_state = time_in_move_state < force_timing
	local move_state = current_move_state

	if not forced_move_state then
		local is_sprinting = current_move_state == "sprint" and not wants_to_stop
		local is_walking = current_move_state == "walk" and not wants_to_stop

		if Sprint.sprint_input(input_extension, is_sprinting, false) then
			move_state = "sprint"
		elseif Crouch.crouch_input(input_extension, is_walking, false, false) then
			move_state = "walk"
		elseif not wants_to_stop or current_movement_method == "idle" then
			move_state = "jog"
		end
	end

	if move_state ~= current_move_state then
		local anim_event = move_state_anim_events[move_state]

		anim_extension:anim_event(anim_event)

		hub_jog_character_state.previous_move_state = current_move_state
		hub_jog_character_state.move_state = move_state
		hub_jog_character_state.move_state_start_t = t
	end

	return move_state
end

PlayerCharacterStateHubJog._wanted_movement = function (self, unit, move_state_movement_settings, shared_movement_settings, input_extension, velocity_current, first_person, hub_jog_character_state, old_move_x, old_move_y, dt, t)
	local move_input = input_extension:get("move")
	local input_x, input_y = move_input.x, move_input.y
	local old_wants_move = math.abs(old_move_x) > 0 or math.abs(old_move_y) > 0
	local input_wants_move = math.abs(input_x) > 0 or math.abs(input_y) > 0
	local force_old_end_t = hub_jog_character_state.force_old_input_end_t
	local input_move_direction = self:_input_to_move_direction(input_x, input_y, first_person)
	local current_move_direction, moving = self:_current_direction(self._locomotion_component)
	local input_flat_angle = Vector3.flat_angle(current_move_direction, input_move_direction)
	local inside_180_turnaround_space = false

	if moving and input_wants_move and not old_wants_move then
		local abs_input_flat_angle = math.abs(input_flat_angle)

		inside_180_turnaround_space = abs_input_flat_angle > shared_movement_settings.moving_turnaround_angle_rad
	end

	local wanted_move_direction, wanted_x, wanted_y
	local should_force_old_input = t < force_old_end_t and not inside_180_turnaround_space

	if should_force_old_input then
		wanted_move_direction = self:_input_to_move_direction(old_move_x, old_move_y, first_person)
		wanted_x, wanted_y = old_move_x, old_move_y
	else
		wanted_move_direction = input_move_direction
		wanted_x, wanted_y = input_x, input_y
	end

	local move_direction, new_x, new_y, active_stopping = self:_move_direction(wanted_move_direction, current_move_direction, wanted_x, wanted_y, moving, move_state_movement_settings, shared_movement_settings)
	local move_speed, stopping = _move_speed(move_state_movement_settings, move_direction, new_x, new_y)
	local wants_move = math.abs(move_direction.x) > 0 or math.abs(move_direction.y) > 0

	if wants_move ~= old_wants_move then
		local timer

		if wants_move then
			timer = move_state_movement_settings.repeat_move_input_timer
		else
			timer = move_state_movement_settings.repeat_no_move_input_timer
		end

		hub_jog_character_state.force_old_input_end_t = t + timer
		hub_jog_character_state.force_old_input_start_t = t
	end

	if not old_wants_move and input_wants_move then
		hub_jog_character_state.move_start_delay_t = t + shared_movement_settings.turn_in_place_timeout
	end

	local wants_turn_on_spot = false

	if t <= hub_jog_character_state.move_start_delay_t then
		if old_wants_move and not input_wants_move then
			wants_turn_on_spot = true
		end

		move_speed = 0
		wants_move = false
	end

	return move_direction, move_speed, new_x, new_y, wants_move, stopping, active_stopping, wants_turn_on_spot
end

PlayerCharacterStateHubJog._input_to_move_direction = function (self, x, y, first_person_component)
	local look_rotation = first_person_component.rotation
	local right = Quaternion.right(look_rotation)
	local flat_look_direction = Vector3.cross(right, Vector3.down())
	local local_move_direction = Vector3.normalize(Vector3(x, y, 0))
	local flat_look_rotation = Quaternion.look(flat_look_direction, Vector3.up())

	return Quaternion.rotate(flat_look_rotation, local_move_direction)
end

PlayerCharacterStateHubJog._current_direction = function (self, locomotion_component)
	local velocity_current = locomotion_component.velocity_current
	local velocity_current_flat = Vector3.flat(velocity_current)
	local velocity_current_flat_dir = Vector3.normalize(velocity_current_flat)
	local moving = Vector3.length_squared(velocity_current_flat) > 0
	local locomotion_rotation = locomotion_component.rotation
	local loc_forward = Quaternion.forward(locomotion_rotation)
	local current_direction = moving and velocity_current_flat_dir or loc_forward

	return current_direction, moving
end

local TURNING_WEIRDNESS_RAD_EPS = 0.001
local CORRECTION_RAD = PI / 15
local TURNING_WEIRDNESS_COS_L = math.cos(-CORRECTION_RAD)
local TURNING_WEIRDNESS_SIN_L = math.sin(-CORRECTION_RAD)

PlayerCharacterStateHubJog._move_direction = function (self, wanted_move_direction, current_move_direction, wanted_x, wanted_y, moving, move_state_movement_settings, shared_movement_settings)
	local flat_angle = Vector3.flat_angle(current_move_direction, wanted_move_direction)
	local abs_flat_angle = math.abs(flat_angle)
	local active_stopping = false
	local is_stopping = wanted_x == 0 and wanted_y == 0
	local allowed_turning_angle_rad = move_state_movement_settings.allowed_turning_angle_rad

	if moving and not is_stopping then
		local larger_than_turning_angle = allowed_turning_angle_rad < abs_flat_angle
		local inside_180_turnaround_space = abs_flat_angle > shared_movement_settings.moving_turnaround_angle_rad

		if inside_180_turnaround_space then
			wanted_move_direction.x = 0
			wanted_move_direction.y = 0
			active_stopping = true
		elseif larger_than_turning_angle then
			local current_x, current_y = current_move_direction.x, current_move_direction.y
			local turning_angle = allowed_turning_angle_rad * math.sign(flat_angle)
			local angle_cos = math.cos(turning_angle)
			local angle_sin = math.sin(turning_angle)
			local turning_x = current_x * angle_cos - current_y * angle_sin
			local turning_y = current_x * angle_sin + current_y * angle_cos

			wanted_move_direction.x = turning_x
			wanted_move_direction.y = turning_y
		end
	end

	local wants_move = not is_stopping

	if wants_move and math.abs(abs_flat_angle - PI) < TURNING_WEIRDNESS_RAD_EPS then
		local wanted_move_x, wanted_move_y = wanted_move_direction.x, wanted_move_direction.y
		local cos = TURNING_WEIRDNESS_COS_L
		local sin = TURNING_WEIRDNESS_SIN_L
		local modified_x = wanted_move_x * cos - wanted_move_y * sin
		local modified_y = wanted_move_x * sin + wanted_move_y * cos

		wanted_move_direction.x = modified_x
		wanted_move_direction.y = modified_y
	end

	local move_direction = wanted_move_direction
	local x = wanted_x
	local y = wanted_y

	return move_direction, x, y, active_stopping
end

local STOP_VARIATION_VARIABLE_NAME = "stop_variation"
local NUM_STOP_VARIATIONS = 3

PlayerCharacterStateHubJog._update_move_method = function (self, move_state, hub_jog_character_state, locomotion, locomotion_steering, stopping, wants_move, wants_turn_on_spot, anim_extension, velocity_wanted, velocity_current, t)
	local old_method = self._movement_method
	local move_method

	move_method = wants_turn_on_spot and "turn_on_spot" or stopping and "idle" or wants_move and "moving" or "idle"

	local method_changed = move_method ~= old_method

	if method_changed then
		local move_method_anims = self._move_method_anims[move_method]
		local from_movement_turn_anims = move_method_anims.from_movement_turn_anims
		local from_still_turn_anims = move_method_anims.from_still_turn_anims
		local from_movement_stop_anims = move_method_anims.from_movement_stop_anims
		local anim, variable_name, variable_value
		local moving = Vector3.length_squared(velocity_current) > 0
		local angle

		if moving and from_movement_turn_anims then
			local velocity_current_flat_dir = Vector3.normalize(Vector3.flat(velocity_current))

			angle = Vector3.flat_angle(velocity_wanted, velocity_current_flat_dir)
			anim = _anims_from_angle(angle, from_movement_turn_anims)
		elseif (stopping or moving) and from_movement_stop_anims then
			anim = from_movement_stop_anims[move_state]
			variable_name = STOP_VARIATION_VARIABLE_NAME
			variable_value = math.random(1, NUM_STOP_VARIATIONS)
		elseif from_still_turn_anims then
			local rotation = locomotion.rotation

			if move_method == "turn_on_spot" then
				velocity_wanted = Quaternion.forward(locomotion_steering.target_rotation)
			end

			local character_forward = Quaternion.forward(rotation)

			angle = Vector3.flat_angle(velocity_wanted, character_forward)
			anim = _anims_from_angle(angle, from_still_turn_anims)
		end

		self._movement_method = move_method

		if anim then
			if variable_name then
				anim_extension:anim_event_with_variable_int(anim, variable_name, variable_value)
			elseif angle then
				anim_extension:anim_event_with_variable_float(anim, "start_angle", math.deg(angle) / 180)
			else
				anim_extension:anim_event(anim)
			end
		end

		hub_jog_character_state.method = move_method
	end

	return method_changed, move_method
end

PlayerCharacterStateHubJog._check_transition = function (self, unit, t, next_state_params, input_extension)
	local emote_slot_id = Managers.state.emote:check_emote_input(input_extension)

	if emote_slot_id then
		next_state_params.emote_slot_id = emote_slot_id

		return "hub_emote"
	end

	local is_player_interacting = Managers.state.companion_interaction:is_player_interacting(unit)

	if is_player_interacting then
		return "hub_companion_interaction"
	end
end

function _anims_from_angle(angle, anims)
	local left = angle < 0
	local abs_angle = math.abs(angle)

	if abs_angle < TAU_16TH then
		return anims.forward
	elseif abs_angle < TAU_16TH * 3 then
		return left and anims.left_45 or anims.right_45
	elseif abs_angle < TAU_16TH * 5 then
		return left and anims.left_90 or anims.right_90
	elseif abs_angle < TAU_16TH * 7 then
		return left and anims.left_135 or anims.right_135
	else
		return left and anims.left_180 or anims.right_180
	end
end

function _move_speed(move_state_movement_settings, move_direction, new_x, new_y)
	local stopping = new_x == 0 and new_y == 0
	local speed_scale = stopping and 0 or 1
	local max_move_speed = move_state_movement_settings.move_speed

	return max_move_speed * speed_scale, stopping
end

return PlayerCharacterStateHubJog
