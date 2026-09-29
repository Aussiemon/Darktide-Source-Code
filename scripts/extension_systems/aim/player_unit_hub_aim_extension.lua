-- chunkname: @scripts/extension_systems/aim/player_unit_hub_aim_extension.lua

local HubAimConstraints = require("scripts/extension_systems/aim/utilities/hub_aim_constraints")
local HubAimConstraintSettings = require("scripts/settings/aim/hub_aim_constraint_settings")
local ThirdPersonAimAnimationControl = require("scripts/extension_systems/aim/third_person_aim_animation_control")
local ThirdPersonLookDeltaAnimationControl = require("scripts/extension_systems/aim/third_person_look_delta_animation_control")
local HORIZONTAL_WEIGHTS = HubAimConstraintSettings.horizontal_weight
local VERTICAL_WEIGHTS = HubAimConstraintSettings.vertical_weight
local PlayerUnitHubAimExtension = class("PlayerUnitHubAimExtension")
local STATES = HubAimConstraintSettings.states

PlayerUnitHubAimExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, nil_or_game_object_id)
	local is_server = extension_init_context.is_server

	self._is_server = is_server

	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

	self._locomotion_read_component = unit_data_extension:read_component("locomotion")
	self._locomotion_steering_read_component = unit_data_extension:read_component("locomotion_steering")
	self._hub_jog_character_state_component = unit_data_extension:read_component("hub_jog_character_state")

	local first_person_read_component = unit_data_extension:read_component("first_person")

	self._first_person_read_component = first_person_read_component

	if is_server then
		local aim_rotation = first_person_read_component.rotation

		game_object_data_or_game_session.aim_direction = Quaternion.forward(aim_rotation)
	else
		self._game_session_id = game_object_data_or_game_session
		self._game_object_id = nil_or_game_object_id
	end

	self._first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	self._aim_animation_control = ThirdPersonAimAnimationControl:new(unit)
	self._look_delta_animation_control = ThirdPersonLookDeltaAnimationControl:new(unit)
	self._init_context = {
		aim_constraint_target_name = extension_init_data.aim_constraint_target_name,
		aim_constraint_target_torso_name = extension_init_data.aim_constraint_target_torso_name,
		aim_constraint_distance = extension_init_data.aim_constraint_distance,
		head_aim_weight_name = extension_init_data.head_aim_weight_name,
		torso_aim_weight_name = extension_init_data.torso_aim_weight_name
	}
	self._hub_aim_constraints = nil
end

PlayerUnitHubAimExtension.state_machine_changed = function (self, unit)
	self._hub_aim_constraints = HubAimConstraints:new(unit, self._init_context)
end

PlayerUnitHubAimExtension.game_object_initialized = function (self, session, object_id)
	self._game_session_id = session
	self._game_object_id = object_id
end

PlayerUnitHubAimExtension.fixed_update = function (self, unit, dt, t, frame)
	if self._is_server then
		self._aim_animation_control:update(dt, t)
	end

	self._look_delta_animation_control:update(dt, t)
end

PlayerUnitHubAimExtension.update = function (self, unit, dt, t)
	local hub_aim_constraints = self._hub_aim_constraints

	if not hub_aim_constraints then
		return
	end

	local is_moving = hub_aim_constraints:is_moving()
	local head_direction, torso_direction, is_passive = self:_directions_and_passive_state(unit)
	local aim_state = self:_aim_state(self._hub_jog_character_state_component, is_passive)

	head_direction, torso_direction = self:_target_goal_positions(unit, head_direction, torso_direction, is_passive, is_moving)

	hub_aim_constraints:update(head_direction, torso_direction, is_moving, aim_state, dt, t)

	if self._is_server then
		local game_session_id = self._game_session_id
		local game_object_id = self._game_object_id

		GameSession.set_game_object_field(game_session_id, game_object_id, "hub_head_aim_direction", head_direction)
		GameSession.set_game_object_field(game_session_id, game_object_id, "hub_torso_aim_direction", torso_direction)
		GameSession.set_game_object_field(game_session_id, game_object_id, "hub_aim_state", aim_state)
	end
