-- chunkname: @scripts/managers/pacing/auto_event/templates/dummy_auto_event_template.lua

template = {}
template.dummy_auto_event_template = {
	monster_limit_per_event = 1,
	name = "dummy_auto_event_template",
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
	},
	num_waves_by_resistance = {
		3,
		3,
		3,
		4,
		5,
	},
	pause_pacing_on_event = {
		all = {},
	},
	monster_chance = {
		challenge = {
			0,
			0,
			0.7,
			0.8,
			0.9,
		},
		heat = {
			0.1,
			0.2,
			0.3,
			0.4,
			0.5,
		},
	},
	resistance_multiplier = {
		0.5,
		0.6,
		0.7,
		0.8,
		0.9,
	},
	points_base = {
		35,
		40,
		45,
		50,
		60,
	},
	size_multipliers = {
		default = 1,
		large = 1.5,
		small = 0.5,
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
							0.5,
							0.4,
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
	monster_composition = {
		{
			breed_amount = 1,
			breed_name = "chaos_beast_of_nurgle",
		},
		{
			breed_amount = 1,
			breed_name = "chaos_spawn",
		},
		{
			breed_amount = 1,
			breed_name = "chaos_plague_ogryn",
		},
	},
}

return template
