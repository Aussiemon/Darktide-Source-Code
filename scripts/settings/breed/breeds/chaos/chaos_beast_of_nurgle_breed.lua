local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BossNameTemplates = require("scripts/settings/boss/boss_name_templates")
local BossTemplates = require("scripts/settings/boss/boss_templates/boss_templates")
local BreedBlackboardComponentTemplates = require("scripts/settings/breed/breed_blackboard_component_templates")
local BreedCombatRanges = require("scripts/settings/breed/breed_combat_ranges")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local BreedTerrorEventSettings = require("scripts/settings/breed/breed_terror_event_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
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
local breed_name = "chaos_beast_of_nurgle"
local breed_data = {
	ignore_stagger_accumulation = true,
	walk_speed = 2,
	use_bone_lod = false,
	look_at_distance = 20,
	fx_proximity_culling_weight = 10,
	sub_faction_name = "chaos",
	unit_template_name = "minion",
	broadphase_radius = 1,
	weakspot_stagger_reduction = -200,
	only_accumulate_stagger_on_weakspot = true,
	stagger_resistance = 1,
	stagger_pool_decay_delay = 1,
	base_height = 3.6,
	explosion_radius = 2,
	player_locomotion_constrain_radius = 1,
	half_extent_right = 0.8,
	stagger_pool_decay_time = 2,
	half_extent_forward = 0.8,
	hit_reacts_min_damage = 50,
	use_navigation_path_splines = true,
	game_object_type = "minion_beast_of_nurgle",
	challenge_rating = 30,
	bone_lod_radius = 3,
	trigger_boss_health_bar_on_damaged = true,
	display_name = "loc_breed_display_name_chaos_beast_of_nurgle",
	run_speed = 3.9,
	is_boss = true,
	faction_name = "chaos",
	uses_script_components = true,
	spawn_aggro_state = "aggroed",
	line_of_sight_collision_filter = "filter_minion_line_of_sight_check",
	stagger_reduction = 100,
	count_num_liquid_hits = true,
	navigation_propagation_box_extent = 500,
	smart_tag_target_type = "breed",
	base_unit = "content/characters/enemy/chaos_beast_of_nurgle/third_person/base",
	name = breed_name,
	breed_type = breed_types.minion,
	power_level_type = {
		melee = "chaos_beast_of_nurgle_melee",
		ranged = "chaos_beast_of_nurgle_ranged"
	},
	tags = {
		monster = true,
		minion = true
	},
	point_cost = BreedTerrorEventSettings[breed_name].point_cost,
	armor_type = armor_types.resistant,
	hit_mass = MinionDifficultySettings.hit_mass[breed_name],
	boss_display_name = BossNameTemplates.beast_of_nurgle,
	boss_template = BossTemplates.chaos_beast_of_nurgle,
	combat_range_data = BreedCombatRanges.chaos_beast_of_nurgle,
	combat_vector_config = {
		choose_furthest_away = true,
		default_combat_range = "far",
		valid_combat_ranges = {
			far = true
		}
	},
	gib_template = MinionGibbingTemplates.chaos_beast_of_nurgle,
	stagger_durations = {
		[stagger_types.light] = 2,
		[stagger_types.medium] = 2,
		[stagger_types.heavy] = 2,
		[stagger_types.light_ranged] = 2,
		[stagger_types.explosion] = 2,
		[stagger_types.killshot] = 2,
		[stagger_types.sticky] = 1.6666666666666667,
		[stagger_types.wall_collision] = 2
	},
	stagger_immune_times = {
		[stagger_types.light] = 5,
		[stagger_types.medium] = 5,
		[stagger_types.heavy] = 10,
		[stagger_types.explosion] = 10,
		[stagger_types.light_ranged] = 5
	},
	stagger_thresholds = {
		[stagger_types.light] = -1,
		[stagger_types.medium] = -1,
		[stagger_types.heavy] = 120,
		[stagger_types.explosion] = 200,
		[stagger_types.light_ranged] = -1,
		[stagger_types.killshot] = -1,
		[stagger_types.sticky] = -1
	},
	hit_zone_hit_reactions = {
		lower_left_arm = "hit_reaction_arm_left",
		upper_right_arm = "hit_reaction_arm_right",
		lower_right_arm = "hit_reaction_arm_right",
		head = "hit_reaction_bwd",
		upper_left_arm = "hit_reaction_arm_left",
		weakspot = "hit_reaction_blob",
		lower_tail = {
			left = "hit_reaction_tail_lower_left",
			right = "hit_reaction_tail_lower_right"
		},
		upper_tail = {
			left = "hit_reaction_tail_upper_left",
			right = "hit_reaction_tail_upper_right"
		},
		torso = {
			left = "hit_reaction_left",
			right = "hit_reaction_right"
		}
	},
	hit_reacts_ignored_actions = {
		consume = true,
		vomit = true
	},
	inventory = MinionVisualLoadoutTemplates.chaos_beast_of_nurgle,
	sounds = require("scripts/settings/breed/breeds/chaos/chaos_beast_of_nurgle_sounds"),
	vfx = require("scripts/settings/breed/breeds/chaos/chaos_common_vfx"),
	target_effect_template = EffectTemplates.chaos_beast_of_nurgle_consumed_effect,
	look_at_tag = breed_name,
	dissolve_config = {
		slot_name = "slot_body",
		duration = 8.5,
		from = -3,
		delay = 0,
		to = 5,
		remove_ragdoll_when_done = false,
		material_variable_name = "dissolve",
		material_names = {
			"beast_of_nurgle_torso",
			"beast_of_nurgle_lowerbody",
			"beast_of_nurgle_arms",
			"beast_of_nurgle_appendages",
			"bon_gib_cap"
		}
	},
	behavior_tree_name = breed_name,
	animation_variables = {
		"tongue_length"
	},
	spawn_buffs = {
		"beast_of_nurgle_liquid_immunity"
	},
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
	detection_radius = math.huge,
	target_changed_attack_intensities = {
		disabling = 5
	},
	line_of_sight_data = {
		{
			id = "eyes",
			to_node = "enemy_aim_target_03",
			from_node = "j_head",
			offsets = PerceptionSettings.chaos_beast_of_nurgle_minion_line_of_sight_offsets
		},
		{
			to_node = "enemy_aim_target_03",
			from_node = "j_spine",
			id = "vomit",
			offsets = {
				Vector3Box(0, 0, -0.5)
			},
			from_offsets = Vector3Box(0, -1, 0)
		}
	},
	target_selection_template = TargetSelectionTemplates.chaos_beast_of_nurgle,
	target_selection_weights = TargetSelectionWeights.chaos_beast_of_nurgle,
	threat_config = {
		threat_multiplier = 0.1,
		max_threat = 50,
		threat_decay_per_second = 5
	},
	aim_config = {
		aim_on_target = true,
		target = "aim_target",
		distance = 5,
		lerp_speed = 200,
		node = "j_neck",
		target_node = "enemy_aim_target_03"
	},
	nearby_units_broadphase_config = {
		interval = 0.133,
		radius = 4,
		relation = "allied",
		angle = math.degrees_to_radians(100),
		valid_breeds = {
			chaos_newly_infected = true,
			chaos_poxwalker = true
		}
	},
	navigation_path_spline_config = {
		spline_distance_to_borders = 2,
		spline_recomputation_ratio = 0.5,
		navigation_channel_radius = 6,
		turn_sampling_angle = 30,
		spline_length = 100,
		channel_smoothing_angle = 15,
		max_distance_to_spline_position = 5,
		max_distance_between_gates = 5,
		min_distance_between_gates = 0.25
	},
	nav_tag_allowed_layers = {
		teleporters = 0.5,
		ledges_with_fence = 8000,
		monster_walls = 1.5,
		jumps = 8000,
		ledges = 8000,
		cover_ledges = 8000
	},
	smart_object_template = SmartObjectSettings.templates.chaos_beast_of_nurgle,
	fade = {
		max_distance = 1.6,
		max_height_difference = 2,
		min_distance = 1.1
	},
	hit_zones = {
		{
			name = hit_zone_names.head,
			actors = {
				"c_neck",
				"c_head"
			}
		},
		{
			name = hit_zone_names.center_mass,
			actors = {
				"c_gut",
				"c_spine",
				"c_spine1"
			}
		},
		{
			name = hit_zone_names.upper_left_arm,
			actors = {
				"c_leftshoulder",
				"c_leftarmspline01",
				"c_leftarmspline02",
				"c_leftarmspline03"
			}
		},
		{
			name = hit_zone_names.lower_left_arm,
			actors = {
				"c_leftarmspline04",
				"c_leftarmspline05",
				"c_leftarmspline06",
				"c_lefthand"
			}
		},
		{
			name = hit_zone_names.upper_right_arm,
			actors = {
				"c_rightshoulder",
				"c_rightarmspline01",
				"c_rightarmspline02",
				"c_rightarmspline03"
			}
		},
		{
			name = hit_zone_names.lower_right_arm,
			actors = {
				"c_rightarmspline04",
				"c_rightarmspline05",
				"c_rightarmspline06",
				"c_righthand"
			}
		},
		{
			name = hit_zone_names.upper_tail,
			actors = {
				"c_tail_anim_01",
				"c_tail_anim_02",
				"c_tail_anim_03",
				"c_tail_anim_04"
			}
		},
		{
			name = hit_zone_names.lower_tail,
			actors = {
				"c_tail_anim_05",
				"c_tail_anim_06",
				"c_tail_anim_07",
				"c_tail_anim_08"
			}
		},
		{
			name = hit_zone_names.tongue,
			actors = {
				"c_tonguespline_start",
				"c_tonguespline01",
				"c_tonguespline02",
				"c_tonguespline03",
				"c_tonguespline04",
				"c_tonguespline05",
				"c_tonguespline06",
				"c_tonguespline_end"
			}
		},
		{
			name = hit_zone_names.afro,
			actors = {
				"r_afro"
			}
		},
		{
			name = hit_zone_names.weakspot,
			actors = {
				"c_weakspot"
			}
		}
	},
	hit_zone_ragdoll_pushes = {
		[hit_zone_names.head] = {
			j_spine1 = 0.4,
			j_head = 0.15,
			j_spine = 0.4,
			j_neck = 0.1
		},
		[hit_zone_names.torso] = {
			j_spine1 = 0.4,
			j_head = 0.1,
			j_spine = 0.4,
			j_neck = 0.1
		},
		[hit_zone_names.upper_left_arm] = {
			j_spine1 = 0.4,
			j_head = 0.1,
			j_spine = 0.4,
			j_neck = 0.1
		},
		[hit_zone_names.upper_right_arm] = {
			j_spine1 = 0.4,
			j_head = 0.1,
			j_spine = 0.4,
			j_neck = 0.1
		},
		[hit_zone_names.upper_left_leg] = {
			j_leftleg = 0.4,
			j_leftupleg = 0.25,
			j_spine = 0.3,
			j_leftfoot = 0.2,
			j_hips = 0.25,
			j_spine1 = 0.3
		},
		[hit_zone_names.upper_right_leg] = {
			j_rightfoot = 0.2,
			j_rightupleg = 0.25,
			j_spine = 0.3,
			j_hips = 0.25,
			j_rightleg = 0.4,
			j_spine1 = 0.3
		},
		[hit_zone_names.lower_left_arm] = {
			j_spine1 = 0.4,
			j_head = 0.1,
			j_spine = 0.4,
			j_neck = 0.1
		},
		[hit_zone_names.lower_right_arm] = {
			j_spine1 = 0.4,
			j_head = 0.1,
			j_spine = 0.4,
			j_neck = 0.1
		},
		[hit_zone_names.lower_left_leg] = {
			j_leftleg = 0.4,
			j_leftupleg = 0.25,
			j_spine = 0.3,
			j_leftfoot = 0.2,
			j_hips = 0.25,
			j_spine1 = 0.3
		},
		[hit_zone_names.lower_right_leg] = {
			j_rightfoot = 0.2,
			j_rightupleg = 0.25,
			j_spine = 0.3,
			j_hips = 0.25,
			j_rightleg = 0.4,
			j_spine1 = 0.3
		},
		[hit_zone_names.center_mass] = {
			j_hips = 0.5,
			j_spine = 0.5
		},
		[hit_zone_names.weakspot] = {
			j_hips = 0.5,
			j_spine = 0.5
		},
		[hit_zone_names.tongue] = {
			j_hips = 0.5,
			j_spine = 0.5
		},
		[hit_zone_names.upper_tail] = {
			j_hips = 0.5,
			j_spine = 0.5
		},
		[hit_zone_names.lower_tail] = {
			j_hips = 0.5,
			j_spine = 0.5
		}
	},
	hitzone_damage_multiplier = {
		melee = {
			[hit_zone_names.head] = 0.9,
			[hit_zone_names.weakspot] = 1.4,
			[hit_zone_names.lower_left_arm] = 0.7,
			[hit_zone_names.lower_right_arm] = 0.7,
			[hit_zone_names.lower_left_leg] = 0.7,
			[hit_zone_names.lower_right_leg] = 0.7,
			[hit_zone_names.upper_left_arm] = 0.7,
			[hit_zone_names.upper_right_arm] = 0.7,
			[hit_zone_names.upper_left_leg] = 0.7,
			[hit_zone_names.upper_right_leg] = 0.7,
			[hit_zone_names.center_mass] = 0.7,
			[hit_zone_names.upper_tail] = 0.2,
			[hit_zone_names.lower_tail] = 0.2
		},
		ranged = {
			[hit_zone_names.weakspot] = 1,
			[hit_zone_names.head] = 0.5,
			[hit_zone_names.lower_left_arm] = 0.4,
			[hit_zone_names.lower_right_arm] = 0.4,
			[hit_zone_names.lower_left_leg] = 0.4,
			[hit_zone_names.lower_right_leg] = 0.4,
			[hit_zone_names.upper_left_arm] = 0.4,
			[hit_zone_names.upper_right_arm] = 0.4,
			[hit_zone_names.upper_left_leg] = 0.4,
			[hit_zone_names.upper_right_leg] = 0.4,
			[hit_zone_names.center_mass] = 0.4,
			[hit_zone_names.upper_tail] = 0.1,
			[hit_zone_names.lower_tail] = 0.1
		}
	},
	hit_zone_weakspot_types = {
		[hit_zone_names.weakspot] = weakspot_types.weakspot
	},
	weakspot_config = {
		impact_fx = {
			damage_type = damage_types.minion_beast_of_nurgle_weakspot_hit
		}
	},
	outline_config = {},
	blackboard_component_config = BreedBlackboardComponentTemplates.chaos_beast_of_nurgle
}

return breed_data
