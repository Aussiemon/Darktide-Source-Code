-- chunkname: @scripts/utilities/expeditions/expedition_loot_handler.lua

local Text = require("scripts/utilities/ui/text")
local UISettings = require("scripts/settings/ui/ui_settings")
local Vo = require("scripts/utilities/vo")

local function _log(...)
	Log.info("ExpeditionLootHandler", ...)
end

local CLIENT_RPCS = {
	"rpc_client_expedition_loot_collected",
	"rpc_client_expedition_remove_loot_collected",
}
local SERVER_RPCS = {}
local ExpeditionLootHandler = class("ExpeditionLootHandler")

ExpeditionLootHandler.init = function (self, expedition_template, is_server, network_event_delegate)
	self._expedition_template = expedition_template
	self._is_server = is_server
	self._network_event_delegate = network_event_delegate
	self._loot_by_player = {}
	self._peer_id_by_pickup_unit = {}
	self._dropped_loot_by_pickup_unit = {}
	self._dropped_reason_by_pickup_unit = {}
	self._loot_calculations_dirty = false
	self._total_team_loot_collected = 0

	local event_manager = Managers.event

	if self._is_server then
		network_event_delegate:register_session_events(self, unpack(SERVER_RPCS))
		event_manager:register(self, "event_player_died", "event_player_died")
		event_manager:register(self, "event_expedition_loot_collected", "event_expedition_loot_collected")
		event_manager:register(self, "event_expedition_pocketable_collected", "event_expedition_pocketable_collected")
		event_manager:register(self, "event_expedition_convert_and_collect", "event_expedition_convert_and_collect")
		event_manager:register(self, "event_expedition_pocketable_dropped", "event_expedition_pocketable_dropped")
		event_manager:register(self, "event_expedition_player_loot_collected", "event_expedition_player_loot_collected")
		event_manager:register(self, "client_disconnected", "_event_client_disconnected")
	else
		network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

ExpeditionLootHandler.on_gameplay_init = function (self)
	if self._is_server then
		local mission_objective_system = Managers.state.extension:system("mission_objective_system")
		local increment = 0
		local max_incremented = 1

		mission_objective_system:start_mission_objective("expedition_loot", nil, nil, nil, increment, max_incremented)
	end
end

ExpeditionLootHandler.event_player_died = function (self, player)
	self:server_drop_player_loot(player, "death")
end

ExpeditionLootHandler._event_client_disconnected = function (self, network_interface, peer_id, channel_id)
	self._loot_by_player[peer_id] = nil
end

ExpeditionLootHandler.loot_type_settings = function (self, loot_type)
	local expedition_template = self._expedition_template

	if not expedition_template then
		return nil
	end

	local loot_settings = expedition_template.loot_settings

	if not loot_settings then
		return nil
	end

	local loot_settings_by_type = loot_settings.settings_by_type

	if not loot_settings_by_type then
		return nil
	end

	return loot_settings_by_type[loot_type]
end

ExpeditionLootHandler.event_expedition_convert_and_collect = function (self, interactor_unit, loot_type, tier)
	local type_settings = self:loot_type_settings(loot_type)
	local amount = type_settings.values_per_tier[tier]

	Managers.event:trigger("event_expedition_loot_collected", interactor_unit, "small", nil, amount)

	if self._is_server then
		Vo.set_npc_faction_memory("data_reliquary_carried", 0)
	end
end

ExpeditionLootHandler.event_expedition_pocketable_collected = function (self, interactor_unit, loot_type, tier, show_notification)
	local player = Managers.state.player_unit_spawn:owner(interactor_unit)
	local peer_id = player and player:peer_id()
	local type_settings = self:loot_type_settings(loot_type)
	local amount = type_settings.values_per_tier[tier]

	if self._is_server then
		Managers.state.game_session:send_rpc_clients("rpc_client_expedition_loot_collected", peer_id, amount, loot_type, show_notification)

		if show_notification then
			self:_show_collected_materials_notification(peer_id, amount, loot_type)
		end

		self:_add_player_loot_by_type(peer_id, amount, loot_type)
		Vo.set_npc_faction_memory("data_reliquary_carried", 1)
	end
end

ExpeditionLootHandler.event_expedition_pocketable_dropped = function (self, interactor_unit, loot_type, tier, show_notification)
	local player = Managers.state.player_unit_spawn:owner(interactor_unit)
	local peer_id = player and player:peer_id()
	local type_settings = self:loot_type_settings(loot_type)
	local amount = -type_settings.values_per_tier[tier]

	if self._is_server then
		Managers.state.game_session:send_rpc_clients("rpc_client_expedition_loot_collected", peer_id, amount, loot_type, show_notification)

		if show_notification then
			self:_show_collected_materials_notification(peer_id, amount, loot_type)
		end

		self:_add_player_loot_by_type(peer_id, amount, loot_type)
		Vo.set_npc_faction_memory("data_reliquary_carried", 0)
	end
