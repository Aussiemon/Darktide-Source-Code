-- chunkname: @scripts/ui/hud/elements/world_markers/templates/world_marker_template_chat_bubble.lua

local Colors = require("scripts/utilities/ui/colors")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local Text = require("scripts/utilities/ui/text")
local ChatSettings = require("scripts/ui/constant_elements/elements/chat/constant_element_chat_settings")
local template = {}
local size = {
	600,
	100,
}

template.size = size
template.name = "chat_bubble"
template.position_offset = {
	0,
	0,
	0.2,
}
template.check_line_of_sight = true
template.max_distance = 20
template.screen_clamp = false
template.pixel_offset = {
	0,
	0,
}
template.life_time = 8
template.min_life_time = 3
template.max_life_time = 12
template.ignore_scale = true
template.scale_settings = {
	distance_max = 30,
	distance_min = 20,
	scale_from = 0.5,
	scale_to = 1,
}
template.fade_settings = {
	default_fade = 1,
	fade_from = 0,
	fade_to = 1,
	distance_max = template.max_distance,
	distance_min = template.max_distance * 0.5,
	easing_function = math.ease_exp,
}

local template_visual_definitions = {
	default = {
		template_settings_overrides = {
			fade_settings = {
				default_fade = 1,
				fade_from = 0,
				fade_to = 1,
				distance_max = template.max_distance,
				distance_min = template.max_distance * 0.5,
				easing_function = math.ease_exp,
			},
			scale_settings = {
				distance_max = 20,
				distance_min = 10,
				scale_from = 0.5,
				scale_to = 1,
			},
		},
		template_settings_overrides_by_breed = {
			human = {
				position_offset = {
					0,
					0,
					2.2,
				},
			},
			ogryn = {
				position_offset = {
					0,
					0,
					2.8,
				},
			},
		},
	},
}

local function get_interactee_unit_breed(marker)
	local marker_unit = marker.unit
	local player = Managers.player:player_by_unit(marker_unit)

	if player then
		local breed_name = player:breed_name()

		return breed_name
	end
end

local function setup_chat_bubble_by_type(widget, marker, bubble_type)
	local content = widget.content
	local style = widget.style
	local visual_definition = template_visual_definitions[bubble_type]
	local default_color = visual_definition.colors
	local default_textures = visual_definition.textures
	local template_settings_overrides = visual_definition.template_settings_overrides

	if template_settings_overrides then
		local new_template = table.clone(marker.template)

		marker.template = table.merge_recursive(new_template, template_settings_overrides)
	end

	local template_settings_overrides_by_breed = visual_definition.template_settings_overrides_by_breed

	if template_settings_overrides_by_breed then
		local breed_name = get_interactee_unit_breed(marker)
		local override_settings = breed_name and template_settings_overrides_by_breed[breed_name]

		if override_settings then
			local new_template = table.clone(marker.template)

			marker.template = table.merge_recursive(new_template, override_settings)
		end
	end

	for style_id, pass_style in pairs(style) do
		local color = default_color and default_color[style_id]

		if color then
			Colors.color_copy(color, pass_style.color or pass_style.text_color)
		end
	end

	if default_textures then
		for content_id, value in pairs(default_textures) do
			content[content_id] = value ~= StrictNil and value or nil
		end
	end
end

