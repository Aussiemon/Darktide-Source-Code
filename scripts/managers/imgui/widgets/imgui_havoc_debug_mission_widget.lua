-- chunkname: @scripts/managers/imgui/widgets/imgui_havoc_debug_mission_widget.lua

local ImguiWidgetUtilities = require("scripts/managers/imgui/widgets/imgui_widget_utilities")
local DEFAULT_INPUT_FIELD_WIDTH = 100

local function _tooltip(text)
	if Imgui.is_item_hovered() then
		Imgui.begin_tool_tip()
		Imgui.text(text)
		Imgui.end_tool_tip()
	end
end

local Widget = {}

Widget.new = function (display_name, button_text, on_activated, maps, havoc_ranks, default_value, optional_width)
	return {
		type = "debug_havoc_mission_input",
		display_name = display_name,
		label = ImguiWidgetUtilities.create_unique_label(),
		button_label = ImguiWidgetUtilities.create_unique_label(button_text),
		havoc_rank_label = ImguiWidgetUtilities.create_unique_label(),
		on_activated = on_activated,
		maps = maps,
		havoc_ranks = havoc_ranks,
		value = default_value,
		width = optional_width or DEFAULT_INPUT_FIELD_WIDTH
	}
end

local function _render_mission_dropdown(widget)
	local maps = widget.maps
	local dropdown_label = widget.label
	local current_value = widget.value

	Imgui.push_item_width(widget.width)

	local dropdown_is_active = Imgui.begin_combo(dropdown_label, current_value.map)
	local dropdown_is_focused = Imgui.is_item_focused() or dropdown_is_active

	_tooltip("Mission")

	if dropdown_is_focused and not dropdown_is_active and Imgui.is_key_pressed(Imgui.KEY_RIGHT_ARROW) then
		ImguiWidgetUtilities.activate_widget(dropdown_label)
	end

	if dropdown_is_active then
		local focused_value

		for i = 1, #maps do
			local opt_text = maps[i]
			local opt_value = maps[i]
			local selected = current_value.map == opt_value

			if Imgui.selectable(opt_text, selected) then
				current_value.map = opt_value
			end

			if selected then
				Imgui.set_item_default_focus()
			end

			if Imgui.is_item_focused() then
				focused_value = opt_value
			end
		end

		local widget_label_to_activate

		if focused_value ~= nil and Imgui.is_key_pressed(Imgui.KEY_RIGHT_ARROW) then
			current_value.map = focused_value

			Imgui.close_current_popup()

			widget_label_to_activate = widget.circumstance_label
		elseif Imgui.is_key_pressed(Imgui.KEY_LEFT_ARROW) then
			Imgui.close_current_popup()
		end

		Imgui.end_combo()

		if widget_label_to_activate then
			ImguiWidgetUtilities.activate_widget(widget_label_to_activate)
		end
	end

	Imgui.pop_item_width()
	Imgui.push_item_width(25)
end

Widget.render = function (widget)
	local current_value = widget.value
	local on_activated = widget.on_activated

	_render_mission_dropdown(widget)
	Imgui.same_line(10)

	current_value.havoc_rank = Imgui.input_float(widget.havoc_rank_label, current_value.havoc_rank, "%.0f")

	_tooltip("Havoc order rank")

	local button_label = widget.button_label

	if Imgui.button(button_label) then
		on_activated(current_value)
	end

	local is_focused = Imgui.is_item_focused()
	local is_active = false

	if is_focused and Imgui.is_key_pressed(Imgui.KEY_RIGHT_ARROW) then
		ImguiWidgetUtilities.activate_widget(button_label)
	end

	Imgui.pop_item_width()

	return is_focused, is_active
end

return Widget
