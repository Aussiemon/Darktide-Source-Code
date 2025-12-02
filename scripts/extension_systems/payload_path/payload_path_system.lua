-- chunkname: @scripts/extension_systems/payload_path/payload_path_system.lua

require("scripts/extension_systems/payload_path/payload_path_node_extension")

local PayloadPathSystem = class("PayloadPathSystem", "ExtensionSystemBase")
local CLIENT_RPCS = {
	"rpc_payload_path_node_allow_payload_to_pass",
}

PayloadPathSystem.init = function (self, context, system_init_data, ...)
	PayloadPathSystem.super.init(self, context, system_init_data, ...)

	self._is_server = context.is_server
	self._paths = {}

	if not self._is_server then
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

PayloadPathSystem.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	PayloadPathSystem.super.destroy(self)
end

local function _nodes_id_ascending(a, b)
	return a:node_id() < b:node_id()
end

PayloadPathSystem.on_gameplay_post_init = function (self, level)
	local paths = self._paths
	local unit_to_extension_map = self._unit_to_extension_map

	for node_unit, node_extension in pairs(unit_to_extension_map) do
		local path_name = node_extension:path_name()
		local path = paths[path_name]

		if not path then
			path = {}
			paths[path_name] = path
		end

		path[#path + 1] = node_extension
	end

	for path_name, path in pairs(paths) do
		table.sort(path, _nodes_id_ascending)
	end
end

PayloadPathSystem.get_nodes_for_path = function (self, path_name)
	return self._paths[path_name]
end

PayloadPathSystem.get_node_for_path_and_id = function (self, path_name, node_id)
	local path_nodes = self._paths[path_name]

	for i = 1, #path_nodes do
		local node_extension = path_nodes[i]

		if node_extension:node_id() == node_id then
			return node_extension
		end
	end

	return nil
end

PayloadPathSystem.rpc_payload_path_node_allow_payload_to_pass = function (self, channel_id, level_unit_id, ...)
	local unit = Managers.state.unit_spawner:unit(level_unit_id, true)
	local extension = self._unit_to_extension_map[unit]

	extension:rpc_payload_path_node_allow_payload_to_pass(...)
end

return PayloadPathSystem
