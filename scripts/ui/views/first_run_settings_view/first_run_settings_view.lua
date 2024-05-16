-- chunkname: @scripts/ui/views/first_run_settings_view/first_run_settings_view.lua

local Definitions = require("scripts/ui/views/first_run_settings_view/first_run_settings_view_definitions")
local ContentBlueprints = require("scripts/ui/views/first_run_settings_view/first_run_settings_view_blueprints")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local template_functions = require("scripts/ui/views/first_run_settings_view/components")
local template_utils = require("scripts/ui/views/first_run_settings_view/utils")
local screen_1 = {
	{
		default_value = 2.2,
		display_name = "Gamma",
		id = "gamma_value",
		max_value = 3,
		min_value = 0.1,
		num_decimals = 1,
		save_location = "",
		step_size_value = 0.1,
		widget_type = "value_slider",
		get_function = function (template)
			return template.default_value
		end,
		on_value_changed = function (template, value)
			Application.set_render_setting("gamma", tostring(value))
		end,
	},
}
local screen_2 = {
	{
		default_value = true,
		display_name = "loc_interface_setting_subtitle_enabled",
		id = "subtitle_enabled",
		save_location = "interface_settings",
		widget_type = "checkbox",
		get_function = function (template)
			return template_utils.get_account_settings(template.save_location, template.id) or template.default_value
		end,
		on_value_changed = function (template, value)
			template_utils.save_account_settings(template.save_location, template.id, value)
			Managers.event:trigger("event_update_subtitles_enabled", value)
		end,
	},
	{
		default_value = true,
		display_name = "loc_interface_setting_subtitle_speaker_enabled",
		id = "subtitle_speaker_enabled",
		save_location = "interface_settings",
		widget_type = "checkbox",
		get_function = function (template)
			return template_utils.get_account_settings(template_utils.save_location, template_utils.id) or template.default_value
		end,
		on_value_changed = function (template, value)
			template_utils.save_account_settings(template.save_location, template.id, value)
			Managers.event:trigger("event_update_subtitle_speaker_enabled", value)
		end,
	},
	{
		default_value = 32,
		display_name = "loc_interface_setting_subtitle_font_size",
		id = "subtitle_font_size",
		max_value = 72,
		min_value = 12,
		num_decimals = 0,
		save_location = "interface_settings",
		step_size_value = 1,
		widget_type = "value_slider",
		get_function = function (template)
			return template_utils.get_account_settings(template.save_location, template.id) or template.default_value
		end,
		on_value_changed = function (template, value)
			template_utils.save_account_settings(template.save_location, template.id, value)
			Managers.event:trigger("event_update_subtitles_font_size", value)
		end,
	},
	{
		default_value = 80,
		display_name = "loc_interface_setting_subtitle_background_opacity",
		id = "subtitle_background_opacity",
		min_value = 0,
		save_location = "interface_settings",
		widget_type = "percent_slider",
		get_function = function (template)
			return template_utils.get_account_settings(template.save_location, template.id) or template.default_value
		end,
		on_value_changed = function (template, value)
			template_utils.save_account_settings(template.save_location, template.id, value)
			Managers.event:trigger("event_update_subtitles_background_opacity", value)
		end,
	},
	{
		default_value = 100,
		display_name = "loc_interface_setting_subtitle_text_opacity",
		id = "subtitle_text_opacity",
		min_value = 10,
		save_location = "interface_settings",
		widget_type = "percent_slider",
		get_function = function (template)
			return template_utils.get_account_settings(template.save_location, template.id) or template.default_value
		end,
		on_value_changed = function (template, value)
			template_utils.save_account_settings(template.save_location, template.id, value)
			Managers.event:trigger("event_update_subtitle_text_opacity", value)
		end,
	},
}
local screen_3 = {
	{
		default_value = 1,
		display_name = "loc_setting_speaker_settings",
		id = "speaker_settings",
		save_location = "sound_settings",
		widget_type = "dropdown",
		options = {
			{
				display_name = "loc_setting_speaker_five_one",
				id = 0,
				values = {
					audio_settings = {
						speaker_settings = 0,
					},
				},
			},
			{
				display_name = "loc_setting_speaker_stereo",
				id = 1,
				values = {
					audio_settings = {
						speaker_settings = 1,
					},
				},
			},
			{
				display_name = "loc_setting_speaker_stereo_headphones",
				id = 2,
				values = {
					audio_settings = {
						speaker_settings = 2,
					},
				},
			},
			{
				display_name = "loc_setting_speaker_mono",
				id = 3,
				values = {
					audio_settings = {
						speaker_settings = 3,
					},
				},
			},
		},
		get_function = function (template)
			return template_utils.get_account_settings(template.save_location, template.id) or template.default_value
		end,
		on_value_changed = function (value)
			local PANNING_RULE_SPEAKERS = 0
			local PANNING_RULE_HEADPHONES = 1
			local mastering_bus_name = "MIX_BUS"

			if value == 0 then
				Wwise.set_panning_rule(PANNING_RULE_SPEAKERS)
				Wwise.set_bus_config(mastering_bus_name, Wwise.AK_SPEAKER_SETUP_5POINT1)
			elseif value == 1 then
				Wwise.set_panning_rule(PANNING_RULE_SPEAKERS)
				Wwise.set_bus_config(mastering_bus_name, Wwise.AK_SPEAKER_SETUP_STEREO)
			elseif value == 2 then
				Wwise.set_panning_rule(PANNING_RULE_HEADPHONES)
				Wwise.set_bus_config(mastering_bus_name, Wwise.AK_SPEAKER_SETUP_STEREO)
			elseif value == 3 then
				Wwise.set_panning_rule(PANNING_RULE_SPEAKERS)
				Wwise.set_bus_config(mastering_bus_name, Wwise.AK_SPEAKER_SETUP_MONO)
			end
		end,
	},
}
local page_settings = {
	{
		title = "Gamma Settings",
		widgets = screen_1,
	},
	{
		title = "Acessibility",
		widgets = screen_2,
	},
	{
		title = "Audio Settings",
		widgets = screen_3,
	},
}
local FirstRunSettingsView = class("FirstRunSettingsView", "BaseView")

