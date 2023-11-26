-- chunkname: @scripts/extension_systems/character_state_machine/character_states/player_character_state_ledge_hanging_falling.lua

require("scripts/extension_systems/character_state_machine/character_states/player_character_state_base")

local FirstPersonView = require("scripts/utilities/first_person_view")
local HealthStateTransitions = require("scripts/extension_systems/character_state_machine/character_states/utilities/health_state_transitions")
local LagCompensation = require("scripts/utilities/lag_compensation")
local PlayerDeath = require("scripts/utilities/player_death")
local PlayerCharacterStateLedgeHangingFalling = class("PlayerCharacterStateLedgeHangingFalling", "PlayerCharacterStateBase")

PlayerCharacterStateLedgeHangingFalling.init = function (self, character_state_init_context, ...)
	PlayerCharacterStateLedgeHangingFalling.super.init(self, character_state_init_context, ...)
end

PlayerCharacterStateLedgeHangingFalling.on_enter = function (self, unit, dt, t, previous_state, params)
	if self._is_server then
		local reason = "ledge_hanging"

		PlayerDeath.die(unit, nil, nil, reason)
	end
end

PlayerCharacterStateLedgeHangingFalling.on_exit = function (self, unit, t, next_state)
	local first_person_mode_component = self._first_person_mode_component
	local rewind_ms = LagCompensation.rewind_ms(self._is_server, self._is_local_unit, self._player)

	FirstPersonView.enter(t, first_person_mode_component, rewind_ms)
end

PlayerCharacterStateLedgeHangingFalling.fixed_update = function (self, unit, dt, t, next_state_params, fixed_frame)
	return self:_check_transition(unit, t, next_state_params)
end

PlayerCharacterStateLedgeHangingFalling._check_transition = function (self, unit, t, next_state_params)
	local unit_data_extension = self._unit_data_extension
	local health_transition = HealthStateTransitions.poll(unit_data_extension, next_state_params)

	if health_transition == "dead" then
		return health_transition
	end
end

return PlayerCharacterStateLedgeHangingFalling
