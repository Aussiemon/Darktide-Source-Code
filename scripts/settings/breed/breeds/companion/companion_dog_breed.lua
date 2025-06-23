-- chunkname: @scripts/settings/breed/breeds/companion/companion_dog_breed.lua

local BreedBlackboardComponentTemplates = require("scripts/settings/breed/breed_blackboard_component_templates")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MinionVisualLoadoutTemplates = require("scripts/settings/minion_visual_loadout/minion_visual_loadout_templates")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local SmartObjectSettings = require("scripts/settings/navigation/smart_object_settings")
local TargetSelectionTemplates = require("scripts/extension_systems/perception/target_selection_templates")
local TargetSelectionWeights = require("scripts/settings/minion_target_selection/minion_target_selection_weights")
local breed_types = BreedSettings.types
local hit_zone_names = HitZone.hit_zone_names
local breed_name = "companion_dog"

local function _is_in_hub()
	return Managers.state and Managers.state.game_mode and Managers.state.game_mode:is_social_hub() or false
end

local breed_data = {
	walk_speed = 2,
	mission_intro_state_machine = "content/characters/player/companion_dog/third_person/animations/unarmed",
	end_of_round_state_machine = "content/characters/player/companion_dog/third_person/animations/unarmed",
	inventory_state_machine = "content/characters/player/companion_dog/third_person/animations/unarmed",
	look_at_distance = 20,
	portrait_state_machine = "content/characters/player/companion_dog/third_person/animations/unarmed",
	fx_proximity_culling_weight = 6,
	unit_template_name = "minion_companion_dog",
	character_creation_state_machine = "content/characters/player/companion_dog/third_person/animations/unarmed",
	faction_name = "imperium",
	target_stickiness_distance = 10,
	broadphase_radius = 1,
	base_height = 1.5,
	use_navigation_path_splines = true,
	player_locomotion_constrain_radius = 0.7,
	use_bone_lod = false,
	line_of_sight_collision_filter = "filter_minion_line_of_sight_check",
	run_speed = 5,
	force_aggro = true,
	select_target_cooldown = 1,
	use_avoidance = true,
	display_name = "loc_breed_display_name_undefined",
	navigation_propagation_box_extent = 200,
	hub_state_machine = "content/characters/player/companion_dog/third_person/animations/hub",
	game_object_type = "minion_companion_dog",
	base_unit = "content/characters/player/companion_dog/third_person/base",
	challenge_rating = 0,
	bone_lod_radius = 1.5,
	name = breed_name,
	breed_type = breed_types.companion,
	tags = {
		minion = true,
		companion = true
	},
	inventory = MinionVisualLoadoutTemplates.companion_dog,
	sounds = require("scripts/settings/breed/breeds/companion/companion_dog_sounds"),
	vfx = require("scripts/settings/breed/breeds/companion/companion_dog_vfx"),
	look_at_tag = breed_name,
	behavior_tree_name = breed_name,
	behavior_tree_name_hub = breed_name .. "_hub",
	outline_config = {},
	animation_variables = {
		"walk_speed",
		"trot_speed",
		"canter_speed",
		"gallop_speed",
		"gallop_fast_speed",
		"attack_start_angle",
		"gallop_lean"
	},
	animation_variable_bounds = {
		walk_speed = {
			0.2,
			1.2
		},
		trot_speed = {
			0.7,
			1.3
		},
		canter_speed = {
			0.8,
			1.3
		},
		gallop_speed = {
			0.9,
			1.4
		},
		gallop_fast_speed = {
			1.4,
			1.5
		}
	},
	animation_variable_init = {
		gallop_fast_speed = 0.5,
		walk_speed = 0.5,
		gallop_speed = 0.5,
		canter_speed = 0.5,
		trot_speed = 0.5
	},
	animation_speed_thresholds = {
		walk = {
			speed_variable = "walk_speed",
			min = 0,
			event_name = "to_walk",
			offset = 0.3,
			max = 1.8
		},
		trot = {
			speed_variable = "trot_speed",
			min = 1.8,
			event_name = "to_trot",
			offset = 0.3,
			max = 3.6
		},
		canter = {
			speed_variable = "canter_speed",
			min = 3.6,
			event_name = "to_canter",
			offset = 0.3,
			max = 4.8
		},
		gallop = {
			speed_variable = "gallop_speed",
			min = 4.8,
			event_name = "to_gallop",
			offset = 0.3,
			max = 9
		},
		gallop_fast = {
			speed_variable = "gallop_fast_speed",
			min = 9,
			event_name = "to_gallop_fast",
			offset = 0.3,
			max = 10
		}
	},
	animation_variable_bounds_hub = {
		walk_speed = {
			0.2,
			1.2
		},
		trot_speed = {
			0.7,
			0.85
		},
		canter_speed = {
			0.8,
			1.3
		},
		gallop_speed = {
			0.9,
			1.4
		},
		gallop_fast_speed = {
			1.4,
			1.5
		}
	},
	animation_variable_init_hub = {
		gallop_fast_speed = 0.5,
		walk_speed = 0.5,
		gallop_speed = 0.5,
		canter_speed = 0.5,
		trot_speed = 0.5
	},
	animation_speed_thresholds_hub = {
		walk = {
			speed_variable = "walk_speed",
			min = 0,
			event_name = "to_walk",
			offset = 0.3,
			max = 1.8
		},
		trot = {
			speed_variable = "trot_speed",
			min = 1.8,
			event_name = "to_trot",
			offset = 0.3,
			max = 4.8
		},
		canter = {
			speed_variable = "canter_speed",
			min = 4.8,
			event_name = "to_canter",
			offset = 0.3,
			max = 5
		},
		gallop = {
			speed_variable = "gallop_speed",
			min = 5,
			event_name = "to_gallop",
			offset = 0.3,
			max = 9
		},
		gallop_fast = {
			speed_variable = "gallop_fast_speed",
			min = 9,
			event_name = "to_gallop_fast",
			offset = 0.3,
			max = 10
		}
	},
	navigation_path_spline_config = {
		spline_distance_to_borders = 0.1,
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
		ledges_with_fence = 40,
		cover_vaults = 0.5,
		jumps = 40,
		ledges = 40,
		cover_ledges = 40
	},
	smart_object_template = SmartObjectSettings.templates.chaos_hound,
	fade = {
		node_name = "fade_root",
		max_distance = 0.9,
		max_height_difference = 1,
		min_distance = 0.65
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
	target_selection_template = TargetSelectionTemplates.companion_dog,
	target_selection_weights = TargetSelectionWeights.companion_dog,
	threat_config = {
		threat_multiplier = 1,
		max_threat = 50,
		threat_decay_per_second = 2.5
	},
	aim_config = {
		lerp_speed = 5,
		target = "head_aim_target",
		distance = 10,
		node = "j_neck",
		target_node = "enemy_aim_target_03"
	},
	combat_vector_config = {
		choose_furthest_away = true,
		default_combat_range = "far",
		valid_combat_ranges = {
			far = true
		}
	},
	hit_zones = {
		{
			name = hit_zone_names.center_mass,
			actors = {
				"c_spine",
				"c_spine1",
				"c_spine2"
			}
		}
	},
	blackboard_component_config = BreedBlackboardComponentTemplates.companion_dog,
	blackboard_component_config_hub = BreedBlackboardComponentTemplates.companion_dog_hub,
	base_unit_sound_sources = {
		jaw = "fx_jaw"
	},
	testify_flags = {
		spawn_all_enemies = false
	}
}

breed_data.get_animation_variable_bounds = function ()
	local is_in_hub = _is_in_hub()

	return is_in_hub and breed_data.animation_variable_bounds_hub or breed_data.animation_variable_bounds
end

breed_data.get_animation_variable_init = function ()
	local is_in_hub = _is_in_hub()

	return is_in_hub and breed_data.animation_variable_init_hub or breed_data.animation_variable_init
end

breed_data.get_animation_speed_thresholds = function ()
	local is_in_hub = _is_in_hub()

	return is_in_hub and breed_data.animation_speed_thresholds_hub or breed_data.animation_speed_thresholds
end

return breed_data
