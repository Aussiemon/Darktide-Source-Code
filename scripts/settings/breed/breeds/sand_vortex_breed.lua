-- chunkname: @scripts/settings/breed/breeds/sand_vortex_breed.lua

local BreedBlackboardComponentTemplates = require("scripts/settings/breed/breed_blackboard_component_templates")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local BreedTerrorEventSettings = require("scripts/settings/breed/breed_terror_event_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local SmartObjectSettings = require("scripts/settings/navigation/smart_object_settings")
local breed_name = "sand_vortex"
local breed_types = BreedSettings.types
local hit_zone_names = HitZone.hit_zone_names
local breed_data = {
	base_height = 3.6,
	base_unit = "content/characters/enemy/sand_vortex/third_person/sand_vortex",
	behavior = "chaos_vortex",
	bone_lod_radius = 3,
	broadphase_radius = 2,
	can_patrol = true,
	challenge_rating = 30,
	detection_radius = 20,
	display_name = "loc_breed_display_name_chaos_spawn",
	explosion_radius = 1,
	faction_name = "chaos",
	game_object_type = "spineless_breed_unit",
	has_inventory = false,
	heat = 2,
	ignore_minion_push = true,
	is_untargetable = true,
	line_of_sight_collision_filter = "filter_minion_line_of_sight_check",
	navigation_propagation_box_extent = 200,
	power_level_type = "chaos_spawn_melee",
	run_speed = 2.5,
	smart_tag_target_type = "breed",
	sub_faction_name = "chaos",
	unit_template_name = "spineless_breed_unit",
	use_bone_lod = false,
	use_navigation_path_splines = true,
	walk_speed = 2.5,
	name = breed_name,
	breed_type = breed_types.living_prop,
	blackboard_component_config = BreedBlackboardComponentTemplates.sand_vortex,
	tags = {
		minion = true,
	},
	size_variation_range = {
		1.04,
		1.04,
	},
	outline_config = {},
	behavior_tree_name = breed_name,
	point_cost = BreedTerrorEventSettings[breed_name].point_cost,
	attack_intensity_cooldowns = {
		melee = {
			0,
			0,
		},
		moving_melee = {
			0,
			0,
		},
	},
	threat_config = {
		max_threat = 1000,
		threat_decay_per_second = 100,
		threat_multiplier = 1,
	},
	target_changed_attack_intensities = {
		disabling = 5,
	},
	line_of_sight_data = {
		{
			from_node = "j_head",
			id = "eyes",
			to_node = "j_spine",
			offsets = PerceptionSettings.default_minion_line_of_sight_offsets,
		},
	},
	nav_tag_allowed_layers = {
		monster_walls = 1.5,
	},
	smart_object_template = SmartObjectSettings.templates.chaos_spawn,
	hit_zones = {
		{
			name = hit_zone_names.center_mass,
			actors = {},
		},
	},
	nav_cost_map_multipliers = {},
	vortex_template = {
		ai_ascension_speed = 3,
		ai_attract_speed = 20,
		ai_attractable = true,
		ai_radius_change_speed = 1,
		ai_rotation_speed = 15,
		deal_wall_slam_damage = false,
		distance_per_stack = 1,
		horizontal_angular_delta = 5,
		inner_radius = 3,
		lifetime = 100,
		max_allowed_inner_radius_dist = 1.5,
		max_grow_time = 25,
		max_spin_speed = 15,
		max_vertical_speed = 6,
		movement_speed_debuff_name = "expedition_sand_vortex_move_speed",
		movement_speed_debuff_radius = 14,
		new_target_wait_time = 10,
		node_count = 60,
		node_lifetime = 25,
		outer_radius = 8,
		player_ascend_speed = 1,
		player_attract_speed = 200,
		player_attractable = true,
		player_eject_distance = 25,
		player_eject_height = 12.5,
		player_eject_speed = 25,
		player_ejected_bliss_time = 5,
		player_in_vortex_max_duration = 5,
		player_lift_time = 0.8,
		player_radius_change_speed = 1,
		player_rotation_speed = 10,
		random_wander = true,
		spawn_mode = "stagger",
		startup_time = 7,
		stop_and_process_player = true,
		vfx_follow_speed = 0.5,
		vfx_ground_offset = -0.5,
		vortex_height = 13,
		wall_slam_damage_profile = "vortex_grab_wall_slam",
		wall_slam_max_power_level = 500,
		wanted_maximum_flight_height = 12,
		wanted_minimum_flight_height = 3,
		windup_time = 0.5,
		ai_eject_height = {
			3,
			5,
		},
		catapult_force = {
			human = 9,
			ogryn = 10,
		},
		catapult_z_force = {
			human = 3,
			ogryn = 4,
		},
	},
	companion_pounce_setting = {
		companion_pounce_action = "stagger_and_leap_away",
		ignore_target_selection = true,
	},
	testify_flags = {
		spawn_all_enemies = false,
	},
}

return breed_data
