-- chunkname: @scripts/managers/pacing/horde_pacing/compositions/cultist_horde_compositions.lua

local horde_compositions = {
	cultist_trickle_assaulters = {
		{
			breeds = {
				{
					name = "cultist_assault",
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
					name = "cultist_assault",
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
					name = "cultist_assault",
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
					name = "cultist_assault",
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
					name = "cultist_assault",
					amount = {
						10,
						11,
					},
				},
			},
		},
	},
	cultist_trickle_assaulters_high = {
		{
			breeds = {
				{
					name = "cultist_assault",
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
					name = "cultist_assault",
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
					name = "cultist_assault",
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
					name = "cultist_assault",
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
					name = "cultist_assault",
					amount = {
						18,
						20,
					},
				},
			},
		},
	},
	cultist_trickle_melee = {
		{
			breeds = {
				{
					name = "cultist_melee",
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
					name = "cultist_melee",
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
					name = "cultist_melee",
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
					name = "cultist_melee",
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
					name = "cultist_melee",
					amount = {
						6,
						7,
					},
				},
			},
		},
	},
	cultist_trickle_gunners = {
		{
			breeds = {
				{
					name = "cultist_assault",
					amount = {
						4,
						5,
					},
				},
				{
					name = "cultist_gunner",
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
					name = "cultist_assault",
					amount = {
						5,
						6,
					},
				},
				{
					name = "cultist_gunner",
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
					name = "cultist_assault",
					amount = {
						7,
						8,
					},
				},
				{
					name = "cultist_gunner",
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
					name = "cultist_assault",
					amount = {
						9,
						10,
					},
				},
				{
					name = "cultist_gunner",
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
					name = "cultist_assault",
					amount = {
						10,
						11,
					},
				},
				{
					name = "cultist_gunner",
					amount = {
						1,
						2,
					},
				},
			},
		},
	},
	cultist_trickle_ogryn_gunners = {
		{
			breeds = {
				{
					name = "cultist_assault",
					amount = {
						2,
						3,
					},
				},
				{
					name = "cultist_gunner",
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
					name = "cultist_assault",
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
					name = "cultist_assault",
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
					name = "cultist_assault",
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
					name = "cultist_assault",
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
	cultist_trickle_melee_elites = {
		{
			breeds = {
				{
					name = "cultist_melee",
					amount = {
						2,
						3,
					},
				},
				{
					name = "cultist_berzerker",
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
					name = "cultist_melee",
					amount = {
						4,
						5,
					},
				},
				{
					name = "cultist_berzerker",
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
					name = "cultist_melee",
					amount = {
						5,
						6,
					},
				},
				{
					name = "cultist_berzerker",
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
					name = "cultist_melee",
					amount = {
						6,
						7,
					},
				},
				{
					name = "cultist_berzerker",
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
					name = "cultist_melee",
					amount = {
						7,
						8,
					},
				},
				{
					name = "cultist_berzerker",
					amount = {
						1,
						2,
					},
				},
			},
		},
	},
	cultist_trickle_ogryn_executors = {
		{
			breeds = {
				{
					name = "cultist_melee",
					amount = {
						1,
						2,
					},
				},
				{
					name = "cultist_berzerker",
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
					name = "cultist_melee",
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
					name = "cultist_melee",
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
					name = "cultist_melee",
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
					name = "cultist_melee",
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
	cultist_trickle_ogryn_bulwarks = {
		{
			breeds = {
				{
					name = "cultist_melee",
					amount = {
						1,
						2,
					},
				},
				{
					name = "cultist_berzerker",
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
					name = "cultist_melee",
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
					name = "cultist_melee",
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
					name = "cultist_melee",
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
					name = "cultist_melee",
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
	cultist_melee_low_terror_trickle = {
		{
			breeds = {
				{
					name = "cultist_melee",
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
					name = "cultist_melee",
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
					name = "cultist_melee",
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
					name = "cultist_melee",
					amount = {
						8,
						9,
					},
				},
			},
		},
	},
	cultist_melee_terror_trickle = {
		{
			breeds = {
				{
					name = "cultist_melee",
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
					name = "cultist_melee",
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
					name = "cultist_melee",
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
					name = "cultist_melee",
					amount = {
						9,
						10,
					},
				},
			},
		},
	},
	cultist_close_terror_trickle = {
		{
			breeds = {
				{
					name = "cultist_assault",
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
					name = "cultist_assault",
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
					name = "cultist_assault",
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
					name = "cultist_assault",
					amount = {
						5,
						6,
					},
				},
			},
		},
	},
	cultist_close_terror_trickle_elite = {
		{
			breeds = {
				{
					name = "cultist_assault",
					amount = {
						4,
						5,
					},
				},
				{
					name = "cultist_shocktrooper",
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
					name = "cultist_assault",
					amount = {
						5,
						6,
					},
				},
				{
					name = "cultist_shocktrooper",
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
					name = "cultist_assault",
					amount = {
						6,
						7,
					},
				},
				{
					name = "cultist_shocktrooper",
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
					name = "cultist_assault",
					amount = {
						8,
						9,
					},
				},
				{
					name = "cultist_shocktrooper",
					amount = {
						1,
						2,
					},
				},
			},
		},
	},
	cultist_melee_terror_trickle_elite = {
		{
			breeds = {
				{
					name = "cultist_melee",
					amount = {
						5,
						6,
					},
				},
				{
					name = "cultist_berzerker",
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
					name = "cultist_melee",
					amount = {
						6,
						7,
					},
				},
				{
					name = "cultist_berzerker",
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
					name = "cultist_melee",
					amount = {
						7,
						8,
					},
				},
				{
					name = "cultist_berzerker",
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
					name = "cultist_melee",
					amount = {
						8,
						9,
					},
				},
				{
					name = "cultist_berzerker",
					amount = {
						1,
						2,
					},
				},
			},
		},
	},
	cultist_coordinated_ranged_horde = {
		{
			breeds = {
				{
					name = "cultist_assault",
					amount = {
						4,
						5,
					},
				},
				{
					name = "cultist_gunner",
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
					name = "cultist_assault",
					amount = {
						5,
						6,
					},
				},
				{
					name = "cultist_gunner",
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
					name = "cultist_assault",
					amount = {
						7,
						8,
					},
				},
				{
					name = "cultist_gunner",
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
					name = "cultist_assault",
					amount = {
						9,
						10,
					},
				},
				{
					name = "cultist_gunner",
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
					name = "cultist_assault",
					amount = {
						10,
						11,
					},
				},
				{
					name = "cultist_gunner",
					amount = {
						3,
						4,
					},
				},
			},
		},
	},
	cultist_coordinated_melee_mix = {
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
					name = "cultist_melee",
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
					name = "cultist_melee",
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
					name = "cultist_melee",
					amount = {
						6,
						7,
					},
				},
				{
					name = "cultist_berzerker",
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
					name = "cultist_melee",
					amount = {
						8,
						9,
					},
				},
				{
					name = "cultist_berzerker",
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
					name = "cultist_melee",
					amount = {
						9,
						10,
					},
				},
				{
					name = "cultist_berzerker",
					amount = {
						2,
						3,
					},
				},
			},
		},
	},
	cultist_coordinated_melee_mix_2 = {
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
					name = "cultist_melee",
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
					name = "cultist_melee",
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
					name = "cultist_melee",
					amount = {
						6,
						7,
					},
				},
				{
					name = "cultist_berzerker",
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
					name = "cultist_melee",
					amount = {
						8,
						9,
					},
				},
				{
					name = "cultist_berzerker",
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
					name = "cultist_melee",
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
	cultist_small_coordinated_ranged_horde = {
		{
			breeds = {
				{
					name = "cultist_assault",
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
					name = "cultist_assault",
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
					name = "cultist_assault",
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
					name = "cultist_assault",
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
					name = "cultist_assault",
					amount = {
						8,
						9,
					},
				},
			},
		},
	},
	cultist_trickle_ogryns_high_1 = {
		{
			breeds = {
				{
					name = "cultist_melee",
					amount = {
						1,
						2,
					},
				},
				{
					name = "cultist_berzerker",
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
					name = "cultist_melee",
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
					name = "cultist_melee",
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
					name = "cultist_melee",
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
					name = "cultist_melee",
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
	cultist_trickle_ogryns_high_2 = {
		{
			breeds = {
				{
					name = "cultist_melee",
					amount = {
						1,
						2,
					},
				},
				{
					name = "cultist_berzerker",
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
					name = "cultist_melee",
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
					name = "cultist_melee",
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
					name = "cultist_melee",
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
					name = "cultist_melee",
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
	cultist_trickle_ogryns_high_3 = {
		{
			breeds = {
				{
					name = "cultist_assault",
					amount = {
						1,
						2,
					},
				},
				{
					name = "cultist_berzerker",
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
					name = "cultist_assault",
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
					name = "cultist_assault",
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
					name = "cultist_assault",
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
					name = "cultist_assault",
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
	cultist_trickle_ogryns_high_4 = {
		{
			breeds = {
				{
					name = "cultist_assault",
					amount = {
						1,
						2,
					},
				},
				{
					name = "cultist_berzerker",
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
					name = "cultist_assault",
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
					name = "cultist_assault",
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
					name = "cultist_assault",
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
					name = "cultist_assault",
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
	cultist_trickle_high_1 = {
		{
			breeds = {
				{
					name = "cultist_assault",
					amount = {
						4,
						6,
					},
				},
				{
					name = "cultist_shocktrooper",
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
					name = "cultist_assault",
					amount = {
						5,
						7,
					},
				},
				{
					name = "cultist_shocktrooper",
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
					name = "cultist_assault",
					amount = {
						6,
						8,
					},
				},
				{
					name = "cultist_shocktrooper",
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
					name = "cultist_assault",
					amount = {
						8,
						12,
					},
				},
				{
					name = "cultist_shocktrooper",
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
					name = "cultist_assault",
					amount = {
						10,
						14,
					},
				},
				{
					name = "cultist_shocktrooper",
					amount = {
						5,
						7,
					},
				},
			},
		},
	},
	cultist_trickle_high_2 = {
		{
			breeds = {
				{
					name = "cultist_assault",
					amount = {
						4,
						6,
					},
				},
				{
					name = "cultist_gunner",
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
					name = "cultist_assault",
					amount = {
						5,
						7,
					},
				},
				{
					name = "cultist_gunner",
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
					name = "cultist_assault",
					amount = {
						6,
						8,
					},
				},
				{
					name = "cultist_gunner",
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
					name = "cultist_assault",
					amount = {
						8,
						12,
					},
				},
				{
					name = "cultist_gunner",
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
					name = "cultist_assault",
					amount = {
						10,
						14,
					},
				},
				{
					name = "cultist_gunner",
					amount = {
						5,
						7,
					},
				},
			},
		},
	},
	cultist_elite_poxwalkers_small = {
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
					name = "cultist_berzerker",
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
					name = "cultist_berzerker",
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
					name = "cultist_berzerker",
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
