-- chunkname: @scripts/ui/hud/elements/world_markers/templates/world_marker_template_unit_threat.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ColorUtilities = require("scripts/utilities/ui/colors")
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

template.default_visual_type = "default"
template.using_smart_tag_system = true
template.size = size
template.name = "unit_threat"
template.unit_node = "j_head"
template.position_offset = {
	0,
	0,
	0.8
}
template.check_line_of_sight = false
template.max_distance = 200
template.screen_clamp = true
template.screen_margins = {
	down = 0.23148148148148148,
	up = 0.23148148148148148,
	left = 0.234375,
	right = 0.234375
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

local template_visual_definitions = {
	default = {
		colors = {
			arrow = Color.ui_hud_red_light(255, true),
			icon = Color.ui_hud_red_light(255, true),
			text = Color.ui_hud_red_light(255, true),
			entry_icon_1 = Color.ui_hud_red_light(255, true),
			entry_icon_2 = Color.ui_hud_red_light(255, true)
		},
		textures = {
			arrow = "content/ui/materials/hud/interactions/frames/direction",
			icon = "content/ui/materials/hud/interactions/icons/enemy"
		}
	},
	passive = {
		colors = {
			arrow = {
				255,
				236,
				165,
				50
			},
			icon = {
				255,
				236,
				165,
				50
			},
			text = {
				255,
				236,
				165,
				50
			},
			entry_icon_1 = {
				255,
				236,
				165,
				50
			},
			entry_icon_2 = {
				255,
				236,
				165,
				50
			}
		},
		textures = {
			arrow = "content/ui/materials/hud/interactions/frames/direction",
			icon = "content/ui/materials/hud/interactions/icons/attention"
		}
	}
}

local function setup_marker_by_visual_type(widget, marker, visual_type)
	local content = widget.content
	local style = widget.style
	local visual_definition = template_visual_definitions[visual_type]
	local default_color = visual_definition.colors
	local default_textures = visual_definition.textures
	local template_settings_overrides = visual_definition.template_settings_overrides

	if template_settings_overrides then
		local new_template = table.clone(marker.template)

		marker.template = table.merge_recursive(new_template, template_settings_overrides)
	end

	for style_id, pass_style in pairs(style) do
		local color = default_color[style_id]

		if color then
			ColorUtilities.color_copy(color, pass_style.color or pass_style.text_color)
		end
	end

	for content_id, value in pairs(default_textures) do
		content[content_id] = value ~= StrictNil and value or nil
	end

	marker.template.default_position_offset = marker.template.position_offset
end

template.create_widget_defintion = function (template, scenegraph_id)
	local header_font_setting_name = "hud_body"
	local header_font_settings = UIFontSettings[header_font_setting_name]
	local header_font_color = Color.ui_hud_red_light(255, true)

	return UIWidget.create_definition({
		{
			style_id = "icon",
			value_id = "icon",
			pass_type = "texture",
			value = "content/ui/materials/hud/interactions/icons/enemy",
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
				color = Color.ui_hud_red_light(255, true)
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
				color = Color.ui_hud_red_medium(255, true)
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
				color = Color.ui_hud_red_light(255, true)
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
					0,
					1
				},
				color = Color.ui_hud_red_light(255, true)
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
			value = "-",
			style = {
				horizontal_alignment = "center",
				text_vertical_alignment = "top",
				text_horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					20,
					2
				},
				default_offset = {
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
			end,
			change_function = function (content, style)
				return
			end
		}
	}, scenegraph_id)
end

template.on_enter = function (widget, marker, template)
	local content = widget.content

	content.spawn_progress_timer = 0
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

	local tag_instance = data.tag_instance
	local wanted_visual_type = data.visual_type or template.default_visual_type

	if tag_instance then
		local target_unit_outline = tag_instance:target_unit_outline()

		if target_unit_outline ~= wanted_visual_type and target_unit_outline == "smart_tagged_enemy_passive" then
			wanted_visual_type = "passive"
		end
	end

	if wanted_visual_type ~= data.visual_type then
		setup_marker_by_visual_type(widget, marker, wanted_visual_type)

		data.visual_type = wanted_visual_type
	end

	local spawn_progress_timer = content.spawn_progress_timer
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

	local is_inside_frustum = content.is_inside_frustum
	local alpha_multiplier = 1

	if not is_inside_frustum then
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
