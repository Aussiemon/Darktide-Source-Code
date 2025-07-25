﻿-- chunkname: @scripts/settings/breed/breeds/chaos/chaos_ogryn_bulwark_breed.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BreedBlackboardComponentTemplates = require("scripts/settings/breed/breed_blackboard_component_templates")
local BreedCombatRanges = require("scripts/settings/breed/breed_combat_ranges")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local BreedShieldTemplates = require("scripts/settings/breed/breed_shield_templates")
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
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local armor_types = ArmorSettings.types
local breed_types = BreedSettings.types
local hit_zone_names = HitZone.hit_zone_names
local stagger_types = StaggerSettings.stagger_types
local weakspot_types = WeakspotSettings.types
local breed_name = "chaos_ogryn_bulwark"
local breed_data = {
	activate_slot_system_on_spawn = true,
	base_height = 2.5,
	base_unit = "content/characters/enemy/chaos_ogryn/third_person/base",
	bone_lod_radius = 1.7,
	broadphase_radius = 1,
	can_patrol = true,
	challenge_rating = 8,
	detection_radius = 13,
	display_name = "loc_breed_display_name_chaos_ogryn_bulwark",
	explosion_radius = 0.25,
	faction_name = "chaos",
	fx_proximity_culling_weight = 5,
	game_object_type = "minion_shield_melee",
	half_extent_forward = 0.5,
	half_extent_right = 0.5,
	has_direct_ragdoll_flow_event = true,
	line_of_sight_collision_filter = "filter_minion_line_of_sight_check",
	player_locomotion_constrain_radius = 0.9,
	power_level_type = "chaos_ogryn_default_melee",
	reverse_stagger_count = true,
	run_speed = 5.6,
	slot_template = "chaos_ogryn",
	smart_tag_target_type = "breed",
	smite_stagger_immunity = true,
	spawn_inventory_slot = "slot_shield",
	stagger_reduction = 5,
	stagger_reduction_ranged = 10,
	stagger_resistance = 1,
	state_machine = "content/characters/enemy/chaos_ogryn/third_person/animations/chaos_ogryn_bulwark",
	sub_faction_name = "chaos",
	unit_template_name = "minion",
	use_avoidance = true,
	use_bone_lod = true,
	use_navigation_path_splines = true,
	use_wounds = true,
	walk_speed = 1.9,
	name = breed_name,
	breed_type = breed_types.minion,
	tags = {
		bulwark = true,
		elite = true,
		melee = true,
		minion = true,
		ogryn = true,
	},
	point_cost = BreedTerrorEventSettings[breed_name].point_cost,
	armor_type = armor_types.resistant,
	hit_mass = MinionDifficultySettings.hit_mass[breed_name],
	gib_template = MinionGibbingTemplates.chaos_ogryn_bulwark,
	stagger_durations = {
		[stagger_types.light] = 2.6666666666666665,
		[stagger_types.medium] = 2.6666666666666665,
		[stagger_types.heavy] = 3.5,
		[stagger_types.explosion] = 3,
		[stagger_types.light_ranged] = 2.5,
		[stagger_types.killshot] = 2.5,
		[stagger_types.sticky] = 0.6,
		[stagger_types.shield_block] = 0.4166666666666667,
		[stagger_types.shield_heavy_block] = 3.076923076923077,
		[stagger_types.shield_broken] = 3.8461538461538463,
	},
	stagger_thresholds = {
		[stagger_types.light] = 30,
		[stagger_types.medium] = 60,
		[stagger_types.heavy] = 120,
		[stagger_types.explosion] = 200,
		[stagger_types.light_ranged] = 60,
		[stagger_types.killshot] = 60,
		[stagger_types.sticky] = 1,
	},
	stagger_immune_times = {
		[stagger_types.light] = 4,
		[stagger_types.medium] = 4,
		[stagger_types.heavy] = 5,
		[stagger_types.explosion] = 3,
		[stagger_types.light_ranged] = 1.5,
		[stagger_types.killshot] = 1.5,
		[stagger_types.shield_block] = 1.5,
		[stagger_types.shield_heavy_block] = 1,
		[stagger_types.shield_broken] = 4,
		[stagger_types.sticky] = 0.25,
	},
	impact_anim_override = {
		shield_blocked = {
			bwd = "offset_shield_hit_reaction_up",
			fwd = "offset_shield_hit_reaction_up",
			left = "offset_shield_hit_reaction_left",
			right = "offset_shield_hit_reaction_right",
		},
	},
	inventory = MinionVisualLoadoutTemplates.chaos_ogryn_bulwark,
	sounds = require("scripts/settings/breed/breeds/chaos/chaos_ogryn_bulwark_sounds"),
	vfx = require("scripts/settings/breed/breeds/chaos/chaos_common_vfx"),
	behavior_tree_name = breed_name,
	shield_template = BreedShieldTemplates.chaos_ogryn_bulwark,
	animation_variables = {
		"moving_attack_fwd_speed",
		"anim_move_speed",
	},
	combat_range_data = BreedCombatRanges.chaos_ogryn_bulwark,
	attack_intensity_cooldowns = {
		melee = {
			0,
			0,
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
	line_of_sight_data = {
		{
			from_node = "j_head",
			id = "eyes",
			to_node = "enemy_aim_target_03",
			offsets = PerceptionSettings.default_minion_line_of_sight_offsets,
		},
	},
	target_selection_template = TargetSelectionTemplates.melee_elite,
	target_selection_weights = TargetSelectionWeights.chaos_ogryn_bulwark,
	threat_config = {
		max_threat = 10,
		threat_decay_per_second = 5,
		threat_multiplier = 0.1,
	},
	smart_object_template = SmartObjectSettings.templates.chaos_ogryn,
	size_variation_range = {
		0.97,
		0.98,
	},
	fade = {
		max_distance = 0.7,
		max_height_difference = 1.2,
		min_distance = 0.3,
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
			create_on_startup = true,
			destroy_on_death = true,
			name = hit_zone_names.shield,
			actors = {
				"c_shield",
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
				"c_leftshoulder",
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
				"c_rightshoulder",
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
			"j_leftarm",
			"j_leftshoulder",
			"j_leftforearm",
			"j_lefthand",
			"j_rightarm",
			"j_rightshoulder",
			"j_rightforearm",
			"j_righthand",
		},
		[hit_zone_names.upper_left_arm] = {
			"j_leftarm",
			"j_leftshoulder",
			"j_leftforearm",
			"j_lefthand",
		},
		[hit_zone_names.lower_left_arm] = {
			"j_leftforearm",
			"j_lefthand",
		},
		[hit_zone_names.upper_right_arm] = {
			"j_rightarm",
			"j_rightshoulder",
			"j_rightforearm",
			"j_righthand",
		},
		[hit_zone_names.lower_right_arm] = {
			"j_rightforearm",
			"j_righthand",
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
			j_head = 0.3,
			j_leftshoulder = 0.25,
			j_neck = 0.1,
			j_rightshoulder = 0.25,
			j_spine = 0.4,
			j_spine1 = 0.4,
		},
		[hit_zone_names.torso] = {
			j_head = 0.1,
			j_leftshoulder = 0.2,
			j_neck = 0.1,
			j_rightshoulder = 0.2,
			j_spine = 0.4,
			j_spine1 = 0.6,
		},
		[hit_zone_names.shield] = {
			j_head = 0.1,
			j_leftshoulder = 0.2,
			j_neck = 0.1,
			j_rightshoulder = 0.2,
			j_spine = 0.4,
			j_spine1 = 0.6,
		},
		[hit_zone_names.upper_left_arm] = {
			j_head = 0.1,
			j_leftshoulder = 1,
			j_neck = 0.1,
			j_spine = 0.4,
			j_spine1 = 0.4,
		},
		[hit_zone_names.lower_left_arm] = {
			j_head = 0.1,
			j_leftshoulder = 1,
			j_neck = 0.1,
			j_spine = 0.4,
			j_spine1 = 0.4,
		},
		[hit_zone_names.upper_right_arm] = {
			j_head = 0.1,
			j_neck = 0.1,
			j_rightshoulder = 1,
			j_spine = 0.4,
			j_spine1 = 0.4,
		},
		[hit_zone_names.lower_right_arm] = {
			j_head = 0.1,
			j_neck = 0.1,
			j_rightshoulder = 1,
			j_spine = 0.4,
			j_spine1 = 0.4,
		},
		[hit_zone_names.upper_left_leg] = {
			j_hips = 0.25,
			j_leftfoot = 0.4,
			j_leftleg = 0.6,
			j_leftupleg = 0.5,
			j_spine = 0.3,
			j_spine1 = 0.3,
		},
		[hit_zone_names.lower_left_leg] = {
			j_hips = 0.25,
			j_leftfoot = 0.4,
			j_leftleg = 0.6,
			j_leftupleg = 0.5,
			j_spine = 0.3,
			j_spine1 = 0.3,
		},
		[hit_zone_names.upper_right_leg] = {
			j_hips = 0.25,
			j_rightfoot = 0.4,
			j_rightleg = 0.6,
			j_rightupleg = 0.5,
			j_spine = 0.3,
			j_spine1 = 0.3,
		},
		[hit_zone_names.lower_right_leg] = {
			j_hips = 0.25,
			j_rightfoot = 0.4,
			j_rightleg = 0.6,
			j_rightupleg = 0.5,
			j_spine = 0.3,
			j_spine1 = 0.3,
		},
		[hit_zone_names.center_mass] = {
			j_hips = 0.5,
			j_spine = 0.5,
		},
	},
	wounds_config = {
		always_show_killing_blow = true,
		apply_threshold_filtering = false,
		health_percent_throttle = 0.2,
		radius_multiplier = 1.3,
	},
	hit_zone_weakspot_types = {
		[hit_zone_names.head] = weakspot_types.headshot,
		[hit_zone_names.shield] = weakspot_types.shield,
	},
	hitzone_armor_override = {
		[hit_zone_names.shield] = armor_types.super_armor,
		[hit_zone_names.lower_left_arm] = armor_types.super_armor,
		[hit_zone_names.lower_right_arm] = armor_types.super_armor,
		[hit_zone_names.upper_left_arm] = armor_types.super_armor,
		[hit_zone_names.upper_right_arm] = armor_types.super_armor,
		[hit_zone_names.lower_left_leg] = armor_types.super_armor,
		[hit_zone_names.lower_right_leg] = armor_types.super_armor,
	},
	hitzone_damage_multiplier = {
		default = {
			[hit_zone_names.shield] = 0,
		},
		melee = {
			[hit_zone_names.head] = 1,
			[hit_zone_names.lower_left_arm] = 1,
			[hit_zone_names.lower_right_arm] = 1,
			[hit_zone_names.lower_left_leg] = 1,
			[hit_zone_names.lower_right_leg] = 1,
		},
		ranged = {
			[hit_zone_names.head] = 1,
			[hit_zone_names.lower_left_arm] = 0.5,
			[hit_zone_names.lower_right_arm] = 0.5,
			[hit_zone_names.lower_left_leg] = 0.5,
			[hit_zone_names.lower_right_leg] = 0.5,
		},
	},
	outline_config = {},
	blackboard_component_config = BreedBlackboardComponentTemplates.melee_shield_patroller,
	companion_pounce_setting = {
		companion_pounce_action = "stagger_and_leap_away",
		on_target_hit = {
			anim_event = "attack_leap_nonhuman_start",
			animation_driven_duration = 0.5333333333333333,
		},
		land_anim_events = {
			{
				duration = 0.8333333333333334,
				name = "attack_leap_nonhuman_land_02",
			},
		},
		damage_profile = DamageProfileTemplates.adamant_companion_ogryn_pounce,
		force_stagger_settings = {
			duration = 2.5,
			immune_time = 2.5,
			length_scale = 1,
			stagger_type = "light",
		},
	},
}

return breed_data
