local player_progression_unlocks = {
	pot_contracts = 11,
	talent_1 = 5,
	barber = 1,
	credits_vendor = 2,
	gadget_slot_1 = 8,
	crafting = 4,
	talent_6 = 30,
	pot_story_traitor_first = 2,
	pot_story_traitor_second = 14,
	pot_story_final = 30,
	gadget_slot_2 = 16,
	pot_crafting = 4,
	pot_gadgets = 8,
	pot_story_masozi = 18,
	talent_4 = 20,
	pot_story_do_or_die = 26,
	gadget_slot_3 = 24,
	contracts = 11,
	talent_2 = 10,
	premium_store = 1,
	shooting_range = 2,
	cosmetics_vendor = 3,
	talent_5 = 25,
	talent_3 = 15,
	pot_story_hadron = 21,
	mission_difficulty_unlocks = {
		normal = {
			1,
			1,
			3,
			9,
			15
		},
		auric = {
			[4.0] = 30,
			[5.0] = 30
		}
	},
	mission_type_unlocks = {
		auric = 30,
		normal = 1
	},
	shooting_range_breed_unlocks = {
		renegade_flamer = "all_renegade_specials_killed",
		renegade_shocktrooper = "all_renegade_elites_killed",
		renegade_grenadier = "all_renegade_specials_killed",
		cultist_shocktrooper = "all_cultist_elites_killed",
		cultist_berzerker = "all_cultist_elites_killed",
		renegade_netgunner = "all_renegade_specials_killed",
		renegade_sniper = "all_renegade_specials_killed",
		cultist_grenadier = "all_cultist_specials_killed",
		cultist_mutant = "all_cultist_specials_killed",
		chaos_hound = "all_chaos_specials_killed",
		chaos_ogryn_executor = "all_chaos_elites_killed",
		chaos_ogryn_bulwark = "all_chaos_elites_killed",
		chaos_ogryn_gunner = "all_chaos_elites_killed",
		renegade_berzerker = "all_renegade_elites_killed",
		cultist_gunner = "all_cultist_elites_killed",
		cultist_flamer = "all_cultist_specials_killed"
	}
}

return settings("PlayerProgressionUnlocks", player_progression_unlocks)
