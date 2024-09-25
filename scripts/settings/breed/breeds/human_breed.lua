-- chunkname: @scripts/settings/breed/breeds/human_breed.lua

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
	1.08,
}
local average_human_size = human_size_variation_range[1] + (human_size_variation_range[2] - human_size_variation_range[1]) / 2
local breed_data = {
	base_unit = "content/characters/player/human/third_person/base",
	behavior_tree_name = "bot",
	broadphase_radius = 1,
	character_creation_state_machine = "content/characters/player/human/third_person/animations/menu/character_creation",
	debug_color_name = "cyan",
	display_name = "loc_breed_display_name_undefined",
	end_of_round_state_machine = "content/characters/player/human/third_person/animations/menu/end_of_round",
	faction_name = "imperium",
	first_person_unit = "content/characters/player/human/first_person/base",
	friendly_hit_mass = 0,
	hit_mass = 2,
	inventory_state_machine = "content/characters/player/human/third_person/animations/menu/inventory",
	ladder_max_distance_allow_climb = 0.5,
	ladder_movement_anim_length = 4,
	ladder_whole_movement_anim_distance = 1.4,
	mission_intro_state_machine = "content/characters/player/human/third_person/animations/menu/mission_briefing",
	name = "human",
	portrait_state_machine = "content/characters/player/human/third_person/animations/menu/portrait",
	breed_type = breed_types.player,
	genders = {
		"male",
		"female",
	},
	testify_flags = {
		spawn_all_enemies = false,
	},
	tags = {
		human = true,
	},
	armor_type = armor_types.player,
	heights = {
		default = 1.65 / average_human_size,
		sprint = 1.4 / average_human_size,
		crouch = 1 / average_human_size,
		slide = 0.85 / average_human_size,
		vault = 0.9 / average_human_size,
	},
	size_variation_range = human_size_variation_range,
	fade = {
		max_distance = 0.9,
		max_height_difference = 1,
		min_distance = 0.3,
	},
	threat_config = {
		max_threat = 50,
		threat_decay_per_second = 5,
	},
	target_selection_template = TargetSelectionTemplates.bot_default,
	hit_zones = {
		{
			name = hit_zone_names.head,
			actors = {
				"c_head",
				"c_neck",
			},
		},
		{
			name = hit_zone_names.torso,
			actors = {
				"c_hips",
				"c_spine",
				"c_spine1",
				"c_spine2",
			},
		},
		{
			name = hit_zone_names.upper_left_arm,
			actors = {
				"c_leftarm",
				"c_leftshoulder",
			},
		},
		{
			name = hit_zone_names.lower_left_arm,
			actors = {
				"c_leftforearm",
				"c_lefthand",
			},
		},
		{
			name = hit_zone_names.upper_right_arm,
			actors = {
				"c_rightarm",
				"c_rightshoulder",
			},
		},
		{
			name = hit_zone_names.lower_right_arm,
			actors = {
				"c_rightforearm",
				"c_righthand",
			},
		},
		{
			name = hit_zone_names.upper_left_leg,
			actors = {
				"c_leftupleg",
			},
		},
		{
			name = hit_zone_names.lower_left_leg,
			actors = {
				"c_leftleg",
				"c_leftfoot",
			},
		},
		{
			name = hit_zone_names.upper_right_leg,
			actors = {
				"c_rightupleg",
			},
		},
		{
			name = hit_zone_names.lower_right_leg,
			actors = {
				"c_rightleg",
				"c_rightfoot",
			},
		},
		{
			name = hit_zone_names.afro,
			actors = {
				"r_afro",
			},
		},
		{
			name = hit_zone_names.center_mass,
			actors = {
				"c_hips",
				"c_spine",
				"c_spine1",
			},
		},
	},
	hit_reaction_keys = {
		catapulting_template = "catapulting_template",
		disorientation_type = "disorientation_type",
		force_look_function = "force_look_function",
		ignore_stun_immunity = "ignore_stun_immunity",
		interrupt_alternate_fire = "interrupt_alternate_fire",
		push_template = "push_template",
		toughness_disorientation_type = "toughness_disorientation_type",
	},
	hit_reaction_stun_types = {
		fumbled = "fumbled",
		toughness_absorbed_default = "toughness",
		toughness_absorbed_melee = "toughness_melee",
		toughness_absorbed_ranged_sprinting = "ranged_sprinting",
		toughness_broken_default = "medium",
		toughness_broken_ranged = "ranged",
		toughness_broken_ranged_sprinting = "ranged_sprinting",
		toughness_burning = "toughness_burning",
	},
	ledge_finder_tweak_data = {
		player_height = 1.21,
		player_width = 0.5,
		significant_obstacle_distance = 1.31,
	},
	ledge_vault_tweak_values = {
		allowed_flat_distance_to_ledge = 1.5,
		allowed_height_distance_max = 1.3,
		allowed_height_distance_min = 0.31,
		inair_allowed_height_distance_max = 0.65,
		inair_allowed_height_distance_min = 0.31,
	},
	spawn_buffs = {
		"grimoire_damage_tick",
		"sprint_with_stamina_buff",
	},
	blackboard_component_config = BotSettings.blackboard_component_config,
	base_unit_sound_sources = {
		fx_anim_01 = "fx_anim_01",
		fx_left_elbow = "fx_left_elbow",
		fx_left_finger_tip_index = "fx_left_finger_tip_index",
		fx_left_finger_tip_middle = "fx_left_finger_tip_middle",
		fx_left_finger_tip_pinky = "fx_left_finger_tip_pinky",
		fx_left_finger_tip_ring = "fx_left_finger_tip_ring",
		fx_left_finger_tip_thumb = "fx_left_finger_tip_thumb",
		fx_left_forearm = "fx_left_forearm",
		fx_left_hand = "fx_left_hand",
		fx_left_hand_offset_fwd = "fx_left_hand_offset_fwd",
		fx_right_elbow = "fx_right_elbow",
		fx_right_finger_tip_index = "fx_right_finger_tip_index",
		fx_right_finger_tip_middle = "fx_right_finger_tip_middle",
		fx_right_finger_tip_pinky = "fx_right_finger_tip_pinky",
		fx_right_finger_tip_ring = "fx_right_finger_tip_ring",
		fx_right_finger_tip_thumb = "fx_right_finger_tip_thumb",
		fx_right_hand = "fx_right_hand",
		fx_right_hand_offset_fwd = "fx_right_hand_offset_fwd",
		head = "j_head",
		hips = "j_hips",
		left_foot = "j_leftfoot",
		right_foot = "j_rightfoot",
	},
	base_unit_fx_sources = {
		fx_anim_01 = "fx_anim_01",
		fx_left_elbow = "fx_left_elbow",
		fx_left_finger_tip_index = "fx_left_finger_tip_index",
		fx_left_finger_tip_middle = "fx_left_finger_tip_middle",
		fx_left_finger_tip_pinky = "fx_left_finger_tip_pinky",
		fx_left_finger_tip_ring = "fx_left_finger_tip_ring",
		fx_left_finger_tip_thumb = "fx_left_finger_tip_thumb",
		fx_left_forearm = "fx_left_forearm",
		fx_left_hand = "fx_left_hand",
		fx_left_hand_offset_fwd = "fx_left_hand_offset_fwd",
		fx_right_elbow = "fx_right_elbow",
		fx_right_finger_tip_index = "fx_right_finger_tip_index",
		fx_right_finger_tip_middle = "fx_right_finger_tip_middle",
		fx_right_finger_tip_pinky = "fx_right_finger_tip_pinky",
		fx_right_finger_tip_ring = "fx_right_finger_tip_ring",
		fx_right_finger_tip_thumb = "fx_right_finger_tip_thumb",
		fx_right_hand = "fx_right_hand",
		fx_right_hand_offset_fwd = "fx_right_hand_offset_fwd",
		head = "j_head",
		hips = "j_hips",
		left_foot = "j_leftfoot",
		right_foot = "j_rightfoot",
	},
	sfx = {
		footstep = "player_footstep",
		footstep_dodge = "player_footstep_dodge",
		footstep_jump = "player_footstep_jump",
		footstep_land = "player_footstep_land",
		sliding_alias = "player_slide_loop",
	},
	vfx = {
		footstep = "player_footstep",
		footstep_dodge = "player_footstep_dodge",
		footstep_jump = "player_footstep_jump",
		footstep_land = "player_footstep_land",
		sliding_alias = "player_slide_loop",
	},
}

return breed_data