template.create_widget_defintion = function (template, scenegraph_id)
	local header_font_setting_name = "hud_body"
	local header_font_settings = UIFontSettings[header_font_setting_name]
	local header_font_color = Color.terminal_text_header(255, true)
	local font_size = 24

	return UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "<text>",
			value_id = "text",
			style = {
				horizontal_alignment = "center",
				text_horizontal_alignment = "left",
				text_vertical_alignment = "center",
				vertical_alignment = "bottom",
				size = size,
				offset = {
					5,
					-5,
					2,
				},
				size_addition = {
					-10,
					-10,
				},
				font_type = header_font_settings.font_type,
				font_size = font_size,
				default_font_size = font_size,
				text_color = header_font_color,
				default_text_color = header_font_color,
			},
		},
		{
			pass_type = "rect",
			style_id = "window_background",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = size,
				color = {
					180,
					0,
					0,
					0,
				},
				offset = {
					0,
					0,
					1,
				},
				size_addition = {
					0,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "outer_shadow",
			value = "content/ui/materials/frames/dropshadow_medium",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "bottom",
				size = size,
				color = Color.white(200, true),
				size_addition = {
					20,
					20,
				},
				offset = {
					0,
					10,
					2,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "arrow",
			value = "content/ui/materials/frames/chat_bubble_arrow",
			style = {
				horizontal_alignment = "center",
				ignore_size_change = true,
				vertical_alignment = "center",
				size = {
					30,
					26,
				},
				color = Color.black(180, true),
				offset = {
					0,
					12,
					3,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "arrow_outer_shadow",
			value = "content/ui/materials/frames/chat_bubble_arrow_dropshadow_medium",
			style = {
				horizontal_alignment = "center",
				ignore_size_change = true,
				vertical_alignment = "center",
				size = {
					30,
					26,
				},
				color = Color.white(200, true),
				offset = {
					0,
					12,
					0,
				},
			},
		},
	}, scenegraph_id, nil)
end

local function _get_life_time_by_text_length(text, lifetime_multiplier)
	local text_length = Utf8.string_length(text)
	local min_duration = template.min_life_time
	local max_duration = template.max_life_time
	local max_text_length = ChatSettings.message_limit_in_characters
	local min_duration_text_length = math.floor(max_text_length * 0.1)
	local bonus_text_length = math.max(text_length - min_duration_text_length, 0)
	local bonus_text_duration = bonus_text_length / (max_text_length - min_duration_text_length) * (max_duration - min_duration)
	local duration = min_duration + bonus_text_duration
	local multiplier = tonumber(lifetime_multiplier) or 100

	multiplier = math.max(50, math.min(200, multiplier))

	return duration * (multiplier / 100)
end

local function _apply_background_opacity(widget, background_opacity)
	local clamped_opacity = tonumber(background_opacity) or 70

	clamped_opacity = math.max(0, math.min(100, clamped_opacity))

	local opacity_multiplier = clamped_opacity / 100
	local style = widget.style

	style.window_background.color[1] = math.floor(180 * opacity_multiplier + 0.5)
	style.arrow.color[1] = math.floor(180 * opacity_multiplier + 0.5)
	style.outer_shadow.color[1] = math.floor(200 * opacity_multiplier + 0.5)
	style.arrow_outer_shadow.color[1] = math.floor(200 * opacity_multiplier + 0.5)
end

local function _apply_text_size(widget, text_size)
	local clamped_text_size = tonumber(text_size) or 24

	clamped_text_size = math.max(12, math.min(72, clamped_text_size))

	local text_style = widget.style.text

	text_style.font_size = math.floor(clamped_text_size + 0.5)
end

local function _apply_text_opacity(widget, text_opacity)
	local clamped_text_opacity = tonumber(text_opacity) or 100

	clamped_text_opacity = math.max(10, math.min(100, clamped_text_opacity))

	local opacity_multiplier = clamped_text_opacity / 100
	local text_style = widget.style.text

	text_style.text_color[1] = math.floor(255 * opacity_multiplier + 0.5)
end

template.on_enter = function (widget, marker)
	local data = marker.data
	local content = widget.content
	local text = data.text or ""

	marker.template.life_time = _get_life_time_by_text_length(text, data.lifetime_multiplier)

	_apply_background_opacity(widget, data.background_opacity)
	_apply_text_size(widget, data.text_size)
	_apply_text_opacity(widget, data.text_opacity)

	content.text = text
end

local temp_text_box_size = {
	0,
	0,
}

template.update_function = function (parent, ui_renderer, widget, marker, self, dt, t)
	local content = widget.content
	local style = widget.style
	local data = marker.data
	local channel = data.channel
	local channel_tag = channel and channel.tag
	local channel_meta_data = ChatSettings.channel_metadata[channel_tag]
	local channel_color = channel_meta_data and channel_meta_data.color

	if channel_color then
		local text_style = style.text
		local text_color = text_style.text_color

		text_color[2] = channel_color[2]
		text_color[3] = channel_color[3]
		text_color[4] = channel_color[4]
	end

	local bubble_type = "default"

	if bubble_type ~= marker.bubble_type then
		setup_chat_bubble_by_type(widget, marker, bubble_type)

		marker.bubble_type = bubble_type
	end

	if not content.text_height then
		temp_text_box_size[1] = 600 + style.text.size_addition[1]
		temp_text_box_size[2] = 100 + style.text.size_addition[2]

		local text_width, text_height = Text.text_size(ui_renderer, content.text, style.text, temp_text_box_size, true)
		local box_width = math.min(math.max(text_width + 20, 10), size[1])
		local box_height = text_height + 10

		for _, pass_style in pairs(widget.style) do
			if not pass_style.ignore_size_change then
				local pass_size = pass_style.size

				if pass_size then
					pass_size[1] = box_width
					pass_size[2] = box_height
				end

				local pass_default_size = pass_style.default_size

				if pass_default_size then
					pass_default_size[1] = box_width
					pass_default_size[2] = box_height
				end
			end
		end

		content.text_height = text_height
		content.box_width = box_width
	end

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
		content.line_of_sight_progress = line_of_sight_progress
		widget.alpha_multiplier = line_of_sight_progress
	end

	marker.ignore_scale = false
end

return template
