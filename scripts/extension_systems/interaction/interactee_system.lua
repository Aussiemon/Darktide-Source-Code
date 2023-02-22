require("scripts/extension_systems/interaction/interactee_extension")
require("scripts/extension_systems/interaction/player_interactee_extension")

local InteracteeSystem = class("InteracteeSystem", "ExtensionSystemBase")
local RPCS = {
	"rpc_interaction_started",
	"rpc_interaction_stopped",
	"rpc_interaction_set_active",
	"rpc_interaction_hot_join"
}

InteracteeSystem.init = function (self, ...)
	InteracteeSystem.super.init(self, ...)
	self._network_event_delegate:register_session_events(self, unpack(RPCS))
end

InteracteeSystem.destroy = function (self, ...)
	self._network_event_delegate:unregister_events(unpack(RPCS))
	InteracteeSystem.super.destroy(self, ...)
end

InteracteeSystem.rpc_interaction_started = function (self, channel_id, unit_id, is_level_unit, game_object_id)
	local interactor_unit = Managers.state.unit_spawner:unit(game_object_id)
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]

	extension:started(interactor_unit)
end

InteracteeSystem.rpc_interaction_stopped = function (self, channel_id, unit_id, is_level_unit, result)
	local result_name = NetworkLookup.interaction_result[result]
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]

	extension:stopped(result_name)
end

InteracteeSystem.rpc_interaction_set_active = function (self, channel_id, unit_id, is_level_unit, state)
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]

	extension:set_active(state)
end

InteracteeSystem.rpc_interaction_hot_join = function (self, channel_id, unit_id, is_level_unit, state, is_used, active_type_id)
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)
	local extension = self._unit_to_extension_map[unit]
	local active_type = active_type_id ~= 0 and NetworkLookup.interaction_type_strings[active_type_id] or nil

	extension:hot_join_setup(state, is_used, active_type)
end

return InteracteeSystem
