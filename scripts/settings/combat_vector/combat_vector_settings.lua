-- chunkname: @scripts/settings/combat_vector/combat_vector_settings.lua

local combat_vector_settings = {}

combat_vector_settings.vector_types = table.enum("main", "left_flank", "right_flank")
combat_vector_settings.location_types = {
	"left",
	"mid",
	"right"
}
combat_vector_settings.main_vector_type = "main"
combat_vector_settings.flank_vector_types = {
	"left_flank",
	"right_flank"
}
combat_vector_settings.range_types = table.enum("close", "far")
combat_vector_settings.main_aggro_target_event_types = table.enum("killed_unit", "suppression")
combat_vector_settings.target_side_id = 1
combat_vector_settings.max_segments = 20
combat_vector_settings.width = 35
combat_vector_settings.flank_width = 14
combat_vector_settings.main_path_distance = 50
combat_vector_settings.min_segment_length = 3
combat_vector_settings.from_update_distance_sq = 36
combat_vector_settings.to_update_distance_sq = 144
combat_vector_settings.combat_vector_update_frequency = 3
combat_vector_settings.astar_frequency = 0.5
combat_vector_settings.min_nav_mesh_location_radius = 0.4
combat_vector_settings.num_locations_per_segment_meter = 1
combat_vector_settings.num_flank_locations_per_segment_meter = 0
combat_vector_settings.min_distance_sq = 900
combat_vector_settings.max_distance_sq = 6400
combat_vector_settings.main_aggro_target_stickyness = 10
combat_vector_settings.max_main_aggro_score = 20
combat_vector_settings.aggro_decay_speed = 3
combat_vector_settings.locked_in_melee_cooldown = 5
combat_vector_settings.locked_in_melee_range = 10
combat_vector_settings.melee_minion_range = 7.5
combat_vector_settings.nav_mesh_location_start_index = 5

return settings("CombatVectorSettings", combat_vector_settings)
