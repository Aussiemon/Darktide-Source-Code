local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local hud_element_personal_player_panel_settings = {
	critical_health_threshold = 0.2,
	health_bar_settings = {
		animate_on_health_increase = true,
		alpha_fade_delay = 2.6,
		duration_health_ghost = 1.5,
		health_animation_threshold = 0.1,
		alpha_fade_duration = 0.6,
		duration_health = 1.5,
		alpha_fade_min_value = 50
	},
	toughness_bar_settings = {
		animate_on_health_increase = true,
		alpha_fade_delay = 2.6,
		duration_health_ghost = 1,
		health_animation_threshold = 0.05,
		alpha_fade_duration = 0.6,
		duration_health = 1,
		alpha_fade_min_value = 50
	},
	size = {
		510,
		80
	},
	bar_size = {
		279,
		16
	},
	icon_size = {
		90,
		100
	},
	icon_bar_spacing = {
		10,
		0
	},
	critical_health_color = UIHudSettings.color_tint_alert_2,
	default_health_color = UIHudSettings.color_tint_main_2,
	disabled_health_color = {
		255,
		200,
		200,
		200
	},
	feature_list = {
		respawn_timer = true,
		name = true,
		throwables = false,
		voip = true,
		portrait = true,
		ammo = false,
		health = true,
		coherency = true,
		health_text = true,
		player_color = true,
		status_icon = true,
		toughness_hit_indicator = true,
		toughness_text = true,
		toughness = true,
		corruption_text = true
	}
}

return settings("HudElementPersonalPlayerPanelSettings", hud_element_personal_player_panel_settings)
