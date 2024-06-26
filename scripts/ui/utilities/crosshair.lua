-- chunkname: @scripts/ui/utilities/crosshair.lua

local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local HudElementCrosshairSettings = require("scripts/ui/hud/elements/crosshair/hud_element_crosshair_settings")
local hit_indicator_colors = HudElementCrosshairSettings.hit_indicator_colors
local Crosshair = {}
local _apply_color_values, _hit_indicator_segment, _hit_indicator_offset, _hit_indicator_pivot, _hit_indicator_angle, _apply_hit_indicator_segment_style

Crosshair.update_hit_indicator = function (style, hit_progress, hit_color, hit_weakspot, draw_hit_indicator)
	local hit_alpha = math.ease_sine(hit_progress or 0) * 255

	if hit_alpha > 0 and draw_hit_indicator then
		local indicator_visible = not hit_weakspot
		local weakspot_indicator_visible = not not hit_weakspot

		_apply_hit_indicator_segment_style(style.hit_top_left, indicator_visible, hit_color, hit_alpha)
		_apply_hit_indicator_segment_style(style.hit_bottom_left, indicator_visible, hit_color, hit_alpha)
		_apply_hit_indicator_segment_style(style.hit_top_right, indicator_visible, hit_color, hit_alpha)
		_apply_hit_indicator_segment_style(style.hit_bottom_right, indicator_visible, hit_color, hit_alpha)
		_apply_hit_indicator_segment_style(style.hit_weakspot_top_left, weakspot_indicator_visible, hit_color, hit_alpha)
		_apply_hit_indicator_segment_style(style.hit_weakspot_bottom_left, weakspot_indicator_visible, hit_color, hit_alpha)
		_apply_hit_indicator_segment_style(style.hit_weakspot_top_right, weakspot_indicator_visible, hit_color, hit_alpha)
		_apply_hit_indicator_segment_style(style.hit_weakspot_bottom_right, weakspot_indicator_visible, hit_color, hit_alpha)
	else
		style.hit_top_left.visible = false
		style.hit_bottom_left.visible = false
		style.hit_top_right.visible = false
		style.hit_bottom_right.visible = false
		style.hit_weakspot_top_left.visible = false
		style.hit_weakspot_bottom_left.visible = false
		style.hit_weakspot_top_right.visible = false
		style.hit_weakspot_bottom_right.visible = false
	end
end

Crosshair.center_dot = function ()
	return table.clone({
		pass_type = "texture",
		style_id = "center",
		value = "content/ui/materials/hud/crosshairs/center_dot",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			offset = {
				0,
				0,
				1,
			},
			size = {
				4,
				4,
			},
			color = UIHudSettings.color_tint_main_1,
		},
	})
end

Crosshair.hit_indicator_segment = function (position_name)
	local style_id = string.format("hit_%s", position_name)
	local texture = "content/ui/materials/hud/crosshairs/hit_marker"
	local hit_size = {
		15,
		3,
	}
	local center_size = 4
	local hit_marker_distance = 10

	return _hit_indicator_segment(style_id, texture, hit_size, center_size, hit_marker_distance, position_name)
end

Crosshair.weakspot_hit_indicator_segment = function (position_name)
	local style_id = string.format("hit_weakspot_%s", position_name)
	local texture = "content/ui/materials/hud/crosshairs/hit_marker_weakspot"
	local hit_size = {
		15,
		5,
	}
	local center_size = 4
	local hit_marker_distance = 10

	return _hit_indicator_segment(style_id, texture, hit_size, center_size, hit_marker_distance, position_name)
end

function _apply_color_values(destination_color, target_color, include_alpha, optional_alpha)
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

function _hit_indicator_segment(style_id, texture, hit_marker_size, center_size, hit_marker_distance, position_name)
	return table.clone({
		pass_type = "rotated_texture",
		value = texture,
		style_id = style_id,
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			offset = _hit_indicator_offset(position_name, center_size * 0.5, hit_marker_distance),
			size = {
				hit_marker_size[1],
				hit_marker_size[2],
			},
			pivot = _hit_indicator_pivot(position_name, hit_marker_size),
			angle = _hit_indicator_angle(position_name),
			color = hit_indicator_colors.damage_normal,
		},
	})
end

function _hit_indicator_offset(position_name, center_half_width, hit_marker_distance)
	if position_name == "top_left" then
		return {
			-center_half_width - hit_marker_distance,
			-center_half_width - hit_marker_distance,
			1,
		}
	elseif position_name == "bottom_left" then
		return {
			-center_half_width - hit_marker_distance,
			center_half_width + hit_marker_distance,
			1,
		}
	elseif position_name == "top_right" then
		return {
			center_half_width + hit_marker_distance,
			-center_half_width - hit_marker_distance,
			1,
		}
	elseif position_name == "bottom_right" then
		return {
			center_half_width + hit_marker_distance,
			center_half_width + hit_marker_distance,
			1,
		}
	end
end

function _hit_indicator_pivot(position_name, hit_marker_size)
	if position_name == "top_left" then
		return {
			hit_marker_size[1] * 0.5,
			hit_marker_size[2] * 0.5,
		}
	elseif position_name == "bottom_left" then
		return {
			hit_marker_size[1] * 0.5,
			hit_marker_size[2] * 0.5,
		}
	elseif position_name == "top_right" then
		return {
			hit_marker_size[1] * 0.5,
			hit_marker_size[2] * 0.5,
		}
	elseif position_name == "bottom_right" then
		return {
			hit_marker_size[1] * 0.5,
			hit_marker_size[2] * 0.5,
		}
	end
end

function _hit_indicator_angle(position_name, center_half_width, hit_distance)
	if position_name == "top_left" then
		return math.rad(-45)
	elseif position_name == "bottom_left" then
		return math.rad(45)
	elseif position_name == "top_right" then
		return math.rad(225)
	elseif position_name == "bottom_right" then
		return math.rad(-225)
	end
end

function _apply_hit_indicator_segment_style(style, visible, hit_color, hit_alpha)
	style.color = _apply_color_values(style.color, hit_color or style.color, true, hit_alpha)
	style.visible = visible
end

return Crosshair
