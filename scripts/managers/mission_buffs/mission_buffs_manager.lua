-- chunkname: @scripts/managers/mission_buffs/mission_buffs_manager.lua

local HordesBuffsData = require("scripts/settings/buff/hordes_buffs/hordes_buffs_data")
local HordesModeSettings = require("scripts/settings/hordes_mode_settings")
local MissionBuffsHandler = require("scripts/managers/mission_buffs/mission_buffs_handler")
local MissionBuffsSelector = require("scripts/managers/mission_buffs/mission_buffs_selector")
local MissionBuffsUIManager = require("scripts/managers/mission_buffs/mission_buffs_ui_manager")
local MissionBuffsManager = class("MissionBuffsManager")
local CLIENT_RPCS = {
	"rpc_client_mission_buffs_buff_choices_received",
	"rpc_client_mission_buffs_buff_received",
	"rpc_client_mission_buffs_family_received",
}
local EVENTS = {
	{
		"mission_buffs_event_player_spawned",
		"_manage_player_spawn",
	},
	{
		"mission_buffs_event_notify_buff_to_player",
		"notify_buff_given_to_player",
	},
	{
		"mission_buffs_event_add_externally_controlled_to_player",
		"_add_externally_controlled_buff_to_player",
	},
	{
		"mission_buffs_event_request_specific_buff",
		"_request_specific_buff",
	},
	{
		"mission_buffs_event_request_family_buff_choice",
		"_request_buff_family_choice",
	},
	{
		"mission_buffs_event_request_family_buff_for_all",
		"_request_family_buff_for_all",
	},
	{
		"mission_buffs_event_request_legendary_buff_choice",
		"_request_legendary_buff_choice",
	},
	{
		"event_surival_mode_buff_choice",
		"_notify_server_buff_choice",
	},
}

MissionBuffsManager._register_rpcs = function (self, network_event_delegate)
	if not self._is_server then
		network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

MissionBuffsManager._unregister_rpcs = function (self, network_event_delegate)
	if not self._is_server then
		network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end
end

MissionBuffsManager._register_events = function (self)
	for _, event in ipairs(EVENTS) do
		Managers.event:register(self, event[1], event[2])
	end
end

MissionBuffsManager._unregister_events = function (self)
	for _, event in ipairs(EVENTS) do
		Managers.event:unregister(self, event[1])
	end
end

MissionBuffsManager.init = function (self, is_server, game_mode, game_mode_name, network_event_delegate)
	self._mission_buffs_handler = nil
	self._mission_buffs_selector = nil
	self._is_server = is_server
	self._game_mode = game_mode
	self._game_mode_name = game_mode_name
	self._network_event_delegate = network_event_delegate

	if self:_is_server_or_host() then
		self._mission_buffs_handler = MissionBuffsHandler:new(self, game_mode, is_server)
		self._mission_buffs_selector = MissionBuffsSelector:new(self, self._mission_buffs_handler, network_event_delegate, is_server)

		local buffs_to_exclude_promise = Managers.backend.interfaces.hordes:deactivate_buffs_from_the_backend()

		buffs_to_exclude_promise:next(callback(self, "cb_backend_buffs_to_exclude_received")):catch(callback(self, "cb_backend_buffs_to_exclude_failed"))

		self._backend_buffs_to_exclude = nil
		self._players_needing_data_initialization = {}
	end

	self._mission_buffs_ui_manager = MissionBuffsUIManager:new(self, game_mode, is_server, network_event_delegate)

	self:_register_events()
	self:_register_rpcs(network_event_delegate)
end

MissionBuffsManager.destroy = function (self)
	self:_unregister_events()
	self:_unregister_rpcs(self._network_event_delegate)

	self._game_mode = nil
	self._network_event_delegate = nil

	if self:_is_server_or_host() then
		self._mission_buffs_selector:destroy()
		self._mission_buffs_handler:destroy()

		self._mission_buffs_selector = nil
		self._mission_buffs_handler = nil

		table.clear(self._players_needing_data_initialization)
	end

	self._mission_buffs_ui_manager:destroy()

	self._mission_buffs_ui_manager = nil
end

MissionBuffsManager.check_if_all_players_chosen_family = function (self)
	self._mission_buffs_handler:check_if_all_players_chosen_family()
end

