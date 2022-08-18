local ui_hud_settings = {
	color_tint_main_1 = Color.ui_hud_green_super_light(255, true),
	color_tint_main_2 = Color.ui_hud_green_light(255, true),
	color_tint_main_3 = Color.ui_hud_green_medium(255, true),
	color_tint_main_4 = Color.ui_hud_green_dark(255, true),
	color_tint_secondary_1 = Color.ui_hud_yellow_super_light(255, true),
	color_tint_secondary_2 = Color.ui_hud_yellow_light(255, true),
	color_tint_secondary_3 = Color.ui_hud_yellow_medium(255, true),
	color_tint_alert_1 = Color.ui_hud_red_super_light(255, true),
	color_tint_alert_2 = Color.ui_hud_red_light(255, true),
	color_tint_alert_3 = Color.ui_hud_red_medium(255, true),
	color_tint_alert_4 = Color.ui_hud_red_dark(255, true),
	color_tint_0 = {
		150,
		0,
		0,
		0
	},
	color_tint_1 = {
		255,
		255,
		255,
		255
	},
	color_tint_2 = Color.ui_orange_light(153, true),
	color_tint_3 = Color.ui_orange_dark(153, true),
	color_tint_4 = Color.ui_grey_medium(153, true),
	color_tint_5 = Color.ui_terminal(255, true),
	color_tint_6 = Color.ui_toughness_default(255, true),
	color_tint_7 = Color.ui_toughness_medium(255, true),
	color_tint_8 = Color.ui_corruption_default(255, true),
	color_tint_9 = Color.ui_corruption_medium(255, true),
	player_status_icons = {
		ledge_hanging = "content/ui/materials/hud/interactions/icons/help",
		luggable = "content/ui/materials/icons/player_states/lugged",
		hogtied = "content/ui/materials/icons/player_states/dead",
		knocked_down = "content/ui/materials/hud/interactions/icons/help",
		pounced = "content/ui/materials/icons/player_states/incapacitated",
		dead = "content/ui/materials/icons/player_states/dead"
	},
	player_status_colors = {
		dead = Color.ui_hud_green_super_light(255, true),
		hogtied = Color.ui_hud_green_super_light(255, true),
		pounced = Color.ui_orange_light(255, true),
		knocked_down = Color.ui_hud_red_light(255, true),
		ledge_hanging = Color.ui_hud_green_super_light(255, true),
		luggable = Color.ui_hud_green_super_light(255, true)
	}
}

return settings("UIHudSettings", ui_hud_settings)
