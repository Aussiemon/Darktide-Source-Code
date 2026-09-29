-- chunkname: @scripts/ui/constant_elements/constant_element_base.lua

local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIScenegraph = require("scripts/managers/ui/ui_scenegraph")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UISequenceAnimator = require("scripts/managers/ui/ui_sequence_animator")
local ConstantElementBase = class("ConstantElementBase")

ConstantElementBase.init = function (self, parent, draw_layer, start_scale, definitions)
	self._definitions = definitions
	self._draw_layer = draw_layer
	self._parent = parent
	self._is_visible = true
	self._event_list = {}
	self._elements = {}
	self._elements_array = {}
	self._element_to_pivot = {}
	self._ui_scenegraph = self:_create_scenegraph(definitions, start_scale)
	self._widgets, self._widgets_by_name = {}, {}

	self:_create_widgets(definitions, self._widgets, self._widgets_by_name)

	self._ui_sequence_animator = self:_create_sequence_animator(definitions)
end

ConstantElementBase._create_scenegraph = function (self, definitions, start_scale)
	local scenegraph_definition = definitions.scenegraph_definition
	local scenegraph = UIScenegraph.init_scenegraph(scenegraph_definition, start_scale)

	return scenegraph
end

ConstantElementBase._create_widgets = function (self, definitions, widgets, widgets_by_name)
	local widget_definitions = definitions.widget_definitions

	widgets = widgets or {}
	widgets_by_name = widgets_by_name or {}

	for name, definition in pairs(widget_definitions) do
		local widget = self:_create_widget(name, definition)

		widgets[#widgets + 1] = widget
	end

	return widgets, widgets_by_name
end

ConstantElementBase._create_widget = function (self, name, definition)
	local widgets_by_name = self._widgets_by_name
	local widget = UIWidget.init(name, definition)

	widgets_by_name[name] = widget

	return widget
end

ConstantElementBase._unregister_widget_name = function (self, name)
	local widgets_by_name = self._widgets_by_name

	widgets_by_name[name] = nil
end

ConstantElementBase.has_widget = function (self, name)
	return self._widgets_by_name[name] ~= nil
end

ConstantElementBase._register_event = function (self, event_name, function_name)
	function_name = function_name or event_name

	Managers.event:register(self, event_name, function_name)

	self._event_list[event_name] = function_name
end

ConstantElementBase._unregister_event = function (self, event_name)
	Managers.event:unregister(self, event_name)

	self._event_list[event_name] = nil
end

ConstantElementBase._unregister_events = function (self)
	if self._event_list then
		for event_name, _ in pairs(self._event_list) do
			self:_unregister_event(event_name)
		end

		self._event_list = {}
	end
end

ConstantElementBase._create_sequence_animator = function (self, definitions)
	local animations = definitions.animations

	if animations then
		local scenegraph_definition = definitions.scenegraph_definition

		return UISequenceAnimator:new(self._ui_scenegraph, scenegraph_definition, animations)
	end
end

ConstantElementBase._start_animation = function (self, animation_sequence_name, widgets, params, callback, speed)
	speed = speed or 1
	widgets = widgets or self._widgets_by_name

	local scenegraph_definition = self._definitions.scenegraph_definition
	local ui_sequence_animator = self._ui_sequence_animator
	local animation_id = ui_sequence_animator:start_animation(self, animation_sequence_name, widgets, params, speed, callback)

	return animation_id
end

ConstantElementBase._stop_animation = function (self, animation_id)
	return self._ui_sequence_animator:stop_animation(animation_id)
end

ConstantElementBase._is_animation_active = function (self, animation_id)
	return self._ui_sequence_animator:is_animation_active(animation_id)
end

ConstantElementBase._is_animation_completed = function (self, animation_id)
	return self._ui_sequence_animator:is_animation_completed(animation_id)
end

ConstantElementBase._complete_animation = function (self, animation_id)
	self._ui_sequence_animator:complete_animation(animation_id)
end

ConstantElementBase.set_visible = function (self, visible, optional_visibility_parameters)
	self._is_visible = visible
end

ConstantElementBase.should_update = function (self)
	return self._is_visible
end

ConstantElementBase.should_draw = function (self)
	return self._is_visible
end

ConstantElementBase.set_render_scale = function (self, render_scale)
	self._render_scale = render_scale
end

ConstantElementBase.on_resolution_modified = function (self)
	self._update_scenegraph = true
end

ConstantElementBase.scenegraph_size = function (self, id, scale)
	local ui_scenegraph = self._ui_scenegraph

	return UIScenegraph.size_scaled(ui_scenegraph, id, scale)
end

ConstantElementBase.scenegraph_position = function (self, id)
	local ui_scenegraph = self._ui_scenegraph
	local scenegraph = ui_scenegraph[id]

	return scenegraph.position
end

ConstantElementBase.scenegraph_world_position = function (self, id, scale)
	local ui_scenegraph = self._ui_scenegraph

	return UIScenegraph.world_position(ui_scenegraph, id, scale)
end

ConstantElementBase._force_update_scenegraph = function (self)
	UIScenegraph.update_scenegraph(self._ui_scenegraph, self._render_scale)
end

ConstantElementBase.set_scenegraph_position = function (self, id, x, y, z, horizontal_alignment, vertical_alignment)
	local ui_scenegraph = self._ui_scenegraph
	local scenegraph = ui_scenegraph[id]

	scenegraph.horizontal_alignment = horizontal_alignment or scenegraph.horizontal_alignment
	scenegraph.vertical_alignment = vertical_alignment or scenegraph.vertical_alignment

	local position = scenegraph.position

	if x then
		position[1] = x
	end

	if y then
		position[2] = y
	end

	if z then
		position[3] = z
	end

	self._update_scenegraph = true
end

ConstantElementBase._set_scenegraph_size = function (self, id, width, height)
	local ui_scenegraph = self._ui_scenegraph
	local scenegraph = ui_scenegraph[id]
	local size = scenegraph.size

	if width then
		size[1] = width
	end

	if height then
		size[2] = height
	end

	self._update_scenegraph = true
end

ConstantElementBase._update_animations = function (self, dt, t)
	local ui_sequence_animator = self._ui_sequence_animator

	if ui_sequence_animator and ui_sequence_animator:update(dt, t) then
		self._update_scenegraph = true
	end
end

ConstantElementBase.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	self:_update_animations(dt, t)

	if self._update_scenegraph then
		local ui_scenegraph = self._ui_scenegraph

		UIScenegraph.update_scenegraph(ui_scenegraph, render_settings.scale)

		self._update_scenegraph = nil
	end

	self:_update_elements(dt, t, input_service)
end

ConstantElementBase.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	render_settings.start_layer = self._draw_layer

	local ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)
	self:_draw_widgets(dt, t, input_service, ui_renderer, render_settings)
	UIRenderer.end_pass(ui_renderer)
	self:_draw_elements(dt, t, ui_renderer, render_settings, input_service)
