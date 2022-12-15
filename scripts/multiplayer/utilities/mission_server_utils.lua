local Missions = require("scripts/settings/mission/mission_templates")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local TeamStats = require("scripts/managers/stats/groups/team_stats")
local MissionServerUtils = {
	process_mission_data = function (mission_data)
		mission_data.circumstance_name = mission_data.circumstance or "default"
		mission_data.side_mission = mission_data.sideMission or "default"
		mission_data.mission_giver_override = mission_data.missionGiver or "none"

		return mission_data
	end
}

local function _get_pacing_control_data(flags)
	if not flags then
		return
	end

	local pacing_control = {}

	return pacing_control
end

MissionServerUtils.set_mission_mechanism = function (mission_data)
	local flags = mission_data.flags
	local mechanism_context = {
		mission_name = mission_data.map,
		circumstance_name = mission_data.circumstance_name,
		side_mission = mission_data.side_mission,
		challenge = mission_data.challenge,
		resistance = mission_data.resistance,
		backend_mission_id = mission_data.id,
		mission_giver_vo_override = mission_data.mission_giver_override,
		pickup_pool_adjustments = mission_data.pickup,
		pacing_control = _get_pacing_control_data(flags)
	}
	local mission_name = mission_data.map
	local mission_settings = Missions[mission_name]
	local mechanism_name = mission_settings.mechanism_name

	Managers.mechanism:change_mechanism(mechanism_name, mechanism_context)
end

local function _get_collected_materials(session_won)
	local session_materials = {
		plasteel = {
			small = 0,
			large = 0
		},
		diamantine = {
			small = 0,
			large = 0
		}
	}
	local extension_manager = Managers.state.extension

	if extension_manager then
		local pickup_system = extension_manager:system("pickup_system")
		local collected_materials = pickup_system:get_collected_materials()
		local collected_plasteel = collected_materials.plasteel
		local collected_diamantine = collected_materials.diamantine

		if collected_plasteel then
			local session_plasteel = session_materials.plasteel
			session_plasteel.small = collected_plasteel.small or session_plasteel.small
			session_plasteel.large = collected_plasteel.large or session_plasteel.large
		end

		if collected_diamantine then
			local session_diamantine = session_materials.diamantine
			session_diamantine.small = collected_diamantine.small or session_diamantine.small
			session_diamantine.large = collected_diamantine.large or session_diamantine.large
		end
	end

	if not session_won then
		local session_plasteel = session_materials.plasteel
		session_plasteel.small = session_plasteel.large + math.floor(session_plasteel.small / 2)
		session_plasteel.large = 0
		local session_diamantine = session_materials.diamantine
		session_diamantine.small = session_diamantine.large + math.floor(session_diamantine.small / 2)
		session_diamantine.large = 0
	end

	return session_materials
end

local function _get_travel_ratio()
	local main_path_manager = Managers.state.main_path

	if not main_path_manager then
		return 0
	end

	return main_path_manager:furthest_travel_percentage(1)
end

local function _get_side_mission_result()
	local mission_manager = Managers.state.mission
	local extension_manager = Managers.state.extension

	if not mission_manager or not extension_manager then
		return nil
	end

	local side_mission = mission_manager:side_mission_name()
	local mission_objective_system = extension_manager:system("mission_objective_system")

	if side_mission == "default" then
		mission_objective_system:evaluate_level_end_objectives()

		return nil
	end

	local _, progression, max_progression = mission_objective_system:get_objective_progress(side_mission)

	mission_objective_system:evaluate_level_end_objectives()

	return {
		missionName = side_mission,
		win = max_progression <= progression,
		count = progression,
		maxCount = max_progression
	}
end

MissionServerUtils.get_mission_result = function (mission_data, game_mode_result)
	local win = game_mode_result == "won"
	local materials = _get_collected_materials(win)
	local travel_ratio = _get_travel_ratio()
	local percentage_complete = math.clamp(travel_ratio, 0, 1) * 100
	local mission_result = {
		missionName = mission_data.map,
		appliedEvent = mission_data.circumstance_name,
		challenge = mission_data.challenge,
		resistance = mission_data.resistance,
		percentageComplete = percentage_complete,
		win = win,
		sideMissions = {
			_get_side_mission_result()
		},
		resources = materials
	}

	return mission_result
