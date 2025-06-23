-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_survival.lua

local BotSpawning = require("scripts/managers/bot/bot_spawning")
local CinematicSceneSettings = require("scripts/settings/cinematic_scene/cinematic_scene_settings")
local GameModeBase = require("scripts/managers/game_mode/game_modes/game_mode_base")
local HordesModeSettings = require("scripts/settings/hordes_mode_settings")
local MissionBuffsManager = require("scripts/managers/mission_buffs/mission_buffs_manager")
local PickupSettings = require("scripts/settings/pickup/pickup_settings")
local PlayerManager = require("scripts/foundation/managers/player/player_manager")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local CINEMATIC_NAMES = CinematicSceneSettings.CINEMATIC_NAMES
local DEFAULT_RESPAWN_TIME = 30
local GameModeSurvival = class("GameModeSurvival", "GameModeBase")
local SERVER_RPCS = {}
local CLIENT_RPCS = {
	"rpc_set_player_respawn_time",
	"rpc_fetch_session_report",
	"rpc_client_hordes_set_progress_data",
	"rpc_client_hordes_wave_completed",
	"rpc_client_hordes_show_wave_completed_notification",
	"rpc_client_hordes_tag_remaining_enemies"
}

local function _log(...)
	Log.info("GameModeSurvival", ...)
end

local MINION_HEALTH_MODIFIER_PER_WAVE = {
	{
		default = 0,
		elite = 0,
		special = 0,
		captain = 0,
		monster = 0
	},
	{
		default = 0,
		elite = 0,
		special = 0,
		captain = 0,
		monster = 0
	},
	{
		default = 0,
		elite = 0,
		special = 0,
		captain = 0,
		monster = 0
	},
	{
		default = 0.2,
		elite = 0.2,
		special = 0.2,
		captain = 0,
		monster = 0.2
	},
	{
		default = 0.4,
		elite = 0.3,
		special = 0.3,
		captain = 0,
		monster = 0.3
	},
	{
		default = 0.6,
		elite = 0.4,
		special = 0.4,
		captain = 0,
		monster = 0.3
	},
	{
		default = 0.7,
		elite = 0.5,
		special = 0.5,
		captain = 0,
		monster = 0.4
	},
	{
		default = 0.8,
		elite = 0.6,
		special = 0.6,
		captain = 0.1,
		monster = 0.4
	},
	{
		default = 1.1,
		elite = 0.7,
		special = 0.7,
		captain = 0.2,
		monster = 0.5
	},
	{
		default = 1.1,
		elite = 0.8,
		special = 0.8,
		captain = 0.3,
		monster = 0.5
	},
	{
		default = 1.1,
		elite = 0.9,
		special = 0.9,
		captain = 0.4,
		monster = 0.7
	},
	{
		default = 1.1,
		elite = 1.1,
		special = 1.1,
		captain = 0.5,
		monster = 0.7
	}
}

GameModeSurvival.init = function (self, game_mode_context, game_mode_name, network_event_delegate)
	GameModeSurvival.super.init(self, game_mode_context, game_mode_name, network_event_delegate)

	self._pacing_enabled = false
	self._can_start_players_check = false
	self._players_respawn_time = {}
	self._end_t = nil
	self._current_wave = 0
	self._is_wave_in_progress = false
	self._waves_completed = 0
	self._islands_completed = 0
	self._num_islands_to_complete = 1
	self._objectives_completed = {}
	self._current_island = nil

	self:_init_buff_system(game_mode_name, network_event_delegate)
	Managers.event:register(self, "event_surival_mode_tag_remaining_enemies", "_tag_remaining_enemies")
	Managers.event:register(self, "hordes_mode_on_wave_started", "on_wave_started")
	Managers.event:register(self, "hordes_mode_on_objective_completed", "on_objective_completed")
	Managers.event:register(self, "hordes_mode_on_wave_completed", "on_wave_completed")
	Managers.event:register(self, "hordes_mode_on_island_entered", "on_island_entered")
	Managers.event:register(self, "hordes_mode_on_island_completed", "on_island_completed")
	Managers.event:register(self, "hordes_mode_on_mcguffin_picked_up", "on_mcguffin_picked_up")
	Managers.event:register(self, "hordes_mode_on_mcguffin_returned", "on_mcguffin_returned")
	Managers.event:register(self, "minion_unit_spawned", "_on_minion_unit_spawned")

	if self._is_server then
		Managers.event:register(self, "in_safe_volume", "in_safe_volume")

		self._persistent_data_humans = {}
		self._persistent_data_bots = {}

		network_event_delegate:register_session_events(self, unpack(SERVER_RPCS))
	else
		network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end

	self._network_event_delegate = network_event_delegate
end

