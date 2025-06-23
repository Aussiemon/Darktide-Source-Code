-- chunkname: @scripts/ui/hud/elements/player_ability/hud_element_player_ability_settings.lua

local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local get_hud_color = UIHudSettings.get_hud_color
local hud_element_player_ability_settings = {
	animate_on_health_increase = true,
	duration_health_ghost = 2.5,
	bar_spacing = 3,
	duration_health = 1,
	alpha_fade_delay = 2.6,
	edge_offset = -50,
	alpha_fade_duration = 0.6,
	critical_health_threshold = 0.33,
	health_animation_threshold = 0.1,
	alpha_fade_min_value = 50,
	size = {
		202,
		9
	},
	icon_size = {
		80,
		80
	},
	icon_bar_spacing = {
		10,
		0
	},
	ammo_size = {
		11,
		11
	},
	ammo_spacing = {
		0,
		0
	},
	critical_health_color = {
		255,
		215,
		63,
		63
	},
	default_health_color = {
		255,
		231,
		145,
		26
	},
	active_colors = {
		icon = get_hud_color("color_tint_main_2", 200),
		frame = get_hud_color("color_tint_main_2", 255),
		right_edge = get_hud_color("color_tint_main_1", 255),
		left_edge = get_hud_color("color_tint_main_1", 255),
		frame_glow = get_hud_color("color_tint_main_1", 255),
		text = get_hud_color("color_tint_main_1", 255),
		input_text = get_hud_color("color_tint_main_1", 255)
	},
	cooldown_colors = {
		icon = get_hud_color("color_tint_main_3", 200),
		frame = get_hud_color("color_tint_main_3", 255),
		right_edge = get_hud_color("color_tint_main_2", 0),
		left_edge = get_hud_color("color_tint_main_2", 0),
		frame_glow = get_hud_color("color_tint_main_3", 0),
		text = get_hud_color("color_tint_main_3", 255),
		input_text = get_hud_color("color_tint_main_3", 255)
	},
	out_of_charges_cooldown_colors = {
		icon = get_hud_color("color_tint_main_3", 200),
		frame = get_hud_color("color_tint_main_3", 255),
		right_edge = get_hud_color("color_tint_main_2", 0),
		left_edge = get_hud_color("color_tint_main_2", 0),
		frame_glow = get_hud_color("color_tint_main_3", 0),
		text = Color.red(255, true),
		input_text = get_hud_color("color_tint_main_3", 255)
	},
	has_charges_cooldown_colors = {
		icon = get_hud_color("color_tint_main_3", 200),
		frame = get_hud_color("color_tint_main_3", 255),
		right_edge = get_hud_color("color_tint_main_2", 255),
		left_edge = get_hud_color("color_tint_main_2", 255),
		frame_glow = get_hud_color("color_tint_main_1", 255),
		text = get_hud_color("color_tint_main_2", 255),
		input_text = get_hud_color("color_tint_main_1", 255)
	},
	inactive = {
		icon = get_hud_color("color_tint_main_4", 200),
		frame = get_hud_color("color_tint_main_4", 255),
		right_edge = get_hud_color("color_tint_main_2", 0),
		left_edge = get_hud_color("color_tint_main_2", 0),
		frame_glow = get_hud_color("color_tint_main_4", 0),
		text = Color.red(255, true),
		input_text = get_hud_color("color_tint_main_3", 255)
	},
	events = {
		{
			"event_on_input_settings_changed",
			"event_on_input_changed"
		},
		{
			"event_on_active_input_changed",
			"event_on_input_changed"
		}
	}
}

return settings("HudElementPlayerAbilitySettings", hud_element_player_ability_settings)
