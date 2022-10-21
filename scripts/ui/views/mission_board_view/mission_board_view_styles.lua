local ColorUtilities = require("scripts/utilities/ui/colors")
local MissionBoardViewSettings = require("scripts/ui/views/mission_board_view/mission_board_view_settings")
local MissionBoardViewStyles = {
	mission_glow_change_function = function (content, style, animations, dt)
		local color = style.color

		if content.hotspot.is_selected then
			color[2] = 0
			color[3] = 204
			color[4] = 0
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
	is_locked_change_function = function (content, style)
		if content.is_locked then
			ColorUtilities.color_copy(MissionBoardViewSettings.color_disabled, style.color, true)
		end
	end,
	objective_gradient_change_function = function (content, style)
		style.color = content.is_side and style.color_main or style.color_side
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

MissionBoardViewStyles.play_button_widget_logic = function (pass, ui_renderer, logic_style, content, position, size)
	local style = logic_style.parent
	local hotspot = content.hotspot
	local uvs = style.gradient.uvs

	if hotspot.is_held then
		uvs[2][2] = 0
		uvs[1][2] = 1

		ColorUtilities.color_copy(style.background_selected.color_held, style.background_selected.color, true)
		ColorUtilities.color_copy(style.text.text_color_held, style.text.text_color, true)
	else
		uvs[2][2] = 1
		uvs[1][2] = 0

		if hotspot.is_hover then
			ColorUtilities.color_copy(style.background_selected.color_hover, style.background_selected.color, true)
			ColorUtilities.color_copy(style.text.text_color_hover, style.text.text_color, true)
		else
			ColorUtilities.color_copy(style.background_selected.color_default, style.background_selected.color, true)
			ColorUtilities.color_copy(style.text.text_color_default, style.text.text_color, true)
		end
	end
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
		font_size = 38,
		font_type = "itc_novarese_bold",
		text_color = Color.terminal_icon(nil, true)
	}
}
MissionBoardViewStyles.happening_widget_style = {
	background = {
		color = MissionBoardViewSettings.color_background
	},
	gradient = {
		color = {
			100,
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
	frame = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_frame,
		offset = {
			0,
			0,
			2
		}
	},
	icon = {
		color = MissionBoardViewSettings.color_main,
		offset = {
			10,
			5,
			3
		},
		size = {
			40,
			40
		}
	},
	title = {
		font_size = 18,
		font_type = "proxima_nova_bold",
		text_color = MissionBoardViewSettings.color_gray,
		offset = {
			60,
			5,
			4
		}
	},
	subtitle = {
		font_size = 20,
		font_type = "itc_novarese_bold",
		text_color = MissionBoardViewSettings.color_main,
		offset = {
			60,
			25,
			5
		}
	}
}
MissionBoardViewStyles.detail_widget_style = {
	background = {
		color = MissionBoardViewSettings.color_background
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
		color = MissionBoardViewSettings.color_main,
		size = {
			19,
			19
		},
		offset = {
			10,
			10,
			2
		}
	},
	timer_text = {
		font_type = "itc_novarese_bold",
		font_size = 24,
		horizontal_alignment = "left",
		text_vertical_alignment = "center",
		text_color = MissionBoardViewSettings.color_main,
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
			2
		}
	},
	header_title = {
		font_type = "proxima_nova_bold",
		font_size = 24,
		drop_shadow = true,
		text_vertical_alignment = "center",
		text_color = MissionBoardViewSettings.color_main,
		offset = {
			20,
			-12,
			2
		}
	},
	header_subtitle = {
		font_type = "proxima_nova_medium",
		font_size = 20,
		drop_shadow = true,
		text_vertical_alignment = "center",
		text_color = MissionBoardViewSettings.color_frame,
		offset = {
			20,
			12,
			2
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
			5,
			18
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
			5,
			18
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
			5,
			18
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
			5,
			18
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
			5,
			18
		}),
		offset = _apply_difficulty_scale({
			35,
			0,
			3
		})
	},
	location_image = {
		material_values = {
			texture_map = "content/ui/textures/missions/cm_habs_big"
		}
	},
	location_vignette = {
		scale_to_material = true,
		color = {
			255,
			16,
			32,
			1
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
			2
		}
	}
}
MissionBoardViewStyles.objective_widget_style = {
	background = {
		color = MissionBoardViewSettings.color_background
	},
	header_gradient = {
		color = {
			0,
			0,
			0,
			0
		},
		color_main = {
			100,
			169,
			211,
			158
		},
		color_side = {
			100,
			66,
			79,
			64
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
	header_icon = {
		color = MissionBoardViewSettings.color_main,
		offset = {
			10,
			5,
			1
		},
		size = {
			40,
			40
		}
	},
	header_title = {
		font_size = 18,
		font_type = "proxima_nova_bold",
		text_color = MissionBoardViewSettings.color_gray,
		offset = {
			60,
			5,
			2
		}
	},
	header_subtitle = {
		font_size = 20,
		font_type = "itc_novarese_bold",
		text_color = MissionBoardViewSettings.color_main,
		offset = {
			60,
			25,
			2
		}
	},
	body_background = {
		color = MissionBoardViewSettings.color_background
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
		text_color = MissionBoardViewSettings.color_frame,
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
			255,
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
		text_color = MissionBoardViewSettings.color_main,
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
		text_color = MissionBoardViewSettings.color_main,
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
MissionBoardViewStyles.play_button_widget_style = {
	background = {
		color = Color.ui_hud_green_medium(nil, true)
	},
	background_selected = {
		color = {
			200,
			0,
			0,
			0
		},
		color_default = {
			200,
			0,
			0,
			0
		},
		color_hover = {
			255,
			0,
			255,
			0
		},
		color_held = {
			255,
			0,
			255,
			0
		}
	},
	gradient = {
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
		},
		uvs = {
			{
				0,
				0
			},
			{
				1,
				1
			}
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
	corner = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_corner,
		offset = {
			0,
			0,
			2
		}
	},
	text = {
		character_spacing = 0.1,
		font_size = 24,
		text_vertical_alignment = "center",
		text_horizontal_alignment = "center",
		font_type = "proxima_nova_bold",
		text_color = {
			255,
			0,
			0,
			0
		},
		text_color_default = MissionBoardViewSettings.color_main,
		text_color_hover = {
			255,
			216,
			237,
			190
		},
		text_color_held = {
			255,
			158,
			178,
			133
		},
		offset = {
			0,
			0,
			3
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
	timer_mini = {
		color = {
			255,
			0,
			0,
			0
		},
		material_values = {
			progress = 0.75
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
			progress = 0.75
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
		font_type = "itc_novarese_bold",
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
			-24,
			0,
			3
		}
	},
	difficulty_bar_1 = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		color = MissionBoardViewSettings.color_main,
		size = {
			5,
			18
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
			5,
			18
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
			5,
			18
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
			5,
			18
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
			5,
			18
		},
		offset = {
			31,
			0,
			3
		}
	},
	location_image = {
		material_values = {
			texture_map = "content/ui/textures/missions/cm_habs_small"
		}
	},
	location_vignette = {
		scale_to_material = true,
		color = {
			255,
			16,
			32,
			1
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
			2
		}
	},
	location_corner = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_corner,
		offset = {
			0,
			0,
			3
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
			4
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
		color = MissionBoardViewSettings.color_main,
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
			-5,
			-5
		}
	},
	circumstance_corner = {
		scale_to_material = true,
		color = MissionBoardViewSettings.color_corner,
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
	}
}

return settings("MissionBoardViewStyles", MissionBoardViewStyles)
