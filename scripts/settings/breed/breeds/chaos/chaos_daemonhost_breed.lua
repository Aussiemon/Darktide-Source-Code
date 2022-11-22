local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BossNameTemplates = require("scripts/settings/boss/boss_name_templates")
local BossTemplates = require("scripts/settings/boss/boss_templates/boss_templates")
local BreedBlackboardComponentTemplates = require("scripts/settings/breed/breed_blackboard_component_templates")
local BreedCombatRanges = require("scripts/settings/breed/breed_combat_ranges")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local BreedTerrorEventSettings = require("scripts/settings/breed/breed_terror_event_settings")
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
local breed_name = "chaos_daemonhost"
local breed_data = {
	walk_speed = 1.9,
	use_navigation_path_splines = true,
	use_bone_lod = false,
	navigation_propagation_box_extent = 200,
	sub_faction_name = "chaos",
	unit_template_name = "minion",
	slot_template = "chaos_ogryn",
	broadphase_radius = 1,
	ignore_ally_alerts = true,
	stagger_resistance = 1,
	boss_health_bar_disabled = true,
	smart_tag_breed_aggroed_context = true,
	use_action_controlled_alert = true,
	hit_reacts_min_damage = 100,
	game_object_type = "minion_daemonhost",
	challenge_rating = 20,
	bone_lod_radius = 2.5,
	power_level_type = "chaos_daemonhost_melee",
	display_name = "loc_breed_display_name_chaos_daemonhost",
	run_speed = 6.2,
	is_boss = true,
	faction_name = "chaos",
	base_height = 1.7,
	state_machine = "content/characters/enemy/chaos_daemonhost_witch/third_person/animations/chaos_daemonhost_witch",
	line_of_sight_collision_filter = "filter_minion_line_of_sight_check",
	stagger_reduction = 50,
	player_locomotion_constrain_radius = 0.3,
	activate_slot_system_on_spawn = true,
	smart_tag_target_type = "breed",
	base_unit = "content/characters/enemy/chaos_daemonhost_witch/third_person/base",
	hit_mass = 100,
	reduced_hit_mass = 20,
	name = breed_name,
	breed_type = breed_types.minion,
	tags = {
		minion = true,
		witch = true,
		monster = true
	},
	testify_flags = {
		spawn_all_enemies = false
	},
	point_cost = BreedTerrorEventSettings[breed_name].point_cost,
	armor_type = armor_types.resistant,
	boss_display_name = BossNameTemplates.daemonhost,
	boss_template = BossTemplates.chaos_daemonhost,
	gib_template = MinionGibbingTemplates.chaos_daemonhost,
	stagger_durations = {
		[stagger_types.light] = 1,
		[stagger_types.medium] = 1,
		[stagger_types.heavy] = 1,
		[stagger_types.light_ranged] = 1,
		[stagger_types.explosion] = 1,
		[stagger_types.killshot] = 1,
		[stagger_types.sticky] = 1
	},
	stagger_immune_times = {
		[stagger_types.light] = 1,
		[stagger_types.medium] = 1,
		[stagger_types.heavy] = 1,
		[stagger_types.light_ranged] = 1
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
	inventory = MinionVisualLoadoutTemplates.chaos_daemonhost,
	sounds = require("scripts/settings/breed/breeds/chaos/chaos_daemonhost_sounds"),
	vfx = require("scripts/settings/breed/breeds/chaos/chaos_common_vfx"),
	behavior_tree_name = breed_name,
	animation_variables = {
		"lean",
		"moving_attack_fwd_speed"
	},
	combat_range_data = BreedCombatRanges.chaos_daemonhost,
	suppress_config = {
		threat_factor = 20,
		require_line_of_sight = true,
		threshold = 40,
		max_value = 50,
		decay_amount = 1,
		decay_speeds = {
			melee = 1,
			far = 1,
			close = 1
		}
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
	line_of_sight_data = {
		{
			id = "eyes",
			to_node = "enemy_aim_target_03",
			from_node = "j_head",
			offsets = PerceptionSettings.default_minion_line_of_sight_offsets
		}
	},
	target_selection_template = TargetSelectionTemplates.chaos_daemonhost,
	target_selection_weights = TargetSelectionWeights.chaos_daemonhost,
	threat_config = {
		threat_decay_per_second = 10,
		max_threat = 7500
	},
	aim_config = {
		lerp_speed = 10,
		target = "head_aim_target",
		distance = 5,
		require_line_of_sight = false,
		ignore_require_target = true,
		node = "j_neck",
		target_node = "enemy_aim_target_03"
	},
	nearby_units_broadphase_config = {
		interval = 0.133,
		radius = 4,
		relation = "allied",
		angle = math.degrees_to_radians(100)
	},
	smart_object_template = SmartObjectSettings.templates.chaos_daemonhost,
	size_variation_range = {
		1.2,
		1.25
	},
	fade = {
		max_distance = 0.8,
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
			"j_spine1",
			"j_spine2",
			"j_leftshoulder",
			"j_rightshoulder",
			"j_leftarm",
			"j_leftforearm",
			"j_lefthand",
			"j_rightarm",
			"j_rightforearm",
			"j_righthand"
		},
		[hit_zone_names.upper_left_arm] = {
			"j_leftarm",
			"j_leftshoulder"
		},
		[hit_zone_names.lower_left_arm] = {
			"j_leftforearm",
			"j_lefthand"
		},
		[hit_zone_names.upper_right_arm] = {
			"j_rightarm",
			"j_rightshoulder"
		},
		[hit_zone_names.lower_right_arm] = {
			"j_rightforearm",
			"j_righthand"
		},
		[hit_zone_names.upper_left_leg] = {
			"j_leftupleg"
		},
		[hit_zone_names.lower_left_leg] = {
			"j_leftleg",
			"j_leftfoot"
		},
		[hit_zone_names.upper_right_leg] = {
			"j_rightupleg"
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
	hit_zone_weakspot_types = {
		[hit_zone_names.head] = weakspot_types.headshot
	},
	hitzone_damage_multiplier = {
		melee = {
			[hit_zone_names.head] = 0.9,
			[hit_zone_names.torso] = 0.7,
			[hit_zone_names.lower_left_arm] = 0.7,
			[hit_zone_names.lower_right_arm] = 0.7,
			[hit_zone_names.lower_left_leg] = 0.7,
			[hit_zone_names.lower_right_leg] = 0.7,
			[hit_zone_names.upper_left_arm] = 0.7,
			[hit_zone_names.upper_right_arm] = 0.7,
			[hit_zone_names.upper_left_leg] = 0.7,
			[hit_zone_names.upper_right_leg] = 0.7,
			[hit_zone_names.center_mass] = 0.7
		},
		ranged = {
			[hit_zone_names.head] = 0.7,
			[hit_zone_names.torso] = 0.6,
			[hit_zone_names.lower_left_arm] = 0.6,
			[hit_zone_names.lower_right_arm] = 0.6,
			[hit_zone_names.lower_left_leg] = 0.6,
			[hit_zone_names.lower_right_leg] = 0.6,
			[hit_zone_names.upper_left_arm] = 0.6,
			[hit_zone_names.upper_right_arm] = 0.6,
			[hit_zone_names.upper_left_leg] = 0.6,
			[hit_zone_names.upper_right_leg] = 0.6,
			[hit_zone_names.center_mass] = 0.6
		}
	},
	outline_config = {
		visual_loadout_slot = "slot_body"
	},
	blackboard_component_config = BreedBlackboardComponentTemplates.chaos_daemonhost
}

return breed_data
