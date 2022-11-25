local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local hud_element_personal_player_panel_hub_settings = {
	size = {
		510,
		80
	},
	icon_size = {
		90,
		100
	},
	icon_bar_spacing = {
		10,
		0
	},
	feature_list = {
		coherency = false,
		name = true,
		pocketable = false,
		character_text = true,
		respawn_timer = false,
		throwables = false,
		corruption_text = false,
		toughness_hit_indicator = false,
		ammo = false,
		player_color = false,
		toughness = false,
		level = true,
		portrait = true,
		voip = true,
		health_text = false,
		status_icon = false,
		health = false,
		toughness_text = false,
		insignia = true
	}
}

return settings("HudElementPersonalPlayerPanelHubSettings", hud_element_personal_player_panel_hub_settings)
