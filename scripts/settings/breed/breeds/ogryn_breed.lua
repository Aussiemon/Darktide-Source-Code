-- chunkname: @scripts/settings/breed/breeds/ogryn_breed.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BotSettings = require("scripts/settings/bot/bot_settings")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local TargetSelectionTemplates = require("scripts/extension_systems/perception/target_selection_templates")
local armor_types = ArmorSettings.types
local breed_types = BreedSettings.types
local hit_zone_names = HitZone.hit_zone_names
local stagger_results = AttackSettings.stagger_results
local ogryn_size_variation_range = {
	0.9,
	0.925
}
local average_ogryn_size = ogryn_size_variation_range[1] + (ogryn_size_variation_range[2] - ogryn_size_variation_range[1]) / 2
local breed_data = {
	friendly_hit_mass = 0,
	display_name = "loc_breed_display_name_undefined",
	behavior_tree_name = "bot",
	end_of_round_state_machine = "content/characters/player/ogryn/third_person/animations/menu/end_of_round",
	inventory_state_machine = "content/characters/player/ogryn/third_person/animations/menu/inventory",
	first_person_unit = "content/characters/player/ogryn/first_person/base",
	mission_intro_state_machine = "content/characters/player/ogryn/third_person/animations/menu/mission_briefing",
	portrait_state_machine = "content/characters/player/ogryn/third_person/animations/menu/portrait",
	character_creation_state_machine = "content/characters/player/ogryn/third_person/animations/menu/character_creation",
	faction_name = "imperium",
	name = "ogryn",
	debug_color_name = "sea_green",
	broadphase_radius = 1,
	ladder_max_distance_allow_climb = 1.3,
	ladder_whole_movement_anim_distance = 1.4,
	ladder_movement_anim_length = 4,
	base_unit = "content/characters/player/ogryn/third_person/base",
	hit_mass = 2,
	breed_type = breed_types.player,
	genders = {
		"male"
	},
	testify_flags = {
		spawn_all_enemies = false
	},
	tags = {
		ogryn = true
	},
	armor_type = armor_types.player,
	heights = {
		default = 2.2 / average_ogryn_size,
		sprint = 1.75 / average_ogryn_size,
		crouch = 1.7 / average_ogryn_size,
		slide = 1.6 / average_ogryn_size,
		vault = 1.8 / average_ogryn_size
	},
	size_variation_range = ogryn_size_variation_range,
	first_person_pose_scale = average_ogryn_size * 0.8,
	fade = {
		max_distance = 1.2,
		max_height_difference = 1.2,
		min_distance = 0.5
	},
	threat_config = {
		threat_decay_per_second = 1,
		max_threat = 50
	},
	target_selection_template = TargetSelectionTemplates.bot_default,
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
				"c_spine",
				"c_spine1"
			}
		}
	},
	hit_reaction_keys = {
		catapulting_template = "catapulting_template",
		force_look_function = "ogryn_force_look_function",
		toughness_disorientation_type = "toughness_disorientation_type",
		interrupt_alternate_fire = "interrupt_alternate_fire",
		push_template = "ogryn_push_template",
		ignore_stun_immunity = "ignore_stun_immunity",
		disorientation_type = "ogryn_disorientation_type"
	},
	hit_reaction_stun_types = {
		toughness_absorbed_default = "ogryn_toughness",
		toughness_burning = "toughness_burning",
		toughness_broken_default = "ogryn_medium",
		fumbled = "ogryn_fumbled",
		toughness_absorbed_melee = "ogryn_toughness_melee"
	},
	default_stagger_result = stagger_results.no_stagger,
	ledge_finder_tweak_data = {
		player_width = 0.5,
		player_height = 1.61,
		significant_obstacle_distance = 1.31
	},
	ledge_vault_tweak_values = {
		inair_allowed_height_distance_max = 0.65,
		always_step_up = true,
		allowed_height_distance_min = 0.5,
		allowed_height_distance_max = 0.8,
		allowed_flat_distance_to_ledge = 1.5,
		inair_allowed_height_distance_min = 0.5
	},
	spawn_buffs = {
		"grimoire_damage_tick",
		"sprint_with_stamina_buff"
	},
	blackboard_component_config = BotSettings.blackboard_component_config,
	base_unit_sound_sources = {
		head = "j_head",
		right_foot = "j_rightfoot",
		left_foot = "j_leftfoot",
		fx_anim_01 = "fx_anim_01",
		hips = "j_hips"
	},
	base_unit_fx_sources = {
		head = "j_head",
		right_foot = "j_rightfoot",
		left_foot = "j_leftfoot",
		fx_anim_01 = "fx_anim_01",
		hips = "j_hips"
	},
	sfx = {
		footstep_land = "player_footstep_land",
		footstep = "player_footstep",
		footstep_jump = "player_footstep_jump",
		footstep_dodge = "player_footstep_dodge",
		sliding_alias = "player_slide_loop"
	},
	vfx = {
		footstep_land = "player_footstep_land",
		footstep = "player_footstep",
		footstep_jump = "player_footstep_jump",
		footstep_dodge = "player_footstep_dodge",
		sliding_alias = "player_slide_loop"
	}
}

return breed_data
