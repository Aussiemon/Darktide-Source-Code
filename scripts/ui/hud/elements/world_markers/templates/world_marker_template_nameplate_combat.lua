-- chunkname: @scripts/ui/hud/elements/world_markers/templates/world_marker_template_nameplate_combat.lua

local ProfileUtils = require("scripts/utilities/profile_utils")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISettings = require("scripts/settings/ui/ui_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local template = {}
local size = {
	400,
	20,
}
local arrow_size = {
	60,
	60,
}
local icon_size = {
	128,
	128,
}

template.size = size
template.name = "nameplate_party"
template.unit_node = "player_name"
template.position_offset = {
	0,
	0,
	-0.2,
}
template.check_line_of_sight = false
template.max_distance = 500
template.screen_clamp = true
template.screen_margins = {
	down = 0.23148148148148148,
	left = 0.234375,
	right = 0.234375,
	up = 0.23148148148148148,
}
template.scale_settings = {
	distance_max = 20,
	distance_min = 10,
	scale_from = 0.8,
	scale_to = 1,
}

template.create_widget_defintion = function (template, scenegraph_id)
	local size = template.size
	local header_font_setting_name = "hud_body"
	local header_font_settings = UIFontSettings[header_font_setting_name]
	local header_font_color = header_font_settings.text_color

	return UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "header_text",
			value = "<header_text>",
			value_id = "header_text",
			style = {
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					2,
				},
				text_color = header_font_color,
				font_type = header_font_settings.font_type,
				font_size = header_font_settings.font_size,
				default_font_size = header_font_settings.font_size,
				default_text_color = header_font_color,
				size = size,
			},
			visibility_function = function (content, style)
				return not content.is_clamped
			end,
		},
		{
			pass_type = "text",
			style_id = "icon_text",
			value = "<icon_text>",
			value_id = "icon_text",
			style = {
				drop_shadow = false,
				font_size = 32,
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				text_vertical_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					-3,
					2,
				},
				font_type = header_font_settings.font_type,
				default_font_size = header_font_settings.font_size,
				text_color = header_font_color,
				default_text_color = header_font_color,
				size = icon_size,
			},
			visibility_function = function (content, style)
				return content.is_clamped
			end,
		},
		{
			pass_type = "rotated_texture",
			style_id = "arrow",
			value = "content/ui/materials/hud/interactions/frames/direction",
			value_id = "arrow",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = arrow_size,
				offset = {
					0,
					0,
					5,
				},
				color = Color.ui_hud_green_super_light(255, true),
			},
			visibility_function = function (content, style)
				return content.is_clamped
			end,
			change_function = function (content, style)
				style.angle = content.angle
			end,
		},
	}, scenegraph_id)
end

local function _cb_event_titles_in_mission_setting_changed(self, option_type)
	local marker = self
	local data = marker.data
	local header_text = ""

	if option_type and option_type == "color_changed" then
		local player_slot = data:slot()
		local player_slot_color = UISettings.player_slot_colors[player_slot] or Color.ui_hud_green_light(255, true)
		local color_string = "{#color(" .. player_slot_color[2] .. "," .. player_slot_color[3] .. "," .. player_slot_color[4] .. ")}"

		header_text = color_string .. "{#reset()} " .. data:name()

		local profile = data:profile()
		local title = profile and ProfileUtils.character_title(profile)

		if title then
			header_text = header_text .. " \n " .. title
		end
	elseif option_type ~= "none" then
		local player_slot = data:slot()
		local player_slot_color = UISettings.player_slot_colors[player_slot] or Color.ui_hud_green_light(255, true)
		local color_string = "{#color(" .. player_slot_color[2] .. "," .. player_slot_color[3] .. "," .. player_slot_color[4] .. ")}"

		header_text = color_string .. "{#reset()} " .. data:name()

		if option_type == "name_and_title" then
			local profile = data:profile()
			local title = profile and ProfileUtils.character_title(profile)

			if title then
				header_text = header_text .. " \n " .. title
			end
		end
	end

	local widget = marker.widget
	local content = widget.content

	content.header_text = header_text
end

template.on_exit = function (widget, marker)
	Managers.event:unregister(marker, "event_titles_in_mission_setting_changed")
	Managers.event:unregister(marker, "event_in_mission_title_color_type_changed")
end

template.on_enter = function (widget, marker)
	local data = marker.data
	local content = widget.content
	local player_slot = data:slot()
	local player_slot_color = UISettings.player_slot_colors[player_slot] or Color.ui_hud_green_light(255, true)
	local color_string = "{#color(" .. player_slot_color[2] .. "," .. player_slot_color[3] .. "," .. player_slot_color[4] .. ")}"
	local header_text = color_string .. "{#reset()} " .. data:name()
	local save_data = Managers.save:account_data()
	local interface_settings = save_data.interface_settings
	local character_nameplates_in_mission_type = interface_settings.character_nameplates_in_mission_type

	if character_nameplates_in_mission_type ~= "none" then
		if character_nameplates_in_mission_type == "name_and_title" then
			local profile = data:profile()
			local title = profile and ProfileUtils.character_title(profile)

			if title then
				header_text = header_text .. " \n " .. title
			end
		end
	else
		header_text = ""
	end

	marker.cb_event_titles_in_mission_setting_changed = _cb_event_titles_in_mission_setting_changed

	Managers.event:register(marker, "event_titles_in_mission_setting_changed", "cb_event_titles_in_mission_setting_changed")
	Managers.event:register(marker, "event_in_mission_title_color_type_changed", "cb_event_titles_in_mission_setting_changed")

	content.header_text = header_text
	content.icon_text = color_string .. "{#reset()}"
end

template.update_function = function (parent, ui_renderer, widget, marker, template, dt, t)
	local content = widget.content
	local style = widget.style
	local is_inside_frustum = content.is_inside_frustum
	local distance = content.distance
	local line_of_sight_progress = content.line_of_sight_progress or 0

	if marker.raycast_initialized then
		local raycast_result = marker.raycast_result
		local line_of_sight_speed = 3

		if raycast_result then
			line_of_sight_progress = math.max(line_of_sight_progress - dt * line_of_sight_speed, 0)
		else
			line_of_sight_progress = math.min(line_of_sight_progress + dt * line_of_sight_speed, 1)
		end
	end

	local edge_clamp_speed = 2.5
	local edge_clamp_progress = content.edge_clamp_progress or 0

	if content.is_clamped then
		edge_clamp_progress = math.max(edge_clamp_progress - dt * edge_clamp_speed, 0)
	else
		edge_clamp_progress = math.min(edge_clamp_progress + dt * edge_clamp_speed, 1)
	end

	local draw = marker.draw

	if draw then
		local scale = marker.scale
		local header_text_id = "header_text"
		local header_style = style[header_text_id]
		local header_default_font_size = header_style.default_font_size

		header_style.font_size = header_style.default_font_size * scale
		content.line_of_sight_progress = line_of_sight_progress
		widget.alpha_multiplier = 1
		content.edge_clamp_progress = edge_clamp_progress

		local clamped_alpha = 255 - 255 * edge_clamp_progress

		style.icon_text.text_color[1] = distance > 15 and clamped_alpha or 0
		style.arrow.color[1] = distance > 15 and clamped_alpha or 0
	end
end

return template
