local monster_settings = {
	spawn_distance = 40,
	max_sections = 20,
	spawn_types = {
		"monsters",
		"witches"
	},
	used_spawn_types = {
		"monsters"
	},
	no_spawn_volume_half_extents = {
		witches = Vector3Box(2, 2, 0.5)
	}
}

return settings("MonsterSettings", monster_settings)
