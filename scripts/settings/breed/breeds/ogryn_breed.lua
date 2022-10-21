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
local breed_data = {
	name = "ogryn",
	display_name = "loc_breed_display_name_undefined",
	inventory_state_machine = "content/characters/player/ogryn/third_person/animations/menu/inventory",
	end_of_round_state_machine = "content/characters/player/ogryn/third_person/animations/menu/end_of_round",
	mission_intro_state_machine = "content/characters/player/ogryn/third_person/animations/menu/mission_briefing",
	portrait_state_machine = "content/characters/player/ogryn/third_person/animations/menu/portrait",
	first_person_unit = "content/characters/player/ogryn/first_person/base",
	behavior_tree_name = "bot",
	character_creation_state_machine = "content/characters/player/ogryn/third_person/animations/menu/character_creation",
	faction_name = "imperium",
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
		default = 2.2,
		crouch = 1.8,
		sprint = 1.9,
		vault = 1.8,
		slide = 1.6
	},
	size_variation_range = {
		0.9,
		0.925
	},
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
		interrupt_alternate_fire = "interrupt_alternate_fire",
		force_look_function = "ogryn_force_look_function",
		catapulting_template = "catapulting_template",
		push_template = "ogryn_push_template",
		ignore_stun_immunity = "ignore_stun_immunity",
		disorientation_type = "ogryn_disorientation_type"
	},
	hit_reaction_stun_types = {
		toughness_absorbed_default = "ogryn_toughness",
		toughness_broken_default = "ogryn_medium",
		fumbled = "fumbled",
		toughness_absorbed_melee = "ogryn_toughness_melee"
	},
	default_stagger_result = stagger_results.no_stagger,
	ledge_finder_tweak_data = {
		player_width = 0.5,
		player_height = 1.61
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
		"grimoire_damage_tick"
	},
	blackboard_component_config = BotSettings.blackboard_component_config,
	base_unit_sound_sources = {
		head = "j_head",
		rightfoot = "j_rightfoot",
		hips = "j_hips"
	},
	base_unit_fx_sources = {
		head = "j_head",
		rightfoot = "j_rightfoot",
		hips = "j_hips"
	},
	sfx = {
		sliding_alias = "player_slide_loop"
	}
}

return breed_data
