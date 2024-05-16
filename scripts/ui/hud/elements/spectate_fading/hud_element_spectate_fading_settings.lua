-- chunkname: @scripts/ui/hud/elements/spectate_fading/hud_element_spectate_fading_settings.lua

local hud_element_spectate_fading_settings = {
	render_settings = {
		timer_name = "ui",
		viewport_layer = 2,
		viewport_type = "overlay",
		world_layer = 20,
	},
}

return settings("HudElementSpectateFadingSettings", hud_element_spectate_fading_settings)
