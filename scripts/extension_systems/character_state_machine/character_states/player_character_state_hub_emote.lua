-- chunkname: @scripts/extension_systems/character_state_machine/character_states/player_character_state_hub_emote.lua

require("scripts/extension_systems/character_state_machine/character_states/player_character_state_base")

local PlayerCharacterStateHubEmote = class("PlayerCharacterStateHubEmote", "PlayerCharacterStateBase")
local ALLOW_TRIGGER_NEW_EMOTE = true
local ABORT_ON_MOVEMENT = true
local ABORT_ON_MOVEMENT_DELAY = 0.5

PlayerCharacterStateHubEmote.init = function (self, character_state_init_context, ...)
	PlayerCharacterStateHubEmote.super.init(self, character_state_init_context, ...)
end

PlayerCharacterStateHubEmote.on_enter = function (self, unit, dt, t, previous_state, params)
	PlayerCharacterStateHubEmote.super.on_enter(self, unit, dt, t, previous_state, params)

	self._unit_id = Managers.state.unit_spawner:game_object_id(unit)

	local emote_slot_id = params.emote_slot_id

	Managers.state.emote:trigger_emote(unit, emote_slot_id)
end

PlayerCharacterStateHubEmote.on_exit = function (self, unit, t, next_state)
	PlayerCharacterStateHubEmote.super.on_exit(self, unit, t, next_state)
end

PlayerCharacterStateHubEmote.fixed_update = function (self, unit, dt, t, next_state_params, fixed_frame)
	local input_extension = self._input_extension

	if ABORT_ON_MOVEMENT then
		local character_state_component = self._character_state_component
		local entered_t = character_state_component.entered_t

		if t >= entered_t + ABORT_ON_MOVEMENT_DELAY then
			local move_vector = input_extension:get("move")

			if Vector3.length_squared(move_vector) > 0 then
				Managers.state.emote:stop_emote(self._unit_id)
			end
		end
	end

	return self:_check_transition(unit, t, next_state_params, input_extension)
end

PlayerCharacterStateHubEmote._check_transition = function (self, unit, t, next_state_params, input_extension)
	if ALLOW_TRIGGER_NEW_EMOTE then
		local emote_slot_id = Managers.state.emote:check_emote_input(input_extension)

		if emote_slot_id then
			next_state_params.emote_slot_id = emote_slot_id

			return "hub_emote"
		end
	end

	if not Managers.state.emote:running_emote(self._unit_id) then
		return "hub_jog"
	end
end

return PlayerCharacterStateHubEmote
