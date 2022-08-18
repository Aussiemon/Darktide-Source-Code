require("scripts/extension_systems/character_state_machine/character_states/player_character_state_base")

local HangLedge = require("scripts/extension_systems/character_state_machine/character_states/utilities/hang_ledge")
local PlayerMovement = require("scripts/utilities/player_movement")
local PlayerCharacterStateLedgeHangingPullUp = class("PlayerCharacterStateLedgeHangingPullUp", "PlayerCharacterStateBase")

PlayerCharacterStateLedgeHangingPullUp.init = function (self, character_state_init_context, ...)
	PlayerCharacterStateLedgeHangingPullUp.super.init(self, character_state_init_context, ...)

	local unit_data_extension = character_state_init_context.unit_data
	local ledge_hanging_character_state_component = unit_data_extension:write_component("ledge_hanging_character_state")
	self._ledge_hanging_character_state_component = ledge_hanging_character_state_component
end

PlayerCharacterStateLedgeHangingPullUp.on_enter = function (self, unit, dt, t, previous_state, params)
	local hang_ledge_unit = self._ledge_hanging_character_state_component.hang_ledge_unit

	self:_teleport(unit, hang_ledge_unit)
	self:_restore_locomotion()
end

PlayerCharacterStateLedgeHangingPullUp.on_exit = function (self, unit, t, next_state)
	self._ledge_hanging_character_state_component.hang_ledge_unit = nil
end

PlayerCharacterStateLedgeHangingPullUp._restore_locomotion = function (self)
	local locomotion_steering = self._locomotion_steering_component
	locomotion_steering.move_method = "script_driven"
	locomotion_steering.calculate_fall_velocity = true
	locomotion_steering.disable_velocity_rotation = false
end

PlayerCharacterStateLedgeHangingPullUp.fixed_update = function (self, unit, dt, t, next_state_params, fixed_frame)
	return self:_check_transition(unit, t, next_state_params)
end

PlayerCharacterStateLedgeHangingPullUp._check_transition = function (self, unit, t, next_state_params)
	return "walking"
end

PlayerCharacterStateLedgeHangingPullUp._teleport = function (self, unit, hang_ledge_unit)
	if self._is_server then
		local new_position = HangLedge.calculate_pull_up_end_position(self._nav_world, hang_ledge_unit, unit)
		local rotation = Unit.local_rotation(unit, 1)

		PlayerMovement.teleport(self._player, new_position, rotation)
	end
end

return PlayerCharacterStateLedgeHangingPullUp