end

local function _get_reward_modifier(player)
	local extension_manager = Managers.state.extension

	if not extension_manager then
		return nil
	end

	local gadget_system = extension_manager:system("gadget_system")
	local stat_buffs = gadget_system:stat_buffs(player)
	local reward_modifier = {
		mission_reward_xp_modifier = stat_buffs.mission_reward_xp_modifier,
		mission_reward_credit_modifier = stat_buffs.mission_reward_credit_modifier,
		mission_reward_rare_loot_modifier = stat_buffs.mission_reward_rare_loot_modifier,
		mission_reward_gear_instead_of_weapon_modifier = stat_buffs.mission_reward_gear_instead_of_weapon_modifier,
		mission_reward_drop_chance_modifier = stat_buffs.mission_reward_drop_chance_modifier,
		mission_reward_weapon_drop_rarity_modifier = stat_buffs.mission_reward_weapon_drop_rarity_modifier,
		side_mission_reward_xp_modifier = stat_buffs.side_mission_reward_xp_modifier,
		side_mission_reward_credit_modifier = stat_buffs.side_mission_reward_credit_modifier
	}

	return reward_modifier
end

MissionServerUtils.get_reward_modifiers = function ()
	local players = Managers.player:human_players()
	local reward_modifiers = {}

	for id, player in pairs(players) do
		repeat
			local character_id = player:character_id()

			if not character_id then
				break
			end

			if type(character_id) == "number" then
				break
			end

			local reward_modifier = _get_reward_modifier(player)

			if not reward_modifier then
				break
			end

			reward_modifiers[character_id] = reward_modifier
		until true
	end

	return reward_modifiers
end

MissionServerUtils.update_stats = function (mission_data, team_stats, mission_result, mission_start_time)
	local mission_play_time = Managers.time:time("main") - mission_start_time
	local human_players = Managers.player:human_players()
	local collected_materials = _get_collected_materials(mission_result.win)

	Managers.stats:record_collect_material("plasteel", 10 * collected_materials.plasteel.small + 25 * collected_materials.plasteel.large)
	Managers.stats:record_collect_material("diamantine", 10 * collected_materials.diamantine.small + 25 * collected_materials.diamantine.large)

	for _, player in pairs(human_players) do
		local difficulty = Managers.state.difficulty:get_difficulty()
		local win = mission_result.win
		local map_type = Managers.state.mission:main_objective_type()
		local mission_name = Managers.state.mission:mission_name()
		local circumstance = Managers.state.circumstance:circumstance_name()
		local team_kills = TeamStats.definitions.team_kill:get_value(team_stats)
		local team_downs = TeamStats.definitions.team_knock_down:get_value(team_stats)
		local team_deaths = TeamStats.definitions.team_death:get_value(team_stats)
		local is_flash_mission = mission_data.flags and not not mission_data.flags.flash
		local side_mission_progress = mission_result.sideMissions[1] and mission_result.sideMissions[1].count or 0
		local side_mission_complete = mission_result.sideMissions[1] and mission_result.sideMissions[1].win or false
		local side_mission_name = mission_result.sideMissions[1] and mission_result.sideMissions[1].missionName or "default"

		Managers.stats:record_mission_end(player, mission_name, map_type, circumstance, difficulty, win, mission_play_time, team_kills, team_downs, team_deaths, side_mission_progress, side_mission_complete, side_mission_name, is_flash_mission)
	end
end

MissionServerUtils.player_state = function (player)
	local player_unit = player.player_unit

	if not player_unit then
		return "missing"
	end

	local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
	local character_state_component = unit_data_extension:read_component("character_state")
	local requires_help = PlayerUnitStatus.requires_help(character_state_component)

	if HEALTH_ALIVE[player_unit] then
		if requires_help then
			return "downed"
		else
			return "alive"
		end
	else
		return "dead"
	end
end

return MissionServerUtils
