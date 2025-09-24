-- chunkname: @scripts/settings/roamer/roamer_limits.lua

local DEFAULT_REPLACEMENTS = {
	chaos_ogryn_bulwark = {
		renegade = {
			"renegade_melee",
		},
		cultist = {
			"cultist_melee",
		},
	},
	chaos_ogryn_executor = {
		renegade = {
			"renegade_melee",
		},
		cultist = {
			"cultist_melee",
		},
	},
	renegade_executor = {
		renegade = {
			"renegade_melee",
		},
		cultist = {
			"cultist_melee",
		},
	},
	renegade_berzerker = {
		renegade = {
			"renegade_melee",
		},
		cultist = {
			"cultist_melee",
		},
	},
	cultist_berzerker = {
		renegade = {
			"renegade_melee",
		},
		cultist = {
			"cultist_melee",
		},
	},
	chaos_ogryn_gunner = {
		renegade = {
			"renegade_rifleman",
		},
		cultist = {
			"cultist_assault",
		},
	},
	renegade_gunner = {
		renegade = {
			"renegade_rifleman",
		},
		cultist = {
			"cultist_assault",
		},
	},
	cultist_gunner = {
		renegade = {
			"renegade_rifleman",
		},
		cultist = {
			"cultist_assault",
		},
	},
	renegade_shocktrooper = {
		renegade = {
			"renegade_assault",
		},
		cultist = {
			"cultist_assault",
		},
	},
	renegade_plasma_gunner = {
		renegade = {
			"renegade_assault",
		},
		cultist = {
			"cultist_assault",
		},
	},
	cultist_shocktrooper = {
		renegade = {
			"renegade_assault",
		},
		cultist = {
			"cultist_assault",
		},
	},
	chaos_newly_infected = {
		renegade = {
			"renegade_melee",
		},
		cultist = {
			"cultist_melee",
		},
	},
	chaos_poxwalker = {
		renegade = {
			"renegade_melee",
		},
		cultist = {
			"cultist_melee",
		},
	},
}
local roamer_limits = {
	none = {
		{
			tag_limits = {
				elite = 0,
				ogryn = 0,
			},
			replacements = DEFAULT_REPLACEMENTS,
		},
		{
			tag_limits = {
				elite = 0,
				ogryn = 0,
			},
			replacements = DEFAULT_REPLACEMENTS,
		},
		{
			tag_limits = {
				elite = 0,
				ogryn = 0,
			},
			replacements = DEFAULT_REPLACEMENTS,
		},
		{
			tag_limits = {
				elite = 0,
				ogryn = 0,
			},
			replacements = DEFAULT_REPLACEMENTS,
		},
		{
			tag_limits = {
				elite = 0,
				ogryn = 0,
			},
			replacements = DEFAULT_REPLACEMENTS,
		},
		{
			tag_limits = {
				elite = 0,
				ogryn = 0,
			},
			replacements = DEFAULT_REPLACEMENTS,
		},
	},
	low = {
		{
			cultist_melee = {
				extra_replacement = "cultist_berzerker",
				max = 3,
				num_limitations_to_add_extra = 4,
			},
			renegade_melee = {
				extra_replacement = "renegade_executor",
				max = 3,
				num_limitations_to_add_extra = 4,
			},
			renegade_assault = {
				extra_replacement = "renegade_shocktrooper",
				max = 3,
				num_limitations_to_add_extra = 3,
			},
			renegade_rifleman = {
				extra_replacement = "renegade_gunner",
				max = 4,
				num_limitations_to_add_extra = 4,
			},
			cultist_assault = {
				extra_replacement = "cultist_gunner",
				max = 4,
				num_limitations_to_add_extra = 4,
			},
			cultist_berzerker = {
				extra_replacement = "cultist_melee",
				max = 1,
				num_limitations_to_add_extra = 2,
			},
			renegade_berzerker = {
				extra_replacement = "renegade_melee",
				max = 1,
				num_limitations_to_add_extra = 2,
			},
			chaos_ogryn_executor = {
				extra_replacement = "renegade_melee",
				max = 1,
				num_limitations_to_add_extra = 1,
			},
			tag_limits = {
				elite = 1,
				ogryn = 0,
			},
			replacements = DEFAULT_REPLACEMENTS,
		},
		{
			cultist_melee = {
				extra_replacement = "cultist_berzerker",
				max = 3,
				num_limitations_to_add_extra = 4,
			},
			renegade_melee = {
				extra_replacement = "renegade_executor",
				max = 3,
				num_limitations_to_add_extra = 4,
			},
			renegade_assault = {
				extra_replacement = "renegade_shocktrooper",
				max = 3,
				num_limitations_to_add_extra = 3,
			},
			renegade_rifleman = {
				extra_replacement = "renegade_gunner",
				max = 4,
				num_limitations_to_add_extra = 4,
			},
			cultist_assault = {
				extra_replacement = "cultist_gunner",
				max = 4,
				num_limitations_to_add_extra = 4,
			},
			chaos_ogryn_bulwark = {
				extra_replacement = "renegade_melee",
				max = 1,
				num_limitations_to_add_extra = 1,
			},
			cultist_berzerker = {
				extra_replacement = "cultist_melee",
				max = 1,
				num_limitations_to_add_extra = 2,
			},
			renegade_berzerker = {
				extra_replacement = "renegade_melee",
				max = 1,
				num_limitations_to_add_extra = 2,
			},
			chaos_ogryn_executor = {
				extra_replacement = "renegade_melee",
				max = 1,
				num_limitations_to_add_extra = 1,
			},
			tag_limits = {
				elite = 2,
				ogryn = 0,
			},
			replacements = DEFAULT_REPLACEMENTS,
		},
		{
			cultist_melee = {
				extra_replacement = "cultist_berzerker",
				max = 3,
				num_limitations_to_add_extra = 4,
			},
			renegade_melee = {
				extra_replacement = "renegade_executor",
				max = 3,
				num_limitations_to_add_extra = 4,
			},
			renegade_assault = {
				extra_replacement = "renegade_shocktrooper",
				max = 3,
				num_limitations_to_add_extra = 3,
			},
			renegade_rifleman = {
				extra_replacement = "renegade_gunner",
				max = 5,
				num_limitations_to_add_extra = 4,
			},
			cultist_assault = {
				extra_replacement = "cultist_gunner",
				max = 4,
				num_limitations_to_add_extra = 4,
			},
			chaos_ogryn_bulwark = {
				extra_replacement = "renegade_melee",
				max = 1,
				num_limitations_to_add_extra = 1,
			},
			cultist_berzerker = {
				extra_replacement = "cultist_melee",
				max = 2,
				num_limitations_to_add_extra = 2,
			},
			renegade_berzerker = {
				extra_replacement = "renegade_melee",
				max = 2,
				num_limitations_to_add_extra = 2,
			},
			chaos_ogryn_executor = {
				extra_replacement = "renegade_melee",
				max = 1,
				num_limitations_to_add_extra = 1,
			},
			tag_limits = {
				ogryn = 0,
				elite = {
					2,
					3,
				},
			},
			replacements = DEFAULT_REPLACEMENTS,
		},
		{
			chaos_newly_infected = 0,
			chaos_poxwalker = 0,
			cultist_melee = {
				extra_replacement = "cultist_berzerker",
				max = 3,
				num_limitations_to_add_extra = 4,
			},
			renegade_melee = {
				extra_replacement = "renegade_executor",
				max = 3,
				num_limitations_to_add_extra = 4,
			},
			renegade_assault = {
				extra_replacement = "renegade_shocktrooper",
				max = 3,
				num_limitations_to_add_extra = 3,
			},
			renegade_rifleman = {
				extra_replacement = "renegade_gunner",
				max = 6,
				num_limitations_to_add_extra = 4,
			},
			cultist_assault = {
				extra_replacement = "cultist_gunner",
				max = 8,
				num_limitations_to_add_extra = 4,
			},
			chaos_ogryn_bulwark = {
				extra_replacement = "renegade_melee",
				max = 1,
				num_limitations_to_add_extra = 1,
			},
			cultist_berzerker = {
				extra_replacement = "cultist_melee",
				max = 3,
				num_limitations_to_add_extra = 2,
			},
			renegade_berzerker = {
				extra_replacement = "renegade_melee",
				max = 3,
				num_limitations_to_add_extra = 2,
			},
			chaos_ogryn_executor = {
				extra_replacement = "renegade_melee",
				max = 2,
				num_limitations_to_add_extra = 1,
			},
			tag_limits = {
				ogryn = {
					0,
					1,
				},
				elite = {
					3,
					5,
				},
			},
			replacements = DEFAULT_REPLACEMENTS,
		},
		{
			chaos_newly_infected = 0,
			chaos_poxwalker = 0,
			cultist_melee = {
				extra_replacement = "cultist_berzerker",
				max = 3,
				num_limitations_to_add_extra = 3,
			},
			renegade_melee = {
				extra_replacement = "renegade_executor",
				max = 3,
				num_limitations_to_add_extra = 3,
			},
			renegade_assault = {
				extra_replacement = "renegade_shocktrooper",
				max = 3,
				num_limitations_to_add_extra = 2,
			},
			renegade_rifleman = {
				extra_replacement = "renegade_gunner",
				max = 6,
				num_limitations_to_add_extra = 3,
			},
			cultist_assault = {
				extra_replacement = "cultist_gunner",
				max = 8,
				num_limitations_to_add_extra = 3,
			},
			chaos_ogryn_bulwark = {
				extra_replacement = "renegade_melee",
				max = 1,
				num_limitations_to_add_extra = 1,
			},
			cultist_berzerker = {
				extra_replacement = "cultist_melee",
				max = 3,
				num_limitations_to_add_extra = 2,
			},
			renegade_berzerker = {
				extra_replacement = "renegade_melee",
				max = 3,
				num_limitations_to_add_extra = 2,
			},
			chaos_ogryn_executor = {
				extra_replacement = "renegade_melee",
				max = 2,
				num_limitations_to_add_extra = 1,
			},
			tag_limits = {
				ogryn = {
					0,
					1,
				},
				elite = {
					4,
					6,
				},
			},
			replacements = DEFAULT_REPLACEMENTS,
		},
		{
			chaos_newly_infected = 0,
			chaos_poxwalker = 0,
			cultist_melee = {
				extra_replacement = "cultist_berzerker",
				max = 3,
				num_limitations_to_add_extra = 4,
			},
			renegade_melee = {
				extra_replacement = "renegade_executor",
				max = 3,
				num_limitations_to_add_extra = 4,
			},
			renegade_assault = {
				extra_replacement = "renegade_shocktrooper",
				max = 2,
				num_limitations_to_add_extra = 3,
			},
			renegade_rifleman = {
				extra_replacement = "renegade_gunner",
				max = 5,
				num_limitations_to_add_extra = 4,
			},
			cultist_assault = {
				extra_replacement = "cultist_gunner",
				max = 4,
				num_limitations_to_add_extra = 4,
			},
			chaos_ogryn_bulwark = {
				extra_replacement = "renegade_melee",
				max = 1,
				num_limitations_to_add_extra = 1,
			},
			chaos_ogryn_executor = {
				extra_replacement = "renegade_melee",
				max = 2,
				num_limitations_to_add_extra = 1,
			},
			tag_limits = {
				elite = 8,
				ogryn = 1,
			},
			replacements = DEFAULT_REPLACEMENTS,
		},
	},
	high = {
		{
			cultist_melee = {
				extra_replacement = "cultist_berzerker",
				max = 3,
				num_limitations_to_add_extra = 4,
			},
			renegade_melee = {
				extra_replacement = "renegade_executor",
				max = 3,
				num_limitations_to_add_extra = 4,
			},
			renegade_assault = {
				extra_replacement = "renegade_shocktrooper",
				max = 2,
				num_limitations_to_add_extra = 4,
			},
			renegade_rifleman = {
				extra_replacement = "renegade_gunner",
				max = 5,
				num_limitations_to_add_extra = 4,
			},
			cultist_assault = {
				extra_replacement = "cultist_gunner",
				max = 4,
				num_limitations_to_add_extra = 4,
			},
			cultist_berzerker = {
				extra_replacement = "cultist_melee",
				max = 1,
				num_limitations_to_add_extra = 2,
			},
			renegade_berzerker = {
				extra_replacement = "renegade_melee",
				max = 1,
				num_limitations_to_add_extra = 2,
			},
			chaos_ogryn_executor = {
				extra_replacement = "renegade_melee",
				max = 1,
				num_limitations_to_add_extra = 1,
			},
			tag_limits = {
				elite = 2,
				ogryn = 0,
			},
			replacements = DEFAULT_REPLACEMENTS,
		},
		{
			cultist_melee = {
				extra_replacement = "cultist_berzerker",
				max = 4,
				num_limitations_to_add_extra = 4,
			},
			renegade_melee = {
				extra_replacement = "renegade_executor",
				max = 4,
				num_limitations_to_add_extra = 4,
			},
			renegade_assault = {
				extra_replacement = "renegade_shocktrooper",
				max = 3,
				num_limitations_to_add_extra = 4,
			},
			renegade_rifleman = {
				extra_replacement = "renegade_gunner",
				max = 5,
				num_limitations_to_add_extra = 4,
			},
			cultist_assault = {
				extra_replacement = "cultist_gunner",
				max = 4,
				num_limitations_to_add_extra = 4,
			},
			chaos_ogryn_bulwark = {
				extra_replacement = "renegade_melee",
				max = 1,
				num_limitations_to_add_extra = 1,
			},
			cultist_berzerker = {
				extra_replacement = "cultist_melee",
				max = 2,
				num_limitations_to_add_extra = 2,
			},
			renegade_berzerker = {
				extra_replacement = "renegade_melee",
				max = 2,
				num_limitations_to_add_extra = 2,
			},
			chaos_ogryn_executor = {
				extra_replacement = "renegade_melee",
				max = 1,
				num_limitations_to_add_extra = 1,
			},
			tag_limits = {
				elite = 3,
				ogryn = 0,
			},
			replacements = DEFAULT_REPLACEMENTS,
		},
		{
			cultist_melee = {
				extra_replacement = "cultist_berzerker",
				max = 4,
				num_limitations_to_add_extra = 3,
			},
			renegade_melee = {
				extra_replacement = "renegade_executor",
				max = 4,
				num_limitations_to_add_extra = 3,
			},
			renegade_assault = {
				extra_replacement = "renegade_shocktrooper",
				max = 3,
				num_limitations_to_add_extra = 3,
			},
			renegade_rifleman = {
				extra_replacement = "renegade_gunner",
				max = 4,
				num_limitations_to_add_extra = 3,
			},
			cultist_assault = {
				extra_replacement = "cultist_gunner",
				max = 3,
				num_limitations_to_add_extra = 3,
			},
			cultist_berzerker = {
				extra_replacement = "cultist_melee",
				max = 4,
				num_limitations_to_add_extra = 2,
			},
			renegade_berzerker = {
				extra_replacement = "renegade_melee",
				max = 4,
				num_limitations_to_add_extra = 2,
			},
			chaos_ogryn_bulwark = {
				extra_replacement = "renegade_melee",
				max = 1,
				num_limitations_to_add_extra = 1,
			},
			chaos_ogryn_executor = {
				extra_replacement = "renegade_melee",
				max = 2,
				num_limitations_to_add_extra = 1,
			},
			tag_limits = {
				ogryn = {
					0,
					2,
				},
				elite = {
					4,
					6,
				},
			},
			replacements = DEFAULT_REPLACEMENTS,
		},
		{
			chaos_newly_infected = 0,
			chaos_poxwalker = 0,
			cultist_melee = {
				extra_replacement = "cultist_berzerker",
				max = 5,
				num_limitations_to_add_extra = 2,
			},
			renegade_melee = {
				extra_replacement = "renegade_executor",
				max = 5,
				num_limitations_to_add_extra = 2,
			},
			renegade_assault = {
				extra_replacement = "renegade_shocktrooper",
				max = 5,
				num_limitations_to_add_extra = 2,
			},
			renegade_rifleman = {
				extra_replacement = "renegade_gunner",
				max = 8,
				num_limitations_to_add_extra = 2,
			},
			cultist_assault = {
				extra_replacement = "cultist_gunner",
				max = 10,
				num_limitations_to_add_extra = 2,
			},
			cultist_berzerker = {
				extra_replacement = "cultist_melee",
				max = 4,
				num_limitations_to_add_extra = 2,
			},
			renegade_berzerker = {
				extra_replacement = "renegade_melee",
				max = 4,
				num_limitations_to_add_extra = 2,
			},
			chaos_ogryn_bulwark = {
				extra_replacement = "renegade_melee",
				max = 2,
				num_limitations_to_add_extra = 1,
			},
			chaos_ogryn_executor = {
				extra_replacement = "renegade_melee",
				max = 3,
				num_limitations_to_add_extra = 1,
			},
			tag_limits = {
				ogryn = {
					1,
					3,
				},
				elite = {
					5,
					7,
				},
			},
			replacements = DEFAULT_REPLACEMENTS,
		},
		{
			chaos_newly_infected = 0,
			chaos_poxwalker = 0,
			cultist_melee = {
				extra_replacement = "cultist_berzerker",
				max = 5,
				num_limitations_to_add_extra = 2,
			},
			renegade_melee = {
				extra_replacement = "renegade_executor",
				max = 5,
				num_limitations_to_add_extra = 2,
			},
			renegade_assault = {
				extra_replacement = "renegade_shocktrooper",
				max = 5,
				num_limitations_to_add_extra = 2,
			},
			renegade_rifleman = {
				extra_replacement = "renegade_gunner",
				max = 9,
				num_limitations_to_add_extra = 2,
			},
			cultist_assault = {
				extra_replacement = "cultist_gunner",
				max = 11,
				num_limitations_to_add_extra = 2,
			},
			chaos_ogryn_bulwark = {
				extra_replacement = "renegade_melee",
				max = 2,
				num_limitations_to_add_extra = 1,
			},
			cultist_berzerker = {
				extra_replacement = "cultist_melee",
				max = 5,
				num_limitations_to_add_extra = 2,
			},
			renegade_berzerker = {
				extra_replacement = "renegade_melee",
				max = 5,
				num_limitations_to_add_extra = 2,
			},
			chaos_ogryn_executor = {
				extra_replacement = "renegade_melee",
				max = 4,
				num_limitations_to_add_extra = 1,
			},
			tag_limits = {
				ogryn = {
					2,
					4,
				},
				elite = {
					6,
					8,
				},
			},
			replacements = DEFAULT_REPLACEMENTS,
		},
		{
			chaos_newly_infected = 0,
			chaos_poxwalker = 0,
			cultist_melee = {
				extra_replacement = "cultist_berzerker",
				max = 4,
				num_limitations_to_add_extra = 3,
			},
			renegade_melee = {
				extra_replacement = "renegade_executor",
				max = 4,
				num_limitations_to_add_extra = 3,
			},
			renegade_assault = {
				extra_replacement = "renegade_shocktrooper",
				max = 5,
				num_limitations_to_add_extra = 3,
			},
			renegade_rifleman = {
				extra_replacement = "renegade_gunner",
				max = 8,
				num_limitations_to_add_extra = 3,
			},
			cultist_assault = {
				extra_replacement = "cultist_gunner",
				max = 7,
				num_limitations_to_add_extra = 3,
			},
			chaos_ogryn_bulwark = {
				extra_replacement = "renegade_melee",
				max = 3,
				num_limitations_to_add_extra = 1,
			},
			chaos_ogryn_executor = {
				extra_replacement = "renegade_melee",
				max = 4,
				num_limitations_to_add_extra = 1,
			},
			tag_limits = {
				elite = 20,
				ogryn = 5,
			},
			replacements = DEFAULT_REPLACEMENTS,
		},
	},
}

return settings("RoamerLimits", roamer_limits)
