-- chunkname: @scripts/settings/breed/breeds/companion/companion_dog_breed.lua

local BreedBlackboardComponentTemplates = require("scripts/settings/breed/breed_blackboard_component_templates")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
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
	base_height = 1.5,
	base_unit = "content/characters/player/companion_dog/third_person/base",
	bone_lod_radius = 1.5,
	broadphase_radius = 1,
	challenge_rating = 0,
	character_creation_state_machine = "content/characters/player/companion_dog/third_person/animations/unarmed",
	display_name = "loc_breed_display_name_undefined",
	end_of_round_state_machine = "content/characters/player/companion_dog/third_person/animations/unarmed",
	faction_name = "imperium",
	force_aggro = true,
	fx_proximity_culling_weight = 6,
	game_object_type = "minion_companion_dog",
	hub_state_machine = "content/characters/player/companion_dog/third_person/animations/hub",
	inventory_state_machine = "content/characters/player/companion_dog/third_person/animations/unarmed",
	line_of_sight_collision_filter = "filter_minion_line_of_sight_check",
	look_at_distance = 20,
	mission_intro_state_machine = "content/characters/player/companion_dog/third_person/animations/unarmed",
	navigation_propagation_box_extent = 200,
	player_locomotion_constrain_radius = 0.7,
	portrait_state_machine = "content/characters/player/companion_dog/third_person/animations/unarmed",
	run_speed = 5,
	select_target_cooldown = 1,
	target_stickiness_distance = 10,
	unit_template_name = "minion_companion_dog",
	use_avoidance = true,
	use_bone_lod = false,
	use_navigation_path_splines = true,
	walk_speed = 2,
	name = breed_name,
	breed_type = breed_types.companion,
	tags = {
		companion = true,
		minion = true,
	},
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
		"gallop_lean",
	},
	animation_variable_bounds = {
		walk_speed = {
			0.2,
			1.2,
		},
		trot_speed = {
			0.7,
			1.3,
		},
		canter_speed = {
			0.8,
			1.3,
		},
		gallop_speed = {
			0.9,
			1.4,
		},
		gallop_fast_speed = {
			1.4,
			1.5,
		},
	},
	animation_variable_init = {
		canter_speed = 0.5,
		gallop_fast_speed = 0.5,
		gallop_speed = 0.5,
		trot_speed = 0.5,
		walk_speed = 0.5,
	},
	animation_speed_thresholds = {
		walk = {
			event_name = "to_walk",
			max = 1.8,
			min = 0,
			offset = 0.3,
			speed_variable = "walk_speed",
		},
		trot = {
			event_name = "to_trot",
			max = 3.6,
			min = 1.8,
			offset = 0.3,
			speed_variable = "trot_speed",
		},
		canter = {
			event_name = "to_canter",
			max = 4.8,
			min = 3.6,
			offset = 0.3,
			speed_variable = "canter_speed",
		},
		gallop = {
			event_name = "to_gallop",
			max = 9,
			min = 4.8,
			offset = 0.3,
			speed_variable = "gallop_speed",
		},
		gallop_fast = {
			event_name = "to_gallop_fast",
			max = 10,
			min = 9,
			offset = 0.3,
			speed_variable = "gallop_fast_speed",
		},
	},
	animation_variable_bounds_hub = {
		walk_speed = {
			0.2,
			1.2,
		},
		trot_speed = {
			0.7,
			0.85,
		},
		canter_speed = {
			0.8,
			1.3,
		},
		gallop_speed = {
			0.9,
			1.4,
		},
		gallop_fast_speed = {
			1.4,
			1.5,
		},
	},
	animation_variable_init_hub = {
		canter_speed = 0.5,
		gallop_fast_speed = 0.5,
		gallop_speed = 0.5,
		trot_speed = 0.5,
		walk_speed = 0.5,
	},
	animation_speed_thresholds_hub = {
		walk = {
			event_name = "to_walk",
			max = 1.8,
			min = 0,
			offset = 0.3,
			speed_variable = "walk_speed",
		},
		trot = {
			event_name = "to_trot",
			max = 4.8,
			min = 1.8,
			offset = 0.3,
			speed_variable = "trot_speed",
		},
		canter = {
			event_name = "to_canter",
			max = 5,
			min = 4.8,
			offset = 0.3,
			speed_variable = "canter_speed",
		},
		gallop = {
			event_name = "to_gallop",
			max = 9,
			min = 5,
			offset = 0.3,
			speed_variable = "gallop_speed",
		},
		gallop_fast = {
			event_name = "to_gallop_fast",
			max = 10,
			min = 9,
			offset = 0.3,
			speed_variable = "gallop_fast_speed",
		},
	},
	navigation_path_spline_config = {
		channel_smoothing_angle = 15,
		max_distance_between_gates = 5,
		max_distance_to_spline_position = 5,
		min_distance_between_gates = 0.25,
		navigation_channel_radius = 6,
		spline_distance_to_borders = 0.1,
		spline_length = 100,
		spline_recomputation_ratio = 0.5,
		turn_sampling_angle = 30,
	},
	nav_tag_allowed_layers = {
		cover_ledges = 40,
		cover_vaults = 0.5,
		jumps = 40,
		ledges = 40,
		ledges_with_fence = 40,
	},
	smart_object_template = SmartObjectSettings.templates.chaos_hound,
	fade = {
		max_distance = 0.9,
		max_height_difference = 1,
		min_distance = 0.65,
		node_name = "fade_root",
	},
	detection_radius = math.huge,
	target_changed_attack_intensities = {
		disabling = 5,
	},
	line_of_sight_data = {
		{
			from_node = "j_head",
			id = "eyes",
			to_node = "enemy_aim_target_03",
			offsets = PerceptionSettings.default_minion_line_of_sight_offsets,
		},
	},
	target_selection_template = TargetSelectionTemplates.companion_dog,
	target_selection_weights = TargetSelectionWeights.companion_dog,
	threat_config = {
		max_threat = 50,
		threat_decay_per_second = 2.5,
		threat_multiplier = 1,
	},
	aim_config = {
		distance = 10,
		lerp_speed = 5,
		node = "j_neck",
		target = "head_aim_target",
		target_node = "enemy_aim_target_03",
	},
	combat_vector_config = {
		choose_furthest_away = true,
		default_combat_range = "far",
		valid_combat_ranges = {
			far = true,
		},
	},
	hit_zones = {
		{
			name = hit_zone_names.center_mass,
			actors = {
				"c_spine",
				"c_spine1",
				"c_spine2",
			},
		},
	},
	blackboard_component_config = BreedBlackboardComponentTemplates.companion_dog,
	blackboard_component_config_hub = BreedBlackboardComponentTemplates.companion_dog_hub,
	base_unit_sound_sources = {
		jaw = "fx_jaw",
	},
	testify_flags = {
		spawn_all_enemies = false,
	},
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
