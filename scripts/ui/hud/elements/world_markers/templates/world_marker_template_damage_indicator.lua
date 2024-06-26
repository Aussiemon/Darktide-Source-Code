-- chunkname: @scripts/ui/hud/elements/world_markers/templates/world_marker_template_damage_indicator.lua

local HudHealthBarLogic = require("scripts/ui/hud/elements/hud_health_bar_logic")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local template = {}
local size = {
	120,
	6,
}
local damage_number_types = table.enum("readable", "floating", "flashy")

template.show_health_bar = true
template.show_numbers = true
template.show_armor_types = true
template.show_dps = true
template.skip_damage_from_others = false
template.fade_bar_on_death = false
template.damage_number_type = damage_number_types.readable
template.size = size
template.name = "damage_indicator"
template.unit_node = "root_point"
template.position_offset = {
	0,
	0,
	0,
}
template.check_line_of_sight = true
template.max_distance = 200
template.screen_clamp = false
template.remove_on_death_duration = 2
template.damage_number_settings = {
	add_numbers_together_timer = 0.2,
	add_numbers_together_timer_flashy = 0,
	crit_color = "orange",
	crit_hit_size_scale = 1.5,
	default_color = "white",
	default_font_size = 17,
	dps_font_size = 14.4,
	dps_y_offset = -36,
	duration = 3,
	expand_bonus_scale = 30,
	expand_duration = 0.2,
	fade_delay = 2,
	first_hit_size_scale = 1.2,
	has_taken_damage_timer_remove_after_time = 5,
	has_taken_damage_timer_y_offset = 34,
	hundreds_font_size = 14.4,
	max_float_y = 100,
	shrink_duration = 1,
	visibility_delay = 2,
	weakspot_color = "yellow",
	x_offset = 1,
	x_offset_between_numbers = 38,
	y_offset = 15,
	flashy_font_size_dmg_multiplier = {
		1,
		2,
	},
	flashy_font_size_dmg_scale_range = {
		100,
		600,
	},
}
template.bar_settings = {
	alpha_fade_delay = 0.5,
	alpha_fade_duration = 0.6,
	alpha_fade_min_value = 50,
	animate_on_health_increase = true,
	bar_spacing = 2,
	duration_health = 0.5,
	duration_health_ghost = 0.2,
	health_animation_threshold = 0.1,
}

local armor_type_string_lookup = {
	armored = "loc_weapon_stats_display_armored",
	berserker = "loc_weapon_stats_display_berzerker",
	disgustingly_resilient = "loc_weapon_stats_display_disgustingly_resilient",
	resistant = "loc_glossary_armour_type_resistant",
	super_armor = "loc_weapon_stats_display_super_armor",
	unarmored = "loc_weapon_stats_display_unarmored",
}

template.fade_settings = {
	default_fade = 0.5,
	fade_from = 0.5,
	fade_to = 1,
	distance_max = template.max_distance,
	distance_min = template.max_distance * 0.5,
	easing_function = math.ease_exp,
}

local function _readable_damage_number_function(ui_content, ui_renderer, ui_style, damage_number_settings, damage_numbers, num_damage_numbers, position, default_color, text_color, crit_color, weakspot_color, default_font_size, hundreds_font_size, font_type)
	local z_position = position[3]
	local y_position = position[2] + damage_number_settings.y_offset
	local x_position = position[1] + damage_number_settings.x_offset

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
		elseif damage_number.shrink_start_t and time > damage_number.shrink_start_t then
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

	position[3] = z_position
	position[2] = y_position
	position[1] = x_position
end

local function _floating_damage_number_function(ui_content, ui_renderer, ui_style, damage_number_settings, damage_numbers, num_damage_numbers, position, default_color, text_color, crit_color, weakspot_color, default_font_size, hundreds_font_size, font_type)
	local z_position = position[3]
	local y_position = position[2] - damage_number_settings.y_offset * 3
	local x_position = position[1] + damage_number_settings.x_offset

	if ui_content.alpha_multiplier then
		text_color[1] = text_color[1] * ui_content.alpha_multiplier
	end

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
		elseif damage_number.shrink_start_t and time > damage_number.shrink_start_t then
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

		position[3] = z_position + current_order * 2
		position[2] = y_position - 35 * time
		position[1] = x_position + current_order * damage_number_settings.x_offset_between_numbers

		UIRenderer.draw_text(ui_renderer, text, font_size, font_type, position, size, text_color, {})
	end

	position[3] = z_position
	position[2] = y_position
	position[1] = x_position