MissionBuffsManager.does_player_have_buff_saved = function (self, player, buff_name)
	return self._mission_buffs_handler:does_player_have_buff_saved(player, buff_name)
end

MissionBuffsManager.try_show_new_ui_notification = function (self)
	self._mission_buffs_ui_manager:try_show_new_ui_notification()
end

MissionBuffsManager.get_buffs_to_exclude = function (self)
	return self._backend_buffs_to_exclude
end

MissionBuffsManager.get_buff_family_selected_by_player = function (self, player)
	return self._mission_buffs_handler:get_buff_family_selected_by_player(player)
end

MissionBuffsManager.cb_backend_buffs_to_exclude_received = function (self, buffs_to_exclude)
	local excluded_buffs = {}
	local excluded_buffs_message = "Buffs Excluded: "

	for _, buff_name in pairs(buffs_to_exclude) do
		excluded_buffs[buff_name] = true
		excluded_buffs_message = excluded_buffs_message .. buff_name .. " || "
	end

	Log.info("MissionBuffsManager", excluded_buffs_message)

	self._backend_buffs_to_exclude = excluded_buffs

	self:_manage_delayed_data_initialization_for_players()
end

MissionBuffsManager.cb_backend_buffs_to_exclude_failed = function (self, err)
	Log.error("MissionBuffsManager", string.format("Could not get backend list of buffs to exclude. Error: %s", err.description))

	self._backend_buffs_to_exclude = {}

	self:_manage_delayed_data_initialization_for_players()
end

MissionBuffsManager.give_player_silent_buff_not_saved_to_player_data = function (self, player, buff_name)
	self._mission_buffs_handler:give_buff_to_player(player, buff_name, true, true)
end

MissionBuffsManager.check_catchup_for_new_player = function (self, player, override_waves_completed_num)
	local does_player_have_family_selected = self._mission_buffs_handler:does_player_have_family_selected(player)

	if not does_player_have_family_selected then
		Log.error("MissionBuffsManager", "Tried triggering catchup on player without family selected! Once they select their family, catchup will be triggered again.")

		return
	end

	local waves_completed = self._game_mode:get_last_wave_completed()

	waves_completed = override_waves_completed_num or waves_completed

	local missing_legendary_buffs, missing_family_buffs = self:_get_catchup_buff_counts_for_player(player, waves_completed)
	local wave_num
	local num_choices = 3
	local legendary_buff_waves = HordesModeSettings.give_legendary_buffs_at_waves

	for i = 1, missing_legendary_buffs do
		wave_num = legendary_buff_waves[i]

		self._mission_buffs_selector:create_legendary_buff_choice_for_player(player, wave_num, num_choices)
	end

	self._mission_buffs_selector:try_start_new_buff_choice_for_player(player)

	local skip_notification = true

	for i = 1, missing_family_buffs do
		self._mission_buffs_selector:give_family_buff_to_player(player, skip_notification)
	end
end

MissionBuffsManager._get_catchup_buff_counts_for_player = function (self, player, waves_completed)
	local islands_completed = self._game_mode:get_islands_completed()
	local extra_legendary_buffs_needed = islands_completed * HordesModeSettings.num_legendary_buffs_per_island
	local extra_family_buffs_needed = islands_completed * (HordesModeSettings.num_family_buffs_per_island + 1)
	local num_family_buffs_received, num_legendary_buffs_received = self._mission_buffs_handler:get_num_buffs_given_to_player(player)
	local num_queued_legendary_buffs_choices = self._mission_buffs_handler:get_num_legendary_buff_choices_pending_for_player(player)
	local target_num_legendary_buffs = self._get_num_buffs_for_waves_completed(waves_completed, HordesModeSettings.give_legendary_buffs_at_waves)

	target_num_legendary_buffs = target_num_legendary_buffs + extra_legendary_buffs_needed

	local target_num_family_buffs = self._get_num_buffs_for_waves_completed(waves_completed, HordesModeSettings.give_family_buffs_at_waves) + 1

	target_num_family_buffs = target_num_family_buffs + extra_family_buffs_needed

	local missing_legendary_buffs = target_num_legendary_buffs - num_legendary_buffs_received - num_queued_legendary_buffs_choices
	local missing_family_buffs = target_num_family_buffs - num_family_buffs_received

	Log.info("MissionBuffsManager", "Catchup Triggered for Player (PeerID: %s) -> Islands Completed: %d | Waves Completed: %d | TarFam: %d | TarLeg: %d | FamRec: %d | LegRec: %d | LegQue: %d | MisLeg: %d | MisFam: %d", player:peer_id(), islands_completed, waves_completed, target_num_family_buffs, target_num_legendary_buffs, num_family_buffs_received, num_legendary_buffs_received, num_queued_legendary_buffs_choices, missing_legendary_buffs, missing_family_buffs)

	return missing_legendary_buffs, missing_family_buffs
