-- chunkname: @scripts/extension_systems/door/door_system.lua

require("scripts/extension_systems/door/door_extension")

local NetworkLookup = require("scripts/network_lookup/network_lookup")
local DoorSystem = class("DoorSystem", "ExtensionSystemBase")
local CLIENT_RPCS = {
	"rpc_sync_door_state",
}

DoorSystem.init = function (self, extension_system_creation_context, ...)
	DoorSystem.super.init(self, extension_system_creation_context, ...)

	if self._is_server then
		self:_create_staggered_iterator("close_door_iterator", function (extension, cumulative_dt)
			return extension:staggered_update_closing(cumulative_dt)
		end)
	else
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end

	self:_create_staggered_iterator("update_nav_block_iterator", function (extension, cumulative_dt)
		return extension:staggered_update_nav_block(cumulative_dt)
	end)
end

local CLOSE_CHECK_ITERATION_TIME = 5
local NAV_BLOCK_ITERATION_TIME = 1

DoorSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	local extension = DoorSystem.super.on_add_extension(self, world, unit, extension_name, extension_init_data, ...)

	if self._is_server then
		self:_register_staggered_item_update("close_door_iterator", extension, CLOSE_CHECK_ITERATION_TIME)
	end

	self:_register_staggered_item_update("update_nav_block_iterator", extension, NAV_BLOCK_ITERATION_TIME)

	return extension
end

DoorSystem.on_remove_extension = function (self, unit, extension_name)
	if self._is_server then
		self:_unregister_staggered_item_update("close_door_iterator", self._unit_to_extension_map[unit])
	end

	self:_unregister_staggered_item_update("update_nav_block_iterator", self._unit_to_extension_map[unit])

	return DoorSystem.super.on_remove_extension(self, unit, extension_name)
end

DoorSystem.rpc_sync_door_state = function (self, channel_id, unit_level_index, state_lookup_id, animate)
	local unit = Managers.state.unit_spawner:unit(unit_level_index, true)
	local state = NetworkLookup.door_states[state_lookup_id]
	local extension = self._unit_to_extension_map[unit]

	extension:rpc_sync_door_state(state, animate)
end

DoorSystem.destroy = function (self, ...)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	DoorSystem.super.destroy(self, ...)
end

return DoorSystem
