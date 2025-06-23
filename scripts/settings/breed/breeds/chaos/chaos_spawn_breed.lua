-- chunkname: @scripts/settings/breed/breeds/chaos/chaos_spawn_breed.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BossNameTemplates = require("scripts/settings/boss/boss_name_templates")
local BossTemplates = require("scripts/settings/boss/boss_templates/boss_templates")
local BreedBlackboardComponentTemplates = require("scripts/settings/breed/breed_blackboard_component_templates")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local BreedTerrorEventSettings = require("scripts/settings/breed/breed_terror_event_settings")
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
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local armor_types = ArmorSettings.types
local breed_types = BreedSettings.types
local hit_zone_names = HitZone.hit_zone_names
local stagger_types = StaggerSettings.stagger_types
local weakspot_types = WeakspotSettings.types
local breed_name = "chaos_spawn"
local breed_data = {
	detection_radius = 20,
	walk_speed = 6,
	use_navigation_path_splines = true,
	use_bone_lod = false,
	look_at_distance = 20,
	ignore_stagger_accumulation = true,
	fx_proximity_culling_weight = 10,
	activate_slot_system_on_spawn = true,
	unit_template_name = "minion",
	sub_faction_name = "chaos",
	power_level_type = "chaos_spawn_melee",
	slot_template = "chaos_spawn",
	broadphase_radius = 2,
	navigation_propagation_box_extent = 200,
	count_num_grabs_done = true,
	stagger_resistance = 1,
	half_extent_forward = 0.6,
	half_extent_right = 0.7,
	hit_reacts_min_damage = 100,
	game_object_type = "minion_monster",
	challenge_rating = 30,
	bone_lod_radius = 3,
	trigger_boss_health_bar_on_damaged = true,
	explosion_radius = 1,
	display_name = "loc_breed_display_name_chaos_spawn",
	run_speed = 6,
	is_boss = true,
	faction_name = "chaos",
	base_height = 3.6,
	line_of_sight_collision_filter = "filter_minion_line_of_sight_check",
	stagger_reduction = 50,
	player_locomotion_constrain_radius = 1.5,
	can_patrol = true,
	smart_tag_target_type = "breed",
	explosion_power_multiplier = 2,
	base_unit = "content/characters/enemy/chaos_spawn/third_person/base",
	name = breed_name,
	breed_type = breed_types.minion,
	tags = {
		monster = true,
		minion = true
	},
	point_cost = BreedTerrorEventSettings[breed_name].point_cost,
	armor_type = armor_types.resistant,
	hit_mass = MinionDifficultySettings.hit_mass[breed_name],
	gib_template = MinionGibbingTemplates.chaos_spawn,
	boss_display_name = BossNameTemplates.chaos_spawn,
	boss_template = BossTemplates.chaos_spawn,
	stagger_durations = {
		[stagger_types.light] = 1.5,
		[stagger_types.medium] = 1.5,
		[stagger_types.heavy] = 1.5,
		[stagger_types.light_ranged] = 1.5,
		[stagger_types.explosion] = 1.5,
		[stagger_types.killshot] = 1.5,
		[stagger_types.sticky] = 1.5,
		[stagger_types.wall_collision] = 2
	},
	stagger_immune_times = {
		[stagger_types.light] = 1.5,
		[stagger_types.medium] = 1.5,
		[stagger_types.heavy] = 1.5,
		[stagger_types.light_ranged] = 0.5,
		[stagger_types.explosion] = 1.5
	},
	stagger_thresholds = {
		[stagger_types.light] = -1,
		[stagger_types.medium] = -1,
		[stagger_types.heavy] = -1,
		[stagger_types.explosion] = 100,
		[stagger_types.light_ranged] = -1,
		[stagger_types.killshot] = -1,
		[stagger_types.sticky] = -1
	},
	impact_anim_override = {
		damaged = {
			fwd = "hit_reaction_fwd",
			bwd = "hit_reaction_bwd",
			left = "hit_reaction_left",
			right = "hit_reaction_right"
		}
	},
	inventory = MinionVisualLoadoutTemplates.chaos_spawn,
	animation_variables = {
		"anim_move_speed"
	},
	sounds = require("scripts/settings/breed/breeds/chaos/chaos_spawn_sounds"),
	vfx = require("scripts/settings/breed/breeds/chaos/chaos_spawn_vfx"),
	look_at_tag = breed_name,
	behavior_tree_name = breed_name,
	attack_intensity_cooldowns = {
		melee = {
			0,
			0
		},
		moving_melee = {
			0,
			0
		}
	},
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
	target_selection_template = TargetSelectionTemplates.chaos_spawn,
	target_selection_weights = TargetSelectionWeights.chaos_spawn,
	threat_config = {
		threat_multiplier = 1,
		max_threat = 1000,
		threat_decay_per_second = 100
	},
	nav_tag_allowed_layers = {
		monster_walls = 1.5
	},
	smart_object_template = SmartObjectSettings.templates.chaos_spawn,
	size_variation_range = {
		1.04,
		1.04
	},
	fade = {
		max_distance = 1.2,
		max_height_difference = 2,
		min_distance = 0.8
	},
	hit_zones = {
		{
			name = hit_zone_names.head,
			actors = {
				"c_head",
				"c_neck1"
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
				"c_leftarm"
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
				"c_rightarm"
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
				"c_spine",
				"c_spine1",
				"c_leftarmB",
				"c_leftshoulder",
				"c_tentacleC1",
				"c_tentacleC2",
				"c_leftfinger4_jnt",
				"c_leftfinger5_jnt",
				"c_leftfinger3_jnt",
				"c_neck2",
				"c_leftforearmB",
				"c_tentacleC3",
				"c_smallTentacleE3",
				"c_smallTentacleE2",
				"c_smallTentacleE1",
				"c_smallTentacleA1",
				"c_smallTentacleA2",
				"c_smallTentacleA3",
				"c_lefthandA",
				"c_smallTentacleB1",
				"c_smallTentacleB2",
				"c_smallTentacleB3",
				"c_smallTentacleC3",
				"c_tentacleC4",
				"c_smallTentacleD1",
				"c_tentacleB2",
				"c_rightshoulder",
				"c_tentacleD1",
				"c_smallTentacleD2",
				"c_tentacleB4",
				"c_tentacleB3",
				"c_leftarmA",
				"c_leftforearmA",
				"c_lefttoebase",
				"c_leftfinger1_jnt",
				"c_leftfinger2_jnt",
				"c_tentacleD2",
				"c_tentacleD3",
				"c_smallTentacleC1",
				"c_smallTentacleC2"
			}
		}
	},
	hit_zone_ragdoll_actors = {
		[hit_zone_names.head] = {
			"j_head",
			"j_neck1"
		},
		[hit_zone_names.torso] = {
			"j_head",
			"j_neck1",
			"j_spine",
			"j_spine1",
			"j_leftarm",
			"j_leftforearm",
			"j_lefthand",
			"j_rightarm",
			"j_rightforearm",
			"j_righthand"
		},
		[hit_zone_names.upper_left_arm] = {
			"j_leftarm",
			"j_leftforearm",
			"j_lefthand"
		},
		[hit_zone_names.lower_left_arm] = {
			"j_leftforearm",
			"j_lefthand",
			"j_leftfinger1_jnt",
			"j_leftfinger2_jnt",
			"j_leftfinger3_jnt",
			"j_leftfinger4_jnt",
			"j_leftfinger5_jnt"
		},
		[hit_zone_names.upper_right_arm] = {
			"j_rightarm",
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
			j_spine1 = 0.4,
			j_head = 10.15,
			j_spine = 0.4,
			j_neck = 0.1
		},
		[hit_zone_names.torso] = {
			j_spine1 = 0.4,
			j_head = 10.1,
			j_spine = 0.4,
			j_neck = 0.1
		},
		[hit_zone_names.upper_left_arm] = {
			j_spine1 = 0.4,
			j_head = 10.1,
			j_spine = 0.4,
			j_neck = 0.1
		},
		[hit_zone_names.upper_right_arm] = {
			j_spine1 = 0.4,
			j_head = 10.1,
			j_spine = 0.4,
			j_neck = 0.1
		},
		[hit_zone_names.upper_left_leg] = {
			j_leftleg = 0.4,
			j_leftupleg = 0.25,
			j_spine = 0.3,
			j_leftfoot = 0.2,
			j_hips = 10.25,
			j_spine1 = 0.3
		},
		[hit_zone_names.upper_right_leg] = {
			j_rightfoot = 0.2,
			j_rightupleg = 0.25,
			j_spine = 0.3,
			j_hips = 10.25,
			j_rightleg = 0.4,
			j_spine1 = 0.3
		},
		[hit_zone_names.lower_left_arm] = {
			j_spine1 = 0.4,
			j_head = 10.1,
			j_spine = 0.4,
			j_neck = 0.1
		},
		[hit_zone_names.lower_right_arm] = {
			j_spine1 = 0.4,
			j_head = 10.1,
			j_spine = 0.4,
			j_neck = 0.1
		},
		[hit_zone_names.lower_left_leg] = {
			j_leftleg = 0.4,
			j_leftupleg = 0.25,
			j_spine = 0.3,
			j_leftfoot = 0.2,
			j_hips = 10.25,
			j_spine1 = 0.3
		},
		[hit_zone_names.lower_right_leg] = {
			j_rightfoot = 0.2,
			j_rightupleg = 0.25,
			j_spine = 0.3,
			j_hips = 10.25,
			j_rightleg = 0.4,
			j_spine1 = 0.3
		},
		[hit_zone_names.center_mass] = {
			j_hips = 10.5,
			j_spine = 0.5
		}
	},
	hit_zone_weakspot_types = {
		[hit_zone_names.head] = weakspot_types.headshot
	},
	hitzone_damage_multiplier = {
		melee = {
			[hit_zone_names.head] = 1,
			[hit_zone_names.torso] = 0.85,
			[hit_zone_names.lower_left_arm] = 0.65,
			[hit_zone_names.lower_right_arm] = 0.65,
			[hit_zone_names.lower_left_leg] = 0.65,
			[hit_zone_names.lower_right_leg] = 0.65,
			[hit_zone_names.upper_left_arm] = 0.65,
			[hit_zone_names.upper_right_arm] = 0.65,
			[hit_zone_names.upper_left_leg] = 0.65,
			[hit_zone_names.upper_right_leg] = 0.65,
			[hit_zone_names.center_mass] = 0.65
		},
		ranged = {
			[hit_zone_names.head] = 1,
			[hit_zone_names.torso] = 0.75,
			[hit_zone_names.lower_left_arm] = 0.5,
			[hit_zone_names.lower_right_arm] = 0.5,
			[hit_zone_names.lower_left_leg] = 0.5,
			[hit_zone_names.lower_right_leg] = 0.5,
			[hit_zone_names.upper_left_arm] = 0.5,
			[hit_zone_names.upper_right_arm] = 0.5,
			[hit_zone_names.upper_left_leg] = 0.5,
			[hit_zone_names.upper_right_leg] = 0.5,
			[hit_zone_names.center_mass] = 0.5
		}
	},
	outline_config = {},
	blackboard_component_config = BreedBlackboardComponentTemplates.chaos_spawn,
	companion_pounce_setting = {
		companion_pounce_action = "stagger_and_leap_away",
		on_target_hit = {
			linking_time = 1.55,
			anim_event_on_stick = "attack_leap_nonhuman_stick",
			anim_event = "attack_leap_nonhuman_start",
			animation_driven_duration = 0.5333333333333333,
			dog_target_nodes = {
				"dog_target_position_right_01",
				"dog_target_position_right_02",
				"dog_target_position_back_01",
				"dog_target_position_back_02",
				"dog_target_position_front_01",
				"dog_target_position_front_02"
			}
		},
		land_anim_events = {
			{
				duration = 0.8333333333333334,
				name = "attack_leap_nonhuman_land_02"
			}
		},
		damage_profile = DamageProfileTemplates.adamant_companion_monster_pounce
	}
}

return breed_data
