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
local breed_name = "chaos_ogryn_gunner"
local breed_data = {
	detection_radius = 13,
	use_navigation_path_splines = true,
	walk_speed = 1.9,
	use_bone_lod = true,
	sub_faction_name = "chaos",
	state_machine = "content/characters/enemy/chaos_ogryn/third_person/animations/chaos_ogryn_gunner",
	unit_template_name = "minion",
	spawn_inventory_slot = "slot_ranged_weapon",
	slot_template = "chaos_ogryn",
	broadphase_radius = 1,
	stagger_resistance = 1,
	half_extent_right = 0.5,
	smite_stagger_immunity = true,
	half_extent_forward = 0.5,
	accumulative_stagger_multiplier = 0.25,
	use_avoidance = true,
	game_object_type = "minion_elite_ranged",
	challenge_rating = 8,
	bone_lod_radius = 1.7,
	use_wounds = true,
	explosion_radius = 0.25,
	display_name = "loc_breed_display_name_chaos_ogryn_gunner",
	run_speed = 6.2,
	health_type_override = "health_medium",
	spawn_anim_state = "to_gunner",
	faction_name = "chaos",
	base_height = 2.5,
	ranged = true,
	line_of_sight_collision_filter = "filter_minion_line_of_sight_check",
	stagger_reduction = 3,
	player_locomotion_constrain_radius = 0.9,
	stagger_reduction_ranged = 35,
	can_patrol = true,
	smart_tag_target_type = "breed",
	explosion_power_multiplier = 2,
	base_unit = "content/characters/enemy/chaos_ogryn/third_person/base",
	has_direct_ragdoll_flow_event = true,
	name = breed_name,
	breed_type = breed_types.minion,
	power_level_type = {
		melee = "chaos_ogryn_default_melee",
		ranged = "chaos_ogryn_default_ranged"
	},
	tags = {
		far = true,
		minion = true,
		elite = true,
		ogryn = true
	},
	point_cost = BreedTerrorEventSettings[breed_name].point_cost,
	armor_type = armor_types.resistant,
	hit_mass = MinionDifficultySettings.hit_mass[breed_name],
	gib_template = MinionGibbingTemplates.chaos_ogryn_gunner,
	stagger_durations = {
		[stagger_types.light] = 0.5,
		[stagger_types.medium] = 1,
		[stagger_types.heavy] = 3.5,
		[stagger_types.explosion] = 3,
		[stagger_types.light_ranged] = 0.75,
		[stagger_types.killshot] = 0.75,
		[stagger_types.sticky] = 0.6
	},
	stagger_immune_times = {
		[stagger_types.light] = 1.5,
		[stagger_types.medium] = 3,
		[stagger_types.heavy] = 4,
		[stagger_types.explosion] = 3,
		[stagger_types.light_ranged] = 1,
		[stagger_types.killshot] = 2,
		[stagger_types.sticky] = 0.25
	},
	stagger_thresholds = {
		[stagger_types.light] = 3,
		[stagger_types.medium] = 15,
		[stagger_types.heavy] = 40,
		[stagger_types.light_ranged] = 10,
		[stagger_types.sticky] = 5,
		[stagger_types.killshot] = 3
	},
	inventory = MinionVisualLoadoutTemplates.chaos_ogryn_gunner,
	sounds = require("scripts/settings/breed/breeds/chaos/chaos_ogryn_gunner_sounds"),
	vfx = require("scripts/settings/breed/breeds/chaos/chaos_common_vfx"),
	behavior_tree_name = breed_name,
	animation_variables = {
		"anim_move_speed",
		"lean"
	},
	combat_range_data = BreedCombatRanges.chaos_ogryn_gunner,
	combat_vector_config = {
		choose_closest_to_target = true,
		default_combat_range = "far",
		valid_combat_ranges = {
			far = true,
			close = true
		}
	},
	suppress_config = MinionDifficultySettings.suppression.chaos_ogryn_gunner,
	attack_intensity_cooldowns = {
		melee = {
			0.7,
			0.8
		},
		ranged = {
			0,
			0
		},
		moving_melee = {
			0.7,
			0.8
		},
		elite_ranged = {
			0.1,
			0.3
		}
	},
	line_of_sight_data = {
		{
			id = "eyes",
			to_node = "enemy_aim_target_03",
			from_node = "j_head",
			offsets = PerceptionSettings.default_minion_line_of_sight_offsets
		},
		{
			id = "gun",
			to_node = "enemy_aim_target_03",
			from_node = "j_righthand",
			offsets = {
				Vector3Box(0, 0, 0)
			}
		}
	},
	target_selection_template = TargetSelectionTemplates.ranged,
	target_selection_weights = TargetSelectionWeights.chaos_ogryn_gunner,
	threat_config = {
		threat_multiplier = 0.1,
		max_threat = 50,
		threat_decay_per_second = 5
	},
	aim_config = {
		lerp_speed = 2,
		target = "head_aim_target",
		distance = 50,
		lean_variable_name = "lean",
		lean_variable_modifier = -0.2,
		node = "j_neck",
		target_node = "enemy_aim_target_03",
		require_line_of_sight = true
	},
	smart_object_template = SmartObjectSettings.templates.chaos_ogryn,
	size_variation_range = {
		0.94,
		0.96
	},
	fade = {
		max_distance = 0.7,
		max_height_difference = 1.2,
		min_distance = 0.3
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
				"c_spine1",
				"c_spine2"
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
		},
		{
			create_on_startup = true,
			destroy_on_death = true,
			name = hit_zone_names.right_shoulderguard,
			actors = {
				"c_rightshoulderguard"
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
		[hit_zone_names.right_shoulderguard] = {
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
			j_rightshoulder = 0.25,
			j_leftshoulder = 0.25,
			j_spine = 0.4,
			j_spine1 = 0.4,
			j_head = 0.3,
			j_neck = 0.1
		},
		[hit_zone_names.torso] = {
			j_rightshoulder = 0.2,
			j_leftshoulder = 0.2,
			j_spine = 0.4,
			j_spine1 = 0.6,
			j_head = 0.1,
			j_neck = 0.1
		},
		[hit_zone_names.upper_left_arm] = {
			j_spine1 = 0.4,
			j_leftshoulder = 1,
			j_spine = 0.4,
			j_head = 0.1,
			j_neck = 0.1
		},
		[hit_zone_names.lower_left_arm] = {
			j_spine1 = 0.4,
			j_leftshoulder = 1,
			j_spine = 0.4,
			j_head = 0.1,
			j_neck = 0.1
		},
		[hit_zone_names.upper_right_arm] = {
			j_rightshoulder = 1,
			j_spine1 = 0.4,
			j_spine = 0.4,
			j_head = 0.1,
			j_neck = 0.1
		},
		[hit_zone_names.right_shoulderguard] = {
			j_rightshoulder = 1,
			j_spine1 = 0.4,
			j_spine = 0.4,
			j_head = 0.1,
			j_neck = 0.1
		},
		[hit_zone_names.lower_right_arm] = {
			j_rightshoulder = 1,
			j_spine1 = 0.4,
			j_spine = 0.4,
			j_head = 0.1,
			j_neck = 0.1
		},
		[hit_zone_names.upper_left_leg] = {
			j_leftleg = 0.6,
			j_leftupleg = 0.5,
			j_spine = 0.3,
			j_leftfoot = 0.4,
			j_hips = 0.25,
			j_spine1 = 0.3
		},
		[hit_zone_names.lower_left_leg] = {
			j_leftleg = 0.6,
			j_leftupleg = 0.5,
			j_spine = 0.3,
			j_leftfoot = 0.4,
			j_hips = 0.25,
			j_spine1 = 0.3
		},
		[hit_zone_names.upper_right_leg] = {
			j_rightfoot = 0.4,
			j_rightupleg = 0.5,
			j_spine = 0.3,
			j_hips = 0.25,
			j_rightleg = 0.6,
			j_spine1 = 0.3
		},
		[hit_zone_names.lower_right_leg] = {
			j_rightfoot = 0.4,
			j_rightupleg = 0.5,
			j_spine = 0.3,
			j_hips = 0.25,
			j_rightleg = 0.6,
			j_spine1 = 0.3
		},
		[hit_zone_names.center_mass] = {
			j_hips = 0.5,
			j_spine = 0.5
		}
	},
	wounds_config = {
		always_show_killing_blow = true,
		apply_threshold_filtering = false,
		health_percent_throttle = 0.2,
		radius_multiplier = 1.3
	},
	hit_zone_weakspot_types = {
		[hit_zone_names.head] = weakspot_types.headshot
	},
	hitzone_armor_override = {
		[hit_zone_names.right_shoulderguard] = armor_types.super_armor,
		[hit_zone_names.torso] = armor_types.armored,
		[hit_zone_names.lower_left_arm] = armor_types.super_armor,
		[hit_zone_names.lower_right_arm] = armor_types.super_armor
	},
	blackboard_component_config = BreedBlackboardComponentTemplates.ranged_patroller
}

return breed_data
