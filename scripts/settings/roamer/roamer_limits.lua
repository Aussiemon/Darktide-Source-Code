﻿-- chunkname: @scripts/settings/roamer/roamer_limits.lua

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
	chaos_ogryn_gunner = {
		renegade = {
			"renegade_rifleman"
		},
		cultist = {
			"cultist_assault"
		}
	},
	renegade_gunner = {
		renegade = {
			"renegade_rifleman"
		},
		cultist = {
			"cultist_assault"
		}
	},
	cultist_gunner = {
		renegade = {
			"renegade_rifleman"
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
	},
	chaos_poxwalker = {
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
			tag_limits = {
				elite = 0,
				ogryn = 0
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			tag_limits = {
				elite = 0,
				ogryn = 0
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			tag_limits = {
				elite = 0,
				ogryn = 0
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			tag_limits = {
				elite = 0,
				ogryn = 0
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			tag_limits = {
				elite = 0,
				ogryn = 0
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			tag_limits = {
				elite = 0,
				ogryn = 0
			},
			replacements = DEFAULT_REPLACEMENTS
		}
	},
	low = {
		{
			cultist_melee = {
				extra_replacement = "cultist_berzerker",
				num_limitations_to_add_extra = 4,
				max = 3
			},
			renegade_melee = {
				extra_replacement = "renegade_executor",
				num_limitations_to_add_extra = 4,
				max = 3
			},
			renegade_assault = {
				extra_replacement = "renegade_shocktrooper",
				num_limitations_to_add_extra = 3,
				max = 3
			},
			renegade_rifleman = {
				extra_replacement = "renegade_gunner",
				num_limitations_to_add_extra = 4,
				max = 4
			},
			cultist_assault = {
				extra_replacement = "cultist_gunner",
				num_limitations_to_add_extra = 4,
				max = 4
			},
			cultist_berzerker = {
				extra_replacement = "cultist_melee",
				num_limitations_to_add_extra = 2,
				max = 1
			},
			renegade_berzerker = {
				extra_replacement = "renegade_melee",
				num_limitations_to_add_extra = 2,
				max = 1
			},
			tag_limits = {
				elite = 1,
				ogryn = 0
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			cultist_melee = {
				extra_replacement = "cultist_berzerker",
				num_limitations_to_add_extra = 4,
				max = 3
			},
			renegade_melee = {
				extra_replacement = "renegade_executor",
				num_limitations_to_add_extra = 4,
				max = 3
			},
			renegade_assault = {
				extra_replacement = "renegade_shocktrooper",
				num_limitations_to_add_extra = 3,
				max = 3
			},
			renegade_rifleman = {
				extra_replacement = "renegade_gunner",
				num_limitations_to_add_extra = 4,
				max = 4
			},
			cultist_assault = {
				extra_replacement = "cultist_gunner",
				num_limitations_to_add_extra = 4,
				max = 4
			},
			chaos_ogryn_bulwark = {
				extra_replacement = "renegade_melee",
				num_limitations_to_add_extra = 1,
				max = 1
			},
			cultist_berzerker = {
				extra_replacement = "cultist_melee",
				num_limitations_to_add_extra = 2,
				max = 1
			},
			renegade_berzerker = {
				extra_replacement = "renegade_melee",
				num_limitations_to_add_extra = 2,
				max = 1
			},
			tag_limits = {
				elite = 2,
				ogryn = 0
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			cultist_melee = {
				extra_replacement = "cultist_berzerker",
				num_limitations_to_add_extra = 4,
				max = 3
			},
			renegade_melee = {
				extra_replacement = "renegade_executor",
				num_limitations_to_add_extra = 4,
				max = 3
			},
			renegade_assault = {
				extra_replacement = "renegade_shocktrooper",
				num_limitations_to_add_extra = 3,
				max = 3
			},
			renegade_rifleman = {
				extra_replacement = "renegade_gunner",
				num_limitations_to_add_extra = 4,
				max = 5
			},
			cultist_assault = {
				extra_replacement = "cultist_gunner",
				num_limitations_to_add_extra = 4,
				max = 4
			},
			chaos_ogryn_bulwark = {
				extra_replacement = "renegade_melee",
				num_limitations_to_add_extra = 1,
				max = 1
			},
			cultist_berzerker = {
				extra_replacement = "cultist_melee",
				num_limitations_to_add_extra = 2,
				max = 2
			},
			renegade_berzerker = {
				extra_replacement = "renegade_melee",
				num_limitations_to_add_extra = 2,
				max = 2
			},
			tag_limits = {
				ogryn = 0,
				elite = {
					2,
					3
				}
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			chaos_newly_infected = 0,
			chaos_poxwalker = 0,
			cultist_melee = {
				extra_replacement = "cultist_berzerker",
				num_limitations_to_add_extra = 4,
				max = 3
			},
			renegade_melee = {
				extra_replacement = "renegade_executor",
				num_limitations_to_add_extra = 4,
				max = 3
			},
			renegade_assault = {
				extra_replacement = "renegade_shocktrooper",
				num_limitations_to_add_extra = 3,
				max = 3
			},
			renegade_rifleman = {
				extra_replacement = "renegade_gunner",
				num_limitations_to_add_extra = 4,
				max = 6
			},
			cultist_assault = {
				extra_replacement = "cultist_gunner",
				num_limitations_to_add_extra = 4,
				max = 8
			},
			chaos_ogryn_bulwark = {
				extra_replacement = "renegade_melee",
				num_limitations_to_add_extra = 1,
				max = 1
			},
			cultist_berzerker = {
				extra_replacement = "cultist_melee",
				num_limitations_to_add_extra = 2,
				max = 3
			},
			renegade_berzerker = {
				extra_replacement = "renegade_melee",
				num_limitations_to_add_extra = 2,
				max = 3
			},
			tag_limits = {
				ogryn = {
					0,
					1
				},
				elite = {
					3,
					5
				}
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			chaos_newly_infected = 0,
			chaos_poxwalker = 0,
			cultist_melee = {
				extra_replacement = "cultist_berzerker",
				num_limitations_to_add_extra = 3,
				max = 3
			},
			renegade_melee = {
				extra_replacement = "renegade_executor",
				num_limitations_to_add_extra = 3,
				max = 3
			},
			renegade_assault = {
				extra_replacement = "renegade_shocktrooper",
				num_limitations_to_add_extra = 2,
				max = 3
			},
			renegade_rifleman = {
				extra_replacement = "renegade_gunner",
				num_limitations_to_add_extra = 3,
				max = 6
			},
			cultist_assault = {
				extra_replacement = "cultist_gunner",
				num_limitations_to_add_extra = 3,
				max = 8
			},
			chaos_ogryn_bulwark = {
				extra_replacement = "renegade_melee",
				num_limitations_to_add_extra = 1,
				max = 1
			},
			cultist_berzerker = {
				extra_replacement = "cultist_melee",
				num_limitations_to_add_extra = 2,
				max = 3
			},
			renegade_berzerker = {
				extra_replacement = "renegade_melee",
				num_limitations_to_add_extra = 2,
				max = 3
			},
			tag_limits = {
				ogryn = {
					0,
					1
				},
				elite = {
					4,
					6
				}
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			chaos_newly_infected = 0,
			chaos_poxwalker = 0,
			cultist_melee = {
				extra_replacement = "cultist_berzerker",
				num_limitations_to_add_extra = 4,
				max = 3
			},
			renegade_melee = {
				extra_replacement = "renegade_executor",
				num_limitations_to_add_extra = 4,
				max = 3
			},
			renegade_assault = {
				extra_replacement = "renegade_shocktrooper",
				num_limitations_to_add_extra = 3,
				max = 2
			},
			renegade_rifleman = {
				extra_replacement = "renegade_gunner",
				num_limitations_to_add_extra = 4,
				max = 5
			},
			cultist_assault = {
				extra_replacement = "cultist_gunner",
				num_limitations_to_add_extra = 4,
				max = 4
			},
			chaos_ogryn_bulwark = {
				extra_replacement = "renegade_melee",
				num_limitations_to_add_extra = 1,
				max = 1
			},
			tag_limits = {
				elite = 8,
				ogryn = 1
			},
			replacements = DEFAULT_REPLACEMENTS
		}
	},
	high = {
		{
			cultist_melee = {
				extra_replacement = "cultist_berzerker",
				num_limitations_to_add_extra = 4,
				max = 3
			},
			renegade_melee = {
				extra_replacement = "renegade_executor",
				num_limitations_to_add_extra = 4,
				max = 3
			},
			renegade_assault = {
				extra_replacement = "renegade_shocktrooper",
				num_limitations_to_add_extra = 4,
				max = 2
			},
			renegade_rifleman = {
				extra_replacement = "renegade_gunner",
				num_limitations_to_add_extra = 4,
				max = 5
			},
			cultist_assault = {
				extra_replacement = "cultist_gunner",
				num_limitations_to_add_extra = 4,
				max = 4
			},
			cultist_berzerker = {
				extra_replacement = "cultist_melee",
				num_limitations_to_add_extra = 2,
				max = 1
			},
			renegade_berzerker = {
				extra_replacement = "renegade_melee",
				num_limitations_to_add_extra = 2,
				max = 1
			},
			tag_limits = {
				elite = 2,
				ogryn = 0
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			cultist_melee = {
				extra_replacement = "cultist_berzerker",
				num_limitations_to_add_extra = 4,
				max = 4
			},
			renegade_melee = {
				extra_replacement = "renegade_executor",
				num_limitations_to_add_extra = 4,
				max = 4
			},
			renegade_assault = {
				extra_replacement = "renegade_shocktrooper",
				num_limitations_to_add_extra = 4,
				max = 3
			},
			renegade_rifleman = {
				extra_replacement = "renegade_gunner",
				num_limitations_to_add_extra = 4,
				max = 5
			},
			cultist_assault = {
				extra_replacement = "cultist_gunner",
				num_limitations_to_add_extra = 4,
				max = 4
			},
			chaos_ogryn_bulwark = {
				extra_replacement = "renegade_melee",
				num_limitations_to_add_extra = 1,
				max = 1
			},
			cultist_berzerker = {
				extra_replacement = "cultist_melee",
				num_limitations_to_add_extra = 2,
				max = 2
			},
			renegade_berzerker = {
				extra_replacement = "renegade_melee",
				num_limitations_to_add_extra = 2,
				max = 2
			},
			tag_limits = {
				elite = 3,
				ogryn = 0
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			cultist_melee = {
				extra_replacement = "cultist_berzerker",
				num_limitations_to_add_extra = 3,
				max = 4
			},
			renegade_melee = {
				extra_replacement = "renegade_executor",
				num_limitations_to_add_extra = 3,
				max = 4
			},
			renegade_assault = {
				extra_replacement = "renegade_shocktrooper",
				num_limitations_to_add_extra = 3,
				max = 3
			},
			renegade_rifleman = {
				extra_replacement = "renegade_gunner",
				num_limitations_to_add_extra = 3,
				max = 4
			},
			cultist_assault = {
				extra_replacement = "cultist_gunner",
				num_limitations_to_add_extra = 3,
				max = 3
			},
			cultist_berzerker = {
				extra_replacement = "cultist_melee",
				num_limitations_to_add_extra = 2,
				max = 4
			},
			renegade_berzerker = {
				extra_replacement = "renegade_melee",
				num_limitations_to_add_extra = 2,
				max = 4
			},
			chaos_ogryn_bulwark = {
				extra_replacement = "renegade_melee",
				num_limitations_to_add_extra = 1,
				max = 1
			},
			tag_limits = {
				ogryn = {
					0,
					2
				},
				elite = {
					4,
					6
				}
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			chaos_newly_infected = 0,
			chaos_poxwalker = 0,
			cultist_melee = {
				extra_replacement = "cultist_berzerker",
				num_limitations_to_add_extra = 2,
				max = 5
			},
			renegade_melee = {
				extra_replacement = "renegade_executor",
				num_limitations_to_add_extra = 2,
				max = 5
			},
			renegade_assault = {
				extra_replacement = "renegade_shocktrooper",
				num_limitations_to_add_extra = 2,
				max = 5
			},
			renegade_rifleman = {
				extra_replacement = "renegade_gunner",
				num_limitations_to_add_extra = 2,
				max = 8
			},
			cultist_assault = {
				extra_replacement = "cultist_gunner",
				num_limitations_to_add_extra = 2,
				max = 10
			},
			cultist_berzerker = {
				extra_replacement = "cultist_melee",
				num_limitations_to_add_extra = 2,
				max = 4
			},
			renegade_berzerker = {
				extra_replacement = "renegade_melee",
				num_limitations_to_add_extra = 2,
				max = 4
			},
			chaos_ogryn_bulwark = {
				extra_replacement = "renegade_melee",
				num_limitations_to_add_extra = 1,
				max = 2
			},
			tag_limits = {
				ogryn = {
					1,
					3
				},
				elite = {
					5,
					7
				}
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			chaos_newly_infected = 0,
			chaos_poxwalker = 0,
			cultist_melee = {
				extra_replacement = "cultist_berzerker",
				num_limitations_to_add_extra = 2,
				max = 5
			},
			renegade_melee = {
				extra_replacement = "renegade_executor",
				num_limitations_to_add_extra = 2,
				max = 5
			},
			renegade_assault = {
				extra_replacement = "renegade_shocktrooper",
				num_limitations_to_add_extra = 2,
				max = 5
			},
			renegade_rifleman = {
				extra_replacement = "renegade_gunner",
				num_limitations_to_add_extra = 2,
				max = 9
			},
			cultist_assault = {
				extra_replacement = "cultist_gunner",
				num_limitations_to_add_extra = 2,
				max = 11
			},
			chaos_ogryn_bulwark = {
				extra_replacement = "renegade_melee",
				num_limitations_to_add_extra = 1,
				max = 2
			},
			cultist_berzerker = {
				extra_replacement = "cultist_melee",
				num_limitations_to_add_extra = 2,
				max = 5
			},
			renegade_berzerker = {
				extra_replacement = "renegade_melee",
				num_limitations_to_add_extra = 2,
				max = 5
			},
			tag_limits = {
				ogryn = {
					2,
					4
				},
				elite = {
					6,
					8
				}
			},
			replacements = DEFAULT_REPLACEMENTS
		},
		{
			chaos_newly_infected = 0,
			chaos_poxwalker = 0,
			cultist_melee = {
				extra_replacement = "cultist_berzerker",
				num_limitations_to_add_extra = 3,
				max = 4
			},
			renegade_melee = {
				extra_replacement = "renegade_executor",
				num_limitations_to_add_extra = 3,
				max = 4
			},
			renegade_assault = {
				extra_replacement = "renegade_shocktrooper",
				num_limitations_to_add_extra = 3,
				max = 5
			},
			renegade_rifleman = {
				extra_replacement = "renegade_gunner",
				num_limitations_to_add_extra = 3,
				max = 8
			},
			cultist_assault = {
				extra_replacement = "cultist_gunner",
				num_limitations_to_add_extra = 3,
				max = 7
			},
			chaos_ogryn_bulwark = {
				extra_replacement = "renegade_melee",
				num_limitations_to_add_extra = 1,
				max = 3
			},
			tag_limits = {
				elite = 20,
				ogryn = 5
			},
			replacements = DEFAULT_REPLACEMENTS
		}
	}
}

return settings("RoamerLimits", roamer_limits)
