-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_expedition.lua

local Ammo = require("scripts/utilities/ammo")
local BotSpawning = require("scripts/managers/bot/bot_spawning")
local CinematicSceneSettings = require("scripts/settings/cinematic_scene/cinematic_scene_settings")
local GameModeBase = require("scripts/managers/game_mode/game_modes/game_mode_base")
local PlayerManager = require("scripts/foundation/managers/player/player_manager")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local ExpeditionLogicClient = require("scripts/managers/game_mode/game_modes/expedition/expedition_logic_client")
local ExpeditionLogicServer = require("scripts/managers/game_mode/game_modes/expedition/expedition_logic_server")
local CINEMATIC_NAMES = CinematicSceneSettings.CINEMATIC_NAMES
local DEFAULT_RESPAWN_TIME = 30
local CLIENT_RPCS = {
	"rpc_set_player_respawn_time",
	"rpc_fetch_session_report",
}
local SERVER_RPCS = {}

local function _log(...)
	Log.info("GameModeExpedition", ...)
end

local GameModeExpedition = class("GameModeExpedition", "GameModeBase")

GameModeExpedition.init = function (self, game_mode_context, game_mode_name, network_event_delegate)
	GameModeExpedition.super.init(self, game_mode_context, game_mode_name, network_event_delegate)

	self._network_event_delegate = network_event_delegate
	self._can_start_players_check = false
	self._players_respawn_time = {}
	self._end_t = nil

	local is_server = self._is_server

	if is_server then
		self._game_mode_logic = ExpeditionLogicServer:new(network_event_delegate)
	else
		self._game_mode_logic = ExpeditionLogicClient:new(network_event_delegate)
	end

	if is_server then
		network_event_delegate:register_session_events(self, unpack(SERVER_RPCS))

		local event_manager = Managers.event

		event_manager:register(self, "in_safe_volume", "in_safe_volume")

		self._persistent_data_humans = {}
		self._persistent_data_bots = {}
	else
		network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

GameModeExpedition.in_safe_volume = function (self, volume_unit)
	local pacing_enabled = self._game_mode_logic:pacing_enabled()

	if not pacing_enabled then
		_log("[in_safe_volume] %s", volume_unit and "Entered safe volume" or "Exited safe volume")

		if volume_unit then
			self:_restrict_spawning(true)
		else
			self:_restrict_spawning(false)
		end
	end
end

GameModeExpedition._restrict_spawning = function (self, enabled)
	Managers.state.pacing:pause_spawn_type("specials", enabled, "safe_zone")
	Managers.state.pacing:pause_spawn_type("hordes", enabled, "safe_zone")
	Managers.state.pacing:pause_spawn_type("trickle_hordes", enabled, "safe_zone")
	Managers.state.pacing:set_in_safe_zone(enabled)
end

GameModeExpedition.on_gameplay_init = function (self)
	self._game_mode_logic:on_gameplay_init()
end

GameModeExpedition.on_gameplay_post_init = function (self)
	self._game_mode_logic:on_gameplay_post_init()
end

GameModeExpedition.can_player_enter_game = function (self)
	return self._game_mode_logic:can_player_enter_game()
end

GameModeExpedition.hot_join_sync = function (self, sender, channel)
	GameModeExpedition.super.hot_join_sync(self, sender, channel)
	self._game_mode_logic:hot_join_sync(sender, channel)
end

GameModeExpedition.get_current_level_name = function (self)
	local mission_name = self._game_mode_logic:get_mission_level_name()

	return mission_name
end

GameModeExpedition.get_expedition_template = function (self)
	local template = self._game_mode_logic:get_expedition_template()

	return template
end

GameModeExpedition.is_auspex_enabled = function (self)
	local template = self._game_mode_logic:get_expedition_template()

	return template.auspex_map == nil or template.auspex_map
end

GameModeExpedition.get_level_data = function (self, level)
	return self._game_mode_logic:get_level_data(level)
end

GameModeExpedition.get_all_levels_of_specified_tag = function (self, index, valid_types)
	return self._game_mode_logic:get_all_levels_of_specified_tag(index, valid_types)
