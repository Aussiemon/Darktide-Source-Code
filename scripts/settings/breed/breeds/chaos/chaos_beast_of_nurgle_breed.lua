local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BreedBlackboardComponentTemplates = require("scripts/settings/breed/breed_blackboard_component_templates")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
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
local breed_name = "chaos_beast_of_nurgle"
local breed_data = {
	run_speed = 3.9,
	use_bone_lod = false,
	look_at_distance = 20,
	challenge_rating = 30,
	unit_template_name = "minion",
	display_name = "loc_breed_display_name_chaos_beast_of_nurgle",
	faction_name = "chaos",
	sub_faction_name = "chaos",
	slot_template = "chaos_ogryn",
	broadphase_radius = 1,
	walk_speed = 2,
	spawn_aggro_state = "aggroed",
	uses_script_components = true,
	stagger_resistance = 100,
	navigation_propagation_box_extent = 500,
	base_height = 3.6,
	power_level_type = "chaos_plague_ogryn_melee",
	line_of_sight_collision_filter = "filter_minion_line_of_sight_check",
	player_locomotion_constrain_radius = 1.5,
	activate_slot_system_on_spawn = true,
	smart_tag_target_type = "breed",
	use_navigation_path_splines = true,
	game_object_type = "minion_monster",
	base_unit = "content/characters/enemy/chaos_beast_of_nurgle/third_person/base",
	hit_mass = 20,
	bone_lod_radius = 3,
	name = breed_name,
	breed_type = breed_types.minion,
	tags = {
		minion = true
	},
	testify_flags = {
		spawn_all_enemies = false
	},
	point_cost = {},
	armor_type = armor_types.resistant,
	stagger_durations = {
		[stagger_types.light] = 1,
		[stagger_types.medium] = 1,
		[stagger_types.heavy] = 1.5,
		[stagger_types.light_ranged] = 1,
		[stagger_types.explosion] = 1,
		[stagger_types.killshot] = 1,
		[stagger_types.sticky] = 1
	},
	stagger_immune_times = {
		[stagger_types.light] = 0.25,
		[stagger_types.medium] = 0.5,
		[stagger_types.heavy] = 2.25,
		[stagger_types.light_ranged] = 0.5
	},
	stagger_thresholds = {
		[stagger_types.light] = 5,
		[stagger_types.medium] = 5,
		[stagger_types.heavy] = 7,
		[stagger_types.light_ranged] = 5,
		[stagger_types.sticky] = 5
	},
	inventory = MinionVisualLoadoutTemplates.chaos_beast_of_nurgle,
	sounds = require("scripts/settings/breed/breeds/chaos/chaos_beast_of_nurgle_sounds"),
	vfx = require("scripts/settings/breed/breeds/chaos/chaos_common_vfx"),
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
	target_selection_template = TargetSelectionTemplates.chaos_plague_ogryn,
	target_selection_weights = TargetSelectionWeights.chaos_beast_of_nurgle,
	threat_config = {
		threat_multiplier = 0.1,
		max_threat = 50,
		threat_decay_per_second = 5
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
				"c_head",
				"c_weakspot"
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
			name = hit_zone_names.tail,
			actors = {
				"c_tail_anim_01",
				"c_tail_anim_02",
				"c_tail_anim_03",
				"c_tail_anim_04",
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
			name = hit_zone_names.torso,
			actors = {
				"c_gut",
				"c_spine",
				"c_spine1"
			}
		},
		{
			name = hit_zone_names.afro,
			actors = {
				"r_afro"
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
		}
	},
	hit_zone_weakspot_types = {
		[hit_zone_names.head] = weakspot_types.headshot
	},
	blackboard_component_config = BreedBlackboardComponentTemplates.monster
}

return breed_data
