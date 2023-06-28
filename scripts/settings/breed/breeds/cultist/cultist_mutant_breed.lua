local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BreedBlackboardComponentTemplates = require("scripts/settings/breed/breed_blackboard_component_templates")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local BreedTerrorEventSettings = require("scripts/settings/breed/breed_terror_event_settings")
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
local breed_name = "cultist_mutant"
local breed_data = {
	run_speed = 6,
	use_bone_lod = false,
	look_at_distance = 20,
	use_death_velocity = true,
	display_name = "loc_breed_display_name_cultist_mutant",
	unit_template_name = "minion",
	can_be_used_for_all_factions = true,
	faction_name = "chaos",
	volley_fire_target = true,
	uses_wwise_special_targeting_parameter = true,
	sub_faction_name = "chaos",
	broadphase_radius = 1,
	spawn_aggro_state = "aggroed",
	stagger_resistance = 2000,
	walk_speed = 2.3,
	use_avoidance = true,
	base_height = 2.4,
	line_of_sight_collision_filter = "filter_minion_line_of_sight_check",
	player_locomotion_constrain_radius = 0.7,
	half_extent_right = 0.5,
	challenge_rating = 6,
	use_wounds = true,
	navigation_propagation_box_extent = 200,
	hit_reacts_min_damage = 300,
	smart_tag_target_type = "breed",
	use_navigation_path_splines = true,
	game_object_type = "minion_special_melee",
	half_extent_forward = 0.5,
	base_unit = "content/characters/enemy/chaos_mutant_charger/third_person/base",
	hit_mass = 10,
	bone_lod_radius = 2.3,
	name = breed_name,
	breed_type = breed_types.minion,
	tags = {
		disabler = true,
		minion = true,
		special = true
	},
	point_cost = BreedTerrorEventSettings[breed_name].point_cost,
	armor_type = armor_types.berserker,
	gib_template = MinionGibbingTemplates.chaos_mutant_charger,
	stagger_durations = {
		[stagger_types.light] = 1,
		[stagger_types.medium] = 2,
		[stagger_types.heavy] = 2,
		[stagger_types.light_ranged] = 1,
		[stagger_types.explosion] = 3,
		[stagger_types.killshot] = 1,
		[stagger_types.sticky] = 1,
		[stagger_types.wall_collision] = 1
	},
	stagger_immune_times = {
		[stagger_types.light] = 0.25,
		[stagger_types.medium] = 0.5,
		[stagger_types.heavy] = 2.25,
		[stagger_types.light_ranged] = 0.5
	},
	inventory = MinionVisualLoadoutTemplates.cultist_mutant,
	sounds = require("scripts/settings/breed/breeds/cultist/cultist_mutant_sounds"),
	vfx = require("scripts/settings/breed/breeds/cultist/cultist_common_vfx"),
	look_at_tag = breed_name,
	behavior_tree_name = breed_name,
	attack_intensity_cooldowns = {
		disabling = {
			1.7,
			2.8
		}
	},
	detection_radius = math.huge,
	target_changed_attack_intensities = {
		disabling = 5
	},
	line_of_sight_data = {
		{
			id = "eyes",
			to_node = "enemy_aim_target_03",
			from_node = "j_head",
			offsets = PerceptionSettings.default_minion_line_of_sight_offsets
		}
	},
	target_selection_template = TargetSelectionTemplates.cultist_mutant,
	target_selection_weights = TargetSelectionWeights.cultist_mutant,
	threat_config = {
		threat_multiplier = 1,
		max_threat = 10000,
		threat_decay_per_second = 50
	},
	navigation_path_spline_config = {
		spline_distance_to_borders = 3,
		spline_recomputation_ratio = 0.5,
		navigation_channel_radius = 6,
		turn_sampling_angle = 45,
		spline_length = 100,
		channel_smoothing_angle = 15,
		max_distance_to_spline_position = 5,
		max_distance_between_gates = 5,
		min_distance_between_gates = 0.5
	},
	smart_object_template = SmartObjectSettings.templates.cultist_mutant,
	fade = {
		max_distance = 1.3,
		max_height_difference = 1,
		min_distance = 0.5
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
				"c_spine2",
				"c_spine2_misc_01",
				"c_spine2_misc_02"
			}
		},
		{
			name = hit_zone_names.upper_left_arm,
			actors = {
				"c_leftarm",
				"c_leftshoulder",
				"c_leftarm_misc"
			}
		},
		{
			name = hit_zone_names.lower_left_arm,
			actors = {
				"c_leftforearm",
				"c_lefthand1"
			}
		},
		{
			name = hit_zone_names.upper_right_arm,
			actors = {
				"c_rightarm",
				"c_rightshoulder",
				"c_rightshoulder_misc_01",
				"c_rightshoulder_misc_02",
				"c_rightarm_misc"
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
				"c_lefttoebase"
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
			"j_neck",
			"j_spine",
			"j_spine1",
			"j_spine2",
			"j_leftarm",
			"j_leftshoulder",
			"j_leftforearm",
			"j_rightarm",
			"j_rightshoulder",
			"j_rightforearm",
			"j_righthand"
		},
		[hit_zone_names.upper_left_arm] = {
			"j_leftarm",
			"j_leftshoulder",
			"j_leftforearm"
		},
		[hit_zone_names.lower_left_arm] = {
			"j_leftforearm"
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
			"j_lefttoebase"
		},
		[hit_zone_names.lower_left_leg] = {
			"j_leftleg",
			"j_lefttoebase"
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
		apply_threshold_filtering = true,
		health_percent_throttle = 0.3,
		always_show_killing_blow = false,
		thresholds = {
			[damage_types.blunt] = 0.3,
			[damage_types.blunt_heavy] = 0.4,
			[damage_types.blunt_thunder] = 0.3,
			[damage_types.plasma] = 0.15,
			[damage_types.rippergun_pellet] = 0.15,
			[damage_types.auto_bullet] = 0.25,
			[damage_types.pellet] = 0.35,
			[damage_types.boltshell] = 0.1,
			[damage_types.laser] = 0.55,
			[damage_types.power_sword] = 0.3,
			[damage_types.sawing_stuck] = 0.5,
			[damage_types.slashing_force_stuck] = 0.3,
			[damage_types.combat_blade] = 0.1
		}
	},
	hit_zone_weakspot_types = {
		[hit_zone_names.head] = weakspot_types.headshot
	},
	hitzone_damage_multiplier = {
		melee = {
			[hit_zone_names.head] = 3,
			[hit_zone_names.torso] = 3,
			[hit_zone_names.upper_left_arm] = 3,
			[hit_zone_names.upper_right_arm] = 3,
			[hit_zone_names.upper_left_leg] = 3,
			[hit_zone_names.upper_right_leg] = 3,
			[hit_zone_names.lower_left_arm] = 3,
			[hit_zone_names.lower_right_arm] = 3,
			[hit_zone_names.lower_left_leg] = 3,
			[hit_zone_names.lower_right_leg] = 3,
			[hit_zone_names.center_mass] = 3
		}
	},
	blackboard_component_config = BreedBlackboardComponentTemplates.cultist_mutant
}

return breed_data
