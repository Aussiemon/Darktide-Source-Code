-- chunkname: @scripts/utilities/player_death.lua

local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerDeath = {}

PlayerDeath.die = function (unit, optional_despawn_time, optional_attacking_unit, reason)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local dead_state_input = unit_data_extension:write_component("dead_state_input")

	dead_state_input.die = true
	dead_state_input.despawn_time = optional_despawn_time or PlayerCharacterConstants.time_to_despawn_corpse

	local player_unit_spawn_manager = Managers.state and Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager and player_unit_spawn_manager:owner(unit)

	if reason ~= "damage" then
		local data = {
			reason = reason,
		}

		Managers.telemetry_events:player_died(player, data)
	end

	Managers.stats:record_private("hook_death", player)

	if player and Managers.state.pacing then
		local minions_listening_for_player_deaths = Managers.state.pacing:get_minions_listening_for_player_deaths()

		for minion_unit, statistics_component in pairs(minions_listening_for_player_deaths) do
			statistics_component.player_deaths = statistics_component.player_deaths + 1
		end

		Managers.state.pacing:player_died(player.player_unit)
	end
end

PlayerDeath.knock_down = function (unit)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local knocked_down_state_input = unit_data_extension:write_component("knocked_down_state_input")

	knocked_down_state_input.knock_down = true

	local player_unit_spawn_manager = Managers.state and Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager and player_unit_spawn_manager:owner(unit)

	Managers.stats:record_private("hook_knocked_down", player)
end

return PlayerDeath
