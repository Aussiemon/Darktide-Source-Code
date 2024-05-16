-- chunkname: @scripts/ui/hud/elements/player_compass/hud_element_player_compass_settings.lua

local hud_element_player_compass_settings = {
	edge_offset = 15,
	font_size_big = 24,
	font_size_small = 16,
	step_fade_start = 0.6,
	step_font_type = "proxima_nova_bold",
	step_height_large = 12,
	step_height_small = 8,
	step_width = 2,
	steps = 24,
	visible_steps = 12,
	step_color = Color.ui_hud_green_light(255, true),
	direction_icon_color = {
		255,
		255,
		255,
		255,
	},
	direction_icon_size = {
		25,
		25,
	},
	degree_direction_icons = {
		[0] = "content/ui/vector_textures/hud/compass_icon_direction_north",
		[90] = "content/ui/vector_textures/hud/compass_icon_direction_east",
		[180] = "content/ui/vector_textures/hud/compass_icon_direction_south",
		[270] = "content/ui/vector_textures/hud/compass_icon_direction_west",
		[360] = "content/ui/vector_textures/hud/compass_icon_direction_north",
	},
	degree_direction_abbreviations = {
		[0] = "N",
		[90] = "E",
		[180] = "S",
		[270] = "W",
		[360] = "N",
	},
}

return settings("HudElementPlayerCompassSettings", hud_element_player_compass_settings)
