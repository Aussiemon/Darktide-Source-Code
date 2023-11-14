local UIWidget = require("scripts/managers/ui/ui_widget")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local template = {
	name = "dot",
	size = {
		4,
		4
	},
	hit_default_distance = 10,
	hit_size = {
		12,
		2
	}
}

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
	local hit_size = template.hit_size
	local hit_default_distance = template.hit_default_distance
	local center_half_width = size[1] * 0.5

	return UIWidget.create_definition({
		{
			value = "content/ui/materials/hud/crosshairs/default_center",
			style_id = "center",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					0
				},
				size = size,
				color = UIHudSettings.color_tint_main_1
			}
		},
		{
			value = "content/ui/materials/backgrounds/default_square",
			style_id = "hit_top_left",
			pass_type = "rotated_texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				offset = {
					-center_half_width - hit_default_distance,
					-center_half_width - hit_default_distance,
					0
				},
				size = {
					hit_size[1],
					hit_size[2]
				},
				pivot = {
					hit_size[1],
					hit_size[2] * 0.5
				},
				angle = -math.pi / 4,
				color = {
					255,
					255,
					255,
					0
				}
			}
		},
		{
			value = "content/ui/materials/backgrounds/default_square",
			style_id = "hit_bottom_left",
			pass_type = "rotated_texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				offset = {
					-center_half_width - hit_default_distance,
					center_half_width + hit_default_distance,
					0
				},
				size = {
					hit_size[1],
					hit_size[2]
				},
				pivot = {
					hit_size[1],
					hit_size[2] * 0.5
				},
				angle = math.pi / 4,
				color = {
					255,
					255,
					255,
					0
				}
			}
		},
		{
			value = "content/ui/materials/backgrounds/default_square",
			style_id = "hit_top_right",
			pass_type = "rotated_texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				offset = {
					center_half_width + hit_default_distance,
					-center_half_width - hit_default_distance,
					0
				},
				size = {
					hit_size[1],
					hit_size[2]
				},
				pivot = {
					0,
					hit_size[2] * 0.5
				},
				angle = math.pi / 4,
				color = {
					255,
					255,
					255,
					0
				}
			}
		},
		{
			value = "content/ui/materials/backgrounds/default_square",
			style_id = "hit_bottom_right",
			pass_type = "rotated_texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				offset = {
					center_half_width + hit_default_distance,
					center_half_width + hit_default_distance,
					0
				},
				size = {
					hit_size[1],
					hit_size[2]
				},
				pivot = {
					0,
					hit_size[2] * 0.5
				},
				angle = -math.pi / 4,
				color = {
					255,
					255,
					255,
					0
				}
			}
		}
	}, scenegraph_id)
end

template.update_function = function (parent, ui_renderer, widget, crosshair_template, crosshair_settings, dt, t)
	local style = widget.style
	local hit_progress, hit_color = parent:hit_indicator()
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
