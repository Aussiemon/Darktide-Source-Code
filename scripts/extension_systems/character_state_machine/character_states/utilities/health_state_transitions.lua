-- chunkname: @scripts/extension_systems/character_state_machine/character_states/utilities/health_state_transitions.lua

local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local HealthStateTransitions = {}

HealthStateTransitions.poll = function (unit_data_extension, next_state_params)
	local dead_state_input = unit_data_extension:read_component("dead_state_input")

	if dead_state_input.die then
		next_state_params.time_to_despawn_corpse = dead_state_input.despawn_time

		return "dead"
	end

	local character_state_component = unit_data_extension:read_component("character_state")

	if not PlayerUnitStatus.is_knocked_down(character_state_component) then
		local knocked_down_state_input = unit_data_extension:read_component("knocked_down_state_input")

		if knocked_down_state_input.knock_down then
			return "knocked_down"
		end
	end

	local hogtied_state_input = unit_data_extension:read_component("hogtied_state_input")

	if not PlayerUnitStatus.is_hogtied(character_state_component) and hogtied_state_input.hogtie then
		return "hogtied"
	end

	return nil
end

return HealthStateTransitions
