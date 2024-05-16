-- chunkname: @scripts/ui/hud/elements/overcharge/hud_element_overcharge_settings.lua

local shield_size = {
	31,
	38,
}
local hud_element_overcharge_settings = {
	center_offset = 200,
	half_distance = 1,
	max_glow_alpha = 130,
	spacing = 0,
	size = shield_size,
	area_size = {
		shield_size[1] * 12,
		shield_size[2],
	},
	glow_size = {
		29,
		29,
	},
}

return settings("HudElementOverchargeSettings", hud_element_overcharge_settings)
