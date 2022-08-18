local ThirdPersonAimAnimationControl = require("scripts/extension_systems/aim/third_person_aim_animation_control")
local ThirdPersonIdleFullbodyAnimationControl = require("scripts/extension_systems/aim/third_person_idle_fullbody_animation_control")
local ThirdPersonLookDeltaAnimationControl = require("scripts/extension_systems/aim/third_person_look_delta_animation_control")
local PlayerHuskAimExtension = class("PlayerHuskAimExtension")

PlayerHuskAimExtension.init = function (self, extension_init_context, unit, extension_init_data, game_session, game_object_id, owner_id)
	self._aim_constraint_target_name = extension_init_data.aim_constraint_target_name
	self._aim_constraint_variable = nil
	self._game_session_id = game_session
	self._game_object_id = game_object_id
	self._aim_contraint_distance = extension_init_data.aim_constraint_distance
	self._aim_animation_control = ThirdPersonAimAnimationControl:new(unit)
	self._idle_fullbody_animation_control = ThirdPersonIdleFullbodyAnimationControl:new(unit)
	self._look_delta_animation_control = ThirdPersonLookDeltaAnimationControl:new(unit)
end

PlayerHuskAimExtension.state_machine_changed = function (self, unit)
	self._aim_constraint_variable = Unit.animation_find_constraint_target(unit, self._aim_constraint_target_name)

	self._idle_fullbody_animation_control:state_machine_changed(unit)
	self._look_delta_animation_control:state_machine_changed(unit)
end

PlayerHuskAimExtension.update = function (self, unit, dt, t)
	self._idle_fullbody_animation_control:update(dt, t)

	if not self._aim_constraint_variable then
		return
	end

	local game_session_id = self._game_session_id
	local game_object_id = self._game_object_id
	local aim_direction = GameSession.game_object_field(game_session_id, game_object_id, "aim_direction")
	local root_position = Unit.local_position(unit, 1)
	local height = GameSession.game_object_field(game_session_id, game_object_id, "character_height")
	local target_position = root_position + height * Vector3.up() + aim_direction * self._aim_contraint_distance

	Unit.animation_set_constraint_target(unit, self._aim_constraint_variable, target_position)
	self._aim_animation_control:update(dt, t)
	self._look_delta_animation_control:update(dt, t)
end

return PlayerHuskAimExtension