GameModeSurvival.hot_join_sync = function (self, sender, channel)
	GameModeSurvival.super.hot_join_sync(self, sender, channel)
	RPC.rpc_client_hordes_set_progress_data(channel, self._current_wave, self._waves_completed, self._is_wave_in_progress)
end

GameModeSurvival.client_update = function (self, dt, t)
	GameModeSurvival.super.client_update(self, dt, t)
end

GameModeSurvival.server_update = function (self, dt, t)
	GameModeSurvival.super.server_update(self, dt, t)
end

GameModeSurvival.destroy = function (self)
	self:_destroy_buff_system()
	Managers.event:unregister(self, "event_surival_mode_tag_remaining_enemies")
	Managers.event:unregister(self, "hordes_mode_on_wave_started")
	Managers.event:unregister(self, "hordes_mode_on_objective_completed")
	Managers.event:unregister(self, "hordes_mode_on_wave_completed")
	Managers.event:unregister(self, "hordes_mode_on_island_entered")
	Managers.event:unregister(self, "hordes_mode_on_island_completed")
	Managers.event:unregister(self, "hordes_mode_on_mcguffin_returned")
	Managers.event:unregister(self, "minion_unit_spawned")

	if self._is_server then
		Managers.event:unregister(self, "in_safe_volume")
		self._network_event_delegate:unregister_events(unpack(SERVER_RPCS))
	else
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	GameModeSurvival.super.destroy(self)
end

GameModeSurvival._game_mode_state_changed = function (self, new_state, old_state)
	if not self._is_server and self:_cinematic_active() then
		_log("[_game_mode_state_changed] Force stop cinematics")
		Managers.state.cinematic:stop_all_stories()
	end
end

GameModeSurvival.get_game_progression_percentage = function (self)
	local total_waves_completed = self:get_total_waves_completed()
	local percentage_completed = total_waves_completed / HordesModeSettings.waves_per_island * self._num_islands_to_complete

	return percentage_completed
end

GameModeSurvival.evaluate_end_conditions = function (self)
	local settings = self._settings
	local current_state = self._state
	local completion_conditions_met = self._completed
	local failure_conditions_met, all_players_disabled, all_players_dead = self:_failure_conditions_met()
	local t = Managers.time:time("gameplay")
	local cinematic_scene_system = Managers.state.extension:system("cinematic_scene_system")

	if current_state == "running" then
		if failure_conditions_met then
			local disabled_grace_time = settings.mission_end_grace_time_disabled
			local dead_grace_time = settings.mission_end_grace_time_dead
			local grace_time = all_players_disabled and disabled_grace_time or all_players_dead and dead_grace_time or 0
			local next_state = all_players_disabled and "about_to_fail_disabled" or "about_to_fail_dead"

			self._end_t = t + grace_time

			self:_change_state(next_state)
			_log("[evaluate_end_conditions] Failure conditions changed (dead: %s | disabled: %s), game mode will end in %.2f seconds", all_players_dead and "Y" or "N", all_players_disabled and "Y" or "N", grace_time)
		elseif completion_conditions_met then
			self:_gamemode_complete("won", self._end_reason)
			self:_change_state("outro_cinematic")
			Managers.state.minion_spawn:despawn_all_minions()
			cinematic_scene_system:play_cutscene(CINEMATIC_NAMES.outro_win)
			_log("[evaluate_end_conditions] Triggering cutscene %q", CINEMATIC_NAMES.outro_win)
		end
	elseif current_state == "about_to_fail_disabled" or current_state == "about_to_fail_dead" then
		local dead_grace_time = settings.mission_end_grace_time_dead

		if current_state == "about_to_fail_disabled" and failure_conditions_met and all_players_dead and dead_grace_time then
			self._end_t = t + dead_grace_time

			self:_change_state("about_to_fail_dead")
			_log("[evaluate_end_conditions] Failure conditions changed (dead: %s | disabled: %s), game mode will end in %.2f seconds", all_players_dead and "Y" or "N", all_players_disabled and "Y" or "N", dead_grace_time)
		elseif not failure_conditions_met then
			_log("[evaluate_end_conditions] Failure conditions interrupted")

			self._end_t = nil

			self:_change_state("running")
		end

		if failure_conditions_met and t > self._end_t then
			self._failed = true

			self:_gamemode_complete("lost", self._end_reason)
			self:_change_state("outro_cinematic")
			Managers.state.minion_spawn:despawn_all_minions()
			cinematic_scene_system:play_cutscene(CINEMATIC_NAMES.outro_fail)
			_log("[evaluate_end_conditions] Grace timer reached end")
			_log("[evaluate_end_conditions] Triggering cutscene %q", CINEMATIC_NAMES.outro_fail)
		end
	elseif current_state == "outro_cinematic" then
		if not self:_cinematic_active() then
			self:_change_state("done")
			_log("[evaluate_end_conditions] Cutscene finished. Switch to done")
		end
	elseif current_state == "done" then
		_log("[evaluate_end_conditions] Completing game mode with result %q", failure_conditions_met and "lost" or completion_conditions_met and "won")

		return true, failure_conditions_met and "lost" or completion_conditions_met and "won"
	end

	return false
