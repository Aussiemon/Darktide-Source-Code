local ColorUtilities = require("scripts/utilities/ui/colors")
local MissionBoardViewSettings = require("scripts/ui/views/mission_board_view/mission_board_view_settings")
local MissionBoardViewStyles = {
	mission_glow_change_function = function (content, style, animations, dt)
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
	end,
	update_mission_line = function (content, style)
		if content.is_locked then
			ColorUtilities.color_copy(MissionBoardViewSettings.color_disabled, style.color, true)
		end
	end,
	is_locked_change_function = function (content, style)
		if content.is_locked then
			ColorUtilities.color_copy(MissionBoardViewSettings.color_disabled, style.color, true)
		end
	end
}

MissionBoardViewStyles.timer_logic = function (pass, ui_renderer, logic_style, content, position, size)
	local t0 = content.start_game_time
	local t1 = content.expiry_game_time

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
			0
		},
		offset = {
			0,
			0,
			-1
		}
	},
	overlay_top = {
		color = {
			0,
			0,
			0,
			0
		},
		offset = {
			0,
			0,
			500
		}
	},
	corner_right = {
		uvs = {
			{
				1,
				0
			},
			{
				0,
				1
			}
		}
	}
}
MissionBoardViewStyles.planet_widget_style = {
	title = {
		font_type = "machine_medium",
		font_size = 55,
		drop_shadow = true,
		material = "content/ui/materials/font_gradients/slug_font_gradient_header",
		text_color = MissionBoardViewSettings.color_text_title
	}
}
MissionBoardViewStyles.happening_widget_style = {
	background = {
		color = {
			0,
			0,
			0,
			0
		}
	},
	gradient = {
		color = {
			0,
			54,
			78,
			40
		},
		offset = {
			0,
			0,
			2
		}
	},
	frame = {
		scale_to_material = true,
		color = {
			0,
			221,
			172,
			38
		},
		offset = {
			0,
			0,
			1
		}
	},
	icon = {
		drop_shadow = true,
		color = MissionBoardViewSettings.color_accent,
		offset = {
			10,
			8,
			3
		},
		size = {
			36,
			36
		}
	},
	title = {
		font_type = "proxima_nova_bold",
		font_size = 20,
		drop_shadow = true,
		text_color = MissionBoardViewSettings.color_accent,
		offset = {
			60,
			4,
			4
		}
	},
	subtitle = {
		font_type = "proxima_nova_bold",
		font_size = 18,
		drop_shadow = true,
		text_color = MissionBoardViewSettings.color_text_body,
		offset = {
			60,
			25,
			5
		}
	}
}
MissionBoardViewStyles.detail_widget_style = {
	background = {
		color = {
			200,
			0,
			0,
			0
		}
	},
	timer_frame = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_frame,
		offset = {
			0,
			0,
			2
		}
	},
	timer_bar = {
		vertical_alignment = "center",
		horizontal_alignment = "right",
		color = MissionBoardViewSettings.color_accent,
		offset = {
			-12,
			0,
			2
		},
		size = {
			nil,
			10
		},
		size_addition = {
			-115,
			0
		},
		material_values = {
			progress = 0.75
		}
	},
	timer_hourglass = {
		color = MissionBoardViewSettings.color_gray,
		size = {
			24,
			24
		},
		offset = {
			7,
			8,
			2
		}
	},
	timer_text = {
		font_type = "proxima_nova_bold",
		font_size = 20,
		horizontal_alignment = "left",
		text_vertical_alignment = "center",
		text_color = MissionBoardViewSettings.color_gray,
		offset = {
			35,
			0,
			2
		}
	},
	header_frame = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_frame,
		offset = {
			0,
			0,
			1
		}
	},
	header_title = {
		font_type = "proxima_nova_bold",
		font_size = 28,
		drop_shadow = true,
		text_vertical_alignment = "center",
		text_color = MissionBoardViewSettings.color_text_title,
		offset = {
			20,
			-10,
			2
		}
	},
	header_subtitle = {
		font_type = "proxima_nova_bold",
		font_size = 18,
		drop_shadow = true,
		text_vertical_alignment = "center",
		text_color = MissionBoardViewSettings.color_text_body,
		offset = {
			20,
			16,
			3
		}
	},
	difficulty_icon = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		color = MissionBoardViewSettings.color_main,
		size = _apply_difficulty_scale({
			23,
			23
		}),
		offset = _apply_difficulty_scale({
			-20,
			0,
			3
		})
	},
	difficulty_bar_1 = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		color = MissionBoardViewSettings.color_main,
		size = _apply_difficulty_scale({
			6,
			16
		}),
		offset = _apply_difficulty_scale({
			-1,
			0,
			3
		})
	},
	difficulty_bar_2 = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		color = MissionBoardViewSettings.color_main,
		size = _apply_difficulty_scale({
			6,
			16
		}),
		offset = _apply_difficulty_scale({
			8,
			0,
			3
		})
	},
	difficulty_bar_3 = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		color = MissionBoardViewSettings.color_main,
		size = _apply_difficulty_scale({
			6,
			16
		}),
		offset = _apply_difficulty_scale({
			17,
			0,
			3
		})
	},
	difficulty_bar_4 = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		color = MissionBoardViewSettings.color_main,
		size = _apply_difficulty_scale({
			6,
			16
		}),
		offset = _apply_difficulty_scale({
			26,
			0,
			3
		})
	},
	difficulty_bar_5 = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		color = MissionBoardViewSettings.color_main,
		size = _apply_difficulty_scale({
			6,
			16
		}),
		offset = _apply_difficulty_scale({
			35,
			0,
			3
		})
	},
	location_frame = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_frame,
		offset = {
			0,
			0,
			2
		}
	},
	location_image = {
		material_values = {
			texture_map = "content/ui/textures/missions/quickplay"
		}
	},
	location_vignette = {
		scale_to_material = true,
		color = {
			255,
			0,
			0,
			0
		},
		offset = {
			0,
			0,
			1
		}
	},
	location_lock = {
		font_type = "itc_novarese_bold",
		font_size = 160,
		drop_shadow = false,
		text_vertical_alignment = "center",
		text_horizontal_alignment = "center",
		text_color = MissionBoardViewSettings.color_background,
		offset = {
			0,
			-40,
			3
		}
	},
	circumstance_frame = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_frame,
		offset = {
			0,
			0,
			2
		}
	},
	circumstance_detail = {
		color = MissionBoardViewSettings.color_accent,
		offset = {
			0,
			0,
			1
		},
		size = {
			6
		}
	},
	circumstance_icon = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		color = MissionBoardViewSettings.color_accent,
		size = {
			42,
			42
		},
		offset = {
			20,
			15,
			3
		}
	},
	circumstance_label = {
		font_type = "proxima_nova_bold",
		font_size = 18,
		text_vertical_alignment = "bottom",
		text_horizontal_alignment = "right",
		text_color = MissionBoardViewSettings.color_gray,
		offset = {
			-12,
			-5,
			5
		}
	},
	circumstance_name = {
		font_type = "proxima_nova_bold",
		font_size = 20,
		text_color = MissionBoardViewSettings.color_accent,
		offset = {
			75,
			10,
			4
		},
		size_addition = {
			-75,
			-10
		}
	},
	circumstance_description = {
		line_spacing = 1,
		font_size = 18,
		font_type = "proxima_nova_bold",
		text_color = MissionBoardViewSettings.color_text_body,
		offset = {
			75,
			30,
			6
		},
		size_addition = {
			-75,
			-30
		}
	}
}
MissionBoardViewStyles.objective_widget_style = {
	background = {
		color = MissionBoardViewSettings.color_background
	},
	header_gradient = {
		color = MissionBoardViewSettings.color_green_faded,
		color_main = MissionBoardViewSettings.color_green_faded,
		color_side = MissionBoardViewSettings.color_green_faded
	},
	header_frame = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_frame,
		offset = {
			0,
			0,
			1
		}
	},
	header_icon = {
		color = MissionBoardViewSettings.color_terminal_text_header,
		offset = {
			10,
			6,
			2
		},
		size = {
			36,
			36
		}
	},
	header_title = {
		font_size = 16,
		font_type = "proxima_nova_bold",
		text_color = MissionBoardViewSettings.color_text_body,
		offset = {
			60,
			4,
			3
		}
	},
	header_subtitle = {
		font_size = 20,
		font_type = "proxima_nova_bold",
		text_color = MissionBoardViewSettings.color_text_title,
		offset = {
			60,
			20,
			4
		}
	},
	body_background = {
		color = MissionBoardViewSettings.color_dark_opacity
	},
	body_frame = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_frame,
		offset = {
			0,
			0,
			2
		}
	},
	body_text = {
		line_spacing = 1.2,
		font_size = 18,
		font_type = "proxima_nova_bold",
		text_color = MissionBoardViewSettings.color_text_body,
		offset = {
			10,
			52,
			1
		},
		size_addition = {
			-20,
			0
		}
	},
	reward_background = {
		color = {
			175,
			0,
			0,
			0
		}
	},
	reward_gradient = {
		color = {
			32,
			169,
			211,
			158
		},
		offset = {
			0,
			0,
			1
		}
	},
	reward_frame = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_frame,
		offset = {
			0,
			0,
			2
		}
	},
	reward_icon = {
		font_type = "proxima_nova_bold",
		font_size = 22,
		text_vertical_alignment = "center",
		text_horizontal_alignment = "left",
		text_color = MissionBoardViewSettings.color_text_body,
		offset = {
			10,
			0,
			3
		}
	},
	reward_text = {
		font_type = "proxima_nova_bold",
		font_size = 22,
		text_vertical_alignment = "center",
		text_horizontal_alignment = "right",
		text_color = MissionBoardViewSettings.color_text_body,
		offset = {
			-10,
			0,
			3
		}
	},
	speaker_frame = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_frame,
		offset = {
			0,
			0,
			1
		}
	},
	speaker_corner = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_corner,
		offset = {
			0,
			0,
			2
		}
	},
	speaker_icon = {
		offset = {
			0,
			0,
			0
		}
	},
	speaker_text = {
		font_type = "proxima_nova_bold",
		font_size = 18,
		text_vertical_alignment = "bottom",
		text_horizontal_alignment = "right",
		text_color = MissionBoardViewSettings.color_gray,
		offset = {
			-38,
			-3,
			5
		}
	}
}
MissionBoardViewStyles.difficulty_stepper_window_widget_style = {
	background = {
		color = MissionBoardViewSettings.color_dark_opacity,
		offset = {
			0,
			0,
			-1
		}
	},
	frame = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_frame,
		offset = {
			0,
			0,
			1
		}
	},
	glow = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		scale_to_material = true,
		color = {
			128,
			169,
			211,
			158
		},
		offset = {
			0,
			0,
			-1
		},
		size_addition = {
			24,
			24
		}
	},
	header_gradient = {
		color = MissionBoardViewSettings.color_green_faded
	},
	header_frame = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_frame,
		offset = {
			0,
			0,
			1
		}
	},
	header_title = {
		font_size = 20,
		font_type = "proxima_nova_bold",
		text_color = MissionBoardViewSettings.color_text_title,
		offset = {
			12,
			7,
			2
		}
	}
}
MissionBoardViewStyles.game_settings_widget_style = {
	background = {
		color = MissionBoardViewSettings.color_background
	},
	frame = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_frame,
		offset = {
			0,
			0,
			1
		}
	},
	glow = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		scale_to_material = true,
		color = Color.terminal_corner_selected(255, true),
		offset = {
			0,
			0,
			-1
		},
		size_addition = {
			24,
			24
		}
	},
	header_gradient = {
		color = {
			200,
			169,
			211,
			158
		}
	},
	header_frame = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_frame,
		offset = {
			0,
			0,
			1
		}
	},
	header_title = {
		font_size = 28,
		font_type = "proxima_nova_bold",
		text_color = MissionBoardViewSettings.color_main,
		offset = {
			15,
			3,
			2
		}
	}
}
MissionBoardViewStyles.info_box_widget_style = {
	background = {
		color = MissionBoardViewSettings.color_dark_opacity
	},
	frame = {
		scale_to_material = true,
		color = {
			0,
			0,
			0,
			0
		},
		color_info = MissionBoardViewSettings.color_accent,
		color_warning = MissionBoardViewSettings.color_frame,
		offset = {
			0,
			0,
			1
		}
	},
	text = {
		font_type = "proxima_nova_bold",
		font_size = 18,
		text_vertical_alignment = "center",
		text_horizontal_alignment = "center",
		text_color = MissionBoardViewSettings.color_text_body,
		offset = {
			0,
			0,
			2
		},
		size_addition = {
			-10,
			0
		}
	}
}
MissionBoardViewStyles.mission_widget_style = {
	background = {
		color = MissionBoardViewSettings.color_background
	},
	fluff_frame = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		size = {
			160,
			184
		}
	},
	glow = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		scale_to_material = true,
		color = {
			255,
			0,
			0,
			0
		},
		offset = {
			0,
			0,
			-1
		},
		size_addition = {
			24,
			24
		}
	},
	timer_frame = {
		vertical_alignment = "center",
		scale_to_material = true,
		horizontal_alignment = "center",
		color = MissionBoardViewSettings.color_frame,
		size_addition = {
			4,
			4
		},
		offset = {
			0,
			0,
			2
		}
	},
	timer_bar = {
		color = MissionBoardViewSettings.color_accent,
		offset = {
			0,
			0,
			1
		},
		material_values = {
			progress = 0.1
		}
	},
	timer_hourglass = {
		color = MissionBoardViewSettings.color_main,
		size = {
			19,
			19
		},
		offset = {
			-79,
			-6,
			2
		}
	},
	timer_text = {
		vertical_alignment = "center",
		font_size = 20,
		horizontal_alignment = "left",
		drop_shadow = true,
		font_type = "proxima_nova_bold",
		text_color = MissionBoardViewSettings.color_main,
		offset = {
			-60,
			-5,
			2
		}
	},
	difficulty_frame = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_frame,
		offset = {
			0,
			0,
			1
		}
	},
	difficulty_icon = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		color = MissionBoardViewSettings.color_main,
		size = {
			23,
			23
		},
		offset = {
			-26,
			0,
			3
		}
	},
	difficulty_bar_1 = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		color = MissionBoardViewSettings.color_main,
		size = {
			6,
			16
		},
		offset = {
			-5,
			0,
			3
		}
	},
	difficulty_bar_2 = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		color = MissionBoardViewSettings.color_main,
		size = {
			6,
			16
		},
		offset = {
			4,
			0,
			3
		}
	},
	difficulty_bar_3 = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		color = MissionBoardViewSettings.color_main,
		size = {
			6,
			16
		},
		offset = {
			13,
			0,
			3
		}
	},
	difficulty_bar_4 = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		color = MissionBoardViewSettings.color_main,
		size = {
			6,
			16
		},
		offset = {
			22,
			0,
			3
		}
	},
	difficulty_bar_5 = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		color = MissionBoardViewSettings.color_main,
		size = {
			6,
			16
		},
		offset = {
			31,
			0,
			3
		}
	},
	location_image = {
		material_values = {
			texture_map = "content/ui/textures/missions/quickplay"
		}
	},
	location_rect = {
		visible = false,
		offset = {
			0,
			0,
			1
		},
		color = {
			200,
			0,
			0,
			0
		}
	},
	location_vignette = {
		scale_to_material = true,
		color = {
			255,
			0,
			0,
			0
		},
		offset = {
			0,
			0,
			1
		}
	},
	location_frame = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_frame,
		offset = {
			0,
			0,
			3
		}
	},
	location_corner = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_corner,
		offset = {
			0,
			0,
			4
		}
	},
	location_decoration = {
		vertical_alignment = "top",
		horizontal_alignment = "center",
		color = MissionBoardViewSettings.color_main,
		size = {
			60,
			20
		},
		offset = {
			0,
			-3,
			5
		}
	},
	location_lock = {
		font_type = "itc_novarese_bold",
		font_size = 80,
		drop_shadow = false,
		text_vertical_alignment = "center",
		text_horizontal_alignment = "center",
		text_color = MissionBoardViewSettings.color_background,
		offset = {
			0,
			0,
			10
		}
	},
	objective_corner = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_corner,
		offset = {
			0,
			0,
			2
		}
	},
	objective_1_icon = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		color = MissionBoardViewSettings.color_terminal_text_header,
		offset = {
			0,
			0,
			3
		},
		size_addition = {
			-5,
			-5
		}
	},
	objective_2_icon = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		color = MissionBoardViewSettings.color_gray,
		offset = {
			0,
			0,
			3
		},
		size_addition = {
			-10,
			-10
		}
	},
	circumstance_corner = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_accent,
		offset = {
			0,
			0,
			2
		}
	},
	circumstance_icon = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		color = MissionBoardViewSettings.color_accent,
		offset = {
			0,
			0,
			3
		},
		size_addition = {
			-5,
			-5
		}
	},
	title_gradient = {
		color = {
			255,
			0,
			0,
			0
		},
		offset = {
			0,
			0,
			1
		},
		size_addition = {
			-2,
			-1
		}
	},
	title_text = {
		font_type = "proxima_nova_bold",
		font_size = 22,
		text_vertical_alignment = "center",
		text_horizontal_alignment = "right",
		text_color = MissionBoardViewSettings.color_text_body,
		offset = {
			-20,
			2,
			2
		}
	},
	title_flash_icon = {
		vertical_alignment = "center",
		drop_shadow = true,
		horizontal_alignment = "right",
		size = {
			70,
			70
		},
		offset = {
			0,
			-90,
			50
		},
		color = MissionBoardViewSettings.color_accent
	},
	mission_line = {
		vertical_alignment = "top",
		horizontal_alignment = "center",
		color = Color.terminal_frame(130, true),
		offset = {
			0,
			100,
			-5
		},
		size = {
			2,
			300
		},
		size_addition = {
			0,
			0
		}
	},
	mission_completed_icon = {
		vertical_alignment = "top",
		horizontal_alignment = "center",
		color = Color.terminal_frame(255, true),
		offset = {
			0,
			130,
			4
		},
		size = {
			82,
			52
		},
		size_addition = {
			0,
			0
		}
	}
}

return settings("MissionBoardViewStyles", MissionBoardViewStyles)
