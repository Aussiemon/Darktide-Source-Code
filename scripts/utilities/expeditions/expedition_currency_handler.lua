-- chunkname: @scripts/utilities/expeditions/expedition_currency_handler.lua

local Text = require("scripts/utilities/ui/text")
local UISettings = require("scripts/settings/ui/ui_settings")
local PlayerManager = require("scripts/foundation/managers/player/player_manager")
local CLIENT_RPCS = {
	"rpc_client_expedition_currency_collected",
	"rpc_client_expedition_remove_currency_collected",
	"rpc_client_expedition_currency_set",
}
local SERVER_RPCS = {}
local ExpeditionCurrencyHandler = class("ExpeditionCurrencyHandler")

ExpeditionCurrencyHandler.init = function (self, expedition_template, is_server, network_event_delegate)
	self._expedition_template = expedition_template
	self._settings_by_type = expedition_template.scrap_settings.settings_by_type
	self._is_server = is_server
	self._network_event_delegate = network_event_delegate
	self._currency_by_peer = {}
	self._currency_stored_by_account_id = {}
	self._currecy_collected_at_location = 0
	self._peer_id_by_pickup_unit = {}
	self._currency_calculations_dirty = false
	self._total_team_currency_collected = 0

	local event_manager = Managers.event

	if self._is_server then
		network_event_delegate:register_session_events(self, unpack(SERVER_RPCS))
		event_manager:register(self, "event_expedition_reached_location", "event_expedition_reached_location")
		event_manager:register(self, "host_game_session_manager_player_joined", "_event_client_connected")
		event_manager:register(self, "multiplayer_session_client_disconnected", "_event_client_disconnected")
		event_manager:register(self, "event_expedition_currency_collected", "event_expedition_currency_collected")
	else
		network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

ExpeditionCurrencyHandler.on_gameplay_init = function (self)
	if self._is_server then
		local mission_objective_system = Managers.state.extension:system("mission_objective_system")
		local increment = 0
		local max_incremented = 1

		mission_objective_system:start_mission_objective("expedition_currency", nil, nil, nil, increment, max_incremented)
	end
end

local function _player_account_id(player)
	local account_id = player:account_id()

	if account_id and account_id ~= PlayerManager.NO_ACCOUNT_ID then
		return account_id
	end
end

ExpeditionCurrencyHandler.event_expedition_reached_location = function (self)
	self._currecy_collected_at_location = 0
end

ExpeditionCurrencyHandler._event_client_connected = function (self, peer_id, player)
	local account_id = _player_account_id(player)
	local grant_currency = self._currency_stored_by_account_id[account_id]

	grant_currency = grant_currency or self._currecy_collected_at_location

	if grant_currency then
		self._currency_stored_by_account_id[account_id] = nil

		Managers.state.game_session:send_rpc_clients("rpc_client_expedition_currency_collected", peer_id, grant_currency, false)
		self:_set_player_currency(peer_id, grant_currency)
	end
end

ExpeditionCurrencyHandler._event_client_disconnected = function (self, removed_players_data, host_became_empty)
	if not removed_players_data then
		return
	end

	local currency_by_peer = self._currency_by_peer

	for i = 1, #removed_players_data do
		local player_data = removed_players_data[i]
		local peer_id = player_data.peer_id
		local currency_to_store = currency_by_peer[peer_id]

		if currency_to_store and currency_to_store > 0 then
			self._currency_stored_by_account_id[player_data.account_id] = currency_to_store
			currency_by_peer[peer_id] = nil
			self._currency_calculations_dirty = true
		end
	end
end

ExpeditionCurrencyHandler.event_expedition_currency_collected = function (self, interactor_unit, currency_type, currency_tier)
	local interactor_player = Managers.state.player_unit_spawn:owner(interactor_unit)
	local interactor_peer_id = interactor_player and interactor_player:peer_id()
	local type_settings = self._settings_by_type[currency_type]
	local amount = type_settings.values_per_tier[currency_tier]

	self._currecy_collected_at_location = self._currecy_collected_at_location + amount

	if self._is_server then
		self:_show_collected_materials_notification(interactor_peer_id, amount)

		local player_manager = Managers.player
		local players = player_manager:players()

		for _, player in pairs(players) do
			local valid_player = player:is_human_controlled()

			if valid_player then
				local peer_id = player:peer_id()
				local expedition_currency_show_notification = peer_id == interactor_peer_id

				Managers.state.game_session:send_rpc_clients("rpc_client_expedition_currency_collected", peer_id, amount, expedition_currency_show_notification)
				self:_add_player_currency(peer_id, amount)
			end
		end

		local currency_stored_by_account_id = self._currency_stored_by_account_id

		for account_id, stored_currency in pairs(currency_stored_by_account_id) do
			currency_stored_by_account_id[account_id] = stored_currency + amount
		end
	end
end

