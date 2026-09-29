-- chunkname: @scripts/settings/mutator/templates/live_event_mutator_templates/mutator_live_story_spillway_templates.lua

local Breeds = require("scripts/settings/breed/breeds")
local HordeCompositions = require("scripts/managers/pacing/horde_pacing/horde_compositions")
local WizardBreed = require("scripts/settings/breed/breeds/renegade/renegade_wizard_breed")
local MutatorSpawnerLocationSources = require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_location_sources")
local MutatorSpawnerNode = require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node")
local _all_breeds_buff_chances = {}
local _included_breed_tags = {
	"elite",
}

for breed, breed_data in pairs(Breeds) do
	if breed_data.tags then
		for tag, _ in pairs(breed_data.tags) do
			if table.array_contains(_included_breed_tags, tag) then
				_all_breeds_buff_chances[breed] = 0.25
			end
		end
	end
end

local _cargo_spawn_enemy_composition = {
	{
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						4,
						8,
					},
				},
				{
					name = "renegade_assault",
					amount = {
						3,
						6,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						4,
						8,
					},
				},
				{
					name = "renegade_assault",
					amount = {
						3,
						6,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						4,
						8,
					},
				},
				{
					name = "renegade_assault",
					amount = {
						4,
						6,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						6,
						10,
					},
				},
				{
					name = "renegade_assault",
					amount = {
						4,
						6,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						8,
						10,
					},
				},
				{
					name = "renegade_assault",
					amount = {
						5,
						6,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						10,
						12,
					},
				},
				{
					name = "renegade_assault",
					amount = {
						6,
						8,
					},
				},
			},
		},
	},
}
local _small_clip_drop_chances = {
	0.1,
	0.1,
	0.1,
	0.1,
	0.1,
	0.1,
}
local _stimm_drop_breed_chances = {
	0.1,
	0.1,
	0.1,
	0.1,
	0.1,
	0.1,
}
local mutator_templates = {
	mutator_live_story_spillway_void_shield = {
		activate_on_load = true,
		asset_package = "packages/content/live_campaigns/spillway_campaign/spillway_campaign_assets",
		class = "scripts/managers/mutator/mutators/mutator_minion_nurgle_blessing",
		random_spawn_buff_templates = {
			buffs = {
				"live_story_spillway_void_shield_buff",
			},
			breed_chances = _all_breeds_buff_chances,
		},
		trigger_on_events = {
			boss_encounter_started = {
				deactivate_on_breed = WizardBreed,
			},
		},
	},
	mutator_live_story_spillway_cultist_grenadier = {
		class = "scripts/managers/mutator/mutators/mutator_extra_trickle_hordes",
		trickle_horde_templates = {
			{
				cant_be_ramped = true,
				disallow_spawning_too_close_to_other_spawn = true,
				ignore_disallowance = true,
				not_during_terror_events = false,
				num_trickle_hordes_active_for_cooldown = 20,
				optional_num_tries = 6,
				stinger = "wwise/events/minions/play_minion_special_grenadier_spawn",
				stinger_duration = 8,
				horde_compositions = {
					trickle_horde = {
						renegade = {
							none = {
								HordeCompositions.mutator_cultist_grenadier,
							},
							low = {
								HordeCompositions.mutator_cultist_grenadier,
							},
							high = {
								HordeCompositions.mutator_cultist_grenadier,
							},
							poxwalkers = {
								HordeCompositions.mutator_cultist_grenadier,
							},
						},
						cultist = {
							none = {
								HordeCompositions.mutator_cultist_grenadier,
							},
							low = {
								HordeCompositions.mutator_cultist_grenadier,
							},
							high = {
								HordeCompositions.mutator_cultist_grenadier,
							},
							poxwalkers = {
								HordeCompositions.mutator_cultist_grenadier,
							},
						},
					},
				},
				trickle_horde_travel_distance_range = {
					110,
					230,
				},
				trickle_horde_cooldown = {
					40,
					45,
				},
				optional_main_path_offset = {
					30,
					70,
				},
				pause_pacing_on_spawn = {
					{
						hordes = 40,
						roamers = 20,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						hordes = 40,
						roamers = 20,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						hordes = 40,
						specials = 50,
						trickle_hordes = 40,
					},
					{
						trickle_hordes = 20,
					},
					{
						trickle_hordes = 10,
					},
				},
				num_trickle_waves = {
					{
						4,
						7,
					},
					{
						5,
						8,
					},
					{
						6,
						9,
					},
					{
						7,
						10,
					},
					{
						9,
						14,
					},
				},
				time_between_waves = {
					2,
					5,
				},
			},
		},
	},
	mutator_mutator_live_story_spillway_cultist_grenadier_replacement = {
		class = "scripts/managers/mutator/mutators/mutator_replace_breed",
		init_replacement_breed = {
			breed_replacement = {
				renegade_grenadier = "cultist_grenadier",
			},
		},
	},
	mutator_spillway_cargo_event_spawner = {
		activate_on_load = true,
		asset_package = "packages/content/live_campaigns/spillway_campaign/spillway_campaign_assets",
		class = "scripts/managers/mutator/mutators/mutator_spawner",
		max_spawned_per_section = 1,
		num_to_spawn = 3,
		proximity_trigger_distance = 50,
		spawn_type = "default",
		trigger_distance = 50,
		spawn_locations = MutatorSpawnerLocationSources.mission_provided_gizmo(),
		spawners = {
			{
				class = "scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node_level_instance",
				template = {
					asset_package = "packages/content/live_campaigns/spillway_campaign/spillway_campaign_01",
					use_raycast = false,
					levels = {
						level_size_4 = {
							"content/levels/live_stories/spillway/live_story_spillway_cargo_prop_01",
						},
					},
					placement_method = MutatorSpawnerNode.SINGLE_PLACEMENT,
					size_lookup = {
						"level_size_4",
					},
					spawn_settings = {
						randomize_rotation = true,
					},
				},
			},
			{
				class = "scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node_enemy_template",
				template = {
					placement_method = MutatorSpawnerNode.SINGLE_PLACEMENT,
					composition = {
						renegade = _cargo_spawn_enemy_composition,
						cultist = _cargo_spawn_enemy_composition,
					},
					enemy_placement_method = MutatorSpawnerNode.CIRCLE_PLACEMENT,
				},
			},
		},
	},
	mutator_live_story_spillway_ranged_elite_drops = {
		activate_on_load = true,
		class = "scripts/managers/mutator/mutators/mutator_base",
		random_spawn_buff_templates = {
			buffs = {
				"live_event_barren_drop_small_clip_on_death",
			},
			breed_chances = {
				chaos_ogryn_gunner = _small_clip_drop_chances,
				cultist_gunner = _small_clip_drop_chances,
				cultist_shocktrooper = _small_clip_drop_chances,
				renegade_gunner = _small_clip_drop_chances,
				renegade_netgunner = _small_clip_drop_chances,
				renegade_plasma_gunner = _small_clip_drop_chances,
				renegade_shocktrooper = _small_clip_drop_chances,
				renegade_sniper = _small_clip_drop_chances,
				cultist_flamer = _small_clip_drop_chances,
				renegade_flamer = _small_clip_drop_chances,
			},
		},
	},
	mutator_live_story_spillway_melee_elite_drops = {
		activate_on_load = true,
		class = "scripts/managers/mutator/mutators/mutator_base",
		random_spawn_buff_templates = {
			buffs = {
				"live_event_barren_drop_random_stimm_on_death",
			},
			breed_chances = {
				renegade_berzerker = _stimm_drop_breed_chances,
				cultist_berzerker = _stimm_drop_breed_chances,
				renegade_executor = _stimm_drop_breed_chances,
				chaos_ogryn_bulwark = _stimm_drop_breed_chances,
				chaos_ogryn_executor = _stimm_drop_breed_chances,
			},
		},
	},
}

return mutator_templates