end

local function _flashy_damage_number_function(ui_content, ui_renderer, ui_style, damage_number_settings, damage_numbers, num_damage_numbers, position, default_color, text_color, crit_color, weakspot_color, default_font_size, hundreds_font_size, font_type)
	local z_position = position[3]
	local y_position = position[2] - damage_number_settings.y_offset * 3
	local x_position = position[1] + damage_number_settings.x_offset

	if ui_content.alpha_multiplier then
		text_color[1] = text_color[1] * ui_content.alpha_multiplier
	end

	local flashy_font_size_dmg_multiplier = damage_number_settings.flashy_font_size_dmg_multiplier
	local flashy_font_size_dmg_scale_range = damage_number_settings.flashy_font_size_dmg_scale_range

	for i = num_damage_numbers, 1, -1 do
		local damage_number = damage_numbers[i]

		if damage_number.hit_world_position then
			local world_to_screen_position = Camera.world_to_screen(ui_content.player_camera, damage_number.hit_world_position:unbox())

			y_position = world_to_screen_position[2] - 75
			x_position = world_to_screen_position[1]
		end

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
		local dmg_scale_multiplier = 1

		if value > flashy_font_size_dmg_scale_range[1] then
			local min = flashy_font_size_dmg_scale_range[1]
			local max = flashy_font_size_dmg_scale_range[2]
			local lerp = math.min((value - min) / (max - min), 1)
			local multiplier = math.lerp(flashy_font_size_dmg_multiplier[1], flashy_font_size_dmg_multiplier[2], lerp)

			font_size = font_size * multiplier
			dmg_scale_multiplier = multiplier
		end

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
		elseif damage_number.shrink_start_t and time > damage_number.shrink_start_t then
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

		local random_number = damage_number.random_number
		local float_right = damage_number.float_right
		local float_value = 45 * math.lerp(0.8, 1.2, random_number) * dmg_scale_multiplier
		local float_y_value = float_value * 1.25
		local float_x_value = float_right and float_value or -float_value

		position[2] = y_position - math.ease_out_elastic(time) * float_y_value + time * float_y_value
		position[1] = x_position + math.ease_out_elastic(time) * float_x_value + (float_right and time * float_value or time * -float_value) - (not float_right and font_size * 0.5 or 0)

		UIRenderer.draw_text(ui_renderer, text, font_size, font_type, position, size, text_color, {})
	end

	position[3] = z_position
	position[2] = y_position
	position[1] = x_position
end