ExpeditionCurrencyHandler._add_player_currency = function (self, peer_id, amount)
	local currency_by_peer = self._currency_by_peer

	if not currency_by_peer[peer_id] then
		currency_by_peer[peer_id] = 0
	end

	currency_by_peer[peer_id] = currency_by_peer[peer_id] + amount
	self._currency_calculations_dirty = true
end

ExpeditionCurrencyHandler._set_player_currency = function (self, peer_id, amount)
	local currency_by_peer = self._currency_by_peer

	currency_by_peer[peer_id] = amount
	self._currency_calculations_dirty = true
end

ExpeditionCurrencyHandler.rpc_client_expedition_remove_currency_collected = function (self, channel_id, peer_id, amount_to_deduct)
	self:_add_player_currency(peer_id, -amount_to_deduct)

	self._currency_calculations_dirty = true
end

ExpeditionCurrencyHandler.rpc_client_expedition_currency_collected = function (self, channel_id, peer_id, amount, expedition_currency_show_notification)
	self:_add_player_currency(peer_id, amount)

	if expedition_currency_show_notification then
		self:_show_collected_materials_notification(peer_id, amount)
	end
end

ExpeditionCurrencyHandler.rpc_client_expedition_currency_set = function (self, channel_id, peer_id, amount, expedition_currency_show_notification)
	self:_set_player_currency(peer_id, amount)

	if expedition_currency_show_notification then
		self:_show_collected_materials_notification(peer_id, amount)
	end
end

ExpeditionCurrencyHandler.hot_join_sync = function (self, channel_id)
	local expedition_currency_show_notification = false
	local currency_by_peer = self._currency_by_peer

	for currencyer_peer_id, amount in pairs(currency_by_peer) do
		RPC.rpc_client_expedition_currency_set(channel_id, currencyer_peer_id, amount, expedition_currency_show_notification)
	end
end

ExpeditionCurrencyHandler._show_collected_materials_notification = function (self, peer_id, amount)
	local player_manager = Managers.player
	local local_player_id = 1
	local player = player_manager:player(peer_id, local_player_id)
	local player_name = player and player:name()
	local player_slot = player and player.slot and player:slot()
	local player_slot_colors = UISettings.player_slot_colors
	local player_slot_color = player_slot and player_slot_colors[player_slot]

	if player_name and player_slot_color then
		player_name = Text.apply_color_to_text(player_name, player_slot_color)
	end

	local optional_localization_key = "loc_tactical_overlay_crafting_mat_notification"

	Managers.event:trigger("event_add_notification_message", "currency", {
		currency = "expedition_salvage",
		amount = amount,
		player_name = player_name,
		optional_localization_key = optional_localization_key,
	})
end

ExpeditionCurrencyHandler.collected_team_currency = function (self)
	return self._total_team_currency_collected
end

ExpeditionCurrencyHandler.collected_player_currency = function (self, peer_id)
	local currency_by_peer = self._currency_by_peer
	local player_currency = currency_by_peer[peer_id] or 0

	return player_currency
end

ExpeditionCurrencyHandler.server_deduct_player_currency = function (self, peer_id, amount)
	local currency_by_peer = self._currency_by_peer
	local player_currency_amount = currency_by_peer[peer_id]

	if player_currency_amount and amount <= player_currency_amount then
		currency_by_peer[peer_id] = player_currency_amount - amount
		self._currency_calculations_dirty = true

		Managers.state.game_session:send_rpc_clients("rpc_client_expedition_remove_currency_collected", peer_id, amount)

		return true
	end

	return false
end

ExpeditionCurrencyHandler.update = function (self, dt, t)
	if self._currency_calculations_dirty then
		self:_update_currency_calculations(dt, t)
	end
end

ExpeditionCurrencyHandler._update_currency_calculations = function (self, dt, t)
	local total_amount = 0
	local currency_by_peer = self._currency_by_peer

	for peer_id, player_currency in pairs(currency_by_peer) do
		total_amount = total_amount + player_currency
	end

	self._total_team_currency_collected = total_amount
	self._currency_calculations_dirty = false

	if self._is_server then
		local mission_objective_system = Managers.state.extension:system("mission_objective_system")
		local currency_objective = mission_objective_system:active_objective("expedition_currency")

		if currency_objective then
			currency_objective:set_increment(0)
			mission_objective_system:external_update_mission_objective("expedition_currency", nil, dt, total_amount)
		end
	end
end

ExpeditionCurrencyHandler.destroy = function (self)
	local event_manager = Managers.event

	if self._is_server then
		event_manager:unregister(self, "event_expedition_currency_collected")
		event_manager:unregister(self, "host_game_session_manager_player_joined")
		event_manager:unregister(self, "multiplayer_session_client_disconnected")
		self._network_event_delegate:unregister_events(unpack(SERVER_RPCS))
	else
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end
end

return ExpeditionCurrencyHandler