FirstRunSettingsView.init = function (self, settings, context)
	self._current_settings_widgets = {}
	self._current_settings_alignment = {}
	self._current_index = 1

	FirstRunSettingsView.super.init(self, Definitions, settings, context)

	self._allow_close_hotkey = false
	self._grid = nil
	self._offscreen_world = nil
	self._offscreen_viewport = nil
	self._offscreen_viewport_name = nil
end

FirstRunSettingsView.on_enter = function (self)
	FirstRunSettingsView.super.on_enter(self)
	self:_setup_buttons_interactions()
	self:_change_settings_page(1)
end

FirstRunSettingsView.on_exit = function (self)
	if self._ui_offscreen_renderer then
		self._ui_offscreen_renderer = nil

		Managers.ui:destroy_renderer(self.__class_name .. "_ui_offscreen_renderer")

		local offscreen_world = self._offscreen_world
		local offscreen_viewport_name = self._offscreen_viewport_name

		ScriptWorld.destroy_viewport(offscreen_world, offscreen_viewport_name)
		Managers.ui:destroy_world(offscreen_world)

		self._offscreen_viewport = nil
		self._offscreen_viewport_name = nil
		self._offscreen_world = nil
	end

	FirstRunSettingsView.super.on_exit(self)
end

FirstRunSettingsView._setup_buttons_interactions = function (self)
	self._widgets_by_name.next_button.content.hotspot.pressed_callback = callback(self, "_on_forward_pressed")
end

