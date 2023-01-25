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
template.unit_node = "root_point"
template.position_offset = {
	0,
	0,
	0
}
template.check_line_of_sight = true
template.max_distance = 200
template.screen_clamp = false
template.remove_on_death_duration = 2
template.damage_number_settings = {
	first_hit_size_scale = 1.2,
	crit_hit_size_scale = 1.5,
	visibility_delay = 5,
	expand_bonus_scale = 30,
	default_color = "white",
	has_taken_damage_timer_y_offset = 34,
	weakspot_color = "orange",
	fade_delay = 0.35,
	add_numbers_together_timer = 0.2,
	shrink_duration = 1,
	duration = 3,
	x_offset_between_numbers = 38,
	expand_duration = 0.2,
	crit_color = "yellow",
	hundreds_font_size = 14.4,
	default_font_size = 17,
	has_taken_damage_timer_remove_after_time = 5,
	max_float_y = 100,
	dps_font_size = 14.4,
	x_offset = 1,
	dps_y_offset = -24,
	y_offset = 15
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
local armor_type_string_lookup = {
	disgustingly_resilient = "loc_weapon_stats_display_disgustingly_resilient",
	super_armor = "loc_weapon_stats_display_super_armor",
	armored = "loc_weapon_stats_display_armored",
	resistant = "loc_glossary_armour_type_resistant",
	berserker = "loc_weapon_stats_display_berzerker",
	unarmored = "loc_weapon_stats_display_unarmored"
}
template.fade_settings = {
	fade_to = 1,
	fade_from = 0.5,
	default_fade = 0.5,
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
				local y_position = position[2] + damage_number_settings.y_offset
				local x_position = position[1] + damage_number_settings.x_offset
				local scale = RESOLUTION_LOOKUP.scale
				local default_font_size = damage_number_settings.default_font_size * scale
				local dps_font_size = damage_number_settings.dps_font_size * scale
				local hundreds_font_size = damage_number_settings.hundreds_font_size * scale
				local font_type = ui_style.font_type
				local default_color = Color[damage_number_settings.default_color](255, true)
				local crit_color = Color[damage_number_settings.crit_color](255, true)
				local weakspot_color = Color[damage_number_settings.weakspot_color](255, true)
				local text_color = table.clone(default_color)
				local num_damage_numbers = #damage_numbers

				for i = num_damage_numbers, 1, -1 do
					local damage_number = damage_numbers[i]
					local duration = damage_number.duration
					local time = damage_number.time
					local progress = math.clamp(time / duration, 0, 1)

					if progress >= 1 then
						table.remove(damage_numbers, i)
					else
						damage_number.time = damage_number.time + ui_renderer.dt
					end

					if damage_number.was_critical then
						text_color[2] = crit_color[2]
						text_color[3] = crit_color[3]
						text_color[4] = crit_color[4]
						damage_number.expand_duration = damage_number_settings.expand_duration
					elseif damage_number.hit_weakspot then
						text_color[2] = weakspot_color[2]
						text_color[3] = weakspot_color[3]
						text_color[4] = weakspot_color[4]
					else
						text_color[2] = default_color[2]
						text_color[3] = default_color[3]
						text_color[4] = default_color[4]
					end

					local value = damage_number.value
					local font_size = value <= 99 and default_font_size or hundreds_font_size
					local expand_duration = damage_number.expand_duration

					if expand_duration then
						local expand_time = damage_number.expand_time
						local expand_progress = math.clamp(expand_time / expand_duration, 0, 1)
						local anim_progress = 1 - expand_progress
						font_size = font_size + damage_number_settings.expand_bonus_scale * anim_progress

						if expand_progress >= 1 then
							damage_number.expand_duration = nil
							damage_number.shrink_start_t = duration - damage_number_settings.shrink_duration
						else
							damage_number.expand_time = expand_time + ui_renderer.dt
						end
					elseif damage_number.shrink_start_t and damage_number.shrink_start_t < time then
						local diff = time - damage_number.shrink_start_t
						local percentage = diff / damage_number_settings.shrink_duration
						local scale = 1 - percentage
						font_size = font_size * scale
						text_color[1] = text_color[1] * scale
					end

					local text = value
					local size = ui_style.size
					local current_order = num_damage_numbers - i

					if current_order == 0 then
						local scale_size = damage_number.was_critical and damage_number_settings.crit_hit_size_scale or damage_number_settings.first_hit_size_scale
						font_size = font_size * scale_size
					end

					position[3] = z_position + current_order
					position[2] = y_position
					position[1] = x_position + current_order * damage_number_settings.x_offset_between_numbers

					UIRenderer.draw_text(ui_renderer, text, font_size, font_type, position, size, text_color, {})
				end

				local damage_has_started = ui_content.damage_has_started

				if damage_has_started then
					if not ui_content.damage_has_started_timer then
						ui_content.damage_has_started_timer = ui_renderer.dt
					elseif not ui_content.dead then
						ui_content.damage_has_started_timer = ui_content.damage_has_started_timer + ui_renderer.dt
					end

					if ui_content.dead then
						local damage_has_started_position = Vector3(x_position, y_position - damage_number_settings.dps_y_offset, z_position)
						local dps = ui_content.damage_has_started_timer > 1 and ui_content.damage_taken / ui_content.damage_has_started_timer or ui_content.damage_taken
						local text = string.format("%d DPS", dps)

						UIRenderer.draw_text(ui_renderer, text, dps_font_size, font_type, damage_has_started_position, size, ui_style.text_color, {})
					end

					if ui_content.last_hit_zone_name then
						local hit_zone_name = ui_content.last_hit_zone_name
						local breed = ui_content.breed
						local armor_type = breed.armor_type

						if breed.hitzone_armor_override and breed.hitzone_armor_override[hit_zone_name] then
							armor_type = breed.hitzone_armor_override[hit_zone_name]
						end

						local armor_type_loc_string = armor_type and armor_type_string_lookup[armor_type] or ""
						local armor_type_text = Localize(armor_type_loc_string)
						local armor_type_position = Vector3(x_position, y_position - damage_number_settings.has_taken_damage_timer_y_offset, z_position)

						UIRenderer.draw_text(ui_renderer, armor_type_text, dps_font_size, font_type, armor_type_position, size, ui_style.text_color, {})
					end
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

local HEAD_NODE = "j_head"

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

	if health_extension then
		local last_damaging_unit = health_extension:last_damaging_unit()

		if last_damaging_unit then
			content.last_hit_zone_name = health_extension:last_hit_zone_name() or "center_mass"
			local breed = content.breed
			local hit_zone_weakspot_types = breed.hit_zone_weakspot_types

			if hit_zone_weakspot_types and hit_zone_weakspot_types[content.last_hit_zone_name] then
				content.hit_weakspot = true
			else
				content.hit_weakspot = false
			end

			content.was_critical = health_extension:was_hit_by_critical_hit_this_render_frame()
		end
	end

	if ALIVE[unit] and damage_taken > 0 then
		local root_position = Unit.world_position(unit, 1)

		if not marker.world_position then
			local node = Unit.node(unit, HEAD_NODE)
			local head_position = Unit.world_position(unit, node)
			head_position.z = head_position.z + 0.5
			marker.world_position = Vector3Box(head_position)
		else
			local position = marker.world_position:unbox()
			position.x = root_position.x
			position.y = root_position.y

			marker.world_position:store(position)
		end
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
			local was_critical = health_extension and health_extension:was_hit_by_critical_hit_this_render_frame()

			if latest_damage_number and t - latest_damage_number.start_time < damage_number_settings.add_numbers_together_timer then
				should_add = false
			end

			if content.add_on_next_number or was_critical or should_add then
				local damage_number = {
					expand_time = 0,
					time = 0,
					start_time = t,
					duration = damage_number_settings.duration,
					value = damage_diff,
					expand_duration = damage_number_settings.expand_duration
				}
				local breed = content.breed
				local hit_zone_weakspot_types = breed.hit_zone_weakspot_types

				if hit_zone_weakspot_types and hit_zone_weakspot_types[content.last_hit_zone_name] then
					damage_number.hit_weakspot = true
				else
					damage_number.hit_weakspot = false
				end

				damage_number.was_critical = was_critical
				damage_numbers[#damage_numbers + 1] = damage_number

				if content.add_on_next_number then
					content.add_on_next_number = nil
				end

				if was_critical then
					content.add_on_next_number = true
				end
			else
				latest_damage_number.value = math.clamp(latest_damage_number.value + damage_diff, 0, max_health)
				latest_damage_number.time = 0
				latest_damage_number.y_position = nil
				latest_damage_number.start_time = t
				local breed = content.breed
				local hit_zone_weakspot_types = breed.hit_zone_weakspot_types

				if hit_zone_weakspot_types and hit_zone_weakspot_types[content.last_hit_zone_name] then
					latest_damage_number.hit_weakspot = true
				else
					latest_damage_number.hit_weakspot = false
				end

				latest_damage_number.was_critical = was_critical
			end
		end

		if not content.damage_has_started then
			content.damage_has_started = true
		end

		content.last_damage_taken_time = t
	end

	content.t = t
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
			content.dead = true
		else
			content.remove_timer = content.remove_timer - dt

			if content.remove_timer <= 0 and (not marker.health_fraction or marker.health_fraction == 0) then
				marker.remove = true
			end
		end
	end

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

return template