template.damage_number_function = function (pass, ui_renderer, ui_style, ui_content, position, size)
	local damage_numbers = ui_content.damage_numbers
	local damage_number_settings = template.damage_number_settings
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
	local z_position = position[3]
	local y_position = position[2]
	local x_position = position[1]
	local damage_has_started = ui_content.damage_has_started

	if damage_has_started then
		if not ui_content.damage_has_started_timer then
			ui_content.damage_has_started_timer = ui_renderer.dt
		elseif not ui_content.dead then
			ui_content.damage_has_started_timer = ui_content.damage_has_started_timer + ui_renderer.dt
		end

		if template.show_dps and ui_content.dead then
			if template.damage_number_type == damage_number_types.readable then
				local damage_has_started_position = Vector3(x_position, y_position - damage_number_settings.dps_y_offset, z_position)
				local dps = ui_content.damage_has_started_timer > 1 and ui_content.damage_taken / ui_content.damage_has_started_timer or ui_content.damage_taken
				local text = string.format("%d DPS", dps)

				UIRenderer.draw_text(ui_renderer, text, dps_font_size, font_type, damage_has_started_position, size, ui_style.text_color, {})
			else
				local damage_has_started_position = Vector3(x_position, y_position - damage_number_settings.dps_y_offset * 0.6, z_position)
				local dps = ui_content.damage_has_started_timer > 1 and ui_content.damage_taken / ui_content.damage_has_started_timer or ui_content.damage_taken
				local text = string.format("%d DPS", dps)

				UIRenderer.draw_text(ui_renderer, text, dps_font_size, font_type, damage_has_started_position, size, ui_style.text_color, {})
			end
		end

		if ui_content.last_hit_zone_name then
			local hit_zone_name = ui_content.last_hit_zone_name
			local breed = ui_content.breed
			local armor_type = breed.armor_type

			if breed.hitzone_armor_override and breed.hitzone_armor_override[hit_zone_name] then
				armor_type = breed.hitzone_armor_override[hit_zone_name]
			end

			if template.show_armor_types then
				local armor_type_loc_string = armor_type and armor_type_string_lookup[armor_type] or ""
				local armor_type_text = Localize(armor_type_loc_string)

				if template.damage_number_type == damage_number_types.readable then
					local armor_type_position = Vector3(x_position, y_position - damage_number_settings.has_taken_damage_timer_y_offset * 0.7, z_position)

					UIRenderer.draw_text(ui_renderer, armor_type_text, dps_font_size, font_type, armor_type_position, size, ui_style.text_color, {})
				else
					local armor_type_position = Vector3(x_position, y_position + damage_number_settings.has_taken_damage_timer_y_offset * 1.25, z_position)

					UIRenderer.draw_text(ui_renderer, armor_type_text, dps_font_size, font_type, armor_type_position, size, ui_style.text_color, {})
				end
			end
		end
	end

	if template.damage_number_type == damage_number_types.readable then
		_readable_damage_number_function(ui_content, ui_renderer, ui_style, damage_number_settings, damage_numbers, num_damage_numbers, position, default_color, text_color, crit_color, weakspot_color, default_font_size, hundreds_font_size, font_type)
	elseif template.damage_number_type == damage_number_types.floating then
		_floating_damage_number_function(ui_content, ui_renderer, ui_style, damage_number_settings, damage_numbers, num_damage_numbers, position, default_color, text_color, crit_color, weakspot_color, default_font_size, hundreds_font_size, font_type)
	elseif template.damage_number_type == damage_number_types.flashy then
		_flashy_damage_number_function(ui_content, ui_renderer, ui_style, damage_number_settings, damage_numbers, num_damage_numbers, position, default_color, text_color, crit_color, weakspot_color, default_font_size, hundreds_font_size, font_type)
	end

	ui_style.font_size = default_font_size
end

