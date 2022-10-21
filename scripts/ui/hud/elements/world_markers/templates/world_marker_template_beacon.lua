local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local template = {}
local size = {
	20,
	20
}
template.size = size
template.name = "beacon"
template.unit_node = "ui_marker"
template.max_distance = 200
template.min_distance = 0
template.screen_clamp = true
template.evolve_distance = 6
template.screen_margins = {
	up = size[2] * 0.5,
	down = size[2] * 0.5,
	left = size[1] * 0.5,
	right = size[1] * 0.5
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
	local header_font_setting_name = "button_medium"
	local header_font_settings = UIFontSettings[header_font_setting_name]
	local header_font_color = {
		255,
		255,
		255,
		255
	}
	local size = template.size

	return UIWidget.create_definition({
		{
			value = "content/ui/vector_textures/hud/circle_full",
			value_id = "default",
			pass_type = "slug_icon",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = size,
				color = {
					255,
					255,
					255,
					255
				}
			}
		},
		{
			value = "content/ui/vector_textures/hud/icon_objective_warning",
			value_id = "close",
			pass_type = "slug_icon",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = size,
				color = {
					255,
					255,
					255,
					255
				}
			}
		},
		{
			style_id = "text",
			pass_type = "text",
			value_id = "text",
			value = "MMM",
			style = {
				text_vertical_alignment = "top",
				horizontal_alignment = "center",
				text_horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					20,
					2
				},
				font_type = header_font_settings.font_type,
				font_size = header_font_settings.font_size,
				text_color = header_font_color,
				default_text_color = header_font_color,
				size = {
					200,
					20
				}
			},
			visibility_function = function (content, style)
				return content.distance >= 5
			end
		}
	}, scenegraph_id)
end

template.on_enter = function (widget)
	local content = widget.content
	content.spawn_progress_timer = 0
end

template.update_function = function (parent, ui_renderer, widget, marker, template, dt, t)
	local animating = false
	local content = widget.content
	local distance = content.distance
	local data = marker.data

	if data then
		data.distance = distance
	end

	local distance_text = tostring(math.floor(distance)) .. "m"
	content.text = distance > 1 and distance_text or ""

	return animating
end

return template
