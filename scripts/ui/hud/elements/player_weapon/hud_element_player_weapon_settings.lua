-- chunkname: @scripts/ui/hud/elements/player_weapon/hud_element_player_weapon_settings.lua

local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local get_hud_color = UIHudSettings.get_hud_color
local hud_element_player_weapon_settings = {
	ammo_clip_max_row_rounds = 15,
	ammo_clip_round_spacing = -2,
	ammo_clip_urgent_threshold = 0.2,
	ammo_font_size_default = 30,
	ammo_font_size_default_small = 20,
	ammo_font_size_focused = 45,
	ammo_font_size_focused_small = 26,
	ammo_urgent_threshold = 0.2,
	bar_edge_width = 5,
	max_ammo_digits = 4,
	overheat_segment_spacing = -2,
	overview_segment_length_difference = 2,
	urgent_color = get_hud_color("color_tint_alert_2", 255),
	urgent_color_wielded = get_hud_color("color_tint_alert_2", 255),
	bar_segment_urgent_color = get_hud_color("color_tint_alert_2", 255),
	bar_segment_passive_color = get_hud_color("color_tint_main_3", 255),
	bar_segment_background_color = get_hud_color("color_tint_main_4", 255),
	ammo_round_size = {
		19,
		10,
	},
	infinite_symbol_size = {
		51.25,
		30,
	},
	infinite_symbol_size_focused = {
		61.5,
		36,
	},
	events = {
		{
			"event_on_active_input_changed",
			"event_on_input_changed",
		},
		{
			"event_on_input_settings_changed",
			"event_on_input_changed",
		},
	},
}

return settings("HudElementPlayerWeaponSettings", hud_element_player_weapon_settings)
