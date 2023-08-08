local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ColorUtilities = require("scripts/utilities/ui/colors")
local ui_brown_dark = Color.ui_brown_dark(255, true)
local ui_brown_medium = Color.ui_brown_medium(255, true)
local ui_brown_light = Color.ui_brown_light(255, true)
local ui_brown_super_light = Color.ui_brown_super_light(255, true)
local ui_grey_medium = Color.ui_grey_medium(255, true)
local ui_terminal = Color.ui_terminal(255, true)
local ui_difficulty_dimmed = Color.white(40, true)
local black = Color.black(255, true)
local title_font_style = table.clone(UIFontSettings.header_2)
title_font_style.font_size = 28
title_font_style.text_vertical_alignment = "bottom"
title_font_style.offset = {
	0,
	0,
	12
}
title_font_style.text_horizontal_alignment = "center"
local flash_title_style = table.clone(title_font_style)
flash_title_style.size_addition = {
	-20,
	-20
}
flash_title_style.horizontal_alignment = "center"
flash_title_style.vertical_alignment = "center"
flash_title_style.text_vertical_alignment = "center"
flash_title_style.text_horizontal_alignment = "center"
flash_title_style.fade_out_text_color = Color.terminal_text_header(0, true)
flash_title_style.fade_in_text_color = flash_title_style.default_color
local mission_detail_top = {
	vertical_alignment = "top",
	size = {
		630,
		52
	},
	offset = {
		5,
		-5,
		0
	}
}
local mission_detail_bottom = {
	vertical_alignment = "bottom",
	size = {
		630,
		52
	},
	offset = {
		5,
		5,
		0
	}
}
local mission_title_font_style = table.clone(UIFontSettings.header_3)
mission_title_font_style.font_size = 34
mission_title_font_style.offset = {
	0,
	0,
	12
}
mission_title_font_style.text_horizontal_alignment = "center"
mission_title_font_style.text_color = {
	255,
	216,
	229,
	207
}
local mission_rewards_title_text_style = table.clone(UIFontSettings.header_3)
mission_rewards_title_text_style.size = {
	350,
	35
}
mission_rewards_title_text_style.horizontal_alignment = "center"
mission_rewards_title_text_style.font_size = 34
mission_rewards_title_text_style.offset = {
	0,
	-5,
	12
}
mission_rewards_title_text_style.text_horizontal_alignment = "center"
mission_rewards_title_text_style.text_color = {
	255,
	216,
	229,
	207
}
local mission_type_font_style = table.clone(UIFontSettings.header_3)
mission_type_font_style.font_size = 24
mission_type_font_style.offset = {
	0,
	40,
	13
}
mission_type_font_style.text_horizontal_alignment = "center"
mission_type_font_style.text_color = {
	255,
	169,
	191,
	153
}
local challenge_text_font_style = table.clone(UIFontSettings.header_3)
challenge_text_font_style.font_size = 34
challenge_text_font_style.offset = {
	-20,
	20,
	12
}
challenge_text_font_style.text_horizontal_alignment = "center"
challenge_text_font_style.text_color = {
	255,
	216,
	229,
	207
}
challenge_text_font_style.horizontal_alignment = "center"
challenge_text_font_style.size = {
	300,
	35
}
local mission_reward_text_style = {
	font_size = 24,
	scenegraph_id = "side_objective_pivot",
	text_vertical_alignment = "center",
	horizontal_alignment = "center",
	text_horizontal_alignment = "center",
	vertical_alignment = "bottom",
	font_type = "proxima_nova_bold",
	text_color = Color.ui_brown_super_light(65, true),
	size = {
		80,
		30
	},
	offset = {
		0,
		0,
		0
	}
}
local rewards_text_style = {
	font_size = 24,
	text_vertical_alignment = "center",
	horizontal_alignment = "center",
	text_horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "proxima_nova_bold",
	text_color = Color.terminal_text_body(255, true),
	size = {
		300,
		40
	},
	offset = {
		0,
		0,
		0
	}
}
local stat_circumstances_bonuses_icon_style = {
	vertical_alignment = "bottom",
	direction = 1,
	spacing = 0,
	amount = 0,
	orignal_offset = {
		0,
		5,
		1
	},
	size = {
		64,
		64
	}
}
stat_circumstances_bonuses_icon_style.offset = table.clone(stat_circumstances_bonuses_icon_style.orignal_offset)
local styles = {
	title_font_style = title_font_style,
	mission_title_font_style = mission_title_font_style,
	mission_type_font_style = mission_type_font_style,
	mission_reward_text_style = mission_reward_text_style,
	rewards_text_style = rewards_text_style,
	mission_detail_top = mission_detail_top,
	mission_detail_bottom = mission_detail_bottom,
	challenge_text_font_style = challenge_text_font_style,
	mission_rewards_title_text_style = mission_rewards_title_text_style,
	flash_title_style = flash_title_style,
	inner_panel_border_style = {
		color = ui_brown_medium,
		offset = {
			0,
			0,
			16
		}
	},
	inner_panel_drop_shadow_style = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		color = black,
		size_addition = {
			26,
			26
		}
	},
	inner_panel_frame_style = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		offset = {
			0,
			0,
			5
		},
		color = ui_brown_medium,
		size_addition = {
			6,
			6
		}
	},
	divider_style_01 = {
		vertical_alignment = "bottom",
		horizontal_alignment = "center",
		size = {
			466,
			20
		},
		offset = {
			0,
			14,
			4
		}
	},
	divider_style_03 = {
		vertical_alignment = "bottom",
		horizontal_alignment = "center",
		size = {
			468,
			16
		},
		offset = {
			0,
			6,
			2
		},
		color = ui_brown_medium
	},
	mission_type_icon_style = {
		color = ui_grey_medium,
		offset = {
			-8,
			6,
			2
		},
		size = {
			32,
			32
		}
	},
	stat_circumstances_bonuses_icon_style = stat_circumstances_bonuses_icon_style,
	timer_bar_frame_style = {
		hdr = true,
		offset = {
			0,
			0,
			2
		},
		color = Color.terminal_frame(255, true)
	},
	timer_bar_background_style = {
		color = Color.black(180, true)
	},
	timer_bar_fill_style = {
		timer_progress = 0,
		timer_time = 10,
		offset = {
			0,
			0,
			1
		},
		size = {
			185,
			10
		},
		color = Color.chocolate(200, true)
	},
	player_portrait = {}
}
local player_portrait = styles.player_portrait
player_portrait.frame = {
	horizontal_alignment = "center",
	vertical_alignment = "center"
}
player_portrait.portrait = {
	horizontal_alignment = "center",
	vertical_alignment = "center"
}
styles.salary = {}
local salary_style = styles.salary
salary_style.experience_icon = {
	size = {
		40,
		40
	},
	offset = {
		0,
		0,
		4
	}
}
salary_style.experience_text = table.clone(UIFontSettings.mission_voting_body)
salary_style.experience_text.offset = {
	35,
	0,
	4
}
salary_style.credits_icon = table.clone(salary_style.experience_icon)
salary_style.credits_icon.base_margin_left = 15
salary_style.credits_text = table.clone(salary_style.experience_text)
styles.difficulty = {}
local difficulty = styles.difficulty
difficulty.difficulty_font = table.clone(UIFontSettings.mission_detail_sub_header)
difficulty.difficulty_font.text_horizontal_alignment = "center"
difficulty.difficulty_icon = {
	vertical_alignment = "center",
	spacing = 8,
	direction = 1,
	amount = 0,
	offset = {
		40,
		10,
		0
	},
	size = {
		18,
		40
	},
	color = {
		255,
		169,
		191,
		153
	}
}
difficulty.diffulty_icon_background = table.clone(difficulty.difficulty_icon)
local stat_diffulty_icon_background_style = difficulty.diffulty_icon_background
stat_diffulty_icon_background_style.color = Color.terminal_background(255, true)
stat_diffulty_icon_background_style.amount = 5
difficulty.diffulty_icon_background_frame = table.clone(difficulty.difficulty_icon)
local diffulty_icon_background_frame_style = difficulty.diffulty_icon_background_frame
diffulty_icon_background_frame_style.color = {
	255,
	169,
	191,
	153
}
diffulty_icon_background_frame_style.amount = 5
diffulty_icon_background_frame_style.offset = {
	40,
	10,
	3
}
styles.difficulty_divider = {
	color = ui_brown_dark
}
styles.mission_info_circumstance = {}
local circumstance = styles.mission_info_circumstance
circumstance.header = table.clone(UIFontSettings.mission_detail_sub_header)
circumstance.header.text_horizontal_alignment = "center"
circumstance.icon = {
	vertical_alignment = "bottom",
	horizontal_alignment = "left",
	size = {
		50,
		50
	}
}
circumstance.text = table.clone(UIFontSettings.mission_voting_body)
local circumstance_text = circumstance.text
circumstance_text.text_vertical_alignment = "bottom"
circumstance_text.offset = {
	60,
	-10,
	4
}
styles.circumstance_height_addition = 40
styles.accept_button = {}
local accept_button_style = styles.accept_button
accept_button_style.hotspot = {
	on_pressed_sound = ""
}
styles.decline_button = {}
local decline_button_style = styles.decline_button
decline_button_style.hotspot = {
	on_pressed_sound = ""
}
decline_button_style.frame = {
	color = Color.ui_grey_medium(64, true)
}
styles.accept_confirmation = {}
local accept_confirmation = styles.accept_confirmation
accept_confirmation.subheader = table.clone(UIFontSettings.mission_voting_body)
accept_confirmation.subheader.text_color = Color.ui_grey_medium(255, true)
accept_confirmation.subheader.text_horizontal_alignment = "center"
accept_confirmation.subheader.text_vertical_alignment = "bottom"
styles.blueprints = {}
local blueprints = styles.blueprints
blueprints.main_objective = {}
local main_objective = blueprints.main_objective
main_objective.objective_header = table.clone(UIFontSettings.header_2)
main_objective.objective_header.text_horizontal_alignment = "left"
main_objective.objective_header.font_size = 28
main_objective.main_objective_icon = {
	size = {
		42,
		42
	},
	color = {
		255,
		169,
		191,
		153
	}
}
main_objective.body_text = table.clone(UIFontSettings.mission_detail_sub_header)
main_objective.body_text.text_horizontal_alignment = "left"
main_objective.body_text.size = {
	475,
	60
}
main_objective.body_text.text_color = {
	255,
	169,
	191,
	153
}
main_objective.rewards_text = table.clone(UIFontSettings.mission_detail_sub_header)
main_objective.rewards_text.text_horizontal_alignment = "left"
main_objective.rewards_text.text_color = Color.terminal_text_header(255, true)
blueprints.side_mission = {}
local side_mission = blueprints.side_mission
side_mission.objective_header = table.clone(UIFontSettings.header_2)
side_mission.objective_header.text_horizontal_alignment = "left"
side_mission.objective_header.font_size = 28
side_mission.objective_icon = {
	size = {
		42,
		42
	},
	color = {
		255,
		169,
		191,
		153
	}
}
side_mission.body_text = table.clone(UIFontSettings.mission_detail_sub_header)
side_mission.body_text.text_horizontal_alignment = "left"
side_mission.body_text.text_color = {
	255,
	169,
	191,
	153
}
side_mission.reward_icon = {
	size = {
		32,
		32
	}
}
side_mission.rewards_text = table.clone(UIFontSettings.mission_detail_sub_header)
side_mission.rewards_text.text_horizontal_alignment = "left"
side_mission.rewards_text.text_color = Color.terminal_text_header(255, true)
blueprints.circumstance = {}
local circumstance = blueprints.circumstance
circumstance.circumstance_icon = {
	vertical_alignment = "top",
	horizontal_alignment = "left",
	size = {
		50,
		50
	},
	offset = {
		0,
		20,
		1
	},
	color = Color.golden_rod(255, true)
}
circumstance.circumstance_title = table.clone(UIFontSettings.header_2)
local circumstance_title = circumstance.circumstance_title
circumstance_title.text_vertical_alignment = "top"
circumstance_title.offset = {
	60,
	30,
	4
}
circumstance_title.font_size = 28
circumstance.body_text = table.clone(UIFontSettings.mission_detail_sub_header)
local circumstance_description = circumstance.body_text
circumstance_description.text_vertical_alignment = "top"
circumstance_description.offset = {
	60,
	15,
	4
}
circumstance_description.text_color = {
	255,
	169,
	191,
	153
}
circumstance.reward_text = table.clone(UIFontSettings.mission_detail_sub_header)
circumstance.reward_text.text_horizontal_alignment = "left"
circumstance.reward_text.text_color = Color.terminal_text_header(255, true)
circumstance.reward_icon = {
	size = {
		32,
		32
	}
}
blueprints.category_name = {
	text = {}
}
local text = blueprints.category_name.text
text.font_size = 20
text.text_color = Color.ui_grey_medium(255, true)
text.offset = {
	40,
	20,
	1
}
blueprints.detail = {}
local detail = blueprints.detail
detail.title = table.clone(UIFontSettings.header_3)
detail.title.font_type = "itc_novarese_medium"
detail.title.offset = {
	90,
	10,
	1
}
detail.title.text_color_disabled = Color.ui_grey_light(255, true)
detail.description = table.clone(UIFontSettings.body_small)
detail.description.offset = {
	90,
	15,
	1
}
detail.icon = {
	vertical_alignment = "top",
	spacing = 0,
	direction = 1,
	amount = 0,
	offset = {
		detail.title.offset[1] / 2 - 32,
		-8,
		0
	},
	size = {
		64,
		64
	}
}

return settings("MissionVotingViewStyles", styles)
