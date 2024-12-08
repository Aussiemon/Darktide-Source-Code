-- chunkname: @scripts/ui/views/mission_board_view/mission_board_view_styles.lua

local ColorUtilities = require("scripts/utilities/ui/colors")
local MissionBoardViewSettings = require("scripts/ui/views/mission_board_view/mission_board_view_settings")
local DangerSettings = require("scripts/settings/difficulty/danger_settings")
local MissionBoardViewStyles = {}

MissionBoardViewStyles.difficulty_bar_change_function = function (content, style)
	if content.is_locked then
		ColorUtilities.color_copy(MissionBoardViewSettings.color_disabled, style.color, true)
	else
		local max_danger = 5
		local danger_level = 1

		if content.danger then
			danger_level = math.clamp(content.danger, 1, max_danger)
		end

		local danger_color = DangerSettings.by_index[danger_level] and DangerSettings.by_index[danger_level].color or DangerSettings.by_index[1].color

		ColorUtilities.color_copy(danger_color, style.color, true)
	end
end

MissionBoardViewStyles.mission_glow_change_function = function (content, style, animations, dt)
	local color = style.color

	if content.hotspot.is_selected_mission_board then
		color[2] = 250
		color[3] = 189
		color[4] = 73
	elseif content.hotspot.is_hover then
		color[2] = 204
		color[3] = 255
		color[4] = 204
	else
		color[2] = 0
		color[3] = 0
		color[4] = 0
	end
end

MissionBoardViewStyles.update_mission_line = function (content, style)
	if content.is_locked then
		ColorUtilities.color_copy(MissionBoardViewSettings.color_disabled, style.color, true)
	end
end

MissionBoardViewStyles.is_hover_with_locked_change_function = function (content, style)
	local hotspot = content.hotspot
	local is_selected = hotspot.is_selected
	local is_selected_mission_board = hotspot.is_selected_mission_board
	local is_focused = hotspot.is_focused
	local is_hover = hotspot.is_hover
	local disabled = hotspot.disabled
	local default_color = style.default_color
	local hover_color = style.hover_color
	local selected_color = style.selected_color
	local disabled_color = style.disabled_color
	local color

	if disabled and disabled_color then
		color = disabled_color
	elseif (is_selected or is_focused or is_selected_mission_board) and selected_color then
		color = selected_color
	elseif is_hover and hover_color then
		color = hover_color
	elseif default_color then
		color = default_color
	end

	if color then
		ColorUtilities.color_copy(color, style.color)
	end
end

MissionBoardViewStyles.is_locked_change_function = function (content, style)
	if content.is_locked then
		ColorUtilities.color_copy(MissionBoardViewSettings.color_disabled, style.color, true)
	end
end

local function _get_color_by_name(color_name, mission_type)
	if not mission_type then
		return MissionBoardViewSettings[color_name]
	end

	return MissionBoardViewSettings.colors_by_mission_type[mission_type][color_name] or MissionBoardViewSettings[color_name]
end

MissionBoardViewStyles.timer_logic = function (pass, ui_renderer, logic_style, content, position, size)
	local t0, t1 = content.start_game_time, content.expiry_game_time

	if t0 and t1 then
		local style = logic_style.parent
		local t = Managers.time:time("main")

		style.timer_bar.material_values.progress = 1 - math.max(0, t - t0) / (t1 - t0)

		local time_left = math.max(0, t1 - t)
		local seconds = time_left % 60
		local minutes = math.floor(time_left / 60)

		content.timer_text = string.format("%02d:%02d", minutes, seconds)
	end
end

local function _apply_difficulty_scale(vector_like_table)
	local scale_factor = 2

	vector_like_table[1] = vector_like_table[1] * scale_factor
	vector_like_table[2] = vector_like_table[2] * scale_factor

	return vector_like_table
end

