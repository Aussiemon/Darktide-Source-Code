local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BreedBlackboardComponentTemplates = require("scripts/settings/breed/breed_blackboard_component_templates")
local BreedCombatRanges = require("scripts/settings/breed/breed_combat_ranges")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local BreedTerrorEventSettings = require("scripts/settings/breed/breed_terror_event_settings")
local CoverSettings = require("scripts/settings/cover/cover_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
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
local breed_name = "cultist_gunner"
local breed_data = {
	detection_radius = 15,
	walk_speed = 2.3,
	use_bone_lod = true,
	sub_faction_name = "cultist",
	unit_template_name = "minion",
	spawn_anim_state = "to_ranged",
	spawn_inventory_slot = "slot_ranged_weapon",
	volley_fire_target = true,
	slot_template = "renegade_melee",
	broadphase_radius = 1,
	stagger_resistance = 2,
	state_machine = "content/characters/enemy/chaos_traitor_guard/third_person/animations/chaos_traitor_guard_elite_gunner",
	game_object_type = "minion_elite_ranged",
	challenge_rating = 4,
	bone_lod_radius = 1.2,
	use_wounds = true,
	display_name = "loc_breed_display_name_cultist_gunner",
	run_speed = 5.5,
	faction_name = "chaos",
	base_height = 2,
	ignore_attack_delay = true,
	line_of_sight_collision_filter = "filter_minion_line_of_sight_check",
	stagger_reduction = 0,
	player_locomotion_constrain_radius = 0.5,
	stagger_reduction_ranged = 10,
	can_patrol = true,
	smart_tag_target_type = "breed",
	base_unit = "content/characters/enemy/chaos_traitor_guard/third_person/base",
	hit_mass = 4,
	reduced_hit_mass = 1,
	has_direct_ragdoll_flow_event = true,
	name = breed_name,
	breed_type = breed_types.minion,
	power_level_type = {
		melee = "renegade_default_melee",
		ranged = "renegade_gunner_shot"
	},
	tags = {
		far = true,
		minion = true,
		elite = true
	},
	point_cost = BreedTerrorEventSettings[breed_name].point_cost,
	armor_type = armor_types.armored,
	gib_template = MinionGibbingTemplates.cultist_gunner_gibbing,
	stagger_durations = {
		[stagger_types.light] = 0.75,
		[stagger_types.medium] = 1.25,
		[stagger_types.heavy] = 2.8,
		[stagger_types.light_ranged] = 0.5,
		[stagger_types.explosion] = 6.363636363636363,
		[stagger_types.killshot] = 1,
		[stagger_types.sticky] = 0.6
	},
	stagger_immune_times = {
		[stagger_types.light] = 0.3,
		[stagger_types.medium] = 0.5,
		[stagger_types.heavy] = 0.75,
		[stagger_types.explosion] = 3,
		[stagger_types.light_ranged] = 0.2,
		[stagger_types.killshot] = 1,
		[stagger_types.sticky] = 0.25
	},
	stagger_thresholds = {
		[stagger_types.light] = 1,
		[stagger_types.medium] = 10,
		[stagger_types.heavy] = 20,
		[stagger_types.explosion] = 50,
		[stagger_types.killshot] = 1,
		[stagger_types.light_ranged] = 10,
		[stagger_types.sticky] = 2
	},
	inventory = MinionVisualLoadoutTemplates.cultist_gunner,
	sounds = require("scripts/settings/breed/breeds/cultist/cultist_gunner_sounds"),
	vfx = require("scripts/settings/breed/breeds/cultist/cultist_common_vfx"),
	behavior_tree_name = breed_name,
	animation_variables = {
		"anim_move_speed",
		"lean"
	},
	combat_range_data = BreedCombatRanges.renegade_gunner,
	cover_config = {
		max_distance_modifier_duration = 40,
		max_distance_modifier_percentage = 0.8,
		suppressed_max_distance_from_combat_vector = 60,
		max_distance_from_target = 35,
		max_distance_from_target_z_below = -10,
		search_radius = 40,
		max_distance_from_combat_vector = 35,
		suppressed_max_distance_from_target = 100,
		max_distance_from_target_z = 10,
		suppressed_search_radius = 50,
		cover_combat_ranges = {
			far = true,
			close = false
		},
		search_source = CoverSettings.user_search_sources.from_self,
		suppressed_search_sticky_time = {
			5,
			8
		}
	},
	combat_vector_config = {
		can_flank = true,
		default_combat_range = "far",
		valid_combat_ranges = {
			far = true,
			close = false
		}
	},
	suppress_config = {
		disable_cover_threshold = 35,
		above_threshold_decay_multiplier = 2,
		threshold = 27.5,
		max_value = 40,
		decay_speeds = {
			melee = 0.05,
			far = 0.5,
			close = 0.3
		},
		immunity_duration = {
			2.75,
			3.25
		}
	},
	attack_intensity_cooldowns = {
		melee = {
			0.7,
			0.8
		},
		ranged = {
			0.2,
			0.5
		},
		moving_melee = {
			0.7,
			0.8
		},
		elite_ranged = {
			0.2,
			0.5
		}
	},
	line_of_sight_data = {
		{
			to_node = "enemy_aim_target_03",
			from_node = "j_head",
			id = "eyes",
			from_offsets = Vector3Box(0, 0, 0.1),
			offsets = PerceptionSettings.default_minion_line_of_sight_offsets
		},
		{
			id = "gun",
			to_node = "enemy_aim_target_03",
			from_node = "j_rightarm",
			offsets = {
				Vector3Box(0, 0, 0)
			}
		}
	},
	target_selection_template = TargetSelectionTemplates.ranged,
	target_selection_weights = TargetSelectionWeights.cultist_gunner,
	threat_config = {
		threat_multiplier = 0.1,
		max_threat = 50,
		threat_decay_per_second = 5
	},
	aim_config = {
		lerp_speed = 5,
		target = "head_aim_target",
		distance = 5,
		lean_variable_name = "lean",
		lean_variable_modifier = -0.2,
		node = "j_neck",
		target_node = "enemy_aim_target_03",
		require_line_of_sight = true
	},
	smart_object_template = SmartObjectSettings.templates.renegade,
	size_variation_range = {
		1.025,
		1.05
	},
	fade = {
		max_distance = 0.7,
		max_height_difference = 1,
		min_distance = 0.2
	},
	hit_zones = {
		{
			name = hit_zone_names.head,
			actors = {
				"c_head",
				"c_neck"
			}
		},
		{
			name = hit_zone_names.torso,
			actors = {
				"c_hips",
				"c_spine",
				"c_spine1"
			}
		},
		{
			name = hit_zone_names.upper_left_arm,
			actors = {
				"c_leftarm",
				"c_leftshoulder"
			}
		},
		{
			name = hit_zone_names.lower_left_arm,
			actors = {
				"c_leftforearm",
				"c_lefthand"
			}
		},
		{
			name = hit_zone_names.upper_right_arm,
			actors = {
				"c_rightarm",
				"c_rightshoulder"
			}
		},
		{
			name = hit_zone_names.lower_right_arm,
			actors = {
				"c_rightforearm",
				"c_righthand"
			}
		},
		{
			name = hit_zone_names.upper_left_leg,
			actors = {
				"c_leftupleg"
			}
		},
		{
			name = hit_zone_names.lower_left_leg,
			actors = {
				"c_leftleg",
				"c_leftfoot"
			}
		},
		{
			name = hit_zone_names.upper_right_leg,
			actors = {
				"c_rightupleg"
			}
		},
		{
			name = hit_zone_names.lower_right_leg,
			actors = {
				"c_rightleg",
				"c_rightfoot"
			}
		},
		{
			name = hit_zone_names.afro,
			actors = {
				"r_afro"
			}
		},
		{
			name = hit_zone_names.center_mass,
			actors = {
				"c_hips",
				"c_spine"
			}
		}
	},
	hit_zone_ragdoll_actors = {
		[hit_zone_names.head] = {
			"j_head",
			"j_neck"
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
			"j_righthand"
		},
		[hit_zone_names.upper_left_arm] = {
			"j_leftarm",
			"j_leftshoulder",
			"j_leftforearm",
			"j_lefthand"
		},
		[hit_zone_names.lower_left_arm] = {
			"j_leftforearm",
			"j_lefthand"
		},
		[hit_zone_names.upper_right_arm] = {
			"j_rightarm",
			"j_rightshoulder",
			"j_rightforearm",
			"j_righthand"
		},
		[hit_zone_names.lower_right_arm] = {
			"j_rightforearm",
			"j_righthand"
		},
		[hit_zone_names.upper_left_leg] = {
			"j_leftupleg",
			"j_leftleg",
			"j_leftfoot"
		},
		[hit_zone_names.lower_left_leg] = {
			"j_leftleg",
			"j_leftfoot"
		},
		[hit_zone_names.upper_right_leg] = {
			"j_rightupleg",
			"j_rightleg",
			"j_rightfoot"
		},
		[hit_zone_names.lower_right_leg] = {
			"j_rightleg",
			"j_rightfoot"
		}
	},
	hit_zone_ragdoll_pushes = {
		[hit_zone_names.head] = {
			j_rightshoulder = 0.15,
			j_leftshoulder = 0.15,
			j_spine = 0.3,
			j_spine1 = 0.1,
			j_head = 0.5,
			j_neck = 0.5
		},
		[hit_zone_names.torso] = {
			j_rightshoulder = 0,
			j_leftshoulder = 0,
			j_spine = 0.2,
			j_spine1 = 0.7,
			j_head = 0,
			j_neck = 0
		},
		[hit_zone_names.upper_left_arm] = {
			j_leftuparm = 0.8,
			j_leftshoulder = 0.4,
			j_spine = 0,
			j_spine1 = 0.1,
			j_head = 0,
			j_neck = 0
		},
		[hit_zone_names.lower_left_arm] = {
			j_leftuparm = 0.8,
			j_leftshoulder = 0.4,
			j_spine = 0,
			j_spine1 = 0.1,
			j_head = 0,
			j_neck = 0
		},
		[hit_zone_names.upper_right_arm] = {
			j_rightshoulder = 0.4,
			j_spine1 = 0.1,
			j_spine = 0,
			j_rightuparm = 0.8,
			j_head = 0,
			j_neck = 0
		},
		[hit_zone_names.lower_right_arm] = {
			j_rightshoulder = 0.4,
			j_spine1 = 0.1,
			j_spine = 0,
			j_rightuparm = 0.8,
			j_head = 0,
			j_neck = 0
		},
		[hit_zone_names.upper_left_leg] = {
			j_leftleg = 0.35,
			j_leftupleg = 0.35,
			j_spine = 0,
			j_leftfoot = 0.1,
			j_hips = 0.2,
			j_spine1 = 0.1
		},
		[hit_zone_names.lower_left_leg] = {
			j_leftleg = 0.35,
			j_leftupleg = 0.35,
			j_spine = 0,
			j_leftfoot = 0.1,
			j_hips = 0.2,
			j_spine1 = 0.1
		},
		[hit_zone_names.upper_right_leg] = {
			j_rightfoot = 0.3,
			j_rightupleg = 0.4,
			j_spine = 0,
			j_hips = 0.1,
			j_rightleg = 0.25,
			j_spine1 = 0
		},
		[hit_zone_names.lower_right_leg] = {
			j_rightfoot = 0.3,
			j_rightupleg = 0.4,
			j_spine = 0,
			j_hips = 0.1,
			j_rightleg = 0.25,
			j_spine1 = 0
		},
		[hit_zone_names.center_mass] = {
			j_hips = 0.5,
			j_spine = 0.5
		}
	},
	wounds_config = {
		apply_threshold_filtering = true,
		always_show_killing_blow = true,
		thresholds = {
			[damage_types.blunt] = 0.45,
			[damage_types.blunt_heavy] = 0.35,
			[damage_types.blunt_thunder] = 0.35,
			[damage_types.plasma] = 0.25,
			[damage_types.rippergun_pellet] = 0.25,
			[damage_types.auto_bullet] = 0.35,
			[damage_types.pellet] = 0.25,
			[damage_types.laser] = 0.65,
			[damage_types.boltshell] = 0.35,
			[damage_types.power_sword] = 0.4,
			[damage_types.sawing_stuck] = 0.1,
			[damage_types.sawing] = 0.05,
			[damage_types.slashing_force_stuck] = 0.4,
			[damage_types.combat_blade] = 0.4
		}
	},
	hit_zone_weakspot_types = {
		[hit_zone_names.head] = weakspot_types.headshot
	},
	hitzone_armor_override = {
		[hit_zone_names.head] = armor_types.unarmored,
		[hit_zone_names.upper_right_leg] = armor_types.unarmored,
		[hit_zone_names.lower_right_leg] = armor_types.unarmored,
		[hit_zone_names.upper_left_leg] = armor_types.unarmored,
		[hit_zone_names.upper_right_arm] = armor_types.unarmored,
		[hit_zone_names.lower_right_arm] = armor_types.unarmored,
		[hit_zone_names.lower_left_arm] = armor_types.unarmored,
		[hit_zone_names.upper_left_arm] = armor_types.unarmored
	},
	hitzone_damage_multiplier = {
		ranged = {
			[hit_zone_names.lower_left_arm] = 0.5,
			[hit_zone_names.lower_right_arm] = 0.5,
			[hit_zone_names.lower_left_leg] = 0.5,
			[hit_zone_names.lower_right_leg] = 0.5
		}
	},
	blackboard_component_config = BreedBlackboardComponentTemplates.riflemen
}

return breed_data
