local WidgetUtilities = require("scripts/managers/imgui/widgets/imgui_widget_utilities")
local DEFAULT_INPUT_FIELD_WIDTH = 100

local function tooltip(text)
	if Imgui.is_item_hovered() then
		Imgui.begin_tool_tip()
		Imgui.text(text)
		Imgui.end_tool_tip()
	end
end

local Widget = {
	new = function (display_name, button_text, on_activated, maps, circumstances, side_missions, default_value, optional_width)
		return {
			type = "debug_mission_input",
			display_name = display_name,
			label = WidgetUtilities.create_unique_label(),
			circumstance_label = WidgetUtilities.create_unique_label(),
			side_mission_label = WidgetUtilities.create_unique_label(),
			resistance_label = WidgetUtilities.create_unique_label(),
			challenge_label = WidgetUtilities.create_unique_label(),
			button_label = WidgetUtilities.create_unique_label(button_text),
			on_activated = on_activated,
			maps = maps,
			circumstances = circumstances,
			side_missions = side_missions,
			value = default_value,
			width = optional_width or DEFAULT_INPUT_FIELD_WIDTH
		}
	end
}

local function render_mission_dropdown(widget)
	local maps = widget.maps
	local dropdown_label = widget.label
	local current_value = widget.value

	Imgui.push_item_width(widget.width)

	local dropdown_is_active = Imgui.begin_combo(dropdown_label, current_value.map)
	local dropdown_is_focused = Imgui.is_item_focused() or dropdown_is_active

	tooltip("Mission")

	if dropdown_is_focused and not dropdown_is_active and Imgui.is_key_pressed(Imgui.KEY_RIGHT_ARROW) then
		Imgui.activate_item(Imgui.get_id(dropdown_label))
	end

	local focused_value = nil

	if dropdown_is_active then
		for i = 1, #maps, 1 do
			local opt_text = maps[i]
			local opt_value = maps[i]
			local selected = current_value.map == opt_value

			if Imgui.selectable(opt_text, selected) then
				current_value.map = opt_value
			end

			if Imgui.is_item_focused() then
				focused_value = opt_value
			end
		end

		Imgui.end_combo()

		if focused_value ~= nil and Imgui.is_key_pressed(Imgui.KEY_RIGHT_ARROW) then
			current_value.map = focused_value

			WidgetUtilities.focus_widget(widget.circumstance_label)
		elseif Imgui.is_key_pressed(Imgui.KEY_LEFT_ARROW) then
			WidgetUtilities.focus_widget(dropdown_label)
		end
	end

	Imgui.pop_item_width()
	Imgui.push_item_width(25)
end

local function render_circumstance_dropdown(widget)
	local circumstances = widget.circumstances
	local dropdown_label = widget.circumstance_label
	local current_value = widget.value

	Imgui.push_item_width(widget.width)

	local dropdown_is_active = Imgui.begin_combo(dropdown_label, current_value.circumstance_name)
	local dropdown_is_focused = Imgui.is_item_focused() or dropdown_is_active

	tooltip("Circumstance")

	if dropdown_is_focused and not dropdown_is_active and Imgui.is_key_pressed(Imgui.KEY_RIGHT_ARROW) then
		Imgui.activate_item(Imgui.get_id(dropdown_label))
	end

	local focused_value = nil

	if dropdown_is_active then
		for i = 1, #circumstances, 1 do
			local opt_text = circumstances[i]
			local opt_value = circumstances[i]
			local selected = current_value.circumstance_name == opt_value

			if Imgui.selectable(opt_text, selected) then
				current_value.circumstance_name = opt_value
			end

			if Imgui.is_item_focused() then
				focused_value = opt_value
			end
		end

		Imgui.end_combo()

		if focused_value ~= nil and Imgui.is_key_pressed(Imgui.KEY_RIGHT_ARROW) then
			current_value.circumstance_name = focused_value

			WidgetUtilities.focus_widget(widget.side_mission_label)
		elseif Imgui.is_key_pressed(Imgui.KEY_LEFT_ARROW) then
			WidgetUtilities.focus_widget(dropdown_label)
		end
	end

	Imgui.pop_item_width()
	Imgui.push_item_width(25)
end

local function render_side_mission_dropdown(widget)
	local side_missions = widget.side_missions
	local dropdown_label = widget.side_mission_label
	local current_value = widget.value

	Imgui.push_item_width(widget.width)

	local dropdown_is_active = Imgui.begin_combo(dropdown_label, current_value.side_mission)
	local dropdown_is_focused = Imgui.is_item_focused() or dropdown_is_active

	tooltip("Side Mission")

	if dropdown_is_focused and not dropdown_is_active and Imgui.is_key_pressed(Imgui.KEY_RIGHT_ARROW) then
		Imgui.activate_item(Imgui.get_id(dropdown_label))
	end

	local focused_value = nil

	if dropdown_is_active then
		for i = 1, #side_missions, 1 do
			local opt_text = side_missions[i]
			local opt_value = side_missions[i]
			local selected = current_value.side_mission == opt_value

			if Imgui.selectable(opt_text, selected) then
				current_value.side_mission = opt_value
			end

			if Imgui.is_item_focused() then
				focused_value = opt_value
			end
		end

		Imgui.end_combo()

		if focused_value ~= nil and Imgui.is_key_pressed(Imgui.KEY_RIGHT_ARROW) then
			current_value.side_mission = focused_value
		elseif Imgui.is_key_pressed(Imgui.KEY_LEFT_ARROW) then
			WidgetUtilities.focus_widget(widget.circumstance_label)
		end
	end

	Imgui.pop_item_width()
	Imgui.push_item_width(25)
end

Widget.render = function (widget)
	local current_value = widget.value
	local on_activated = widget.on_activated

	render_mission_dropdown(widget)
	Imgui.same_line(10)

	current_value.resistance = Imgui.input_float(widget.resistance_label, current_value.resistance, "%.0f")

	tooltip("Resistance")
	Imgui.same_line(10)

	current_value.challenge = Imgui.input_float(widget.challenge_label, current_value.challenge, "%.0f")

	tooltip("Challenge")
	render_circumstance_dropdown(widget)
	Imgui.same_line(10)
	render_side_mission_dropdown(widget)

	local button_label = widget.button_label

	if Imgui.button(button_label) then
		on_activated(current_value)
	end

	local is_focused = Imgui.is_item_focused()
	local is_active = false

	if is_focused and Imgui.is_key_pressed(Imgui.KEY_RIGHT_ARROW) then
		WidgetUtilities.activate_widget(button_label)
	end

	Imgui.pop_item_width()

	return is_focused, is_active
end

return Widget
