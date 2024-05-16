-- chunkname: @scripts/ui/hud/elements/cutscene_fading/hud_element_cutscene_fading_settings.lua

local hud_element_cutscene_fading_settings = {
	render_settings = {
		timer_name = "ui",
		viewport_layer = 2,
		viewport_type = "overlay",
		world_layer = 20,
	},
}

return settings("HudElementCutsceneFadingSettings", hud_element_cutscene_fading_settings)