end

GameModeExpedition.minion_steal = function (self, player_unit, unit)
	self._game_mode_logic:minion_steal(player_unit, unit)
end

GameModeExpedition.current_location_index = function (self)
	return self._game_mode_logic:current_location_index()
end

GameModeExpedition.set_minion_spawn_loot_amount = function (self, unit, starting_amount)
	self._game_mode_logic:set_minion_spawn_loot_amount(unit, starting_amount)
end

GameModeExpedition.check_minion_loot = function (self, unit)
	return self._game_mode_logic:check_minion_loot(unit)
end

GameModeExpedition.remove_minion_loot = function (self, unit)
	return self._game_mode_logic:check_minion_loot(unit)
end

GameModeExpedition.in_safe_zone = function (self)
	return self._game_mode_logic:in_safe_zone()
end

GameModeExpedition.expedition_team_loot = function (self)
	return self._game_mode_logic:expedition_team_loot()
end

GameModeExpedition.expedition_loot = function (self, optional_peer_id)
	return self._game_mode_logic:expedition_loot(optional_peer_id)
end

GameModeExpedition.expedition_currency = function (self, optional_peer_id)
	return self._game_mode_logic:expedition_currency(optional_peer_id)
end

GameModeExpedition.is_store_product = function (self, unit)
	return self._game_mode_logic:is_store_product(unit)
end

GameModeExpedition.can_purchase_product = function (self, interactee_unit, interactor_unit)
	return self._game_mode_logic:can_purchase_product(interactee_unit, interactor_unit)
end

GameModeExpedition.get_unit_store_product_price = function (self, unit)
	return self._game_mode_logic:get_unit_store_product_price(unit)
end

GameModeExpedition.get_unit_store_data = function (self, unit)
	return self._game_mode_logic:get_unit_store_data(unit)
end

GameModeExpedition.server_perform_purchase = function (self, purchase_unit, player)
	return self._game_mode_logic:server_perform_purchase(purchase_unit, player)
end

GameModeExpedition.next_spawn_point_identifier = function (self)
	return self._game_mode_logic:next_spawn_point_identifier()
end

GameModeExpedition.map_minigame = function (self)
	return self._game_mode_logic:map_minigame()
end

GameModeExpedition.mission_cleanup = function (self, on_shutdown)
	GameModeExpedition.super.mission_cleanup(self, on_shutdown)
	self._game_mode_logic:mission_cleanup(on_shutdown)
end

GameModeExpedition.pre_populate_pickups_setup = function (self, pickup_spawners)
	return self._game_mode_logic:pre_populate_pickups_setup(pickup_spawners)
end

GameModeExpedition.get_additional_pickups = function (self)
	return self._game_mode_logic:get_additional_pickups()
end

GameModeExpedition.get_navigation_handler = function (self)
	return self._game_mode_logic:get_navigation_handler()
end

GameModeExpedition.get_objectives_handler = function (self)
	return self._game_mode_logic:get_objectives_handler()
end

GameModeExpedition.get_collectibles_handler = function (self)
	return self._game_mode_logic:get_collectibles_handler()
end

GameModeExpedition.register_level_hazard = function (self, params)
	self._game_mode_logic:register_level_hazard(params)
end

GameModeExpedition.unregister_level_hazard = function (self, params)
	self._game_mode_logic:unregister_level_hazard(params)
end

GameModeExpedition.get_active_level_hazards = function (self)
	return self._game_mode_logic:get_active_level_hazards()
end

GameModeExpedition.clean_up_current_level_hazards = function (self)
	return self._game_mode_logic:clean_up_current_level_hazards()
end

GameModeExpedition.level_hazard_objective_lookup = function (self)
	local level_hazard_objective_lookup = {
		extraction = {
			activated_event = "aa_turrent_shoot",
			objective = "objective_expedition_extract_aa_turrent",
		},
		safe_zone_traversal = {
			activated_event = "activate_distruption",
			objective = "objective_expedition_safe_zone_traversal_power_off",
		},
	}

	return level_hazard_objective_lookup
