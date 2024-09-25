﻿-- chunkname: @scripts/utilities/component.lua

local Component = {}
local component_interface = {
	"init",
	"enable",
	"disable",
	"destroy",
}

Component.event_lookup = {}
Component.lookup = {}
Component.default_rpc_name = "rpc_trigger_client_component_event"

Component.parse_components = function (components)
	local event_lookup = Component.event_lookup
	local event_index = 1
	local component_index = 1
	local component_names = table.keys(components)

	table.sort(component_names)

	for component_name_index = 1, #component_names do
		local name = component_names[component_name_index]
		local component = components[name]

		implements(component, component_interface)

		for _, function_name in ipairs(component_interface) do
			local editor_function_name = "editor_" .. function_name

			if not component[editor_function_name] then
				component[editor_function_name] = component[function_name]
			end
		end

		if not component.editor_update and component.update then
			component.editor_update = component.update
		end

		if not component.editor_changed and component.changed then
			component.editor_changed = component.changed
		end

		local events = component.events
		local event_names = table.keys(events)

		table.sort(event_names)

		for event_name_index = 1, #event_names do
			local event_name = event_names[event_name_index]

			if not event_lookup[event_name] then
				event_lookup[event_index] = event_name
				event_lookup[event_name] = event_index
				event_index = event_index + 1
			end
		end

		component_index = component_index + 1
	end
end

Component.has_component_by_name = function (unit, component_name)
	local component_system = Managers.state.extension:system("component_system")
	local components = component_system:get_components(unit, component_name)

	return #components > 0
end

Component.get_components_by_name = function (unit, component_name)
	local component_system = Managers.state.extension:system("component_system")
	local components = component_system:get_components(unit, component_name)

	return components
end

Component.event = function (unit, event, ...)
	return Managers.state.extension:system("component_system"):trigger_event(unit, event, ...)
end

Component.trigger_event_on_clients = function (component, event_name, rpc_name, ...)
	local unit = component.unit
	local is_level_index, id = Managers.state.unit_spawner:game_object_id_or_level_index(unit)
	local event_id = Component.event_lookup[event_name]
	local network_index = component.network_index

	Managers.state.game_session:send_rpc_clients(rpc_name or Component.default_rpc_name, is_level_index, id, network_index, event_id, ...)
end

Component.hot_join_sync_event_to_client = function (client, channel, component, event_name, rpc_name, ...)
	local rpc = RPC[rpc_name or Component.default_rpc_name]
	local unit = component.unit
	local is_level_index, id = Managers.state.unit_spawner:game_object_id_or_level_index(unit)
	local event_id = Component.event_lookup[event_name]
	local network_index = component.network_index

	rpc(channel, is_level_index, id, network_index, event_id, ...)
end

Component.receive_client_event = function (self, sender, is_level_index, id, network_index, event_id, ...)
	local unit = Managers.state.unit_spawner:unit(id, is_level_index)
	local component_ext = ScriptUnit.extension(unit, "component_system")
	local component = component_ext:component(network_index)
	local event_name = Component.event_lookup[event_id]

	component.events[event_name](component, ...)
end

return Component
