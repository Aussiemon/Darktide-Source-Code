-- chunkname: @scripts/managers/pacing/auto_event/templates/expedition_auto_event_template.lua

local template = {}

template.expedition_auto_event_template = {
	check_radius_to_players = true,
	name = "expedition_auto_event_template",
	optional_disallowed_positions = true,
	resistance_multiplier = {
		0.5,
		0.6,
		1,
		1.2,
		1.5,
		1.7,
	},
	points_base = {
		25,
		30,
		35,
		40,
		55,
	},
	num_waves_by_resistance = {
		3,
		3,
		4,
		4,
		5,
	},
	size_multipliers = {
		default = 1,
		large = 1.5,
		small = 0.5,
	},
	cooldown = {
		{
			22,
			24,
		},
		{
			20,
			22,
		},
		{
			14,
			16,
		},
		{
			9,
			12,
		},
		{
			7,
			10,
		},
	},
	waves_cooldown = {
		{
			9,
			12,
		},
		{
			8,
			11,
		},
		{
			5,
			8,
		},
		{
			4,
			7,
		},
		{
			3,
			7,
		},
	},
	inital_cooldown_types = {
		default = 1,
		extraction = 0.3,
		safe_room = 0.3,
	},
	stingers = {
		stingers = {
			default = "wwise/events/minions/play_minion_expeditions_horde_signal_3d_med",
			huge = "wwise/events/minions/play_minion_expeditions_horde_signal_3d_huge",
			large = "wwise/events/minions/play_minion_expeditions_horde_signal_3d_lar",
			small = "wwise/events/minions/play_minion_expeditions_horde_signal_3d_sml",
		},
		pre_stingers = {
			default = "wwise/events/minions/play_minion_expeditions_horde_signal_2d",
			huge = "wwise/events/minions/play_minion_expeditions_horde_signal_2d",
			large = "wwise/events/minions/play_minion_expeditions_horde_signal_2d",
			small = "wwise/events/minions/play_minion_expeditions_horde_signal_2d",
		},
	},
	captains_settings = {
		chance_for_injection = {
			conditional_values = {
				0,
				0,
				0,
				0.4,
				0.5,
			},
			chance_indexed_by_resistance = {
				0,
				0,
				0.3,
				0.4,
				0.5,
				0.6,
			},
		},
		execute = function (force_spawn)
			local num_to_spawn = math.random(1, 2)

			if force_spawn then
				if type(force_spawn) == "number" then
					num_to_spawn = force_spawn
				end

				return true, num_to_spawn
			end

			local heat_chance = template.expedition_auto_event_template.conditional_function(template.expedition_auto_event_template.captains_settings.chance_for_injection.conditional_values)
			local resistance_chance = Managers.state.difficulty:get_table_entry_by_resistance(template.expedition_auto_event_template.captains_settings.chance_for_injection.chance_indexed_by_resistance)
			local randomized_heat_chance = math.random(0, heat_chance)
			local randomzied_resistance_chance = math.random(0, resistance_chance)
			local chance = math.clamp(randomized_heat_chance + randomzied_resistance_chance, 0, 1)

			if chance > math.random() then
				return true, num_to_spawn
			else
				return false
			end
		end,
	},
	monster_settings = {
		chance_for_injection = {
			conditional_values = {
				0,
				0,
				0,
				0,
				0,
			},
			chance_indexed_by_resistance = {
				0,
				0,
				0,
				0,
				0,
				0,
			},
		},
		execute = function (force_spawn)
			local num_to_spawn = math.random(1, 2)

			if force_spawn then
				if type(force_spawn) == "number" then
					num_to_spawn = force_spawn
				end

				return true, num_to_spawn
			end

			local heat_chance = template.expedition_auto_event_template.conditional_function(template.expedition_auto_event_template.monster_settings.chance_for_injection.conditional_values)
			local resistance_chance = Managers.state.difficulty:get_table_entry_by_resistance(template.expedition_auto_event_template.monster_settings.chance_for_injection.chance_indexed_by_resistance)
			local randomized_heat_chance = math.random(0, heat_chance)
			local randomzied_resistance_chance = math.random(0, resistance_chance)
			local chance = math.clamp(randomized_heat_chance + randomzied_resistance_chance, 0, 1)

			if chance > math.random() then
				return true, num_to_spawn
			else
				return false
			end
		end,
	},
	twins_settings = {
		chance_for_injection = {
			conditional_values = {
				0,
				0,
				0,
				0.1,
				0.5,
			},
			chance_indexed_by_resistance = {
				0,
				0,
				0,
				0,
				0.7,
				0.8,
			},
		},
		execute = function (force_spawn, num_twins)
			if force_spawn then
				if type(force_spawn) == "number" then
					num_to_spawn = force_spawn
				end

				return true, num_to_spawn
			end

			local heat_chance = template.expedition_auto_event_template.conditional_function(template.expedition_auto_event_template.twins_settings.chance_for_injection.conditional_values)
			local resistance_chance = Managers.state.difficulty:get_table_entry_by_resistance(template.expedition_auto_event_template.twins_settings.chance_for_injection.chance_indexed_by_resistance)
			local randomized_heat_chance = math.random(0, heat_chance)
			local randomzied_resistance_chance = math.random(0, resistance_chance)
			local chance = math.clamp(randomized_heat_chance + randomzied_resistance_chance, 0, 1)

			if chance > math.random() then
				return true, num_twins
			else
				return false
			end
		end,
	},
	special_config = {
		breeds = {
			"chaos_hound",
			"chaos_poxwalker_bomber",
			"grenadier",
			"renegade_netgunner",
			"flamer",
			"cultist_mutant",
		},
		chance_for_special_injection = {
			0,
			0,
			0.3,
			0.5,
			0.6,
		},
		success_cooldown = {
			{
				99,
				99,
			},
			{
				99,
				99,
			},
			{
				15,
				25,
			},
			{
				10,
				20,
			},
			{
				5,
				15,
			},
			{
				3,
				12,
			},
		},
		failed_cooldown = {
			{
				99,
				99,
			},
			{
				99,
				99,
			},
			{
				5,
				10,
			},
			{
				4,
				9,
			},
			{
				3,
				8,
			},
		},
	},
	composition = {
		default = {
			breeds = {
				{
					points = 0,
					breed_tags = {
						{
							"elite",
						},
					},
					excluded_breed_tags = {
						{
							"ogryn",
						},
					},
					weights = {
						{
							0,
							0,
							0,
							0,
							0,
						},
						{
							0,
							0,
							0,
							0,
							0,
						},
						{
							0.2,
							0.3,
							0.4,
							0.5,
							0.7,
						},
						{
							0.4,
							0.6,
							0.8,
							1,
							1,
						},
						{
							0.5,
							0.7,
							1,
							1,
							1.5,
						},
					},
				},
				{
					points = 0,
					breed_tags = {
						{
							"elite",
							"ogryn",
						},
					},
					excluded_breed_tags = {},
					weights = {
						{
							0,
							0,
							0,
							0,
							0,
						},
						{
							0,
							0,
							0,
							0,
							0,
						},
						{
							0.1,
							0.2,
							0.5,
							0.8,
							1,
						},
						{
							0.2,
							0.4,
							0.8,
							1,
							1,
						},
						{
							0.3,
							0.5,
							1,
							1,
							1.5,
						},
					},
				},
				{
					points = 0,
					breed_tags = {
						{
							"roamer",
						},
					},
					excluded_breed_tags = {
						{
							"elite",
						},
					},
					weights = {
						{
							1,
							1,
							0.7,
							0.5,
							0.4,
						},
						{
							1,
							1,
							0.7,
							0.5,
							0.4,
						},
						{
							1,
							1,
							0.7,
							0.6,
							0.45,
						},
						{
							0.9,
							0.8,
							0.7,
							0.45,
							0.4,
						},
						{
							0.85,
							0.75,
							0.65,
							0.35,
							0.3,
						},
					},
				},
				{
					points = 0,
					breed_tags = {
						{
							"horde",
						},
					},
					excluded_breed_tags = {},
					weights = {
						{
							1.5,
							1.3,
							1.1,
							0.9,
							0.7,
						},
						{
							1.5,
							1.3,
							1.1,
							0.9,
							0.7,
						},
						{
							1.5,
							1.3,
							1.1,
							0.9,
							0.7,
						},
						{
							1.4,
							1.3,
							1,
							0.9,
							0.7,
						},
						{
							1.3,
							1.1,
							1,
							0.9,
							0.7,
						},
					},
				},
			},
		},
		melee = {
			breeds = {
				{
					points = 0,
					breed_tags = {
						{
							"elite",
							"melee",
						},
					},
					excluded_breed_tags = {},
					weights = {
						{
							1.5,
							1.5,
							1.5,
							1.5,
							1.5,
						},
						{
							1.5,
							1.5,
							1.5,
							1.5,
							1.5,
						},
						{
							1.5,
							1.5,
							1.5,
							1.5,
							1.5,
						},
						{
							1.5,
							1.5,
							1.5,
							1.5,
							1.5,
						},
						{
							1.5,
							1.5,
							1.5,
							1.5,
							1.5,
						},
					},
				},
				{
					points = 0,
					breed_tags = {
						{
							"elite",
							"ranged",
						},
					},
					excluded_breed_tags = {},
					weights = {
						{
							1,
							1,
							1,
							1,
							1,
						},
						{
							1,
							1,
							1,
							1,
							1,
						},
						{
							1,
							1,
							1,
							1,
							1,
						},
						{
							1,
							1,
							1,
							1,
							1,
						},
						{
							1,
							1,
							1,
							1,
							1,
						},
					},
				},
				{
					points = 0,
					breed_tags = {
						{
							"elite",
							"ogryn",
						},
					},
					excluded_breed_tags = {},
					weights = {
						{
							0,
							0,
							0,
							0,
							0,
						},
						{
							0,
							0,
							0,
							0,
							0,
						},
						{
							0,
							0,
							0,
							0,
							0,
						},
						{
							0,
							0,
							0,
							0,
							0,
						},
						{
							0,
							0,
							0,
							0,
							0,
						},
					},
				},
				{
					points = 0,
					breed_tags = {
						{
							"ranged",
							"roamer",
						},
					},
					excluded_breed_tags = {
						{
							"elite",
						},
					},
					weights = {
						{
							0.5,
							0.5,
							0.5,
							0.5,
							0.5,
						},
						{
							0.5,
							0.5,
							0.5,
							0.5,
							0.5,
						},
						{
							0.5,
							0.5,
							0.5,
							0.5,
							0.5,
						},
						{
							0.5,
							0.5,
							0.5,
							0.5,
							0.5,
						},
						{
							0.5,
							0.5,
							0.5,
							0.5,
							0.5,
						},
					},
				},
				{
					points = 0,
					breed_tags = {
						{
							"melee",
							"roamer",
						},
					},
					excluded_breed_tags = {
						{
							"elite",
						},
					},
					weights = {
						{
							1.5,
							1.5,
							1.5,
							1.5,
							1.5,
						},
						{
							1.5,
							1.5,
							1.5,
							1.5,
							1.5,
						},
						{
							1.5,
							1.5,
							1.5,
							1.5,
							1.5,
						},
						{
							1.5,
							1.5,
							1.5,
							1.5,
							1.5,
						},
						{
							1.5,
							1.5,
							1.5,
							1.5,
							1.5,
						},
					},
				},
				{
					points = 0,
					breed_tags = {
						{
							"horde",
						},
					},
					excluded_breed_tags = {},
					weights = {
						{
							0.7,
							0.7,
							0.7,
							0.7,
							0.7,
						},
						{
							0.7,
							0.7,
							0.7,
							0.7,
							0.7,
						},
						{
							0.7,
							0.7,
							0.7,
							0.7,
							0.7,
						},
						{
							0.7,
							0.7,
							0.7,
							0.7,
							0.7,
						},
						{
							0.7,
							0.7,
							0.7,
							0.7,
							0.7,
						},
					},
				},
			},
		},
		ranged = {
			breeds = {
				{
					points = 0,
					breed_tags = {
						{
							"elite",
							"melee",
						},
					},
					excluded_breed_tags = {},
					weights = {
						{
							1,
							1,
							1,
							1,
							1,
						},
						{
							1,
							1,
							1,
							1,
							1,
						},
						{
							1,
							1,
							1,
							1,
							1,
						},
						{
							1,
							1,
							1,
							1,
							1,
						},
						{
							1,
							1,
							1,
							1,
							1,
						},
					},
				},
				{
					points = 0,
					breed_tags = {
						{
							"elite",
							"ranged",
						},
					},
					excluded_breed_tags = {},
					weights = {
						{
							0.7,
							1,
							1,
							1,
							1,
						},
						{
							0.7,
							1,
							1,
							1,
							1,
						},
						{
							0.7,
							1,
							1,
							1,
							1,
						},
						{
							0.7,
							1,
							1,
							1,
							1,
						},
						{
							0.7,
							1,
							1,
							1,
							1,
						},
					},
				},
				{
					points = 0,
					breed_tags = {
						{
							"elite",
							"ogryn",
						},
					},
					excluded_breed_tags = {},
					weights = {
						{
							0,
							0,
							0,
							0,
							0,
						},
						{
							0,
							0,
							0,
							0,
							0,
						},
						{
							0,
							0,
							0,
							0,
							0,
						},
						{
							0,
							0,
							0,
							0,
							0,
						},
						{
							0,
							0,
							0,
							0,
							0,
						},
					},
				},
				{
					points = 0,
					breed_tags = {
						{
							"ranged",
							"roamer",
						},
					},
					excluded_breed_tags = {
						{
							"elite",
						},
					},
					weights = {
						{
							1.5,
							1.5,
							1.5,
							1.5,
							1.5,
						},
						{
							1.5,
							1.5,
							1.5,
							1.5,
							1.5,
						},
						{
							1.5,
							1.5,
							1.5,
							1.5,
							1.5,
						},
						{
							1.5,
							1.5,
							1.5,
							1.5,
							1.5,
						},
						{
							1.5,
							1.5,
							1.5,
							1.5,
							1.5,
						},
					},
				},
				{
					points = 0,
					breed_tags = {
						{
							"melee",
							"roamer",
						},
					},
					excluded_breed_tags = {
						{
							"elite",
						},
					},
					weights = {
						{
							0.5,
							0.5,
							0.5,
							0.5,
							0.5,
						},
						{
							0.5,
							0.5,
							0.5,
							0.5,
							0.5,
						},
						{
							0.5,
							0.5,
							0.5,
							0.5,
							0.5,
						},
						{
							0.5,
							0.5,
							0.5,
							0.5,
							0.5,
						},
						{
							0.5,
							0.5,
							0.5,
							0.5,
							0.5,
						},
					},
				},
				{
					points = 0,
					breed_tags = {
						{
							"horde",
						},
					},
					excluded_breed_tags = {},
					weights = {
						{
							0.7,
							0.7,
							0.7,
							0.7,
							0.7,
						},
						{
							0.7,
							0.7,
							0.7,
							0.7,
							0.7,
						},
						{
							0.7,
							0.7,
							0.7,
							0.7,
							0.7,
						},
						{
							0.7,
							0.7,
							0.7,
							0.7,
							0.7,
						},
						{
							0.7,
							0.7,
							0.7,
							0.7,
							0.7,
						},
					},
				},
			},
		},
	},
	conditional_function = function (t)
		return Managers.state.pacing:get_table_entry_by_heat_stage(t)
	end,
}

return template