MissionBoardViewStyles.screen_decorations_widget_style = {
	overlay = {
		color = {
			75,
			0,
			0,
			0,
		},
		offset = {
			0,
			0,
			-1,
		},
	},
	overlay_top = {
		color = {
			0,
			0,
			0,
			0,
		},
		offset = {
			0,
			0,
			500,
		},
	},
	corner_right = {
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
	},
}
MissionBoardViewStyles.planet_widget_style = {
	title = {
		drop_shadow = true,
		font_size = 55,
		font_type = "machine_medium",
		material = "content/ui/materials/font_gradients/slug_font_gradient_header",
		text_color = MissionBoardViewSettings.color_text_title,
	},
}
MissionBoardViewStyles.happening_widget_style = {
	background = {
		color = {
			0,
			0,
			0,
			0,
		},
	},
	gradient = {
		color = {
			0,
			54,
			78,
			40,
		},
		offset = {
			0,
			0,
			2,
		},
	},
	frame = {
		scale_to_material = true,
		color = {
			0,
			221,
			172,
			38,
		},
		offset = {
			0,
			0,
			1,
		},
	},
	icon = {
		drop_shadow = true,
		color = MissionBoardViewSettings.color_accent,
		offset = {
			10,
			8,
			3,
		},
		size = {
			36,
			36,
		},
	},
	title = {
		drop_shadow = true,
		font_size = 20,
		font_type = "proxima_nova_bold",
		text_color = MissionBoardViewSettings.color_accent,
		offset = {
			60,
			4,
			4,
		},
	},
	subtitle = {
		drop_shadow = true,
		font_size = 18,
		font_type = "proxima_nova_bold",
		text_color = MissionBoardViewSettings.color_text_body,
		offset = {
			60,
			25,
			5,
		},
	},
}
MissionBoardViewStyles.detail_widget_style = {
	background = {
		color = {
			200,
			0,
			0,
			0,
		},
	},
	timer_frame = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_frame,
		offset = {
			0,
			0,
			2,
		},
	},
	timer_bar = {
		horizontal_alignment = "right",
		vertical_alignment = "center",
		color = MissionBoardViewSettings.color_accent,
		offset = {
			-12,
			0,
			2,
		},
		size = {
			nil,
			10,
		},
		size_addition = {
			-115,
			0,
		},
		material_values = {
			progress = 0.75,
		},
	},
	timer_hourglass = {
		color = MissionBoardViewSettings.color_gray,
		size = {
			24,
			24,
		},
		offset = {
			7,
			8,
			2,
		},
	},
	timer_text = {
		font_size = 20,
		font_type = "proxima_nova_bold",
		horizontal_alignment = "left",
		text_vertical_alignment = "center",
		text_color = MissionBoardViewSettings.color_gray,
		offset = {
			35,
			0,
			2,
		},
	},
	header_frame = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_frame,
		offset = {
			0,
			0,
			1,
		},
	},
	header_title = {
		drop_shadow = true,
		font_size = 28,
		font_type = "proxima_nova_bold",
		text_vertical_alignment = "center",
		text_color = MissionBoardViewSettings.color_text_title,
		offset = {
			20,
			-10,
			2,
		},
	},
	header_subtitle = {
		drop_shadow = true,
		font_size = 18,
		font_type = "proxima_nova_bold",
		text_vertical_alignment = "center",
		text_color = MissionBoardViewSettings.color_text_body,
		offset = {
			20,
			16,
			3,
		},
	},
	bonus_title = {
		font_size = 18,
		font_type = "proxima_nova_bold",
		text_horizontal_alignment = "left",
		text_vertical_alignment = "top",
		text_color = MissionBoardViewSettings.color_text_body,
		offset = {
			20,
			10,
			2,
		},
	},
	bonus_text = {
		font_size = 22,
		font_type = "proxima_nova_bold",
		line_spacing = 1.5,
		text_horizontal_alignment = "left",
		text_vertical_alignment = "top",
		text_color = MissionBoardViewSettings.color_text_body,
		offset = {
			85,
			50,
			2,
		},
	},
	difficulty_icon = {
		horizontal_alignment = "center",
		vertical_alignment = "center",
		color = MissionBoardViewSettings.color_main,
		size = _apply_difficulty_scale({
			23,
			23,
		}),
		offset = _apply_difficulty_scale({
			-20,
			0,
			3,
		}),
	},
	difficulty_bar_1 = {
		horizontal_alignment = "center",
		vertical_alignment = "center",
		default_color = DangerSettings.by_index[1].color,
		color = DangerSettings.by_index[1].color,
		color_disabled = MissionBoardViewSettings.color_disabled,
		size = _apply_difficulty_scale({
			6,
			16,
		}),
		offset = _apply_difficulty_scale({
			-1,
			0,
			3,
		}),
	},
	difficulty_bar_2 = {
		horizontal_alignment = "center",
		vertical_alignment = "center",
		default_color = DangerSettings.by_index[1].color,
		color = DangerSettings.by_index[1].color,
		color_disabled = MissionBoardViewSettings.color_disabled,
		size = _apply_difficulty_scale({
			6,
			16,
		}),
		offset = _apply_difficulty_scale({
			8,
			0,
			3,
		}),
	},
	difficulty_bar_3 = {
		horizontal_alignment = "center",
		vertical_alignment = "center",
		default_color = DangerSettings.by_index[1].color,
		color = DangerSettings.by_index[1].color,
		color_disabled = MissionBoardViewSettings.color_disabled,
		size = _apply_difficulty_scale({
			6,
			16,
		}),
		offset = _apply_difficulty_scale({
			17,
			0,
			3,
		}),
	},
	difficulty_bar_4 = {
		horizontal_alignment = "center",
		vertical_alignment = "center",
		default_color = DangerSettings.by_index[1].color,
		color = DangerSettings.by_index[1].color,
		color_disabled = MissionBoardViewSettings.color_disabled,
		size = _apply_difficulty_scale({
			6,
			16,
		}),
		offset = _apply_difficulty_scale({
			26,
			0,
			3,
		}),
	},
	difficulty_bar_5 = {
		horizontal_alignment = "center",
		vertical_alignment = "center",
		default_color = DangerSettings.by_index[1].color,
		color = DangerSettings.by_index[1].color,
		color_disabled = MissionBoardViewSettings.color_disabled,
		size = _apply_difficulty_scale({
			6,
			16,
		}),
		offset = _apply_difficulty_scale({
			35,
			0,
			3,
		}),
	},
	location_frame = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_frame,
		offset = {
			0,
			0,
			2,
		},
	},
	location_image = {
		material_values = {
			texture_map = "content/ui/textures/missions/quickplay",
		},
	},
	location_vignette = {
		scale_to_material = true,
		color = {
			255,
			0,
			0,
			0,
		},
		offset = {
			0,
			0,
			1,
		},
	},
	location_lock = {
		drop_shadow = false,
		font_size = 160,
		font_type = "itc_novarese_bold",
		text_horizontal_alignment = "center",
		text_vertical_alignment = "center",
		text_color = MissionBoardViewSettings.color_background,
		offset = {
			0,
			-40,
			3,
		},
	},
	circumstance_frame = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_frame,
		offset = {
			0,
			0,
			2,
		},
	},
	circumstance_detail = {
		color = MissionBoardViewSettings.color_accent,
		offset = {
			0,
			0,
			1,
		},
		size = {
			6,
		},
	},
	circumstance_icon = {
		horizontal_alignment = "left",
		vertical_alignment = "top",
		color = MissionBoardViewSettings.color_accent,
		size = {
			40,
			40,
		},
		offset = {
			20,
			10,
			3,
		},
	},
	circumstance_label = {
		font_size = 18,
		font_type = "proxima_nova_bold",
		text_horizontal_alignment = "right",
		text_vertical_alignment = "bottom",
		text_color = MissionBoardViewSettings.color_gray,
		offset = {
			-12,
			-5,
			5,
		},
	},
	circumstance_name = {
		font_size = 20,
		font_type = "proxima_nova_bold",
		text_color = MissionBoardViewSettings.color_accent,
		offset = {
			75,
			10,
			4,
		},
		size_addition = {
			-85,
			0,
		},
		size = {},
	},
	circumstance_description = {
		font_size = 18,
		font_type = "proxima_nova_bold",
		line_spacing = 1,
		text_color = MissionBoardViewSettings.color_text_body,
		offset = {
			75,
			30,
			6,
		},
		size = {},
		size_addition = {
			-85,
			0,
		},
	},
	maelstrom_background = {
		size = {
			nil,
			40,
		},
		color = Color.black(76.5, true),
		offset = {
			0,
			-40,
			6,
		},
	},
	maelstrom_text = {
		font_size = 20,
		font_type = "proxima_nova_bold",
		text_horizontal_alignment = "center",
		text_vertical_alignment = "center",
		offset = {
			0,
			-40,
			7,
		},
		size = {
			nil,
			40,
		},
		text_color = MissionBoardViewSettings.color_accent,
	},
	unlock_text_background = {
		color = Color.black(76.5, true),
		size = {
			nil,
			40,
		},
		offset = {
			0,
			0,
			6,
		},
	},
	unlock_text = {
		font_size = 18,
		font_type = "proxima_nova_bold",
		text_horizontal_alignment = "left",
		text_vertical_alignment = "center",
		offset = {
			20,
			0,
			7,
		},
		size = {
			nil,
			40,
		},
		size_addition = {
			-10,
			0,
		},
		text_color = MissionBoardViewSettings.color_accent_light,
	},
}
MissionBoardViewStyles.objective_widget_style = {
	background = {
		color = MissionBoardViewSettings.color_background,
	},
	header_gradient = {
		color = MissionBoardViewSettings.color_green_faded,
		color_main = MissionBoardViewSettings.color_green_faded,
		color_side = MissionBoardViewSettings.color_green_faded,
	},
	header_frame = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_frame,
		offset = {
			0,
			0,
			1,
		},
	},
	header_icon = {
		color = MissionBoardViewSettings.color_terminal_text_header,
		offset = {
			20,
			16,
			2,
		},
		size = {
			36,
			36,
		},
	},
	header_title = {
		font_size = 16,
		font_type = "proxima_nova_bold",
		text_color = MissionBoardViewSettings.color_text_body,
		offset = {
			70,
			13,
			3,
		},
		size_addition = {
			-90,
			0,
		},
	},
	header_subtitle = {
		font_size = 20,
		font_type = "proxima_nova_bold",
		text_color = MissionBoardViewSettings.color_text_title,
		offset = {
			70,
			33,
			4,
		},
		size_addition = {
			-90,
			0,
		},
	},
	body_background = {
		color = MissionBoardViewSettings.color_dark_opacity,
	},
	body_frame = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_frame,
		offset = {
			0,
			0,
			2,
		},
	},
	body_text = {
		font_size = 18,
		font_type = "proxima_nova_bold",
		line_spacing = 1.2,
		text_color = MissionBoardViewSettings.color_text_body,
		offset = {
			20,
			80,
			1,
		},
		size_addition = {
			-40,
			0,
		},
	},
	reward_background = {
		color = {
			175,
			0,
			0,
			0,
		},
	},
	reward_gradient = {
		color = {
			32,
			169,
			211,
			158,
		},
		offset = {
			0,
			0,
			1,
		},
	},
	reward_frame = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_frame,
		offset = {
			0,
			0,
			2,
		},
	},
	reward_icon = {
		horizontal_alignment = "right",
		vertical_alignment = "center",
		size = {
			28,
			20,
		},
		offset = {
			0,
			0,
			3,
		},
	},
	reward_text = {
		font_size = 22,
		font_type = "proxima_nova_bold",
		text_horizontal_alignment = "right",
		text_vertical_alignment = "center",
		text_color = MissionBoardViewSettings.color_text_body,
		offset = {
			-28,
			0,
			3,
		},
	},
	speaker_frame = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_frame,
		offset = {
			0,
			0,
			1,
		},
	},
	speaker_corner = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_corner,
		offset = {
			0,
			0,
			2,
		},
	},
	speaker_icon = {
		offset = {
			0,
			0,
			0,
		},
	},
	speaker_text = {
		font_size = 18,
		font_type = "proxima_nova_bold",
		text_horizontal_alignment = "right",
		text_vertical_alignment = "bottom",
		text_color = MissionBoardViewSettings.color_gray,
		offset = {
			-38,
			-3,
			5,
		},
	},
}
MissionBoardViewStyles.difficulty_stepper_window_widget_style = {
	background = {
		color = MissionBoardViewSettings.color_dark_opacity,
		offset = {
			0,
			0,
			-1,
		},
	},
	frame = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_frame,
		offset = {
			0,
			0,
			1,
		},
	},
	glow = {
		horizontal_alignment = "center",
		scale_to_material = true,
		vertical_alignment = "center",
		color = {
			128,
			169,
			211,
			158,
		},
		offset = {
			0,
			0,
			-1,
		},
		size_addition = {
			24,
			24,
		},
	},
	header_gradient = {
		color = MissionBoardViewSettings.color_green_faded,
	},
	header_frame = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_frame,
		offset = {
			0,
			0,
			1,
		},
	},
	header_title = {
		font_size = 20,
		font_type = "proxima_nova_bold",
		text_color = MissionBoardViewSettings.color_text_title,
		offset = {
			12,
			7,
			2,
		},
	},
}
MissionBoardViewStyles.game_settings_widget_style = {
	background = {
		color = MissionBoardViewSettings.color_background,
	},
	frame = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_frame,
		offset = {
			0,
			0,
			1,
		},
	},
	glow = {
		horizontal_alignment = "center",
		scale_to_material = true,
		vertical_alignment = "center",
		color = Color.terminal_corner_selected(255, true),
		offset = {
			0,
			0,
			-1,
		},
		size_addition = {
			24,
			24,
		},
	},
	header_gradient = {
		color = {
			200,
			169,
			211,
			158,
		},
	},
	header_frame = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_frame,
		offset = {
			0,
			0,
			1,
		},
	},
	header_title = {
		font_size = 28,
		font_type = "proxima_nova_bold",
		text_color = MissionBoardViewSettings.color_main,
		offset = {
			15,
			3,
			2,
		},
	},
}
MissionBoardViewStyles.info_box_widget_style = {
	background = {
		color = MissionBoardViewSettings.color_dark_opacity,
	},
	frame = {
		scale_to_material = true,
		color = {
			0,
			0,
			0,
			0,
		},
		color_info = MissionBoardViewSettings.color_accent,
		color_warning = MissionBoardViewSettings.color_frame,
		offset = {
			0,
			0,
			1,
		},
	},
	text = {
		font_size = 18,
		font_type = "proxima_nova_bold",
		text_horizontal_alignment = "center",
		text_vertical_alignment = "center",
		text_color = MissionBoardViewSettings.color_text_body,
		offset = {
			0,
			0,
			2,
		},
		size_addition = {
			-10,
			0,
		},
	},
}
MissionBoardViewStyles.play_team_button_legend = {
	text = {
		font_size = 18,
		font_type = "proxima_nova_bold",
		text_horizontal_alignment = "center",
		text_vertical_alignment = "center",
		text_color = MissionBoardViewSettings.color_text_body,
		offset = {
			0,
			50,
			2,
		},
	},
}
MissionBoardViewStyles.search_text_style = {
	text = {
		font_size = 42,
		font_type = "proxima_nova_bold",
		text_horizontal_alignment = "center",
		text_vertical_alignment = "center",
		text_color = MissionBoardViewSettings.color_main,
		offset = {
			0,
			0,
			2,
		},
	},
}
MissionBoardViewStyles.mission_widget_style = {
	background = {
		color = MissionBoardViewSettings.color_background,
	},
	fluff_frame = {
		horizontal_alignment = "center",
		vertical_alignment = "center",
		size = {
			160,
			184,
		},
	},
	glow = {
		horizontal_alignment = "center",
		scale_to_material = true,
		vertical_alignment = "center",
		color = {
			255,
			0,
			0,
			0,
		},
		offset = {
			0,
			0,
			-1,
		},
		size_addition = {
			24,
			24,
		},
	},
	timer_frame = {
		horizontal_alignment = "center",
		scale_to_material = true,
		vertical_alignment = "center",
		color = MissionBoardViewSettings.color_frame,
		size_addition = {
			4,
			4,
		},
		offset = {
			0,
			0,
			2,
		},
	},
	timer_bar = {
		color = MissionBoardViewSettings.color_accent,
		offset = {
			0,
			0,
			1,
		},
		material_values = {
			progress = 0.1,
		},
	},
	timer_hourglass = {
		color = MissionBoardViewSettings.color_main,
		size = {
			19,
			19,
		},
		offset = {
			-79,
			-6,
			2,
		},
	},
	timer_text = {
		drop_shadow = true,
		font_size = 20,
		font_type = "proxima_nova_bold",
		horizontal_alignment = "left",
		vertical_alignment = "center",
		text_color = MissionBoardViewSettings.color_main,
		offset = {
			-60,
			-5,
			2,
		},
	},
	difficulty_frame = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_frame,
		offset = {
			0,
			0,
			1,
		},
	},
	difficulty_icon = {
		horizontal_alignment = "center",
		vertical_alignment = "center",
		color = MissionBoardViewSettings.color_main,
		size = {
			23,
			23,
		},
		offset = {
			-26,
			0,
			3,
		},
	},
	difficulty_bar_1 = {
		horizontal_alignment = "center",
		vertical_alignment = "center",
		color = DangerSettings.by_index[1].color,
		size = {
			6,
			16,
		},
		offset = {
			-5,
			0,
			3,
		},
	},
	difficulty_bar_2 = {
		horizontal_alignment = "center",
		vertical_alignment = "center",
		color = DangerSettings.by_index[1].color,
		size = {
			6,
			16,
		},
		offset = {
			4,
			0,
			3,
		},
	},
	difficulty_bar_3 = {
		horizontal_alignment = "center",
		vertical_alignment = "center",
		color = DangerSettings.by_index[1].color,
		size = {
			6,
			16,
		},
		offset = {
			13,
			0,
			3,
		},
	},
	difficulty_bar_4 = {
		horizontal_alignment = "center",
		vertical_alignment = "center",
		color = DangerSettings.by_index[1].color,
		size = {
			6,
			16,
		},
		offset = {
			22,
			0,
			3,
		},
	},
	difficulty_bar_5 = {
		horizontal_alignment = "center",
		vertical_alignment = "center",
		color = DangerSettings.by_index[1].color,
		size = {
			6,
			16,
		},
		offset = {
			31,
			0,
			3,
		},
	},
	location_image = {
		material_values = {
			texture_map = "content/ui/textures/missions/quickplay",
		},
	},
	location_rect = {
		visible = false,
		offset = {
			0,
			0,
			1,
		},
		color = {
			200,
			0,
			0,
			0,
		},
	},
	location_vignette = {
		scale_to_material = true,
		color = {
			255,
			0,
			0,
			0,
		},
		offset = {
			0,
			0,
			1,
		},
	},
	location_frame = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_frame,
		offset = {
			0,
			0,
			3,
		},
	},
	location_corner = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_corner,
		offset = {
			0,
			0,
			4,
		},
	},
	location_decoration = {
		horizontal_alignment = "center",
		vertical_alignment = "top",
		color = MissionBoardViewSettings.color_main,
		size = {
			60,
			20,
		},
		offset = {
			0,
			-3,
			5,
		},
	},
	location_lock = {
		drop_shadow = false,
		font_size = 80,
		font_type = "itc_novarese_bold",
		text_horizontal_alignment = "center",
		text_vertical_alignment = "center",
		text_color = MissionBoardViewSettings.color_background,
		offset = {
			0,
			0,
			10,
		},
	},
	objective_corner = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_corner,
		offset = {
			0,
			0,
			2,
		},
	},
	objective_1_icon = {
		horizontal_alignment = "center",
		vertical_alignment = "center",
		color = MissionBoardViewSettings.color_terminal_text_header,
		offset = {
			0,
			0,
			3,
		},
		size_addition = {
			-5,
			-5,
		},
	},
	objective_2_icon = {
		horizontal_alignment = "center",
		vertical_alignment = "center",
		color = MissionBoardViewSettings.color_gray,
		offset = {
			0,
			0,
			3,
		},
		size_addition = {
			-10,
			-10,
		},
	},
	circumstance_corner = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_accent,
		offset = {
			0,
			0,
			2,
		},
	},
	circumstance_icon = {
		horizontal_alignment = "center",
		vertical_alignment = "center",
		color = MissionBoardViewSettings.color_accent,
		offset = {
			0,
			0,
			3,
		},
		size_addition = {
			-5,
			-5,
		},
	},
	title_gradient = {
		color = {
			255,
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
			-2,
			-1,
		},
	},
	title_text = {
		font_size = 22,
		font_type = "proxima_nova_bold",
		text_horizontal_alignment = "right",
		text_vertical_alignment = "center",
		text_color = MissionBoardViewSettings.color_text_body,
		offset = {
			-20,
			2,
			2,
		},
	},
	title_flash_icon = {
		drop_shadow = true,
		horizontal_alignment = "right",
		vertical_alignment = "center",
		size = {
			70,
			70,
		},
		offset = {
			0,
			-90,
			50,
		},
		color = MissionBoardViewSettings.color_accent,
	},
	bonus_text = {
		font_size = 22,
		font_type = "proxima_nova_bold",
		text_horizontal_alignment = "right",
		text_vertical_alignment = "center",
		text_color = MissionBoardViewSettings.color_text_body,
		offset = {
			0,
			0,
			2,
		},
	},
	mission_line = {
		horizontal_alignment = "center",
		vertical_alignment = "top",
		color = Color.terminal_frame(130, true),
		offset = {
			0,
			100,
			-5,
		},
		size = {
			2,
			300,
		},
		size_addition = {
			0,
			0,
		},
	},
	mission_completed_icon = {
		horizontal_alignment = "center",
		vertical_alignment = "top",
		color = Color.terminal_frame(255, true),
		offset = {
			0,
			130,
			4,
		},
		size = {
			82,
			52,
		},
		size_addition = {
			0,
			0,
		},
	},
}
MissionBoardViewStyles.difficulty_stepper_style = {
	danger = {
		color = MissionBoardViewSettings.color_main,
	},
}