end

GameModeSurvival._gamemode_complete = function (self, result, reason)
	_log("gamemode_complete, result: %s, reason: %s", result, reason)
	self:_fetch_session_report()
	Managers.state.game_session:send_rpc_clients("rpc_fetch_session_report")
	self:_handle_game_end_server(result == "won")

	if Managers.mission_server then
		local total_waves_completed = self:get_total_waves_completed()

		Managers.mission_server:on_gamemode_completed(result, reason, {
			completion_time = self._completition_time,
			current_island = self._current_island or "NONE",
			waves_completed = total_waves_completed or 0
		})
	end
end

GameModeSurvival.rpc_fetch_session_report = function (self)
	self:_fetch_session_report()
end

GameModeSurvival._fetch_session_report = function (self)
	local session_id = Managers.connection:session_id()

	if DEDICATED_SERVER then
		Managers.progression:fetch_session_report_server(session_id)
	else
		Managers.progression:fetch_session_report(session_id)
	end

	_log("fetch_session_report, session_id: %s", session_id)
end

GameModeSurvival._all_players_disabled = function (self, num_alive_players, alive_players, include_bots)
	for i = 1, num_alive_players do
		local player = alive_players[i]
		local player_unit = player.player_unit
		local unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")

		if unit_data_extension then
			local is_human = player:is_human_controlled()
			local count_player = is_human or include_bots and not is_human
			local character_state_component = unit_data_extension:read_component("character_state")
			local is_disabled = HEALTH_ALIVE[player_unit] and PlayerUnitStatus.is_disabled_for_mission_failure(character_state_component)

			if count_player and not is_disabled and HEALTH_ALIVE[player_unit] then
				return false
			end
		end
	end

	return true
end

GameModeSurvival._all_players_dead = function (self, num_alive_players, alive_players, include_bots)
	for i = 1, num_alive_players do
		local player = alive_players[i]
		local player_unit = player.player_unit
		local unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")

		if unit_data_extension then
			local is_human = player:is_human_controlled()
			local count_player = is_human or include_bots and not is_human
			local character_state_component = unit_data_extension:read_component("character_state")
			local is_dead = not HEALTH_ALIVE[player_unit] or PlayerUnitStatus.is_dead_for_mission_failure(character_state_component)

			if count_player and not is_dead then
				return false
			end
		end
	end

	return true
end

GameModeSurvival._failure_conditions_met = function (self)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local alive_players = player_unit_spawn_manager:alive_players()
	local num_alive_players = #alive_players

	if self._can_start_players_check then
		local all_players_disabled = self:_all_players_disabled(num_alive_players, alive_players, true)
		local all_players_dead = self:_all_players_dead(num_alive_players, alive_players, false)
		local has_failed = not not self._failed

		return all_players_disabled or all_players_dead or has_failed, all_players_disabled, all_players_dead
	else
		for i = 1, num_alive_players do
			local player = alive_players[i]

			if player:is_human_controlled() then
				self._can_start_players_check = true

				break
			end
		end
	end

	return not not self._failed, false, false
end

GameModeSurvival.in_safe_volume = function (self, volume_unit)
	if not self._pacing_enabled then
		_log("[in_safe_volume] %s", volume_unit and "Entered safe volume" or "Exited safe volume")

		if volume_unit then
			self:_restrict_spawning(true)
		else
			self:_restrict_spawning(false)
		end
	end
end

GameModeSurvival._restrict_spawning = function (self, enabled)
	Managers.state.pacing:pause_spawn_type("specials", enabled, "safe_zone")
	Managers.state.pacing:pause_spawn_type("hordes", enabled, "safe_zone")
	Managers.state.pacing:pause_spawn_type("trickle_hordes", enabled, "safe_zone")
	Managers.state.pacing:set_in_safe_zone(enabled)
end

GameModeSurvival._set_pacing = function (self, enabled)
	self._pacing_enabled = enabled

	Managers.state.pacing:set_enabled(self._pacing_enabled)
end

GameModeSurvival.complete = function (self, reason)
	self._completed = true
	self._end_reason = reason
end

GameModeSurvival.fail = function (self, reason)
	self._failed = true
	self._end_reason = reason
end

GameModeSurvival._init_buff_system = function (self, game_mode_name, network_event_delegate)
	self._mission_buffs_manager = MissionBuffsManager:new(self._is_server, self, game_mode_name, network_event_delegate)
end

GameModeSurvival._destroy_buff_system = function (self, game_mode_name, network_event_delegate)
	self._mission_buffs_manager:destroy()

	self._mission_buffs_manager = nil
end

