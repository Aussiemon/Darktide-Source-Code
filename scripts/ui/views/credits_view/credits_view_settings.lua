local credits_view_settings = {
	style_settings = {
		header = {
			font_size = 55,
			font_type = "machine_medium",
			material = "content/ui/materials/font_gradients/slug_font_gradient_gold",
			color = Color.white(255, true)
		},
		normal = {
			font_size = 24,
			font_type = "proxima_nova_bold",
			color = Color.light_gray(255, true)
		},
		title = {
			font_size = 28,
			color = Color.white(255, true)
		},
		legal = {
			font_size = 24,
			color = Color.white(255, true)
		}
	},
	carousel = {
		"content/ui/materials/backgrounds/backstory/childhood",
		"content/ui/materials/backgrounds/backstory/formative_event",
		"content/ui/materials/backgrounds/backstory/growing_up"
	}
}

return settings("CreditsViewSettings", credits_view_settings)
