-- chunkname: @scripts/ui/hud/elements/personal_player_panel/hud_element_personal_player_panel_settings.lua

local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local hud_element_personal_player_panel_settings = {
	critical_health_threshold = 0.2,
	health_bar_settings = {
		alpha_fade_delay = 2.6,
		alpha_fade_duration = 0.6,
		alpha_fade_min_value = 50,
		animate_on_health_increase = true,
		duration_health = 1.5,
		duration_health_ghost = 1.5,
		ghost_delay = 0.25,
		health_animation_threshold = 0.1,
	},
	toughness_bar_settings = {
		alpha_fade_delay = 2.6,
		alpha_fade_duration = 0.6,
		alpha_fade_min_value = 50,
		animate_on_health_increase = true,
		duration_health = 1,
		duration_health_ghost = 1,
		ghost_delay = 0.25,
		health_animation_threshold = 0.05,
	},
	size = {
		510,
		80,
	},
	bar_size = {
		279,
		16,
	},
	icon_size = {
		90,
		100,
	},
	icon_bar_spacing = {
		10,
		0,
	},
	critical_health_color = UIHudSettings.color_tint_alert_2,
	default_health_color = UIHudSettings.color_tint_main_2,
	disabled_health_color = {
		255,
		200,
		200,
		200,
	},
	feature_list = {
		ammo = false,
		coherency = false,
		corruption_text = true,
		health = true,
		health_text = true,
		name = true,
		player_color = true,
		pocketable = false,
		portrait = true,
		respawn_timer = true,
		status_icon = true,
		throwables = false,
		toughness = true,
		toughness_hit_indicator = true,
		toughness_text = true,
		voip = true,
	},
}

return settings("HudElementPersonalPlayerPanelSettings", hud_element_personal_player_panel_settings)
