-- chunkname: @scripts/extension_systems/character_state_machine/character_states/player_character_state_hub_companion_interaction.lua

local PlayerCharacterStateHubCompanionInteraction = class("PlayerCharacterStateHubCompanionInteraction", "PlayerCharacterStateBase")
local ABORT_ON_MOVEMENT = true
local ABORT_ON_MOVEMENT_DELAY = 0.5

PlayerCharacterStateHubCompanionInteraction.on_enter = function (self, unit, dt, t, previous_state, params)
	PlayerCharacterStateHubCompanionInteraction.super.on_enter(self, unit, dt, t, previous_state, params)

	self._unit_id = Managers.state.unit_spawner:game_object_id(unit)
end

PlayerCharacterStateHubCompanionInteraction.fixed_update = function (self, unit, dt, t, next_state_params, fixed_frame)
	local input_extension = self._input_extension

	if ABORT_ON_MOVEMENT then
		local character_state_component = self._character_state_component
		local entered_t = character_state_component.entered_t

		if t >= entered_t + ABORT_ON_MOVEMENT_DELAY then
			local move_vector = input_extension:get("move")

			if Vector3.length_squared(move_vector) > 0 then
				Managers.state.companion_interaction:interrupt_interaction_animation(unit)
				Managers.state.companion_interaction:stop_interaction(unit)
			end
		end
	end

	return self:_check_transition(unit, t, next_state_params, input_extension, fixed_frame)
end

PlayerCharacterStateHubCompanionInteraction._check_transition = function (self, unit, t, next_state_params, input_extension, fixed_frame)
	if not Managers.state.companion_interaction:is_player_interacting(unit) then
		return "hub_jog"
	end
end

return PlayerCharacterStateHubCompanionInteraction
