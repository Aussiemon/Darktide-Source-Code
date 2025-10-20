-- chunkname: @scripts/managers/mission_buffs/mission_buffs_manager.lua

local MissionBuffsHandler = require("scripts/managers/mission_buffs/mission_buffs_handler")
local MissionBuffsManager = class("MissionBuffsManager")
local CLIENT_RPCS = {
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
	self._is_server = is_server
	self._game_mode = game_mode
	self._game_mode_name = game_mode_name
	self._network_event_delegate = network_event_delegate

	if self:_is_server_or_host() then
		self._mission_buffs_handler = MissionBuffsHandler:new(self, game_mode, is_server)
		self._players_needing_data_initialization = {}
	end

	self:_register_events()
	self:_register_rpcs(network_event_delegate)
end

MissionBuffsManager.destroy = function (self)
	self:_unregister_events()
	self:_unregister_rpcs(self._network_event_delegate)

	self._game_mode = nil
	self._network_event_delegate = nil

	if self:_is_server_or_host() then
		self._mission_buffs_handler:destroy()

		self._mission_buffs_handler = nil

		table.clear(self._players_needing_data_initialization)
	end
end

MissionBuffsManager.does_player_have_buff_saved = function (self, player, buff_name)
	return self._mission_buffs_handler:does_player_have_buff_saved(player, buff_name)
end

MissionBuffsManager.give_player_silent_buff_not_saved_to_player_data = function (self, player, buff_name)
	self._mission_buffs_handler:give_buff_to_player(player, buff_name, true, true)
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
	local player_has_existing_data = mission_buffs_handler:does_player_have_existing_data(player)

	if player_has_existing_data then
		mission_buffs_handler:restore_buffs_given_to_player(player)
	end

	mission_buffs_handler:log_player_data(player)
end

MissionBuffsManager._request_specific_buff = function (self, buff_name, target_self)
	if target_self then
		self:_request_buff_for_self(buff_name)
	else
		self:_request_buff_for_all(buff_name)
	end
end

MissionBuffsManager.rpc_client_mission_buffs_buff_received = function (self, channel_id, buff_template_id, wave_num)
	local buff_name = NetworkLookup.buff_templates[buff_template_id]

	Log.info("MissionBuffsManager", "Buff received %s", buff_name)
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
		-- Nothing
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
