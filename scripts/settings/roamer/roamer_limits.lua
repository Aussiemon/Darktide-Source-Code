local DEFAULT_REPLACEMENTS = {
	chaos_ogryn_bulwark = {
		renegade = {
			"renegade_melee"
		},
		cultist = {
			"cultist_melee"
		}
	},
	chaos_ogryn_executor = {
		renegade = {
			"renegade_melee"
		},
		cultist = {
			"cultist_melee"
		}
	},
	chaos_ogryn_gunner = {
		renegade = {
			"renegade_melee"
		},
		cultist = {
			"cultist_melee"
		}
	},
	renegade_executor = {
		renegade = {
			"renegade_melee"
		},
		cultist = {
			"cultist_melee"
		}
	},
	renegade_berzerker = {
		renegade = {
			"renegade_melee"
		},
		cultist = {
			"cultist_melee"
		}
	},
	cultist_berzerker = {
		renegade = {
			"renegade_melee"
		},
		cultist = {
			"cultist_melee"
		}
	},
	renegade_gunner = {
		renegade = {
			"renegade_assault"
		},
		cultist = {
			"cultist_assault"
		}
	},
	cultist_gunner = {
		renegade = {
			"renegade_assault"
		},
		cultist = {
			"cultist_assault"
		}
	},
	renegade_shocktrooper = {
		renegade = {
			"renegade_assault"
		},
		cultist = {
			"cultist_assault"
		}
	},
	cultist_shocktrooper = {
		renegade = {
			"renegade_assault"
		},
		cultist = {
			"cultist_assault"
		}
	},
	chaos_newly_infected = {
		renegade = {
			"renegade_melee"
		},
		cultist = {
			"cultist_melee"
		}
	}
}
local roamer_limits = {
	none = {
		{
			chaos_ogryn_bulwark = 0,
			renegade_shocktrooper = 0,
			renegade_gunner = 0,
			chaos_ogryn_gunner = 0,
			cultist_berzerker = 0,
			cultist_shocktrooper = 0,
			cultist_gunner = 0,
			renegade_executor = 0,
			chaos_ogryn_executor = 0,
			tag_limits = {
				elite = 0,
				ogryn = 0
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			chaos_ogryn_bulwark = 0,
			renegade_shocktrooper = 1,
			renegade_gunner = 1,
			chaos_ogryn_gunner = 0,
			cultist_berzerker = 1,
			cultist_shocktrooper = 1,
			cultist_gunner = 1,
			renegade_executor = 1,
			chaos_ogryn_executor = 0,
			tag_limits = {
				elite = 0,
				ogryn = 0
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			chaos_ogryn_bulwark = 0,
			renegade_shocktrooper = 1,
			renegade_gunner = 1,
			chaos_ogryn_gunner = 0,
			cultist_berzerker = 1,
			cultist_shocktrooper = 1,
			cultist_gunner = 1,
			renegade_executor = 1,
			chaos_ogryn_executor = 1,
			tag_limits = {
				elite = 0,
				ogryn = 0
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			cultist_shocktrooper = 2,
			renegade_shocktrooper = 2,
			renegade_gunner = 2,
			cultist_berzerker = 2,
			chaos_newly_infected = 0,
			chaos_ogryn_bulwark = 1,
			chaos_ogryn_gunner = 0,
			renegade_executor = 2,
			chaos_ogryn_executor = 1,
			tag_limits = {
				elite = 0,
				ogryn = 0
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			cultist_shocktrooper = 2,
			renegade_shocktrooper = 2,
			renegade_gunner = 2,
			cultist_berzerker = 2,
			chaos_newly_infected = 0,
			chaos_ogryn_bulwark = 1,
			chaos_ogryn_gunner = 0,
			renegade_executor = 2,
			chaos_ogryn_executor = 1,
			tag_limits = {
				elite = 0,
				ogryn = 0
			},
			replacements = DEFAULT_REPLACEMENTS
		}
	},
	low = {
		{
			cultist_shocktrooper = 1,
			renegade_shocktrooper = 1,
			renegade_gunner = 1,
			chaos_ogryn_gunner = 1,
			cultist_berzerker = 1,
			chaos_ogryn_bulwark = 1,
			cultist_gunner = 1,
			renegade_berzerker = 1,
			renegade_executor = 1,
			chaos_ogryn_executor = 1,
			tag_limits = {
				elite = 1,
				ogryn = 0
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			cultist_shocktrooper = 2,
			renegade_shocktrooper = 2,
			renegade_gunner = 2,
			chaos_ogryn_gunner = 1,
			cultist_berzerker = 1,
			chaos_ogryn_bulwark = 1,
			cultist_gunner = 2,
			renegade_berzerker = 1,
			renegade_executor = 2,
			chaos_ogryn_executor = 1,
			tag_limits = {
				elite = 2,
				ogryn = 0
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			cultist_shocktrooper = 2,
			renegade_shocktrooper = 2,
			renegade_gunner = 2,
			chaos_ogryn_gunner = 1,
			cultist_berzerker = 2,
			chaos_ogryn_bulwark = 1,
			cultist_gunner = 2,
			renegade_berzerker = 2,
			renegade_executor = 2,
			chaos_ogryn_executor = 1,
			tag_limits = {
				elite = 4,
				ogryn = 1
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			cultist_shocktrooper = 2,
			renegade_shocktrooper = 3,
			renegade_gunner = 3,
			cultist_berzerker = 3,
			chaos_newly_infected = 0,
			chaos_ogryn_bulwark = 2,
			chaos_ogryn_gunner = 2,
			renegade_berzerker = 3,
			renegade_executor = 4,
			chaos_ogryn_executor = 2,
			tag_limits = {
				elite = 5,
				ogryn = 2
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			cultist_shocktrooper = 2,
			renegade_shocktrooper = 3,
			renegade_gunner = 3,
			cultist_berzerker = 4,
			chaos_newly_infected = 0,
			chaos_ogryn_bulwark = 2,
			chaos_ogryn_gunner = 2,
			renegade_berzerker = 4,
			renegade_executor = 5,
			chaos_ogryn_executor = 2,
			tag_limits = {
				elite = 7,
				ogryn = 3
			},
			replacements = DEFAULT_REPLACEMENTS
		}
	},
	high = {
		{
			cultist_shocktrooper = 2,
			renegade_shocktrooper = 2,
			renegade_gunner = 2,
			chaos_ogryn_gunner = 1,
			cultist_berzerker = 1,
			chaos_ogryn_bulwark = 1,
			cultist_gunner = 2,
			renegade_berzerker = 1,
			renegade_executor = 2,
			chaos_ogryn_executor = 1,
			tag_limits = {
				elite = 2,
				ogryn = 0
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			cultist_shocktrooper = 2,
			renegade_shocktrooper = 2,
			renegade_gunner = 2,
			chaos_ogryn_gunner = 1,
			cultist_berzerker = 2,
			chaos_ogryn_bulwark = 1,
			cultist_gunner = 2,
			renegade_berzerker = 2,
			renegade_executor = 3,
			chaos_ogryn_executor = 1,
			tag_limits = {
				elite = 2,
				ogryn = 1
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			cultist_shocktrooper = 2,
			renegade_shocktrooper = 2,
			renegade_gunner = 2,
			chaos_ogryn_gunner = 2,
			cultist_berzerker = 3,
			chaos_ogryn_bulwark = 1,
			cultist_gunner = 2,
			renegade_berzerker = 3,
			renegade_executor = 3,
			chaos_ogryn_executor = 2,
			tag_limits = {
				elite = 5,
				ogryn = 2
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			cultist_shocktrooper = 3,
			renegade_shocktrooper = 3,
			renegade_gunner = 3,
			chaos_ogryn_gunner = 2,
			cultist_berzerker = 5,
			chaos_newly_infected = 0,
			chaos_ogryn_bulwark = 2,
			cultist_gunner = 3,
			renegade_berzerker = 5,
			renegade_executor = 4,
			chaos_ogryn_executor = 2,
			tag_limits = {
				elite = 7,
				ogryn = 3
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			cultist_shocktrooper = 3,
			renegade_shocktrooper = 3,
			renegade_gunner = 3,
			chaos_ogryn_gunner = 3,
			cultist_berzerker = 5,
			chaos_newly_infected = 0,
			chaos_ogryn_bulwark = 2,
			cultist_gunner = 3,
			renegade_berzerker = 5,
			renegade_executor = 6,
			chaos_ogryn_executor = 3,
			tag_limits = {
				elite = 10,
				ogryn = 5
			},
			replacements = DEFAULT_REPLACEMENTS
		}
	}
}

return settings("RoamerLimits", roamer_limits)
