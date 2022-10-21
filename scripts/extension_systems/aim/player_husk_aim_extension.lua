local SweepStickyness = require("scripts/utilities/action/sweep_stickyness")
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
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	self._action_sweep_component = unit_data_extension:read_component("action_sweep")
	self._sticky_aim_position_box = Vector3Box()
	self._skticy_aim_blend = 0
	local aim_direction = GameSession.game_object_field(game_session, game_object_id, "aim_direction")
	self._aim_direction_box = Vector3Box(aim_direction)
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
	local height = GameSession.game_object_field(game_session_id, game_object_id, "character_height")
	local root_position = Unit.local_position(unit, 1) + height * Vector3.up()
	local new_aim_direction = GameSession.game_object_field(game_session_id, game_object_id, "aim_direction")
	local old_aim_direction = self._aim_direction_box:unbox()
	local lerped_aim_direction = Vector3.lerp(old_aim_direction, new_aim_direction, dt * 10)

	self._aim_direction_box:store(lerped_aim_direction)

	local aim_position = root_position + lerped_aim_direction * self._aim_contraint_distance
	local sticky_aim_position = self._sticky_aim_position_box:unbox()
	local skticy_aim_blend = self._skticy_aim_blend or 0
	local action_sweep_component = self._action_sweep_component

	if action_sweep_component.is_sticky then
		local stycky_position = SweepStickyness.stick_to_position(action_sweep_component)

		if stycky_position then
			sticky_aim_position = root_position + Vector3.normalize(stycky_position - root_position) * self._aim_contraint_distance

			self._sticky_aim_position_box:store(sticky_aim_position)

			skticy_aim_blend = math.lerp(skticy_aim_blend, 1, dt * 16)
		end
	else
		skticy_aim_blend = math.lerp(skticy_aim_blend, 0, dt * 5)
	end

	self._skticy_aim_blend = skticy_aim_blend
	local new_aim_position = Vector3.lerp(aim_position, sticky_aim_position, skticy_aim_blend)

	Unit.animation_set_constraint_target(unit, self._aim_constraint_variable, new_aim_position)
	self._aim_animation_control:update(dt, t)
	self._look_delta_animation_control:update(dt, t)
end

return PlayerHuskAimExtension
