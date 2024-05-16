-- chunkname: @scripts/ui/hud/elements/world_markers/templates/world_marker_template_objective_hub.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local ColorUtilities = require("scripts/utilities/ui/colors")
local template = {}
local size = {
	50,
	50,
}
local arrow_size = {
	70,
	70,
}
local indicator_size = {
	16,
	28,
}

template.size = size
template.unit_node = "ui_objective_marker"
template.position_offset = {
	0,
	0,
	0.3,
}
template.name = "hub_objective"
template.max_distance = 300
template.screen_clamp = true
template.screen_margins = {
	down = 0.23148148148148148,
	left = 0.234375,
	right = 0.234375,
	up = 0.23148148148148148,
}
template.fade_settings = {
	default_fade = 1,
	distance_max = 16,
	distance_min = 14,
	fade_from = 0,
	fade_to = 1,
	invert = true,
	easing_function = math.ease_exp,
}

local template_visual_definitions = {
	default = {
		template_settings_overrides = {
			screen_clamp = true,
			position_offset = {
				0,
				0,
				0,
			},
		},
		colors = {
			frame = UIHudSettings.color_tint_main_1,
			arrow = Color.ui_hud_green_super_light(255, true),
			icon = UIHudSettings.color_tint_main_1,
			text = UIHudSettings.color_tint_main_1,
			indicator = Color.ui_hud_green_super_light(255, true),
			background = Color.terminal_background(200, true),
			demolition_marker_1 = {
				0,
				0,
				0,
				0,
			},
			demolition_marker_2 = {
				0,
				0,
				0,
				0,
			},
			demolition_marker_3 = {
				0,
				0,
				0,
				0,
			},
			demolition_marker_shadow_1 = {
				0,
				0,
				0,
				0,
			},
			demolition_marker_shadow_2 = {
				0,
				0,
				0,
				0,
			},
			demolition_marker_shadow_3 = {
				0,
				0,
				0,
				0,
			},
		},
		textures = {},
	},
	demolition = {
		template_settings_overrides = {
			screen_clamp = false,
			unit_node = "ui_objective_marker",
			position_offset = {
				0,
				0,
				0,
			},
			scale_settings = {
				distance_max = 30,
				distance_min = 2,
				scale_from = 0.5,
				scale_to = 1,
			},
		},
		colors = {
			frame = {
				0,
				0,
				0,
				0,
			},
			arrow = {
				0,
				0,
				0,
				0,
			},
			icon = {
				0,
				0,
				0,
				0,
			},
			text = {
				0,
				0,
				0,
				0,
			},
			background = {
				0,
				0,
				0,
				0,
			},
			indicator = {
				0,
				0,
				0,
				0,
			},
			demolition_marker_1 = Color.ui_terminal(255, true),
			demolition_marker_2 = Color.ui_terminal(255, true),
			demolition_marker_3 = Color.ui_terminal(255, true),
			demolition_marker_shadow_1 = {
				200,
				0,
				0,
				0,
			},
			demolition_marker_shadow_2 = {
				200,
				0,
				0,
				0,
			},
			demolition_marker_shadow_3 = {
				200,
				0,
				0,
				0,
			},
		},
		textures = {},
	},
	corruptor = {
		template_settings_overrides = {
			screen_clamp = false,
			position_offset = {
				0,
				0,
				0,
			},
		},
		colors = {
			frame = {
				0,
				0,
				0,
				0,
			},
			arrow = {
				0,
				0,
				0,
				0,
			},
			icon = {
				0,
				0,
				0,
				0,
			},
			text = {
				0,
				0,
				0,
				0,
			},
			background = {
				0,
				0,
				0,
				0,
			},
			indicator = {
				0,
				0,
				0,
				0,
			},
			demolition_marker_1 = Color.ui_terminal_highlight(255, true),
			demolition_marker_2 = Color.ui_terminal_highlight(255, true),
			demolition_marker_3 = Color.ui_terminal_highlight(255, true),
			demolition_marker_shadow_1 = {
				200,
				0,
				0,
				0,
			},
			demolition_marker_shadow_2 = {
				200,
				0,
				0,
				0,
			},
			demolition_marker_shadow_3 = {
				200,
				0,
				0,
				0,
			},
		},
		textures = {},
	},
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

local demolition_center_distance = 70
local demolition_marker_size = {
	46,
	26,
}
local demolition_marker_style = {
	angle = 0,
	horizontal_alignment = "right",
	vertical_alignment = "center",
	offset = {
		-demolition_center_distance,
		0,
		1,
	},
	default_offset = {
		-demolition_center_distance,
		0,
		1,
	},
	size = demolition_marker_size,
	default_size = demolition_marker_size,
	pivot = {
		demolition_marker_size[1] + demolition_center_distance,
		demolition_marker_size[2] * 0.5,
	},
	default_pivot = {
		demolition_marker_size[1] + demolition_center_distance,
		demolition_marker_size[2] * 0.5,
	},
	color = Color.ui_terminal_highlight(0, true),
}
local demolition_marker_shadow_style = {
	angle = 0,
	horizontal_alignment = "right",
	vertical_alignment = "center",
	offset = {
		-demolition_center_distance,
		0,
		0,
	},
	default_offset = {
		-demolition_center_distance,
		0,
		0,
	},
	size = demolition_marker_size,
	default_size = demolition_marker_size,
	pivot = {
		demolition_marker_size[1] + demolition_center_distance,
		demolition_marker_size[2] * 0.5,
	},
	default_pivot = {
		demolition_marker_size[1] + demolition_center_distance,
		demolition_marker_size[2] * 0.5,
	},
	color = {
		0,
		0,
		0,
		0,
	},
}

template.create_widget_defintion = function (template, scenegraph_id)
	local header_font_setting_name = "hud_body"
	local header_font_settings = UIFontSettings[header_font_setting_name]
	local header_font_color = UIHudSettings.color_tint_main_1
	local size = template.size

	return UIWidget.create_definition({
		{
			pass_type = "rotated_texture",
			style_id = "demolition_marker_1",
			value = "content/ui/materials/hud/icons/objective_demolition/demolition_indicator_pointer",
			style = demolition_marker_style,
			visibility_function = function (content, style)
				return style.color[1] > 0
			end,
		},
		{
			pass_type = "rotated_texture",
			style_id = "demolition_marker_2",
			value = "content/ui/materials/hud/icons/objective_demolition/demolition_indicator_pointer",
			style = demolition_marker_style,
			visibility_function = function (content, style)
				return style.color[1] > 0
			end,
		},
		{
			pass_type = "rotated_texture",
			style_id = "demolition_marker_3",
			value = "content/ui/materials/hud/icons/objective_demolition/demolition_indicator_pointer",
			style = demolition_marker_style,
			visibility_function = function (content, style)
				return style.color[1] > 0
			end,
		},
		{
			pass_type = "rotated_texture",
			style_id = "demolition_marker_shadow_1",
			value = "content/ui/materials/hud/icons/objective_demolition/demolition_indicator_pointer_glow",
			style = demolition_marker_shadow_style,
			visibility_function = function (content, style)
				return style.color[1] > 0
			end,
		},
		{
			pass_type = "rotated_texture",
			style_id = "demolition_marker_shadow_2",
			value = "content/ui/materials/hud/icons/objective_demolition/demolition_indicator_pointer_glow",
			style = demolition_marker_shadow_style,
			visibility_function = function (content, style)
				return style.color[1] > 0
			end,
		},
		{
			pass_type = "rotated_texture",
			style_id = "demolition_marker_shadow_3",
			value = "content/ui/materials/hud/icons/objective_demolition/demolition_indicator_pointer_glow",
			style = demolition_marker_shadow_style,
			visibility_function = function (content, style)
				return style.color[1] > 0
			end,
		},
		{
			pass_type = "texture",
			style_id = "icon",
			value = "content/ui/materials/hud/interactions/icons/objective_main",
			value_id = "icon",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = size,
				offset = {
					0,
					0,
					2,
				},
				color = UIHudSettings.color_tint_main_1,
			},
			visibility_function = function (content, style)
				return style.color[1] > 0
			end,
		},
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/hud/interactions/frames/point_of_interest_top",
			value_id = "frame",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = size,
				offset = {
					0,
					0,
					1,
				},
				size_addition = {
					10,
					10,
				},
				color = UIHudSettings.color_tint_main_1,
			},
			visibility_function = function (content, style)
				return style.color[1] > 0
			end,
		},
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/hud/interactions/frames/point_of_interest_back",
			value_id = "background",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = size,
				offset = {
					0,
					0,
					0,
				},
				size_addition = {
					10,
					10,
				},
				color = {
					200,
					0,
					0,
					0,
				},
			},
			visibility_function = function (content, style)
				return style.color[1] > 0
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
					1,
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

