-- chunkname: @scripts/settings/breed/breeds/nurgle_flies_breed.lua

local BreedBlackboardComponentTemplates = require("scripts/settings/breed/breed_blackboard_component_templates")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local BreedTerrorEventSettings = require("scripts/settings/breed/breed_terror_event_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local SmartObjectSettings = require("scripts/settings/navigation/smart_object_settings")
local breed_name = "nurgle_flies"
local breed_types = BreedSettings.types
local hit_zone_names = HitZone.hit_zone_names
local breed_data = {
	base_height = 3.6,
	base_unit = "content/characters/enemy/nurgle_flies/third_person/nurgle_flies",
	bone_lod_radius = 3,
	broadphase_radius = 1,
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
	blackboard_component_config = BreedBlackboardComponentTemplates.nurgle_flies,
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
	nav_tag_allowed_layers = {},
	nav_cost_map_multipliers = {},
	smart_object_template = SmartObjectSettings.templates.chaos_spawn,
	hit_zones = {
		{
			name = hit_zone_names.center_mass,
			actors = {},
		},
	},
	chase_target_template = {
		attach_range = 2,
		fizzle_out_duration = 2,
		flight_speed = 1.75,
		lifetime = 60,
		new_target_wait_time = 10,
		random_wander = false,
		stop_and_process_player = true,
		vfx_follow_speed = 1,
		vfx_ground_offset = 0.75,
	},
	companion_pounce_setting = {
		companion_pounce_action = "stagger_and_leap_away",
		ignore_target_selection = true,
	},
}

return breed_data
