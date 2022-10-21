local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local template = {}
local size = {
	400,
	20
}
template.size = size
template.name = "nameplate"
template.unit_node = "j_head"
template.position_offset = {
	0,
	0,
	0.4
}
template.check_line_of_sight = true
template.max_distance = 15
template.screen_clamp = false
template.scale_settings = {
	scale_to = 1,
	scale_from = 0.5,
	distance_max = 20,
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
	local header_font_color = Color.ui_hud_green_light(255, true)

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
				font_type = header_font_settings.font_type,
				font_size = header_font_settings.font_size,
				default_font_size = header_font_settings.font_size,
				text_color = header_font_color,
				default_text_color = header_font_color,
				size = size
			}
		}
	}, scenegraph_id)
end

template.on_enter = function (widget, marker)
	local data = marker.data
	local content = widget.content
	content.header_text = data:name()
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

	local draw = marker.draw

	if draw then
		local scale = marker.scale
		local header_text_id = "header_text"
		local header_style = style[header_text_id]
		local header_default_font_size = header_style.default_font_size
		header_style.font_size = header_style.default_font_size * scale
		content.line_of_sight_progress = line_of_sight_progress
		widget.alpha_multiplier = line_of_sight_progress
	end
end

return template
