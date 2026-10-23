-- chunkname: @scripts/managers/multiplayer/utility/session_stat_events.lua

local BackendStatTypes = require("scripts/settings/stats/backend_stat_types")
local SessionStats = require("scripts/settings/stats/session_stats")
local StatDefinitions = require("scripts/managers/stats/stat_definitions")
local SessionStatEvents = {}
local collectible_missions = {
	side_mission_consumable = "relic",
	side_mission_grimoire = "grimoire",
	side_mission_hack_communications = "communications_hack_device",
	side_mission_tome = "tome",
}

SessionStatEvents.create_mission_events = function (mission_data, mission_result, account_id, character_id)
	local danger_settings = Managers.state.difficulty:get_danger_settings()
	local difficulty = danger_settings and danger_settings.difficulty or 1
	local win = mission_result.win
	local mission_type = Managers.state.mission:mission_type_index()
	local mission_name = Managers.state.mission:mission_name()
	local circumstance = Managers.state.circumstance:circumstance_name()
	local team_kills = Managers.stats:read_team_stat("session_team_kills")
	local team_deaths = Managers.stats:read_team_stat("team_deaths")
	local team_expedition_loot_retrieved = Managers.stats:read_team_stat("session_team_expedition_loot_retrieved") or 0
	local side_mission_progress = mission_result.sideMissions[1] and mission_result.sideMissions[1].count or 0
	local side_mission_complete = mission_result.sideMissions[1] and mission_result.sideMissions[1].win or false
	local side_mission_name = mission_result.sideMissions[1] and mission_result.sideMissions[1].missionName or "default"
	local events = {}

	do
		local specifier = string.format("name:%s|type:%s|difficulty:%s|win:%s|side_objective_complete:%s|side_objective_name:%s", mission_name, mission_type, difficulty, win, side_mission_complete, side_mission_name)

		events[1] = {
			type = "mission",
			accountId = account_id,
			characterId = character_id,
			dataType = BackendStatTypes.statistic_by,
			value = {
				[specifier] = 1,
			},
		}
	end

	if win and team_deaths == 0 then
		events[#events + 1] = {
			type = "complete_mission_no_death",
			accountId = account_id,
			characterId = character_id,
			dataType = BackendStatTypes.ephemeral,
			value = {
				none = 1,
			},
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
				[specifier] = side_mission_progress,
			},
		}
	end

	return events
end

SessionStatEvents.player_share = function (total, share_index, share_count)
	total = math.floor(total)

	local share = math.floor(total / share_count)
	local remainder = total - share * share_count

	if share_index <= remainder then
		share = share + 1
	end

	return share
end

local function _stat_id(player)
	return player.remote and player.stat_id or player:local_player_id()
end

local function _is_reporting_player(player)
	return Managers.stats:user_state(_stat_id(player)) ~= nil and math.is_uuid(player:account_id()) and math.is_uuid(player:character_id())
end

SessionStatEvents.create_player_events = function (mission_data, mission_result, player, share_index, share_count)
	local stats_manager = Managers.stats
	local stat_id = _stat_id(player)
	local account_id = player:account_id()
	local character_id = player:character_id()
	local events = SessionStatEvents.create_mission_events(mission_data, mission_result, account_id, character_id)
	local event_size = #events

	for backend_id, session_stat_config in pairs(SessionStats) do
		local values = {}

		for specifier, stat_name in pairs(session_stat_config.stats) do
			local value

			if StatDefinitions[stat_name].flags.team then
				value = stats_manager:read_team_stat(stat_name)
			else
				value = stats_manager:read_user_stat(stat_id, stat_name)
			end

			if session_stat_config.split_across_players then
				value = SessionStatEvents.player_share(value, share_index, share_count)
			end

			if value ~= 0 or session_stat_config.always_push then
				values[specifier] = value
			end
		end

		local should_push = not table.is_empty(values)
		local fill_with_default = session_stat_config.fill_with_default

		if should_push and fill_with_default then
			for specifier, _ in pairs(session_stat_config.stats) do
				if values[specifier] == nil then
					values[specifier] = 0
				end
			end
		end

		if should_push then
			event_size = event_size + 1
			events[event_size] = {
				accountId = account_id,
				characterId = character_id,
				dataType = session_stat_config.type,
				type = backend_id,
				value = values,
			}
		end
	end

	return events
end

SessionStatEvents.create_events = function (mission_data, mission_result, players)
	local reporting_players = {}

	for _, player in pairs(players) do
		if _is_reporting_player(player) then
			reporting_players[#reporting_players + 1] = player
		end
	end

	local events = {}
	local share_count = #reporting_players

	for share_index, player in ipairs(reporting_players) do
		table.append(events, SessionStatEvents.create_player_events(mission_data, mission_result, player, share_index, share_count))
	end

	return events
end

SessionStatEvents.push_events = function (session_id, mission_data, mission_result, players)
	local events = SessionStatEvents.create_events(mission_data, mission_result, players)

	return Managers.backend.interfaces.gameplay_session:events(session_id, events)
end

return SessionStatEvents
