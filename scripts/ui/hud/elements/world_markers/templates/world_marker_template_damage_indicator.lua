local HudHealthBarLogic = require("scripts/ui/hud/elements/hud_health_bar_logic")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local template = {}
local size = {
	120,
	6
}
template.size = size
template.name = "damage_indicator"
template.unit_node = "j_head"
template.position_offset = {
	0,
	0,
	0.9
}
template.check_line_of_sight = true
template.max_distance = 200
template.screen_clamp = false
template.remove_on_death_duration = 1
template.damage_number_settings = {
	expand_duration = 0.4,
	expand_bonus_scale = 20,
	visibility_delay = 10.5,
	max_float_y = 200,
	start_y_offset = 40,
	duration = 1,
	fade_delay = 0.35
}
template.bar_settings = {
	animate_on_health_increase = true,
	bar_spacing = 2,
	duration_health_ghost = 0.2,
	health_animation_threshold = 0.1,
	alpha_fade_delay = 0.3,
	duration_health = 0.5,
	alpha_fade_min_value = 50,
	alpha_fade_duration = 0.4
}
template.fade_settings = {
	fade_to = 1,
	fade_from = 0,
	default_fade = 1,
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
			pass_type = "logic",
			value = function (pass, ui_renderer, ui_style, ui_content, position, size)
				local damage_numbers = ui_content.damage_numbers
				local damage_number_settings = template.damage_number_settings
				local z_position = position[3]
				local y_position = position[2] - damage_number_settings.start_y_offset
				local x_position = position[1]
				local default_font_size = ui_style.font_size
				local font_type = ui_style.font_type
				local text_color = ui_style.text_color
				local num_damage_numbers = #damage_numbers

				for i = num_damage_numbers, 1, -1 do
					local damage_number = damage_numbers[i]
					local wanted_y_position = nil

					if not damage_number.y_position then
						damage_number.y_position = position.y - damage_number_settings.start_y_offset
						wanted_y_position = position.y
					else
						wanted_y_position = damage_number.y_position
					end

					local duration = damage_number.duration
					local time = damage_number.time
					local progress = math.clamp(time / duration, 0, 1)

					if progress >= 1 then
						table.remove(damage_numbers, i)
					else
						damage_number.time = damage_number.time + ui_renderer.dt
					end

					local font_size = default_font_size * 0.75
					local expand_duration = damage_number.expand_duration

					if expand_duration then
						local expand_time = damage_number.expand_time
						local expand_progress = math.clamp(expand_time / expand_duration, 0, 1)
						local anim_progress = 1 - expand_progress
						font_size = font_size + damage_number_settings.expand_bonus_scale * anim_progress

						if expand_progress >= 1 then
							damage_number.expand_duration = nil
						else
							damage_number.expand_time = expand_time + ui_renderer.dt
						end
					end

					local value = damage_number.value
					local text = value
					local size = ui_style.size
					local current_order = num_damage_numbers - i
					position[3] = z_position + current_order
					position[2] = wanted_y_position - damage_number_settings.max_float_y * progress
					position[1] = x_position + (current_order - 5 * math.floor(current_order / 5)) * 15

					UIRenderer.draw_text(ui_renderer, text, font_size, font_type, position, size, text_color)

					damage_number.y_position = wanted_y_position
				end

				ui_style.font_size = default_font_size
				position[3] = z_position
				position[2] = y_position
				position[1] = x_position
			end,
			style = {
				horizontal_alignment = "left",
				font_size = 30,
				text_vertical_alignment = "bottom",
				text_horizontal_alignment = "left",
				vertical_alignment = "center",
				offset = {
					-size[1] * 0.5,
					-size[2],
					2
				},
				font_type = header_font_settings.font_type,
				text_color = header_font_color,
				size = {
					600,
					size[2]
				}
			}
		},
		{
			value = "content/ui/materials/backgrounds/default_square",
			style_id = "background",
			pass_type = "rect",
			style = {
				vertical_alignment = "center",
				offset = bar_offset,
				size = bar_size,
				color = UIHudSettings.color_tint_0
			}
		},
		{
			value = "content/ui/materials/backgrounds/default_square",
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
			value = "content/ui/materials/backgrounds/default_square",
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
			value = "content/ui/materials/backgrounds/default_square",
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
			value = "content/ui/materials/bars/simple/end",
			style_id = "bar_end",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				offset = {
					bar_offset[1],
					bar_offset[2],
					4
				},
				size = {
					12,
					bar_size[2] + 12
				},
				color = {
					255,
					255,
					255,
					255
				}
			}
		}
	}, scenegraph_id)
