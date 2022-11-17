local definition_path = "scripts/ui/view_elements/view_element_input_legend/view_element_input_legend_definitions"
local InputUtils = require("scripts/managers/input/input_utils")
local DefaultViewInputSettings = require("scripts/settings/input/default_view_input_settings")
local ViewElementInputLegendSettings = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIScenegraph = require("scripts/managers/ui/ui_scenegraph")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local TextUtils = require("scripts/utilities/ui/text")
local ViewElementInputLegend = class("ViewElementInputLegend", "ViewElementBase")

ViewElementInputLegend.init = function (self, parent, draw_layer, start_scale)
	local definitions = require(definition_path)

	ViewElementInputLegend.super.init(self, parent, draw_layer, start_scale, definitions)

	self._entry_index = 0
	self._entries = {}
end

ViewElementInputLegend.add_entry = function (self, display_name, input_action, visibility_function, on_pressed_callback, side_optional, sound_overrides, use_mouse_hold)
	local id = "entry_" .. self._entry_index
	local scenegraph_id = "entry_pivot"
	local pass_template = ButtonPassTemplates.input_legend_button
	local default_size = ViewElementInputLegendSettings.button_size
	local widget_definition = pass_template and UIWidget.create_definition(pass_template, scenegraph_id, nil, default_size)

	if sound_overrides then
		local hotspot = widget_definition.content.hotspot
		hotspot.on_pressed_sound = sound_overrides.on_pressed_sound
		hotspot.on_hover_sound = sound_overrides.on_hover_sound
		hotspot.on_released_sound = sound_overrides.on_released_sound
	end

	local widget = self:_create_widget(id, widget_definition)
	local entry = {
		recalcultate_text_width = true,
		is_visible = true,
		widget = widget,
		id = id,
		display_name = display_name,
		input_action = input_action,
		visibility_function = visibility_function,
		on_pressed_callback = on_pressed_callback,
		side = side_optional,
		use_mouse_hold = use_mouse_hold
	}
	local content = widget.content

	if on_pressed_callback then
		content.hotspot.pressed_callback = function ()
			if not self._input_handled then
				on_pressed_callback(id)
			end
		end
	end

	self:_update_widget_text(entry)

	self._entries[#self._entries + 1] = entry
	self._entry_index = self._entry_index + 1

	return id
end

ViewElementInputLegend._update_widget_size = function (self, widget, ui_renderer)
	local content = widget.content
	local style = widget.style
	local text_style = style.text
	local text = content.text
	local size = content.size
	local text_options = UIFonts.get_font_options_by_style(text_style)
	size[1] = 1920
	local width, height = UIRenderer.text_size(ui_renderer, text, text_style.font_type, text_style.font_size, size, text_options)
	size[1] = width + ViewElementInputLegendSettings.button_text_margin
end

ViewElementInputLegend.remove_entry = function (self, id)
	local entry, index = self:_get_entry_by_id(id)

	if entry then
		local widget = entry.widget

		self:_unregister_widget_name(widget.name)
		table.remove(self._entries, index)

		return true
	end

	return false
end

ViewElementInputLegend.remove_all_entries = function (self)
	if self._entries then
		for i = 1, #self._entries do
			local entry = self._entries[i]
			local widget = entry.widget

			self:_unregister_widget_name(widget.name)
		end
	end

	self._entries = {}
	self._entry_index = 0
end

ViewElementInputLegend.update = function (self, dt, t, input_service)
	self._input_handled = false

	self:_handle_input(dt, t, input_service)

	return ViewElementInputLegend.super.update(self, dt, t, input_service)
end

ViewElementInputLegend._handle_input = function (self, dt, t, input_service)
	local entries = self._entries
	local input_handled = false

	if entries then
		for i = 1, #entries do
			local entry = entries[i]
			local input_action = entry.input_action

			if input_action and input_service:get(input_action) and entry.is_visible or entry.use_mouse_hold and entry.is_visible and entry.widget.content.hotspot.is_held then
				local on_pressed_callback = entry.on_pressed_callback

				if on_pressed_callback then
					local id = entry.id
					input_handled = true

					on_pressed_callback(id)

					break
				end
			end
		end
	end

	self._input_handled = input_handled
end

ViewElementInputLegend._on_navigation_input_changed = function (self)
	local entries = self._entries

	if entries then
		for i = 1, #entries do
			local entry = entries[i]

			self:_update_widget_text(entry)
		end
	end
end

ViewElementInputLegend.set_display_name = function (self, entry_id, display_name, suffix)
	local entry = self:_get_entry_by_id(entry_id)

	if entry and display_name ~= entry.display_name then
		entry.display_name = display_name
		entry.suffix = suffix

		self:_update_widget_text(entry)
	end
end

ViewElementInputLegend._get_entry_by_id = function (self, id)
	local entries = self._entries

	if entries then
		for i = 1, #entries do
			local entry = entries[i]

			if entry.id == id then
				return entry, i
			end
		end
	end

	return nil
end

ViewElementInputLegend._update_widget_text = function (self, entry)
	local service_type = DefaultViewInputSettings.service_type
	local widget = entry.widget

	if widget then
		local action = entry.input_action
		local display_name = entry.display_name
		local text = TextUtils.localize_with_button_hint(action, display_name, nil, service_type, Localize("loc_input_legend_text_template"))
		local suffix = entry.suffix

		if suffix then
			text = text .. suffix
		end

		widget.content.text = text
		entry.recalcultate_text_width = true
	end
end

ViewElementInputLegend._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	ViewElementInputLegend.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

	local entries = self._entries

	if entries then
		local scale = self._render_scale
		local inverse_scale = 1 / scale
		local resolution_width = RESOLUTION_LOOKUP.width
		local parent_width, _ = UIScenegraph.get_render_size(self._ui_scenegraph, "bottom_panel", scale)
		local inversed_parent_width = parent_width * inverse_scale
		local button_spacing = ViewElementInputLegendSettings.button_spacing
		local button_edge_margin = ViewElementInputLegendSettings.button_edge_margin
		local left_size_offset = button_edge_margin
		local right_size_offset = inversed_parent_width - button_edge_margin
		local total_center_alignment_size = 0
		local num_entries = #entries

		for i = 1, num_entries do
			local entry = entries[i]
			local widget = entry.widget

			if entry.recalcultate_text_width then
				self:_update_widget_size(widget, ui_renderer)

				entry.recalcultate_text_width = false
			end

			if entry.is_visible then
				local side = entry.side
				local offset = widget.offset
				local size = widget.content.size

				if side == "center_alignment" then
					total_center_alignment_size = total_center_alignment_size + size[1] + button_spacing
				elseif side == "left_alignment" then
					offset[1] = left_size_offset
					left_size_offset = left_size_offset + size[1] + button_spacing

					UIWidget.draw(widget, ui_renderer)
				else
					right_size_offset = right_size_offset - (size[1] + button_spacing)
					offset[1] = right_size_offset

					UIWidget.draw(widget, ui_renderer)
				end
			end

			local visibility_function = entry.visibility_function

			if visibility_function then
				local id = entry.id
				entry.is_visible = visibility_function(self._parent, id)
			end
		end

		if total_center_alignment_size > 0 then
			total_center_alignment_size = total_center_alignment_size - button_spacing
			local center_size_offset = (inversed_parent_width - total_center_alignment_size) / 2

			for i = 1, num_entries do
				local entry = entries[i]

				if entry.side == "center_alignment" and entry.is_visible then
					local widget = entry.widget
					local offset = widget.offset
					local size = widget.content.size
					offset[1] = center_size_offset
					center_size_offset = center_size_offset + size[1] + button_spacing

					UIWidget.draw(widget, ui_renderer)
				end
			end
		end
	end
end

return ViewElementInputLegend