GameModeSurvival.on_island_entered = function (self, island_name)
	Log.info("GameModeSurvival", string.format("Players entered island %s", island_name))

	self._current_island = island_name
end

GameModeSurvival.on_island_completed = function (self)
	self._islands_completed = self._islands_completed + 1
	self._current_wave = 0
	self._waves_completed = 0
	self._is_wave_in_progress = false

	table.clear(self._objectives_completed)

	if self._is_server then
		Managers.state.extension:system("pickup_system"):external_populate_pickups()
		Managers.stats:record_team("hook_game_mode_survival_island_completed", self._current_island)

		local players = Managers.player:human_players()

		for _, player in pairs(players) do
			local buff_family_selected_by_player = self._mission_buffs_manager:get_buff_family_selected_by_player(player)

			if buff_family_selected_by_player then
				Managers.stats:record_private("hook_game_mode_survival_class_completed", player, buff_family_selected_by_player)
			end
		end
	end
end

GameModeSurvival.on_mcguffin_picked_up = function (self)
	if self._is_server then
		self:_horde_game_completed_server()
		self:_give_game_end_damage_immunity_buff()
	end
end

GameModeSurvival.on_mcguffin_returned = function (self)
	if self._is_server then
		Managers.stats:record_team("hook_game_mode_mcguffins_returned")
	end
end

GameModeSurvival.on_wave_started = function (self, wave_num)
	Log.info("GameModeSurvival", string.format("Wave %d started event received", wave_num))
	self:_update_wave_progression(wave_num, true, true)
	self:_handle_progression_notification(wave_num, true, true)

	if self._is_server and wave_num == 1 and self._islands_completed == 0 then
		self:_handle_horde_game_start()
	end
end

GameModeSurvival.on_objective_completed = function (self, wave_num)
	Log.info("GameModeSurvival", string.format("Objective completed for wave %d event received", wave_num))

	local target_objective = string.format("wave_%d_objective_completed", wave_num)

	self._objectives_completed[target_objective] = true
end

GameModeSurvival._tag_remaining_enemies = function (self)
	if self._is_server then
		Managers.state.game_session:send_rpc_clients("rpc_client_hordes_tag_remaining_enemies")
	end

	if not DEDICATED_SERVER then
		local outline_system = Managers.state.extension:system("outline_system")

		if outline_system then
			local side = Managers.state.extension:system("side_system"):get_side_from_name("villains")
			local _, target_units = side:relation_sides("allied"), side:alive_units_by_tag("allied", "minion")

			for _, unit in pairs(target_units) do
				if HEALTH_ALIVE[unit] then
					outline_system:add_outline(unit, "hordes_tagged_remaining_target")
				end
			end
		end
	end
end

GameModeSurvival.on_wave_completed = function (self, wave_num)
	Log.info("GameModeSurvival", string.format("Wave %d completed event received", wave_num))

	local show_progression_notification

	self:_update_wave_progression(wave_num, false)

	if self._is_server then
		local buff_notification_sent = self:_handle_giving_buffs_for_wave(wave_num)

		show_progression_notification = not buff_notification_sent

		local hazard_prop_system = Managers.state.extension:system("hazard_prop_system")

		hazard_prop_system:re_populate_hazard_props()
	end

	self:_handle_progression_notification(self._waves_completed, false, show_progression_notification)
end

GameModeSurvival._handle_horde_game_start = function (self)
	self._first_wave_start_time = Managers.time:time("gameplay")

	Log.info("GameModeSurvival", "Game Mode Timer started (%f)", self._first_wave_start_time)
end

GameModeSurvival._horde_game_completed_server = function (self)
	if self._first_wave_start_time == nil then
		self._completition_time = 0

		return
	end

	local current_time = Managers.time:time("gameplay")

	self._completition_time = math.floor(current_time - self._first_wave_start_time)

	Log.info("GameModeSurvival", "Game Mode Timer stopped by picking up Relic: Completion Time [%f](seconds)", self._completition_time or -1)
end

GameModeSurvival._handle_game_end_server = function (self, game_won)
	if not game_won then
		self:_horde_game_completed_server()
	end

	local danger_settings = Managers.state.difficulty:get_danger_settings()
	local difficulty = danger_settings and danger_settings.difficulty or 1

	Managers.stats:record_team("hook_game_mode_survival_game_end", game_won, self._completition_time, difficulty)

	local total_waves_completed = self:get_total_waves_completed()

	Log.info("GameModeSurvival", "Game Mode Ended: Island played [%s] | Total Waves Completed [%d] | Islands Completed [%d] | Completition Time [%f]", self._current_island or "NONE", total_waves_completed or -1, self._islands_completed or -1, self._completition_time or -1)

	if Managers.telemetry_events then
		local players = Managers.player:human_players()

		for _, player in pairs(players) do
			Managers.telemetry_events:player_hordes_mode_ended(player, game_won, self._completition_time, self._current_island or "NONE", total_waves_completed or 0)
		end
	end