end

template.on_enter = function (widget, marker, template)
	local content = widget.content
	content.spawn_progress_timer = 0
	content.damage_taken = 0
	content.damage_numbers = {}
	local bar_settings = template.bar_settings
	marker.bar_logic = HudHealthBarLogic:new(bar_settings)
	local unit = marker.unit
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local breed = unit_data_extension:breed()
	content.header_text = breed.name
	content.breed = breed
end

template.update_function = function (parent, ui_renderer, widget, marker, template, dt, t)
	local content = widget.content
	local style = widget.style
	local unit = marker.unit
	local health_extension = ScriptUnit.has_extension(unit, "health_system")
	local is_dead = not health_extension or not health_extension:is_alive()
	local health_percent = is_dead and 0 or health_extension:current_health_percent()
	local max_health = Managers.state.difficulty:get_minion_max_health(content.breed.name)
	local damage_taken = nil

	if not is_dead then
		damage_taken = health_extension:total_damage_taken()
	else
		damage_taken = max_health
	end

	local old_damage_taken = content.damage_taken
	local damage_number_settings = template.damage_number_settings

	if damage_taken and damage_taken ~= old_damage_taken then
		content.visibility_delay = damage_number_settings.visibility_delay
		content.damage_taken = damage_taken

		if old_damage_taken < damage_taken then
			local damage_numbers = content.damage_numbers
			local damage_diff = math.ceil(damage_taken - old_damage_taken)
			local latest_damage_number = damage_numbers[#damage_numbers]
			local should_add = true

			if latest_damage_number and t - latest_damage_number.start_time < 0.25 then
				should_add = false
			end

			if should_add then
				local damage_number = {
					expand_time = 0,
					time = 0,
					start_time = t,
					duration = damage_number_settings.duration,
					value = damage_diff,
					expand_duration = damage_number_settings.expand_duration
				}
				damage_numbers[#damage_numbers + 1] = damage_number
			else
				latest_damage_number.value = math.clamp(latest_damage_number.value + damage_diff, 0, max_health)
				latest_damage_number.time = 0
				latest_damage_number.y_position = nil
				latest_damage_number.start_time = t
			end
		end
	end

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
		local health_end_style = style.bar_end
		health_end_style.offset[1] = -(bar_width - bar_width * health_fraction) + 6 + math.abs(default_width_offset)
		marker.health_fraction = health_fraction
	end

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

	if not HEALTH_ALIVE[unit] then
		if not content.remove_timer then
			content.remove_timer = template.remove_on_death_duration
		else
			content.remove_timer = content.remove_timer - dt

			if content.remove_timer <= 0 and (not marker.health_fraction or marker.health_fraction == 0) then
				marker.remove = true
			end
		end
	end

	local draw = marker.draw

	if draw then
		local alpha_multiplier = line_of_sight_progress
		content.line_of_sight_progress = line_of_sight_progress
		local visibility_delay = content.visibility_delay

		if visibility_delay then
			visibility_delay = visibility_delay - dt
			content.visibility_delay = visibility_delay >= 0 and visibility_delay or nil

			if not content.visibility_delay then
				content.fade_delay = damage_number_settings.fade_delay
			end
		end

		local fade_delay = content.fade_delay

		if fade_delay then
			fade_delay = fade_delay - dt
			content.fade_delay = fade_delay >= 0 and fade_delay or nil
			local progress = math.clamp(fade_delay / damage_number_settings.fade_delay, 0, 1)
			alpha_multiplier = alpha_multiplier * progress
		elseif not visibility_delay then
			alpha_multiplier = 0
		end

		widget.alpha_multiplier = alpha_multiplier
	end
end

return template
