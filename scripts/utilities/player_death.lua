local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerDeath = {
	die = function (unit, optional_despawn_time, optional_attacking_unit)
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local dead_state_input = unit_data_extension:write_component("dead_state_input")
		dead_state_input.die = true
		dead_state_input.despawn_time = optional_despawn_time or PlayerCharacterConstants.time_to_despawn_corpse
		local player_unit_spawn_manager = Managers.state and Managers.state.player_unit_spawn
		local player = player_unit_spawn_manager and player_unit_spawn_manager:owner(unit)

		if DEDICATED_SERVER and player then
			Managers.stats:record_team_death()

			if player:is_human_controlled() then
				Managers.stats:record_player_death(player)
			end
		end
	end,
	knock_down = function (unit)
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local knocked_down_state_input = unit_data_extension:write_component("knocked_down_state_input")
		knocked_down_state_input.knock_down = true
		local player_unit_spawn_manager = Managers.state and Managers.state.player_unit_spawn
		local player = player_unit_spawn_manager and player_unit_spawn_manager:owner(unit)

		if DEDICATED_SERVER and player then
			Managers.stats:record_team_knock_down()

			if player:is_human_controlled() then
				Managers.stats:record_player_knock_down(player)
			end
		end
	end
}

return PlayerDeath
