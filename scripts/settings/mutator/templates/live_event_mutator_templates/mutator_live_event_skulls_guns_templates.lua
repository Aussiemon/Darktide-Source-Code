-- chunkname: @scripts/settings/mutator/templates/live_event_mutator_templates/mutator_live_event_skulls_guns_templates.lua

local MutatorSpawnerNode = require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node")
local MutatorSpawnerLocationSources = require("scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_location_sources")
local EnemyEventSpawnerSettings = require("scripts/settings/components/enemy_event_spawner_settings")
local LevelProps = require("scripts/settings/level_prop/level_props")
local ResistanceUtils = require("scripts/managers/pacing/utilities/resistance_utils")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local _side_notification_settings = {
	interaction_type_loc_strings = {
		"loc_player_skulls_pickup_notification",
	},
	pickup_localization_by_size = {
		large = "loc_tainted_skull_pickup",
		medium = "loc_tainted_skull_pickup",
		small = "loc_tainted_skull_pickup",
	},
	pickup_icon_by_size = {
		large = "content/ui/materials/icons/currencies/live_events/skulls_live_event_small",
		medium = "content/ui/materials/icons/currencies/live_events/skulls_live_event_small",
		small = "content/ui/materials/icons/currencies/live_events/skulls_live_event_small",
	},
}
local _nurgle_totem_mutator_base = {
	class = "scripts/managers/mutator/mutators/mutator_spawner",
	max_spawned_per_section = 1,
	num_to_spawn = 3,
	trigger_distance = 60,
	spawn_locations = MutatorSpawnerLocationSources.prebaked_mission_locations("skulls_locations"),
	spawners = {
		{
			class = "scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node_networked_unit_instance",
			template = {
				asset_package = "content/characters/enemy/mutators/skull_totems_assets",
				use_raycast = true,
				units = {
					level_size_4 = {
						{
							unit_name = "content/environment/artsets/imperial/global/props/skull_totem/skull_totem_01",
							unit_template_name = "level_prop",
							unit_settings = LevelProps.nurgle_totem,
						},
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
			class = "scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node_horde_trigger",
			template = {},
		},
		{
			class = "scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node_enemy_template",
			template = {
				placement_method = MutatorSpawnerNode.SINGLE_PLACEMENT,
				composition = EnemyEventSpawnerSettings.live_event_skull_totem_guards,
				enemy_placement_method = MutatorSpawnerNode.CIRCLE_PLACEMENT,
				spawn_settings = {
					position_offset = 4,
				},
			},
		},
	},
}
local mutator_templates = {
	mutator_nurgle_totem = table.clone(_nurgle_totem_mutator_base),
	mutator_nurgle_totem_more = table.add_missing({
		max_spawned_per_section = 2,
		num_to_spawn = 5,
	}, table.clone(_nurgle_totem_mutator_base)),
	mutator_live_event_skulls_notification_feed = {
		activate_on_load = true,
		asset_package = "packages/content/live_events/skulls/live_event_skulls_ui_assets",
		class = "scripts/managers/mutator/mutators/mutator_gameplay",
		gameplay_template = {
			path = "scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_live_event_skulls",
			start_module_on_activate = true,
			settings = {},
		},
		side_notification = _side_notification_settings,
	},
	mutator_live_event_skulls_drop_single_skull_pickup_on_death = {
		class = "scripts/managers/mutator/mutators/mutator_base",
		random_spawn_buff_templates = {
			buffs = {
				"drop_single_skull_on_death",
			},
			breed_chances = {
				chaos_beast_of_nurgle = 0,
				chaos_daemonhost = 0,
				chaos_hound = 0.05,
				chaos_newly_infected = 0.01875,
				chaos_ogryn_bulwark = 0.0825,
				chaos_ogryn_executor = 0.0825,
				chaos_ogryn_gunner = 0.0825,
				chaos_plague_ogryn = 0,
				chaos_poxwalker = 0.03125,
				chaos_spawn = 0,
				cultist_assault = 0.01875,
				cultist_berzerker = 0.0825,
				cultist_flamer = 0.0825,
				cultist_grenadier = 0.0825,
				cultist_gunner = 0.0825,
				cultist_melee = 0.01875,
				cultist_mutant = 0.0825,
				cultist_shocktrooper = 0.0375,
				renegade_assault = 0.01875,
				renegade_berzerker = 0.0825,
				renegade_executor = 0.0825,
				renegade_flamer = 0.0825,
				renegade_grenadier = 0.0825,
				renegade_gunner = 0.0375,
				renegade_melee = 0.01875,
				renegade_netgunner = 0.0825,
				renegade_rifleman = 0.01875,
				renegade_shocktrooper = 0.0375,
				renegade_sniper = 0.0825,
			},
		},
	},
	mutator_live_event_skulls_drop_many_skull_pickups_on_death = {
		class = "scripts/managers/mutator/mutators/mutator_base",
		random_spawn_buff_templates = {
			buffs = {
				"drop_many_skulls_on_death",
			},
			breed_chances = {
				chaos_beast_of_nurgle = 1,
				chaos_daemonhost = 1,
				chaos_hound = 0,
				chaos_newly_infected = 0,
				chaos_ogryn_bulwark = 0,
				chaos_ogryn_executor = 0,
				chaos_ogryn_gunner = 0,
				chaos_plague_ogryn = 1,
				chaos_poxwalker = 0,
				chaos_spawn = 1,
				cultist_assault = 0,
				cultist_berzerker = 0,
				cultist_flamer = 0,
				cultist_grenadier = 0,
				cultist_gunner = 0,
				cultist_melee = 0,
				cultist_mutant = 0,
				cultist_shocktrooper = 0,
				renegade_assault = 0,
				renegade_berzerker = 0,
				renegade_executor = 0,
				renegade_flamer = 0,
				renegade_grenadier = 0,
				renegade_gunner = 0,
				renegade_melee = 0,
				renegade_netgunner = 0,
				renegade_rifleman = 0,
				renegade_shocktrooper = 0,
				renegade_sniper = 0,
			},
		},
	},
	mutator_live_event_skulls_guns_full = {
		activate_on_load = true,
		asset_package = "packages/content/live_events/skulls/live_event_skulls_guns_assets",
		class = "scripts/managers/mutator/mutators/mutator_gameplay",
		gameplay_template = {
			path = "scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_live_event_skulls_guns_full",
			start_module_on_activate = true,
			settings = {
				min_auto_event_duration = 20,
				horde_pacing_per_skull = ResistanceUtils.to_interpolated_array({
					required_horde_travel_distance = {
						interpolate_floats = false,
						low = {
							70,
							50,
							35,
							30,
							25,
						},
						high = {
							40,
							30,
							25,
							20,
							15,
						},
						interpolation_func = ResistanceUtils.interpolation_linear,
					},
					chance_of_coordinated_strike = {
						interpolate_floats = true,
						low = {
							0.125,
							0.15,
							0.175,
							0.2,
							0.25,
						},
						high = {
							0.35,
							0.4,
							0.45,
							0.5,
							0.55,
						},
						interpolation_func = ResistanceUtils.interpolation_linear,
					},
				}),
				notifications = {
					event_start = {
						style = "alert",
						subtitle = "loc_skulls_guns_event_auto_event_start_subtitle",
						title = "loc_skulls_guns_event_auto_event_start_title",
						sound_event = UISoundEvents.notification_warning,
					},
					event_end = {
						style = "default",
						subtitle = "loc_skulls_guns_event_auto_event_end_subtitle",
						title = "loc_skulls_guns_event_auto_event_end_title",
						sound_event = UISoundEvents.notification_achievement,
					},
				},
			},
		},
		side_notification = _side_notification_settings,
	},
}

return mutator_templates
