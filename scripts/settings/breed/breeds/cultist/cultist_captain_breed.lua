-- chunkname: @scripts/settings/breed/breeds/cultist/cultist_captain_breed.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BossNameTemplates = require("scripts/settings/boss/boss_name_templates")
local BreedBlackboardComponentTemplates = require("scripts/settings/breed/breed_blackboard_component_templates")
local BreedCombatRanges = require("scripts/settings/breed/breed_combat_ranges")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local BreedTerrorEventSettings = require("scripts/settings/breed/breed_terror_event_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MinionAttackSelectionTemplates = require("scripts/settings/minion_attack_selection/minion_attack_selection_templates")
local MinionDifficultySettings = require("scripts/settings/difficulty/minion_difficulty_settings")
local MinionToughnessTemplates = require("scripts/settings/toughness/minion_toughness_templates")
local MinionVisualLoadoutTemplates = require("scripts/settings/minion_visual_loadout/minion_visual_loadout_templates")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local PhaseTemplates = require("scripts/settings/phases/phase_templates")
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
local breed_name = "cultist_captain"
local breed_data = {
	activate_slot_system_on_spawn = false,
	base_height = 2,
	base_unit = "content/characters/enemy/chaos_traitor_guard_captain/third_person/base",
	bone_lod_radius = 1.3,
	broadphase_radius = 1,
	can_patrol = true,
	challenge_rating = 1,
	display_name = "loc_breed_display_name_cultist_captain",
	faction_name = "chaos",
	fx_proximity_culling_weight = 10,
	game_object_type = "minion_renegade_captain",
	has_direct_ragdoll_flow_event = true,
	hit_reacts_min_damage = 10,
	ignore_stagger_accumulation = true,
	ignore_weakened_boss_name = true,
	is_boss = true,
	line_of_sight_collision_filter = "filter_minion_line_of_sight_check",
	navigation_propagation_box_extent = 200,
	player_locomotion_constrain_radius = 0.7,
	run_speed = 5.9,
	slot_template = "renegade_melee",
	smart_tag_target_type = "breed",
	spawn_aggro_state = "aggroed",
	spawn_anim_state = "to_riflemen",
	stagger_reduction = 500,
	stagger_resistance = 5,
	state_machine = "content/characters/enemy/chaos_traitor_guard/third_person/animations/chaos_traitor_guard_captain",
	sub_faction_name = "cultist",
	target_stickiness_distance = 1,
	trigger_boss_health_bar_on_aggro = true,
	unit_template_name = "minion",
	use_bone_lod = true,
	walk_speed = 2.5,
	name = breed_name,
	breed_type = breed_types.minion,
	power_level_type = {
		melee = "cultist_captain_melee_one_hand",
		melee_two_hand = "cultist_captain_melee_two_hand",
		ranged = "cultist_captain_default_shot",
	},
	tags = {
		cultist_captain = true,
		minion = true,
	},
	point_cost = BreedTerrorEventSettings[breed_name].point_cost,
	armor_type = armor_types.armored,
	toughness_armor_type = armor_types.void_shield,
	hit_mass = MinionDifficultySettings.hit_mass[breed_name],
	toughness_template = MinionToughnessTemplates.cultist_captain,
	boss_display_name = BossNameTemplates.cultist_captain,
	stagger_durations = {
		[stagger_types.light] = 0.5,
		[stagger_types.medium] = 1.5,
		[stagger_types.heavy] = 3,
		[stagger_types.light_ranged] = 1,
		[stagger_types.shield_broken] = 4,
		[stagger_types.wall_collision] = 1,
		[stagger_types.explosion] = 6.363636363636363,
		[stagger_types.killshot] = 1,
		[stagger_types.sticky] = 1,
	},
	stagger_immune_times = {
		[stagger_types.light] = 8,
		[stagger_types.medium] = 8,
		[stagger_types.heavy] = 8,
		[stagger_types.explosion] = 8,
		[stagger_types.light_ranged] = 8,
		[stagger_types.sticky] = 8,
		[stagger_types.killshot] = 8,
		[stagger_types.shield_block] = 8,
		[stagger_types.shield_heavy_block] = 8,
		[stagger_types.shield_broken] = 8,
		[stagger_types.wall_collision] = 8,
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
	inventory = MinionVisualLoadoutTemplates.cultist_captain,
	target_breed_items = {
		netted = {
			human = "content/items/generic/human_netgunner_net",
			ogryn = "content/items/generic/ogryn_netgunner_net",
		},
	},
	sounds = require("scripts/settings/breed/breeds/cultist/cultist_captain_sounds"),
	vfx = require("scripts/settings/breed/breeds/renegade/renegade_common_vfx"),
	behavior_tree_name = breed_name,
	attack_selection_templates = {
		MinionAttackSelectionTemplates.cultist_captain_all,
		MinionAttackSelectionTemplates.cultist_captain_default,
		MinionAttackSelectionTemplates.cultist_captain_melee,
		MinionAttackSelectionTemplates.cultist_captain_ranged,
	},
	animation_variables = {
		"moving_attack_fwd_speed",
		"lean",
		"anim_move_speed",
	},
	shoot_offset_anim_event = {
		pistol_standing = "offset_pistol_standing_shoot_01",
		shotgun_standing = "offset_shotgun_standing_shoot_01",
	},
	combat_range_data = BreedCombatRanges.renegade_captain,
	combat_vector_config = {
		default_combat_range = "close",
		valid_combat_ranges = {
			close = true,
			far = true,
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
		{
			from_node = "j_rightarm_roll",
			id = "netgun",
			to_node = "enemy_aim_target_03",
			offsets = {
				Vector3Box(0, 0, 0),
			},
		},
	},
	target_selection_template = TargetSelectionTemplates.ranged,
	target_selection_weights = TargetSelectionWeights.renegade_captain,
	threat_config = {
		max_threat = 50,
		threat_decay_per_second = 5,
		threat_multiplier = 0.1,
	},
	aim_config = {
		distance = 5,
		lean_variable_modifier = -0.2,
		lean_variable_name = "lean",
		lerp_speed = 5,
		node = "j_neck",
		require_line_of_sight = true,
		target = "head_aim_target",
		target_node = "enemy_aim_target_03",
	},
	nearby_units_broadphase_config = {
		interval = 0.133,
		radius = 4,
		relation = "enemy",
		angle = math.degrees_to_radians(360),
	},
	nav_tag_allowed_layers = {
		cover_ledges = 80,
		jumps = 80,
		ledges = 80,
		ledges_with_fence = 80,
		monster_walls = 1.5,
		teleporters = 1.2,
	},
	smart_object_template = SmartObjectSettings.templates.renegade,
	size_variation_range = {
		1.2,
		1.2,
	},
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
	hit_zone_weakspot_types = {
		[hit_zone_names.head] = weakspot_types.headshot,
	},
	hitzone_damage_multiplier = {
		ranged = {
			[hit_zone_names.head] = 0.75,
			[hit_zone_names.lower_left_arm] = 0.5,
			[hit_zone_names.lower_right_arm] = 0.5,
			[hit_zone_names.lower_left_leg] = 0.5,
			[hit_zone_names.lower_right_leg] = 0.5,
			[hit_zone_names.captain_void_shield] = 0.5,
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
			[hit_zone_names.captain_void_shield] = 3,
		},
	},
	phase_template = PhaseTemplates.renegade_captain_default,
	outline_config = {},
	blackboard_component_config = BreedBlackboardComponentTemplates.renegade_captain,
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
