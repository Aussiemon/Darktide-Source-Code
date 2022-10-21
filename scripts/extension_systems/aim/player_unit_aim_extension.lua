local SweepStickyness = require("scripts/utilities/action/sweep_stickyness")
local ThirdPersonAimAnimationControl = require("scripts/extension_systems/aim/third_person_aim_animation_control")
local ThirdPersonIdleFullbodyAnimationControl = require("scripts/extension_systems/aim/third_person_idle_fullbody_animation_control")
local ThirdPersonLookDeltaAnimationControl = require("scripts/extension_systems/aim/third_person_look_delta_animation_control")
local PlayerUnitAimExtension = class("PlayerUnitAimExtension")

PlayerUnitAimExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	local is_server = extension_init_context.is_server
	self._is_server = is_server
	local unit_data_ext = ScriptUnit.extension(unit, "unit_data_system")
	local fp_comp = unit_data_ext:read_component("first_person")
	self._first_person_component = fp_comp

	if is_server then
		local game_object_data = ...
		local aim_rotation = fp_comp.rotation
		game_object_data.aim_direction = Quaternion.forward(aim_rotation)
	else
		local game_session, game_object_id, owner_id = ...
		self._game_session_id = game_session
		self._game_object_id = game_object_id
	end

	self._using_unit_deafult_sm = true
	self._first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	self._aim_constraint_target_name = extension_init_data.aim_constraint_target_name
	self._aim_constraint_variable = nil
	self._aim_contraint_distance = extension_init_data.aim_constraint_distance
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	self._action_sweep_component = unit_data_extension:read_component("action_sweep")
	self._aim_animation_control = ThirdPersonAimAnimationControl:new(unit)
	self._idle_fullbody_animation_control = ThirdPersonIdleFullbodyAnimationControl:new(unit)
	self._look_delta_animation_control = ThirdPersonLookDeltaAnimationControl:new(unit)
	self._sticky_aim_position = Vector3Box()
	self._skticy_aim_blend = 0
end

PlayerUnitAimExtension.state_machine_changed = function (self, unit)
	self._aim_constraint_variable = Unit.animation_find_constraint_target(unit, self._aim_constraint_target_name)
end

PlayerUnitAimExtension.game_object_initialized = function (self, session, object_id)
	self._game_session_id = session
	self._game_object_id = object_id
end

PlayerUnitAimExtension.fixed_update = function (self, unit, dt, t, frame)
	if self._is_server then
		local aim_direction = Quaternion.forward(self._first_person_component.rotation)

		GameSession.set_game_object_field(self._game_session_id, self._game_object_id, "aim_direction", aim_direction)
		self._aim_animation_control:update(dt, t)
	end

	self._idle_fullbody_animation_control:update(dt, t)
	self._look_delta_animation_control:update(dt, t)
end

PlayerUnitAimExtension.update = function (self, unit, dt, t)
	if not self._aim_constraint_variable then
		return
	end

	local fp_ext = self._first_person_extension
	local height = fp_ext:extrapolated_character_height()
	local root_position = Unit.local_position(unit, 1) + height * Vector3.up()
	local aim_rotation = fp_ext:extrapolated_rotation()
	local direction = Quaternion.forward(aim_rotation)
	local aim_position = root_position + direction * self._aim_contraint_distance
	local sticky_aim_position = self._sticky_aim_position:unbox()
	local skticy_aim_blend = self._skticy_aim_blend or 0
	local action_sweep_component = self._action_sweep_component

	if action_sweep_component.is_sticky then
		local stycky_position = SweepStickyness.stick_to_position(action_sweep_component)

		if stycky_position then
			sticky_aim_position = root_position + Vector3.normalize(stycky_position - root_position) * self._aim_contraint_distance

			self._sticky_aim_position:store(sticky_aim_position)

			skticy_aim_blend = math.lerp(skticy_aim_blend, 1, dt * 16)
		end
	else
		skticy_aim_blend = math.lerp(skticy_aim_blend, 0, dt * 5)
	end

	self._skticy_aim_blend = skticy_aim_blend
	local new_aim_position = Vector3.lerp(aim_position, sticky_aim_position, skticy_aim_blend)

	Unit.animation_set_constraint_target(unit, self._aim_constraint_variable, new_aim_position)
end

return PlayerUnitAimExtension
