-- chunkname: @scripts/extension_systems/payload/payload_system.lua

require("scripts/extension_systems/payload/payload_extension")

local PayloadSystem = class("PayloadSystem", "ExtensionSystemBase")
local RPCS = {
	"rpc_payload_add_target",
	"rpc_payload_clear_targets_before",
	"rpc_payload_clear_targets",
	"rpc_payload_update",
	"rpc_payload_set_bezier_turning",
	"rpc_payload_add_proximity_history",
	"rpc_payload_add_main_path_history",
	"rpc_payload_set_aim_constraint_target_override",
	"rpc_payload_clear_aim_constraint_target_override",
}

PayloadSystem.init = function (self, context, ...)
	PayloadSystem.super.init(self, context, ...)

	if not self._is_server then
		self._network_event_delegate:register_session_events(self, unpack(RPCS))
	end
end

PayloadSystem.on_gameplay_post_init = function (self, level)
	self:call_gameplay_post_init_on_extensions(level)
end

PayloadSystem.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(RPCS))
	end

	PayloadSystem.super.destroy(self)
end

PayloadSystem.rpc_payload_add_target = function (self, channel_id, level_unit_id, target_location, normal, has_node, node_unit_id)
	local unit = Managers.state.unit_spawner:unit(level_unit_id, true)
	local extension = self._unit_to_extension_map[unit]
	local node_extension

	if has_node then
		local node_unit = Managers.state.unit_spawner:unit(node_unit_id, true)

		node_extension = ScriptUnit.extension(node_unit, "payload_path_system")
	end

	extension:add_target(target_location, normal, node_extension)
end

PayloadSystem.rpc_payload_clear_targets_before = function (self, channel_id, level_unit_id, index)
	local unit = Managers.state.unit_spawner:unit(level_unit_id, true)
	local extension = self._unit_to_extension_map[unit]

	extension:clear_targets_before(index)
end

PayloadSystem.rpc_payload_clear_targets = function (self, channel_id, level_unit_id)
	local unit = Managers.state.unit_spawner:unit(level_unit_id, true)
	local extension = self._unit_to_extension_map[unit]

	extension:clear_targets()
end

PayloadSystem.rpc_payload_update = function (self, channel_id, level_unit_id, ...)
	local unit = Managers.state.unit_spawner:unit(level_unit_id, true)
	local extension = self._unit_to_extension_map[unit]

	extension:rpc_payload_update(...)
end

PayloadSystem.rpc_payload_set_bezier_turning = function (self, channel_id, level_unit_id, ...)
	local unit = Managers.state.unit_spawner:unit(level_unit_id, true)
	local extension = self._unit_to_extension_map[unit]

	extension:rpc_payload_set_bezier_turning(...)
end

PayloadSystem.rpc_payload_add_proximity_history = function (self, channel_id, level_unit_id, ...)
	local unit = Managers.state.unit_spawner:unit(level_unit_id, true)
	local extension = self._unit_to_extension_map[unit]

	extension:add_proximity_history(...)
end

PayloadSystem.rpc_payload_add_main_path_history = function (self, channel_id, level_unit_id, ...)
	local unit = Managers.state.unit_spawner:unit(level_unit_id, true)
	local extension = self._unit_to_extension_map[unit]

	extension:add_main_path_history(...)
end

PayloadSystem.rpc_payload_set_aim_constraint_target_override = function (self, channel_id, level_unit_id, ...)
	local unit = Managers.state.unit_spawner:unit(level_unit_id, true)
	local extension = self._unit_to_extension_map[unit]

	extension:rpc_payload_set_aim_constraint_target_override(...)
end

PayloadSystem.rpc_payload_clear_aim_constraint_target_override = function (self, channel_id, level_unit_id, ...)
	local unit = Managers.state.unit_spawner:unit(level_unit_id, true)
	local extension = self._unit_to_extension_map[unit]

	extension:rpc_payload_clear_aim_constraint_target_override(...)
end

return PayloadSystem
