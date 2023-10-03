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
local breed_name = "renegade_shocktrooper"
local breed_data = {
	detection_radius = 15,
	walk_speed = 2.3,
	use_bone_lod = true,
	state_machine = "content/characters/enemy/chaos_traitor_guard/third_person/animations/chaos_traitor_guard_elite_shocktrooper",
	sub_faction_name = "renegade",
	unit_template_name = "minion",
	volley_fire_target = true,
	spawn_anim_state = "to_ranged",
	aggro_inventory_slot = "slot_ranged_weapon",
	slot_template = "renegade_melee",
	broadphase_radius = 1,
	spawn_inventory_slot = "slot_ranged_weapon",
	stagger_resistance = 1,
	game_object_type = "minion_ranged",
	challenge_rating = 3,
	bone_lod_radius = 1.05,
	use_wounds = true,
	display_name = "loc_breed_display_name_renegade_shocktrooper",
	run_speed = 5.6,
	faction_name = "chaos",
	base_height = 1.9,
	ranged = true,
	line_of_sight_collision_filter = "filter_minion_line_of_sight_check",
	stagger_reduction = 5,
	player_locomotion_constrain_radius = 0.7,
	stagger_reduction_ranged = 15,
	can_patrol = true,
	smart_tag_target_type = "breed",
	base_unit = "content/characters/enemy/chaos_traitor_guard/third_person/base",
	has_direct_ragdoll_flow_event = true,
	name = breed_name,
	breed_type = breed_types.minion,
	power_level_type = {
		melee = "renegade_default_melee",
		ranged = "renegade_shotgun_shot"
	},
	tags = {
		minion = true,
		elite = true,
		close = true
	},
	point_cost = BreedTerrorEventSettings[breed_name].point_cost,
	armor_type = armor_types.armored,
	hit_mass = MinionDifficultySettings.hit_mass[breed_name],
	gib_template = MinionGibbingTemplates.renegade_shocktrooper_gibbing,
	stagger_durations = {
		[stagger_types.light] = 0.75,
		[stagger_types.medium] = 1.25,
		[stagger_types.heavy] = 2.8,
		[stagger_types.light_ranged] = 0.5,
		[stagger_types.sticky] = 0.6,
		[stagger_types.explosion] = 6.363636363636363,
		[stagger_types.killshot] = 1
	},
	stagger_immune_times = {
		[stagger_types.light] = 0.65,
		[stagger_types.medium] = 0.85,
		[stagger_types.heavy] = 2,
		[stagger_types.explosion] = 1.75,
		[stagger_types.light_ranged] = 0.2,
		[stagger_types.killshot] = 0.2,
		[stagger_types.sticky] = 0.25
	},
	stagger_thresholds = {
		[stagger_types.light] = 5,
		[stagger_types.medium] = 10,
		[stagger_types.heavy] = 20,
		[stagger_types.explosion] = 50,
		[stagger_types.killshot] = 10,
		[stagger_types.light_ranged] = 15,
		[stagger_types.sticky] = 5
	},
	stagger_thresholds = {
		[stagger_types.light] = 5,
		[stagger_types.medium] = 40,
		[stagger_types.heavy] = 60,
		[stagger_types.explosion] = 80,
		[stagger_types.light_ranged] = 15,
		[stagger_types.killshot] = 5
	},
	inventory = MinionVisualLoadoutTemplates.renegade_shocktrooper,
	sounds = require("scripts/settings/breed/breeds/renegade/renegade_shocktrooper_sounds"),
	vfx = require("scripts/settings/breed/breeds/renegade/renegade_common_vfx"),
	behavior_tree_name = breed_name,
	animation_variables = {
		"moving_attack_fwd_speed",
		"anim_move_speed",
		"lean"
	},
	shoot_offset_anim_event = {
		standing = "offset_shotgun_standing_shoot_01"
	},
	combat_range_data = BreedCombatRanges.renegade_shocktrooper,
	combat_vector_config = {
		choose_closest_to_target = true,
		choose_furthest_away = false,
		can_flank = true,
		default_combat_range = "close",
		switch_location_preference_on_locked_in_melee = true,
		valid_combat_ranges = {
			far = true,
			close = true
		}
	},
	attack_intensity_cooldowns = {
		melee = {
			0.3,
			0.5
		},
		moving_melee = {
			1.7,
			2.8
		},
		elite_shotgun = {
			0.1,
			0.4
		}
	},
	line_of_sight_data = {
		{
			id = "eyes",
			to_node = "enemy_aim_target_03",
			from_node = "j_head",
			offsets = PerceptionSettings.default_minion_line_of_sight_offsets
		}
	},
	target_selection_template = TargetSelectionTemplates.ranged,
	target_selection_weights = TargetSelectionWeights.renegade_shocktrooper,
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
		node = "j_neck",
		target_node = "enemy_aim_target_03",
		lean_variable_modifier = -0.2,
		valid_aim_combat_ranges = {
			far = true,
			close = true
		}
	},
	smart_object_template = SmartObjectSettings.templates.renegade,
	size_variation_range = {
		1,
		1
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
			j_head = 0.3,
			j_neck = 0.3
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
	wounds_config = {
		always_show_killing_blow = true,
		apply_threshold_filtering = false,
		health_percent_throttle = 0.2
	},
	hit_zone_weakspot_types = {
		[hit_zone_names.head] = weakspot_types.headshot
	},
	hitzone_armor_override = {
		[hit_zone_names.upper_right_arm] = armor_types.unarmored,
		[hit_zone_names.lower_right_arm] = armor_types.unarmored,
		[hit_zone_names.upper_right_leg] = armor_types.unarmored,
		[hit_zone_names.upper_left_arm] = armor_types.unarmored,
		[hit_zone_names.lower_left_arm] = armor_types.unarmored,
		[hit_zone_names.upper_left_leg] = armor_types.unarmored
	},
	hitzone_damage_multiplier = {
		ranged = {
			[hit_zone_names.upper_left_arm] = 0.75,
			[hit_zone_names.lower_left_arm] = 0.5,
			[hit_zone_names.upper_right_arm] = 0.75,
			[hit_zone_names.lower_right_arm] = 0.5,
			[hit_zone_names.upper_left_leg] = 0.75,
			[hit_zone_names.lower_left_leg] = 0.5,
			[hit_zone_names.upper_right_leg] = 0.75,
			[hit_zone_names.lower_right_leg] = 0.5
		}
	},
	blackboard_component_config = BreedBlackboardComponentTemplates.ranged_patroller_no_suppression
}

return breed_data