end

ExpeditionLootHandler.event_expedition_player_loot_collected = function (self, interactor_unit, pickup_unit)
	if self._is_server then
		local dropped_loot_by_pickup_unit = self._dropped_loot_by_pickup_unit
		local amount = dropped_loot_by_pickup_unit[pickup_unit] or 0
		local reason = self._dropped_reason_by_pickup_unit[pickup_unit]

		self._dropped_loot_by_pickup_unit[pickup_unit] = nil
		self._dropped_reason_by_pickup_unit[pickup_unit] = nil

		Managers.event:trigger("event_expedition_loot_collected", interactor_unit, "small", nil, amount)

		local player = Managers.state.player_unit_spawn:owner(interactor_unit)

		if player then
			Managers.stats:record_private("hook_expedition_loot_recovered", player, reason, amount)
		end
	end
end

ExpeditionLootHandler.event_expedition_loot_collected = function (self, interactor_unit, loot_type, tier, optional_amount)
	local player = Managers.state.player_unit_spawn:owner(interactor_unit)
	local peer_id = player and player:peer_id()
	local amount

	if optional_amount then
		amount = optional_amount
	else
		local type_settings = self:loot_type_settings(loot_type)

		amount = type_settings.values_per_tier[tier]
	end

	local currency_type = "expedition_loot"

	if self._is_server then
		Managers.state.game_session:send_rpc_clients("rpc_client_expedition_loot_collected", peer_id, amount, loot_type, true)
		self:_show_collected_materials_notification(peer_id, amount, loot_type)
		self:_add_player_loot_by_type(peer_id, amount, loot_type, tier)
	end
end

ExpeditionLootHandler._add_player_loot_by_type = function (self, peer_id, amount, loot_type)
	local loot_by_player = self._loot_by_player

	if not loot_by_player[peer_id] then
		loot_by_player[peer_id] = {}
	end

	if not loot_by_player[peer_id][loot_type] then
		loot_by_player[peer_id][loot_type] = 0
	end

	loot_by_player[peer_id][loot_type] = loot_by_player[peer_id][loot_type] + amount
	self._loot_calculations_dirty = true
end

ExpeditionLootHandler.rpc_client_expedition_remove_loot_collected = function (self, channel_id, peer_id, loot_type, amount_to_deduct)
	self:_add_player_loot_by_type(peer_id, -amount_to_deduct, loot_type)

	self._loot_calculations_dirty = true
end

ExpeditionLootHandler.hot_join_sync = function (self, channel_id)
	local expedition_loot_show_notification = false
	local loot_by_player = self._loot_by_player

	for looter_peer_id, loot_by_type in pairs(loot_by_player) do
		for loot_type, amount in pairs(loot_by_type) do
			RPC.rpc_client_expedition_loot_collected(channel_id, looter_peer_id, amount, loot_type, expedition_loot_show_notification)
		end
	end
end

ExpeditionLootHandler.rpc_client_expedition_loot_collected = function (self, channel_id, peer_id, amount, loot_type, expedition_loot_show_notification)
	self:_add_player_loot_by_type(peer_id, amount, loot_type)

	if expedition_loot_show_notification then
		self:_show_collected_materials_notification(peer_id, amount, loot_type)
	end
end

ExpeditionLootHandler._show_collected_materials_notification = function (self, peer_id, amount, loot_type)
	local player_manager = Managers.player
	local local_player_id = 1
	local player = player_manager:player(peer_id, local_player_id)

	if amount < 0 then
		Managers.event:trigger("event_add_notification_message", "player_loot_drop", {
			currency = "expedition_loot",
			amount = math.abs(amount),
			player = player,
		})
	else
		local player_name = player and player:name()
		local player_slot = player and player.slot and player:slot()
		local player_slot_colors = UISettings.player_slot_colors
		local player_slot_color = player_slot and player_slot_colors[player_slot]

		if player_name and player_slot_color then
			player_name = Text.apply_color_to_text(player_name, player_slot_color)
		end

		local optional_localization_key = "loc_tactical_overlay_crafting_mat_notification"

		Managers.event:trigger("event_add_notification_message", "currency", {
			currency = "expedition_loot",
			amount = amount,
			player_name = player_name,
			optional_localization_key = optional_localization_key,
		})
	end
end

ExpeditionLootHandler.collected_team_loot = function (self)
	return self._total_team_loot_collected
end

ExpeditionLootHandler.add_external_player_pickup_unit = function (self, pickup_unit, amount, reason)
	self._dropped_loot_by_pickup_unit[pickup_unit] = amount
	self._dropped_reason_by_pickup_unit[pickup_unit] = reason

	Managers.state.extension:system("pickup_system"):dropped(pickup_unit)
