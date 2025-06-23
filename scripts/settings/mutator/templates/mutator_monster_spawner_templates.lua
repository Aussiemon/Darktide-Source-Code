-- chunkname: @scripts/settings/mutator/templates/mutator_monster_spawner_templates.lua

local mutator_templates = {
	mutator_monster_spawner = {
		class = "scripts/managers/mutator/mutators/mutator_monster_spawner",
		spawner_template = {
			force_horde_on_spawn = true,
			trigger_distance = 55,
			monster_breed_name = {
				"chaos_mutator_daemonhost"
			},
			num_to_spawn_per_mission = {
				dm_rise = 5,
				cm_raid = 5,
				lm_scavenge = 5,
				lm_rails = 5,
				km_heresy = 5,
				lm_cooling = 5,
				fm_cargo = 5,
				hm_strain = 5,
				cm_habs = 3,
				km_enforcer = 5,
				fm_armoury = 5,
				fm_resurgence = 5,
				km_station = 5,
				hm_complex = 5,
				cm_archives = 5,
				dm_forge = 5,
				hm_cartel = 5,
				dm_propaganda = 5,
				core_research = 4
			}
		}
	},
	mutator_monster_havoc_twins = {
		class = "scripts/managers/mutator/mutators/mutator_monster_spawner",
		spawner_template = {
			injection_template = "havoc_twins",
			trigger_distance = 55,
			force_horde_on_spawn = true,
			num_to_spawn = 1,
			monster_breed_name = {
				"havoc_twins"
			}
		}
	},
	mutator_nurgle_totem = {
		class = "scripts/managers/mutator/mutators/mutator_monster_spawner",
		spawner_template = {
			spawn_locations = "skulls_locations",
			trigger_distance = 55,
			injection_template = "nurgle_totems",
			force_horde_on_spawn = true,
			asset_package = "content/characters/enemy/mutators/skull_totems_assets",
			num_to_spawn = 3,
			monster_breed_name = {
				"nurgle_totems"
			}
		}
	}
}

return mutator_templates
