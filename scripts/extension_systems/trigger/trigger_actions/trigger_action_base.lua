local TriggerSettings = require("scripts/extension_systems/trigger/trigger_settings")
local ACTION_TARGETS = TriggerSettings.action_targets
local MACHINE_TARGETS = TriggerSettings.machine_targets
local TriggerActionBase = class("TriggerActionBase")

TriggerActionBase.init = function (self, is_server, volume_unit, parameters, trigger_action_name)
	self._is_server = is_server
	self._volume_unit = volume_unit
	self._side_system = Managers.state.extension:system("side_system")
	self._target = parameters.action_target
	self._player_side = parameters.action_player_side
	self._trigger_action_name = trigger_action_name
	local action_machine_target = parameters.action_machine_target
	local trigger_on_client = action_machine_target == MACHINE_TARGETS.client
	local trigger_on_server = action_machine_target == MACHINE_TARGETS.server
	local trigger_on_server_and_client = action_machine_target == MACHINE_TARGETS.server_and_client
	self._triggers_on_client = trigger_on_client or trigger_on_server_and_client
	self._triggers_on_server = trigger_on_server or trigger_on_server_and_client
end

TriggerActionBase.destroy = function (self)
	return
end

TriggerActionBase.on_activate = function (self, entering_unit, registered_units, dt, t)
	if not self._is_server then
		return
	end

	if self._target == ACTION_TARGETS.none then
		self:local_on_activate(entering_unit)
	elseif self._target == ACTION_TARGETS.player_side then
		local side_system = self._side_system
		local side = side_system:get_side_from_name(self._player_side)
		local player_units = side.player_units

		for ii = 1, #player_units do
			self:_activate_on_unit(player_units[ii])
		end
	elseif self._target == ACTION_TARGETS.entering_unit or self._target == ACTION_TARGETS.entering_and_exiting_unit then
		self:_activate_on_unit(entering_unit)
	elseif self._target == ACTION_TARGETS.units_in_volume then
		for unit, _ in pairs(registered_units) do
			self:_activate_on_unit(unit)
		end
	end
end

TriggerActionBase.on_deactivate = function (self, exiting_unit, registered_units)
	if not self._is_server then
		return
	end

	if self._target == ACTION_TARGETS.none then
		self:local_on_deactivate(exiting_unit)
	elseif self._target == ACTION_TARGETS.player_side then
		local side_system = self._side_system
		local side = side_system:get_side_from_name(self._player_side)
		local player_units = side.player_units

		for ii = 1, #player_units do
			self:_deactivate_on_unit(player_units[ii])
		end
	elseif self._target == ACTION_TARGETS.exiting_unit or self._target == ACTION_TARGETS.entering_and_exiting_unit then
		self:_deactivate_on_unit(exiting_unit)
	elseif self._target == ACTION_TARGETS.units_in_volume then
		for unit, _ in pairs(registered_units) do
			self:_deactivate_on_unit(unit)
		end
	end
end

TriggerActionBase.on_unit_enter = function (self, entering_unit)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager:owner(entering_unit)
	local is_local_unit = not player or not player.remote
	local triggers_on_client = self._triggers_on_client
	local triggers_on_server = self._triggers_on_server

	if triggers_on_server and not is_local_unit or is_local_unit then
		self:local_on_unit_enter(entering_unit)
	end

	if triggers_on_client and not is_local_unit then
		local volume_unit = self._volume_unit
		local volume_unit_unit_id = Managers.state.unit_spawner:level_index(volume_unit)
		local entering_unit_id = Managers.state.unit_spawner:game_object_id(entering_unit)

		RPC.rpc_volume_trigger_unit_enter_on_client(player:channel_id(), volume_unit_unit_id, entering_unit_id)
	end
end

TriggerActionBase.on_unit_exit = function (self, exiting_unit)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager:owner(exiting_unit)
	local is_local_unit = not player or not player.remote
	local triggers_on_client = self._triggers_on_client
	local triggers_on_server = self._triggers_on_server

	if triggers_on_server and not is_local_unit or is_local_unit then
		self:local_on_unit_exit(exiting_unit)
	end

	if triggers_on_client and not is_local_unit then
		local volume_unit = self._volume_unit
		local volume_unit_unit_id = Managers.state.unit_spawner:level_index(volume_unit)
		local exiting_unit_id = Managers.state.unit_spawner:game_object_id(exiting_unit)

		RPC.rpc_volume_trigger_unit_exit_on_client(player:channel_id(), volume_unit_unit_id, exiting_unit_id)
	end
end

TriggerActionBase._activate_on_unit = function (self, unit)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager:owner(unit)
	local is_local_unit = not player or not player.remote
	local triggers_on_client = self._triggers_on_client
	local triggers_on_server = self._triggers_on_server

	if triggers_on_server and not is_local_unit or is_local_unit then
		self:local_on_activate(unit)
	end

	if triggers_on_client and not is_local_unit then
		local volume_unit = self._volume_unit
		local volume_unit_unit_id = Managers.state.unit_spawner:level_index(volume_unit)
		local unit_id = Managers.state.unit_spawner:game_object_id(unit)

		RPC.rpc_volume_trigger_activate_on_client(player:channel_id(), volume_unit_unit_id, unit_id)
	end
end

TriggerActionBase._deactivate_on_unit = function (self, unit)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager:owner(unit)
	local is_local_unit = not player or not player.remote
	local triggers_on_client = self._triggers_on_client
	local triggers_on_server = self._triggers_on_server

	if triggers_on_server and not is_local_unit or is_local_unit then
		self:local_on_deactivate(unit)
	end

	if triggers_on_client and not is_local_unit then
		local volume_unit = self._volume_unit
		local volume_unit_unit_id = Managers.state.unit_spawner:level_index(volume_unit)
		local unit_id = Managers.state.unit_spawner:game_object_id(unit)

		RPC.rpc_volume_trigger_deactivate_on_client(player:channel_id(), volume_unit_unit_id, unit_id)
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

	Unit.set_flow_variable(volume_unit, "lua_entering_unit", entering_unit)
	Unit.flow_event(volume_unit, "lua_on_enter")
end

TriggerActionBase.local_on_unit_exit = function (self, exiting_unit)
	local volume_unit = self._volume_unit

	Unit.set_flow_variable(volume_unit, "lua_exiting_unit", exiting_unit)
	Unit.flow_event(volume_unit, "lua_on_exit")
end

return TriggerActionBase
