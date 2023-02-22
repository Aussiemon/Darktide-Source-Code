local Components = require("scripts/components/components")
local ComponentExtension = class("ComponentExtension")

ComponentExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._world = extension_init_context.world
	self._nav_world = extension_init_context.nav_world
	self._unit = unit
	self._unit_name = tostring(unit):gsub("%'", ""):sub(-30)
	self._is_server = extension_init_context.is_server
	self._components = {}
	self._component_list = {}
	self._update_list = {}
	self._num_updates = 0
	self._event_callbacks = {}
	self._extension_updates_enabled = true
	self._component_system = nil

	if Managers.state and Managers.state.extension then
		self._component_system = Managers.state.extension:system("component_system")
	end

	self:_parse_components(unit)
end

ComponentExtension.extensions_ready = function (self, world, unit)
	local list = self._component_list

	for i = 1, #list do
		local component = list[i]

		if component.extensions_ready then
			component:extensions_ready(world, unit)
		end
	end
end

ComponentExtension.hot_join_sync = function (self, unit, client, channel)
	local list = self._component_list

	for i = 1, #list do
		local component = list[i]

		if component.hot_join_sync then
			component:hot_join_sync(client, channel)
		end
	end
end

ComponentExtension.on_gameplay_post_init = function (self, unit, level)
	local list = self._component_list

	for i = 1, #list do
		local component = list[i]

		if component.on_gameplay_post_init then
			component:on_gameplay_post_init(unit, level)
		end
	end
end

ComponentExtension._enable_update = function (self, component)
	self._update_list[component] = component.update
	self._num_updates = self._num_updates + 1

	if self._num_updates > 0 and not self._extension_updates_enabled then
		self:_register_extension_update()
	end
end

ComponentExtension._disable_update = function (self, component)
	self._update_list[component] = nil
	self._num_updates = self._num_updates - 1

	if self._num_updates == 0 and self._extension_updates_enabled then
		self:_unregister_extension_update()
	end
end

ComponentExtension.on_register_update = function (self)
	if self._num_updates == 0 and self._extension_updates_enabled then
		self:_unregister_extension_update()
	end
end

ComponentExtension._register_extension_update = function (self)
	local unit = self._unit
	local component_system = self._component_system

	if component_system then
		component_system:enable_update_function("ComponentExtension", "update", unit, self)

		self._extension_updates_enabled = true
	end
end

ComponentExtension._unregister_extension_update = function (self)
	local unit = self._unit
	local component_system = self._component_system

	if component_system then
		component_system:disable_update_function("ComponentExtension", "update", unit)

		self._extension_updates_enabled = false
	end
end

ComponentExtension.enable_component = function (self, guid)
	local component = self._components[guid]

	if component.is_enabled then
		return self._num_updates
	end

	if component.update and component.run_update_on_enable then
		self:_enable_update(component)
	end

	component:enable(self._unit)

	component.is_enabled = true

	return self._num_updates
end

ComponentExtension.disable_component = function (self, guid)
	local component = self._components[guid]

	if not component.is_enabled then
		return self._num_updates
	end

	if self._update_list[component] then
		self:_disable_update(component)
	end

	component:disable(self._unit)

	component.is_enabled = false

	return self._num_updates
end

ComponentExtension.flow_call_component = function (self, guid, function_name, ...)
	local component = self._components[guid]

	if not component.is_enabled then
		return self._num_updates
	end

	local func = component[function_name]
	local run_update = func(component, ...)

	if component.update and not self._update_list[component] and run_update then
		self:_enable_update(component)
	end

	return self._num_updates
end

ComponentExtension._parse_components = function (self, unit)
	local cbs = self._event_callbacks
	local is_server = self._is_server
	local nav_world = self._nav_world
	local i = 1
	local component_guid = Unit.get_data(unit, "component_guids", 1)

	while component_guid do
		local component_name = Unit.get_data(unit, "components", component_guid, "name")
		local component_class = Components[component_name]
		local component, run_update = component_class:new(component_guid, i, unit, is_server, nav_world)
		local is_enabled = component:get_data(unit, "starts_enabled")
		component.is_enabled = is_enabled == nil and true or is_enabled or false

		if component.update and component.is_enabled and run_update then
			self:_enable_update(component)
		end

		self._component_list[i] = component
		self._components[component_guid] = component
		local registered_events = component_class.events

		for event_name, event_function in pairs(registered_events) do
			local cb_list = cbs[event_name]

			if not cb_list then
				cb_list = {}
				cbs[event_name] = cb_list
			end

			cb_list[#cb_list + 1] = component
		end

		i = i + 1
		component_guid = Unit.get_data(unit, "component_guids", i)
	end
end

ComponentExtension.add_component = function (self, component_name, unit, starts_enabled)
	local cbs = self._event_callbacks
	local is_server = self._is_server
	local nav_world = self._nav_world
	local component_guid = Application.guid()
	local i = 1
	local existing_component_guid = Unit.get_data(unit, "component_guids", 1)

	while existing_component_guid do
		i = i + 1
		existing_component_guid = Unit.get_data(unit, "component_guids", i)
	end

	Unit.set_data(unit, "component_guids", i, component_guid)
	Unit.set_data(unit, "components", component_guid, "name", component_name)

	local component_class = Components[component_name]
	local component, run_update = component_class:new(component_guid, i, unit, is_server, nav_world)
	component.name = component_name
	component.is_enabled = starts_enabled == nil and true or starts_enabled or false

	if component.update and component.is_enabled and run_update then
		self:_enable_update(component)
	end

	self._component_list[i] = component
	self._components[component_guid] = component
	local registered_events = component_class.events

	for event_name, event_function in pairs(registered_events) do
		local cb_list = cbs[event_name]

		if not cb_list then
			cb_list = {}
			cbs[event_name] = cb_list
		end

		cb_list[#cb_list + 1] = component
	end

	return component
end

ComponentExtension.component = function (self, index)
	return self._component_list[index]
end

ComponentExtension.components = function (self)
	return self._component_list
end

ComponentExtension.num_updates = function (self)
	return self._num_updates
end

ComponentExtension.update = function (self, unit, dt, t)
	for component, update_function in pairs(self._update_list) do
		local keep_update = update_function(component, unit, dt, t)

		if not keep_update then
			self:_disable_update(component)
		end
	end

	return self._num_updates
end

ComponentExtension.destroy = function (self, unit)
	local list = self._component_list

	for i = 1, #list do
		local component = list[i]

		component:delete(unit)
	end
end

ComponentExtension.trigger_event = function (self, event_name, ...)
	local cb_list = self._event_callbacks[event_name]

	if not cb_list then
		return self._num_updates
	end

	for i = 1, #cb_list do
		local component = cb_list[i]

		if component.is_enabled then
			local enable_update = component.events[event_name](component, ...)

			if component.update and enable_update and not self._update_list[component] then
				self:_enable_update(component)
			end
		end
	end

	return self._num_updates
end

return ComponentExtension
