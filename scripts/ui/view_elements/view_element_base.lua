local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIScenegraph = require("scripts/managers/ui/ui_scenegraph")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UISequenceAnimator = require("scripts/managers/ui/ui_sequence_animator")
local ViewElementBase = class("ViewElementBase")

ViewElementBase.init = function (self, parent, draw_layer, start_scale, definitions)
	self._definitions = definitions
	self._draw_layer = draw_layer or 0
	self._parent = parent
	self._render_settings = {}
	self._event_list = {}
	self._ui_scenegraph = self:_create_scenegraph(definitions, start_scale)
	self._widgets_by_name = {}
	self._widgets = {}

	self:_create_widgets(definitions, self._widgets, self._widgets_by_name)

	self._ui_sequence_animator = self:_create_sequence_animator(definitions)
	self._visible = true
end

ViewElementBase._create_scenegraph = function (self, definitions, start_scale)
	local scenegraph_definition = definitions.scenegraph_definition
	local scenegraph = UIScenegraph.init_scenegraph(scenegraph_definition, start_scale)

	return scenegraph
end

ViewElementBase._create_widgets = function (self, definitions, widgets, widgets_by_name)
	local widget_definitions = definitions.widget_definitions
	widgets = widgets or {}
	widgets_by_name = widgets_by_name or {}

	for name, definition in pairs(widget_definitions) do
		local widget = self:_create_widget(name, definition)
		widgets[#widgets + 1] = widget
	end

	return widgets, widgets_by_name
end

ViewElementBase._create_widget = function (self, name, definition)
	local widgets_by_name = self._widgets_by_name
	local widget = UIWidget.init(name, definition)
	widgets_by_name[name] = widget

	return widget
end

ViewElementBase._unregister_widget_name = function (self, name)
	local widgets_by_name = self._widgets_by_name
	widgets_by_name[name] = nil
end

ViewElementBase.has_widget = function (self, name)
	return self._widgets_by_name[name] ~= nil
end

ViewElementBase._create_sequence_animator = function (self, definitions)
	local animations = definitions.animations

	if animations then
		local scenegraph_definition = definitions.scenegraph_definition

		return UISequenceAnimator:new(self._ui_scenegraph, scenegraph_definition, animations)
	end
end

ViewElementBase._complete_animation = function (self, animation_id)
	self._ui_sequence_animator:complete_animation(animation_id)
end

ViewElementBase._is_animation_active = function (self, animation_id)
	return self._ui_sequence_animator:is_animation_active(animation_id)
end

ViewElementBase._start_animation = function (self, animation_sequence_name, widgets, params, callback, speed)
	speed = speed or 1
	widgets = widgets or self._widgets_by_name
	local scenegraph_definition = self._definitions.scenegraph_definition
	local ui_sequence_animator = self._ui_sequence_animator
	local animation_id = ui_sequence_animator:start_animation(self, animation_sequence_name, widgets, params, speed, callback)

	return animation_id
end

ViewElementBase._stop_animation = function (self, animation_id)
	self._ui_sequence_animator:stop_animation(animation_id)
end

ViewElementBase.render_scale = function (self)
	return self._render_scale
end

ViewElementBase.set_render_scale = function (self, scale)
	self._render_scale = scale
end

ViewElementBase.on_resolution_modified = function (self, scale)
	self._update_scenegraph = true
	self._render_scale = scale
end

ViewElementBase._scenegraph_size = function (self, id, scale)
	if scale then
		local ui_scenegraph = self._ui_scenegraph

		return UIScenegraph.get_size(ui_scenegraph, id, scale)
	else
		local ui_scenegraph = self._ui_scenegraph
		local scenegraph = ui_scenegraph[id]
		local size = scenegraph.size

		return size[1], size[2]
	end
end

ViewElementBase.scenegraph_position = function (self, id)
	local ui_scenegraph = self._ui_scenegraph
	local scenegraph = ui_scenegraph[id]

	return scenegraph.position
end

ViewElementBase.scenegraph_world_position = function (self, id, scale)
	local ui_scenegraph = self._ui_scenegraph

	return UIScenegraph.world_position(ui_scenegraph, id, scale)
end

ViewElementBase._set_scenegraph_position = function (self, id, x, y, z)
	local ui_scenegraph = self._ui_scenegraph
	local scenegraph = ui_scenegraph[id]
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

ViewElementBase._set_scenegraph_size = function (self, id, width, height)
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

ViewElementBase._update_animations = function (self, dt, t)
	local ui_sequence_animator = self._ui_sequence_animator

	if ui_sequence_animator and ui_sequence_animator:update(dt, t) then
		self._update_scenegraph = true
	end
end

ViewElementBase.update = function (self, dt, t, input_service)
	self:_update_animations(dt, t)

	if self._update_scenegraph then
		local ui_scenegraph = self._ui_scenegraph

		UIScenegraph.update_scenegraph(ui_scenegraph, self._render_scale)

		self._update_scenegraph = nil
	end

	if input_service and not input_service:is_null_service() then
		local using_cursor_navigation = Managers.ui:using_cursor_navigation()

		if self._using_cursor_navigation ~= using_cursor_navigation or self._using_cursor_navigation == nil then
			self._using_cursor_navigation = using_cursor_navigation

			self:_on_navigation_input_changed()
		end
	end
end

ViewElementBase._on_navigation_input_changed = function (self)
	return
end

ViewElementBase._force_update_scenegraph = function (self)
	UIScenegraph.update_scenegraph(self._ui_scenegraph, self._render_scale)
end

ViewElementBase.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	if not self._visible then
		return
	end

	local previous_layer = render_settings.start_layer
	render_settings.start_layer = (previous_layer or 0) + self._draw_layer
	local ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)
	self:_draw_widgets(dt, t, input_service, ui_renderer, render_settings)
	UIRenderer.end_pass(ui_renderer)

	render_settings.start_layer = previous_layer
end

ViewElementBase._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	local widgets = self._widgets
	local num_widgets = #widgets

	for i = 1, num_widgets do
		local widget = widgets[i]

		UIWidget.draw(widget, ui_renderer)
	end
end

ViewElementBase.set_visibility = function (self, visible)
	self._visible = visible
end

ViewElementBase._play_sound = function (self, event_name)
	local ui_manager = Managers.ui

	ui_manager:play_2d_sound(event_name)
end

ViewElementBase._set_sound_parameter = function (self, parameter_id, value)
	local ui_manager = Managers.ui

	ui_manager:set_2d_sound_parameter(parameter_id, value)
end

ViewElementBase._localize = function (self, text, no_cache, context)
	return Managers.localization:localize(text, no_cache, context)
end

ViewElementBase._register_event = function (self, event_name, function_name)
	function_name = function_name or event_name

	Managers.event:register(self, event_name, function_name)

	self._event_list[event_name] = function_name
end

ViewElementBase._unregister_event = function (self, event_name)
	Managers.event:unregister(self, event_name)

	self._event_list[event_name] = nil
end

ViewElementBase._unregister_events = function (self)
	for event_name, _ in pairs(self._event_list) do
		self:_unregister_event(event_name)
	end

	self._event_list = {}
end

ViewElementBase.destroy = function (self)
	self:_unregister_events()
end

return ViewElementBase
