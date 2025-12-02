-- chunkname: @scripts/extension_systems/component/component_system.lua

require("scripts/extension_systems/component/component_extension")

local Component = require("scripts/utilities/component")
local ComponentSystem = class("ComponentSystem", "ExtensionSystemBase")
local RPCS = {
	Component.default_rpc_name,
	"rpc_animation_play_client",
	"rpc_networked_unique_randomize_roll",
	"rpc_prop_on_hit_physics",
	"rpc_trigger_flow_on_unit",
}

ComponentSystem.init = function (self, context, system_init_data, ...)
	ComponentSystem.super.init(self, context, system_init_data, ...)

	self._component_name_to_units_map = {}
	self._level_seed = system_init_data.level_seed

	for _, rpc_name in pairs(RPCS) do
		self[rpc_name] = Component.receive_client_event
	end

	local network_event_delegate = self._network_event_delegate

	if not self._is_server and network_event_delegate then
		network_event_delegate:register_session_events(self, unpack(RPCS))
	end
end

ComponentSystem.destroy = function (self, ...)
	local network_event_delegate = self._network_event_delegate

	if not self._is_server and network_event_delegate then
		network_event_delegate:unregister_events(unpack(RPCS))
	end

	ComponentSystem.super.destroy(self, ...)
end

ComponentSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	local extension = ComponentSystem.super.on_add_extension(self, world, unit, extension_name, extension_init_data, ...)
	local component_name_to_units_map = self._component_name_to_units_map
	local components = extension:components()

	for i = 1, #components do
		local component_name = components[i]:name()

		component_name_to_units_map[component_name] = component_name_to_units_map[component_name] or {}

		local unit_list = component_name_to_units_map[component_name]

		unit_list[#unit_list + 1] = unit
	end

	return extension
end

ComponentSystem.on_remove_extension = function (self, unit, extension_name)
	local component_name_to_units_map = self._component_name_to_units_map

	for component_name, unit_list in pairs(component_name_to_units_map) do
		for index = #unit_list, 1, -1 do
			local registered_unit = unit_list[index]

			if registered_unit == unit then
				table.swap_delete(unit_list, index)
			end
		end
	end

	ComponentSystem.super.on_remove_extension(self, unit, extension_name)
end

ComponentSystem.register_extension_update = function (self, unit, extension_name, extension)
	ComponentSystem.super.register_extension_update(self, unit, extension_name, extension)
	extension:on_register_update()
end

ComponentSystem.on_gameplay_post_init = function (self, level)
	self:call_gameplay_post_init_on_extensions(level)
end

ComponentSystem.enable_component = function (self, unit, guid)
	local extension = self._unit_to_extension_map[unit]

	extension:enable_component(guid)
end

ComponentSystem.disable_component = function (self, unit, guid)
	local extension = self._unit_to_extension_map[unit]

	extension:disable_component(guid)
end

ComponentSystem.trigger_event = function (self, unit, event_name, ...)
	local extension = self._unit_to_extension_map[unit]

	if extension then
		extension:trigger_event(event_name, ...)

		return true
	else
		return false
	end
end

ComponentSystem.flow_call_component = function (self, unit, guid, function_name, ...)
	local extension = self._unit_to_extension_map[unit]

	if extension then
		extension:flow_call_component(guid, function_name, ...)
	else
		Log.warning("ComponentSystem", "[flow_call_component] call failed. unit: %s, guid: %s, function: %s", unit, guid, function_name)
	end
end

ComponentSystem.get_components = function (self, unit, component_name)
	local result = {}
	local extension = self._unit_to_extension_map[unit]

	if extension then
		local components = extension:components()

		for i = 1, #components do
			if components[i]:name() == component_name then
				result[#result + 1] = components[i]
			end
		end
	end

	return result
end

ComponentSystem.get_all_components = function (self, unit)
	local result = {}
	local extension = self._unit_to_extension_map[unit]

	if extension then
		local components = extension:components()

		for i = 1, #components do
			result[#result + 1] = components[i]
		end
	end

	return result
end

local EMPTY_TABLE = {}

ComponentSystem.get_units_from_component_name = function (self, component_name)
	return self._component_name_to_units_map[component_name] or EMPTY_TABLE
end

ComponentSystem.get_level_seed = function (self)
	return self._level_seed
end

return ComponentSystem