end

GameModeSurvival._give_game_end_damage_immunity_buff = function (self)
	local players = Managers.player:human_players()

	for _, player in pairs(players) do
		self._mission_buffs_manager:give_player_silent_buff_not_saved_to_player_data(player, "hordes_buff_damage_immunity_after_game_end")
	end

	self._game_end_immunity_buff_given_to_players = true
end

local TWIN_BREEDS = {
	renegade_twin_captain = true,
	renegade_twin_captain_two = true
}

GameModeSurvival._on_minion_unit_spawned = function (self, unit)
	local breed_name = ScriptUnit.extension(unit, "unit_data_system"):breed().name

	if TWIN_BREEDS[breed_name] then
		local reactivation_override = true
		local spawned_unit_toughness_extension = ScriptUnit.extension(unit, "toughness_system")

		spawned_unit_toughness_extension:set_toughness_damage(0, reactivation_override)
	end
end

GameModeSurvival._handle_giving_buffs_for_wave = function (self, wave_num)
	local should_send_legendary_choice = false
	local legendary_buff_waves = HordesModeSettings.give_legendary_buffs_at_waves

	for _, legendary_buff_wave_number in ipairs(legendary_buff_waves) do
		if legendary_buff_wave_number == wave_num then
			should_send_legendary_choice = true

			break
		end
	end

	if should_send_legendary_choice then
		Managers.event:trigger("mission_buffs_event_request_legendary_buff_choice", wave_num)

		return true
	end

	local should_send_family_buff = false
	local family_buff_waves = HordesModeSettings.give_family_buffs_at_waves

	for _, family_buff_wave_number in ipairs(family_buff_waves) do
		if family_buff_wave_number == wave_num then
			should_send_family_buff = true

			break
		end
	end

	if should_send_family_buff then
		Managers.event:trigger("mission_buffs_event_request_family_buff_for_all", wave_num)

		return true
	end

	return false
end

GameModeSurvival._update_wave_progression = function (self, wave_num, started_wave)
	local is_old_data = self:_is_wave_progress_data_old(wave_num, started_wave)

	if is_old_data then
		Log.error("GameModeSurvival", string.format("Skiping wave progress update due to having the same or newer data. Tried to update with: WaveNum (%d) | InProgress? (%s)", wave_num, started_wave and "Y" or "N"))

		return
	end

	if started_wave then
		self._current_wave = wave_num
		self._is_wave_in_progress = true
	else
		self._waves_completed = wave_num
		self._is_wave_in_progress = false

		if self._is_server then
			local total_waves_completed = self._islands_completed * HordesModeSettings.waves_per_island + self._waves_completed

			Managers.stats:record_team("hook_game_mode_survival_waves_completed", total_waves_completed)
		end
	end

	Log.info("GameModeSurvival", "Wave progress updated: WavesCompleted %d | CurrentWave %d | InProgress? %s", self._waves_completed, self._current_wave, self._is_wave_in_progress and "Y" or "N")
end

GameModeSurvival._handle_progression_notification = function (self, wave_num, started_wave, show_wave_progression_notification)
	if self._is_server and not started_wave then
		Managers.state.game_session:send_rpc_clients("rpc_client_hordes_wave_completed", self._current_wave, self._waves_completed, self._is_wave_in_progress)

		if show_wave_progression_notification then
			Managers.state.game_session:send_rpc_clients("rpc_client_hordes_show_wave_completed_notification", wave_num)

			if not DEDICATED_SERVER then
				self:_trigger_wave_ended_ui_notification()
			end
		end
	end

	if not DEDICATED_SERVER then
		if started_wave and show_wave_progression_notification then
			self:_trigger_wave_started_ui_notification()
		elseif not started_wave then
			self._mission_buffs_manager:try_show_new_ui_notification()
		end
	end
end

GameModeSurvival._is_wave_progress_data_old = function (self, wave_num, started_wave)
	if started_wave then
		return wave_num < self._current_wave
	else
		return wave_num < self._waves_completed
	end
end

GameModeSurvival._trigger_wave_started_ui_notification = function (self)
	local wave_started_notification = {
		timer = 5,
		state = "start",
		wave_num = self._current_wave
	}

	Managers.event:trigger("event_mission_buffs_update_presentation", wave_started_notification)
end

GameModeSurvival._trigger_wave_ended_ui_notification = function (self)
	self._mission_buffs_manager._mission_buffs_ui_manager:queue_wave_end_notification_ui(self._waves_completed)
end

GameModeSurvival.get_islands_completed = function (self)
	return self._islands_completed
end

GameModeSurvival.can_start_wave_one = function (self)
	local level = Managers.state.mission:mission_level()

	Level.trigger_event(level, "hordes_players_ready_for_start")
end

