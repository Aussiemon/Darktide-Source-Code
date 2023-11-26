-- chunkname: @scripts/settings/training_grounds/training_grounds_objectives_lookup.lua

local objectives_lookup = {
	tag_sniper = {
		max_value = 1,
		name = "loc_tagging_objective_1",
		play_sound = true,
		objective_id = "tag_sniper"
	},
	tag_world = {
		max_value = 1,
		name = "loc_tagging_objective_2",
		objective_id = "tag_world"
	},
	dodge_melee = {
		max_value = 3,
		name = "loc_dodging_objective_4",
		play_sound = true,
		objective_id = "dodge_melee"
	},
	dodge_left = {
		max_value = 1,
		name = "loc_dodging_objective_1",
		play_sound = true,
		objective_id = "dodge_left"
	},
	dodge_backward = {
		max_value = 1,
		name = "loc_dodging_objective_2",
		objective_id = "dodge_backward"
	},
	dodge_right = {
		max_value = 1,
		name = "loc_dodging_objective_3",
		objective_id = "dodge_right"
	},
	slide = {
		max_value = 2,
		name = "loc_sprint_slide_objective_1",
		play_sound = true,
		objective_id = "slide"
	},
	sprint = {
		max_value = 1,
		name = "loc_sprint_slide_objective_2",
		play_sound = true,
		objective_id = "sprint"
	},
	lock_in_melee = {
		max_value = 2,
		name = "loc_lock_in_melee_objective",
		play_sound = true,
		objective_id = "lock_in_melee"
	},
	lock_in_melee_2 = {
		max_value = 2,
		name = "loc_lock_in_melee_objective_2",
		objective_id = "lock_in_melee_2"
	},
	toughness_pre_1 = {
		max_value = 1,
		name = "loc_tg_toughness_damage_objective_1",
		play_sound = true,
		objective_id = "toughness_pre_1"
	},
	toughness_pre_2 = {
		max_value = 1,
		name = "loc_tg_toughness_damage_objective_2",
		play_sound = true,
		objective_id = "toughness_pre_2"
	},
	toughness_pre_3 = {
		max_value = 1,
		name = "loc_tg_toughness_damage_objective_3",
		play_sound = true,
		objective_id = "toughness_pre_3"
	},
	toughness_melee = {
		max_value = 2,
		name = "loc_toughness_objective_1",
		play_sound = true,
		objective_id = "toughness_melee"
	},
	toughness_coherency = {
		max_value = 1,
		name = "loc_toughness_objective_2",
		objective_id = "toughness_coherency"
	},
	combat_ability = {
		max_value = 2,
		name = "loc_combat_ability_objective",
		play_sound = true,
		objective_id = "combat_ability"
	},
	combat_ability_ogryn_1 = {
		max_value = 5,
		name = "loc_ability_ogryn_objective_1",
		play_sound = true,
		objective_id = "combat_ability_ogryn_1"
	},
	combat_ability_ogryn_2 = {
		max_value = 1,
		name = "loc_ability_ogryn_objective_2",
		objective_id = "combat_ability_ogryn_2"
	},
	combat_ability_psyker_1 = {
		max_value = 1,
		name = "loc_ability_psyker_objective_1",
		objective_id = "combat_ability_psyker_1"
	},
	combat_ability_psyker_2 = {
		max_value = 1,
		name = "loc_ability_psyker_objective_2",
		play_sound = true,
		objective_id = "combat_ability_psyker_2"
	},
	combat_ability_psyker_3 = {
		max_value = 5,
		name = "loc_ability_psyker_objective_3",
		objective_id = "combat_ability_psyker_3"
	},
	combat_ability_zealot_1 = {
		max_value = 2,
		name = "loc_ability_zealot_objective_1",
		play_sound = true,
		objective_id = "combat_ability_zealot_1"
	},
	combat_ability_zealot_2 = {
		max_value = 2,
		name = "loc_ability_zealot_objective_2",
		objective_id = "combat_ability_zealot_2"
	},
	combat_ability_psyker_3_1 = {
		max_value = 1,
		name = "loc_combat_ability_tutorial_psyker_3_objective_1",
		play_sound = true,
		objective_id = "combat_ability_psyker_3_1"
	},
	combat_ability_psyker_3_2 = {
		max_value = 1,
		name = "loc_combat_ability_tutorial_psyker_3_objective_2",
		objective_id = "combat_ability_psyker_3_2"
	},
	combat_ability_ogryn_1_1 = {
		max_value = 1,
		name = "loc_combat_ability_tutorial_ogryn_1_objective_1",
		play_sound = true,
		objective_id = "combat_ability_ogryn_1_1"
	},
	combat_ability_ogryn_1_2 = {
		max_value = 1,
		name = "loc_combat_ability_tutorial_ogryn_1_objective_2",
		objective_id = "combat_ability_ogryn_1_2"
	},
	combat_ability_zealot_3_1 = {
		max_value = 1,
		name = "loc_combat_ability_tutorial_zealot_3_objective_1",
		play_sound = true,
		objective_id = "combat_ability_zealot_3_1"
	},
	combat_ability_zealot_3_2 = {
		max_value = 1,
		name = "loc_combat_ability_tutorial_zealot_3_objective_2",
		play_sound = true,
		objective_id = "combat_ability_zealot_3_2"
	},
	combat_ability_veteran_3_1 = {
		max_value = 1,
		name = "loc_combat_ability_tutorial_veteran_3_objective_1",
		play_sound = true,
		objective_id = "combat_ability_veteran_3_1"
	},
	attack_chain = {
		max_value = 3,
		name = "loc_melee_chain_objective",
		play_sound = true,
		objective_id = "attack_chain"
	},
	attack_chain_2 = {
		max_value = 2,
		name = "loc_melee_chain_objective_heavy",
		objective_id = "attack_chain_2"
	},
	weapon_special = {
		max_value = 3,
		name = "loc_weapon_special_objective",
		play_sound = true,
		objective_id = "weapon_special"
	},
	armor_objective_1 = {
		max_value = 1,
		name = "loc_armor_objective_1",
		play_sound = true,
		objective_id = "armor_objective_1"
	},
	armor_objective_2 = {
		max_value = 3,
		name = "loc_armor_objective_2",
		objective_id = "armor_objective_2"
	},
	stagger_objective_1 = {
		max_value = 3,
		name = "loc_stagger_objective_1",
		play_sound = true,
		objective_id = "stagger_objective_1"
	},
	stagger_objective_2 = {
		max_value = 3,
		name = "loc_stagger_objective_2",
		objective_id = "stagger_objective_2"
	},
	push = {
		max_value = 5,
		name = "loc_push_objective",
		play_sound = true,
		objective_id = "push"
	},
	push_follow = {
		max_value = 3,
		name = "loc_push_follow_objective",
		play_sound = true,
		objective_id = "push_follow"
	},
	basic_ranged_objective_1 = {
		max_value = 3,
		name = "loc_basic_ranged_objective_1",
		play_sound = true,
		objective_id = "basic_ranged_objective_1"
	},
	basic_ranged_objective_2 = {
		max_value = 2,
		name = "loc_basic_ranged_objective_2",
		objective_id = "basic_ranged_objective_2"
	},
	basic_ranged_objective_3 = {
		max_value = 1,
		name = "loc_basic_ranged_objective_3",
		objective_id = "basic_ranged_objective_3"
	},
	ranged_warp_charge_objective_1 = {
		max_value = 3,
		name = "loc_ranged_warp_charge_objective_1",
		play_sound = true,
		objective_id = "ranged_warp_charge_objective_1"
	},
	ranged_warp_charge_objective_2 = {
		max_value = 2,
		name = "loc_ranged_warp_charge_objective_2",
		objective_id = "ranged_warp_charge_objective_2"
	},
	ranged_warp_charge_objective_3 = {
		max_value = 20,
		name = "loc_ranged_warp_charge_objective_3",
		objective_id = "ranged_warp_charge_objective_3"
	},
	suppression_objective_1 = {
		max_value = 5,
		name = "loc_suppression_objective_1",
		play_sound = true,
		objective_id = "suppression_objective_1"
	},
	suppression_objective_2 = {
		max_value = 1,
		name = "loc_suppression_objective_2",
		objective_id = "suppression_objective_2"
	},
	incoming_suppression_objective_0 = {
		max_value = 1,
		name = "loc_incoming_suppression_objective_0",
		play_sound = true,
		objective_id = "incoming_suppression_objective_0"
	},
	incoming_suppression_objective_1 = {
		max_value = 10,
		name = "loc_incoming_suppression_objective_1",
		play_sound = true,
		objective_id = "incoming_suppression_objective_1"
	},
	incoming_suppression_objective_2 = {
		max_value = 1,
		name = "loc_incoming_suppression_objective_2",
		objective_id = "incoming_suppression_objective_2"
	},
	incoming_suppression_objective_3 = {
		max_value = 1,
		name = "loc_incoming_suppression_objective_3",
		objective_id = "incoming_suppression_objective_3"
	},
	bonebreaker_blitz = {
		max_value = 1,
		name = "loc_incoming_suppression_objective_3",
		play_sound = true,
		objective_id = "bonebreaker_blitz"
	},
	maniac_blitz = {
		max_value = 5,
		name = "loc_grenade_objective_shock",
		play_sound = true,
		objective_id = "maniac_blitz"
	},
	grenade = {
		max_value = 5,
		name = "loc_grenade_objective",
		play_sound = true,
		objective_id = "grenade"
	},
	protectorate_blitz = {
		max_value = 5,
		name = "loc_psyker_ability_objective_protectorate",
		play_sound = true,
		objective_id = "protectorate_blitz"
	},
	biomancer_blitz = {
		max_value = 3,
		name = "loc_psyker_ability_objective",
		play_sound = true,
		objective_id = "biomancer_blitz"
	},
	healing_objective_1 = {
		max_value = 1,
		name = "loc_healing_objective_1",
		play_sound = true,
		objective_id = "healing_objective_1"
	},
	healing_objective_2 = {
		max_value = 1,
		name = "loc_healing_objective_2",
		objective_id = "healing_objective_2"
	},
	healing_objective_3 = {
		max_value = 1,
		name = "loc_healing_objective_3",
		objective_id = "healing_objective_3"
	},
	healing_objective_4 = {
		max_value = 1,
		name = "loc_healing_objective_4",
		objective_id = "healing_objective_4"
	},
	reviving = {
		max_value = 1,
		name = "loc_reviving_objective",
		play_sound = true,
		objective_id = "reviving"
	},
	corruption = {
		max_value = 1,
		name = "loc_corruption_objective",
		play_sound = true,
		objective_id = "corruption"
	},
	health_station_objective_1 = {
		max_value = 1,
		name = "loc_health_staton_objective_1",
		play_sound = true,
		objective_id = "health_station_objective_1"
	},
	health_station_objective_2 = {
		max_value = 1,
		name = "loc_health_staton_objective_2",
		objective_id = "health_station_objective_2"
	},
	end_of_tg_objective = {
		max_value = 1,
		name = "loc_objective_tg_basic_combat_end_header",
		objective_id = "end_of_tg"
	}
}

return objectives_lookup
