-- chunkname: @scripts/settings/mutator/templates/mutator_live_event_templates.lua

local mutator_templates = {
	mutator_drop_pickup_on_death = {
		class = "scripts/managers/mutator/mutators/mutator_base",
		random_spawn_buff_templates = {
			buffs = {
				"drop_pickup_on_death"
			},
			breed_chances = {
				cultist_assault = 0.05,
				cultist_grenadier = 0.25,
				renegade_assault = 0.05,
				renegade_grenadier = 0.25,
				cultist_mutant = 0.25,
				renegade_flamer = 0.25,
				chaos_daemonhost = 1,
				chaos_plague_ogryn = 1,
				cultist_melee = 0.05,
				chaos_poxwalker = 0.1,
				renegade_netgunner = 0.25,
				cultist_shocktrooper = 0.1,
				chaos_ogryn_gunner = 0.25,
				renegade_berzerker = 0.25,
				chaos_spawn = 1,
				renegade_sniper = 0.25,
				chaos_beast_of_nurgle = 1,
				renegade_shocktrooper = 0.1,
				renegade_gunner = 0.1,
				chaos_ogryn_executor = 0.25,
				cultist_berzerker = 0.25,
				renegade_rifleman = 0.05,
				chaos_newly_infected = 0.05,
				chaos_hound = 0.2,
				chaos_ogryn_bulwark = 0.25,
				cultist_gunner = 0.25,
				renegade_melee = 0.05,
				renegade_executor = 0.25,
				cultist_flamer = 0.25
			}
		}
	}
}

return mutator_templates