MissionBoardViewStyles.screen_decorations_widget_style_function = function (mission_type)
	return {
		overlay = {
			color = {
				75,
				0,
				0,
				0,
			},
			offset = {
				0,
				0,
				-1,
			},
		},
		overlay_top = {
			color = {
				0,
				0,
				0,
				0,
			},
			offset = {
				0,
				0,
				500,
			},
		},
		corner_right = {
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
		},
	}
end

MissionBoardViewStyles.planet_widget_style_function = function (mission_type)
	local material_color = "content/ui/materials/font_gradients/slug_font_gradient_header"
	local color = _get_color_by_name("color_text_title", mission_type)

	if mission_type == "auric" then
		material_color = "content/ui/materials/font_gradients/slug_font_gradient_gold"
		color = Color.white(255, true)
	end

	return {
		title = {
			drop_shadow = true,
			font_size = 50,
			font_type = "machine_medium",
			text_color = color,
			material = material_color,
		},
	}
end

MissionBoardViewStyles.happening_widget_style_function = function (mission_type)
	return {
		background = {
			color = {
				0,
				0,
				0,
				0,
			},
		},
		gradient = {
			color = {
				0,
				54,
				78,
				40,
			},
			offset = {
				0,
				0,
				2,
			},
		},
		frame = {
			scale_to_material = true,
			color = {
				0,
				221,
				172,
				38,
			},
			offset = {
				0,
				0,
				1,
			},
		},
		icon = {
			drop_shadow = true,
			color = _get_color_by_name("color_accent", mission_type),
			offset = {
				10,
				8,
				3,
			},
			size = {
				36,
				36,
			},
		},
		title = {
			drop_shadow = true,
			font_size = 20,
			font_type = "proxima_nova_bold",
			text_color = _get_color_by_name("color_accent", mission_type),
			offset = {
				60,
				4,
				4,
			},
		},
		subtitle = {
			drop_shadow = true,
			font_size = 18,
			font_type = "proxima_nova_bold",
			text_color = _get_color_by_name("color_text_body", mission_type),
			offset = {
				60,
				25,
				5,
			},
		},
	}