end

MissionBuffsManager._get_num_buffs_for_waves_completed = function (waves_completed, waves_list)
	local num_legendary_buffs = 0

	for i = 1, #waves_list do
		if waves_completed >= waves_list[i] then
			num_legendary_buffs = num_legendary_buffs + 1
		end
	end

	return num_legendary_buffs
end

MissionBuffsManager._manage_delayed_data_initialization_for_players = function (self)
	local players = self._players_needing_data_initialization

	for _, player in pairs(players) do
		self:_manage_player_spawn(player, false)
	end

	table.clear(self._players_needing_data_initialization)
end

MissionBuffsManager._manage_player_spawn = function (self, player, is_respawn)
	local is_human = player:is_human_controlled()

	if not is_human or not self:_is_server_or_host() then
		return
	end

	local buffs_to_exclude_received_from_backend = self._backend_buffs_to_exclude ~= nil
	local player_account_id = player:account_id()

	if not buffs_to_exclude_received_from_backend and not self._players_needing_data_initialization[player_account_id] then
		self._players_needing_data_initialization[player_account_id] = player

		return
	end

	local mission_buffs_handler = self._mission_buffs_handler
	local mission_buffs_selector = self._mission_buffs_selector
	local player_has_existing_data = mission_buffs_handler:does_player_have_existing_data(player)
	local player_has_legendary_buffs_pool = mission_buffs_handler:does_player_have_legendary_buffs_pool(player)

	if not player_has_legendary_buffs_pool then
		mission_buffs_selector:init_legendary_buffs_pool_for_player(player, self._backend_buffs_to_exclude)
	end

	if player_has_existing_data then
		mission_buffs_handler:restore_buffs_given_to_player(player)
	end

	local player_needs_buff_family, player_has_existing_family_choice_pending = mission_buffs_handler:check_player_buff_family_state(player)

	if player_needs_buff_family then
		if player_has_existing_family_choice_pending then
			mission_buffs_selector:try_start_new_buff_choice_for_player(player)
		else
			mission_buffs_selector:create_buff_family_choice_for_player(player, 3)
		end
	elseif player_has_existing_data then
		mission_buffs_selector:try_start_new_buff_choice_for_player(player)
	end

	self:check_catchup_for_new_player(player, self._game_mode:get_last_wave_completed())
	mission_buffs_handler:log_player_data(player)
end

MissionBuffsManager._request_specific_buff = function (self, buff_name, target_self)
	if target_self then
		self:_request_buff_for_self(buff_name)
	else
		self:_request_buff_for_all(buff_name)
	end
end

MissionBuffsManager._request_buff_family_choice = function (self, num_choices)
	local is_server_or_host = self:_is_server_or_host()

	if not is_server_or_host then
		Log.error("MissionBuffsManager", "Can only request buff family choice from the server!")

		return
	end

	self._mission_buffs_handler:buff_family_choice_initiated()

	local buffs_to_exclude_received_from_backend = self._backend_buffs_to_exclude ~= nil

	if not buffs_to_exclude_received_from_backend then
		Log.error("MissionBuffsManager", "No backen list of excluded buffs. Waiting for request.")

		return
	end

	self._mission_buffs_selector:create_buff_family_choice_for_all(num_choices, self._backend_buffs_to_exclude)
end

MissionBuffsManager._request_family_buff_for_all = function (self)
	local is_server_or_host = self:_is_server_or_host()

	if not is_server_or_host then
		Log.error("MissionBuffsManager", "Can only request family buff from the server!")

		return
	end

	self._mission_buffs_selector:give_family_buff_to_all()
end

