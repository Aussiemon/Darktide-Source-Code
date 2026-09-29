-- chunkname: @scripts/settings/breed/breeds/renegade/renegade_wizard_breed.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BreedBlackboardComponentTemplates = require("scripts/settings/breed/breed_blackboard_component_templates")
local BossNameTemplates = require("scripts/settings/boss/boss_name_templates")
local BreedCombatRanges = require("scripts/settings/breed/breed_combat_ranges")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local BreedTerrorEventSettings = require("scripts/settings/breed/breed_terror_event_settings")
local BreedSummonTemplates = require("scripts/settings/breed/breed_summon_templates")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
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
local damage_types = DamageSettings.damage_types
local hit_effect_types = ArmorSettings.hit_effect_types
local breed_tags = BreedSettings.tags
local breed_types = BreedSettings.types
local hit_zone_names = HitZone.hit_zone_names
local stagger_types = StaggerSettings.stagger_types
local weakspot_types = WeakspotSettings.types
local breed_name = "renegade_wizard"
local breed_data = {
	base_height = 2,
	base_unit = "content/characters/enemy/chaos_traitor_guard_captain/third_person/base",
	body_size = "captain_sized",
	bone_lod_radius = 1.3,
	boss_health_bar_disabled = true,
	broadphase_radius = 1,
	can_be_used_for_all_factions = true,
	can_have_invulnerable_toughness = true,
	challenge_rating = 2,
	clamp_health_percent_damage = 0.025,
	count_num_attacks = true,
	faction_name = "chaos",
	fx_proximity_culling_weight = 6,
	game_object_type = "minion_wizard_boss",
	has_direct_ragdoll_flow_event = true,
	heat = 0.2,
	is_boss = true,
	line_of_sight_collision_filter = "filter_minion_line_of_sight_check",
	navigation_propagation_box_extent = 200,
	player_locomotion_constrain_radius = 0.5,
	run_speed = 4.8,
	skip_kill_feed_announcement = true,
	smart_tag_target_type = "breed",
	spawn_aggro_state = "aggroed",
	spawn_anim_state = "to_combat",
	stagger_reduction = 99999,
	stagger_reduction_ranged = 99999,
	stagger_resistance = 1,
	state_machine = "content/characters/enemy/chaos_traitor_guard/third_person/animations/chaos_traitor_guard_wizard",
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
	display_name = BossNameTemplates.spillway_wizard,
	tags = {
		[breed_tags.lord] = true,
		[breed_tags.monster] = true,
		[breed_tags.minion] = true,
	},
	point_cost = BreedTerrorEventSettings[breed_name].point_cost,
	boss_display_name = BossNameTemplates.spillway_wizard,
	armor_type = armor_types.armored,
	hit_mass = MinionDifficultySettings.hit_mass[breed_name],
	toughness_armor_type = armor_types.void_shield,
	toughness_template = MinionToughnessTemplates.spillway_wizard,
	spawn_buffs = {
		"havoc_no_stagger",
	},
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
		[stagger_types.light] = -1,
		[stagger_types.medium] = -1,
		[stagger_types.heavy] = -1,
		[stagger_types.light_ranged] = -1,
		[stagger_types.sticky] = -1,
	},
	inventory = MinionVisualLoadoutTemplates.renegade_wizard,
	sounds = require("scripts/settings/breed/breeds/renegade/renegade_captain_sounds"),
	vfx = require("scripts/settings/breed/breeds/renegade/renegade_common_vfx"),
	behavior_tree_name = breed_name,
	summon_minions_template = BreedSummonTemplates.renegade_radio_operator,
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
	target_selection_template = TargetSelectionTemplates.ranged,
	target_selection_weights = TargetSelectionWeights.renegade_twin_captain,
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
	size_variation_range = {
		1.5,
		1.65,
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
		{
			name = hit_zone_names.captain_void_shield,
			actors = {
				"c_captain_void_shield",
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
		[hit_zone_names.captain_void_shield] = {
			j_hips = 0.5,
			j_spine = 0.5,
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
	wounds_config = {
		always_show_killing_blow = false,
		apply_threshold_filtering = true,
		health_percent_throttle = 1,
		radius_multiplier = 0,
		thresholds = {
			[damage_types.blunt] = 1,
			[damage_types.blunt_heavy] = 1,
			[damage_types.blunt_thunder] = 1,
			[damage_types.plasma] = 1,
			[damage_types.rippergun_pellet] = 1,
			[damage_types.auto_bullet] = 1,
			[damage_types.pellet] = 1,
			[damage_types.boltshell] = 1,
			[damage_types.laser] = 1,
			[damage_types.power_sword] = 1,
			[damage_types.sawing_stuck] = 1,
			[damage_types.slashing_force_stuck] = 1,
			[damage_types.combat_blade] = 1,
		},
	},
	hit_zone_weakspot_types = {
		[hit_zone_names.head] = weakspot_types.headshot,
	},
	hitzone_armor_override = {
		[hit_zone_names.head] = armor_types.disgustingly_resilient,
		[hit_zone_names.lower_left_arm] = armor_types.disgustingly_resilient,
		[hit_zone_names.lower_right_arm] = armor_types.disgustingly_resilient,
	},
	hitzone_hit_effect_armor_override = {
		[hit_zone_names.captain_void_shield] = hit_effect_types.warp_shield,
	},
	hitzone_damage_multiplier = {
		ranged = {
			[hit_zone_names.head] = 0.5,
			[hit_zone_names.torso] = 0.5,
			[hit_zone_names.upper_left_arm] = 0.5,
			[hit_zone_names.upper_right_arm] = 0.5,
			[hit_zone_names.upper_left_leg] = 0.5,
			[hit_zone_names.upper_right_leg] = 0.5,
			[hit_zone_names.lower_left_arm] = 0.5,
			[hit_zone_names.lower_right_arm] = 0.5,
			[hit_zone_names.lower_left_leg] = 0.5,
			[hit_zone_names.lower_right_leg] = 0.5,
			[hit_zone_names.center_mass] = 0.5,
		},
		melee = {
			[hit_zone_names.head] = 0.8,
			[hit_zone_names.torso] = 0.8,
			[hit_zone_names.upper_left_arm] = 0.8,
			[hit_zone_names.upper_right_arm] = 0.8,
			[hit_zone_names.upper_left_leg] = 0.8,
			[hit_zone_names.upper_right_leg] = 0.8,
			[hit_zone_names.lower_left_arm] = 0.8,
			[hit_zone_names.lower_right_arm] = 0.8,
			[hit_zone_names.lower_left_leg] = 0.8,
			[hit_zone_names.lower_right_leg] = 0.8,
			[hit_zone_names.center_mass] = 0.8,
		},
	},
	dot_damage_multiplier = {
		[damage_types.bleeding] = 0.3,
		[damage_types.burning] = 0.3,
		[damage_types.toxin] = 0.3,
		[damage_types.warpfire] = 0.25,
		[damage_types.corruption] = 0,
	},
	outline_config = {},
	blackboard_component_config = BreedBlackboardComponentTemplates.summoner_boss,
	companion_pounce_setting = {
		companion_pounce_action = "pushed_away",
		ignore_target_selection = true,
		on_target_hit = {
			anim_event = "attack_leap_pushed_back_start",
			animation_driven_duration = 0.36666666666666664,
		},
		land_anim_events = {
			{
				duration = 1.3333333333333333,
				name = "attack_leap_pushed_back_land",
			},
		},
		force_stagger_settings = {
			duration = 0.1,
			immune_time = 10,
			length_scale = 0,
			stagger_type = "companion_push",
		},
	},
}

return breed_data