end

ExpeditionLootHandler.collected_player_loot_by_type = function (self, peer_id, type)
	local loot_by_player = self._loot_by_player
	local player_loot = loot_by_player[peer_id]
	local total_amount = player_loot and player_loot[type] or 0

	return total_amount
end

ExpeditionLootHandler.collected_player_loot = function (self, peer_id)
	local loot_by_player = self._loot_by_player
	local player_loot = loot_by_player[peer_id]
	local total_amount = 0

	if player_loot then
		for _, amount in pairs(player_loot) do
			total_amount = total_amount + amount
		end
	end

	return total_amount
end

ExpeditionLootHandler.server_deduct_player_loot = function (self, peer_id, amount)
	local loot_by_player = self._loot_by_player
	local player_loot_by_type = loot_by_player[peer_id]
	local loot_type = "small"
	local player_small_loot_amount = player_loot_by_type and player_loot_by_type[loot_type]

	if player_small_loot_amount and amount <= player_small_loot_amount then
		player_loot_by_type[loot_type] = player_loot_by_type[loot_type] - amount
		self._loot_calculations_dirty = true

		Managers.state.game_session:send_rpc_clients("rpc_client_expedition_remove_loot_collected", peer_id, loot_type, amount)

		return true
	end

	return false
end

ExpeditionLootHandler.update = function (self, dt, t)
	if self._is_server then
		self:_server_update_loot_amounts(dt, t)
	end

	if self._loot_calculations_dirty then
		self:_update_loot_calculations(dt, t)
	end
end

ExpeditionLootHandler._update_loot_calculations = function (self, dt, t)
	local total_amount = 0
	local loot_by_player = self._loot_by_player

	for peer_id, player_loot in pairs(loot_by_player) do
		for loot_type, loot in pairs(player_loot) do
			total_amount = total_amount + loot
		end
	end

	self._total_team_loot_collected = total_amount
	self._loot_calculations_dirty = false

	if self._is_server then
		local mission_objective_system = Managers.state.extension:system("mission_objective_system")
		local loot_objective = mission_objective_system:active_objective("expedition_loot")

		if loot_objective then
			loot_objective:set_increment(0)
			mission_objective_system:external_update_mission_objective("expedition_loot", nil, dt, total_amount)
		end
	end
end

ExpeditionLootHandler._server_update_loot_amounts = function (self, dt, t)
	return
end

ExpeditionLootHandler.server_drop_player_loot = function (self, player, reason)
	local player_unit = player.player_unit

	if player_unit then
		local player_position = Unit.world_position(player_unit, 1)
		local peer_id = player:peer_id()
		local loot_by_player = self._loot_by_player
		local player_loot_by_type = loot_by_player[peer_id]
		local player_small_loot_amount = player_loot_by_type and player_loot_by_type.small

		if player_small_loot_amount and player_small_loot_amount > 0 then
			player_loot_by_type.small = 0

			Managers.state.game_session:send_rpc_clients("rpc_client_expedition_loot_collected", peer_id, -player_small_loot_amount, "small", true)

			local pickup_name = "expedition_loot_player_drop"
			local extension_manager = Managers.state.extension
			local pickup_system = extension_manager:system("pickup_system")
			local pickup_unit, _ = pickup_system:spawn_pickup(pickup_name, player_position, Quaternion.identity(), nil, nil, nil, nil)

			self._dropped_loot_by_pickup_unit[pickup_unit] = player_small_loot_amount
			self._dropped_reason_by_pickup_unit[pickup_unit] = reason

			pickup_system:dropped(pickup_unit)
		end
	end

	self._loot_calculations_dirty = true
end

ExpeditionLootHandler.server_update_dropped_loot_pickups = function (self)
	local dropped_loot_by_pickup_unit = self._dropped_loot_by_pickup_unit
	local dropped_reason_by_pickup_unit = self._dropped_reason_by_pickup_unit

	for unit, _ in pairs(dropped_loot_by_pickup_unit) do
		if not ALIVE[unit] then
			dropped_loot_by_pickup_unit[unit] = nil
			dropped_reason_by_pickup_unit[unit] = nil
		end
	end
end

ExpeditionLootHandler.destroy = function (self)
	local event_manager = Managers.event

	if self._is_server then
		event_manager:unregister(self, "event_player_died")
		event_manager:unregister(self, "event_expedition_loot_collected")
		event_manager:unregister(self, "event_expedition_pocketable_collected")
		event_manager:unregister(self, "event_expedition_convert_and_collect")
		event_manager:unregister(self, "event_expedition_pocketable_dropped")
		event_manager:unregister(self, "event_expedition_player_loot_collected")
		event_manager:unregister(self, "client_disconnected")
		self._network_event_delegate:unregister_events(unpack(SERVER_RPCS))
	else
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end
end

return ExpeditionLootHandler
