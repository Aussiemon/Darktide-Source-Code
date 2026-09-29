-- chunkname: @scripts/settings/mutator/templates/live_event_mutator_templates/mutator_live_event_nurgle_explosion_2026_templates.lua

local mutator_templates = {
	mutator_nurgle_explosion_2026_player_buffs = {
		activate_on_load = true,
		asset_package = "packages/content/live_events/nurgle_explosion_2026/nurgle_explosion_2026_ui_assets",
		class = "scripts/managers/mutator/mutators/mutator_player_buff",
		trigger_on_events = {
			mission_buffs_event_player_spawned = {},
		},
		externally_controlled_buffs = {
			"live_event_abhuman_explosions_grenade_regen_on_elite_kill",
			"live_event_nurgle_explosion_2026_player_buff",
			"live_event_nurgle_explosion_2026_burn_on_ranged_hit",
		},
	},
	mutator_nurgle_explosion_2026_headshot_parasite_enemies = {
		activate_on_load = true,
		class = "scripts/managers/mutator/mutators/mutator_minion_visual_override",
		template_name = "head_parasite",
		random_spawn_buff_templates = {
			buffs = {
				"headshot_parasite_enemies_nurgle_explosion_2026",
			},
			breed_chances = {
				chaos_armored_infected = 1,
				chaos_beast_of_nurgle = 0,
				chaos_daemonhost = 0,
				chaos_hound = 0,
				chaos_lesser_mutated_poxwalker = 1,
				chaos_mutated_poxwalker = 1,
				chaos_newly_infected = 1,
				chaos_ogryn_bulwark = 0.5,
				chaos_ogryn_executor = 0.5,
				chaos_ogryn_gunner = 0.5,
				chaos_plague_ogryn = 0,
				chaos_poxwalker = 1,
				chaos_poxwalker_bomber = 0,
				chaos_spawn = 0,
				cultist_assault = 0.5,
				cultist_berzerker = 0.5,
				cultist_flamer = 0.5,
				cultist_grenadier = 0.5,
				cultist_gunner = 0.5,
				cultist_melee = 0.5,
				cultist_mutant = 0,
				cultist_shocktrooper = 0.5,
				cultist_vanguard = 0.5,
				renegade_assault = 0.5,
				renegade_berzerker = 0.5,
				renegade_captain = 0,
				renegade_executor = 0.5,
				renegade_flamer = 0.5,
				renegade_grenadier = 0.5,
				renegade_gunner = 0.5,
				renegade_melee = 0.5,
				renegade_netgunner = 0,
				renegade_rifleman = 0.5,
				renegade_shocktrooper = 0.5,
				renegade_sniper = 0,
				renegade_vanguard = 0.5,
			},
		},
	},
}

return mutator_templates