end

ConstantElementBase._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	local widgets = self._widgets
	local num_widgets = #widgets

	for i = 1, num_widgets do
		local widget = widgets[i]

		UIWidget.draw(widget, ui_renderer)
	end
end

ConstantElementBase._play_sound = function (self, event_name)
	local ui_manager = Managers.ui

	ui_manager:play_2d_sound(event_name)
end

ConstantElementBase._localize = function (self, text, no_cache, context)
	return Managers.localization:localize(text, no_cache, context)
end

ConstantElementBase.destroy = function (self, ui_renderer)
	self:_unregister_events()

	local elements_array = self._elements_array

	if elements_array then
		for _, element in ipairs(elements_array) do
			element:destroy(ui_renderer)
		end
	end

	self._elements = nil
	self._elements_array = nil
end

ConstantElementBase._add_element = function (self, class, reference_name, layer, context, pivot, ui_renderer)
	local elements = self._elements
	local elements_array = self._elements_array

	if not self._elements or not self._elements_array then
		return
	end

	context = context or {}

	if not context.reference_name then
		context.reference_name = reference_name
	end

	local draw_layer = layer or 0
	local scale = ui_renderer.scale or RESOLUTION_LOOKUP.scale
	local element = class:new(self, draw_layer, scale, context)

	element:set_render_scale(self._render_scale)

	elements[reference_name] = element

	local id = #elements_array + 1

	elements_array[id] = element

	if pivot then
		self._element_to_pivot[element] = pivot
	end

	return element
end

ConstantElementBase._remove_element = function (self, reference_name, ui_renderer)
	local elements = self._elements or {}
	local element = elements[reference_name]
	local elements_array = self._elements_array

	if elements_array and element then
		for i = 1, #elements_array do
			if elements_array[i] == element then
				table.remove(elements_array, i)

				break
			end
		end

		element:destroy(ui_renderer)

		elements[reference_name] = nil
	end
end

ConstantElementBase._element_reference_name = function (self, element)
	local elements = self._elements or {}
	local reference_name = table.find(elements, element)

	return reference_name
end

ConstantElementBase._element = function (self, reference_name)
	local elements = self._elements or {}
	local element = elements[reference_name]

	return element
end

ConstantElementBase._on_resolution_modified_elements = function (self, scale)
	local elements_array = self._elements_array

	if elements_array then
		for i = 1, #elements_array do
			local element = elements_array[i]
			local element_name = element.__class_name

			if element.on_resolution_modified then
				element:set_render_scale(scale)
				element:on_resolution_modified(scale)
			end
		end
	end

	for element, scenegraph_id in pairs(self._element_to_pivot) do
		self:_update_element_position(scenegraph_id, element)
	end
end

ConstantElementBase._draw_elements = function (self, dt, t, ui_renderer, render_settings, input_service)
	local elements_array = self._elements_array

	if elements_array then
		for i = 1, #elements_array do
			local element = elements_array[i]

			if element then
				local element_name = element.__class_name

				element:draw(dt, t, ui_renderer, render_settings, input_service)
			end
		end
	end
end

ConstantElementBase._update_elements = function (self, dt, t, input_service)
	local elements_array = self._elements_array

	if elements_array then
		for i = 1, #elements_array do
			local element = elements_array[i]

			if element then
				local element_name = element.__class_name

				element:update(dt, t, input_service)
			end
		end
	end
end

return ConstantElementBase
