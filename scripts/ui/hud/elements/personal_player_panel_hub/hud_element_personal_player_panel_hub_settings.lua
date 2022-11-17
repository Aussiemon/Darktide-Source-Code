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
		ammo = false,
		toughness = false,
		toughness_hit_indicator = false,
		respawn_timer = false,
		health = false,
		player_color = false,
		throwables = false,
		portrait = true,
		voip = true,
		health_text = false,
		status_icon = false,
		corruption_text = false,
		toughness_text = false
	}
}

return settings("HudElementPersonalPlayerPanelHubSettings", hud_element_personal_player_panel_hub_settings)
