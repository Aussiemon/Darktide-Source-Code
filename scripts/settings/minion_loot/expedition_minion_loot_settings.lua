-- chunkname: @scripts/settings/minion_loot/expedition_minion_loot_settings.lua

ExpeditionMinionLootSettings = {}
ExpeditionMinionLootSettings.renegade_netgunner = {
	frame = "content/ui/materials/icons/portraits/minion_portraits/scab_trapper_portrait",
	max_per_opportunity = 200,
	max_stolen = 400,
	method = "drop_on_death",
}
ExpeditionMinionLootSettings.cultist_mutant = {
	frame = "content/ui/materials/icons/portraits/minion_portraits/mutant_portrait",
	max_per_opportunity = 200,
	max_stolen = 400,
	method = "drop_on_death",
}
ExpeditionMinionLootSettings.chaos_spawn = {
	frame = "content/ui/materials/icons/portraits/minion_portraits/chaos_spawn_portrait",
	max_per_opportunity = 500,
	max_stolen = 2000,
	method = "drop_on_death",
}
ExpeditionMinionLootSettings.chaos_spawn = {
	frame = "content/ui/materials/icons/portraits/minion_portraits/chaos_ogryn_houndmaster_portrait",
	max_per_opportunity = 500,
	max_stolen = 2000,
	method = "drop_on_death",
}
ExpeditionMinionLootSettings.chaos_beast_of_nurgle = {
	frame = "content/ui/materials/icons/portraits/minion_portraits/beast_of_nurgle_portrait",
	max_per_opportunity = 500,
	max_stolen = 2000,
	method = "drop_on_death",
}
ExpeditionMinionLootSettings.chaos_hound = {
	frame = "content/ui/materials/icons/portraits/minion_portraits/chaos_hound_portrait",
	max_per_opportunity = 250,
	method = "direct_drop",
}
ExpeditionMinionLootSettings.chaos_poxwalker_bomber = {
	frame = "content/ui/materials/icons/portraits/minion_portraits/bomber_portrait",
	max_per_opportunity = 250,
	method = "direct_drop",
}
ExpeditionMinionLootSettings.chaos_armored_hound = table.clone(ExpeditionMinionLootSettings.chaos_hound)
ExpeditionMinionLootSettings.chaos_armored_mutator = table.clone(ExpeditionMinionLootSettings.chaos_hound)
ExpeditionMinionLootSettings.monster_inital_loot_amount_indexed_by_heat = {
	0,
	500,
	1000,
	2000,
	3000,
}

return ExpeditionMinionLootSettings
