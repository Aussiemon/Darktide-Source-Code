local hud_element_cutscene_fading_settings = {
	render_settings = {
		viewport_type = "overlay",
		viewport_layer = 2,
		world_layer = 20,
		timer_name = "ui"
	}
}

return settings("HudElementCutsceneFadingSettings", hud_element_cutscene_fading_settings)
