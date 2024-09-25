-- chunkname: @scripts/ui/hud/elements/crosshair/templates/crosshair_template_charge_up.lua

local Crosshair = require("scripts/ui/utilities/crosshair")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local template = {}
local length = 24
local thickness = 56
local size = {
	length,
	thickness,
}
local mask_size = {
	length,
	thickness - 4,
}
local center_size = {
	4,
	4,
}
local spread_distance = 10
local hit_default_distance = 10
local hit_size = {
	14,
	4,
}

template.name = "charge_up"
template.size = size
template.hit_size = hit_size
template.center_size = center_size
template.spread_distance = spread_distance
template.hit_default_distance = hit_default_distance

template.create_widget_defintion = function (template, scenegraph_id)
	local center_half_width = center_size[1] * 0.5
	local offset_charge = 30
	local offset_charge_right = {
		offset_charge + center_half_width,
		0,
		1,
	}
	local offset_charge_mask_right = {
		offset_charge + center_half_width,
		0,
		2,
	}
	local offset_charge_left = {
		-(offset_charge + center_half_width),
		0,
		1,
	}
	local offset_charge_mask_left = {
		-(offset_charge + center_half_width),
		0,
		2,
	}

	return UIWidget.create_definition({
		Crosshair.center_dot(),
		Crosshair.hit_indicator_segment("top_left"),
		Crosshair.hit_indicator_segment("bottom_left"),
		Crosshair.hit_indicator_segment("top_right"),
		Crosshair.hit_indicator_segment("bottom_right"),
		Crosshair.weakspot_hit_indicator_segment("top_left"),
		Crosshair.weakspot_hit_indicator_segment("bottom_left"),
		Crosshair.weakspot_hit_indicator_segment("top_right"),
		Crosshair.weakspot_hit_indicator_segment("bottom_right"),
		{
			pass_type = "texture_uv",
			style_id = "charge_left",
			value = "content/ui/materials/hud/crosshairs/charge_up",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				uvs = {
					{
						1,
						0,
					},
					{
						0,
						1,
					},
				},
				offset = offset_charge_left,
				size = {
					size[1],
					size[2],
				},
				color = UIHudSettings.color_tint_main_1,
			},
		},
		{
			pass_type = "texture",
			style_id = "charge_right",
			value = "content/ui/materials/hud/crosshairs/charge_up",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = offset_charge_right,
				size = {
					size[1],
					size[2],
				},
				color = UIHudSettings.color_tint_main_1,
			},
		},
		{
			pass_type = "texture_uv",
			style_id = "charge_mask_left",
			value = "content/ui/materials/hud/crosshairs/charge_up_mask",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				uvs = {
					{
						1,
						0,
					},
					{
						0,
						1,
					},
				},
				offset = offset_charge_mask_left,
				size = mask_size,
				color = UIHudSettings.color_tint_main_1,
			},
		},
		{
			pass_type = "texture_uv",
			style_id = "charge_mask_right",
			value = "content/ui/materials/hud/crosshairs/charge_up_mask",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				uvs = {
					{
						0,
						1,
					},
					{
						1,
						0,
					},
				},
				offset = offset_charge_mask_right,
				size = mask_size,
				color = UIHudSettings.color_tint_main_1,
			},
		},
	}, scenegraph_id)
end

template.on_enter = function (widget, template, data)
	return
end

template.update_function = function (parent, ui_renderer, widget, template, crosshair_settings, dt, t, draw_hit_indicator)
	local style = widget.style
	local hit_progress, hit_color, hit_weakspot = parent:hit_indicator()
	local yaw, pitch = parent:_spread_yaw_pitch(dt)
	local charge_level = parent:_get_current_charge_level() or 0

	if yaw and pitch then
		local scalar = template.spread_distance * (crosshair_settings.spread_scalar or 1)
		local spread_offset_y = pitch * scalar
		local spread_offset_x = yaw * scalar
		local charge_left_style = style.charge_left
		local charge_mask_left_style = style.charge_mask_left
		local charge_right_style = style.charge_right
		local charge_mask_right_style = style.charge_mask_right
	end

	local mask_height = mask_size[2]
	local mask_height_charged = mask_height * charge_level
	local mask_height_offset_charged = mask_height * (1 - charge_level) * 0.5
	local charge_mask_right_style = style.charge_mask_right

	charge_mask_right_style.uvs[1][2] = charge_level
	charge_mask_right_style.size[2] = mask_height_charged
	charge_mask_right_style.offset[2] = mask_height_offset_charged

	local charge_mask_left_style = style.charge_mask_left

	charge_mask_left_style.uvs[1][2] = 1 - charge_level
	charge_mask_left_style.size[2] = mask_height_charged
	charge_mask_left_style.offset[2] = mask_height_offset_charged

	Crosshair.update_hit_indicator(style, hit_progress, hit_color, hit_weakspot, draw_hit_indicator)
end

return template
