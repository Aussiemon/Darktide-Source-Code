-- chunkname: @scripts/settings/breed/breeds/renegade/renegade_twin_captain_two_breed.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BossNameTemplates = require("scripts/settings/boss/boss_name_templates")
local BreedBlackboardComponentTemplates = require("scripts/settings/breed/breed_blackboard_component_templates")
local BreedCombatRanges = require("scripts/settings/breed/breed_combat_ranges")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MinionDifficultySettings = require("scripts/settings/difficulty/minion_difficulty_settings")
local MinionToughnessTemplates = require("scripts/settings/toughness/minion_toughness_templates")
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
local breed_name = "renegade_twin_captain_two"
local breed_data = {
	activate_slot_system_on_spawn = true,
	base_height = 2,
	base_unit = "content/characters/enemy/chaos_traitor_guard_captain/third_person/base",
	bone_lod_radius = 1.3,
	broadphase_radius = 1,
	can_have_invulnerable_toughness = true,
	challenge_rating = 2,
	clamp_health_percent_damage = 0.2,
	display_name = "loc_breed_display_name_renegade_twin_captain_two",
	faction_name = "chaos",
	fx_proximity_culling_weight = 10,
	game_object_type = "minion_renegade_twin_captain",
	has_direct_ragdoll_flow_event = true,
	has_havoc_inventory_override = "havoc_twin_visual_loadout",
	hit_reacts_min_damage = 10,
	ignore_stagger_accumulation = true,
	ignore_weakened_boss_name = true,
	is_boss = true,
	line_of_sight_collision_filter = "filter_minion_line_of_sight_check",
	navigation_propagation_box_extent = 200,
	player_locomotion_constrain_radius = 0.5,
	run_speed = 6.72,
	slot_template = "renegade_melee",
	smart_tag_target_type = "breed",
	spawn_aggro_state = "aggroed",
	spawn_anim_state = "to_melee",
	spawn_inventory_slot = "slot_power_sword",
	stagger_reduction = 500,
	stagger_resistance = 5,
	state_machine = "content/characters/enemy/chaos_traitor_guard/third_person/animations/chaos_traitor_guard_captain",
	sub_faction_name = "renegade",
	trigger_boss_health_bar_on_damaged = true,
	unit_template_name = "minion",
	use_bone_lod = false,
	use_navigation_path_splines = true,
	use_wounds = false,
	volley_fire_target = true,
	walk_speed = 4.8,
	name = breed_name,
	breed_type = breed_types.minion,
	power_level_type = {
		melee = "renegade_twin_captain_two_melee",
	},
	size_variation_range = {
		1.2,
		1.2,
	},
	tags = {
		captain = true,
		minion = true,
	},
	point_cost = math.huge,
	armor_type = armor_types.armored,
	hit_mass = MinionDifficultySettings.hit_mass[breed_name],
	toughness_armor_type = armor_types.void_shield,
	toughness_template = MinionToughnessTemplates.twin_captain_one,
	boss_display_name = BossNameTemplates.renegade_twin_captain_two,
	stagger_durations = {
		[stagger_types.light] = 0.25,
		[stagger_types.medium] = 0.5,
		[stagger_types.heavy] = 2,
		[stagger_types.light_ranged] = 1,
		[stagger_types.shield_broken] = 4,
		[stagger_types.wall_collision] = 1,
		[stagger_types.explosion] = 6.363636363636363,
		[stagger_types.killshot] = 1,
		[stagger_types.sticky] = 1,
	},
	stagger_immune_times = {
		[stagger_types.light] = 6,
		[stagger_types.medium] = 6,
		[stagger_types.heavy] = 6,
		[stagger_types.explosion] = 8,
		[stagger_types.light_ranged] = 6,
		[stagger_types.sticky] = 6,
		[stagger_types.killshot] = 6,
		[stagger_types.shield_block] = 6,
		[stagger_types.shield_heavy_block] = 6,
		[stagger_types.shield_broken] = 6,
		[stagger_types.wall_collision] = 6,
	},
	stagger_thresholds = {
		[stagger_types.light] = -1,
		[stagger_types.medium] = 50,
		[stagger_types.heavy] = 400,
		[stagger_types.light_ranged] = -1,
		[stagger_types.sticky] = 100,
		[stagger_types.explosion] = -1,
		[stagger_types.killshot] = -1,
	},
	inventory = MinionVisualLoadoutTemplates.renegade_twin_captain_two,
	sounds = require("scripts/settings/breed/breeds/renegade/renegade_twin_captain_two_sounds"),
	vfx = require("scripts/settings/breed/breeds/renegade/renegade_common_vfx"),
	behavior_tree_name = breed_name,
	nearby_units_broadphase_config = {
		interval = 0.133,
		radius = 4,
		relation = "enemy",
		angle = math.degrees_to_radians(360),
	},
	combat_range_data = BreedCombatRanges.renegade_twin_captain_two,
	animation_variables = {
		"moving_attack_fwd_speed",
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
	target_selection_template = TargetSelectionTemplates.renegade_twin_captain,
	target_selection_weights = TargetSelectionWeights.twin_captain_two,
	threat_config = {
		max_threat = 100,
		threat_decay_per_second = 5,
		threat_multiplier = 0.2,
		attack_type_multiplier = {
			ranged = 10,
		},
	},
	nav_tag_allowed_layers = {
		monster_walls = 1.5,
	},
	smart_object_template = SmartObjectSettings.templates.renegade,
	fade = {
		max_distance = 0.7,
		max_height_difference = 1,
		min_distance = 0.2,
	},
	hit_zones = {
		{
			name = hit_zone_names.captain_void_shield,
			actors = {
				"c_captain_void_shield",
			},
		},
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
	hitzone_armor_override = {
		[hit_zone_names.head] = armor_types.super_armor,
		[hit_zone_names.upper_left_arm] = armor_types.unarmored,
		[hit_zone_names.upper_right_arm] = armor_types.super_armor,
		[hit_zone_names.upper_left_arm] = armor_types.unarmored,
		[hit_zone_names.lower_left_arm] = armor_types.unarmored,
		[hit_zone_names.upper_left_leg] = armor_types.unarmored,
		[hit_zone_names.upper_right_leg] = armor_types.unarmored,
		[hit_zone_names.lower_left_leg] = armor_types.unarmored,
		[hit_zone_names.lower_right_leg] = armor_types.unarmored,
		[hit_zone_names.center_mass] = armor_types.unarmored,
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
		[hit_zone_names.captain_void_shield] = {
			j_hips = 0.5,
			j_spine = 0.5,
		},
	},
	hitzone_damage_multiplier = {
		ranged = {
			[hit_zone_names.captain_void_shield] = 1,
		},
		melee = {
			[hit_zone_names.head] = 2,
			[hit_zone_names.torso] = 2,
			[hit_zone_names.upper_left_arm] = 2,
			[hit_zone_names.upper_right_arm] = 2,
			[hit_zone_names.upper_left_leg] = 2,
			[hit_zone_names.upper_right_leg] = 2,
			[hit_zone_names.lower_left_arm] = 2,
			[hit_zone_names.lower_right_arm] = 2,
			[hit_zone_names.lower_left_leg] = 2,
			[hit_zone_names.lower_right_leg] = 2,
			[hit_zone_names.center_mass] = 2,
			[hit_zone_names.captain_void_shield] = 2,
		},
	},
	hit_zone_weakspot_types = {
		[hit_zone_names.head] = weakspot_types.headshot,
	},
	outline_config = {},
	blackboard_component_config = BreedBlackboardComponentTemplates.renegade_twin_captain_two,
	companion_pounce_setting = {
		companion_pounce_action = "stagger_and_leap_away",
		on_target_hit = {
			anim_event = "attack_leap_pushed_back_start",
			animation_driven_duration = 0.36666666666666664,
		},
		hurt_effect_template = EffectTemplates.companion_dog_hurt_attack_effect,
		land_anim_events = {
			{
				duration = 1.3333333333333333,
				name = "attack_leap_pushed_back_land",
			},
		},
		damage_profile = DamageProfileTemplates.adamant_companion_human_pounce,
	},
}

return breed_data