FirstRunSettingsView._change_settings_page = function (self, next_index)
	if next_index > #page_settings then
		Managers.event:trigger("event_state_first_run_settings_continue")

		return
	end

	local settings = {}
	local settings_alignment = {}
	local settings_title = page_settings[next_index].title
	local settings_widgets = page_settings[next_index].widgets
	local current_widgets = self._current_settings_widgets
	local title_widget = self._widgets_by_name.title_settings
	local page_number_widget = self._widgets_by_name.page_number

	if current_widgets then
		for i = 1, #current_widgets do
			local widget = current_widgets[i]
			local widget_name = widget.name

			self:_unregister_widget_name(widget_name)
		end
	end

	for i = 1, #settings_widgets do
		local setting_template = settings_widgets[i]
		local widget_type = setting_template.widget_type
		local template_function = template_functions[widget_type]
		local widget_options = {}

		if template_function then
			widget_options = template_function(setting_template)
		else
			widget_options = setting_template
		end

		local widget, alignment = self:_create_setting_widget(widget_options, i)

		settings[#settings + 1] = widget
		settings_alignment[#settings_alignment + 1] = alignment
	end

	self._current_settings_widgets = settings
	self._current_settings_alignment = settings_alignment
	self._current_index = next_index
	title_widget.content.text = settings_title
	page_number_widget.content.text = self._current_index .. " / " .. #page_settings
	self._grid = self:_setup_grid()
end

FirstRunSettingsView._create_setting_widget = function (self, widget_options, suffix)
	local callback_name = "cb_on_settings_pressed"
	local scenegraph_id = "grid_content_pivot"
	local widget_type = widget_options.widget_type
	local widget
	local template = ContentBlueprints[widget_type]
	local size = template.size_function and template.size_function(self, widget_options) or template.size
	local pass_template_function = template.pass_template_function
	local pass_template = pass_template_function and pass_template_function(self, widget_options) or template.pass_template
	local widget_definition = pass_template and UIWidget.create_definition(pass_template, scenegraph_id, nil, size)

	if widget_definition then
		local name = "widget_" .. suffix

		widget = self:_create_widget(name, widget_definition)
		widget.type = widget_type

		local init = template.init

		if init then
			init(self, widget, widget_options, callback_name)
		end
	end

	if widget then
		return widget, widget
	else
		return nil, {
			size = size,
		}
	end
end

FirstRunSettingsView.cb_on_settings_pressed = function (self, widget, entry)
	local pressed_function = entry.pressed_function

	if pressed_function then
		pressed_function(self, widget, entry)
	end
end

FirstRunSettingsView._setup_grid = function (self)
	local ui_scenegraph = self._ui_scenegraph
	local direction = "down"
	local grid_scenegraph_id = "grid_start"
	local grid_spacing = {
		0,
		10,
	}
	local widgets = self._current_settings_widgets
	local alignment = self._current_settings_alignment
	local grid = UIWidgetGrid:new(widgets, alignment, ui_scenegraph, grid_scenegraph_id, direction, grid_spacing)

	return grid
end

FirstRunSettingsView._update_settings_widgets = function (self, dt, t, input_service)
	local settings = self._current_settings_widgets

	for i = 1, #settings do
		local widget = settings[i]
		local widget_type = widget.type
		local template = ContentBlueprints[widget_type]
		local update = template and template.update

		if update then
			update(self, widget, input_service, dt, t)
		end
	end
end

FirstRunSettingsView._on_forward_pressed = function (self)
	local index = self._current_index + 1

	self:_change_settings_page(index)
end

FirstRunSettingsView._setup_offscreen_gui = function (self)
	local ui_manager = Managers.ui
	local class_name = self.__class_name
	local timer_name = "ui"
	local world_layer = 10
	local world_name = class_name .. "_ui_offscreen_world"
	local view_name = self.view_name

	self._offscreen_world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)

	local viewport_name = class_name .. "_ui_offscreen_world_viewport"
	local viewport_type = "overlay_offscreen"
	local viewport_layer = 1

	self._offscreen_viewport = ui_manager:create_viewport(self._offscreen_world, viewport_name, viewport_type, viewport_layer)
	self._offscreen_viewport_name = viewport_name
	self._ui_offscreen_renderer = ui_manager:create_renderer(class_name .. "_ui_offscreen_renderer", self._offscreen_world)
end

FirstRunSettingsView.draw = function (self, dt, t, input_service, layer)
	if self._current_settings_widgets then
		self:_draw_grid(dt, t, input_service)
	end

	return FirstRunSettingsView.super.draw(self, dt, t, input_service, layer)
end

FirstRunSettingsView._draw_grid = function (self, dt, t, input_service)
	local render_settings = self._render_settings
	local ui_renderer = self._ui_renderer
	local ui_scenegraph = self._ui_scenegraph
	local widgets = self._current_settings_widgets
	local grid = self._grid

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

	for j = 1, #widgets do
		local widget = widgets[j]

		if grid:is_widget_visible(widget) then
			UIWidget.draw(widget, ui_renderer)
		end
	end

	UIRenderer.end_pass(ui_renderer)
end

FirstRunSettingsView.update = function (self, dt, t, input_service, layer)
	self:_update_settings_widgets(dt, t, input_service)

	return FirstRunSettingsView.super.update(self, dt, t, input_service, layer)
end

return FirstRunSettingsView