end

MissionBoardViewStyles.detail_widget_style_function = function (mission_type)
	local t = {
		background = {
			color = {
				200,
				0,
				0,
				0,
			},
		},
		timer_frame = {
			scale_to_material = true,
			color = _get_color_by_name("color_frame", mission_type),
			offset = {
				0,
				0,
				2,
			},
		},
		timer_bar = {
			horizontal_alignment = "right",
			vertical_alignment = "center",
			color = _get_color_by_name("color_main", mission_type),
			offset = {
				-12,
				0,
				2,
			},
			size = {
				nil,
				10,
			},
			size_addition = {
				-115,
				0,
			},
			material_values = {
				progress = 0.75,
			},
		},
		timer_hourglass = {
			color = _get_color_by_name("color_gray", mission_type),
			size = {
				24,
				24,
			},
			offset = {
				8,
				8,
				2,
			},
		},
		timer_text = {
			font_size = 20,
			font_type = "proxima_nova_bold",
			horizontal_alignment = "left",
			text_vertical_alignment = "center",
			text_color = _get_color_by_name("color_gray", mission_type),
			offset = {
				35,
				0,
				2,
			},
		},
		header_frame = {
			scale_to_material = true,
			color = _get_color_by_name("color_frame", mission_type),
			offset = {
				0,
				0,
				1,
			},
		},
		header_title = {
			drop_shadow = true,
			font_size = 24,
			font_type = "proxima_nova_bold",
			text_vertical_alignment = "center",
			text_color = _get_color_by_name("color_text_title", mission_type),
			offset = {
				20,
				-10,
				2,
			},
		},
		header_subtitle = {
			drop_shadow = true,
			font_size = 18,
			font_type = "proxima_nova_bold",
			text_vertical_alignment = "center",
			text_color = _get_color_by_name("color_text_sub_header", mission_type),
			offset = {
				20,
				14,
				3,
			},
		},
		bonus_title = {
			font_size = 18,
			font_type = "proxima_nova_bold",
			text_horizontal_alignment = "left",
			text_vertical_alignment = "top",
			text_color = _get_color_by_name("color_text_body", mission_type),
			offset = {
				20,
				40,
				2,
			},
		},
		bonus_text = {
			font_size = 22,
			font_type = "proxima_nova_bold",
			line_spacing = 1.5,
			text_horizontal_alignment = "left",
			text_vertical_alignment = "top",
			text_color = _get_color_by_name("color_text_body", mission_type),
			offset = {
				85,
				50,
				2,
			},
		},
		difficulty_icon = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = _get_color_by_name("color_main_light", mission_type),
			size = _apply_difficulty_scale({
				18,
				18,
			}),
			offset = _apply_difficulty_scale({
				-16,
				0,
				3,
			}),
		},
		difficulty_bar_1 = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = DangerSettings.by_index[1].color,
			default_color = DangerSettings.by_index[1].color,
			color_disabled = _get_color_by_name("color_disabled", mission_type),
			size = _apply_difficulty_scale({
				5,
				14,
			}),
			offset = _apply_difficulty_scale({
				-2,
				0,
				3,
			}),
		},
		difficulty_bar_2 = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = DangerSettings.by_index[1].color,
			default_color = DangerSettings.by_index[1].color,
			color_disabled = _get_color_by_name("color_disabled", mission_type),
			size = _apply_difficulty_scale({
				5,
				14,
			}),
			offset = _apply_difficulty_scale({
				6,
				0,
				3,
			}),
		},
		difficulty_bar_3 = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = DangerSettings.by_index[1].color,
			default_color = DangerSettings.by_index[1].color,
			color_disabled = _get_color_by_name("color_disabled", mission_type),
			size = _apply_difficulty_scale({
				5,
				14,
			}),
			offset = _apply_difficulty_scale({
				14,
				0,
				3,
			}),
		},
		difficulty_bar_4 = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = DangerSettings.by_index[1].color,
			default_color = DangerSettings.by_index[1].color,
			color_disabled = _get_color_by_name("color_disabled", mission_type),
			size = _apply_difficulty_scale({
				5,
				14,
			}),
			offset = _apply_difficulty_scale({
				22,
				0,
				3,
			}),
		},
		difficulty_bar_5 = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = DangerSettings.by_index[1].color,
			default_color = DangerSettings.by_index[1].color,
			color_disabled = _get_color_by_name("color_disabled", mission_type),
			size = _apply_difficulty_scale({
				5,
				14,
			}),
			offset = _apply_difficulty_scale({
				30,
				0,
				3,
			}),
		},
		location_frame = {
			scale_to_material = true,
			color = _get_color_by_name("color_frame", mission_type),
			offset = {
				0,
				0,
				2,
			},
		},
		location_image = {
			material_values = {
				texture_map = "content/ui/textures/missions/quickplay",
			},
		},
		location_vignette = {
			scale_to_material = true,
			color = {
				255,
				0,
				0,
				0,
			},
			offset = {
				0,
				0,
				1,
			},
		},
		location_lock = {
			drop_shadow = false,
			font_size = 100,
			font_type = "itc_novarese_bold",
			text_horizontal_alignment = "center",
			text_vertical_alignment = "center",
			text_color = _get_color_by_name("color_background", mission_type),
			offset = {
				0,
				-40,
				3,
			},
		},
		circumstance_frame = {
			scale_to_material = true,
			color = _get_color_by_name("color_frame", mission_type),
			offset = {
				0,
				0,
				2,
			},
		},
		circumstance_detail = {
			color = _get_color_by_name("color_accent", mission_type),
			offset = {
				0,
				0,
				1,
			},
			size = {
				6,
			},
		},
		circumstance_icon = {
			horizontal_alignment = "left",
			vertical_alignment = "top",
			color = _get_color_by_name("color_accent", mission_type),
			size = {
				40,
				40,
			},
			offset = {
				20,
				10,
				3,
			},
		},
		circumstance_label = {
			font_size = 18,
			font_type = "proxima_nova_bold",
			text_horizontal_alignment = "right",
			text_vertical_alignment = "bottom",
			text_color = _get_color_by_name("color_gray", mission_type),
			offset = {
				-12,
				-5,
				5,
			},
		},
		circumstance_name = {
			font_size = 20,
			font_type = "proxima_nova_bold",
			text_color = _get_color_by_name("color_accent", mission_type),
			offset = {
				75,
				10,
				4,
			},
			size_addition = {
				-85,
				0,
			},
			size = {},
		},
		circumstance_description = {
			font_size = 18,
			font_type = "proxima_nova_bold",
			line_spacing = 1,
			text_color = _get_color_by_name("color_text_body", mission_type),
			offset = {
				75,
				30,
				6,
			},
			size = {},
			size_addition = {
				-85,
				0,
			},
		},
		maelstrom_background = {
			size = {
				nil,
				40,
			},
			color = Color.black(76.5, true),
			offset = {
				0,
				-40,
				6,
			},
		},
		maelstrom_text = {
			font_size = 20,
			font_type = "proxima_nova_bold",
			text_horizontal_alignment = "center",
			text_vertical_alignment = "center",
			offset = {
				0,
				-40,
				7,
			},
			size = {
				nil,
				40,
			},
			text_color = MissionBoardViewSettings.color_accent,
		},
		unlock_text_background = {
			color = Color.black(76.5, true),
			size = {
				nil,
				40,
			},
			offset = {
				0,
				0,
				6,
			},
		},
		unlock_text = {
			font_size = 18,
			font_type = "proxima_nova_bold",
			text_horizontal_alignment = "left",
			text_vertical_alignment = "center",
			offset = {
				20,
				0,
				7,
			},
			size = {
				nil,
				40,
			},
			size_addition = {
				-10,
				0,
			},
			text_color = MissionBoardViewSettings.color_accent_light,
		},
	}

	return t
