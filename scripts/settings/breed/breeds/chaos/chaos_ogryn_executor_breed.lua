-- chunkname: @scripts/settings/breed/breeds/chaos/chaos_ogryn_executor_breed.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BreedBlackboardComponentTemplates = require("scripts/settings/breed/breed_blackboard_component_templates")
local BreedCombatRanges = require("scripts/settings/breed/breed_combat_ranges")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local BreedTerrorEventSettings = require("scripts/settings/breed/breed_terror_event_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
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
local damage_types = DamageSettings.damage_types
local hit_zone_names = HitZone.hit_zone_names
local stagger_types = StaggerSettings.stagger_types
local weakspot_types = WeakspotSettings.types
local breed_name = "chaos_ogryn_executor"
local breed_data = {
	accumulative_stagger_multiplier = 0.1,
	activate_slot_system_on_spawn = true,
	aggro_inventory_slot = "slot_melee_weapon",
	base_height = 2.9,
	base_unit = "content/characters/enemy/chaos_ogryn/third_person/base",
	bone_lod_radius = 2.3,
	broadphase_radius = 1,
	can_patrol = true,
	challenge_rating = 8,
	detection_radius = 13,
	display_name = "loc_breed_display_name_chaos_ogryn_executor",
	explosion_radius = 0.25,
	faction_name = "chaos",
	fx_proximity_culling_weight = 8,
	game_object_type = "minion_melee",
	half_extent_forward = 0.5,
	half_extent_right = 0.5,
	has_direct_ragdoll_flow_event = true,
	line_of_sight_collision_filter = "filter_minion_line_of_sight_check",
	player_locomotion_constrain_radius = 0.9,
	power_level_type = "chaos_ogryn_executor_melee",
	push_multiplier = 2.5,
	run_speed = 5.25,
	slot_template = "chaos_ogryn",
	smart_tag_target_type = "breed",
	smite_stagger_immunity = true,
	spawn_inventory_slot = "slot_melee_weapon",
	stagger_reduction = 15,
	stagger_reduction_ranged = 15,
	stagger_resistance = 1,
	state_machine = "content/characters/enemy/chaos_ogryn/third_person/animations/chaos_ogryn_executor",
	sub_faction_name = "chaos",
	unit_template_name = "minion",
	use_avoidance = true,
	use_bone_lod = true,
	use_navigation_path_splines = true,
	use_wounds = true,
	walk_speed = 2,
	name = breed_name,
	breed_type = breed_types.minion,
	tags = {
		elite = true,
		melee = true,
		minion = true,
		ogryn = true,
	},
	point_cost = BreedTerrorEventSettings[breed_name].point_cost,
	armor_type = armor_types.super_armor,
	hit_mass = MinionDifficultySettings.hit_mass[breed_name],
	gib_template = MinionGibbingTemplates.chaos_ogryn_executor,
	stagger_durations = {
		[stagger_types.light] = 0.75,
		[stagger_types.medium] = 2,
		[stagger_types.heavy] = 2.75,
		[stagger_types.explosion] = 3,
		[stagger_types.killshot] = 1,
		[stagger_types.light_ranged] = 1,
		[stagger_types.sticky] = 0.6,
	},
	stagger_thresholds = {
		[stagger_types.light] = 20,
		[stagger_types.medium] = 80,
		[stagger_types.heavy] = 160,
		[stagger_types.explosion] = 200,
		[stagger_types.light_ranged] = 60,
		[stagger_types.killshot] = 60,
		[stagger_types.sticky] = 10,
	},
	stagger_immune_times = {
		[stagger_types.light] = 3,
		[stagger_types.medium] = 4,
		[stagger_types.heavy] = 6,
		[stagger_types.explosion] = 4,
		[stagger_types.light_ranged] = 3,
		[stagger_types.sticky] = 0.25,
		[stagger_types.killshot] = 6,
	},
	inventory = MinionVisualLoadoutTemplates.chaos_ogryn_executor,
	sounds = require("scripts/settings/breed/breeds/chaos/chaos_ogryn_executor_sounds"),
	vfx = require("scripts/settings/breed/breeds/renegade/renegade_common_vfx"),
	behavior_tree_name = breed_name,
	animation_variables = {
		"moving_attack_fwd_speed",
		"anim_move_speed",
	},
	combat_range_data = BreedCombatRanges.chaos_ogryn_executor,
	attack_intensity_cooldowns = {
		melee = {
			0.1,
			0.25,
		},
		moving_melee = {
			0.25,
			0.5,
		},
		running_melee = {
			0.25,
			0.5,
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
	target_selection_weights = TargetSelectionWeights.chaos_ogryn_executor,
	threat_config = {
		max_threat = 10,
		threat_decay_per_second = 5,
		threat_multiplier = 0.1,
	},
	smart_object_template = SmartObjectSettings.templates.chaos_ogryn,
	size_variation_range = {
		0.97,
		0.99,
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
			j_head = 0.5,
			j_leftshoulder = 0.05,
			j_neck = 0.25,
			j_rightshoulder = 0.05,
			j_spine = 0.2,
			j_spine1 = 0.1,
		},
		[hit_zone_names.torso] = {
			j_head = 0.1,
			j_leftshoulder = 0,
			j_neck = 0.1,
			j_rightshoulder = 0,
			j_spine = 0.2,
			j_spine1 = 0.7,
		},
		[hit_zone_names.upper_left_arm] = {
			j_head = 0.05,
			j_leftshoulder = 0.4,
			j_leftuparm = 0.8,
			j_neck = 0.05,
			j_spine = 0.15,
			j_spine1 = 0.1,
		},
		[hit_zone_names.lower_left_arm] = {
			j_head = 0.05,
			j_leftshoulder = 0.4,
			j_leftuparm = 0.8,
			j_neck = 0.05,
			j_spine = 0.15,
			j_spine1 = 0.1,
		},
		[hit_zone_names.upper_right_arm] = {
			j_head = 0.05,
			j_neck = 0.05,
			j_rightshoulder = 0.4,
			j_rightuparm = 0.8,
			j_spine = 0.15,
			j_spine1 = 0.1,
		},
		[hit_zone_names.lower_right_arm] = {
			j_head = 0.05,
			j_neck = 0.05,
			j_rightshoulder = 0.4,
			j_rightuparm = 0.8,
			j_spine = 0.15,
			j_spine1 = 0.1,
		},
		[hit_zone_names.upper_left_leg] = {
			j_hips = 0.2,
			j_leftfoot = 0.1,
			j_leftleg = 0.35,
			j_leftupleg = 0.35,
			j_spine = 0,
			j_spine1 = 0.1,
		},
		[hit_zone_names.lower_left_leg] = {
			j_hips = 0.2,
			j_leftfoot = 0.1,
			j_leftleg = 0.35,
			j_leftupleg = 0.35,
			j_spine = 0,
			j_spine1 = 0.1,
		},
		[hit_zone_names.upper_right_leg] = {
			j_hips = 0.1,
			j_rightfoot = 0.3,
			j_rightleg = 0.25,
			j_rightupleg = 0.4,
			j_spine = 0,
			j_spine1 = 0,
		},
		[hit_zone_names.lower_right_leg] = {
			j_hips = 0.1,
			j_rightfoot = 0.3,
			j_rightleg = 0.25,
			j_rightupleg = 0.4,
			j_spine = 0,
			j_spine1 = 0,
		},
		[hit_zone_names.center_mass] = {
			j_hips = 0.5,
			j_spine = 0.5,
		},
	},
	wounds_config = {
		always_show_killing_blow = false,
		apply_threshold_filtering = true,
		health_percent_throttle = 0.3,
		radius_multiplier = 1,
		thresholds = {
			[damage_types.blunt] = 0.25,
			[damage_types.blunt_heavy] = 0.25,
			[damage_types.blunt_thunder] = 0.25,
			[damage_types.plasma] = 0.25,
			[damage_types.rippergun_pellet] = 0.25,
			[damage_types.auto_bullet] = 0.25,
			[damage_types.pellet] = 0.25,
			[damage_types.boltshell] = 0.05,
			[damage_types.laser] = 0.25,
			[damage_types.power_sword] = 0.01,
			[damage_types.sawing_stuck] = 0.25,
			[damage_types.slashing_force_stuck] = 0.25,
			[damage_types.combat_blade] = 0.25,
		},
	},
	hit_zone_weakspot_types = {
		[hit_zone_names.head] = weakspot_types.headshot,
	},
	hitzone_damage_multiplier = {
		ranged = {
			[hit_zone_names.lower_left_arm] = 0.5,
			[hit_zone_names.lower_right_arm] = 0.5,
			[hit_zone_names.lower_left_leg] = 0.5,
			[hit_zone_names.lower_right_leg] = 0.5,
		},
	},
	outline_config = {},
	blackboard_component_config = BreedBlackboardComponentTemplates.melee_patroller,
}

return breed_data