MissionBuffsManager._request_legendary_buff_choice = function (self, wave_num, num_choices)
	local is_server_or_host = self:_is_server_or_host()

	if not is_server_or_host then
		Log.error("MissionBuffsManager", "Can only request legendary buff choice from the server!")

		return
	end

	self._mission_buffs_selector:create_legendary_buff_choice_for_all(wave_num, num_choices)
end

MissionBuffsManager.rpc_client_mission_buffs_buff_choices_received = function (self, channel_id, choices_network_id_array, is_buff_family_choice, wave_num)
	local buff_choices_names = self._convert_options_network_id_array_to_names(choices_network_id_array, is_buff_family_choice)

	self._mission_buffs_ui_manager:queue_choice_selection_ui(is_buff_family_choice, buff_choices_names, wave_num)
end

MissionBuffsManager.rpc_client_mission_buffs_buff_received = function (self, channel_id, buff_template_id, wave_num)
	local buff_name = NetworkLookup.buff_templates[buff_template_id]

	Log.info("MissionBuffsManager", "Buff received %s", buff_name)

	local local_player = Managers.player:local_player(1)
	local local_player_unit = local_player.player_unit
	local local_player_fx_extension = ScriptUnit.has_extension(local_player_unit, "fx_system")
	local buff_family_source_id
	local is_family_buff = HordesBuffsData[buff_name].is_family_buff

	if is_family_buff and self._local_player_active_buff_family then
		buff_family_source_id = "hordes_family_" .. self._local_player_active_buff_family
	end

	self._mission_buffs_ui_manager:queue_buff_received_notification_ui(buff_name, buff_family_source_id, wave_num)
end

MissionBuffsManager.rpc_client_mission_buffs_family_received = function (self, channel_id, buff_family_id)
	local buff_family_name = NetworkLookup.hordes_build_families[buff_family_id]

	Log.info("MissionBuffsManager", "Buff Family received %s", buff_family_name)

	self._local_player_active_buff_family = buff_family_name
end

MissionBuffsManager._request_buff_for_all = function (self, buff_name)
	if self:_is_hosting_client() then
		self._mission_buffs_handler:give_buff_to_all(buff_name)
	elseif self:_is_client() then
		local buff_template_id = NetworkLookup.buff_templates[buff_name]
	end
end

MissionBuffsManager._request_buff_for_self = function (self, buff_name)
	if self:_is_hosting_client() then
		local local_player = Managers.player:local_player(1)

		self._mission_buffs_handler:give_buff_to_player(local_player, buff_name)
	elseif self:_is_client() then
		local buff_template_id = NetworkLookup.buff_templates[buff_name]
		local peer_id, local_player_id = self._get_local_player_peer_and_local_id()
	end
end

MissionBuffsManager.notify_buff_given_to_player = function (self, player, buff_name)
	local buff_template_id = NetworkLookup.buff_templates[buff_name]
	local is_player_hosting_client = self._is_hosting_player(player)
	local wave_num = self._game_mode._waves_completed

	if DEDICATED_SERVER or not is_player_hosting_client then
		local player_peer_id = player:peer_id()
		local game_session = Managers.state.game_session
		local is_connected_to_client = Managers.state.game_session:connected_to_client(player_peer_id)

		if is_connected_to_client then
			game_session:send_rpc_client("rpc_client_mission_buffs_buff_received", player_peer_id, buff_template_id, wave_num)
		end
	elseif self:_is_hosting_client() and is_player_hosting_client then
		local local_player = Managers.player:local_player(1)
		local local_player_unit = local_player.player_unit
		local local_player_fx_extension = ScriptUnit.has_extension(local_player_unit, "fx_system")
		local buff_family_source_id
		local is_family_buff = HordesBuffsData[buff_name].is_family_buff

		if is_family_buff and self._local_player_active_buff_family then
			buff_family_source_id = "hordes_family_" .. self._local_player_active_buff_family
		end

		self._mission_buffs_ui_manager:queue_buff_received_notification_ui(buff_name, buff_family_source_id, wave_num)
	end
end

MissionBuffsManager._notify_buff_family_given_to_player = function (self, player, buff_family_name)
	local buff_family_id = NetworkLookup.hordes_build_families[buff_family_name]
	local is_player_hosting_client = self._is_hosting_player(player)

	if DEDICATED_SERVER or not is_player_hosting_client then
		Managers.state.game_session:send_rpc_client("rpc_client_mission_buffs_family_received", player:peer_id(), buff_family_id)
	elseif self:_is_hosting_client() and is_player_hosting_client then
		self._local_player_active_buff_family = buff_family_name
	end
