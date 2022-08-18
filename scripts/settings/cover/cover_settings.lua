local cover_settings = {
	types = table.enum("high", "low"),
	peek_types = table.enum("right", "left", "both", "blocked"),
	user_search_sources = table.enum("from_self", "from_target"),
	peek_z_offsets = {
		high = 1,
		low = 0.5
	},
	slot_width = 0.75,
	slot_navmesh_outside_search_distance = 0.75,
	slot_navmesh_offset = 0.45,
	slot_user_offset = 0.2,
	flanking_cover_dot = 0.5
}

return settings("CoverSettings", cover_settings)
