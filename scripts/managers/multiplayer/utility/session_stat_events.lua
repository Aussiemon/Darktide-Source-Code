local BackendStatTypes = require("scripts/settings/stats/backend_stat_types")
local SessionStats = require("scripts/settings/stats/session_stats")
local StatDefinitions = require("scripts/managers/stats/stat_definitions")
local SessionStatEvents = {}
local collectible_missions = {
	side_mission_tome = "tome",
	side_mission_consumable = "relic",
	side_mission_grimoire = "grimoire"
}

SessionStatEvents.create_mission_events = function (mission_data, mission_result, account_id, character_id)
	local difficulty = Managers.state.difficulty:get_difficulty()
	local win = mission_result.win
	local map_type = Managers.state.mission:main_objective_type()
	local mission_name = Managers.state.mission:mission_name()
	local circumstance = Managers.state.circumstance:circumstance_name()
	local team_kills = Managers.stats:read_team_stat("session_team_kills")
	local team_deaths = Managers.stats:read_team_stat("team_deaths")
	local side_mission_progress = mission_result.sideMissions[1] and mission_result.sideMissions[1].count or 0
	local side_mission_complete = mission_result.sideMissions[1] and mission_result.sideMissions[1].win or false
	local side_mission_name = mission_result.sideMissions[1] and mission_result.sideMissions[1].missionName or "default"
	local events = {}
	local specifier = string.format("name:%s|type:%s|difficulty:%s|win:%s|side_objective_complete:%s|side_objective_name:%s", mission_name, map_type, difficulty, win, side_mission_complete, side_mission_name)
	events[1] = {
		type = "mission",
		accountId = account_id,
		characterId = character_id,
		dataType = BackendStatTypes.statistic_by,
		value = {
			[specifier] = 1
		}
	}

	if win and team_deaths == 0 then
		events[#events + 1] = {
			type = "complete_mission_no_death",
			accountId = account_id,
			characterId = character_id,
			dataType = BackendStatTypes.ephemeral,
			value = {
				none = 1
			}
		}
	end

	local collectible_type = collectible_missions[side_mission_name]

	if win and collectible_type then
		local specifier = string.format("type:%s", collectible_type)
		events[#events + 1] = {
			type = "collect_pickup",
			accountId = account_id,
			characterId = character_id,
			dataType = BackendStatTypes.ephemeral,
			value = {
				[specifier] = side_mission_progress
			}
		}
	end

	return events
end

SessionStatEvents.create_player_events = function (mission_data, mission_result, player)
	local stats_manager = Managers.stats
	local stat_id = player.remote and player.stat_id or player:local_player_id()

	if not stats_manager:user_state(stat_id) then
		return {}
	end

	local account_id = player:account_id()
	local character_id = player:character_id()

	if not math.is_uuid(account_id) or not math.is_uuid(character_id) then
		return {}
	end

	local events = SessionStatEvents.create_mission_events(mission_data, mission_result, account_id, character_id)
	local event_size = #events

	for backend_id, session_stat_config in pairs(SessionStats) do
		local values = {}

		for specifier, stat_name in pairs(session_stat_config.stats) do
			local value = nil

			if StatDefinitions[stat_name].flags.team then
				value = stats_manager:read_team_stat(stat_name)
			else
				value = stats_manager:read_user_stat(stat_id, stat_name)
			end

			if value ~= 0 or session_stat_config.always_push then
				values[specifier] = value
			end
		end

		if table.size(values) > 0 then
			event_size = event_size + 1
			events[event_size] = {
				accountId = account_id,
				characterId = character_id,
				dataType = session_stat_config.type,
				type = backend_id,
				value = values
			}
		end
	end

	return events
end

SessionStatEvents.create_events = function (mission_data, mission_result, players)
	local events = {}

	for _, player in pairs(players) do
		table.append(events, SessionStatEvents.create_player_events(mission_data, mission_result, player))
	end

	return events
end

SessionStatEvents.push_events = function (session_id, mission_data, mission_result, players)
	local events = SessionStatEvents.create_events(mission_data, mission_result, players)

	return Managers.backend.interfaces.gameplay_session:events(session_id, events)
end

return SessionStatEvents
