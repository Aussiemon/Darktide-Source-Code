-- chunkname: @scripts/settings/breed/breeds/companion/companion_servo_skull_breed.lua

local BreedBlackboardComponentTemplates = require("scripts/settings/breed/breed_blackboard_component_templates")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local TargetSelectionTemplates = require("scripts/extension_systems/perception/target_selection_templates")
local MinionVisualLoadoutTemplates = require("scripts/settings/minion_visual_loadout/minion_visual_loadout_templates")
local hit_zone_names = HitZone.hit_zone_names
local breed_types = BreedSettings.types
local BREED_NAME = "companion_servo_skull"
local breed_data = {
	base_height = 1,
	base_unit = "content/characters/player/companion_servo_skull/third_person/base",
	can_tag_order = true,
	challenge_rating = 0,
	companion_allow_hack_double_tag = true,
	companion_double_tag_template_name = "servo_skull_enemy_companion_target",
	display_name = "loc_breed_display_name_undefined",
	exponential_smoothing_rotation_sync_husk = true,
	faction_name = "imperium",
	fx_proximity_culling_weight = 6,
	game_object_type = "minion_companion_servo_skull",
	ignore_smoke_fog_los = true,
	inventory_state_machine = "content/characters/player/companion_servo_skull/third_person/animations/inventory",
	line_of_sight_collision_filter = "filter_minion_line_of_sight_check",
	run_speed = 8,
	select_target_cooldown = 5,
	unit_template_name = "minion_companion_servo_skull",
	use_nameplate = false,
	name = BREED_NAME,
	breed_type = breed_types.companion,
	animation_variables = {
		"velocity_length",
	},
	animation_variable_bounds = {
		velocity_length = {
			-99,
			99,
		},
	},
	tags = {
		companion = true,
		minion = true,
	},
	inventory = MinionVisualLoadoutTemplates.companion_servo_skull,
	sounds = require("scripts/settings/breed/breeds/companion/companion_servo_skull_sounds"),
	vfx = require("scripts/settings/breed/breeds/companion/companion_servo_skull_vfx"),
	effect_template_names = {
		aim_on_ground_effect_template_name = "companion_servo_skull_aim_on_ground_effect",
		charged_shoot_effect_template_name = "companion_servo_skull_charged_shooting",
		empowered_effect_template_name = "companion_servo_skull_empowered_effect",
	},
	hit_zones = {
		{
			name = hit_zone_names.center_mass,
			actors = {
				"c_skull",
			},
		},
	},
	fade = {
		max_distance = 0.4,
		max_height_difference = 0.2,
		min_distance = 0.2,
		node_name = "fade_root",
	},
	behavior_tree_name = BREED_NAME,
	blackboard_component_config = BreedBlackboardComponentTemplates.companion_servo_skull,
	base_unit_sound_sources = {
		base = "fx_base",
	},
	testify_flags = {
		spawn_all_enemies = false,
	},
	line_of_sight_data = {
		{
			from_node = "skull_aim_center",
			id = "eyes",
			to_node = "enemy_aim_target_03",
			offsets = PerceptionSettings.default_minion_line_of_sight_offsets,
		},
	},
	target_selection_template = TargetSelectionTemplates.companion_servo_skull,
	threat_config = {
		max_threat = 50,
		threat_decay_per_second = 2.5,
		threat_multiplier = 1,
	},
	power_level_type = {
		ranged = "chaos_spawn_melee",
	},
	aim_config = {
		distance = 10,
		lerp_speed = 200,
		node = "skull_aim_center",
		target = "skull_aim_target",
		target_node = "enemy_aim_target_02",
	},
}

return breed_data
