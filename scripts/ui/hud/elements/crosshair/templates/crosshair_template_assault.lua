﻿-- chunkname: @scripts/ui/hud/elements/crosshair/templates/crosshair_template_assault.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local template = {}
local length = 8
local thickness = 6
local size = {
	length,
	thickness,
}
local center_size = {
	4,
	4,
}
local spread_distance = 15
local default_offset_x = 15
local default_offset_y = -15
local hit_default_distance = 10
local hit_size = {
	12,
	2,
}

template.name = "assault"
template.size = size
template.hit_size = hit_size
template.center_size = center_size
template.spread_distance = spread_distance
template.hit_default_distance = hit_default_distance

local function apply_color_values(destination_color, target_color, include_alpha, optional_alpha)
	if include_alpha then
		destination_color[1] = target_color[1]
	end

	if optional_alpha then
		destination_color[1] = optional_alpha
	end

	destination_color[2] = target_color[2]
	destination_color[3] = target_color[3]
	destination_color[4] = target_color[4]

	return destination_color
end

template.create_widget_defintion = function (template, scenegraph_id)
	local size = template.size
	local center_size = template.center_size
	local center_half_width = center_size[1] * 0.5
	local hit_size = template.hit_size
	local hit_default_distance = template.hit_default_distance
	local offset_up = {
		0,
		-(size[1] * 2 + center_half_width),
		1,
	}
	local offset_down = {
		0,
		size[1] + center_half_width,
		1,
	}
	local offset_left = {
		-(size[1] * 2 + center_half_width),
		0,
		1,
	}
	local offset_right = {
		size[1] + center_half_width,
		0,
		1,
	}

	return UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "center",
			value = "content/ui/materials/hud/crosshairs/default_center",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					0,
				},
				size = center_size,
				color = UIHudSettings.color_tint_main_1,
			},
		},
		{
			pass_type = "rotated_texture",
			style_id = "hit_top_left",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				offset = {
					-center_half_width - hit_default_distance,
					-center_half_width - hit_default_distance,
					0,
				},
				size = {
					hit_size[1],
					hit_size[2],
				},
				pivot = {
					hit_size[1],
					hit_size[2] * 0.5,
				},
				angle = -math.pi / 4,
				color = {
					255,
					255,
					255,
					0,
				},
			},
		},
		{
			pass_type = "rotated_texture",
			style_id = "hit_bottom_left",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				offset = {
					-center_half_width - hit_default_distance,
					center_half_width + hit_default_distance,
					0,
				},
				size = {
					hit_size[1],
					hit_size[2],
				},
				pivot = {
					hit_size[1],
					hit_size[2] * 0.5,
				},
				angle = math.pi / 4,
				color = {
					255,
					255,
					255,
					0,
				},
			},
		},
		{
			pass_type = "rotated_texture",
			style_id = "hit_top_right",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					center_half_width + hit_default_distance,
					-center_half_width - hit_default_distance,
					0,
				},
				size = {
					hit_size[1],
					hit_size[2],
				},
				pivot = {
					0,
					hit_size[2] * 0.5,
				},
				angle = math.pi / 4,
				color = {
					255,
					255,
					255,
					0,
				},
			},
		},
		{
			pass_type = "rotated_texture",
			style_id = "hit_bottom_right",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					center_half_width + hit_default_distance,
					center_half_width + hit_default_distance,
					0,
				},
				size = {
					hit_size[1],
					hit_size[2],
				},
				pivot = {
					0,
					hit_size[2] * 0.5,
				},
				angle = -math.pi / 4,
				color = {
					255,
					255,
					255,
					0,
				},
			},
		},
		{
			pass_type = "rotated_texture",
			style_id = "up",
			value = "content/ui/materials/hud/crosshairs/arrow_top",
			style = {
				horizontal_alignment = "center",
				offset = offset_up,
				default_offset = offset_up,
				size = {
					size[2],
					size[1],
				},
				color = UIHudSettings.color_tint_main_1,
			},
		},
		{
			pass_type = "rotated_texture",
			style_id = "bottom_left",
			value = "content/ui/materials/hud/crosshairs/arrow_top",
			style = {
				horizontal_alignment = "center",
				angle = math.rad(120),
				offset = offset_down,
				default_offset = offset_down,
				size = {
					size[2],
					size[1],
				},
				color = UIHudSettings.color_tint_main_1,
			},
		},
		{
			pass_type = "rotated_texture",
			style_id = "bottom_right",
			value = "content/ui/materials/hud/crosshairs/arrow_top",
			style = {
				horizontal_alignment = "center",
				angle = math.rad(240),
				offset = offset_down,
				default_offset = offset_down,
				size = {
					size[2],
					size[1],
				},
				color = UIHudSettings.color_tint_main_1,
			},
		},
	}, scenegraph_id)
end

template.on_enter = function (widget, template, data)
	return
end

template.update_function = function (parent, ui_renderer, widget, crosshair_template, crosshair_settings, dt, t)
	local content = widget.content
	local style = widget.style
	local hit_progress, hit_color = parent:hit_indicator()
	local yaw, pitch = parent:_spread_yaw_pitch(dt)

	if yaw and pitch then
		local spread_distance = template.spread_distance
		local spread_offset_y = spread_distance * pitch
		local spread_offset_x = spread_distance * yaw
		local up_style = style.up

		up_style.offset[2] = up_style.default_offset[2] - spread_offset_y

		local bottom_left_style = style.bottom_left

		bottom_left_style.offset[1] = bottom_left_style.default_offset[1] - default_offset_x - spread_offset_x
		bottom_left_style.offset[2] = bottom_left_style.default_offset[2] + default_offset_y + spread_offset_y

		local bottom_right_style = style.bottom_right

		bottom_right_style.offset[1] = bottom_right_style.default_offset[1] + default_offset_x + spread_offset_x
		bottom_right_style.offset[2] = bottom_right_style.default_offset[2] + default_offset_y + spread_offset_y
	end

	local hit_alpha = (hit_progress or 0) * 255

	if hit_alpha > 0 then
		local top_left_style = style.hit_top_left

		top_left_style.color = apply_color_values(top_left_style.color, hit_color or top_left_style.color, false, hit_alpha)
		top_left_style.visible = true

		local bottom_left_style = style.hit_bottom_left

		bottom_left_style.color = apply_color_values(bottom_left_style.color, hit_color or bottom_left_style.color, false, hit_alpha)
		bottom_left_style.visible = true

		local top_right_style = style.hit_top_right

		top_right_style.color = apply_color_values(top_right_style.color, hit_color or top_right_style.color, false, hit_alpha)
		top_right_style.visible = true

		local bottom_right_style = style.hit_bottom_right

		bottom_right_style.color = apply_color_values(bottom_right_style.color, hit_color or bottom_right_style.color, false, hit_alpha)
		bottom_right_style.visible = true
	else
		style.hit_top_left.visible = false
		style.hit_bottom_left.visible = false
		style.hit_top_right.visible = false
		style.hit_bottom_right.visible = false
	end
end

return template
