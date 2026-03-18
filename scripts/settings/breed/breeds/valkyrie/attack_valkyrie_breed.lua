-- chunkname: @scripts/settings/breed/breeds/valkyrie/attack_valkyrie_breed.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BreedBlackboardComponentTemplates = require("scripts/settings/breed/breed_blackboard_component_templates")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local FleeConstants = require("scripts/extension_systems/flee/flee_constants")
local HitZone = require("scripts/utilities/attack/hit_zone")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local TargetSelectionTemplates = require("scripts/extension_systems/perception/target_selection_templates")
local TargetSelectionWeights = require("scripts/settings/minion_target_selection/minion_target_selection_weights")
local breed_name = "attack_valkyrie"
local armor_types = ArmorSettings.types
local breed_types = BreedSettings.types
local hit_zone_names = HitZone.hit_zone_names
local flee_types = FleeConstants.flee_types
local breed_data = {
	airbound = true,
	always_update_unit = true,
	base_height = 3.6,
	base_unit = "content/characters/enemy/valkyrie/third_person/attack_valkyrie",
	broadphase_radius = 10,
	can_patrol = false,
	challenge_rating = 30,
	detection_radius = 60,
	display_name = "loc_breed_display_name_attack_valkyrie",
	explosion_radius = 10,
	faction_name = "imperium",
	fly_acceleration = 5,
	fly_fast_acceleration = 10,
	fly_fast_speed = 40,
	fly_speed = 8,
	flying = true,
	flying_navmesh_radius = 10,
	fx_proximity_culling_weight = 6,
	game_object_type = "flying_minion_ranged",
	has_inventory = false,
	heat = 0,
	ignore_minion_push = true,
	is_untargetable = false,
	line_of_sight_collision_filter = "filter_minion_line_of_sight_check",
	no_ragdoll = true,
	run_speed = 2.5,
	smart_tag_target_type = "breed",
	spring_dampened_husk_rotation = true,
	unit_template_name = "minion",
	use_bone_lod = false,
	use_navigation_path_splines = true,
	uses_script_components = true,
	walk_speed = 2.5,
	name = breed_name,
	breed_type = breed_types.minion,
	armor_type = armor_types.armored,
	blackboard_component_config = BreedBlackboardComponentTemplates.attack_valkyrie,
	tags = {
		minion = true,
	},
	size_variation_range = {
		1.04,
		1.04,
	},
	outline_config = {},
	dynamic_fx_templates = {
		"flow_velocity_parameter",
	},
	behavior_tree_name = breed_name,
	flee_settings = {
		budget_falloff_per_second = -1,
		flee_budget = 120,
		flee_type = flee_types.bounds_air,
		before_aggro_modifier = -math.huge,
		rate_modifiers_by_in_combat_tags = {
			captain = -1,
			monster = -1,
			ogryn = -0.1,
		},
	},
	threat_config = {
		max_threat = 1000,
		threat_decay_per_second = 100,
		threat_multiplier = 1,
	},
	target_selection_template = TargetSelectionTemplates.aid_ally,
	target_selection_weights = TargetSelectionWeights.attack_valkyrie,
	target_changed_attack_intensities = {
		disabling = 5,
	},
	line_of_sight_data = {
		{
			from_node = "fx_wpn_node_1",
			id = "left_pod",
			to_node = "j_spine",
			offsets = PerceptionSettings.default_minion_line_of_sight_offsets,
		},
		{
			from_node = "fx_wpn_node_2",
			id = "right_pod",
			to_node = "j_spine",
			offsets = PerceptionSettings.default_minion_line_of_sight_offsets,
		},
	},
	scripted_animation_settings = {
		extension_name = "ScriptedFlyingAnimationExtension",
		idle_offset = 0.5,
		idle_rotation_force_axis = "forward",
		max_lean_at_speed = 25,
		reference_forward_distance = 50,
		rotation_stiffness = 2.5,
		spawn_rotation_offset = {
			node_name = "anim_global",
			offset = {
				0,
				0,
				180,
			},
		},
		idle_rotation_offset = math.degrees_to_radians(5),
		corner_lean = math.degrees_to_radians(-48),
		max_speed_corner_lean = math.degrees_to_radians(-10),
		lean_rotation_acceleration = math.degrees_to_radians(60),
		max_speed_lean_rotation_acceleration = math.degrees_to_radians(90),
		max_lean_rotation_speed = math.degrees_to_radians(120),
		max_rotation_speed = math.degrees_to_radians(540),
		hover_lean_limit = math.degrees_to_radians(25),
	},
	hit_zones = {
		{
			name = hit_zone_names.center_mass,
			actors = {},
		},
	},
	companion_pounce_setting = {
		companion_pounce_action = "stagger_and_leap_away",
		ignore_target_selection = true,
	},
	testify_flags = {
		spawn_all_enemies = false,
	},
}

return breed_data
