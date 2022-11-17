local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local ColorUtilities = require("scripts/utilities/ui/colors")
local template = {}
local size = {
	50,
	50
}
local arrow_size = {
	70,
	70
}
template.size = size
template.unit_node = 1
template.name = "training_grounds"
template.max_distance = math.huge
template.screen_clamp = true
template.screen_margins = {
	down = 250,
	up = 250,
	left = 450,
	right = 450
}
local template_visual_definitions = {
	default = {
		template_settings_overrides = {
			screen_clamp = true
		},
		colors = {
			frame = UIHudSettings.color_tint_main_1,
			arrow = Color.ui_hud_green_super_light(255, true),
			icon = UIHudSettings.color_tint_main_1,
			text = UIHudSettings.color_tint_main_1,
			indicator = Color.ui_hud_green_super_light(255, true),
			background = Color.terminal_background(200, true)
		},
		textures = {}
	},
	interact = {
		template_settings_overrides = {
			unit_node = "ui_interaction_marker",
			position_offset = {
				0,
				0,
				0
			},
			fade_settings = {
				fade_to = 0,
				fade_from = 1,
				default_fade = 1,
				distance_max = 4.5,
				distance_min = 3,
				easing_function = math.easeCubic
			}
		},
		colors = {},
		textures = {}
	},
	servitor = {
		template_settings_overrides = {
			unit_node = "ui_interaction_marker",
			position_offset = {
				0,
				0,
				0
			},
			fade_settings = {
				fade_to = 0,
				fade_from = 1,
				default_fade = 1,
				distance_max = 17,
				distance_min = 15,
				easing_function = math.easeCubic
			}
		},
		colors = {},
		textures = {}
	},
	enemy = {
		template_settings_overrides = {
			unit_node = "j_spine",
			position_offset = {
				0,
				0,
				0.3
			}
		},
		colors = {},
		textures = {}
	},
	portal = {
		template_settings_overrides = {
			position_offset = {
				0,
				0,
				1.8
			}
		},
		colors = {},
		textures = {}
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
	local header_font_color = UIHudSettings.color_tint_main_1
	local size = template.size

	return UIWidget.create_definition({
		{
			value_id = "icon",
			style_id = "icon",
			pass_type = "texture",
			value = "content/ui/materials/hud/interactions/icons/objective_main",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				size = size,
				offset = {
					0,
					30,
					2
				},
				color = UIHudSettings.color_tint_main_1
			},
			visibility_function = function (content, style)
				return style.color[1] > 0
			end
		},
		{
			value_id = "frame",
			style_id = "frame",
			pass_type = "texture",
			value = "content/ui/materials/hud/interactions/frames/point_of_interest_top",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				size = size,
				offset = {
					0,
					35,
					1
				},
				size_addition = {
					10,
					10
				},
				color = UIHudSettings.color_tint_main_1
			},
			visibility_function = function (content, style)
				return style.color[1] > 0
			end
		},
		{
			value_id = "background",
			style_id = "background",
			pass_type = "texture",
			value = "content/ui/materials/hud/interactions/frames/point_of_interest_back",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				size = size,
				offset = {
					0,
					35,
					0
				},
				size_addition = {
					10,
					10
				},
				color = {
					200,
					0,
					0,
					0
				}
			},
			visibility_function = function (content, style)
				return style.color[1] > 0
			end
		},
		{
			value_id = "arrow",
			pass_type = "rotated_texture",
			value = "content/ui/materials/hud/interactions/frames/direction",
			style_id = "arrow",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				size = arrow_size,
				offset = {
					0,
					40,
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
	local style = widget.style
	local is_inside_frustum = content.is_inside_frustum
	marker.block_fade_settings = not is_inside_frustum
	local data = marker.data
	local ui_target_type = data.ui_target_type or "default"
	local distance = content.distance

	if ui_target_type and marker.ui_target_type ~= ui_target_type then
		setup_marker_by_visual_type(widget, marker, ui_target_type)

		marker.ui_target_type = ui_target_type
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