end

MissionBoardViewStyles.objective_widget_style_function = function (mission_type)
	return {
		background = {
			color = _get_color_by_name("color_background", mission_type),
		},
		header_gradient = {
			color = _get_color_by_name("color_green_faded", mission_type),
			color_main = _get_color_by_name("color_green_faded", mission_type),
			color_side = _get_color_by_name("color_green_faded", mission_type),
		},
		header_frame = {
			scale_to_material = true,
			color = _get_color_by_name("color_frame", mission_type),
			offset = {
				0,
				0,
				1,
			},
		},
		header_icon = {
			color = _get_color_by_name("color_main", mission_type),
			offset = {
				20,
				16,
				2,
			},
			size = {
				36,
				36,
			},
		},
		header_title = {
			font_size = 16,
			font_type = "proxima_nova_bold",
			text_color = _get_color_by_name("color_text_sub_header", mission_type),
			offset = {
				70,
				14,
				3,
			},
			size_addition = {
				-90,
				0,
			},
		},
		header_subtitle = {
			font_size = 20,
			font_type = "proxima_nova_bold",
			text_color = _get_color_by_name("color_text_title", mission_type),
			offset = {
				70,
				32,
				4,
			},
			size_addition = {
				-90,
				0,
			},
		},
		body_background = {
			color = _get_color_by_name("color_dark_opacity", mission_type),
		},
		body_frame = {
			scale_to_material = true,
			color = _get_color_by_name("color_frame", mission_type),
			offset = {
				0,
				0,
				2,
			},
		},
		body_text = {
			font_size = 18,
			font_type = "proxima_nova_bold",
			line_spacing = 1.2,
			text_color = _get_color_by_name("color_text_body", mission_type),
			offset = {
				20,
				80,
				1,
			},
			size_addition = {
				-40,
				0,
			},
		},
		reward_background = {
			color = {
				200,
				0,
				0,
				0,
			},
		},
		reward_gradient = {
			color = {
				32,
				169,
				211,
				158,
			},
			offset = {
				0,
				0,
				1,
			},
		},
		reward_frame = {
			scale_to_material = true,
			color = _get_color_by_name("color_frame", mission_type),
			offset = {
				0,
				0,
				2,
			},
		},
		reward_icon = {
			horizontal_alignment = "right",
			vertical_alignment = "center",
			size = {
				28,
				20,
			},
			offset = {
				0,
				0,
				3,
			},
		},
		reward_text = {
			font_size = 20,
			font_type = "proxima_nova_bold",
			text_horizontal_alignment = "right",
			text_vertical_alignment = "center",
			text_color = _get_color_by_name("color_text_body", mission_type),
			offset = {
				-28,
				0,
				3,
			},
		},
		speaker_frame = {
			scale_to_material = true,
			color = _get_color_by_name("color_frame", mission_type),
			offset = {
				0,
				0,
				1,
			},
		},
		speaker_corner = {
			scale_to_material = true,
			color = _get_color_by_name("color_corner", mission_type),
			offset = {
				0,
				0,
				2,
			},
		},
		speaker_icon = {
			offset = {
				0,
				0,
				0,
			},
		},
		speaker_text = {
			font_size = 18,
			font_type = "proxima_nova_bold",
			text_horizontal_alignment = "right",
			text_vertical_alignment = "bottom",
			text_color = _get_color_by_name("color_gray", mission_type),
			offset = {
				-38,
				-3,
				5,
			},
		},
	}
