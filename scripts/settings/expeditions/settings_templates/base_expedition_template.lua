-- chunkname: @scripts/settings/expeditions/settings_templates/base_expedition_template.lua

local expedition_settings = {
	default_session_location_amount = 3,
	pacing_settings = {
		progress_rate_per_location = 1,
		progress_base_rate = {
			denominator = 1800,
			numerator = 1000,
		},
		progress_rate_per_second = {
			denominator = 300,
			numerator = 1,
		},
		minimum_roamer_groups = {
			24,
			23,
			22,
			21,
			20,
		},
	},
	timer_settings = {
		bonus_from_safe_zone = 300,
		corruption_base_damage = 40,
		corruption_tick_time = 0.5,
		corruption_time_power = 1.02,
		max_time = 900,
		total_time = 900,
	},
	exit_event_settings = {
		duration = 30,
	},
	extraction_event_settings = {
		duration = 30,
	},
	ignored_level_slot_tags = {
		"spawn_mode_1",
		"spawn_mode_2",
		"none",
		"01",
		"02",
		"03",
	},
	special_level_slot_tags = {
		"rot_mode_random",
		"rot_mode_slot",
	},
	level_tags_by_type = {
		size = {
			"level_size_16",
			"level_size_32",
			"level_size_48",
			"level_size_64",
		},
		type = {
			"type_opportunity",
			"type_traversal",
			"type_extraction",
			"type_arrival",
			"type_transition",
			"type_main_objective",
			"transition_fake",
		},
		biome = {
			"biome_wastes",
			"biome_oil",
			"biome_quarry",
			"biome_generic",
		},
	},
	slot_distribution_by_level_tag = {},
	level_slot_distributions = {
		{
			only_first_section = true,
			complete_conditions = {
				max = 1,
				min = 1,
			},
			phases = {
				{
					{
						max = 1,
						min = 1,
						order_score = 1,
						tags = {
							"type_arrival",
						},
					},
				},
			},
		},
		{
			complete_conditions = {
				max = 1,
				min = 1,
			},
			phases = {
				{
					{
						max = 1,
						min = 1,
						order_score = 1,
						tags = {
							"type_extraction",
						},
					},
				},
			},
		},
		{
			complete_conditions = {
				max = 4,
				min = 3,
			},
			phases = {
				{
					{
						consume_level_on_spawn_per_expedition = false,
						consume_level_on_spawn_per_location = true,
						max = 2,
						min = 1,
						order_score = 1,
						tags = {
							"level_size_32",
							"type_opportunity",
						},
					},
					{
						consume_level_on_spawn_per_expedition = false,
						consume_level_on_spawn_per_location = true,
						max = 2,
						min = 1,
						order_score = 1,
						tags = {
							"level_size_48",
							"type_opportunity",
						},
					},
					{
						consume_level_on_spawn_per_expedition = false,
						consume_level_on_spawn_per_location = true,
						max = 2,
						min = 1,
						order_score = 1,
						tags = {
							"level_size_64",
							"type_opportunity",
						},
					},
				},
			},
		},
		{
			complete_conditions = {
				max = 100,
				min = 50,
			},
			phases = {
				{
					{
						consume_level_on_spawn_per_expedition = false,
						consume_level_on_spawn_per_location = false,
						max = 2,
						min = 1,
						order_score = 1,
						tags = {
							"level_size_16",
							"type_traversal",
						},
					},
					{
						consume_level_on_spawn_per_expedition = false,
						consume_level_on_spawn_per_location = false,
						max = 2,
						min = 1,
						order_score = 1,
						tags = {
							"level_size_32",
							"type_traversal",
						},
					},
					{
						consume_level_on_spawn_per_expedition = false,
						consume_level_on_spawn_per_location = false,
						max = 2,
						min = 1,
						order_score = 1,
						tags = {
							"level_size_48",
							"type_traversal",
						},
					},
					{
						consume_level_on_spawn_per_expedition = false,
						consume_level_on_spawn_per_location = false,
						max = 2,
						min = 1,
						order_score = 1,
						tags = {
							"level_size_64",
							"type_traversal",
						},
					},
				},
			},
		},
		{
			complete_conditions = {
				max = 100,
				min = 50,
			},
			phases = {
				{
					{
						max = 2,
						min = 1,
						order_score = 1,
						tags = {
							"interactable",
						},
						optional_resource_tags = {
							"default_pickup",
						},
					},
				},
			},
		},
	},
	events = {},
	theme_tags = {
		"default",
	},
	safe_zone_levels = {
		"content/levels/expeditions/safe_zones/wastes/sz_cave_tunnels_001/missions/mission_sz_cave_tunnels_001",
		"content/levels/expeditions/safe_zones/wastes/sz_cave_tunnels_002/missions/mission_sz_cave_tunnels_002",
		"content/levels/expeditions/safe_zones/wastes/sz_stronghold_ruin_002/missions/mission_sz_stronghold_ruin_002",
	},
	loot_settings = {
		pickup_name_format = "expedition_loot_%s_tier_%d",
		reward_base_budget = 100,
		types = {
			"small",
			"crate",
			"heavy",
		},
		settings_by_type = {
			small = {
				values_per_tier = {
					10,
					25,
					50,
				},
			},
			crate = {
				values_per_tier = {
					50,
					60,
					70,
				},
				limit_per_location = {
					max = 0,
					min = 0,
				},
				bonus_spawn_per_location = {
					max = 0,
					min = 0,
				},
			},
			heavy = {
				values_per_tier = {
					200,
					200,
					200,
				},
				limit_per_location = {
					max = 0,
					min = 0,
				},
				bonus_spawn_per_location = {
					max = 2,
					min = 1,
				},
			},
		},
		ambient_budgets_per_difficulty = {
			0,
			200,
			200,
			200,
			200,
			200,
		},
		ambient_location_multipliers = {
			{
				max = 1,
				min = 1,
			},
			{
				max = 1.25,
				min = 1.25,
			},
			{
				max = 1.5,
				min = 1.5,
			},
			{
				max = 1.75,
				min = 1.75,
			},
			{
				max = 2,
				min = 2,
			},
		},
		ambient_distribution_weights = {
			by_tier = {
				{
					max = 1,
					min = 1,
				},
				{
					max = 1,
					min = 1,
				},
				{
					max = 0,
					min = 0,
				},
			},
			by_source = {
				primary = {
					max = 1,
					min = 1,
				},
				secondary = {
					max = 3,
					min = 3,
				},
			},
		},
		reward_location_multipliers = {
			0,
			0.25,
			0.5,
			0.75,
			1,
		},
		reward_difficulty_multipliers = {
			1,
			1,
			1,
			1,
			1,
			1,
		},
		reward_tag_budget_modifiers = {
			type_traversal = {
				max = -0.6,
				min = -0.6,
			},
			level_size_32 = {
				max = 0,
				min = 0,
			},
			level_size_48 = {
				max = 0.3,
				min = 0.3,
			},
			level_size_64 = {
				max = 0.5,
				min = 0.5,
			},
		},
	},
	scrap_settings = {
		pickup_name_format = "expedition_currency_%s_tier_%d",
		types = {
			"small",
		},
		settings_by_type = {
			small = {
				values_per_tier = {
					25,
					50,
				},
			},
		},
		ambient_budgets_per_difficulty = {
			0,
			600,
			600,
			600,
			600,
			600,
		},
		ambient_location_multipliers = {
			{
				max = 1,
				min = 1,
			},
			{
				max = 1,
				min = 1,
			},
			{
				max = 0,
				min = 0,
			},
			{
				max = 0,
				min = 0,
			},
			{
				max = 0,
				min = 0,
			},
		},
		ambient_distribution_weights = {
			by_tier = {
				{
					max = 3,
					min = 3,
				},
				{
					max = 1,
					min = 1,
				},
			},
			by_source = {
				primary = {
					max = 0,
					min = 0,
				},
				secondary = {
					max = 1,
					min = 1,
				},
			},
		},
	},
	store_info = {
		pickups = {
			health_station = {
				player_purchases_per_store = 1,
				price = 50,
			},
			large_ammunition_crate = {
				price = 50,
			},
			small_grenade = {
				price = 25,
			},
			syringe_corruption_pocketable = {
				price = 75,
				random_spawn = true,
			},
			motion_detection_mine_fire_pocketable = {
				price = 0,
				random_spawn = true,
			},
			motion_detection_mine_shock_pocketable = {
				price = 0,
				random_spawn = true,
			},
			motion_detection_mine_explosive_pocketable = {
				price = 0,
				random_spawn = true,
			},
			expedition_grenade_artillery_strike_pocketable = {
				price = 0,
				random_spawn = true,
			},
			expedition_grenade_valkyrie_hover_pocketable = {
				player_purchases_per_store = 1,
				price = 10,
				random_spawn = true,
			},
			expedition_time_syringe_timed = {
				price = 0,
				random_spawn = true,
			},
			expedition_explosive_luggable_01 = {
				price = 0,
				random_spawn = true,
			},
			expedition_deployable_force_field_pocketable = {
				price = 0,
				random_spawn = true,
			},
			expedition_grenade_airstrike_pocketable = {
				price = 0,
				random_spawn = true,
			},
			expedition_grenade_big_pocketable = {
				price = 0,
				random_spawn = true,
			},
		},
	},
}

return expedition_settings
