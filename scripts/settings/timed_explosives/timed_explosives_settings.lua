local timed_explosives_settings = {
	explosive_barrel = {
		explosion_template_name = "explosive_barrel",
		fuse_time = 2
	},
	explosive_luggable = {
		explosion_template_name = "explosive_barrel",
		fuse_time = 2
	}
}

return settings("TimedExplosivesSettings", timed_explosives_settings)
