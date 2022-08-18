local NetworkLookup = require("scripts/network_lookup/network_lookup")
local TriggerActionBase = class("TriggerActionBase")

TriggerActionBase.init = function (self, is_server, volume_unit, params)
	self._is_server = is_server
	self._volume_unit = volume_unit
	self._side_system = Managers.state.extension:system("side_system")
	self._target = params.action_target
	self._player_side = params.action_player_side
	self._component_guid = params.component_guid
	local trigger_machine_targets_lookup = NetworkLookup.trigger_machine_targets
	local action_machine_target = params.action_machine_target
	self._action_on_client = action_machine_target == trigger_machine_targets_lookup.client or action_machine_target == trigger_machine_targets_lookup.server_and_client
	self._action_on_server = action_machine_target == trigger_machine_targets_lookup.server or action_machine_target == trigger_machine_targets_lookup.server_and_client
end

TriggerActionBase.destroy = function (self)
	return
end

TriggerActionBase.volume_unit = function (self)
	return self._volume_unit
end

TriggerActionBase.is_server = function (self)
	return self._is_server
end

TriggerActionBase.action_on_client = function (self)
	return self._action_on_client
end

TriggerActionBase.action_on_server = function (self)
	return self._action_on_server
end

TriggerActionBase.target = function (self)
	return self._target
end

TriggerActionBase.on_activate = function (self, entering_unit, registered_units, dt, t)
	if self:is_server() then
		local action_targets = NetworkLookup.trigger_action_targets

		if self._target == action_targets.none then
			self:local_on_activate(entering_unit)
		elseif self._target == action_targets.player_side then
			local side_name = self._player_side
			local side_system = self._side_system
			local side = side_system:get_side_from_name(side_name)
			local player_units = side.player_units

			for _, unit in ipairs(player_units) do
				self:_activate_on_unit(unit)
			end
		elseif self._target == action_targets.entering_unit or self._target == action_targets.entering_and_exiting_unit then
			self:_activate_on_unit(entering_unit)
		elseif self._target == action_targets.units_in_volume then
			for unit, _ in pairs(registered_units) do
				self:_activate_on_unit(unit)
			end
		end
	end
end

TriggerActionBase.on_deactivate = function (self, exiting_unit, registered_units)
	if self:is_server() then
		local action_targets = NetworkLookup.trigger_action_targets

		if self._target == action_targets.none then
			self:local_on_deactivate(exiting_unit)
		elseif self._target == action_targets.player_side then
			local side_name = self._player_side
			local side_system = self._side_system
			local side = side_system:get_side_from_name(side_name)
			local player_units = side.player_units

			for _, unit in ipairs(player_units) do
				self:_deactivate_on_unit(unit)
			end
		elseif self._target == action_targets.exiting_unit or self._target == action_targets.entering_and_exiting_unit then
			self:_deactivate_on_unit(exiting_unit)
		elseif self._target == action_targets.units_in_volume then
			for unit, _ in pairs(registered_units) do
				self:_deactivate_on_unit(unit)
			end
		end
	end
end

TriggerActionBase.on_unit_enter = function (self, entering_unit)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager:owner(entering_unit)
	local is_local_unit = not player or not player.remote
	local action_on_client = self._action_on_client
	local action_on_server = self._action_on_server

	if (action_on_server and not is_local_unit) or is_local_unit then
		self:local_on_unit_enter(entering_unit)
	end

	if action_on_client and not is_local_unit then
		local volume_unit = self._volume_unit
		local volume_unit_unit_id = Managers.state.unit_spawner:level_index(volume_unit)
		local entering_unit_id = Managers.state.unit_spawner:game_object_id(entering_unit)
		local component_guid = self._component_guid

		RPC.rpc_volume_trigger_unit_enter_on_client(player:channel_id(), volume_unit_unit_id, entering_unit_id, component_guid)
	end
end

TriggerActionBase.on_unit_exit = function (self, exiting_unit)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager:owner(exiting_unit)
	local is_local_unit = not player or not player.remote
	local action_on_client = self._action_on_client
	local action_on_server = self._action_on_server

	if (action_on_server and not is_local_unit) or is_local_unit then
		self:local_on_unit_exit(exiting_unit)
	end

	if action_on_client and not is_local_unit then
		local volume_unit = self._volume_unit
		local volume_unit_unit_id = Managers.state.unit_spawner:level_index(volume_unit)
		local exiting_unit_id = Managers.state.unit_spawner:game_object_id(exiting_unit)
		local component_guid = self._component_guid

		RPC.rpc_volume_trigger_unit_exit_on_client(player:channel_id(), volume_unit_unit_id, exiting_unit_id, component_guid)
	end
end

TriggerActionBase._activate_on_unit = function (self, unit)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager:owner(unit)
	local is_local_unit = not player or not player.remote
	local action_on_client = self._action_on_client
	local action_on_server = self._action_on_server

	if (action_on_server and not is_local_unit) or is_local_unit then
		self:local_on_activate(unit)
	end

	if action_on_client and not is_local_unit then
		local volume_unit = self._volume_unit
		local volume_unit_unit_id = Managers.state.unit_spawner:level_index(volume_unit)
		local unit_id = Managers.state.unit_spawner:game_object_id(unit)

		RPC.rpc_volume_trigger_activate_on_client(player:channel_id(), volume_unit_unit_id, unit_id, self._component_guid)
	end
end

TriggerActionBase._deactivate_on_unit = function (self, unit)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager:owner(unit)
	local is_local_unit = not player or not player.remote
	local action_on_client = self._action_on_client
	local action_on_server = self._action_on_server

	if (action_on_server and not is_local_unit) or is_local_unit then
		self:local_on_deactivate(unit)
	end

	if action_on_client and not is_local_unit then
		local volume_unit = self._volume_unit
		local volume_unit_unit_id = Managers.state.unit_spawner:level_index(volume_unit)
		local unit_id = Managers.state.unit_spawner:game_object_id(unit)

		RPC.rpc_volume_trigger_deactivate_on_client(player:channel_id(), volume_unit_unit_id, unit_id, self._component_guid)
	end
end

TriggerActionBase.local_on_activate = function (self, unit)
	return
end

TriggerActionBase.local_on_deactivate = function (self, unit)
	return
end

TriggerActionBase.local_on_unit_enter = function (self, entering_unit)
	local volume_unit = self._volume_unit

	Unit.set_flow_variable(volume_unit, "lua_component_guid", self._component_guid)
	Unit.set_flow_variable(volume_unit, "lua_entering_unit", entering_unit)
	Unit.flow_event(volume_unit, "lua_on_enter")
end

TriggerActionBase.local_on_unit_exit = function (self, exiting_unit)
	local volume_unit = self._volume_unit

	Unit.set_flow_variable(volume_unit, "lua_component_guid", self._component_guid)
	Unit.set_flow_variable(volume_unit, "lua_exiting_unit", exiting_unit)
	Unit.flow_event(volume_unit, "lua_on_exit")
end

TriggerActionBase.update = function (self, registered_units, dt, t)
	return
end

return TriggerActionBase
