-- chunkname: @scripts/managers/imgui/widgets/imgui_debug_sound_events.lua

local ImguiWidgetUtilities = require("scripts/managers/imgui/widgets/imgui_widget_utilities")
local Widget = {}

Widget.new = function (display_name, optional_width)
	local position = {
		0,
		0,
		0,
	}
	local ImguiInputWidgets = require("scripts/managers/imgui/widgets/imgui_input_widgets")
	local widget = {
		event_name = "",
		play_positioned = false,
		single_column = true,
		type = "debug_sound_events",
		display_name = display_name,
		play_sound_event = ImguiWidgetUtilities.create_unique_label("Play Sound"),
		play_stop_sound_event = ImguiWidgetUtilities.create_unique_label("Play Stop Sound"),
		relative_to_player = {
			false,
		},
		position = position,
		position_widget = ImguiInputWidgets.vector3.new("", function ()
			return position
		end, function (new_value)
			position[1], position[2], position[3] = new_value[1], new_value[2], new_value[3]
		end),
	}

	return widget
end

local function _wwise_world()
	local world = Managers.world:world("level_world")

	return Managers.world:wwise_world(world)
end

local function _play_sound(widget, event_name)
	if widget.play_positioned then
		local position = Vector3(unpack(widget.position))

		if widget.relative_to_player and Unit.alive(widget.relative_to_player.player_unit) then
			position = position + Unit.local_position(widget.relative_to_player.player_unit, 1)
		end

		local source = WwiseWorld.make_auto_source(_wwise_world(), position, Quaternion.identity())
		local success, playing_id_or_error = pcall(WwiseWorld.trigger_resource_event, _wwise_world(), event_name, source)

		if success and not WwiseWorld.is_playing(_wwise_world(), playing_id_or_error) then
			success = false
			playing_id_or_error = "Failed to play positioned sound. Check Log."
		end

		widget.error_msg = not success and playing_id_or_error or nil
	else
		local success, playing_id_or_error = pcall(WwiseWorld.trigger_resource_event, _wwise_world(), event_name)

		if success and not WwiseWorld.is_playing(_wwise_world(), playing_id_or_error) then
			success = false
			playing_id_or_error = "Failed to play sound. Check Log."
		end

		widget.error_msg = not success and playing_id_or_error or nil
	end
end

Widget.render = function (widget)
	Imgui.same_line()

	widget.event_name = Imgui.input_text("##Event:", widget.event_name)

	if Imgui.button(widget.play_sound_event) then
		_play_sound(widget, widget.event_name)
	end

	local stop_sound = string.sub(widget.event_name, #"Play_") == "Play_" and "Stop_" .. string.sub(widget.event_name, #"Play_" + 1, #widget.event_name) or nil

	if stop_sound and Imgui.button(widget.play_stop_sound_event) then
		_play_sound(widget, stop_sound)
	end

	widget.play_positioned = Imgui.checkbox("Play positioned", widget.play_positioned)

	if widget.play_positioned then
		local ImguiInputWidgets = require("scripts/managers/imgui/widgets/imgui_input_widgets")

		ImguiInputWidgets.vector3.render(widget.position_widget)

		local current_player_id = widget.current_player_id
		local player_list_ids = {}

		for unique_id, player in pairs(Managers.player:players()) do
			player_list_ids[#player_list_ids + 1] = unique_id
		end

		table.sort(player_list_ids)
		table.insert(player_list_ids, 1, false)

		local current_player_idx = 1
		local player_list = {}

		for i = 1, #player_list_ids do
			if player_list_ids[i] == current_player_id then
				current_player_idx = i
			end

			if player_list_ids[i] == false then
				player_list[i] = "false"
			else
				player_list[i] = Managers.player:players()[player_list_ids[i]]:name()
			end
		end

		local new_player_idx = Imgui.list_box("##Relative to player", current_player_idx, player_list)

		widget.current_player_id = player_list_ids[new_player_idx]
		widget.relative_to_player = Managers.player:players()[player_list_ids[new_player_idx]]
	end

	if widget.error_msg then
		Imgui.text_colored(widget.error_msg, 255, 0, 0, 255)
	end

	local is_focused = Imgui.is_item_focused()
	local is_active = false

	return is_focused, is_active
end

return Widget
