﻿-- chunkname: @scripts/settings/breed/breeds/chaos/chaos_hound_mutator_breed.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BreedBlackboardComponentTemplates = require("scripts/settings/breed/breed_blackboard_component_templates")
local BreedCombatRanges = require("scripts/settings/breed/breed_combat_ranges")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MinionDifficultySettings = require("scripts/settings/difficulty/minion_difficulty_settings")
local MinionGibbingTemplates = require("scripts/managers/minion/minion_gibbing_templates")
local MinionVisualLoadoutTemplates = require("scripts/settings/minion_visual_loadout/minion_visual_loadout_templates")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local SmartObjectSettings = require("scripts/settings/navigation/smart_object_settings")
local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local TargetSelectionTemplates = require("scripts/extension_systems/perception/target_selection_templates")
local TargetSelectionWeights = require("scripts/settings/minion_target_selection/minion_target_selection_weights")
local WeakspotSettings = require("scripts/settings/damage/weakspot_settings")
local armor_types = ArmorSettings.types
local breed_types = BreedSettings.types
local hit_zone_names = HitZone.hit_zone_names
local stagger_types = StaggerSettings.stagger_types
local weakspot_types = WeakspotSettings.types
local breed_name = "chaos_hound"
local breed_data = {
	base_height = 1.5,
	base_unit = "content/characters/enemy/chaos_hound/third_person/base",
	bone_lod_radius = 1.5,
	broadphase_radius = 1,
	can_be_used_for_all_factions = true,
	challenge_rating = 1,
	display_name = "loc_breed_display_name_chaos_hound",
	faction_name = "chaos",
	fx_proximity_culling_weight = 6,
	game_object_type = "minion_chaos_hound",
	half_extent_forward = 0.8,
	half_extent_right = 0.3,
	line_of_sight_collision_filter = "filter_minion_line_of_sight_check",
	look_at_distance = 20,
	name = "chaos_hound_mutator",
	navigation_propagation_box_extent = 200,
	player_locomotion_constrain_radius = 0.7,
	run_speed = 6,
	smart_tag_target_type = "breed",
	spawn_aggro_state = "aggroed",
	stagger_resistance = 2,
	sub_faction_name = "chaos",
	target_stickiness_distance = 10,
	unit_template_name = "minion",
	use_avoidance = true,
	use_bone_lod = false,
	use_death_velocity = true,
	use_navigation_path_splines = true,
	use_wounds = true,
	uses_wwise_special_targeting_parameter = true,
	volley_fire_target = true,
	walk_speed = 2.3,
	breed_type = breed_types.minion,
	tags = {
		disabler = true,
		minion = true,
		mutator = true,
		special = true,
	},
	point_cost = math.huge,
	armor_type = armor_types.disgustingly_resilient,
	hit_mass = MinionDifficultySettings.hit_mass[breed_name],
	gib_template = MinionGibbingTemplates.chaos_hound,
	stagger_durations = {
		[stagger_types.light] = 1,
		[stagger_types.medium] = 1,
		[stagger_types.heavy] = 2,
		[stagger_types.light_ranged] = 1,
		[stagger_types.explosion] = 1,
		[stagger_types.killshot] = 1,
		[stagger_types.sticky] = 1,
	},
	stagger_immune_times = {
		[stagger_types.light] = 0.5,
		[stagger_types.medium] = 0.5,
		[stagger_types.heavy] = 0.5,
		[stagger_types.light_ranged] = 0.5,
		[stagger_types.killshot] = 0.5,
	},
	inventory = MinionVisualLoadoutTemplates.chaos_hound_mutator,
	sounds = require("scripts/settings/breed/breeds/chaos/chaos_hound_mutator_sounds"),
	vfx = require("scripts/settings/breed/breeds/chaos/chaos_common_vfx"),
	look_at_tag = breed_name,
	behavior_tree_name = breed_name,
	animation_variables = {
		"gallop_lean",
	},
	attack_intensity_cooldowns = {
		disabling = {
			1.7,
			2.8,
		},
	},
	detection_radius = math.huge,
	target_changed_attack_intensities = {
		disabling = 5,
	},
	line_of_sight_data = {
		{
			from_node = "j_head",
			id = "eyes",
			to_node = "enemy_aim_target_03",
			offsets = PerceptionSettings.default_minion_line_of_sight_offsets,
		},
	},
	target_selection_template = TargetSelectionTemplates.chaos_hound,
	target_selection_weights = TargetSelectionWeights.chaos_hound,
	threat_config = {
		max_threat = 50,
		threat_decay_per_second = 2.5,
		threat_multiplier = 1,
	},
	aim_config = {
		distance = 5,
		lerp_speed = 200,
		node = "j_neck",
		target = "head_aim_target",
		target_node = "enemy_aim_target_03",
	},
	combat_range_data = BreedCombatRanges.chaos_hound_mutator,
	combat_vector_config = {
		choose_furthest_away = true,
		default_combat_range = "far",
		valid_combat_ranges = {
			far = true,
		},
	},
	navigation_path_spline_config = {
		channel_smoothing_angle = 15,
		max_distance_between_gates = 5,
		max_distance_to_spline_position = 5,
		min_distance_between_gates = 0.25,
		navigation_channel_radius = 6,
		spline_distance_to_borders = 2,
		spline_length = 100,
		spline_recomputation_ratio = 0.5,
		turn_sampling_angle = 30,
	},
	nav_tag_allowed_layers = {
		cover_ledges = 40,
		cover_vaults = 0.5,
		jumps = 40,
		ledges = 40,
		ledges_with_fence = 40,
	},
	smart_object_template = SmartObjectSettings.templates.chaos_hound,
	size_variation_range = {
		0.9,
		0.92,
	},
	fade = {
		max_distance = 0.7,
		max_height_difference = 1,
		min_distance = 0.2,
	},
	hit_zones = {
		{
			name = hit_zone_names.head,
			actors = {
				"c_head",
				"c_neck",
				"c_neck1",
			},
		},
		{
			name = hit_zone_names.torso,
			actors = {
				"c_hips",
				"c_spine",
				"c_spine1",
				"c_spine2",
			},
		},
		{
			name = hit_zone_names.upper_left_arm,
			actors = {
				"c_leftarm",
			},
		},
		{
			name = hit_zone_names.lower_left_arm,
			actors = {
				"c_leftforearm",
				"c_lefthand",
				"c_leftfingerbase",
			},
		},
		{
			name = hit_zone_names.upper_right_arm,
			actors = {
				"c_rightarm",
			},
		},
		{
			name = hit_zone_names.lower_right_arm,
			actors = {
				"c_rightforearm",
				"c_righthand",
				"c_rightfingerbase",
			},
		},
		{
			name = hit_zone_names.upper_left_leg,
			actors = {
				"c_leftupleg",
			},
		},
		{
			name = hit_zone_names.lower_left_leg,
			actors = {
				"c_leftleg",
				"c_leftfoot",
				"c_lefttoebase",
			},
		},
		{
			name = hit_zone_names.upper_right_leg,
			actors = {
				"c_rightupleg",
			},
		},
		{
			name = hit_zone_names.lower_right_leg,
			actors = {
				"c_rightleg",
				"c_rightfoot",
				"c_righttoebase",
			},
		},
		{
			name = hit_zone_names.afro,
			actors = {
				"r_afro",
			},
		},
		{
			name = hit_zone_names.center_mass,
			actors = {
				"c_spine",
				"c_spine1",
				"c_spine2",
			},
		},
	},
	hit_zone_ragdoll_actors = {
		[hit_zone_names.head] = {
			"j_head",
			"j_neck",
			"j_jaw",
		},
		[hit_zone_names.torso] = {
			"j_spine1",
			"j_spine2",
			"j_head",
			"j_neck",
			"j_leftarm",
			"j_leftforearm",
			"j_lefthand",
			"j_leftfingerbase",
			"j_rightarm",
			"j_rightforearm",
			"j_righthand",
			"j_rightfingerbase",
		},
		[hit_zone_names.upper_left_arm] = {
			"j_leftarm",
			"j_leftforearm",
			"j_lefthand",
			"j_leftfingerbase",
		},
		[hit_zone_names.lower_left_arm] = {
			"j_leftforearm",
			"j_lefthand",
			"j_leftfingerbase",
		},
		[hit_zone_names.upper_right_arm] = {
			"j_rightarm",
			"j_rightforearm",
			"j_righthand",
			"j_rightfingerbase",
		},
		[hit_zone_names.lower_right_arm] = {
			"j_rightforearm",
			"j_righthand",
			"j_rightfingerbase",
		},
		[hit_zone_names.upper_left_leg] = {
			"j_leftupleg",
			"j_leftleg",
			"j_leftfoot",
			"j_lefttoebase",
		},
		[hit_zone_names.lower_left_leg] = {
			"j_leftleg",
			"j_leftfoot",
			"j_lefttoebase",
		},
		[hit_zone_names.upper_right_leg] = {
			"j_rightupleg",
			"j_rightleg",
			"j_rightfoot",
			"j_righttoebase",
		},
		[hit_zone_names.lower_right_leg] = {
			"j_rightleg",
			"j_rightfoot",
			"j_righttoebase",
		},
	},
	hit_zone_ragdoll_pushes = {
		[hit_zone_names.head] = {
			j_head = 0.15,
			j_neck = 0.1,
			j_spine = 0.4,
			j_spine1 = 0.4,
		},
		[hit_zone_names.torso] = {
			j_head = 0.1,
			j_neck = 0.1,
			j_spine = 0.4,
			j_spine1 = 0.4,
		},
		[hit_zone_names.upper_left_arm] = {
			j_head = 0.1,
			j_neck = 0.1,
			j_spine = 0.4,
			j_spine1 = 0.4,
		},
		[hit_zone_names.upper_right_arm] = {
			j_head = 0.1,
			j_neck = 0.1,
			j_spine = 0.4,
			j_spine1 = 0.4,
		},
		[hit_zone_names.upper_left_leg] = {
			j_hips = 0.25,
			j_leftfoot = 0.2,
			j_leftleg = 0.4,
			j_leftupleg = 0.25,
			j_spine = 0.3,
			j_spine1 = 0.3,
		},
		[hit_zone_names.upper_right_leg] = {
			j_hips = 0.25,
			j_rightfoot = 0.2,
			j_rightleg = 0.4,
			j_rightupleg = 0.25,
			j_spine = 0.3,
			j_spine1 = 0.3,
		},
		[hit_zone_names.lower_left_arm] = {
			j_head = 0.1,
			j_neck = 0.1,
			j_spine = 0.4,
			j_spine1 = 0.4,
		},
		[hit_zone_names.lower_right_arm] = {
			j_head = 0.1,
			j_neck = 0.1,
			j_spine = 0.4,
			j_spine1 = 0.4,
		},
		[hit_zone_names.lower_left_leg] = {
			j_hips = 0.25,
			j_leftfoot = 0.2,
			j_leftleg = 0.4,
			j_leftupleg = 0.25,
			j_spine = 0.3,
			j_spine1 = 0.3,
		},
		[hit_zone_names.lower_right_leg] = {
			j_hips = 0.25,
			j_rightfoot = 0.2,
			j_rightleg = 0.4,
			j_rightupleg = 0.25,
			j_spine = 0.3,
			j_spine1 = 0.3,
		},
		[hit_zone_names.center_mass] = {
			j_hips = 0.5,
			j_spine = 0.5,
		},
	},
	hit_zone_weakspot_types = {
		[hit_zone_names.head] = weakspot_types.headshot,
	},
	hitzone_damage_multiplier = {
		melee = {
			[hit_zone_names.head] = 3,
			[hit_zone_names.torso] = 3,
			[hit_zone_names.upper_left_arm] = 3,
			[hit_zone_names.upper_right_arm] = 3,
			[hit_zone_names.upper_left_leg] = 3,
			[hit_zone_names.upper_right_leg] = 3,
			[hit_zone_names.lower_left_arm] = 3,
			[hit_zone_names.lower_right_arm] = 3,
			[hit_zone_names.lower_left_leg] = 3,
			[hit_zone_names.lower_right_leg] = 3,
			[hit_zone_names.center_mass] = 3,
		},
	},
	outline_config = {},
	blackboard_component_config = BreedBlackboardComponentTemplates.chaos_hound,
}

return breed_data
