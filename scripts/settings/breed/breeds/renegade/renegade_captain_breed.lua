-- chunkname: @scripts/settings/breed/breeds/renegade/renegade_captain_breed.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BossNameTemplates = require("scripts/settings/boss/boss_name_templates")
local BreedBlackboardComponentTemplates = require("scripts/settings/breed/breed_blackboard_component_templates")
local BreedCombatRanges = require("scripts/settings/breed/breed_combat_ranges")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local BreedTerrorEventSettings = require("scripts/settings/breed/breed_terror_event_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MinionDifficultySettings = require("scripts/settings/difficulty/minion_difficulty_settings")
local MinionAttackSelectionTemplates = require("scripts/settings/minion_attack_selection/minion_attack_selection_templates")
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
local breed_name = "renegade_captain"
local breed_data = {
	walk_speed = 2.5,
	use_bone_lod = true,
	player_locomotion_constrain_radius = 0.7,
	sub_faction_name = "renegade",
	target_stickiness_distance = 1,
	slot_template = "renegade_melee",
	broadphase_radius = 1,
	ignore_stagger_accumulation = true,
	stagger_resistance = 5,
	unit_template_name = "minion",
	hit_reacts_min_damage = 10,
	game_object_type = "minion_renegade_captain",
	challenge_rating = 1,
	bone_lod_radius = 1.3,
	display_name = "loc_breed_display_name_renegade_captain",
	run_speed = 5.9,
	is_boss = true,
	spawn_anim_state = "to_riflemen",
	faction_name = "chaos",
	base_height = 2,
	state_machine = "content/characters/enemy/chaos_traitor_guard/third_person/animations/chaos_traitor_guard_captain",
	spawn_aggro_state = "aggroed",
	line_of_sight_collision_filter = "filter_minion_line_of_sight_check",
	stagger_reduction = 500,
	navigation_propagation_box_extent = 200,
	activate_slot_system_on_spawn = false,
	smart_tag_target_type = "breed",
	base_unit = "content/characters/enemy/chaos_traitor_guard_captain/third_person/base",
	has_direct_ragdoll_flow_event = true,
	name = breed_name,
	breed_type = breed_types.minion,
	power_level_type = {
		melee = "renegade_captain_melee_one_hand",
		melee_two_hand = "renegade_captain_melee_two_hand",
		ranged = "renegade_captain_default_shot"
	},
	tags = {
		captain = true,
		minion = true
	},
	point_cost = BreedTerrorEventSettings[breed_name].point_cost,
	armor_type = armor_types.armored,
	toughness_armor_type = armor_types.void_shield,
	hit_mass = MinionDifficultySettings.hit_mass[breed_name],
	toughness_template = MinionToughnessTemplates.renegade_captain,
	boss_display_name = BossNameTemplates.renegade_captain,
	stagger_durations = {
		[stagger_types.light] = 0.5,
		[stagger_types.medium] = 1.5,
		[stagger_types.heavy] = 3,
		[stagger_types.light_ranged] = 1,
		[stagger_types.shield_broken] = 4,
		[stagger_types.wall_collision] = 1,
		[stagger_types.explosion] = 6.363636363636363,
		[stagger_types.killshot] = 1,
		[stagger_types.sticky] = 1
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
		[stagger_types.wall_collision] = 8
	},
	stagger_thresholds = {
		[stagger_types.light] = -1,
		[stagger_types.medium] = 50,
		[stagger_types.heavy] = 400,
		[stagger_types.light_ranged] = -1,
		[stagger_types.sticky] = 100,
		[stagger_types.explosion] = -1,
		[stagger_types.killshot] = -1
	},
	inventory = MinionVisualLoadoutTemplates.renegade_captain,
	target_breed_items = {
		netted = {
			human = "content/items/generic/human_netgunner_net",
			ogryn = "content/items/generic/ogryn_netgunner_net"
		}
	},
	sounds = require("scripts/settings/breed/breeds/renegade/renegade_captain_sounds"),
	vfx = require("scripts/settings/breed/breeds/renegade/renegade_common_vfx"),
	behavior_tree_name = breed_name,
	attack_selection_templates = {
		MinionAttackSelectionTemplates.renegade_captain_all,
		MinionAttackSelectionTemplates.renegade_captain_default,
		MinionAttackSelectionTemplates.renegade_captain_melee,
		MinionAttackSelectionTemplates.renegade_captain_ranged
	},
	animation_variables = {
		"moving_attack_fwd_speed",
		"lean"
	},
	shoot_offset_anim_event = {
		pistol_standing = "offset_pistol_standing_shoot_01",
		shotgun_standing = "offset_shotgun_standing_shoot_01"
	},
	combat_range_data = BreedCombatRanges.renegade_captain,
	combat_vector_config = {
		default_combat_range = "close",
		valid_combat_ranges = {
			far = true,
			close = true
		}
	},
	detection_radius = math.huge,
	line_of_sight_data = {
		{
			id = "eyes",
			to_node = "enemy_aim_target_03",
			from_node = "j_head",
			offsets = PerceptionSettings.default_minion_line_of_sight_offsets
		},
		{
			id = "netgun",
			to_node = "enemy_aim_target_03",
			from_node = "j_rightarm_roll",
			offsets = {
				Vector3Box(0, 0, 0)
			}
		}
	},
	target_selection_template = TargetSelectionTemplates.renegade_captain,
	target_selection_weights = TargetSelectionWeights.renegade_captain,
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
	nearby_units_broadphase_config = {
		interval = 0.133,
		radius = 4,
		relation = "enemy",
		angle = math.degrees_to_radians(360)
	},
	nav_tag_allowed_layers = {
		teleporters = 1.2,
		ledges_with_fence = 80,
		jumps = 80,
		ledges = 80,
		cover_ledges = 80
	},
	smart_object_template = SmartObjectSettings.templates.renegade,
	size_variation_range = {
		1.2,
		1.2
	},
	fade = {
		max_distance = 0.7,
		max_height_difference = 1,
		min_distance = 0.2
	},
	hit_zones = {
		{
			name = hit_zone_names.captain_void_shield,
			actors = {
				"c_captain_void_shield"
			}
		},
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
		},
		[hit_zone_names.captain_void_shield] = {
			j_hips = 0.5,
			j_spine = 0.5
		}
	},
	hit_zone_weakspot_types = {
		[hit_zone_names.head] = weakspot_types.headshot
	},
	hitzone_damage_multiplier = {
		ranged = {
			[hit_zone_names.head] = 0.75,
			[hit_zone_names.lower_left_arm] = 0.5,
			[hit_zone_names.lower_right_arm] = 0.5,
			[hit_zone_names.lower_left_leg] = 0.5,
			[hit_zone_names.lower_right_leg] = 0.5,
			[hit_zone_names.captain_void_shield] = 0.5
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
			[hit_zone_names.captain_void_shield] = 3
		}
	},
	phase_template = PhaseTemplates.renegade_captain_default,
	outline_config = {},
	blackboard_component_config = BreedBlackboardComponentTemplates.renegade_captain
}

return breed_data
