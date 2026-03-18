-- chunkname: @scripts/managers/game_mode/game_modes/expedition/expedition_logic_client.lua

require("scripts/managers/game_mode/game_modes/expedition/expedition_logic_base")

local ExpeditionLogicSettings = require("scripts/managers/game_mode/game_modes/expedition/expedition_logic_settings")
local ExpeditionLogicClient = class("ExpeditionLogicClient", "ExpeditionLogicBase")

ExpeditionLogicClient.init = function (self, network_event_delegate)
	ExpeditionLogicClient.super.init(self, network_event_delegate)

	local client_rpcs = ExpeditionLogicSettings.client_rpcs

	network_event_delegate:register_session_events(self, unpack(client_rpcs))
end

ExpeditionLogicClient.update = function (self, dt, t)
	local levels_spawner = self._levels_spawner

	levels_spawner:update(dt)
	self:_client_update_safe_zone()
	self:_client_update_teleport()

	if self._report_after_despawning_levels then
		if not self._levels_spawner:despawning() then
			self._report_after_despawning_levels = false

			Managers.state.game_session:send_rpc_server("rpc_server_expedition_levels_despawned_by_player")
		end
	elseif self._report_when_section_spawned and levels_spawner:is_all_level_loading_done() then
		if levels_spawner:done() then
			levels_spawner:clear_done()

			self._report_when_section_spawned = false

			local current_section_index = self._current_section_index

			Managers.state.game_session:send_rpc_server("rpc_server_location_loaded_and_spawned_by_player", current_section_index)
		elseif levels_spawner:loading() then
			self._levels_spawner:unload_despawned_levels()
			self:_spawn_loaded_levels()
		end
	end

	ExpeditionLogicClient.super.update(self, dt, t)
end

ExpeditionLogicClient._client_update_safe_zone = function (self)
	local safe_zone_section = self:_get_active_safe_zone_section()

	if not safe_zone_section then
		return
	end

	local currency_handler = self._currency_handler
	local collected_team_currency = currency_handler:collected_team_currency()

	if not safe_zone_section.latest_currency_update or safe_zone_section.latest_currency_update ~= collected_team_currency then
		safe_zone_section.latest_currency_update = collected_team_currency

		local purchase_data_by_store_unit = safe_zone_section.purchase_data_by_store_unit

		if purchase_data_by_store_unit then
			for owner_unit, pickup_data in pairs(purchase_data_by_store_unit) do
				self:_refresh_safe_zone_unit_store_data_presentation(pickup_data)
			end
		end
	end
end

ExpeditionLogicClient._client_update_teleport = function (self)
	if not self._setup_player_teleport then
		return
	end

	local player_manager = Managers.player
	local local_players = player_manager:players_at_peer(Network.peer_id())

	if local_players then
		for local_player_id, player in pairs(local_players) do
			if player:is_human_controlled() then
				local old_orintation = player:get_orientation()
				local new_yaw = old_orintation.yaw + (self._teleport_target_yaw - self._teleport_origin_yaw)

				player:set_orientation(new_yaw, old_orintation.pitch, old_orintation.roll)
			end
		end

		self._setup_player_teleport = false
	end
end

ExpeditionLogicClient.event_expedition_teleport_players_to_store = function (self, level, teleporter_unit)
	self._setup_player_teleport = true

	local current_section = self._expedition[self._current_section_index]

	self._teleport_origin_yaw = Quaternion.yaw(Unit.world_rotation(current_section.connector_exit_unit, 1))
	self._teleport_target_yaw = Quaternion.yaw(Unit.world_rotation(current_section.safe_zone_entrance_slot_unit, 1))
end

ExpeditionLogicClient.event_expedition_teleport_players_from_store = function (self, level, exit_safe_zone_location_unit)
	self._setup_player_teleport = true

	local current_section = self._expedition[self._current_section_index]

	self._teleport_target_yaw = Quaternion.yaw(Unit.world_rotation(current_section.connector_entrance_unit, 1))
	self._teleport_origin_yaw = Quaternion.yaw(Unit.world_rotation(exit_safe_zone_location_unit, 1))
end

ExpeditionLogicClient.destroy = function (self, dt, t)
	local client_rpcs = ExpeditionLogicSettings.client_rpcs

	self._network_event_delegate:unregister_events(unpack(client_rpcs))
	ExpeditionLogicClient.super.destroy(self)
end

return ExpeditionLogicClient
