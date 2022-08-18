local shield_size = {
	31,
	38
}
local hud_element_overcharge_settings = {
	max_glow_alpha = 130,
	center_offset = 200,
	spacing = 0,
	half_distance = 1,
	size = shield_size,
	area_size = {
		shield_size[1] * 12,
		shield_size[2]
	},
	glow_size = {
		29,
		29
	}
}

return settings("HudElementOverchargeSettings", hud_element_overcharge_settings)
