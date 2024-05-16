-- chunkname: @scripts/ui/hud/elements/blocking/hud_element_blocking_settings.lua

local hud_element_blocking_settings = {
	center_offset = 210,
	half_distance = 1,
	max_glow_alpha = 130,
	spacing = 4,
	bar_size = {
		200,
		9,
	},
	area_size = {
		220,
		40,
	},
}

return settings("HudElementBlockingSettings", hud_element_blocking_settings)
