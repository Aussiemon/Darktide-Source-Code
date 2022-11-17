local dialogue_lookup_context_names = {
	all_context_names = table.enum("ability_name", "active_hordes", "attack_hit", "attack_name", "attack_tag", "attacked_class", "attacking_class", "breed_name", "category", "circumstance_name", "circumstance_vo_id", "class", "class_name", "conversation", "current_amount", "current_mission", "dialogue_name", "died_class", "distance", "enemies_close", "enemies_distant", "enemy_tag", "expression_type", "fail_reason", "friends_close", "friends_distant", "health", "hit_zone", "horde_type", "interactee_class", "interactor_class", "interactor_voice_profile", "is_circumstance", "is_decaying_tension", "is_hogtied", "is_knocked_down", "is_ledge_hanging", "is_local_player", "is_player", "is_pounced_down", "item", "item_tag", "killed_type", "killer_class", "level_time", "look_at_tag", "mission", "number_of_kills", "objective_type", "pacing_state", "player_class", "player_level", "player_level_string", "player_profile", "player_voice_profiles", "reviving_vo_source", "sequence_no", "sound_event", "source_name", "speaker_class", "speaker_name", "stance_type", "starter_line", "story_name", "story_type", "target_name", "team_lowest_player_level", "team_threat_level", "threat_level", "total_ammo_percentage", "trigger_id", "trigger_type", "vo_event", "vo_line_id", "voice_template", "weapon_slot"),
	ability_name = table.enum("ability_banisher", "ability_banisher_impact", "ability_biomancer_high", "ability_biomancer_low", "ability_bonebreaker", "ability_bullgryn", "ability_gun_lugger", "ability_gunslinger", "ability_maniac", "ability_pious_stabber", "ability_protectorate_start", "ability_protectorate_stop", "ability_ranger", "ability_shock_trooper", "ability_squad_leader", "ability_venting"),
	attacked_class = table.enum("ogryn", "psyker", "veteran", "zealot"),
	attacking_class = table.enum("ogryn", "psyker", "veteran", "zealot"),
	breed_name = table.enum("human", "ogryn"),
	circumstance_name = table.enum("default"),
	circumstance_vo_id = table.enum("default", "thischeckisdisabled"),
	class = table.enum("ogryn", "psyker", "veteran", "zealot"),
	class_name = table.enum("mourningstar_servitor", "ogryn", "ogryn, psyker, veteran, zealot", "psyker", "psyker, veteran, zealot", "veteran", "zealot"),
	current_mission = table.enum("cm_archives", "cm_habs", "dm_forge", "dm_propaganda", "dm_stockpile", "fm_cargo", "fm_resurgence", "hm_cartel", "hm_complex", "hm_strain", "km_enforcer", "km_station", "lm_cooling", "lm_rails", "lm_scavenge", "prologue"),
	dialogue_name = table.enum("critical_health", "debug_player_vo_conversational", "reload_failed_out_of_ammo", "response_for_critical_health"),
	died_class = table.enum("ogryn", "psyker", "veteran", "zealot"),
	enemy_tag = table.enum("aggroed", "chaos_beast_of_nurgle", "chaos_daemonhost", "chaos_hound", "chaos_mutant_charger", "chaos_ogryn_bulwark", "chaos_ogryn_executor", "chaos_ogryn_gunner", "chaos_plague_ogryn", "chaos_poxwalker_bomber", "cultist_berzerker", "cultist_flamer", "cultist_grenadier", "cultist_gunner", "cultist_holy_stubber_gunner", "cultist_mutant", "cultist_shocktrooper", "monster", "renegade_berzerker", "renegade_executor", "renegade_flamer", "renegade_grenadier", "renegade_gunner", "renegade_netgunner", "renegade_shocktrooper", "renegade_sniper", "seen_netgunner_flee"),
	expression_type = table.enum("expression_affirmative", "expression_anger", "expression_awe", "expression_disgust", "expression_joy", "expression_negative", "expression_rage", "expression_relief", "expression_scoff"),
	fail_reason = table.enum("out_of_ammo"),
	hit_zone = table.enum("head", "left_arm", "left_leg", "neck", "right_arm", "right_leg", "slashing_front", "tail", "torso"),
	horde_type = table.enum("ambush", "static", "vector"),
	interactee_class = table.enum("ogryn", "ogryn, psyker, veteran, zealot", "psyker", "veteran", "zealot"),
	interactor_class = table.enum("ogryn", "ogryn, psyker, veteran, zealot", "psyker", "veteran", "zealot"),
	is_hogtied = table.enum("true"),
	is_local_player = table.enum("false", "true"),
	is_player = table.enum("false", "true"),
	item_tag = table.enum("ammo", "bomb", "generic_dead_end", "generic_spotting_dead_body", "health", "healthstation", "potion", "pup_ammo", "pup_battery", "pup_collectible_a", "pup_collectible_b", "pup_container", "pup_control_rod", "pup_deployed_ammo_crate", "pup_deployed_medical_crate", "pup_forge_metal", "pup_grenade", "pup_health_booster", "pup_health_kit", "pup_medical_crate", "pup_melta_bomb", "pup_platinum", "pup_side_mission_consumable", "pup_side_mission_grimoire", "pup_side_mission_tome", "pup_small_grenade", "pup_syringe", "pup_wound_recovery", "station_health", "station_revive", "this_way", "this_way_bridge", "this_way_correct_path_across", "this_way_correct_path_alley", "this_way_correct_path_ladder_down", "this_way_correct_path_ladder_up", "this_way_door", "this_way_down", "this_way_stairs_down", "this_way_stairs_up", "this_way_street", "this_way_up"),
	killed_type = table.enum("chaos_daemonhost", "chaos_hound", "chaos_poxwalker_bomber", "cultist_berzerker", "cultist_flamer", "cultist_mutant", "monster", "renegade_berzerker", "renegade_flamer", "renegade_grenadier", "renegade_netgunner"),
	killer_class = table.enum("ogryn", "psyker", "veteran", "zealot"),
	look_at_tag = table.enum("access_elevator", "almost_there", "ammo", "asset_acid_clouds", "asset_acid_clouds_mission_cartel", "asset_cartel_insignia", "asset_foul_smoke", "asset_goo", "asset_grease_pit", "asset_pneumatic_press", "asset_sigil", "asset_unnatural_dark_a", "asset_water_course", "bomb", "chargeable_health_station", "charged_health_station", "cmd_mission_scavenge_entering_ship_port", "debug_mission_strain_keep_following_pipes", "disabled_health_station", "generic_dead_end", "generic_spotting_dead_body", "grenade", "guidance_correct_doorway", "guidance_correct_path", "guidance_correct_path_1", "guidance_correct_path_10", "guidance_correct_path_2", "guidance_correct_path_3", "guidance_correct_path_4", "guidance_correct_path_5", "guidance_correct_path_6", "guidance_correct_path_7", "guidance_correct_path_8", "guidance_correct_path_9", "guidance_correct_path_across", "guidance_correct_path_alley", "guidance_correct_path_drop", "guidance_correct_path_drop_1", "guidance_correct_path_drop_10", "guidance_correct_path_drop_2", "guidance_correct_path_drop_3", "guidance_correct_path_drop_4", "guidance_correct_path_drop_5", "guidance_correct_path_drop_6", "guidance_correct_path_drop_7", "guidance_correct_path_drop_8", "guidance_correct_path_drop_9", "guidance_correct_path_ladder_down", "guidance_correct_path_ladder_up", "guidance_correct_path_stairs_down", "guidance_correct_path_stairs_up", "guidance_correct_path_up", "guidance_ladder_sighted", "guidance_stairs_sighted", "guidance_stairs_sighted_1", "guidance_stairs_sighted_10", "guidance_stairs_sighted_2", "guidance_stairs_sighted_3", "guidance_stairs_sighted_4", "guidance_stairs_sighted_5", "guidance_stairs_sighted_6", "guidance_stairs_sighted_7", "guidance_stairs_sighted_8", "guidance_stairs_sighted_9", "guidance_switch", "hab_block_apartment", "health", "healthstation", "info_asset_cult_breaking_wheel", "info_asset_nurgle_growth", "info_call_abyss", "info_graffiti_one", "info_mission_scavenge_hangar_guidance_one", "info_mission_scavenge_hangar_guidance_two", "level_hab_block_atrium", "level_hab_block_b", "level_hab_block_corpse", "level_hab_block_market", "level_hab_block_roof", "level_hab_block_security", "level_hab_block_vista", "mission_cargo_armor_plating", "mission_cargo_hab_feed_lines", "mission_cargo_labyrinth", "mission_cargo_something_big", "mission_cartel_pillar", "mission_cartel_reach_bazaar", "mission_cartel_sewer", "mission_complex_way_in", "mission_cooling_long_way_down", "mission_cooling_overseer_office", "mission_cooling_worker_habitation", "mission_deception", "mission_enforcer_courtroom", "mission_enforcer_enforcer_station", "mission_enforcer_hab_support", "mission_enforcer_traders_row", "mission_forge_labour_oversight", "mission_forge_propaganda", "mission_forge_superstructure", "mission_propaganda_cultist_town", "mission_propaganda_infested_elevator", "mission_rails_district_gate", "mission_rails_hab_block_dreyko", "mission_rails_refectory", "mission_rails_station_approach", "mission_resurgence_pulpit_a", "mission_resurgence_statue_baross", "mission_scavenge_interior", "mission_scavenge_underhalls", "mission_station_approach", "mission_station_contrabrand_lockers", "mission_station_cross_station", "mission_station_interrogation_bay_a", "mission_station_station_hall", "mission_station_the_bridge", "mission_stockpile_cartel_habs", "mission_stockpile_holo_statue", "mission_stockpile_main_access", "mission_stockpile_ruined_hab", "mission_strain_atmosphere_shield", "mission_strain_elevator_found", "mission_strain_inert_tanks", "mission_strain_keep_following_pipes", "nurgle_circumstance_prop_alive", "nurgle_circumstance_prop_growth", "nurgle_circumstance_prop_shrine", "potion", "soldiers", "special_item", "this_way", "this_way_bridge", "this_way_correct_path_across", "this_way_correct_path_alley", "this_way_correct_path_ladder_down", "this_way_correct_path_ladder_up", "this_way_door", "this_way_down", "this_way_stairs_down", "this_way_stairs_up", "this_way_street", "this_way_up"),
	objective_type = table.enum("obj_mission_control", "obj_mission_delivery_generic", "obj_mission_delivery_place", "obj_mission_delivery_take", "obj_mission_demolition", "obj_mission_fortification", "obj_mission_hacking", "obj_mission_kill"),
	pacing_state = table.enum("sustain_tension_peak, build_up_tension_no_trickle, build_up_tension", "tension_peak_fade, relax", "tension_peak_fade, relax, build_up_tension_low, build_up_tension_no_trickle"),
	player_class = table.enum("ogryn", "psyker", "veteran", "zealot"),
	player_profile = table.enum("armor_hit", "bright_wizard", "enemy_chaos_ogryn_armoured_executor_a", "enemy_chaos_ogryn_bulwark_a", "enemy_chaos_ogryn_heavy_gunner_a", "enemy_grenadier", "enemy_nemesis_wolfer_a", "enemy_traitor_enforcer_executor", "enemy_traitor_guard_rifleman", "enemy_traitor_gunner", "enemy_traitor_netgunner", "enemy_traitor_scout_shocktrooper", "enemy_traitor_shotgun_rusher", "enemy_traitor_trenchfighter", "explicator", "ogryn", "pilot", "psyker", "psyker_female", "psyker_male", "sergeant", "tech_priest", "use_shield", "veteran", "veteran_female", "veteran_male", "zealot", "zealot_female", "zealot_male"),
	reviving_vo_source = table.enum("enemy_chaos_ogryn_armoured_executor_a", "enemy_chaos_ogryn_bulwark_a", "enemy_chaos_ogryn_heavy_gunner_a", "enemy_grenadier", "enemy_nemesis_wolfer_a", "enemy_traitor_enforcer_executor", "enemy_traitor_guard_rifleman", "enemy_traitor_gunner", "enemy_traitor_netgunner", "enemy_traitor_scout_shocktrooper", "enemy_traitor_shotgun_rusher", "enemy_traitor_trenchfighter", "explicator", "ogryn", "pilot", "psyker_female", "psyker_male", "sergeant", "tech_priest", "veteran_female", "veteran_male", "zealot_female", "zealot_male"),
	source_name = table.enum("bright_wizard", "enemy_chaos_ogryn_armoured_executor_a", "enemy_chaos_ogryn_bulwark_a", "enemy_chaos_ogryn_heavy_gunner_a", "enemy_grenadier", "enemy_nemesis_wolfer_a", "enemy_traitor_enforcer_executor", "enemy_traitor_guard_rifleman", "enemy_traitor_gunner", "enemy_traitor_netgunner", "enemy_traitor_scout_shocktrooper", "enemy_traitor_shotgun_rusher", "enemy_traitor_trenchfighter", "explicator", "ogryn", "pilot", "psyker", "psyker_female", "psyker_male", "sergeant", "tech_priest", "veteran", "veteran_female", "veteran_male", "zealot", "zealot_female", "zealot_male"),
	speaker_class = table.enum("ogryn", "psyker", "veteran", "zealot"),
	speaker_name = table.enum("ogryn", "psyker", "veteran", "zealot"),
	stance_type = table.enum("defensive", "offensive"),
	target_name = table.enum("bright_wizard", "enemy_chaos_ogryn_armoured_executor_a", "enemy_chaos_ogryn_bulwark_a", "enemy_chaos_ogryn_heavy_gunner_a", "enemy_grenadier", "enemy_nemesis_wolfer_a", "enemy_traitor_enforcer_executor", "enemy_traitor_guard_rifleman", "enemy_traitor_gunner", "enemy_traitor_netgunner", "enemy_traitor_scout_shocktrooper", "enemy_traitor_shotgun_rusher", "enemy_traitor_trenchfighter", "explicator", "ogryn", "pilot", "psyker", "psyker_female", "psyker_male", "sergeant", "tech_priest", "veteran", "veteran_female", "veteran_male", "zealot", "zealot_female", "zealot_male"),
	threat_level = table.enum("high", "low", "low, medium", "low, medium, high", "medium", "medium, high"),
	trigger_id = table.enum("answer_following", "answer_need", "answer_no", "answer_yes", "archived", "com_cheer", "com_need_ammo", "com_need_health", "com_thank_you", "debug_vo", "exploding_barrel", "location_enemy_there", "location_over_here", "location_this_way", "start_rescue", "start_revive"),
	trigger_type = table.enum("decreasing", "losing_rapidly"),
	vo_event = table.enum("aggroed", "alerted", "combo_attack", "sniper_aiming"),
	vo_line_id = table.enum("cs_pot01_01", "cs_pot01_02", "cs_pot01_03", "cs_pot01_04", "cs_pot02_01", "cs_pot02_02", "cs_pot02_03", "cs_pot02_04", "cs_pot02_05", "cs_pot03_01", "cs_pot03_02", "cs_pot03_03", "cs_pot03_04", "cs_pot03_05", "cs_pot04_01", "cs_pot04_02", "cs_pot04_03", "cs_pot04_04", "cs_pot04_05", "cs_pot05_01", "cs_pot05_02", "cs_pot05_03", "cs_pot05_04", "cs_pot05_05", "cs_pot05_06", "cs_pot05_07", "cs_pot06_01", "cs_pot06_02", "cs_pot06_03", "cs_pot06_04", "cs_pot06_05", "cs_pot07_01", "cs_pot07_02", "cs_pot07_03", "cs_pot07_04", "cs_pot08_01", "cs_pot08_02", "cs_pot08_03", "cs_pot08_04", "cs_pot08_05", "cs_pot09_01", "cs_pot09_02", "cs_pot09_03", "cs_pot09_04", "cs_pot09_05", "cs_pot09_06", "cs_pot09_07", "cs_pot09_08", "cs_pot09_09", "cs_prologue_five_01", "cs_prologue_five_02", "cs_prologue_five_03", "cs_prologue_five_04", "cs_prologue_five_05", "cs_prologue_five_06", "cs_prologue_five_07", "cs_prologue_five_08", "cs_prologue_five_09", "cs_prologue_four_01", "cs_prologue_four_02", "cs_prologue_four_03", "cs_prologue_one_01", "cs_prologue_seven_01", "cs_prologue_seven_02", "cs_prologue_seven_03", "cs_prologue_seven_04", "cs_prologue_seven_05", "cs_prologue_seven_06", "cs_prologue_seven_07", "cs_prologue_seven_08", "cs_prologue_three_01", "cs_prologue_three_02", "cs_prologue_three_03", "cs_prologue_three_04", "cs_prologue_three_05", "cs_prologue_two_01", "cs_prologue_two_02", "cs_prologue_two_03", "cs_prologue_two_04", "cs_prologue_two_05", "cs_prologue_two_06", "cs_prologue_two_07", "cs_prologue_two_08", "cs_prologue_two_09", "cs_prologue_two_10", "cs_prologue_two_11", "cs_prologue_two_12", "cs_prologue_two_13", "cs_prologue_two_14", "cs_prologue_two_15", "cs_prologue_two_16", "cs_prologue_two_17", "cs_prologue_two_18", "cs_prologue_two_19", "cs_prologue_two_20", "cs_prologue_two_22", "cs_prologue_two_23", "cs_prologue_two_24", "cs_prologue_two_25", "narrative_event_bay_01", "narrative_event_bay_02", "prologue_gameplay_hub_a", "prologue_gameplay_hub_b", "prologue_gameplay_hub_mission_board", "prologue_gameplay_hub_training_deck"),
	voice_template = table.enum("psyker_female_a", "psyker_male_a", "sergeant_a", "veteran_female_a", "veteran_male_a", "zealot_female_a", "zealot_male_a"),
	weapon_slot = table.enum("slot_grenade", "slot_melee", "slot_ranged")
}