end

MissionBoardViewStyles.difficulty_stepper_window_widget_style_function = function (mission_type)
	return {
		background = {
			color = _get_color_by_name("color_dark_opacity", mission_type),
			offset = {
				0,
				0,
				-1,
			},
		},
		frame = {
			scale_to_material = true,
			color = _get_color_by_name("color_frame", mission_type),
			offset = {
				0,
				0,
				1,
			},
		},
		glow = {
			horizontal_alignment = "center",
			scale_to_material = true,
			vertical_alignment = "center",
			color = {
				128,
				169,
				211,
				158,
			},
			offset = {
				0,
				0,
				-1,
			},
			size_addition = {
				24,
				24,
			},
		},
		header_gradient = {
			color = _get_color_by_name("color_green_faded", mission_type),
		},
		header_frame = {
			scale_to_material = true,
			color = _get_color_by_name("color_frame", mission_type),
			offset = {
				0,
				0,
				1,
			},
		},
		header_title = {
			font_size = 20,
			font_type = "proxima_nova_bold",
			text_color = _get_color_by_name("color_text_title", mission_type),
			offset = {
				12,
				7,
				2,
			},
		},
	}
end

MissionBoardViewStyles.game_settings_widget_style_function = function (mission_type)
	return {
		background = {
			color = _get_color_by_name("color_background", mission_type),
		},
		frame = {
			scale_to_material = true,
			color = _get_color_by_name("color_frame", mission_type),
			offset = {
				0,
				0,
				1,
			},
		},
		glow = {
			horizontal_alignment = "center",
			scale_to_material = true,
			vertical_alignment = "center",
			color = Color.terminal_corner_selected(255, true),
			offset = {
				0,
				0,
				-1,
			},
			size_addition = {
				24,
				24,
			},
		},
		header_gradient = {
			color = {
				200,
				169,
				211,
				158,
			},
		},
		header_frame = {
			scale_to_material = true,
			color = _get_color_by_name("color_frame", mission_type),
			offset = {
				0,
				0,
				1,
			},
		},
		header_title = {
			font_size = 28,
			font_type = "proxima_nova_bold",
			text_color = _get_color_by_name("color_main", mission_type),
			offset = {
				15,
				3,
				2,
			},
		},
	}
