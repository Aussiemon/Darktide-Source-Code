-- chunkname: @scripts/ui/views/cutscene_view/cutscene_view.lua

local Definitions = require("scripts/ui/views/cutscene_view/cutscene_view_definitions")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISettings = require("scripts/settings/ui/ui_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local CutsceneView = class("CutsceneView", "BaseView")

CutsceneView.init = function (self, settings, context)
	self._context = context

	CutsceneView.super.init(self, Definitions, settings, context)

	self._pass_input = true
	self._can_exit = not context or context.can_exit
end

CutsceneView.on_enter = function (self)
	self._no_cursor = true

	CutsceneView.super.on_enter(self)
	self:_set_background_visibility(false)

	self._legend_active = 0
	self._hold_timer = 0
	self._show_skip_previous_frame = Managers.ui:cinematic_skip_state()
end

CutsceneView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 100)

	local legend_inputs = Definitions.legend_inputs
	local input_legends_by_key = {}

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)
		local id = self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment, nil, legend_input.use_mouse_hold)
		local key = legend_input.key

		if key then
			input_legends_by_key[key] = {
				id = id,
				settings = legend_input,
			}
		end
	end

	self._input_legends_by_key = input_legends_by_key

	local id = self._input_legends_by_key.hold_skip.id
	local entry = self._input_legend_element:_get_entry_by_id(id)
	local entry_widget = entry.widget
	local widget_definition = UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "background",
			style = {
				color = Color.ui_grey_medium(255, true),
			},
		},
		{
			pass_type = "rect",
			style_id = "fill",
			style = {
				color = Color.ui_terminal(255, true),
				size = {
					0,
				},
			},
		},
	}, entry_widget.scenegraph_id)

	self._skip_bar_widget = self:_create_widget("skip", widget_definition)
end

CutsceneView._remove_input_legend = function (self)
	if self._input_legend_element then
		self:_remove_element("input_legend")

		self._input_legend_element = nil
	end

	if self._skip_bar_widget then
		self:_unregister_widget_name(self._skip_bar_widget.name)

		self._skip_bar_widget = nil
	end
end

CutsceneView.is_using_input = function (self)
	return true
end

CutsceneView.on_skip_pressed = function (self)
	self._skip_pressed = true
end

CutsceneView._set_background_visibility = function (self, visible)
	self._widgets_by_name.background.content.visible = visible
end

CutsceneView.update = function (self, dt, t, input_service)
	local show_skip, can_skip = Managers.ui:cinematic_skip_state()

	if self._show_skip_previous_frame ~= show_skip then
		self._show_skip_previous_frame = show_skip
		self._legend_active = 0
		self._hold_timer = 0

		if show_skip == true then
			self:_setup_input_legend()
		else
			self:_remove_input_legend()
		end
	end

	if input_service:get("skip_cinematic_hold") and self._skip_pressed == true then
		self._hold_timer = self._hold_timer + dt
		self._legend_active = 0
	elseif self._skip_pressed == true then
		self._skip_pressed = false
		self._legend_active = 0
		self._hold_timer = 0
	elseif show_skip then
		self._legend_active = self._legend_active + dt
	end

	if self._hold_timer > UISettings.cutscenes_skip.hold_time then
		Managers.event:trigger("event_cinematic_skip_state", true, true)
	elseif self._legend_active > UISettings.cutscenes_skip.fade_inactivity_time then
		Managers.event:trigger("event_cinematic_skip_state", false, false)
	end

	return CutsceneView.super.update(self, dt, t, input_service)
end

CutsceneView.can_exit = function (self)
	return self._can_exit
end

CutsceneView.dialogue_system = function (self)
	local state_managers = Managers.state

	if state_managers then
		local extension_manager = state_managers.extension
		local system_name = "dialogue_system"

		return extension_manager and extension_manager:has_system(system_name) and extension_manager:system(system_name)
	end
end

CutsceneView.draw = function (self, dt, t, input_service, layer)
	CutsceneView.super.draw(self, dt, t, input_service, layer)

	if self._input_legend_element then
		local render_scale = self._render_scale
		local render_settings = self._render_settings
		local id = self._input_legends_by_key.hold_skip.id
		local entry = self._input_legend_element:_get_entry_by_id(id)
		local entry_widget = entry.widget
		local ui_renderer = self._ui_renderer
		local ui_scenegraph = self._input_legend_element._ui_scenegraph
		local bar_margin = 10
		local position = self._input_legend_element:scenegraph_position(entry_widget.scenegraph_id)
		local width = 100
		local z_offset = render_settings.draw_layer or 0

		z_offset = z_offset + self._input_legend_element._draw_layer + 1
		self._skip_bar_widget.offset = {
			position[1] + entry_widget.offset[1] + (entry_widget.content.size[1] - width) * 0.5,
			position[2] + entry_widget.offset[2] + entry_widget.content.size[2] - bar_margin,
			z_offset,
		}
		self._skip_bar_widget.content.size = {
			width,
			5,
		}

		local progress = UISettings.cutscenes_skip.hold_time and math.min(self._hold_timer / UISettings.cutscenes_skip.hold_time, 1) or 1

		self._skip_bar_widget.style.fill.size[1] = width * progress

		UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

		if self._skip_bar_widget then
			UIWidget.draw(self._skip_bar_widget, ui_renderer)
		end

		UIRenderer.end_pass(ui_renderer)
	end
end

return CutsceneView
