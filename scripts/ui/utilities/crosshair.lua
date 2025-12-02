-- chunkname: @scripts/ui/utilities/crosshair.lua

local HudElementCrosshairSettings = require("scripts/ui/hud/elements/crosshair/hud_element_crosshair_settings")
local Recoil = require("scripts/utilities/recoil")
local Sway = require("scripts/utilities/sway")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local hit_indicator_colors = HudElementCrosshairSettings.hit_indicator_colors
local Crosshair = {}
local _apply_color_values, _hit_indicator_segment, _hit_indicator_offset, _hit_indicator_pivot, _hit_indicator_angle, _apply_hit_indicator_segment_style
local CROSSHAIR_POSITION_LERP_SPEED = 35

Crosshair.position = function (dt, t, ui_hud, ui_renderer, current_x, current_y, pivot_position)
	local target_x, target_y = 0, 0
	local player_extensions = ui_hud:player_extensions()
	local weapon_extension = player_extensions and player_extensions.weapon
	local player_camera = ui_hud:player_camera()

	if weapon_extension and player_camera then
		local unit_data_extension = player_extensions.unit_data
		local first_person_extension = player_extensions.first_person
		local first_person_unit = first_person_extension:first_person_unit()
		local shoot_rotation = Unit.world_rotation(first_person_unit, 1)
		local shoot_position = Unit.world_position(first_person_unit, 1)
		local recoil_template = weapon_extension:recoil_template()
		local recoil_component = unit_data_extension:read_component("recoil")
		local movement_state_component = unit_data_extension:read_component("movement_state")
		local locomotion_component = unit_data_extension:read_component("locomotion")
		local inair_state_component = unit_data_extension:read_component("inair_state")

		shoot_rotation = Recoil.apply_weapon_recoil_rotation(recoil_template, recoil_component, movement_state_component, locomotion_component, inair_state_component, shoot_rotation)

		local sway_component = unit_data_extension:read_component("sway")
		local sway_template = weapon_extension:sway_template()

		shoot_rotation = Sway.apply_sway_rotation(sway_template, sway_component, shoot_rotation)

		local range = 50
		local shoot_direction = Quaternion.forward(shoot_rotation)
		local world_aim_position = shoot_position + shoot_direction * range
		local screen_aim_position = Camera.world_to_screen(player_camera, world_aim_position)
		local abs_target_x, abs_target_y = screen_aim_position.x, screen_aim_position.y
		local pivot_x, pivot_y = pivot_position[1], pivot_position[2]

		target_x = abs_target_x - pivot_x
		target_y = abs_target_y - pivot_y
	end

	local ui_renderer_scale = ui_renderer.scale
	local ui_renderer_inverse_scale = ui_renderer.inverse_scale
	local scaled_x, scaled_y = current_x * ui_renderer_scale, current_y * ui_renderer_scale
	local lerp_t = math.min(CROSSHAIR_POSITION_LERP_SPEED * dt, 1)
	local x = math.lerp(scaled_x, target_x, lerp_t) * ui_renderer_inverse_scale
	local y = math.lerp(scaled_y, target_y, lerp_t) * ui_renderer_inverse_scale

	return x, y
end

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