GameModeSurvival.wait_for_players_to_choose_family = function (self)
	local level = Managers.state.mission:mission_level()

	Level.trigger_event(level, "hordes_wait_for_players_choose_family")
end

GameModeSurvival.is_objective_completed_for_wave = function (self, wave_num)
	local target_objective = string.format("wave_%d_objective_completed", wave_num)

	return not not self._objectives_completed[target_objective]
end

GameModeSurvival.get_total_waves_completed = function (self)
	local total_waves_completed = self._islands_completed * HordesModeSettings.waves_per_island + self._waves_completed

	return total_waves_completed
end

GameModeSurvival.get_waves_completed = function (self)
	local current_waves_completed = self._waves_completed or 3

	return current_waves_completed
end

GameModeSurvival.get_last_wave_completed = function (self)
	return self._waves_completed
end

GameModeSurvival.get_current_wave = function (self)
	return self._current_wave
end

GameModeSurvival.is_wave_in_progress = function (self)
	return self._is_wave_in_progress
end

GameModeSurvival.get_minion_health_modifier = function (self, breed)
	local waves_completed = self._current_wave
	local target_wave_modifier_index = math.clamp(waves_completed, 1, #MINION_HEALTH_MODIFIER_PER_WAVE)
	local health_modifier = MINION_HEALTH_MODIFIER_PER_WAVE[target_wave_modifier_index]
	local tags = breed.tags
	local captain_tag = tags.captain

	if captain_tag then
		health_modifier = health_modifier.captain

		return health_modifier
	end

	local elite = tags.elite

	if elite then
		health_modifier = health_modifier.elite

		return health_modifier
	end

	local special = tags.special

	if special then
		health_modifier = health_modifier.special

		return health_modifier
	end

	local monster = tags.monster

	if monster then
		health_modifier = health_modifier.monster

		return health_modifier
	end

	health_modifier = health_modifier.default

	return health_modifier
end

GameModeSurvival.on_player_unit_spawn = function (self, player, unit, is_respawn)
	GameModeSurvival.super.on_player_unit_spawn(self, player, unit, is_respawn)

	if self._is_server then
		Managers.event:trigger("mission_buffs_event_player_spawned", player, is_respawn)

		if self._game_end_immunity_buff_given_to_players then
			self._mission_buffs_manager:give_player_silent_buff_not_saved_to_player_data(player, "hordes_buff_damage_immunity_after_game_end")
		end

		self:_set_ready_time_to_spawn(player, nil)

		if is_respawn then
			self:_apply_respawn_penalties(player)
		elseif self._settings.persistent_player_data_settings then
			self:_apply_persistent_player_data(player)
		end

		if not is_respawn then
			local buff_extension = ScriptUnit.has_extension(player.player_unit, "buff_system")

			if buff_extension then
				local t = Managers.time:time("gameplay")

				buff_extension:add_internally_controlled_buff("player_spawn_grace", t)
			end
		end

		if not player:is_human_controlled() then
			local bot_config_identifier = BotSpawning.get_bot_config_identifier()

			if bot_config_identifier == "medium" or bot_config_identifier == "high" then
				local t = Managers.time:time("gameplay")
				local buff_extension = ScriptUnit.extension(player.player_unit, "buff_system")

				buff_extension:add_internally_controlled_buff("bot_" .. bot_config_identifier .. "_buff", t)
			end
		end

		local mission_objective_system = Managers.state.extension:system("mission_objective_system")

		if mission_objective_system then
			mission_objective_system:on_player_unit_spawn(player, unit, is_respawn)
		end

		if self._current_wave == 0 then
			self._mission_buffs_manager:check_if_all_players_chosen_family()
		end
	end
end

GameModeSurvival.on_player_unit_despawn = function (self, player)
	GameModeSurvival.super.on_player_unit_despawn(self, player)

	if not self._is_server then
		return
	end

	local respawn_settings = self._settings.respawn
	local has_timer = Managers.time:has_timer("gameplay")

	if respawn_settings and has_timer then
		local time = respawn_settings.respawn_time or DEFAULT_RESPAWN_TIME
		local current_time = Managers.time:time("gameplay")
		local time_until_respawn = current_time + time

		self:_set_ready_time_to_spawn(player, time_until_respawn)
	end

	if self._settings.persistent_player_data_settings then
		self:_store_persistent_player_data(player)
	end

	if self._current_wave == 0 then
		self._mission_buffs_manager:check_if_all_players_chosen_family()
	end
end

local function _player_account_id(player)
	local account_id = player:account_id()

	if account_id and account_id ~= PlayerManager.NO_ACCOUNT_ID then
		return account_id
	end
end

GameModeSurvival._store_persistent_player_data = function (self, player)
	if not player:unit_is_alive() then
		return
	end

	local unit = player.player_unit
	local health_extension = ScriptUnit.extension(unit, "health_system")
	local damage_percent, permanent_damage_percent = health_extension:persistent_data()
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local character_state_component = unit_data_extension:read_component("character_state")
	local character_state_name = character_state_component.state_name
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local weapon_slot_configuration = visual_loadout_extension:slot_configuration_by_type("weapon")
	local weapon_slot_data = {}

	for slot_name, config in pairs(weapon_slot_configuration) do
		local inventory_slot_component = unit_data_extension:read_component(slot_name)
		local max_ammo_reserve = inventory_slot_component.max_ammunition_reserve
		local max_ammo_clip = inventory_slot_component.max_ammunition_clip
		local data = {}

		if max_ammo_reserve > 0 then
			data.ammo_reserve_percent = inventory_slot_component.current_ammunition_reserve / max_ammo_reserve
		end

		if max_ammo_clip > 0 then
			data.ammo_clip_percent = inventory_slot_component.current_ammunition_clip / max_ammo_clip
		end

		weapon_slot_data[slot_name] = data
	end

	local ability_extension = ScriptUnit.extension(unit, "ability_system")
	local equipped_abilities = ability_extension:equipped_abilities()
	local grenade_ability = equipped_abilities.grenade_ability
	local grenades_percent

	if grenade_ability and not grenade_ability.exclude_from_persistant_player_data then
		local num_grenades = ability_extension:remaining_ability_charges("grenade_ability")
		local max_grenades = ability_extension:max_ability_charges("grenade_ability")

		if max_grenades > 0 then
			grenades_percent = num_grenades / max_grenades
		else
			grenades_percent = 1
		end
	end

	local data = {
		damage_percent = damage_percent,
		permanent_damage_percent = permanent_damage_percent,
		character_state_name = character_state_name,
		weapon_slot_data = weapon_slot_data,
		grenades_percent = grenades_percent
	}

	if player:is_human_controlled() then
		local account_id = _player_account_id(player)

		if account_id then
			self._persistent_data_humans[account_id] = data
		end
	else
		self._persistent_data_bots[#self._persistent_data_bots + 1] = data
	end
end

GameModeSurvival._apply_persistent_player_data = function (self, player)
	if not player:unit_is_alive() or not player:is_human_controlled() then
		return
	end

	local account_id = _player_account_id(player)

	if account_id then
		local human_data = self._persistent_data_humans
		local bot_data = self._persistent_data_bots
		local selected_data = human_data[account_id]

		if selected_data then
			human_data[account_id] = nil

			local settings = self._settings.persistent_player_data_settings

			selected_data.damage_percent = math.min(selected_data.damage_percent, settings.max_damage_percent_from_self)
			selected_data.permanent_damage_percent = math.min(selected_data.permanent_damage_percent, settings.max_permanent_damage_percent_from_self)

			Log.info("GameModeSurvival", "Player %s inherited persistent data from previous self: %s", account_id, table.tostring(selected_data, 3))
		elseif #bot_data > 0 then
			selected_data = table.remove(bot_data, #bot_data)

			local settings = self._settings.persistent_player_data_settings

			selected_data.damage_percent = math.min(selected_data.damage_percent, settings.max_damage_percent_from_bot)
			selected_data.permanent_damage_percent = math.min(selected_data.permanent_damage_percent, settings.max_permanent_damage_percent_from_bot)

			Log.info("GameModeSurvival", "Player %s inherited persistent data from previous bot: %s", account_id, table.tostring(selected_data, 3))
		end

		local player_unit = player.player_unit

		if selected_data then
			local health_extension = ScriptUnit.extension(player_unit, "health_system")

			health_extension:apply_persistent_data(selected_data.damage_percent, selected_data.permanent_damage_percent)

			local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")

			for slot_name, data in pairs(selected_data.weapon_slot_data) do
				local inventory_slot_component = unit_data_extension:write_component(slot_name)
				local max_ammo_reserve = inventory_slot_component.max_ammunition_reserve
				local max_ammo_clip = inventory_slot_component.max_ammunition_clip

				if max_ammo_reserve > 0 and data.ammo_reserve_percent then
					inventory_slot_component.current_ammunition_reserve = math.round(max_ammo_reserve * data.ammo_reserve_percent)
				end

				if max_ammo_clip > 0 and data.ammo_clip_percent then
					inventory_slot_component.current_ammunition_clip = math.round(max_ammo_clip * data.ammo_clip_percent)
				end
			end

			if selected_data.grenades_percent then
				local ability_extension = ScriptUnit.extension(player_unit, "ability_system")
				local equipped_abilities = ability_extension:equipped_abilities()
				local grenade_ability = equipped_abilities.grenade_ability

				if not grenade_ability.exclude_from_persistant_player_data then
					local max_grenades = ability_extension:max_ability_charges("grenade_ability")
					local num_grenades = math.round(selected_data.grenades_percent * max_grenades)

					ability_extension:set_ability_charges("grenade_ability", num_grenades)
				end
			end
		else
			local settings = self._settings.spawn
			local ammo_percentage = settings.ammo_percentage or 1
			local health_percentage = settings.health_percentage or 0
			local grenade_percentage = settings.grenade_percentage or 1
			local weapon_extension = ScriptUnit.has_extension(player_unit, "weapon_system")
			local health_extension = ScriptUnit.has_extension(player_unit, "health_system")
			local ability_extension = ScriptUnit.has_extension(player_unit, "ability_system")

			if weapon_extension then
				weapon_extension:on_player_unit_spawn(ammo_percentage)
			end

			if health_extension then
				health_extension:on_player_unit_spawn(health_percentage)
			end

			if ability_extension then
				ability_extension:on_player_unit_spawn(grenade_percentage)
			end
		end
	end
end

GameModeSurvival.should_spawn_dead = function (self, player)
	if player:is_human_controlled() then
		local account_id = _player_account_id(player)
		local my_data = account_id and self._persistent_data_humans[account_id]

		if my_data then
			local state_name = my_data.character_state_name
			local respawn_dead_states = self._settings.persistent_player_data_settings.respawn_dead_from_character_states

			return table.contains(respawn_dead_states, state_name)
		end
	end

	return false
end

GameModeSurvival.player_time_until_spawn = function (self, player)
	local unique_id = player:unique_id()

	return self._players_respawn_time[unique_id]
end

GameModeSurvival._apply_respawn_penalties = function (self, player)
	local respawn_settings = self._settings.respawn
	local player_unit = player.player_unit

	if respawn_settings and player_unit then
		local ammo_percentage = respawn_settings.ammo_percentage
		local health_percentage = respawn_settings.health_percentage
		local grenade_percentage = respawn_settings.grenade_percentage
		local weapon_extension = ScriptUnit.extension(player_unit, "weapon_system")
		local health_extension = ScriptUnit.extension(player_unit, "health_system")
		local ability_extension = ScriptUnit.extension(player_unit, "ability_system")

		weapon_extension:on_player_unit_respawn(ammo_percentage)
		health_extension:on_player_unit_respawn(health_percentage)
		ability_extension:on_player_unit_respawn(grenade_percentage)
	end
end

GameModeSurvival.can_spawn_player = function (self, player)
	local is_dead = not player:unit_is_alive()
	local time_ready = self:player_time_until_spawn(player) or 0
	local current_time = Managers.time:time("gameplay")
	local can_spawn = is_dead and time_ready < current_time

	return can_spawn
end

GameModeSurvival._set_ready_time_to_spawn = function (self, player, time)
	local unique_id = player:unique_id()

	self._players_respawn_time[unique_id] = time

	if self._is_server then
		local peer_id = player:peer_id()
		local local_player_id = player:local_player_id()

		time = time or 0

		Managers.state.game_session:send_rpc_clients("rpc_set_player_respawn_time", peer_id, local_player_id, time)
	end
end

GameModeSurvival.rpc_set_player_respawn_time = function (self, channel_id, peer_id, local_player_id, time)
	local player_manager = Managers.player
	local player = player_manager:player(peer_id, local_player_id)

	if player then
		if time == 0 then
			self:_set_ready_time_to_spawn(player, nil)
		else
			self:_set_ready_time_to_spawn(player, time)
		end
	end
end

GameModeSurvival.rpc_client_hordes_set_progress_data = function (self, channel_id, current_wave, waves_completed, wave_in_progress)
	Log.info("GameModeSurvival", "Server updated progression. Current Wave: %d, Waves Completed: %d, Wave in progress? %s", current_wave, waves_completed, wave_in_progress and "Y" or "N")

	self._current_wave = current_wave
	self._waves_completed = waves_completed
	self._is_wave_in_progress = wave_in_progress
end

GameModeSurvival.rpc_client_hordes_wave_completed = function (self, channel_id, wave_num)
	Log.info("GameModeSurvival", "Server called wave completed. Waves Completed: %d", wave_num)

	if wave_num > self._waves_completed then
		self:on_wave_completed(wave_num)
	end
end

GameModeSurvival.rpc_client_hordes_show_wave_completed_notification = function (self, channel_id, wave_num)
	Log.info("GameModeSurvival", "Server called show wave completed notification. Waves Completed: %d", wave_num)
	self:_trigger_wave_ended_ui_notification()
end

GameModeSurvival.rpc_client_hordes_tag_remaining_enemies = function (self, channel_id)
	self:_tag_remaining_enemies()
end

GameModeSurvival.get_additional_pickups = function (self)
	if self._islands_completed > 0 then
		return PickupSettings.horde_distribution_pool
	else
		return
	end
end

implements(GameModeSurvival, GameModeBase.INTERFACE)

return GameModeSurvival