template.create_widget_defintion = function (temp, scenegraph_id)
	local size = temp.size
	local header_font_setting_name = "nameplates"
	local header_font_settings = UIFontSettings[header_font_setting_name]
	local header_font_color = header_font_settings.text_color
	local bar_size = {
		size[1],
		size[2],
	}
	local bar_offset = {
		-size[1] * 0.5,
		0,
		0,
	}

	if template.show_health_bar and template.show_numbers then
		return UIWidget.create_definition({
			{
				pass_type = "logic",
				value = template.damage_number_function,
				style = {
					font_size = 30,
					horizontal_alignment = "left",
					text_horizontal_alignment = "left",
					text_vertical_alignment = "bottom",
					vertical_alignment = "center",
					offset = {
						-size[1] * 0.5,
						-size[2],
						2,
					},
					font_type = header_font_settings.font_type,
					text_color = header_font_color,
					size = {
						600,
						size[2],
					},
				},
			},
			{
				pass_type = "rect",
				style_id = "background",
				value = "content/ui/materials/backgrounds/default_square",
				style = {
					vertical_alignment = "center",
					offset = bar_offset,
					size = bar_size,
					color = UIHudSettings.color_tint_0,
				},
			},
			{
				pass_type = "rect",
				style_id = "ghost_bar",
				value = "content/ui/materials/backgrounds/default_square",
				style = {
					vertical_alignment = "center",
					offset = {
						bar_offset[1],
						bar_offset[2],
						2,
					},
					size = bar_size,
					color = {
						255,
						220,
						100,
						100,
					},
				},
			},
			{
				pass_type = "rect",
				style_id = "health_max",
				value = "content/ui/materials/backgrounds/default_square",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					offset = {
						bar_offset[1],
						bar_offset[2],
						1,
					},
					size = bar_size,
					color = {
						200,
						255,
						255,
						255,
					},
				},
			},
			{
				pass_type = "rect",
				style_id = "bar",
				value = "content/ui/materials/backgrounds/default_square",
				style = {
					vertical_alignment = "center",
					offset = {
						bar_offset[1],
						bar_offset[2],
						3,
					},
					size = bar_size,
					color = {
						255,
						220,
						20,
						20,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "bar_end",
				value = "content/ui/materials/bars/simple/end",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "center",
					offset = {
						bar_offset[1],
						bar_offset[2],
						4,
					},
					size = {
						12,
						bar_size[2] + 12,
					},
					color = {
						255,
						255,
						255,
						255,
					},
				},
			},
		}, scenegraph_id)
	elseif not template.show_health_bar and template.show_numbers then
		return UIWidget.create_definition({
			{
				pass_type = "logic",
				value = template.damage_number_function,
				style = {
					font_size = 30,
					horizontal_alignment = "left",
					text_horizontal_alignment = "left",
					text_vertical_alignment = "bottom",
					vertical_alignment = "center",
					offset = {
						-size[1] * 0.5,
						-size[2],
						2,
					},
					font_type = header_font_settings.font_type,
					text_color = header_font_color,
					size = {
						600,
						size[2],
					},
				},
			},
		}, scenegraph_id)
	elseif template.show_health_bar and not template.show_numbers then
		return UIWidget.create_definition({
			{
				pass_type = "rect",
				style_id = "background",
				value = "content/ui/materials/backgrounds/default_square",
				style = {
					vertical_alignment = "center",
					offset = bar_offset,
					size = bar_size,
					color = UIHudSettings.color_tint_0,
				},
			},
			{
				pass_type = "rect",
				style_id = "ghost_bar",
				value = "content/ui/materials/backgrounds/default_square",
				style = {
					vertical_alignment = "center",
					offset = {
						bar_offset[1],
						bar_offset[2],
						2,
					},
					size = bar_size,
					color = {
						255,
						220,
						100,
						100,
					},
				},
			},
			{
				pass_type = "rect",
				style_id = "health_max",
				value = "content/ui/materials/backgrounds/default_square",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					offset = {
						bar_offset[1],
						bar_offset[2],
						1,
					},
					size = bar_size,
					color = {
						200,
						255,
						255,
						255,
					},
				},
			},
			{
				pass_type = "rect",
				style_id = "bar",
				value = "content/ui/materials/backgrounds/default_square",
				style = {
					vertical_alignment = "center",
					offset = {
						bar_offset[1],
						bar_offset[2],
						3,
					},
					size = bar_size,
					color = {
						255,
						220,
						20,
						20,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "bar_end",
				value = "content/ui/materials/bars/simple/end",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "center",
					offset = {
						bar_offset[1],
						bar_offset[2],
						4,
					},
					size = {
						12,
						bar_size[2] + 12,
					},
					color = {
						255,
						255,
						255,
						255,
					},
				},
			},
		}, scenegraph_id)
	end
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
	content.unit_data_extension = unit_data_extension
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
	local damage_taken
	local player_camera = parent._parent and parent._parent:player_camera()

	content.player_camera = player_camera

	if not is_dead then
		damage_taken = health_extension:total_damage_taken()
	else
		damage_taken = max_health
	end

	if health_extension then
		local last_damaging_unit = health_extension:last_damaging_unit()

		if last_damaging_unit then
			content.last_hit_zone_name = health_extension:last_hit_zone_name() or "center_mass"
			content.last_damaging_unit = last_damaging_unit

			local breed = content.breed
			local hit_zone_weakspot_types = breed.hit_zone_weakspot_types

			if hit_zone_weakspot_types and hit_zone_weakspot_types[content.last_hit_zone_name] then
				content.hit_weakspot = true
			else
				content.hit_weakspot = false
			end

			content.was_critical = health_extension:was_hit_by_critical_hit_this_render_frame()

			local last_hit_world_position = health_extension:last_hit_world_position()

			if last_hit_world_position then
				if not content.last_hit_world_position then
					content.last_hit_world_position = Vector3Box(last_hit_world_position)
				else
					content.last_hit_world_position:store(last_hit_world_position)
				end
			end
		end
	end

	if ALIVE[unit] and damage_taken > 0 then
		local root_position = Unit.world_position(unit, 1)

		if not marker.world_position then
			root_position.z = root_position.z + content.breed.base_height
			marker.world_position = Vector3Box(root_position)
		else
			root_position.z = root_position.z + content.breed.base_height

			marker.world_position:store(root_position)
		end
	end

	local old_damage_taken = content.damage_taken
	local damage_number_settings = template.damage_number_settings
	local show_damage_number = not template.skip_damage_from_others or not content.last_damaging_unit or content.last_damaging_unit == (Managers.player:local_player(1) and Managers.player:local_player(1).player_unit)

	if damage_taken and damage_taken ~= old_damage_taken then
		content.visibility_delay = damage_number_settings.visibility_delay
		content.damage_taken = damage_taken

		if show_damage_number and old_damage_taken < damage_taken then
			local damage_numbers = content.damage_numbers
			local damage_diff = math.ceil(damage_taken - old_damage_taken)
			local latest_damage_number = damage_numbers[#damage_numbers]
			local should_add = true
			local was_critical = health_extension and health_extension:was_hit_by_critical_hit_this_render_frame()

			if latest_damage_number then
				local add_numbers_together_timer = template.damage_number_type == damage_number_types.flashy and damage_number_settings.add_numbers_together_timer_flashy or damage_number_settings.add_numbers_together_timer

				if add_numbers_together_timer > t - latest_damage_number.start_time then
					should_add = false
				end
			end

			if content.add_on_next_number or was_critical or should_add then
				local damage_number = {
					expand_time = 0,
					time = 0,
					start_time = t,
					duration = damage_number_settings.duration,
					value = damage_diff,
					expand_duration = damage_number_settings.expand_duration,
					random_number = math.random(),
					float_right = math.random() > 0.5,
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

				if content.last_hit_world_position then
					damage_number.hit_world_position = Vector3Box(content.last_hit_world_position:unbox())
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

	if template.show_health_bar then
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
			health_max_style.offset[1] = default_width_offset + (bar_width - health_max_width * 0.5)
			health_max_style.size[1] = health_max_width

			local health_end_style = style.bar_end

			health_end_style.offset[1] = -(bar_width - bar_width * health_fraction) + 6 + math.abs(default_width_offset)
			marker.health_fraction = health_fraction
		end
	else
		local bar_logic = marker.bar_logic

		bar_logic:update(dt, t, 0)
	end

	local line_of_sight_progress = content.line_of_sight_progress or 0

	if marker.raycast_initialized then
		local raycast_result = marker.raycast_result
		local line_of_sight_speed = 10

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

			if template.fade_bar_on_death then
				content.fade_delay = damage_number_settings.fade_delay
			end
		else
			content.remove_timer = content.remove_timer - dt

			if content.remove_timer <= 0 and (not marker.health_fraction or marker.health_fraction == 0) then
				marker.remove = true
			end
		end
	end

	local alpha_multiplier = line_of_sight_progress
	local visibility_delay = content.visibility_delay

	if not content.fade_delay then
		content.line_of_sight_progress = line_of_sight_progress

		if visibility_delay then
			visibility_delay = visibility_delay - dt
			content.visibility_delay = visibility_delay >= 0 and visibility_delay or nil

			if not content.visibility_delay then
				content.fade_delay = damage_number_settings.fade_delay
			end
		end
	end

	local fade_delay = content.fade_delay

	if fade_delay then
		fade_delay = fade_delay - dt
		content.fade_delay = fade_delay >= 0 and fade_delay or nil

		local progress = math.clamp(fade_delay / damage_number_settings.fade_delay, 0, 1)

		alpha_multiplier = alpha_multiplier * progress

		if template.fade_bar_on_death then
			content.visibility_delay = nil
		end
	elseif not visibility_delay then
		alpha_multiplier = 0
	end

	widget.alpha_multiplier = alpha_multiplier
	content.alpha_multiplier = alpha_multiplier
end

return template
