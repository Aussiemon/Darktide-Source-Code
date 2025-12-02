-- chunkname: @scripts/settings/breed/breeds/renegade/renegade_grenadier_breed.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BreedBlackboardComponentTemplates = require("scripts/settings/breed/breed_blackboard_component_templates")
local BreedCombatRanges = require("scripts/settings/breed/breed_combat_ranges")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local BreedTerrorEventSettings = require("scripts/settings/breed/breed_terror_event_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
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
local hit_zone_damage_multiplier = 2
local breed_name = "renegade_grenadier"
local breed_data = {
	achievement_breed_group = "grenadier",
	base_height = 2,
	base_unit = "content/characters/enemy/chaos_traitor_guard/third_person/base",
	bone_lod_radius = 1.3,
	broadphase_radius = 1,
	can_be_used_for_all_factions = true,
	challenge_rating = 2,
	count_num_attacks = true,
	display_name = "loc_breed_display_name_renegade_grenadier",
	faction_name = "chaos",
	fx_proximity_culling_weight = 6,
	game_object_type = "minion_ranged",
	has_direct_ragdoll_flow_event = true,
	line_of_sight_collision_filter = "filter_minion_line_of_sight_check",
	navigation_propagation_box_extent = 200,
	player_locomotion_constrain_radius = 0.5,
	run_speed = 4.8,
	smart_tag_target_type = "breed",
	spawn_aggro_state = "aggroed",
	stagger_reduction = 0,
	stagger_reduction_ranged = 20,
	stagger_resistance = 1,
	state_machine = "content/characters/enemy/chaos_traitor_guard/third_person/animations/chaos_traitor_guard_grenadier",
	sub_faction_name = "renegade",
	unit_template_name = "minion",
	use_bone_lod = true,
	use_wounds = true,
	volley_fire_target = true,
	walk_speed = 2.3,
	name = breed_name,
	breed_type = breed_types.minion,
	power_level_type = {
		melee = "renegade_default_melee",
	},
	size_variation_range = {
		1.16,
		1.16,
	},
	tags = {
		minion = true,
		scrambler = true,
		special = true,
	},
	point_cost = BreedTerrorEventSettings[breed_name].point_cost,
	armor_type = armor_types.armored,
	hit_mass = MinionDifficultySettings.hit_mass[breed_name],
	gib_template = MinionGibbingTemplates.renegade_grenadier_gibbing,
	stagger_durations = {
		[stagger_types.light] = 0.75,
		[stagger_types.medium] = 1.25,
		[stagger_types.heavy] = 2.8,
		[stagger_types.light_ranged] = 0.5,
		[stagger_types.explosion] = 6.363636363636363,
		[stagger_types.killshot] = 1.85,
		[stagger_types.sticky] = 1,
	},
	stagger_immune_times = {
		[stagger_types.light] = 0.2,
		[stagger_types.medium] = 0.2,
		[stagger_types.heavy] = 1.75,
		[stagger_types.light_ranged] = 0.2,
	},
	stagger_thresholds = {
		[stagger_types.light] = 5,
		[stagger_types.medium] = 15,
		[stagger_types.heavy] = 30,
		[stagger_types.light_ranged] = 5,
		[stagger_types.sticky] = 5,
	},
	inventory = MinionVisualLoadoutTemplates.renegade_grenadier,
	sounds = require("scripts/settings/breed/breeds/renegade/renegade_grenadier_sounds"),
	vfx = require("scripts/settings/breed/breeds/renegade/renegade_common_vfx"),
	behavior_tree_name = breed_name,
	spawn_buffs = {
		"renegade_grenadier_liquid_immunity",
	},
	combat_range_data = BreedCombatRanges.renegade_grenadier,
	combat_vector_config = {
		can_flank = true,
		choose_furthest_away = true,
		default_combat_range = "far",
		valid_combat_ranges = {
			far = true,
		},
	},
	attack_intensity_cooldowns = {
		melee = {
			1.7,
			2.8,
		},
		ranged = {
			0.3,
			0.4,
		},
		moving_melee = {
			1.7,
			2.8,
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
	target_selection_template = TargetSelectionTemplates.renegade_grenadier,
	target_selection_weights = TargetSelectionWeights.renegade_grenadier,
	threat_config = {
		max_threat = 50,
		threat_decay_per_second = 5,
		threat_multiplier = 0.1,
	},
	aim_config = {
		distance = 5,
		lerp_speed = 5,
		node = "j_neck",
		require_line_of_sight = true,
		target = "head_aim_target",
		target_node = "enemy_aim_target_03",
	},
	smart_object_template = SmartObjectSettings.templates.renegade,
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
			"j_spine",
			"j_spine1",
			"j_neck",
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
			j_leftshoulder = 0.05,
			j_neck = 0.3,
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
	hit_zone_weakspot_types = {
		[hit_zone_names.head] = weakspot_types.headshot,
	},
	hitzone_armor_override = {
		[hit_zone_names.head] = armor_types.unarmored,
		[hit_zone_names.lower_left_arm] = armor_types.unarmored,
		[hit_zone_names.lower_right_arm] = armor_types.unarmored,
	},
	hitzone_damage_multiplier = {
		melee = {
			[hit_zone_names.head] = hit_zone_damage_multiplier,
			[hit_zone_names.torso] = hit_zone_damage_multiplier,
			[hit_zone_names.upper_left_arm] = hit_zone_damage_multiplier,
			[hit_zone_names.upper_right_arm] = hit_zone_damage_multiplier,
			[hit_zone_names.upper_left_leg] = hit_zone_damage_multiplier,
			[hit_zone_names.upper_right_leg] = hit_zone_damage_multiplier,
			[hit_zone_names.lower_left_arm] = hit_zone_damage_multiplier,
			[hit_zone_names.lower_right_arm] = hit_zone_damage_multiplier,
			[hit_zone_names.lower_left_leg] = hit_zone_damage_multiplier,
			[hit_zone_names.lower_right_leg] = hit_zone_damage_multiplier,
			[hit_zone_names.center_mass] = hit_zone_damage_multiplier,
		},
	},
	outline_config = {},
	blackboard_component_config = BreedBlackboardComponentTemplates.grenadier,
	tokens = {
		pounced = nil,
	},
	companion_pounce_setting = {
		companion_pounce_action = "human",
		pounce_anim_event = "leap_attack",
		damage_profile = DamageProfileTemplates.adamant_companion_human_pounce,
		initial_damage_profile = DamageProfileTemplates.adamant_companion_initial_pounce,
		required_token = {
			free_target_on_assigned_token = true,
			name = "pounced",
		},
	},
}

return breed_data
