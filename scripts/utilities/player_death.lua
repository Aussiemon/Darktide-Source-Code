local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerDeath = {
	die = function (unit, optional_despawn_time, optional_attacking_unit, reason)
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local dead_state_input = unit_data_extension:write_component("dead_state_input")
		dead_state_input.die = true
		dead_state_input.despawn_time = optional_despawn_time or PlayerCharacterConstants.time_to_despawn_corpse
		local player_unit_spawn_manager = Managers.state and Managers.state.player_unit_spawn
		local player = player_unit_spawn_manager and player_unit_spawn_manager:owner(unit)

		if reason ~= "damage" then
			local data = {
				reason = reason
			}

			Managers.telemetry_events:player_died(player, data)
		end

		if Managers.stats.can_record_stats() and player then
			Managers.stats:record_team_death()

			if player:is_human_controlled() then
				Managers.stats:record_player_death(player)
			end
		end

		if player and Managers.state.pacing then
			local minions_listening_for_player_deaths = Managers.state.pacing:get_minions_listening_for_player_deaths()

			for minion_unit, statistics_component in pairs(minions_listening_for_player_deaths) do
				statistics_component.player_deaths = statistics_component.player_deaths + 1
			end
		end
	end
}

PlayerDeath.knock_down = function (unit)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local knocked_down_state_input = unit_data_extension:write_component("knocked_down_state_input")
	knocked_down_state_input.knock_down = true
	local player_unit_spawn_manager = Managers.state and Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager and player_unit_spawn_manager:owner(unit)

	if Managers.stats.can_record_stats() and player then
		Managers.stats:record_team_knock_down()

		if player:is_human_controlled() then
			Managers.stats:record_player_knock_down(player)
		end
	end
end

return PlayerDeath
