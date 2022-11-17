local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BreedBlackboardComponentTemplates = require("scripts/settings/breed/breed_blackboard_component_templates")
local BreedCombatRanges = require("scripts/settings/breed/breed_combat_ranges")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local BreedTerrorEventSettings = require("scripts/settings/breed/breed_terror_event_settings")
local CoverSettings = require("scripts/settings/cover/cover_settings")
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
local hit_zone_names = HitZone.hit_zone_names
local stagger_types = StaggerSettings.stagger_types
local weakspot_types = WeakspotSettings.types
local breed_name = "renegade_rifleman"
local breed_data = {
	detection_radius = 15,
	walk_speed = 2.3,
	use_bone_lod = true,
	sub_faction_name = "renegade",
	target_stickiness_distance = 10,
	unit_template_name = "minion",
	volley_fire_target = true,
	aggro_inventory_slot = "slot_ranged_weapon",
	slot_template = "chaos_poxwalker",
	broadphase_radius = 1,
	spawn_inventory_slot = "slot_ranged_weapon",
	stagger_resistance = 1,
	use_avoidance = true,
	game_object_type = "minion_ranged",
	challenge_rating = 1,
	bone_lod_radius = 1.2,
	use_wounds = true,
	display_name = "loc_breed_display_name_renegade_rifleman",
	run_speed = 4.8,
	spawn_anim_state = "to_riflemen",
	faction_name = "chaos",
	base_height = 2,
	line_of_sight_collision_filter = "filter_minion_line_of_sight_check",
	player_locomotion_constrain_radius = 0.4,
	can_patrol = true,
	explosion_power_multiplier = 0.75,
	base_unit = "content/characters/enemy/chaos_traitor_guard/third_person/base",
	hit_mass = 1.5,
	has_direct_ragdoll_flow_event = true,
	name = breed_name,
	breed_type = breed_types.minion,
	power_level_type = {
		melee = "renegade_default_melee",
		ranged = "renegade_default_shot"
	},
	tags = {
		far = true,
		minion = true,
		roamer = true
	},
	point_cost = BreedTerrorEventSettings[breed_name].point_cost,
	armor_type = armor_types.armored,
	gib_template = MinionGibbingTemplates.renegade_rifleman_gibbing,
	stagger_durations = {
		[stagger_types.light] = 0.75,
		[stagger_types.medium] = 1.25,
		[stagger_types.heavy] = 2.8,
		[stagger_types.light_ranged] = 0.5,
		[stagger_types.explosion] = 6.363636363636363,
		[stagger_types.killshot] = 1.85,
		[stagger_types.sticky] = 1
	},
	stagger_immune_times = {
		[stagger_types.light] = 0.2,
		[stagger_types.medium] = 0.5,
		[stagger_types.heavy] = 1.75,
		[stagger_types.light_ranged] = 0.5,
		[stagger_types.killshot] = 0.75
	},
	stagger_thresholds = {
		[stagger_types.light] = 4,
		[stagger_types.medium] = 8,
		[stagger_types.heavy] = 16,
		[stagger_types.light_ranged] = 5,
		[stagger_types.killshot] = 2,
		[stagger_types.sticky] = 1
	},
	inventory = MinionVisualLoadoutTemplates.renegade_rifleman,
	sounds = require("scripts/settings/breed/breeds/renegade/renegade_rifleman_sounds"),
	vfx = require("scripts/settings/breed/breeds/renegade/renegade_common_vfx"),
	behavior_tree_name = breed_name,
	animation_variables = {
		"anim_move_speed",
		"lean"
	},
	shoot_offset_anim_event = {
		standing = "offset_rifle_standing_shoot_01",
		crouching = "offset_rifle_crouch_shoot_01"
	},
	combat_range_data = BreedCombatRanges.renegade_rifleman,
	cover_config = {
		max_distance_modifier_duration = 50,
		max_distance_modifier_percentage = 0.7,
		suppressed_max_distance_from_combat_vector = 60,
		max_distance_from_target = 45,
		max_distance_from_target_z_below = -10,
		search_radius = 35,
		max_distance_from_combat_vector = 30,
		suppressed_max_distance_from_target = 60,
		max_distance_from_target_z = 10,
		suppressed_search_radius = 50,
		cover_combat_ranges = {
			far = true
		},
		search_source = CoverSettings.user_search_sources.from_self,
		suppressed_search_sticky_time = {
			8,
			10
		}
	},
	combat_vector_config = {
		choose_furthest_away = true,
		can_flank = true,
		default_combat_range = "far",
		valid_combat_ranges = {
			far = true,
			close = true
		}
	},
	suppress_config = {
		max_value = 25,
		above_threshold_decay_multiplier = 2,
		threshold = 10,
		disable_cover_threshold = 25,
		decay_speeds = {
			melee = 0.05,
			far = 0.5,
			close = 0.2
		},
		immunity_duration = {
			0.25,
			0.5
		}
	},
	attack_intensity_cooldowns = {
		melee = {
			0.3,
			0.6
		},
		ranged = {
			0.01,
			0.01
		},
		moving_melee = {
			0.7,
			0.8
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
	target_selection_weights = TargetSelectionWeights.renegade_rifleman,
	threat_config = {
		threat_multiplier = 0.1,
		max_threat = 50,
		threat_decay_per_second = 5
	},
	aim_config = {
		lean_variable_name = "lean",
		target = "head_aim_target",
		distance = 5,
		target_node = "enemy_aim_target_03",
		lerp_speed = 5,
		lean_variable_modifier = -0.2,
		node = "j_neck",
		require_line_of_sight = true,
		valid_aim_combat_ranges = {
			far = true,
			close = true
		}
	},
	smart_object_template = SmartObjectSettings.templates.renegade,
	size_variation_range = {
		0.935,
		0.945
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
			j_rightshoulder = 0.05,
			j_leftshoulder = 0.05,
			j_spine = 0.2,
			j_spine1 = 0.1,
			j_head = 0.5,
			j_neck = 0.25
		},
		[hit_zone_names.torso] = {
			j_rightshoulder = 0,
			j_leftshoulder = 0,
			j_spine = 0.2,
			j_spine1 = 0.7,
			j_head = 0.1,
			j_neck = 0.1
		},
		[hit_zone_names.upper_left_arm] = {
			j_leftuparm = 0.8,
			j_leftshoulder = 0.4,
			j_spine = 0.15,
			j_spine1 = 0.1,
			j_head = 0.05,
			j_neck = 0.05
		},
		[hit_zone_names.lower_left_arm] = {
			j_leftuparm = 0.8,
			j_leftshoulder = 0.4,
			j_spine = 0.15,
			j_spine1 = 0.1,
			j_head = 0.05,
			j_neck = 0.05
		},
		[hit_zone_names.upper_right_arm] = {
			j_rightshoulder = 0.4,
			j_spine1 = 0.1,
			j_spine = 0.15,
			j_rightuparm = 0.8,
			j_head = 0.05,
			j_neck = 0.05
		},
		[hit_zone_names.lower_right_arm] = {
			j_rightshoulder = 0.4,
			j_spine1 = 0.1,
			j_spine = 0.15,
			j_rightuparm = 0.8,
			j_head = 0.05,
			j_neck = 0.05
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
	hit_zone_weakspot_types = {
		[hit_zone_names.head] = weakspot_types.headshot
	},
	hitzone_armor_override = {
		[hit_zone_names.upper_right_leg] = armor_types.unarmored,
		[hit_zone_names.upper_left_leg] = armor_types.unarmored,
		[hit_zone_names.upper_right_arm] = armor_types.unarmored,
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
