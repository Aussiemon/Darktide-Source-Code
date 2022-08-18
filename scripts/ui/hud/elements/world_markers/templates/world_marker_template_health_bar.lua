local HudHealthBarLogic = require("scripts/ui/hud/elements/hud_health_bar_logic")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local template = {}
local size = {
	200,
	6
}
template.size = size
template.name = "health_bar"
template.unit_node = "j_head"
template.position_offset = {
	0,
	0,
	0.35
}
template.check_line_of_sight = true
template.max_distance = 20
template.screen_clamp = false
template.bar_settings = {
	animate_on_health_increase = true,
	bar_spacing = 2,
	duration_health_ghost = 2.5,
	health_animation_threshold = 0.1,
	alpha_fade_delay = 2.6,
	duration_health = 1,
	alpha_fade_min_value = 50,
	alpha_fade_duration = 0.6
}
template.fade_settings = {
	fade_to = 1,
	fade_from = 0,
	default_fade = 0,
	distance_max = template.max_distance,
	distance_min = template.max_distance * 0.5,
	easing_function = math.ease_exp
}

template.create_widget_defintion = function (template, scenegraph_id)
	local size = template.size
	local header_font_setting_name = "nameplates"
	local header_font_settings = UIFontSettings[header_font_setting_name]
	local header_font_color = header_font_settings.text_color
	local bar_size = {
		size[1],
		size[2]
	}
	local bar_offset = {
		-size[1] * 0.5,
		0,
		0
	}

	return UIWidget.create_definition({
		{
			value = "content/ui/vector_textures/hud/hp_bar_short_fill",
			style_id = "background",
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				offset = bar_offset,
				size = bar_size,
				color = {
					120,
					30,
					30,
					30
				}
			}
		},
		{
			value = "content/ui/vector_textures/hud/hp_bar_short_fill",
			style_id = "ghost_bar",
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				offset = {
					bar_offset[1],
					bar_offset[2],
					2
				},
				size = bar_size,
				color = {
					255,
					220,
					100,
					100
				}
			}
		},
		{
			value = "content/ui/vector_textures/hud/hp_bar_short_fill",
			style_id = "health_max",
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					bar_offset[1],
					bar_offset[2],
					1
				},
				size = bar_size,
				color = {
					200,
					255,
					255,
					255
				}
			}
		},
		{
			value = "content/ui/vector_textures/hud/hp_bar_short_fill",
			style_id = "bar",
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				offset = {
					bar_offset[1],
					bar_offset[2],
					3
				},
				size = bar_size,
				color = {
					255,
					220,
					20,
					20
				}
			}
		},
		{
			style_id = "header_text",
			pass_type = "text",
			value_id = "header_text",
			value = "<header_text>",
			style = {
				horizontal_alignment = "left",
				text_vertical_alignment = "bottom",
				text_horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					-size[1] * 0.5,
					-size[2],
					2
				},
				font_type = header_font_settings.font_type,
				font_size = header_font_settings.font_size,
				default_font_size = header_font_settings.font_size,
				text_color = header_font_color,
				default_text_color = header_font_color,
				size = {
					600,
					size[2]
				}
			}
		}
	}, scenegraph_id)
end

template.on_enter = function (widget, marker, template)
	local content = widget.content
	content.spawn_progress_timer = 0
	local bar_settings = template.bar_settings
	marker.bar_logic = HudHealthBarLogic:new(bar_settings)
end

template.update_function = function (parent, ui_renderer, widget, marker, template, dt, t)
	local content = widget.content
	local style = widget.style
	local unit = marker.unit
	local health_extension = ScriptUnit.has_extension(unit, "health_system")
	local health_percent = health_extension and health_extension:current_health_percent() or 0
	local bar_logic = marker.bar_logic

	bar_logic:update(dt, t, health_percent)

	local health_fraction, health_ghost_fraction, health_max_fraction = bar_logic:animated_health_fractions()

	if health_fraction and health_ghost_fraction then
		local bar_settings = template.bar_settings
		local spacing = bar_settings.bar_spacing
		local bar_width = template.size[1]
		local default_width_offset = -bar_width * 0.5
		local health_width = bar_width * health_fraction
		style.bar.size[1] = health_width
		local ghost_bar_width = math.max(bar_width * health_ghost_fraction - health_width, 0)
		local ghost_bar_style = style.ghost_bar
		ghost_bar_style.offset[1] = default_width_offset + health_width
		ghost_bar_style.size[1] = ghost_bar_width
		local background_width = math.max(bar_width - ghost_bar_width - health_width, 0)
		background_width = math.max(background_width - spacing, 0)
		local background_style = style.background
		background_style.offset[1] = default_width_offset + bar_width - background_width
		background_style.size[1] = background_width
		local health_max_style = style.health_max
		local health_max_width = bar_width - math.max(bar_width * health_max_fraction, 0)
		health_max_width = math.max(health_max_width - spacing, 0)
		health_max_style.offset[1] = default_width_offset + bar_width - health_max_width * 0.5
		health_max_style.size[1] = health_max_width
		marker.health_fraction = health_fraction
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

	if not HEALTH_ALIVE[unit] and (not marker.health_fraction or marker.health_fraction == 0) then
		marker.remove = true
	end

	local draw = marker.draw

	if draw then
		local scale = marker.scale
		local header_text_id = "header_text"
		local header_style = style[header_text_id]
		local header_default_font_size = header_style.default_font_size
		header_style.font_size = header_style.default_font_size * scale
		content.line_of_sight_progress = line_of_sight_progress
		widget.alpha_multiplier = line_of_sight_progress
	end
end

return template
