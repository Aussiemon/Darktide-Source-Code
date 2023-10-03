local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BotSettings = require("scripts/settings/bot/bot_settings")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local TargetSelectionTemplates = require("scripts/extension_systems/perception/target_selection_templates")
local armor_types = ArmorSettings.types
local breed_types = BreedSettings.types
local hit_zone_names = HitZone.hit_zone_names
local human_size_variation_range = {
	0.95,
	1.08
}
local average_human_size = human_size_variation_range[1] + (human_size_variation_range[2] - human_size_variation_range[1]) / 2
local breed_data = {
	name = "human",
	display_name = "loc_breed_display_name_undefined",
	inventory_state_machine = "content/characters/player/human/third_person/animations/menu/inventory",
	end_of_round_state_machine = "content/characters/player/human/third_person/animations/menu/end_of_round",
	mission_intro_state_machine = "content/characters/player/human/third_person/animations/menu/mission_briefing",
	portrait_state_machine = "content/characters/player/human/third_person/animations/menu/portrait",
	first_person_unit = "content/characters/player/human/first_person/base",
	character_creation_state_machine = "content/characters/player/human/third_person/animations/menu/character_creation",
	faction_name = "imperium",
	debug_color_name = "cyan",
	behavior_tree_name = "bot",
	broadphase_radius = 1,
	ladder_max_distance_allow_climb = 0.5,
	ladder_whole_movement_anim_distance = 1.4,
	ladder_movement_anim_length = 4,
	base_unit = "content/characters/player/human/third_person/base",
	hit_mass = 2,
	breed_type = breed_types.player,
	genders = {
		"male",
		"female"
	},
	testify_flags = {
		spawn_all_enemies = false
	},
	tags = {
		human = true
	},
	armor_type = armor_types.player,
	heights = {
		default = 1.65 / average_human_size,
		sprint = 1.4 / average_human_size,
		crouch = 1 / average_human_size,
		slide = 0.85 / average_human_size,
		vault = 0.9 / average_human_size
	},
	size_variation_range = human_size_variation_range,
	fade = {
		max_distance = 0.9,
		max_height_difference = 1,
		min_distance = 0.3
	},
	threat_config = {
		threat_decay_per_second = 5,
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
		force_look_function = "force_look_function",
		catapulting_template = "catapulting_template",
		push_template = "push_template",
		ignore_stun_immunity = "ignore_stun_immunity",
		disorientation_type = "disorientation_type"
	},
	hit_reaction_stun_types = {
		toughness_absorbed_melee = "toughness_melee",
		toughness_broken_ranged_sprinting = "ranged_sprinting",
		toughness_broken_ranged = "ranged",
		toughness_broken_default = "medium",
		toughness_absorbed_default = "toughness",
		fumbled = "fumbled",
		toughness_absorbed_ranged_sprinting = "ranged_sprinting"
	},
	ledge_finder_tweak_data = {
		player_width = 0.5,
		player_height = 1.21,
		significant_obstacle_distance = 1.31
	},
	ledge_vault_tweak_values = {
		inair_allowed_height_distance_max = 0.65,
		allowed_height_distance_min = 0.31,
		allowed_height_distance_max = 1.3,
		allowed_flat_distance_to_ledge = 1.5,
		inair_allowed_height_distance_min = 0.31
	},
	spawn_buffs = {
		"grimoire_damage_tick",
		"sprint_with_stamina_buff"
	},
	blackboard_component_config = BotSettings.blackboard_component_config,
	base_unit_sound_sources = {
		head = "j_head",
		fx_right_hand = "fx_spawn_righthand",
		fx_left_forearm = "fx_spawn_leftforearm",
		fx_left_hand = "fx_spawn_lefthand",
		rightfoot = "j_rightfoot",
		hips = "j_hips"
	},
	base_unit_fx_sources = {
		head = "j_head",
		fx_right_hand = "fx_spawn_righthand",
		fx_left_forearm = "fx_spawn_leftforearm",
		fx_left_hand = "fx_spawn_lefthand",
		rightfoot = "j_rightfoot",
		hips = "j_hips"
	},
	sfx = {
		sliding_alias = "player_slide_loop"
	}
}

return breed_data
