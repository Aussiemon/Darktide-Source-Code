-- chunkname: @scripts/ui/hud/elements/team_player_panel_hub/hud_element_team_player_panel_hub_settings.lua

local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local hud_element_team_player_panel_hub_settings = {
	critical_health_threshold = 0.2,
	health_bar_settings = {
		alpha_fade_delay = 2.6,
		alpha_fade_duration = 0.6,
		alpha_fade_min_value = 50,
		animate_on_health_increase = true,
		duration_health = 3,
		duration_health_ghost = 1.5,
		health_animation_threshold = 0.05,
	},
	toughness_bar_settings = {
		alpha_fade_delay = 2.6,
		alpha_fade_duration = 0.6,
		alpha_fade_min_value = 50,
		animate_on_health_increase = false,
		duration_health = 1,
		duration_health_ghost = 1,
		health_animation_threshold = 0.05,
	},
	title_settings = {
		party_player = {
			no_title = {
				player_name_y_offset = -5,
				rich_precence_y_offset = 0,
			},
			title = {
				player_name_y_offset = -10,
				rich_precence_y_offset = 4,
			},
		},
		my_player = {
			no_title = {
				character_text_y_offset = 14,
				player_name_y_offset = -38,
			},
			title = {
				character_text_y_offset = 25,
				player_name_y_offset = -45,
			},
		},
	},
	size = {
		230,
		10,
	},
	icon_size = {
		ItemSlotSettings.slot_portrait_frame.item_icon_size[1] * 0.8,
		ItemSlotSettings.slot_portrait_frame.item_icon_size[2] * 0.8,
	},
	insignia_icon_size = {
		ItemSlotSettings.slot_insignia.item_icon_size[1] * 0.8,
		ItemSlotSettings.slot_insignia.item_icon_size[2] * 0.8,
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
		ammo = false,
		character_titles = true,
		coherency = false,
		health = false,
		insignia = true,
		level = true,
		name = true,
		player_color = false,
		portrait = true,
		respawn_timer = false,
		status_icon = false,
		throwables = false,
		toughness_hit_indicator = false,
		voip = true,
	},
}

return settings("HudElementTeamPlayerPanelHubSettings", hud_element_team_player_panel_hub_settings)
