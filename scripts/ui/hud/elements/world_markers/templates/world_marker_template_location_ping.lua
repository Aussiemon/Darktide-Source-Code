local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UISettings = require("scripts/settings/ui/ui_settings")
local template = {}
local size = {
	100,
	100
}
local arrow_size = {
	100,
	100
}
local icon_size = {
	64,
	64
}
template.size = size
template.name = "location_ping"
template.using_smart_tag_system = true
template.max_distance = 200
template.screen_clamp = true
template.screen_margins = {
	down = 250,
	up = 250,
	left = 450,
	right = 450
}
template.scale_settings = {
	scale_to = 1,
	scale_from = 0.5,
	distance_max = 50,
	distance_min = 5
}

template.get_smart_tag_id = function (marker)
	local data = marker.data

	return data.tag_id
end

template.create_widget_defintion = function (template, scenegraph_id)
	local header_font_setting_name = "hud_body"
	local header_font_settings = UIFontSettings[header_font_setting_name]
	local header_font_color = Color.ui_hud_green_super_light(255, true)
	local size = template.size

	return UIWidget.create_definition({
		{
			style_id = "icon",
			value_id = "icon",
			pass_type = "texture",
			value = "content/ui/materials/hud/interactions/icons/location",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = icon_size,
				default_size = icon_size,
				offset = {
					0,
					-10,
					1
				},
				color = Color.ui_hud_green_super_light(255, true)
			},
			visibility_function = function (content, style)
				return content.icon ~= nil
			end
		},
		{
			style_id = "entry_icon_1",
			pass_type = "texture",
			value_id = "icon",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				default_size = {
					icon_size[1] * 1.25,
					icon_size[2] * 1.25
				},
				size = {
					icon_size[1],
					icon_size[2]
				},
				offset = {
					0,
					-10,
					0
				},
				color = Color.ui_hud_green_medium(255, true)
			},
			visibility_function = function (content, style)
				return content.icon ~= nil
			end
		},
		{
			style_id = "entry_icon_2",
			value_id = "2",
			pass_type = "texture",
			value = "content/ui/materials/hud/interactions/frames/pulse_effect",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				default_size = {
					icon_size[1] * 1,
					icon_size[2] * 1
				},
				size = {
					icon_size[1],
					icon_size[2]
				},
				offset = {
					0,
					-10,
					0
				},
				color = Color.ui_hud_green_super_light(255, true)
			},
			visibility_function = function (content, style)
				return content.icon ~= nil
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
					-10,
					1
				},
				color = Color.ui_hud_green_super_light(255, true)
			},
			visibility_function = function (content, style)
				return content.is_clamped
			end,
			change_function = function (content, style)
				style.angle = content.angle
			end
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
				return content.distance >= 5 and (content.is_hovered or content.is_clamped)
			end
		}
	}, scenegraph_id)
end

template.on_enter = function (widget, marker, template)
	local content = widget.content
	content.spawn_progress_timer = 0
	local data = marker.data
	local player = data.player
	local tag_instance = data.tag_instance
	local tagger_player = tag_instance and tag_instance:tagger_player()
	local player_slot = (tagger_player or player):slot()
	local player_slot_color = UISettings.player_slot_colors[player_slot] or Color.ui_hud_green_light(255, true)
	local style = widget.style
	style.icon.color = table.clone(player_slot_color)
	style.entry_icon_1.color = table.clone(player_slot_color)
	style.entry_icon_2.color = table.clone(player_slot_color)
end

template.update_function = function (parent, ui_renderer, widget, marker, template, dt, t)
	local animating = false
	local content = widget.content
	local style = widget.style
	local distance = content.distance
	local data = marker.data

	if data then
		data.distance = distance
	end

	local is_hovered = data.is_hovered
	local anim_hover_speed = 3

	if anim_hover_speed then
		local anim_hover_progress = content.anim_hover_progress or 0

		if is_hovered then
			anim_hover_progress = math.min(anim_hover_progress + dt * anim_hover_speed, 1)
		else
			anim_hover_progress = math.max(anim_hover_progress - dt * anim_hover_speed, 0)
		end

		content.anim_hover_progress = anim_hover_progress
	end

	local spawn_progress_timer = content.spawn_progress_timer

	if spawn_progress_timer then
		spawn_progress_timer = spawn_progress_timer + dt
		local duration = 1
		local progress = math.min(spawn_progress_timer / duration, 1)
		local anim_out_progress = math.ease_out_quad(progress)
		local anim_in_progress = math.ease_out_exp(progress)
		content.spawn_progress_timer = progress ~= 1 and spawn_progress_timer or nil
		style.icon.color[1] = 255 * anim_in_progress
		style.arrow.color[1] = 255 * anim_in_progress
		style.text.text_color[1] = 255 * anim_in_progress
		local entry_icon_1_style = style.entry_icon_1
		local entry_icon_1_color = entry_icon_1_style.color
		local entry_icon_1_size = entry_icon_1_style.size
		local entry_icon_1_default_size = entry_icon_1_style.default_size
		entry_icon_1_size[1] = entry_icon_1_default_size[1] + entry_icon_1_default_size[1] * anim_out_progress
		entry_icon_1_size[2] = entry_icon_1_default_size[1] + entry_icon_1_default_size[2] * anim_out_progress
		entry_icon_1_color[1] = 255 - 255 * anim_out_progress
		local entry_icon_2_style = style.entry_icon_2
		local entry_icon_2_color = entry_icon_2_style.color
		local entry_icon_2_size = entry_icon_2_style.size
		local entry_icon_2_default_size = entry_icon_2_style.default_size
		entry_icon_2_size[1] = entry_icon_2_default_size[1] + entry_icon_2_default_size[1] * anim_in_progress
		entry_icon_2_size[2] = entry_icon_2_default_size[1] + entry_icon_2_default_size[2] * anim_in_progress
		entry_icon_2_color[1] = 255 - 255 * anim_in_progress

		if anim_out_progress == 1 then
			content.spawn_progress_timer = nil
		end
	end

	local alpha_multiplier = 1

	if not content.is_inside_frustum then
		local pulse_progress = Application.time_since_launch() * 1 % 1
		local pulse_anim_progress = (pulse_progress * 2 - 1)^2
		alpha_multiplier = 0.7 + pulse_anim_progress * 0.3
	end

	widget.alpha_multiplier = alpha_multiplier
	local distance_text = tostring(math.floor(distance)) .. "m"
	content.text = distance > 1 and distance_text or ""
	data.distance_text = distance_text
	marker.ignore_scale = content.is_clamped or is_hovered
	content.is_hovered = is_hovered

	return animating
end

return template
