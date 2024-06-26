-- chunkname: @scripts/managers/pacing/horde_pacing/compositions/renegade_horde_compositions.lua

local horde_compositions = {
	renegade_small = {
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						10,
						12,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						12,
						14,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						14,
						16,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						18,
						20,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						20,
						22,
					},
				},
			},
		},
	},
	infected_small = {
		{
			breeds = {
				{
					name = "chaos_newly_infected",
					amount = {
						10,
						12,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_newly_infected",
					amount = {
						12,
						14,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_newly_infected",
					amount = {
						14,
						16,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_newly_infected",
					amount = {
						18,
						20,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_newly_infected",
					amount = {
						20,
						22,
					},
				},
			},
		},
	},
	renegade_elite_poxwalkers_small = {
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						10,
						12,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						12,
						14,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						14,
						16,
					},
				},
				{
					name = "renegade_berzerker",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						18,
						20,
					},
				},
				{
					name = "renegade_berzerker",
					amount = {
						1,
						2,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						20,
						22,
					},
				},
				{
					name = "renegade_berzerker",
					amount = {
						2,
						3,
					},
				},
			},
		},
	},
	renegade_medium = {
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						15,
						20,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						20,
						25,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						22,
						27,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						27,
						32,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						32,
						35,
					},
				},
			},
		},
	},
	infected_medium = {
		{
			breeds = {
				{
					name = "chaos_newly_infected",
					amount = {
						15,
						20,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_newly_infected",
					amount = {
						20,
						25,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_newly_infected",
					amount = {
						22,
						27,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_newly_infected",
					amount = {
						27,
						32,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_newly_infected",
					amount = {
						32,
						35,
					},
				},
			},
		},
	},
	renegade_large = {
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						30,
						35,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						35,
						40,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						40,
						55,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						45,
						50,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						50,
						55,
					},
				},
			},
		},
	},
	infected_large = {
		{
			breeds = {
				{
					name = "chaos_newly_infected",
					amount = {
						30,
						35,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_newly_infected",
					amount = {
						35,
						40,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_newly_infected",
					amount = {
						40,
						55,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_newly_infected",
					amount = {
						45,
						50,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_newly_infected",
					amount = {
						50,
						55,
					},
				},
			},
		},
	},
	renegade_flood = {
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						30,
						38,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						38,
						42,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						42,
						45,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						45,
						50,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						50,
						52,
					},
				},
			},
		},
	},
	renegade_trickle_riflemen = {
		{
			breeds = {
				{
					name = "renegade_rifleman",
					amount = {
						4,
						5,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_rifleman",
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
					name = "renegade_rifleman",
					amount = {
						6,
						7,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_rifleman",
					amount = {
						8,
						10,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_rifleman",
					amount = {
						10,
						12,
					},
				},
			},
		},
	},
	renegade_trickle_riflemen_high = {
		{
			breeds = {
				{
					name = "renegade_rifleman",
					amount = {
						7,
						8,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_rifleman",
					amount = {
						9,
						10,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_rifleman",
					amount = {
						11,
						13,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_rifleman",
					amount = {
						14,
						16,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_rifleman",
					amount = {
						18,
						20,
					},
				},
			},
		},
	},
	renegade_trickle_gunners = {
		{
			breeds = {
				{
					name = "renegade_rifleman",
					amount = {
						4,
						5,
					},
				},
				{
					name = "renegade_gunner",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_rifleman",
					amount = {
						5,
						6,
					},
				},
				{
					name = "renegade_gunner",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_rifleman",
					amount = {
						7,
						8,
					},
				},
				{
					name = "renegade_gunner",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_rifleman",
					amount = {
						9,
						10,
					},
				},
				{
					name = "renegade_gunner",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_rifleman",
					amount = {
						10,
						11,
					},
				},
				{
					name = "renegade_gunner",
					amount = {
						1,
						2,
					},
				},
			},
		},
	},
	renegade_trickle_ogryn_gunners = {
		{
			breeds = {
				{
					name = "renegade_rifleman",
					amount = {
						2,
						3,
					},
				},
				{
					name = "renegade_gunner",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_rifleman",
					amount = {
						4,
						5,
					},
				},
				{
					name = "chaos_ogryn_gunner",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_rifleman",
					amount = {
						5,
						6,
					},
				},
				{
					name = "chaos_ogryn_gunner",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_rifleman",
					amount = {
						6,
						7,
					},
				},
				{
					name = "chaos_ogryn_gunner",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_rifleman",
					amount = {
						7,
						8,
					},
				},
				{
					name = "chaos_ogryn_gunner",
					amount = {
						1,
						2,
					},
				},
			},
		},
	},
	renegade_trickle_assault = {
		{
			breeds = {
				{
					name = "renegade_assault",
					amount = {
						2,
						3,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_assault",
					amount = {
						3,
						4,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_assault",
					amount = {
						4,
						5,
					},
				},
			},
		},
		{
			breeds = {
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
					name = "renegade_assault",
					amount = {
						6,
						7,
					},
				},
			},
		},
	},
	renegade_trickle_melee = {
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						3,
						4,
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
						5,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_melee",
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
						6,
						7,
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
						7,
					},
				},
			},
		},
	},
	renegade_trickle_melee_elites = {
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						2,
						3,
					},
				},
				{
					name = "renegade_executor",
					amount = {
						1,
						1,
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
						5,
					},
				},
				{
					name = "renegade_executor",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						5,
						6,
					},
				},
				{
					name = "renegade_executor",
					amount = {
						1,
						1,
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
						7,
					},
				},
				{
					name = "renegade_executor",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						7,
						8,
					},
				},
				{
					name = "renegade_executor",
					amount = {
						1,
						2,
					},
				},
			},
		},
	},
	renegade_trickle_ogryn_executors = {
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						1,
						2,
					},
				},
				{
					name = "renegade_executor",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						2,
						3,
					},
				},
				{
					name = "chaos_ogryn_executor",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						3,
						4,
					},
				},
				{
					name = "chaos_ogryn_executor",
					amount = {
						1,
						1,
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
						5,
					},
				},
				{
					name = "chaos_ogryn_executor",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						5,
						6,
					},
				},
				{
					name = "chaos_ogryn_executor",
					amount = {
						1,
						1,
					},
				},
			},
		},
	},
	renegade_trickle_ogryn_bulwarks = {
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						1,
						2,
					},
				},
				{
					name = "renegade_executor",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						2,
						3,
					},
				},
				{
					name = "chaos_ogryn_bulwark",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						3,
						4,
					},
				},
				{
					name = "chaos_ogryn_bulwark",
					amount = {
						1,
						1,
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
						5,
					},
				},
				{
					name = "chaos_ogryn_bulwark",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						5,
						6,
					},
				},
				{
					name = "chaos_ogryn_bulwark",
					amount = {
						1,
						1,
					},
				},
			},
		},
	},
	renegade_melee_terror_trickle = {
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						6,
						7,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						7,
						8,
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
						9,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						9,
						10,
					},
				},
			},
		},
	},
	infected_terror_trickle = {
		{
			breeds = {
				{
					name = "chaos_newly_infected",
					amount = {
						8,
						9,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_newly_infected",
					amount = {
						9,
						10,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_newly_infected",
					amount = {
						11,
						12,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_newly_infected",
					amount = {
						13,
						14,
					},
				},
			},
		},
	},
	poxwalker_terror_trickle = {
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						8,
						9,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						9,
						10,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						11,
						12,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						13,
						14,
					},
				},
			},
		},
	},
	renegade_close_terror_trickle = {
		{
			breeds = {
				{
					name = "renegade_assault",
					amount = {
						2,
						3,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_assault",
					amount = {
						3,
						4,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_assault",
					amount = {
						4,
						5,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_assault",
					amount = {
						5,
						6,
					},
				},
			},
		},
	},
	renegade_close_terror_trickle_elite = {
		{
			breeds = {
				{
					name = "renegade_assault",
					amount = {
						4,
						5,
					},
				},
				{
					name = "renegade_shocktrooper",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_assault",
					amount = {
						5,
						6,
					},
				},
				{
					name = "renegade_shocktrooper",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_assault",
					amount = {
						6,
						7,
					},
				},
				{
					name = "renegade_shocktrooper",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_assault",
					amount = {
						8,
						9,
					},
				},
				{
					name = "renegade_shocktrooper",
					amount = {
						1,
						2,
					},
				},
			},
		},
	},
	renegade_melee_terror_trickle_elite = {
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						5,
						6,
					},
				},
				{
					name = "renegade_executor",
					amount = {
						1,
						1,
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
						7,
					},
				},
				{
					name = "renegade_executor",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						7,
						8,
					},
				},
				{
					name = "renegade_executor",
					amount = {
						1,
						1,
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
						9,
					},
				},
				{
					name = "renegade_executor",
					amount = {
						1,
						2,
					},
				},
			},
		},
	},
	renegade_melee_low_terror_trickle = {
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						2,
						3,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						3,
						4,
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
						5,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						5,
						6,
					},
				},
			},
		},
	},
	renegade_coordinated_ranged_horde = {
		{
			breeds = {
				{
					name = "renegade_rifleman",
					amount = {
						4,
						5,
					},
				},
				{
					name = "renegade_gunner",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_rifleman",
					amount = {
						5,
						6,
					},
				},
				{
					name = "renegade_gunner",
					amount = {
						1,
						2,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_rifleman",
					amount = {
						7,
						8,
					},
				},
				{
					name = "renegade_gunner",
					amount = {
						2,
						3,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_rifleman",
					amount = {
						9,
						10,
					},
				},
				{
					name = "renegade_gunner",
					amount = {
						2,
						3,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_rifleman",
					amount = {
						10,
						11,
					},
				},
				{
					name = "renegade_gunner",
					amount = {
						3,
						4,
					},
				},
			},
		},
	},
	renegade_coordinated_melee_mix = {
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						8,
						10,
					},
				},
				{
					name = "renegade_melee",
					amount = {
						4,
						5,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						10,
						12,
					},
				},
				{
					name = "renegade_melee",
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
					name = "chaos_poxwalker",
					amount = {
						12,
						14,
					},
				},
				{
					name = "renegade_melee",
					amount = {
						6,
						7,
					},
				},
				{
					name = "renegade_executor",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						14,
						16,
					},
				},
				{
					name = "renegade_melee",
					amount = {
						8,
						9,
					},
				},
				{
					name = "renegade_executor",
					amount = {
						1,
						2,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						16,
						18,
					},
				},
				{
					name = "renegade_melee",
					amount = {
						9,
						10,
					},
				},
				{
					name = "renegade_executor",
					amount = {
						2,
						3,
					},
				},
			},
		},
	},
	renegade_coordinated_melee_mix_2 = {
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						8,
						10,
					},
				},
				{
					name = "renegade_melee",
					amount = {
						4,
						5,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						10,
						12,
					},
				},
				{
					name = "renegade_melee",
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
					name = "chaos_poxwalker",
					amount = {
						12,
						14,
					},
				},
				{
					name = "renegade_melee",
					amount = {
						6,
						7,
					},
				},
				{
					name = "renegade_executor",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						14,
						16,
					},
				},
				{
					name = "renegade_melee",
					amount = {
						8,
						9,
					},
				},
				{
					name = "renegade_executor",
					amount = {
						1,
						2,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "chaos_poxwalker",
					amount = {
						16,
						18,
					},
				},
				{
					name = "renegade_melee",
					amount = {
						9,
						10,
					},
				},
				{
					name = "chaos_ogryn_executor",
					amount = {
						1,
						1,
					},
				},
			},
		},
	},
	renegade_small_coordinated_ranged_horde = {
		{
			breeds = {
				{
					name = "renegade_rifleman",
					amount = {
						4,
						5,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_rifleman",
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
					name = "renegade_rifleman",
					amount = {
						6,
						7,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_rifleman",
					amount = {
						7,
						8,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_rifleman",
					amount = {
						8,
						9,
					},
				},
			},
		},
	},
	renegade_trickle_ogryns_high_1 = {
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						1,
						2,
					},
				},
				{
					name = "renegade_executor",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						2,
						3,
					},
				},
				{
					name = "chaos_ogryn_executor",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						3,
						4,
					},
				},
				{
					name = "chaos_ogryn_executor",
					amount = {
						2,
						2,
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
						5,
					},
				},
				{
					name = "chaos_ogryn_executor",
					amount = {
						3,
						3,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						5,
						6,
					},
				},
				{
					name = "chaos_ogryn_executor",
					amount = {
						4,
						4,
					},
				},
			},
		},
	},
	renegade_trickle_ogryns_high_2 = {
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						1,
						2,
					},
				},
				{
					name = "renegade_executor",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						2,
						3,
					},
				},
				{
					name = "chaos_ogryn_bulwark",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						3,
						4,
					},
				},
				{
					name = "chaos_ogryn_bulwark",
					amount = {
						2,
						2,
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
						5,
					},
				},
				{
					name = "chaos_ogryn_bulwark",
					amount = {
						3,
						3,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						5,
						6,
					},
				},
				{
					name = "chaos_ogryn_bulwark",
					amount = {
						4,
						4,
					},
				},
			},
		},
	},
	renegade_trickle_ogryns_high_3 = {
		{
			breeds = {
				{
					name = "renegade_assault",
					amount = {
						1,
						2,
					},
				},
				{
					name = "renegade_executor",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_assault",
					amount = {
						2,
						3,
					},
				},
				{
					name = "chaos_ogryn_bulwark",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_assault",
					amount = {
						3,
						4,
					},
				},
				{
					name = "chaos_ogryn_bulwark",
					amount = {
						2,
						2,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_assault",
					amount = {
						4,
						5,
					},
				},
				{
					name = "chaos_ogryn_bulwark",
					amount = {
						3,
						3,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_assault",
					amount = {
						5,
						6,
					},
				},
				{
					name = "chaos_ogryn_bulwark",
					amount = {
						4,
						4,
					},
				},
			},
		},
	},
	renegade_trickle_ogryns_high_4 = {
		{
			breeds = {
				{
					name = "renegade_assault",
					amount = {
						1,
						2,
					},
				},
				{
					name = "renegade_executor",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_assault",
					amount = {
						2,
						3,
					},
				},
				{
					name = "chaos_ogryn_executor",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_assault",
					amount = {
						3,
						4,
					},
				},
				{
					name = "chaos_ogryn_executor",
					amount = {
						2,
						2,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_assault",
					amount = {
						4,
						5,
					},
				},
				{
					name = "chaos_ogryn_executor",
					amount = {
						3,
						3,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_assault",
					amount = {
						5,
						6,
					},
				},
				{
					name = "chaos_ogryn_executor",
					amount = {
						4,
						4,
					},
				},
			},
		},
	},
	renegade_trickle_high_1 = {
		{
			breeds = {
				{
					name = "renegade_assault",
					amount = {
						4,
						6,
					},
				},
				{
					name = "renegade_shocktrooper",
					amount = {
						2,
						2,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_assault",
					amount = {
						5,
						7,
					},
				},
				{
					name = "renegade_shocktrooper",
					amount = {
						2,
						3,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_assault",
					amount = {
						6,
						8,
					},
				},
				{
					name = "renegade_shocktrooper",
					amount = {
						4,
						5,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_assault",
					amount = {
						8,
						12,
					},
				},
				{
					name = "renegade_shocktrooper",
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
					name = "renegade_assault",
					amount = {
						10,
						14,
					},
				},
				{
					name = "renegade_shocktrooper",
					amount = {
						5,
						7,
					},
				},
			},
		},
	},
	renegade_trickle_high_2 = {
		{
			breeds = {
				{
					name = "renegade_rifleman",
					amount = {
						4,
						6,
					},
				},
				{
					name = "renegade_gunner",
					amount = {
						2,
						2,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_rifleman",
					amount = {
						5,
						7,
					},
				},
				{
					name = "renegade_gunner",
					amount = {
						2,
						3,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_rifleman",
					amount = {
						6,
						8,
					},
				},
				{
					name = "renegade_gunner",
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
					name = "renegade_rifleman",
					amount = {
						8,
						12,
					},
				},
				{
					name = "renegade_gunner",
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
					name = "renegade_rifleman",
					amount = {
						10,
						14,
					},
				},
				{
					name = "renegade_gunner",
					amount = {
						5,
						7,
					},
				},
			},
		},
	},
	twin_elite_trickle_1 = {
		{
			breeds = {
				{
					name = "renegade_assault",
					amount = {
						4,
						5,
					},
				},
				{
					name = "renegade_shocktrooper",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_assault",
					amount = {
						5,
						6,
					},
				},
				{
					name = "renegade_shocktrooper",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_assault",
					amount = {
						6,
						7,
					},
				},
				{
					name = "renegade_shocktrooper",
					amount = {
						1,
						2,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_assault",
					amount = {
						8,
						9,
					},
				},
				{
					name = "renegade_shocktrooper",
					amount = {
						2,
						3,
					},
				},
			},
		},
	},
	twin_elite_trickle_2 = {
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						4,
						5,
					},
				},
				{
					name = "renegade_executor",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						5,
						6,
					},
				},
				{
					name = "renegade_executor",
					amount = {
						1,
						1,
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
						7,
					},
				},
				{
					name = "renegade_executor",
					amount = {
						1,
						2,
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
						9,
					},
				},
				{
					name = "renegade_executor",
					amount = {
						2,
						3,
					},
				},
			},
		},
	},
	twin_elite_trickle_3 = {
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						4,
						5,
					},
				},
				{
					name = "renegade_executor",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						5,
						6,
					},
				},
				{
					name = "renegade_executor",
					amount = {
						1,
						1,
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
						7,
					},
				},
				{
					name = "renegade_executor",
					amount = {
						1,
						2,
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
						9,
					},
				},
				{
					name = "chaos_ogryn_executor",
					amount = {
						1,
						2,
					},
				},
			},
		},
	},
	twin_elite_trickle_4 = {
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						4,
						5,
					},
				},
				{
					name = "renegade_berzerker",
					amount = {
						1,
						1,
					},
				},
			},
		},
		{
			breeds = {
				{
					name = "renegade_melee",
					amount = {
						5,
						6,
					},
				},
				{
					name = "renegade_berzerker",
					amount = {
						1,
						1,
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
						7,
					},
				},
				{
					name = "renegade_berzerker",
					amount = {
						1,
						2,
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
						9,
					},
				},
				{
					name = "renegade_berzerker",
					amount = {
						2,
						3,
					},
				},
			},
		},
	},
}

return horde_compositions