end

GameModeExpedition.zone_override_times = function (self)
	return self._game_mode_logic:zone_override_times()
end

GameModeExpedition.is_player_in_danger_zone = function (self, player)
	return self._game_mode_logic:is_player_in_danger_zone(player)
end

GameModeExpedition.server_update = function (self, dt, t)
	self._game_mode_logic:update(dt, t)
end

GameModeExpedition.client_update = function (self, dt, t)
	self._game_mode_logic:update(dt, t)
end

GameModeExpedition.destroy = function (self)
	self._game_mode_logic:destroy()

	self._game_mode_logic = nil

	local event_manager = Managers.event

	if self._is_server then
		event_manager:unregister(self, "in_safe_volume")
		self._network_event_delegate:unregister_events(unpack(SERVER_RPCS))
	else
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	GameModeExpedition.super.destroy(self)
end

GameModeExpedition._game_mode_state_changed = function (self, new_state, old_state)
	if not self._is_server and self:_cinematic_active() then
		_log("[_game_mode_state_changed] Force stop cinematics")
		Managers.state.cinematic:stop_all_stories()
	end
end

GameModeExpedition.evaluate_end_conditions = function (self)
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

GameModeExpedition._gamemode_complete = function (self, result, reason)
	_log("gamemode_complete, result: %s, reason: %s", result, reason)
	self._game_mode_logic:send_gamemode_finished_telemetry(result, reason)
	self:_fetch_session_report()
	Managers.state.game_session:send_rpc_clients("rpc_fetch_session_report")

	if Managers.mission_server then
		local mechanism_manager = Managers.mechanism
		local mechanism = mechanism_manager:current_mechanism()
		local mechanism_data = mechanism:mechanism_data()

		Managers.mission_server:on_gamemode_completed(result, reason, {
			settings_version = mechanism_data.settings_version,
			expedition_template = mechanism_data.expedition_template_name,
		})
	end
end

GameModeExpedition.rpc_fetch_session_report = function (self)
	self:_fetch_session_report()
end

GameModeExpedition._fetch_session_report = function (self)
	local session_id = Managers.connection:session_id()

	if DEDICATED_SERVER then
		Managers.progression:fetch_session_report_server(session_id)
	else
		Managers.progression:fetch_session_report(session_id)
	end

	_log("fetch_session_report, session_id: %s", session_id)
end

GameModeExpedition._all_players_disabled = function (self, num_alive_players, alive_players, include_bots)
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

GameModeExpedition._all_players_dead = function (self, num_alive_players, alive_players, include_bots)
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

GameModeExpedition._failure_conditions_met = function (self)
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

GameModeExpedition.pacing_update = function (self, dt, t)
	local game_mode_logic = self._game_mode_logic
	local progression

	if game_mode_logic.pacing_update then
		progression = game_mode_logic:pacing_update(dt, t)
	end

	return progression
end

GameModeExpedition.complete = function (self, reason)
	self._completed = true
	self._end_reason = reason
end

GameModeExpedition.fail = function (self, reason)
	self._failed = true
	self._end_reason = reason
end

GameModeExpedition.on_player_unit_spawn = function (self, player, unit, is_respawn)
	GameModeExpedition.super.on_player_unit_spawn(self, player)

	if self._is_server then
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
	end

	self._game_mode_logic:on_player_unit_spawn(player, unit, is_respawn)
end

GameModeExpedition.on_player_unit_despawn = function (self, player)
	local respawn_settings = self._settings.respawn
	local has_timer = Managers.time:has_timer("gameplay")

	if self._is_server and respawn_settings and has_timer then
		local time = respawn_settings.respawn_time or DEFAULT_RESPAWN_TIME
		local current_time = Managers.time:time("gameplay")
		local time_until_respawn = current_time + time

		self:_set_ready_time_to_spawn(player, time_until_respawn)
	end

	if self._is_server and self._settings.persistent_player_data_settings then
		self:_store_persistent_player_data(player)
	end

	self._game_mode_logic:on_player_unit_despawn(player)