end

MissionBoardViewStyles.info_box_widget_style_function = function (mission_type)
	return {
		background = {
			color = {
				150,
				58,
				15,
				15,
			},
		},
		frame = {
			scale_to_material = true,
			color = {
				0,
				0,
				0,
				0,
			},
			color_info = _get_color_by_name("color_accent", mission_type),
			color_warning = Color.ui_interaction_critical(255, true),
			offset = {
				0,
				0,
				1,
			},
		},
		text = {
			font_size = 18,
			font_type = "proxima_nova_bold",
			text_horizontal_alignment = "center",
			text_vertical_alignment = "center",
			text_color = Color.ui_interaction_critical(255, true),
			offset = {
				0,
				0,
				2,
			},
			size_addition = {
				-10,
				0,
			},
		},
	}
end

MissionBoardViewStyles.play_team_button_legend_function = function (mission_type)
	return {
		text = {
			font_size = 18,
			font_type = "proxima_nova_bold",
			text_horizontal_alignment = "center",
			text_vertical_alignment = "center",
			text_color = _get_color_by_name("color_text_body", mission_type),
			offset = {
				0,
				40,
				2,
			},
		},
	}
end

MissionBoardViewStyles.mission_widget_style_function = function (mission_type)
	return {
		background = {
			color = _get_color_by_name("color_background", mission_type),
		},
		fluff_frame = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = {
				80,
				113,
				126,
				103,
			},
			size = {
				160,
				184,
			},
		},
		glow = {
			horizontal_alignment = "center",
			scale_to_material = true,
			vertical_alignment = "center",
			color = {
				255,
				0,
				0,
				0,
			},
			offset = {
				0,
				0,
				-1,
			},
			size_addition = {
				24,
				24,
			},
		},
		timer_frame = {
			horizontal_alignment = "center",
			scale_to_material = true,
			vertical_alignment = "center",
			color = _get_color_by_name("color_frame", mission_type),
			size_addition = {
				4,
				4,
			},
			offset = {
				0,
				0,
				2,
			},
		},
		timer_bar = {
			color = _get_color_by_name("color_main", mission_type),
			offset = {
				0,
				0,
				1,
			},
			material_values = {
				progress = 0.1,
			},
		},
		timer_hourglass = {
			color = _get_color_by_name("color_main", mission_type),
			size = {
				19,
				19,
			},
			offset = {
				-79,
				-7,
				2,
			},
		},
		timer_text = {
			drop_shadow = true,
			font_size = 20,
			font_type = "proxima_nova_bold",
			horizontal_alignment = "left",
			vertical_alignment = "center",
			text_color = _get_color_by_name("color_main", mission_type),
			offset = {
				-60,
				-9,
				2,
			},
		},
		difficulty_frame = {
			scale_to_material = true,
			color = _get_color_by_name("color_frame", mission_type),
			disabled_color = _get_color_by_name("color_disabled", mission_type),
			selected_color = Color.terminal_corner_selected(255, true),
			hover_color = _get_color_by_name("color_main", mission_type),
			default_color = _get_color_by_name("color_frame", mission_type),
			offset = {
				0,
				0,
				1,
			},
		},
		difficulty_corner = {
			scale_to_material = true,
			color = _get_color_by_name("color_corner", mission_type),
			disabled_color = _get_color_by_name("color_disabled", mission_type),
			selected_color = Color.terminal_corner_selected(255, true),
			hover_color = _get_color_by_name("color_main", mission_type),
			default_color = _get_color_by_name("color_corner", mission_type),
			offset = {
				0,
				0,
				2,
			},
		},
		difficulty_icon = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = _get_color_by_name("color_main_light", mission_type),
			size = {
				23,
				23,
			},
			offset = {
				-25,
				0,
				3,
			},
		},
		difficulty_bar_1 = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = DangerSettings.by_index[1].color,
			size = {
				6,
				16,
			},
			offset = {
				-7,
				0,
				3,
			},
		},
		difficulty_bar_2 = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = DangerSettings.by_index[1].color,
			size = {
				6,
				16,
			},
			offset = {
				2,
				0,
				3,
			},
		},
		difficulty_bar_3 = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = DangerSettings.by_index[1].color,
			size = {
				6,
				16,
			},
			offset = {
				11,
				0,
				3,
			},
		},
		difficulty_bar_4 = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = DangerSettings.by_index[1].color,
			size = {
				6,
				16,
			},
			offset = {
				20,
				0,
				3,
			},
		},
		difficulty_bar_5 = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = DangerSettings.by_index[1].color,
			size = {
				6,
				16,
			},
			offset = {
				29,
				0,
				3,
			},
		},
		location_image = {
			material_values = {
				texture_map = "content/ui/textures/missions/quickplay",
			},
		},
		location_rect = {
			visible = false,
			offset = {
				0,
				0,
				1,
			},
			color = {
				200,
				0,
				0,
				0,
			},
		},
		location_vignette = {
			scale_to_material = true,
			color = {
				255,
				0,
				0,
				0,
			},
			offset = {
				0,
				0,
				1,
			},
		},
		location_frame = {
			scale_to_material = true,
			color = _get_color_by_name("color_frame", mission_type),
			disabled_color = _get_color_by_name("color_disabled", mission_type),
			selected_color = Color.terminal_corner_selected(255, true),
			hover_color = _get_color_by_name("color_main", mission_type),
			default_color = _get_color_by_name("color_frame", mission_type),
			offset = {
				0,
				0,
				3,
			},
		},
		location_corner = {
			scale_to_material = true,
			color = _get_color_by_name("color_corner", mission_type),
			disabled_color = _get_color_by_name("color_disabled", mission_type),
			selected_color = Color.terminal_corner_selected(255, true),
			hover_color = _get_color_by_name("color_main", mission_type),
			default_color = _get_color_by_name("color_corner", mission_type),
			offset = {
				0,
				0,
				4,
			},
		},
		location_decoration = {
			horizontal_alignment = "center",
			vertical_alignment = "top",
			color = _get_color_by_name("color_main", mission_type),
			size = {
				60,
				20,
			},
			offset = {
				0,
				-3,
				5,
			},
		},
		location_lock = {
			drop_shadow = false,
			font_size = 50,
			font_type = "itc_novarese_bold",
			text_horizontal_alignment = "center",
			text_vertical_alignment = "center",
			text_color = _get_color_by_name("color_background", mission_type),
			offset = {
				0,
				-4,
				10,
			},
		},
		objective_corner = {
			scale_to_material = true,
			color = _get_color_by_name("color_corner", mission_type),
			disabled_color = _get_color_by_name("color_disabled", mission_type),
			selected_color = Color.terminal_corner_selected(255, true),
			hover_color = _get_color_by_name("color_main", mission_type),
			default_color = _get_color_by_name("color_corner", mission_type),
			offset = {
				0,
				0,
				2,
			},
		},
		objective_1_icon = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = _get_color_by_name("color_text_body", mission_type),
			offset = {
				0,
				0,
				3,
			},
			size_addition = {
				-5,
				-5,
			},
		},
		objective_2_icon = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = _get_color_by_name("color_gray", mission_type),
			offset = {
				0,
				0,
				3,
			},
			size_addition = {
				-10,
				-10,
			},
		},
		circumstance_corner = {
			scale_to_material = true,
			color = _get_color_by_name("color_accent", mission_type),
			disabled_color = _get_color_by_name("color_disabled", mission_type),
			selected_color = Color.terminal_corner_selected(255, true),
			hover_color = _get_color_by_name("color_main", mission_type),
			default_color = _get_color_by_name("color_corner", mission_type),
			offset = {
				0,
				0,
				2,
			},
		},
		circumstance_icon = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = _get_color_by_name("color_accent", mission_type),
			offset = {
				0,
				0,
				3,
			},
			size_addition = {
				-5,
				-5,
			},
		},
		title_gradient = {
			color = {
				255,
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
				-2,
				-1,
			},
		},
		title_background = {
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
				-2,
				-1,
			},
		},
		title_text = {
			font_size = 22,
			font_type = "proxima_nova_bold",
			text_horizontal_alignment = "left",
			text_vertical_alignment = "center",
			text_color = _get_color_by_name("color_text_title", mission_type),
			offset = {
				20,
				0,
				2,
			},
		},
		title_flash_icon = {
			drop_shadow = true,
			horizontal_alignment = "right",
			vertical_alignment = "center",
			size = {
				70,
				70,
			},
			offset = {
				0,
				-90,
				50,
			},
			color = _get_color_by_name("color_accent", mission_type),
		},
		bonus_text = {
			font_size = 18,
			font_type = "proxima_nova_bold",
			text_horizontal_alignment = "center",
			text_vertical_alignment = "center",
			text_color = _get_color_by_name("color_text_body", mission_type),
			offset = {
				0,
				-4,
				2,
			},
		},
		mission_line = {
			horizontal_alignment = "center",
			vertical_alignment = "top",
			color = Color.terminal_frame(130, true),
			offset = {
				0,
				100,
				-5,
			},
			size = {
				2,
				300,
			},
			size_addition = {
				0,
				0,
			},
		},
		mission_completed_icon = {
			horizontal_alignment = "center",
			vertical_alignment = "top",
			color = Color.terminal_frame(255, true),
			offset = {
				0,
				130,
				4,
			},
			size = {
				82,
				52,
			},
			size_addition = {
				0,
				0,
			},
		},
	}
end

MissionBoardViewStyles.difficulty_stepper_style_function = function (mission_type)
	return {
		difficulty_bar_1 = {
			color = DangerSettings.by_index[1].color,
		},
		difficulty_bar_2 = {
			color = DangerSettings.by_index[1].color,
		},
		difficulty_bar_3 = {
			color = DangerSettings.by_index[1].color,
		},
		difficulty_bar_4 = {
			color = DangerSettings.by_index[1].color,
		},
		difficulty_bar_5 = {
			color = DangerSettings.by_index[1].color,
		},
		danger = {
			color = _get_color_by_name("color_main_light", mission_type),
		},
	}
end

return settings("MissionBoardViewStyles", MissionBoardViewStyles)