template.on_enter = function (widget)
	local content = widget.content

	content.spawn_progress_timer = 0
end

template.update_function = function (parent, ui_renderer, widget, marker, template, dt, t)
	local animating = false
	local content = widget.content
	local style = widget.style
	local data = marker.data
	local ui_target_type = data.ui_target_type or "default"
	local distance = content.distance

	if ui_target_type and marker.ui_target_type ~= ui_target_type then
		setup_marker_by_visual_type(widget, marker, ui_target_type)

		marker.ui_target_type = ui_target_type
	end

	if ui_target_type == "demolition" or ui_target_type == "corruptor" then
		local scale = marker.scale or 1
		local offset_distance_progress = math.ease_in_exp((scale - 0.5) / 0.5)
		local offset_distance = demolition_center_distance + demolition_center_distance * offset_distance_progress * 2
		local rotation_speed = 1
		local pulse_speed = 4
		local time_since_launch = Application.time_since_launch()
		local pulse_progress = 0.5 + math.sin(time_since_launch * pulse_speed) * 0.5
		local angle = time_since_launch * rotation_speed % math.pi * 2
		local third_lap = math.pi * 2 / 3
		local start_offset = -math.pi * 0.25

		style.demolition_marker_1.angle = start_offset + (third_lap * 4 + angle)
		style.demolition_marker_2.angle = start_offset + (third_lap * 3 + angle)
		style.demolition_marker_3.angle = start_offset + (third_lap * 2 + angle)
		style.demolition_marker_shadow_1.angle = style.demolition_marker_1.angle
		style.demolition_marker_shadow_2.angle = style.demolition_marker_2.angle
		style.demolition_marker_shadow_3.angle = style.demolition_marker_3.angle

		local width_distance_offset = offset_distance + offset_distance * 0.25 * pulse_progress

		style.demolition_marker_1.default_offset[1] = width_distance_offset
		style.demolition_marker_2.default_offset[1] = width_distance_offset
		style.demolition_marker_3.default_offset[1] = width_distance_offset
		style.demolition_marker_shadow_1.default_offset[1] = width_distance_offset
		style.demolition_marker_shadow_2.default_offset[1] = width_distance_offset
		style.demolition_marker_shadow_3.default_offset[1] = width_distance_offset
		style.demolition_marker_1.default_pivot[1] = demolition_marker_size[1] - width_distance_offset
		style.demolition_marker_2.default_pivot[1] = demolition_marker_size[1] - width_distance_offset
		style.demolition_marker_3.default_pivot[1] = demolition_marker_size[1] - width_distance_offset
		style.demolition_marker_shadow_1.default_pivot[1] = style.demolition_marker_1.default_pivot[1]
		style.demolition_marker_shadow_2.default_pivot[1] = style.demolition_marker_2.default_pivot[1]
		style.demolition_marker_shadow_3.default_pivot[1] = style.demolition_marker_3.default_pivot[1]
	end

	local distance_text = tostring(math.floor(distance)) .. "m"

	content.text = distance > 1 and distance_text or ""

	local unit = marker.unit
	local hud_element = data.hud_element

	if hud_element then
		hud_element._distance = distance
		hud_element._marker_distances[unit] = distance
	end

	return animating
end

return template