local function _create_lookup(hashtable)
	local i = 0
	local new_table = {}

	for key, _ in pairs(hashtable) do
		i = i + 1
		new_table[i] = key
		new_table[key] = i
	end

	return new_table
end

dialogue_lookup_context_names.ability_name = _create_lookup(dialogue_lookup_context_names.ability_name)
dialogue_lookup_context_names.attacked_class = _create_lookup(dialogue_lookup_context_names.attacked_class)
dialogue_lookup_context_names.attacking_class = _create_lookup(dialogue_lookup_context_names.attacking_class)
dialogue_lookup_context_names.breed_name = _create_lookup(dialogue_lookup_context_names.breed_name)
dialogue_lookup_context_names.circumstance_name = _create_lookup(dialogue_lookup_context_names.circumstance_name)
dialogue_lookup_context_names.circumstance_vo_id = _create_lookup(dialogue_lookup_context_names.circumstance_vo_id)
dialogue_lookup_context_names.class = _create_lookup(dialogue_lookup_context_names.class)
dialogue_lookup_context_names.class_name = _create_lookup(dialogue_lookup_context_names.class_name)
dialogue_lookup_context_names.current_mission = _create_lookup(dialogue_lookup_context_names.current_mission)
dialogue_lookup_context_names.dialogue_name = _create_lookup(dialogue_lookup_context_names.dialogue_name)
dialogue_lookup_context_names.died_class = _create_lookup(dialogue_lookup_context_names.died_class)
dialogue_lookup_context_names.enemy_tag = _create_lookup(dialogue_lookup_context_names.enemy_tag)
dialogue_lookup_context_names.expression_type = _create_lookup(dialogue_lookup_context_names.expression_type)
dialogue_lookup_context_names.fail_reason = _create_lookup(dialogue_lookup_context_names.fail_reason)
dialogue_lookup_context_names.hit_zone = _create_lookup(dialogue_lookup_context_names.hit_zone)
dialogue_lookup_context_names.horde_type = _create_lookup(dialogue_lookup_context_names.horde_type)
dialogue_lookup_context_names.interactee_class = _create_lookup(dialogue_lookup_context_names.interactee_class)
dialogue_lookup_context_names.interactor_class = _create_lookup(dialogue_lookup_context_names.interactor_class)
dialogue_lookup_context_names.is_hogtied = _create_lookup(dialogue_lookup_context_names.is_hogtied)
dialogue_lookup_context_names.is_local_player = _create_lookup(dialogue_lookup_context_names.is_local_player)
dialogue_lookup_context_names.is_player = _create_lookup(dialogue_lookup_context_names.is_player)
dialogue_lookup_context_names.item_tag = _create_lookup(dialogue_lookup_context_names.item_tag)
dialogue_lookup_context_names.killed_type = _create_lookup(dialogue_lookup_context_names.killed_type)
dialogue_lookup_context_names.killer_class = _create_lookup(dialogue_lookup_context_names.killer_class)
dialogue_lookup_context_names.look_at_tag = _create_lookup(dialogue_lookup_context_names.look_at_tag)
dialogue_lookup_context_names.objective_type = _create_lookup(dialogue_lookup_context_names.objective_type)
dialogue_lookup_context_names.pacing_state = _create_lookup(dialogue_lookup_context_names.pacing_state)
dialogue_lookup_context_names.player_class = _create_lookup(dialogue_lookup_context_names.player_class)
dialogue_lookup_context_names.player_profile = _create_lookup(dialogue_lookup_context_names.player_profile)
dialogue_lookup_context_names.reviving_vo_source = _create_lookup(dialogue_lookup_context_names.reviving_vo_source)
dialogue_lookup_context_names.source_name = _create_lookup(dialogue_lookup_context_names.source_name)
dialogue_lookup_context_names.speaker_class = _create_lookup(dialogue_lookup_context_names.speaker_class)
dialogue_lookup_context_names.speaker_name = _create_lookup(dialogue_lookup_context_names.speaker_name)
dialogue_lookup_context_names.stance_type = _create_lookup(dialogue_lookup_context_names.stance_type)
dialogue_lookup_context_names.target_name = _create_lookup(dialogue_lookup_context_names.target_name)
dialogue_lookup_context_names.threat_level = _create_lookup(dialogue_lookup_context_names.threat_level)
dialogue_lookup_context_names.trigger_id = _create_lookup(dialogue_lookup_context_names.trigger_id)
dialogue_lookup_context_names.trigger_type = _create_lookup(dialogue_lookup_context_names.trigger_type)
dialogue_lookup_context_names.vo_event = _create_lookup(dialogue_lookup_context_names.vo_event)
dialogue_lookup_context_names.vo_line_id = _create_lookup(dialogue_lookup_context_names.vo_line_id)
dialogue_lookup_context_names.voice_template = _create_lookup(dialogue_lookup_context_names.voice_template)
dialogue_lookup_context_names.weapon_slot = _create_lookup(dialogue_lookup_context_names.weapon_slot)
dialogue_lookup_context_names.all_context_names = _create_lookup(dialogue_lookup_context_names.all_context_names)

return settings("dialogue_lookup_context_names", dialogue_lookup_context_names)
