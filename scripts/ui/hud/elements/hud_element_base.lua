local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIScenegraph = require("scripts/managers/ui/ui_scenegraph")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UISequenceAnimator = require("scripts/managers/ui/ui_sequence_animator")
local HudElementBase = class("HudElementBase")

HudElementBase.init = function (self, parent, draw_layer, start_scale, definitions)
	self._definitions = definitions
	self._draw_layer = draw_layer
	self._parent = parent
	self._event_list = {}
	self._ui_scenegraph = self:_create_scenegraph(definitions, start_scale)
	self._widgets_by_name = {}
	self._widgets = {}

	self:_create_widgets(definitions, self._widgets, self._widgets_by_name)

	self._ui_sequence_animator = self:_create_sequence_animator(definitions)
end

HudElementBase._create_scenegraph = function (self, definitions, start_scale)
	local scenegraph_definition = definitions.scenegraph_definition
	local scenegraph = UIScenegraph.init_scenegraph(scenegraph_definition, start_scale)

	return scenegraph
end

HudElementBase._create_widgets = function (self, definitions, widgets, widgets_by_name)
	local widget_definitions = definitions.widget_definitions
	widgets = widgets or {}
	widgets_by_name = widgets_by_name or {}

	for name, definition in pairs(widget_definitions) do
		local widget = self:_create_widget(name, definition)
		widgets[#widgets + 1] = widget
		widget.dirty = true
	end

	return widgets, widgets_by_name
end

HudElementBase._create_widget = function (self, name, definition)
	local widgets_by_name = self._widgets_by_name
	local widget = UIWidget.init(name, definition)
	widgets_by_name[name] = widget
	widget.dirty = true

	return widget
end

HudElementBase._unregister_widget_name = function (self, name)
	local widgets_by_name = self._widgets_by_name
	widgets_by_name[name] = nil
end

HudElementBase.has_widget = function (self, name)
	return self._widgets_by_name[name] ~= nil
end

HudElementBase._create_sequence_animator = function (self, definitions)
	local animations = definitions.animations

	if animations then
		local scenegraph_definition = definitions.scenegraph_definition

		return UISequenceAnimator:new(self._ui_scenegraph, scenegraph_definition, animations)
	end
end

HudElementBase._start_animation = function (self, animation_sequence_name, widgets, speed, params)
	speed = speed or 1
	widgets = widgets or self._widgets_by_name
	local ui_sequence_animator = self._ui_sequence_animator
	local animation_id = ui_sequence_animator:start_animation(self, animation_sequence_name, widgets, params, speed)

	return animation_id
end

HudElementBase._stop_animation = function (self, animation_id)
	local ui_sequence_animator = self._ui_sequence_animator

	ui_sequence_animator:stop_animation(animation_id)
end

HudElementBase._is_animation_active = function (self, animation_sequence_name)
	return self._ui_sequence_animator:is_animation_active(animation_sequence_name)
end

HudElementBase.set_scenegraph_widgets_visible = function (self, scenegraph_id, visible)
	local widgets = self._widgets
	local n_widgets = #widgets

	for i = 1, n_widgets do
		local widget = widgets[i]

		if widget.scenegraph_id == scenegraph_id then
			widget.content.visible = visible
		end
	end
end

HudElementBase.set_visible = function (self, visible, ui_renderer, use_retained_mode)
	return
end

HudElementBase.set_dirty = function (self)
	local widgets = self._widgets
	local n_widgets = #widgets

	for i = 1, n_widgets do
		local widget = widgets[i]
		widget.dirty = true
	end
end

HudElementBase.on_resolution_modified = function (self)
	self._update_scenegraph = true
end

HudElementBase.scenegraph_size = function (self, id, scale)
	local ui_scenegraph = self._ui_scenegraph

	return UIScenegraph.size_scaled(ui_scenegraph, id, scale)
end

HudElementBase.scenegraph_position = function (self, id)
	local ui_scenegraph = self._ui_scenegraph
	local scenegraph = ui_scenegraph[id]

	return scenegraph.position
end

HudElementBase.scenegraph_world_position = function (self, id, scale)
	local ui_scenegraph = self._ui_scenegraph

	return UIScenegraph.world_position(ui_scenegraph, id, scale)
end

HudElementBase.set_scenegraph_position = function (self, id, x, y, z, horizontal_alignment, vertical_alignment)
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

HudElementBase._set_scenegraph_size = function (self, id, width, height)
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

HudElementBase._update_animations = function (self, dt, t)
	local ui_sequence_animator = self._ui_sequence_animator

	if ui_sequence_animator and ui_sequence_animator:update(dt, t) then
		self._update_scenegraph = true
	end
end

HudElementBase.begin_update = function (self, dt, t, ui_renderer, render_settings, input_service)
	render_settings.start_layer = self._draw_layer
	local ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)
end

HudElementBase.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	self:_update_animations(dt, t)

	if self._update_scenegraph then
		local ui_scenegraph = self._ui_scenegraph

		UIScenegraph.update_scenegraph(ui_scenegraph, render_settings.scale)

		self._update_scenegraph = nil

		self:set_dirty()
	end
end

HudElementBase.end_update = function (self, dt, t, ui_renderer, render_settings, input_service)
	UIRenderer.end_pass(ui_renderer)
end

HudElementBase.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	render_settings.start_layer = self._draw_layer
	local ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)
	self:_draw_widgets(dt, t, input_service, ui_renderer, render_settings)
	UIRenderer.end_pass(ui_renderer)
end

HudElementBase._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	local widgets = self._widgets
	local num_widgets = #widgets

	for i = 1, num_widgets do
		local widget = widgets[i]

		UIWidget.draw(widget, ui_renderer)
	end
end

HudElementBase._play_sound = function (self, event_name)
	local ui_manager = Managers.ui

	ui_manager:play_2d_sound(event_name)
end

HudElementBase._play_3d_sound = function (self, event_name, position)
	local ui_manager = Managers.ui

	ui_manager:play_3d_sound(event_name, position)
end

HudElementBase.destroy = function (self, ui_renderer)
	self._parent:destroy_offscreen_widgets(self.__class_name, self)
	self:_unregister_events()

	self.destroyed = true
end

HudElementBase._localize = function (self, text, no_cache, context)
	return Managers.localization:localize(text, no_cache, context)
end

HudElementBase._register_event = function (self, event_name, function_name)
	function_name = function_name or event_name

	Managers.event:register(self, event_name, function_name)

	self._event_list[event_name] = function_name
end

HudElementBase._unregister_event = function (self, event_name)
	Managers.event:unregister(self, event_name)

	self._event_list[event_name] = nil
end

HudElementBase._unregister_events = function (self)
	for event_name, _ in pairs(self._event_list) do
		self:_unregister_event(event_name)
	end

	self._event_list = {}
end

return HudElementBase
