-- chunkname: @scripts/ui/hud/elements/team_player_panel/hud_element_team_player_panel_settings.lua

local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local hud_element_team_player_panel_settings = {
	critical_health_threshold = 0.2,
	health_bar_settings = {
		alpha_fade_delay = 2.6,
		alpha_fade_duration = 0.6,
		alpha_fade_min_value = 50,
		animate_on_health_increase = true,
		duration_health = 3,
		duration_health_ghost = 1.5,
		ghost_delay = 0.25,
		health_animation_threshold = 0.05,
	},
	toughness_bar_settings = {
		alpha_fade_delay = 2.6,
		alpha_fade_duration = 0.6,
		alpha_fade_min_value = 50,
		animate_on_health_increase = false,
		duration_health = 1,
		duration_health_ghost = 1,
		ghost_delay = 0.25,
		health_animation_threshold = 0.05,
	},
	size = {
		180,
		8,
	},
	icon_size = {
		72,
		80,
	},
	icon_bar_spacing = {
		10,
		0,
	},
	throwable_size = {
		16,
		16,
	},
	ammo_size = {
		16,
		16,
	},
	ammo_spacing = {
		-18,
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
		ammo = true,
		coherency = true,
		health = true,
		name = true,
		player_color = true,
		pocketable = true,
		portrait = true,
		respawn_timer = true,
		status_icon = true,
		throwables = true,
		toughness = true,
		toughness_hit_indicator = true,
		voip = true,
	},
}

return settings("HudElementTeamPlayerPanelSettings", hud_element_team_player_panel_settings)