end

PlayerUnitHubAimExtension._directions_and_passive_state = function (self, unit)
	local unit_rotation = Unit.world_rotation(unit, 1)
	local aim_rotation = self._first_person_extension:extrapolated_rotation()
	local velocity_wanted = self._locomotion_steering_read_component.velocity_wanted
	local wanted_velocity_direction = Vector3.normalize(velocity_wanted)
	local angular_diff = Quaternion.angle(unit_rotation, aim_rotation)
	local is_passive = angular_diff > math.rad(HubAimConstraintSettings.passive_aim_angle_threshold)
	local head_direction, torso_direction

	if is_passive then
		if Vector3.length_squared(velocity_wanted) > 0 then
			head_direction = wanted_velocity_direction
			torso_direction = wanted_velocity_direction * 1
		else
			local unit_forward = Quaternion.forward(unit_rotation)

			head_direction = unit_forward
			torso_direction = unit_forward * 1
		end
	else
		local aim_forward = Quaternion.forward(aim_rotation)

		head_direction = aim_forward
		torso_direction = aim_forward * 1
	end

	return head_direction, torso_direction, is_passive
end

PlayerUnitHubAimExtension._aim_state = function (self, hub_jog_character_state_component, is_passive)
	if is_passive then
		return STATES.passive
	else
		local move_method = hub_jog_character_state_component.method

		if move_method == "moving" then
			local move_state = hub_jog_character_state_component.move_state

			return STATES[move_state] or STATES.passive
		else
			return STATES.idle
		end
	end
end

PlayerUnitHubAimExtension._target_goal_positions = function (self, unit, head_direction, torso_direction, is_passive, is_moving)
	local unit_rotation = Unit.world_rotation(unit, 1)
	local unit_forward = Quaternion.forward(unit_rotation)
	local head_unit_forward = Quaternion.rotate(Quaternion.axis_angle(Quaternion.right(unit_rotation), math.rad(HubAimConstraintSettings.head_look_up_offset)), unit_forward)
	local horizontal_weights, vertical_weights

	if is_moving then
		if is_passive then
			horizontal_weights = HORIZONTAL_WEIGHTS.moving_passive
			vertical_weights = VERTICAL_WEIGHTS.moving_passive
		else
			horizontal_weights = HORIZONTAL_WEIGHTS.moving
			vertical_weights = VERTICAL_WEIGHTS.moving
		end
	elseif is_passive then
		horizontal_weights = HORIZONTAL_WEIGHTS.passive
		vertical_weights = VERTICAL_WEIGHTS.passive
	else
		horizontal_weights = HORIZONTAL_WEIGHTS.idle
		vertical_weights = VERTICAL_WEIGHTS.idle
	end

	local h_head_w = horizontal_weights.head
	local h_torso_w = horizontal_weights.torso
	local v_head_w = vertical_weights.head
	local v_torso_w = vertical_weights.torso

	head_direction.x = (1 - h_head_w) * head_unit_forward.x + h_head_w * head_direction.x
	torso_direction.x = (1 - h_torso_w) * unit_forward.x + h_torso_w * torso_direction.x
	head_direction.y = (1 - h_head_w) * head_unit_forward.y + h_head_w * head_direction.y
	torso_direction.y = (1 - h_torso_w) * unit_forward.y + h_torso_w * torso_direction.y
	head_direction.z = (1 - v_head_w) * head_unit_forward.z + v_head_w * head_direction.z
	torso_direction.z = (1 - v_torso_w) * unit_forward.z + v_torso_w * torso_direction.z

	return Vector3.normalize(head_direction), Vector3.normalize(torso_direction)
end

return PlayerUnitHubAimExtension
