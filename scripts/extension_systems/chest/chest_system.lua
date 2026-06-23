-- chunkname: @scripts/extension_systems/chest/chest_system.lua

local NetworkLookup = require("scripts/network_lookup/network_lookup")

require("scripts/extension_systems/chest/chest_extension")

local ChestSystem = class("ChestSystem", "ExtensionSystemBase")
local CLIENT_RPCS = {
	"rpc_chest_set_state",
	"rpc_chest_hot_join",
	"rpc_chest_despawn",
}

ChestSystem.init = function (self, context, ...)
	ChestSystem.super.init(self, context, ...)

	if not self._is_server then
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

ChestSystem.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	ChestSystem.super.destroy(self)
end

ChestSystem.on_gameplay_post_init = function (self, level)
	self:call_gameplay_post_init_on_extensions(level)
end

ChestSystem.on_location_setup = function (self)
	self:call_gameplay_post_init_on_extensions()
end

ChestSystem.rpc_chest_set_state = function (self, channel_id, level_unit_id, state_id)
	local unit = Managers.state.unit_spawner:unit(level_unit_id, true)
	local extension = self._unit_to_extension_map[unit]
	local state = NetworkLookup.chest_states[state_id]

	extension:set_current_state(state)
end

ChestSystem.rpc_chest_hot_join = function (self, channel_id, level_unit_id, state_id)
	local unit = Managers.state.unit_spawner:unit(level_unit_id, true)
	local extension = self._unit_to_extension_map[unit]
	local state = NetworkLookup.chest_states[state_id]

	extension:rpc_set_chest_state(state)
end

ChestSystem.rpc_chest_despawn = function (self, channel_id, level_unit_id)
	local unit_spawner = Managers.state.unit_spawner
	local unit = unit_spawner:unit(level_unit_id, true)

	if not unit or not Unit.alive(unit) then
		return
	end

	if unit_spawner:is_marked_for_deletion(unit) then
		return
	end

	unit_spawner:mark_for_deletion(unit)
end

return ChestSystem