end

local function _player_account_id(player)
	local account_id = player:account_id()

	if account_id and account_id ~= PlayerManager.NO_ACCOUNT_ID then
		return account_id
	end
end

GameModeExpedition._store_persistent_player_data = function (self, player)
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
		local max_ammo_clip = Ammo.max_ammo_in_clips(inventory_slot_component)
		local data = {}

		if max_ammo_reserve > 0 then
			data.ammo_reserve_percent = inventory_slot_component.current_ammunition_reserve / max_ammo_reserve
		end

		if max_ammo_clip > 0 then
			data.ammo_clip_percent = Ammo.current_ammo_in_clips(inventory_slot_component) / max_ammo_clip
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
		grenades_percent = grenades_percent,
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

GameModeExpedition._apply_persistent_player_data = function (self, player)
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

			Log.info("GameModeExpedition", "Player %s inherited persistent data from previous self: %s", account_id, table.tostring(selected_data, 3))
		elseif #bot_data > 0 then
			selected_data = table.remove(bot_data, #bot_data)

			local settings = self._settings.persistent_player_data_settings

			selected_data.damage_percent = math.min(selected_data.damage_percent, settings.max_damage_percent_from_bot)
			selected_data.permanent_damage_percent = math.min(selected_data.permanent_damage_percent, settings.max_permanent_damage_percent_from_bot)

			Log.info("GameModeExpedition", "Player %s inherited persistent data from previous bot: %s", account_id, table.tostring(selected_data, 3))
		end

		local player_unit = player.player_unit

		if selected_data then
			local health_extension = ScriptUnit.extension(player_unit, "health_system")

			health_extension:apply_persistent_data(selected_data.damage_percent, selected_data.permanent_damage_percent)

			local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")

			for slot_name, data in pairs(selected_data.weapon_slot_data) do
				local inventory_slot_component = unit_data_extension:write_component(slot_name)
				local max_ammo_reserve = inventory_slot_component.max_ammunition_reserve
				local max_ammo_clip = Ammo.max_ammo_in_clips(inventory_slot_component)

				if max_ammo_reserve > 0 and data.ammo_reserve_percent then
					inventory_slot_component.current_ammunition_reserve = math.round(max_ammo_reserve * data.ammo_reserve_percent)
				end

				if max_ammo_clip > 0 and data.ammo_clip_percent then
					Ammo.set_current_ammo_in_clips(inventory_slot_component, math.round(max_ammo_clip * data.ammo_clip_percent))
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

GameModeExpedition.should_spawn_dead = function (self, player)
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

GameModeExpedition.player_time_until_spawn = function (self, player)
	local unique_id = player:unique_id()

	return self._players_respawn_time[unique_id]
end

GameModeExpedition._apply_respawn_penalties = function (self, player)
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

GameModeExpedition.can_spawn_player = function (self, player)
	local is_dead = not player:unit_is_alive()
	local time_ready = self:player_time_until_spawn(player) or 0
	local current_time = Managers.time:time("gameplay")
	local can_spawn = is_dead and time_ready < current_time

	return can_spawn
end

GameModeExpedition._set_ready_time_to_spawn = function (self, player, time)
	local unique_id = player:unique_id()

	self._players_respawn_time[unique_id] = time

	if self._is_server then
		local peer_id = player:peer_id()
		local local_player_id = player:local_player_id()

		time = time or 0

		Managers.state.game_session:send_rpc_clients("rpc_set_player_respawn_time", peer_id, local_player_id, time)
	end
end

GameModeExpedition.rpc_set_player_respawn_time = function (self, channel_id, peer_id, local_player_id, time)
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

GameModeExpedition._on_client_joined = function (self, peer_id)
	GameModeExpedition.super._on_client_joined(self, peer_id)
end

GameModeExpedition._on_client_left = function (self, removed_players_data, host_became_empty)
	GameModeExpedition.super._on_client_left(self, removed_players_data, host_became_empty)
end

implements(GameModeExpedition, GameModeBase.INTERFACE)

return GameModeExpedition
