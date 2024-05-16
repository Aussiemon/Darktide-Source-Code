-- chunkname: @scripts/settings/monster/monster_settings.lua

local monster_settings = {
	boss_patrol_extra_spawn_distance = 20,
	max_sections = 20,
	spawn_distance = 40,
	spawn_types = {
		"monsters",
		"witches",
		"captains",
	},
	used_spawn_types = {
		"monsters",
		"witches",
		"captains",
	},
	no_spawn_volume_half_extents = {
		witches = Vector3Box(2, 2, 0.5),
	},
}

return settings("MonsterSettings", monster_settings)
