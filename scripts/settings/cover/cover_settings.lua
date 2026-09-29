-- chunkname: @scripts/settings/cover/cover_settings.lua

local cover_settings = {}

cover_settings.types = table.enum("high", "low")
cover_settings.peek_types = table.enum("right", "left", "both", "blocked")
cover_settings.user_search_sources = table.enum("from_self", "from_target", "from_combat_vector_start")
cover_settings.peek_z_offsets = {
	high = 1,
	low = 0.5
}
cover_settings.slot_width = 0.75
cover_settings.slot_navmesh_outside_search_distance = 0.75
cover_settings.slot_navmesh_offset = 0.45
cover_settings.slot_user_offset = 0.2
cover_settings.flanking_cover_dot = 0.5

return settings("CoverSettings", cover_settings)
