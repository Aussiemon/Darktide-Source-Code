-- chunkname: @scripts/managers/game_mode/game_modes/expedition/expedition_logic_client.lua

require("scripts/managers/game_mode/game_modes/expedition/expedition_logic_base")

local ExpeditionLogicSettings = require("scripts/managers/game_mode/game_modes/expedition/expedition_logic_settings")
local Expedition = require("scripts/utilities/expedition")
local PlayerMovement = require("scripts/utilities/player_movement")
local ExpeditionLogicClient = class("ExpeditionLogicClient", "ExpeditionLogicBase")

ExpeditionLogicClient.init = function (self, network_event_delegate)
	ExpeditionLogicClient.super.init(self, network_event_delegate)

	local client_rpcs = ExpeditionLogicSettings.client_rpcs

	network_event_delegate:register_session_events(self, unpack(client_rpcs))

	self._translated_ragdolls = {}
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
			local spawn_ready = true

			if spawn_ready then
				levels_spawner:clear_done()

				self._report_when_section_spawned = false

				local current_section_index = self._current_section_index

				Managers.state.game_session:send_rpc_server("rpc_server_location_loaded_and_spawned_by_player", current_section_index)
			end
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
	local current_section = self._expedition[self._current_section_index]
	local connector_exit_unit = current_section.connector_exit_unit
	local safe_zone_entrance_slot_unit = current_section.safe_zone_entrance_slot_unit

	self._setup_player_teleport = true
	self._teleport_origin_yaw = Quaternion.yaw(Unit.world_rotation(connector_exit_unit, 1))
	self._teleport_target_yaw = Quaternion.yaw(Unit.world_rotation(safe_zone_entrance_slot_unit, 1))

	local transition_level = current_section.connector_exit_level
	local volume_name = Level.has_volume(transition_level, "transition_area") and "transition_area" or nil

	self:_teleport_ragdolls_to_target(safe_zone_entrance_slot_unit, connector_exit_unit, transition_level, volume_name)
end

ExpeditionLogicClient.event_expedition_teleport_players_from_store = function (self, level, exit_safe_zone_location_unit)
	local expedition = self._expedition
	local current_section = expedition[self._current_section_index]
	local connector_entrance_unit = current_section.connector_entrance_unit
	local previous_section = expedition[self._current_section_index - 1]
	local safe_zone_connector_exit_unit = previous_section.safe_zone_connector_exit_unit

	self._setup_player_teleport = true
	self._teleport_target_yaw = Quaternion.yaw(Unit.world_rotation(connector_entrance_unit, 1))
	self._teleport_origin_yaw = Quaternion.yaw(Unit.world_rotation(safe_zone_connector_exit_unit, 1))

	local transition_level = previous_section.safe_zone_connector_exit_level
	local volume_name = Level.has_volume(transition_level, "transition_area") and "transition_area" or nil

	self:_teleport_ragdolls_to_target(connector_entrance_unit, safe_zone_connector_exit_unit, transition_level, volume_name)
end

ExpeditionLogicClient._teleport_ragdolls_to_target = function (self, target_unit, relative_unit, transition_level, volume_name)
	local function _new_rotation_and_position(previous_rotation, previous_position)
		local relative_rotation, relative_position = PlayerMovement.calculate_relative_rotation_position(relative_unit, previous_rotation, previous_position)

		return PlayerMovement.calculate_absolute_rotation_position(target_unit, relative_rotation, relative_position)
	end

	table.clear(self._translated_ragdolls)

	local minion_death_manager = Managers.state.minion_death
	local minion_ragdoll = minion_death_manager:minion_ragdoll()
	local ragdolls = minion_ragdoll:get_ragdolls()

	for _, unit in pairs(ragdolls) do
		local ragdoll_position = Unit.world_position(unit, 1)

		if ragdoll_position and Level.is_point_inside_volume(transition_level, volume_name, ragdoll_position) then
			self._translated_ragdolls[unit] = true

			local ragdoll_rotation = Unit.world_rotation(unit, 1)
			local absolute_rotation, absolute_position = _new_rotation_and_position(ragdoll_rotation, ragdoll_position)

			Unit.set_local_position(unit, 1, absolute_position)
			Unit.set_local_rotation(unit, 1, absolute_rotation)

			local num_actors = Unit.num_actors(unit)

			for i = 1, num_actors do
				local actor = Unit.actor(unit, i)

				if actor then
					local actor_position = Actor.position(actor)
					local actor_rotation = Actor.rotation(actor)
					local absolute_actor_rotation, absolute_actor_position = _new_rotation_and_position(actor_rotation, actor_position)

					Actor.teleport_position(actor, absolute_actor_position)
					Actor.teleport_rotation(actor, absolute_actor_rotation)
				end
			end
		end
	end
end

ExpeditionLogicClient._clear_location_systems = function (self)
	Managers.state.minion_death:delete_units_except(self._translated_ragdolls)
	table.clear(self._translated_ragdolls)
	ExpeditionLogicClient.super._clear_location_systems(self)
end

ExpeditionLogicClient.destroy = function (self, dt, t)
	local client_rpcs = ExpeditionLogicSettings.client_rpcs

	self._network_event_delegate:unregister_events(unpack(client_rpcs))
	ExpeditionLogicClient.super.destroy(self)
end

return ExpeditionLogicClient
