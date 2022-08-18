local DEFAULT_REPLACEMENTS = {
	chaos_ogryn_bulwark = {
		traitor_guards = {
			"renegade_melee"
		},
		cultists = {
			"cultist_melee"
		}
	},
	chaos_ogryn_executor = {
		traitor_guards = {
			"renegade_melee"
		},
		cultists = {
			"cultist_melee"
		}
	},
	chaos_ogryn_gunner = {
		traitor_guards = {
			"renegade_melee"
		},
		cultists = {
			"cultist_melee"
		}
	},
	renegade_executor = {
		traitor_guards = {
			"renegade_melee"
		},
		cultists = {
			"cultist_melee"
		}
	},
	cultist_berzerker = {
		traitor_guards = {
			"renegade_melee"
		},
		cultists = {
			"cultist_melee"
		}
	},
	renegade_gunner = {
		traitor_guards = {
			"renegade_assault"
		},
		cultists = {
			"cultist_assault"
		}
	},
	cultist_gunner = {
		traitor_guards = {
			"renegade_assault"
		},
		cultists = {
			"cultist_assault"
		}
	},
	renegade_shocktrooper = {
		traitor_guards = {
			"renegade_assault"
		},
		cultists = {
			"cultist_assault"
		}
	},
	cultist_shocktrooper = {
		traitor_guards = {
			"renegade_assault"
		},
		cultists = {
			"cultist_assault"
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
			chaos_ogryn_bulwark = 1,
			renegade_shocktrooper = 1,
			renegade_gunner = 1,
			chaos_ogryn_gunner = 1,
			cultist_berzerker = 1,
			cultist_shocktrooper = 1,
			cultist_gunner = 1,
			renegade_executor = 1,
			chaos_ogryn_executor = 1,
			tag_limits = {
				elite = 1,
				ogryn = 0
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			chaos_ogryn_bulwark = 1,
			renegade_shocktrooper = 2,
			renegade_gunner = 2,
			chaos_ogryn_gunner = 1,
			cultist_berzerker = 1,
			cultist_shocktrooper = 2,
			cultist_gunner = 2,
			renegade_executor = 2,
			chaos_ogryn_executor = 1,
			tag_limits = {
				elite = 2,
				ogryn = 0
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			chaos_ogryn_bulwark = 1,
			renegade_shocktrooper = 2,
			renegade_gunner = 2,
			chaos_ogryn_gunner = 1,
			cultist_berzerker = 1,
			cultist_shocktrooper = 2,
			cultist_gunner = 2,
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
			cultist_berzerker = 2,
			chaos_ogryn_bulwark = 2,
			chaos_ogryn_gunner = 2,
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
			cultist_berzerker = 3,
			chaos_ogryn_bulwark = 2,
			chaos_ogryn_gunner = 2,
			renegade_executor = 5,
			chaos_ogryn_executor = 2,
			tag_limits = {
				elite = 6,
				ogryn = 3
			},
			replacements = DEFAULT_REPLACEMENTS
		}
	},
	high = {
		{
			chaos_ogryn_bulwark = 1,
			renegade_shocktrooper = 2,
			renegade_gunner = 2,
			chaos_ogryn_gunner = 1,
			cultist_berzerker = 2,
			cultist_shocktrooper = 2,
			cultist_gunner = 2,
			renegade_executor = 2,
			chaos_ogryn_executor = 1,
			tag_limits = {
				elite = 2,
				ogryn = 0
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			chaos_ogryn_bulwark = 1,
			renegade_shocktrooper = 2,
			renegade_gunner = 2,
			chaos_ogryn_gunner = 1,
			cultist_berzerker = 2,
			cultist_shocktrooper = 2,
			cultist_gunner = 2,
			renegade_executor = 3,
			chaos_ogryn_executor = 1,
			tag_limits = {
				elite = 2,
				ogryn = 1
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			chaos_ogryn_bulwark = 1,
			renegade_shocktrooper = 2,
			renegade_gunner = 2,
			chaos_ogryn_gunner = 2,
			cultist_berzerker = 2,
			cultist_shocktrooper = 2,
			cultist_gunner = 2,
			renegade_executor = 3,
			chaos_ogryn_executor = 2,
			tag_limits = {
				elite = 5,
				ogryn = 1
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			chaos_ogryn_bulwark = 2,
			renegade_shocktrooper = 3,
			renegade_gunner = 3,
			chaos_ogryn_gunner = 2,
			cultist_berzerker = 3,
			cultist_shocktrooper = 3,
			cultist_gunner = 3,
			renegade_executor = 4,
			chaos_ogryn_executor = 2,
			tag_limits = {
				elite = 7,
				ogryn = 3
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			chaos_ogryn_bulwark = 2,
			renegade_shocktrooper = 3,
			renegade_gunner = 3,
			chaos_ogryn_gunner = 2,
			cultist_berzerker = 3,
			cultist_shocktrooper = 3,
			cultist_gunner = 3,
			renegade_executor = 4,
			chaos_ogryn_executor = 2,
			tag_limits = {
				elite = 9,
				ogryn = 4
			},
			replacements = DEFAULT_REPLACEMENTS
		}
	}
}

return settings("RoamerLimits", roamer_limits)
