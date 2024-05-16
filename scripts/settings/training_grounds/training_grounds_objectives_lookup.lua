﻿-- chunkname: @scripts/settings/training_grounds/training_grounds_objectives_lookup.lua

local objectives_lookup = {
	tag_sniper = {
		max_value = 1,
		name = "loc_tagging_objective_1",
		objective_id = "tag_sniper",
		play_sound = true,
	},
	tag_world = {
		max_value = 1,
		name = "loc_tagging_objective_2",
		objective_id = "tag_world",
	},
	dodge_melee = {
		max_value = 3,
		name = "loc_dodging_objective_4",
		objective_id = "dodge_melee",
		play_sound = true,
	},
	dodge_left = {
		max_value = 1,
		name = "loc_dodging_objective_1",
		objective_id = "dodge_left",
		play_sound = true,
	},
	dodge_backward = {
		max_value = 1,
		name = "loc_dodging_objective_2",
		objective_id = "dodge_backward",
	},
	dodge_right = {
		max_value = 1,
		name = "loc_dodging_objective_3",
		objective_id = "dodge_right",
	},
	slide = {
		max_value = 2,
		name = "loc_sprint_slide_objective_1",
		objective_id = "slide",
		play_sound = true,
	},
	sprint = {
		max_value = 1,
		name = "loc_sprint_slide_objective_2",
		objective_id = "sprint",
		play_sound = true,
	},
	lock_in_melee = {
		max_value = 2,
		name = "loc_lock_in_melee_objective",
		objective_id = "lock_in_melee",
		play_sound = true,
	},
	lock_in_melee_2 = {
		max_value = 2,
		name = "loc_lock_in_melee_objective_2",
		objective_id = "lock_in_melee_2",
	},
	toughness_pre_1 = {
		max_value = 1,
		name = "loc_tg_toughness_damage_objective_1",
		objective_id = "toughness_pre_1",
		play_sound = true,
	},
	toughness_pre_2 = {
		max_value = 1,
		name = "loc_tg_toughness_damage_objective_2",
		objective_id = "toughness_pre_2",
		play_sound = true,
	},
	toughness_pre_3 = {
		max_value = 1,
		name = "loc_tg_toughness_damage_objective_3",
		objective_id = "toughness_pre_3",
		play_sound = true,
	},
	toughness_melee = {
		max_value = 2,
		name = "loc_toughness_objective_1",
		objective_id = "toughness_melee",
		play_sound = true,
	},
	toughness_coherency = {
		max_value = 1,
		name = "loc_toughness_objective_2",
		objective_id = "toughness_coherency",
	},
	combat_ability = {
		max_value = 2,
		name = "loc_combat_ability_objective",
		objective_id = "combat_ability",
		play_sound = true,
	},
	combat_ability_ogryn_1 = {
		max_value = 5,
		name = "loc_ability_ogryn_objective_1",
		objective_id = "combat_ability_ogryn_1",
		play_sound = true,
	},
	combat_ability_ogryn_2 = {
		max_value = 1,
		name = "loc_ability_ogryn_objective_2",
		objective_id = "combat_ability_ogryn_2",
	},
	combat_ability_psyker_1 = {
		max_value = 1,
		name = "loc_ability_psyker_objective_1",
		objective_id = "combat_ability_psyker_1",
	},
	combat_ability_psyker_2 = {
		max_value = 1,
		name = "loc_ability_psyker_objective_2",
		objective_id = "combat_ability_psyker_2",
		play_sound = true,
	},
	combat_ability_psyker_3 = {
		max_value = 5,
		name = "loc_ability_psyker_objective_3",
		objective_id = "combat_ability_psyker_3",
	},
	combat_ability_zealot_1 = {
		max_value = 2,
		name = "loc_ability_zealot_objective_1",
		objective_id = "combat_ability_zealot_1",
		play_sound = true,
	},
	combat_ability_zealot_2 = {
		max_value = 2,
		name = "loc_ability_zealot_objective_2",
		objective_id = "combat_ability_zealot_2",
	},
	combat_ability_zealot_3_2 = {
		max_value = 1,
		name = "loc_combat_ability_tutorial_zealot_3_objective_2",
		objective_id = "combat_ability_zealot_3_2",
		play_sound = true,
	},
	attack_chain = {
		max_value = 3,
		name = "loc_melee_chain_objective",
		objective_id = "attack_chain",
		play_sound = true,
	},
	attack_chain_2 = {
		max_value = 2,
		name = "loc_melee_chain_objective_heavy",
		objective_id = "attack_chain_2",
	},
	weapon_special = {
		max_value = 3,
		name = "loc_weapon_special_objective",
		objective_id = "weapon_special",
		play_sound = true,
	},
	armor_objective_1 = {
		max_value = 1,
		name = "loc_armor_objective_1",
		objective_id = "armor_objective_1",
		play_sound = true,
	},
	armor_objective_2 = {
		max_value = 3,
		name = "loc_armor_objective_2",
		objective_id = "armor_objective_2",
	},
	stagger_objective_1 = {
		max_value = 3,
		name = "loc_stagger_objective_1",
		objective_id = "stagger_objective_1",
		play_sound = true,
	},
	stagger_objective_2 = {
		max_value = 3,
		name = "loc_stagger_objective_2",
		objective_id = "stagger_objective_2",
	},
	push = {
		max_value = 5,
		name = "loc_push_objective",
		objective_id = "push",
		play_sound = true,
	},
	push_follow = {
		max_value = 3,
		name = "loc_push_follow_objective",
		objective_id = "push_follow",
		play_sound = true,
	},
	suppression_objective_1 = {
		max_value = 5,
		name = "loc_suppression_objective_1",
		objective_id = "suppression_objective_1",
		play_sound = true,
	},
	suppression_objective_2 = {
		max_value = 1,
		name = "loc_suppression_objective_2",
		objective_id = "suppression_objective_2",
	},
	incoming_suppression_objective_0 = {
		max_value = 1,
		name = "loc_incoming_suppression_objective_0",
		objective_id = "incoming_suppression_objective_0",
		play_sound = true,
	},
	incoming_suppression_objective_1 = {
		max_value = 10,
		name = "loc_incoming_suppression_objective_1",
		objective_id = "incoming_suppression_objective_1",
		play_sound = true,
	},
	incoming_suppression_objective_2 = {
		max_value = 1,
		name = "loc_incoming_suppression_objective_2",
		objective_id = "incoming_suppression_objective_2",
	},
	incoming_suppression_objective_3 = {
		max_value = 1,
		name = "loc_incoming_suppression_objective_3",
		objective_id = "incoming_suppression_objective_3",
	},
	bonebreaker_blitz = {
		max_value = 1,
		name = "loc_incoming_suppression_objective_3",
		objective_id = "bonebreaker_blitz",
		play_sound = true,
	},
	maniac_blitz = {
		max_value = 5,
		name = "loc_grenade_objective_shock",
		objective_id = "maniac_blitz",
		play_sound = true,
	},
	grenade = {
		max_value = 5,
		name = "loc_grenade_objective",
		objective_id = "grenade",
		play_sound = true,
	},
	biomancer_blitz = {
		max_value = 3,
		name = "loc_psyker_ability_objective",
		objective_id = "biomancer_blitz",
		play_sound = true,
	},
	healing_objective_1 = {
		max_value = 1,
		name = "loc_healing_objective_1",
		objective_id = "healing_objective_1",
		play_sound = true,
	},
	healing_objective_2 = {
		max_value = 1,
		name = "loc_healing_objective_2",
		objective_id = "healing_objective_2",
	},
	healing_objective_3 = {
		max_value = 1,
		name = "loc_healing_objective_3",
		objective_id = "healing_objective_3",
	},
	healing_objective_4 = {
		max_value = 1,
		name = "loc_healing_objective_4",
		objective_id = "healing_objective_4",
	},
	reviving = {
		max_value = 1,
		name = "loc_reviving_objective",
		objective_id = "reviving",
		play_sound = true,
	},
	corruption = {
		max_value = 1,
		name = "loc_corruption_objective",
		objective_id = "corruption",
		play_sound = true,
	},
	health_station_objective_1 = {
		max_value = 1,
		name = "loc_health_staton_objective_1",
		objective_id = "health_station_objective_1",
		play_sound = true,
	},
	health_station_objective_2 = {
		max_value = 1,
		name = "loc_health_staton_objective_2",
		objective_id = "health_station_objective_2",
	},
	end_of_tg_objective = {
		max_value = 1,
		name = "loc_objective_tg_basic_combat_end_header",
		objective_id = "end_of_tg",
	},
}

return objectives_lookup
