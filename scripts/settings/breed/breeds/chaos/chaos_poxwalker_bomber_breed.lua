﻿-- chunkname: @scripts/settings/breed/breeds/chaos/chaos_poxwalker_bomber_breed.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BreedBlackboardComponentTemplates = require("scripts/settings/breed/breed_blackboard_component_templates")
local BreedCombatRanges = require("scripts/settings/breed/breed_combat_ranges")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local BreedTerrorEventSettings = require("scripts/settings/breed/breed_terror_event_settings")
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
local breed_name = "chaos_poxwalker_bomber"
local breed_data = {
	base_height = 1.7,
	base_unit = "content/characters/enemy/chaos_poxwalker_bomber/third_person/base",
	bone_lod_radius = 1.1,
	broadphase_radius = 1,
	can_be_used_for_all_factions = true,
	challenge_rating = 2,
	display_name = "loc_breed_display_name_chaos_poxwalker_bomber",
	faction_name = "chaos",
	fx_proximity_culling_weight = 6,
	game_object_type = "minion_special_melee",
	line_of_sight_collision_filter = "filter_minion_line_of_sight_check",
	navigation_propagation_box_extent = 200,
	player_locomotion_constrain_radius = 0.35,
	power_level_type = "chaos_poxwalker_bomber_explosion",
	run_speed = 5,
	smart_tag_target_type = "breed",
	spawn_aggro_state = "aggroed",
	stagger_reduction = 1,
	stagger_reduction_ranged = 15,
	stagger_resistance = 2,
	sub_faction_name = "chaos",
	unit_template_name = "minion",
	use_bone_lod = true,
	uses_wwise_special_targeting_parameter = true,
	volley_fire_target = true,
	walk_speed = 2,
	name = breed_name,
	breed_type = breed_types.minion,
	tags = {
		bomber = true,
		minion = true,
		scrambler = true,
		special = true,
	},
	point_cost = BreedTerrorEventSettings[breed_name].point_cost,
	armor_type = armor_types.disgustingly_resilient,
	hit_mass = MinionDifficultySettings.hit_mass[breed_name],
	gib_template = MinionGibbingTemplates.chaos_poxwalker_bomber,
	stagger_durations = {
		[stagger_types.light] = 3.6666666666666665,
		[stagger_types.medium] = 3.6666666666666665,
		[stagger_types.heavy] = 3.6666666666666665,
		[stagger_types.light_ranged] = 3.6666666666666665,
		[stagger_types.explosion] = 3.6666666666666665,
		[stagger_types.killshot] = 3.6666666666666665,
		[stagger_types.sticky] = 3.6666666666666665,
	},
	stagger_immune_times = {
		[stagger_types.light] = 0,
		[stagger_types.medium] = 0,
		[stagger_types.heavy] = 0,
		[stagger_types.explosion] = 0,
		[stagger_types.light_ranged] = 0,
		[stagger_types.sticky] = 0,
		[stagger_types.killshot] = 0,
		[stagger_types.shield_block] = 0,
		[stagger_types.shield_heavy_block] = 0,
		[stagger_types.shield_broken] = 0,
		[stagger_types.wall_collision] = 0,
	},
	stagger_thresholds = {
		[stagger_types.light] = 1,
		[stagger_types.medium] = 5,
		[stagger_types.heavy] = 5,
		[stagger_types.light_ranged] = 100,
		[stagger_types.killshot] = 5,
		[stagger_types.sticky] = 100,
	},
	inventory = MinionVisualLoadoutTemplates.chaos_poxwalker_bomber,
	sounds = require("scripts/settings/breed/breeds/chaos/chaos_poxwalker_bomber_sounds"),
	vfx = require("scripts/settings/breed/breeds/chaos/chaos_common_vfx"),
	behavior_tree_name = breed_name,
	combat_range_data = BreedCombatRanges.chaos_poxwalker_bomber,
	attack_intensity_cooldowns = {
		melee = {
			1.7,
			2.8,
		},
		moving_melee = {
			1.7,
			2.8,
		},
		running_melee = {
			2.7,
			3.8,
		},
	},
	detection_radius = math.huge,
	line_of_sight_data = {
		{
			from_node = "j_head",
			id = "eyes",
			to_node = "enemy_aim_target_03",
			offsets = PerceptionSettings.default_minion_line_of_sight_offsets,
		},
	},
	target_selection_template = TargetSelectionTemplates.chaos_poxwalker_bomber,
	target_selection_weights = TargetSelectionWeights.chaos_poxwalker_bomber,
	threat_config = {
		max_threat = 50,
		threat_decay_per_second = 5,
		threat_multiplier = 0.1,
	},
	nav_tag_allowed_layers = {
		cover_ledges = 80,
		jumps = 80,
		ledges = 80,
		ledges_with_fence = 80,
		teleporters = 1.2,
	},
	smart_object_template = SmartObjectSettings.templates.chaos_poxwalker_bomber,
	size_variation_range = {
		1,
		1.075,
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
				"c_hips",
				"c_spine",
				"c_spine1",
			},
		},
	},
	hit_zone_ragdoll_actors = {
		[hit_zone_names.head] = {
			"j_head",
			"j_neck",
		},
		[hit_zone_names.torso] = {
			"j_head",
			"j_neck",
			"j_spine",
			"j_spine1",
			"j_spine2",
		},
		[hit_zone_names.upper_left_leg] = {
			"j_leftupleg",
			"j_leftleg",
			"j_leftfoot",
		},
		[hit_zone_names.lower_left_leg] = {
			"j_leftleg",
			"j_leftfoot",
		},
		[hit_zone_names.upper_right_leg] = {
			"j_rightupleg",
			"j_rightleg",
			"j_rightfoot",
		},
		[hit_zone_names.lower_right_leg] = {
			"j_rightleg",
			"j_rightfoot",
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
		explosion = {
			[hit_zone_names.head] = 30,
			[hit_zone_names.torso] = 30,
			[hit_zone_names.upper_left_arm] = 30,
			[hit_zone_names.upper_right_arm] = 30,
			[hit_zone_names.upper_left_leg] = 30,
			[hit_zone_names.upper_right_leg] = 30,
			[hit_zone_names.lower_left_arm] = 30,
			[hit_zone_names.lower_right_arm] = 30,
			[hit_zone_names.lower_left_leg] = 30,
			[hit_zone_names.lower_right_leg] = 30,
			[hit_zone_names.center_mass] = 30,
		},
	},
	outline_config = {},
	blackboard_component_config = BreedBlackboardComponentTemplates.chaos_poxwalker_bomber,
}

return breed_data
