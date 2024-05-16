-- chunkname: @scripts/settings/slot/slot_system_settings.lua

local MOVER_RADIUS = 0.6
local NAVMESH_DISTANCE_FROM_WALL = 0.5
local slot_position_check_index = {
	check_left = 0,
	check_middle = 1,
	check_right = 2,
}
local slot_system_settings = {
	disabled_slots_count_update_interval = 0.5,
	ghost_position_distance = 8,
	max_user_loops_per_frame = 75,
	max_user_updates_per_frame = 2,
	occupied_slots_count_update_interval = 0.5,
	overlap_slot_to_target_distance_sq = 1.44,
	slot_anchor_max_position_tries = 24,
	slot_owner_sticky_value = -3,
	slot_queue_max_z_diff_above = 2,
	slot_queue_max_z_diff_below = 3,
	slot_queue_penalty_multiplier = 3,
	slot_queue_radius = 1.75,
	slot_queue_random_position_max_down = 2,
	slot_queue_random_position_max_horizontal = 3,
	slot_queue_random_position_max_up = 1.5,
	slot_release_distance_sq = 9,
	slot_release_owner_distance_modifier = -3,
	slot_sound_update_interval = 1,
	slot_status_update_interval = 0.5,
	slot_z_max_down = 7.5,
	slot_z_max_up = 4,
	target_slots_moved_distance_sq = 0.5,
	target_slots_outside_navmesh_timeout = 2,
	target_slots_stopped_moving_speed_sq = 0.25,
	target_slots_update = 0.25,
	target_slots_update_long = 1,
	z_max_difference_above = 1.5,
	z_max_difference_below = 1.5,
	slot_position_check_index = slot_position_check_index,
	slot_position_check_index_size = table.size(slot_position_check_index),
	slot_position_check_radians = {
		[slot_position_check_index.check_left] = math.degrees_to_radians(-90),
		[slot_position_check_index.check_right] = math.degrees_to_radians(90),
	},
	slot_position_check_raycango_offset = NAVMESH_DISTANCE_FROM_WALL + MOVER_RADIUS,
	slot_ghost_radians = math.degrees_to_radians(90),
}

return settings("SlotSystemSettings", slot_system_settings)