end

MissionBuffsManager._add_externally_controlled_buff_to_player = function (self, player, buff_name)
	if not self:_is_server_or_host() then
		return
	end

	self._mission_buffs_handler:give_buff_to_player(player, buff_name, true)
end

MissionBuffsManager.send_choice_options_to_player = function (self, player, current_choice)
	local is_player_hosting_client = self._is_hosting_player(player)
	local is_buff_family_choice = current_choice.is_buff_family_choice
	local options = current_choice.options
	local wave_num = self._game_mode._waves_completed

	if DEDICATED_SERVER or not is_player_hosting_client then
		local game_session_manager = Managers.state.game_session
		local choices_network_ids = self._convert_options_names_array_to_network_ids(options, is_buff_family_choice)
		local player_peer_id = player:peer_id()
		local is_peer_connected = game_session_manager:connected_to_client(player_peer_id)

		if is_peer_connected then
			Managers.state.game_session:send_rpc_client("rpc_client_mission_buffs_buff_choices_received", player:peer_id(), choices_network_ids, is_buff_family_choice, wave_num)
		end
	elseif self:_is_hosting_client() and is_player_hosting_client then
		self._mission_buffs_ui_manager:queue_choice_selection_ui(is_buff_family_choice, options, wave_num)
	end
end

MissionBuffsManager._notify_server_buff_choice = function (self, choice_index, is_random_selection)
	self._mission_buffs_ui_manager:current_choice_resolved()

	if self:_is_hosting_client() then
		local local_player = Managers.player:local_player(1)

		self._mission_buffs_selector:player_selected_buff_choice(local_player, choice_index)
		self._mission_buffs_selector:try_start_new_buff_choice_for_player(local_player)
	elseif self:_is_client() then
		local peer_id, local_player_id = self._get_local_player_peer_and_local_id()

		Managers.state.game_session:send_rpc_server("rpc_server_mission_buffs_player_buff_choice", peer_id, local_player_id, choice_index)
	end
end

MissionBuffsManager._notify_ui = function (context)
	Managers.event:trigger("event_mission_buffs_update_presentation", context)
end

MissionBuffsManager._is_server_or_host = function (self)
	return self._is_server
end

MissionBuffsManager._is_hosting_client = function (self)
	return not DEDICATED_SERVER and self._is_server
end

MissionBuffsManager._is_hosting_player = function (player)
	local peer_id = player:peer_id()
	local local_peer_id = Network.peer_id()

	return peer_id == local_peer_id
end

MissionBuffsManager._is_client = function (self)
	return not self._is_server
end

MissionBuffsManager._get_local_player_peer_and_local_id = function ()
	local local_player = Managers.player:local_player(1)
	local peer_id = local_player:peer_id()
	local local_player_id = local_player:local_player_id()

	return peer_id, local_player_id
end

MissionBuffsManager._convert_buff_name_to_template_id = function (buff_name)
	return NetworkLookup.buff_templates[buff_name]
end

MissionBuffsManager._convert_buff_template_id_to_name = function (buff_template_id)
	return NetworkLookup.buff_templates[buff_template_id]
end

MissionBuffsManager._convert_options_names_array_to_network_ids = function (options_names_array, is_buff_family_choice)
	local network_lookup = is_buff_family_choice and NetworkLookup.hordes_build_families or NetworkLookup.buff_templates
	local options_network_ids = {}

	for _, buff_template_id in ipairs(options_names_array) do
		table.insert(options_network_ids, network_lookup[buff_template_id])
	end

	return options_network_ids
end

MissionBuffsManager._convert_options_network_id_array_to_names = function (buff_template_ids_array, is_buff_family_choice)
	local network_lookup = is_buff_family_choice and NetworkLookup.hordes_build_families or NetworkLookup.buff_templates
	local buff_template_ids = {}

	for _, buff_name in ipairs(buff_template_ids_array) do
		table.insert(buff_template_ids, network_lookup[buff_name])
	end

	return buff_template_ids
end

return MissionBuffsManager
