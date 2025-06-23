-- chunkname: @scripts/ui/hud/elements/world_markers/templates/world_marker_template_nameplate_companion_hub.lua

local ProfileUtils = require("scripts/utilities/profile_utils")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISettings = require("scripts/settings/ui/ui_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local template = {}
local size = {
	400,
	20
}
local arrow_size = {
	60,
	60
}
local icon_size = {
	128,
	128
}
local companion_glyph = ""

template.size = size
template.name = "nameplate_companion_hub"
template.unit_node = "companion_name"
template.position_offset = {
	0,
	0,
	0
}
template.check_line_of_sight = false
template.max_distance = 15
template.screen_clamp = true
template.screen_margins = {
	down = 0.09259259259259259,
	up = 0.09259259259259259,
	left = 0.052083333333333336,
	right = 0.052083333333333336
}
template.scale_settings = {
	scale_to = 1,
	scale_from = 0.8,
	distance_max = 100,
	distance_min = 10
}
template.fade_settings = {
	fade_to = 1,
	fade_from = 0,
	default_fade = 1,
	distance_max = template.max_distance,
	distance_min = template.max_distance * 0.5,
	easing_function = math.ease_exp
}

template.create_widget_defintion = function (template, scenegraph_id)
	local size = template.size
	local header_font_setting_name = "hud_body"
	local header_font_settings = UIFontSettings[header_font_setting_name]
	local header_font_color = header_font_settings.text_color

	return UIWidget.create_definition({
		{
			style_id = "header_text",
			pass_type = "text",
			value_id = "header_text",
			value = "<header_text>",
			style = {
				horizontal_alignment = "center",
				text_vertical_alignment = "center",
				text_horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					2
				},
				text_color = header_font_color,
				font_type = header_font_settings.font_type,
				font_size = header_font_settings.font_size,
				default_font_size = header_font_settings.font_size,
				default_text_color = header_font_color,
				size = size
			},
			visibility_function = function (content, style)
				return not content.is_clamped
			end
		},
		{
			style_id = "icon_text",
			pass_type = "text",
			value_id = "icon_text",
			value = "<icon_text>",
			style = {
				font_size = 32,
				horizontal_alignment = "center",
				text_vertical_alignment = "center",
				text_horizontal_alignment = "center",
				vertical_alignment = "center",
				drop_shadow = false,
				offset = {
					0,
					-3,
					2
				},
				font_type = header_font_settings.font_type,
				default_font_size = header_font_settings.font_size,
				text_color = header_font_color,
				default_text_color = header_font_color,
				size = icon_size
			},
			visibility_function = function (content, style)
				return content.is_clamped
			end
		},
		{
			value_id = "arrow",
			pass_type = "rotated_texture",
			value = "content/ui/materials/hud/interactions/frames/direction",
			style_id = "arrow",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = arrow_size,
				offset = {
					0,
					0,
					5
				},
				color = Color.ui_hud_green_super_light(255, true)
			},
			visibility_function = function (content, style)
				return content.is_clamped
			end,
			change_function = function (content, style)
				style.angle = content.angle
			end
		}
	}, scenegraph_id)
end

local function _should_show_nameplate(player, option_type)
	local player_deleted = player and player.__deleted
	local is_local_player = not player_deleted and player:peer_id() == Network.peer_id()
	local show_nameplate = option_type == "all" or option_type == "mine_only" and is_local_player

	return not player_deleted and show_nameplate
end

local function _get_color_string(data)
	local player_slot = data:slot()
	local player_slot_color = UISettings.player_slot_colors[player_slot] or Color.ui_hud_green_light(255, true)
	local color_string = "{#color(" .. player_slot_color[2] .. "," .. player_slot_color[3] .. "," .. player_slot_color[4] .. ")}"

	return color_string
end

local function _generate_header_text(data, show_header)
	if not show_header then
		return ""
	end

	local color_string = _get_color_string(data)
	local is_player_blocked = data.is_player_blocked and data:is_player_blocked() or false
	local companion_name = data:companion_name() or "<Missing Name>"
	local companion_name_text = not is_player_blocked and companion_name or Localize("loc_blocking_player")
	local companion_text = color_string .. companion_glyph .. "{#reset()} " .. companion_name_text
	local header_text = show_header and companion_text or ""

	return header_text
end

local function _cb_companion_interface_settings_changed(self, option_type)
	local marker = self
	local data = marker.data
	local show_nameplate = _should_show_nameplate(data, option_type)
	local header_text = _generate_header_text(data, show_nameplate)
	local widget = marker.widget
	local content = widget.content

	content.header_text = header_text
end

local function _cb_update_companion_name(self)
	local marker = self
	local data = marker.data
	local save_data = Managers.save:account_data()
	local interface_settings = save_data.interface_settings
	local companion_nameplate_in_hub_type = interface_settings.companion_nameplate_in_hub_type
	local show_nameplate = _should_show_nameplate(data, companion_nameplate_in_hub_type)
	local header_text = _generate_header_text(data, show_nameplate)
	local widget = marker.widget
	local content = widget.content

	content.header_text = header_text
end

template.on_exit = function (widget, marker)
	Managers.event:unregister(marker, "event_companion_nameplate_in_hub_setting_changed")
	Managers.event:unregister(marker, "event_update_player_name")
end

template.on_enter = function (widget, marker)
	local data = marker.data
	local content = widget.content
	local save_data = Managers.save:account_data()
	local interface_settings = save_data.interface_settings
	local companion_nameplate_in_hub_type = interface_settings.companion_nameplate_in_hub_type
	local show_nameplate = _should_show_nameplate(data, companion_nameplate_in_hub_type)
	local header_text = _generate_header_text(data, show_nameplate)
	local color_string = _get_color_string(data)

	marker.cb_companion_interface_settings_changed = _cb_companion_interface_settings_changed
	marker.cb_update_companion_name = _cb_update_companion_name

	Managers.event:register(marker, "event_companion_nameplate_in_hub_setting_changed", "cb_companion_interface_settings_changed")
	Managers.event:register(marker, "event_update_player_name", "cb_update_companion_name")

	content.header_text = header_text
	content.icon_text = color_string .. companion_glyph .. "{#reset()}"
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
		local directional_icon_distance = 0

		style.icon_text.text_color[1] = directional_icon_distance < distance and clamped_alpha or 0
		style.arrow.color[1] = directional_icon_distance < distance and clamped_alpha or 0
	end
end

return template
