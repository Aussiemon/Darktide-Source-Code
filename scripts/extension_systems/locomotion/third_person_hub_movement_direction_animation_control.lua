local HubMovementLocomotion = require("scripts/extension_systems/locomotion/utilities/hub_movement_locomotion")
local ThirdPersonHubMovementDirectionAnimationControl = class("ThirdPersonHubMovementDirectionAnimationControl")

ThirdPersonHubMovementDirectionAnimationControl.init = function (self, unit, init_context)
	self._unit = unit
	self._player_character_constants = init_context.player_character_constants
	local is_local_unit = init_context.is_local_unit
	self._is_local_unit = is_local_unit
	local is_server = init_context.is_server
	self._is_server = is_server
	local is_husk = init_context.is_husk
	self._is_husk = is_husk

	if is_server or is_husk then
		self._game_session = init_context.game_session
		self._game_object_id = init_context.game_object_id
	end

	self._locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	self._hub_jog_character_state_component = unit_data_extension:read_component("hub_jog_character_state")

	if is_local_unit or is_server then
		self._locomotion_steering_component = unit_data_extension:read_component("locomotion_steering")
		self._locomotion_component = unit_data_extension:read_component("locomotion")
	end

	self._old_movement_direction = 0
end

ThirdPersonHubMovementDirectionAnimationControl.update = function (self, dt, t)
	local unit = self._unit
	local movement_settings = HubMovementLocomotion.fetch_movement_settings(unit, self._player_character_constants, self._hub_jog_character_state_component)
	local move_state_movement_settings = movement_settings.current_move_state
	local velocity_current_direction, velocity_wanted_direction = self:_directions()
	local movement_direction = self:_movement_direction(move_state_movement_settings, velocity_current_direction, velocity_wanted_direction, dt)

	self:_set_variables(unit, movement_direction)

	if self._is_server then
		local game_session = self._game_session
		local game_object_id = self._game_object_id

		GameSession.set_game_object_field(game_session, game_object_id, "velocity_current_direction", velocity_current_direction)
		GameSession.set_game_object_field(game_session, game_object_id, "velocity_wanted_direction", velocity_wanted_direction)
	end
end

ThirdPersonHubMovementDirectionAnimationControl._directions = function (self)
	if self._is_local_unit or self._is_server then
		local velocity_current_flat = Vector3.flat(self._locomotion_component.velocity_current)
		local velocity_wanted = self._locomotion_steering_component.velocity_wanted

		return Vector3.normalize(velocity_current_flat), Vector3.normalize(velocity_wanted)
	else
		local game_session = self._game_session
		local game_object_id = self._game_object_id
		local velocity_current_direction = GameSession.game_object_field(game_session, game_object_id, "velocity_current_direction")
		local velocity_wanted_direction = GameSession.game_object_field(game_session, game_object_id, "velocity_wanted_direction")

		return velocity_current_direction, velocity_wanted_direction
	end
end

ThirdPersonHubMovementDirectionAnimationControl._movement_direction = function (self, move_state_movement_settings, velocity_current_direction, velocity_wanted_direction, dt)
	local wanted_movement_direction = self:_wanted_movement_direction(move_state_movement_settings, velocity_current_direction, velocity_wanted_direction)
	local acceleration = move_state_movement_settings.acceleration
	local movement_direction_modifier = move_state_movement_settings.movement_direction_modifier
	local old_movement_direction = self._old_movement_direction
	local new_movement_direction = math.clamp(old_movement_direction + (wanted_movement_direction - old_movement_direction) * acceleration * dt * movement_direction_modifier, -1, 1)
	self._old_movement_direction = new_movement_direction

	return new_movement_direction
end

local IS_STOPPING_EPS = 0.01

ThirdPersonHubMovementDirectionAnimationControl._wanted_movement_direction = function (self, move_state_movement_settings, velocity_current_direction, velocity_wanted_direction)
	local move_speed_sq = self._locomotion_extension:move_speed_squared()
	local moving = move_speed_sq > 0

	if not moving then
		return 0, 0
	end

	local is_stopping = math.abs(velocity_wanted_direction.x) < IS_STOPPING_EPS and math.abs(velocity_wanted_direction.y) < IS_STOPPING_EPS

	if is_stopping then
		return 0, 0
	end

	local move_angle = Vector3.flat_angle(velocity_wanted_direction, velocity_current_direction)
	local allowed_turning_angle_rad = move_state_movement_settings.allowed_turning_angle_rad
	local movement_direction = math.clamp(move_angle / allowed_turning_angle_rad, -1, 1)

	return movement_direction
end

local MOVEMENT_DIRECTION_VARIABLE_NAME = "movement_direction"

ThirdPersonHubMovementDirectionAnimationControl._set_variables = function (self, unit, movement_direction)
	local animation_variable = Unit.animation_find_variable(unit, MOVEMENT_DIRECTION_VARIABLE_NAME)

	if animation_variable then
		Unit.animation_set_variable(unit, animation_variable, movement_direction)
	end
end

return ThirdPersonHubMovementDirectionAnimationControl
