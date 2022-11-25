local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local hud_element_team_player_panel_hub_settings = {
	critical_health_threshold = 0.2,
	health_bar_settings = {
		animate_on_health_increase = true,
		alpha_fade_delay = 2.6,
		duration_health_ghost = 1.5,
		health_animation_threshold = 0.05,
		alpha_fade_duration = 0.6,
		duration_health = 3,
		alpha_fade_min_value = 50
	},
	toughness_bar_settings = {
		animate_on_health_increase = false,
		alpha_fade_delay = 2.6,
		duration_health_ghost = 1,
		health_animation_threshold = 0.05,
		alpha_fade_duration = 0.6,
		duration_health = 1,
		alpha_fade_min_value = 50
	},
	size = {
		230,
		10
	},
	icon_size = {
		72,
		80
	},
	icon_bar_spacing = {
		10,
		0
	},
	throwable_size = {
		16,
		16
	},
	ammo_size = {
		16,
		16
	},
	ammo_spacing = {
		-18,
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
		respawn_timer = false,
		name = true,
		portrait = true,
		voip = true,
		coherency = false,
		ammo = false,
		toughness_hit_indicator = false,
		player_color = false,
		status_icon = false,
		health = false,
		throwables = false,
		insignia = true,
		level = true
	}
}

return settings("HudElementTeamPlayerPanelHubSettings", hud_element_team_player_panel_hub_settings)
