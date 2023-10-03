local roamer_melee = "cultist_melee"
local roamer_assault = "cultist_assault"
local roamer_rifleman = "cultist_assault"
local elite_berzerker = "cultist_berzerker"
local elite_gunner = "cultist_gunner"
local elite_shocktrooper = "cultist_shocktrooper"
local roamer_packs = {
	cultist_infected_mix_none = {
		{
			weight = 1,
			breeds = {
				"chaos_newly_infected"
			}
		},
		{
			weight = 2,
			breeds = {
				"chaos_poxwalker",
				"chaos_newly_infected"
			}
		},
		{
			weight = 1,
			breeds = {
				"chaos_newly_infected",
				"chaos_newly_infected",
				"chaos_poxwalker"
			}
		},
		{
			weight = 1,
			breeds = {
				"chaos_poxwalker",
				"chaos_newly_infected",
				"chaos_newly_infected",
				"chaos_newly_infected",
				"chaos_poxwalker"
			}
		}
	},
	cultist_melee_low = {
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_executor",
				elite_berzerker,
				roamer_melee,
				roamer_melee,
				roamer_melee
			}
		},
		{
			weight = 1,
			breeds = {
				"chaos_newly_infected",
				"chaos_newly_infected",
				"chaos_newly_infected",
				"chaos_newly_infected",
				"chaos_newly_infected"
			}
		},
		{
			weight = 0.5,
			breeds = {
				"chaos_ogryn_bulwark",
				"chaos_newly_infected",
				"chaos_newly_infected",
				roamer_melee,
				roamer_melee
			}
		},
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_executor",
				elite_berzerker,
				roamer_melee,
				"chaos_newly_infected",
				"chaos_newly_infected"
			}
		},
		{
			weight = 2,
			breeds = {
				"chaos_ogryn_bulwark",
				elite_berzerker,
				roamer_melee,
				roamer_melee
			}
		},
		{
			weight = 0.5,
			breeds = {
				elite_berzerker,
				elite_berzerker
			}
		},
		{
			weight = 0.1,
			breeds = {
				"chaos_ogryn_executor"
			}
		},
		{
			weight = 0.1,
			breeds = {
				"chaos_ogryn_bulwark"
			}
		}
	},
	cultist_melee_high = {
		{
			weight = 2,
			breeds = {
				elite_berzerker,
				elite_berzerker,
				elite_berzerker,
				elite_berzerker,
				elite_berzerker,
				elite_berzerker,
				roamer_melee,
				roamer_melee
			}
		},
		{
			weight = 1,
			breeds = {
				elite_berzerker,
				roamer_melee,
				roamer_melee,
				roamer_melee
			}
		},
		{
			weight = 2,
			breeds = {
				"chaos_ogryn_bulwark",
				elite_berzerker,
				roamer_melee,
				roamer_melee,
				elite_berzerker,
				roamer_melee,
				roamer_melee,
				elite_berzerker
			}
		},
		{
			weight = 2,
			breeds = {
				"chaos_ogryn_executor",
				roamer_melee,
				roamer_melee,
				roamer_melee,
				roamer_melee
			}
		},
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_bulwark",
				roamer_melee,
				roamer_melee
			}
		},
		{
			weight = 1,
			breeds = {
				elite_berzerker,
				elite_berzerker,
				elite_berzerker
			}
		},
		{
			weight = 2,
			breeds = {
				"chaos_ogryn_bulwark",
				roamer_melee,
				elite_berzerker,
				elite_berzerker
			}
		},
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_bulwark",
				roamer_melee,
				elite_berzerker,
				elite_berzerker
			}
		},
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_executor",
				"chaos_ogryn_bulwark"
			}
		},
		{
			weight = 0.5,
			breeds = {
				"chaos_ogryn_bulwark",
				roamer_melee,
				roamer_melee
			}
		}
	},
	cultist_close_low = {
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_executor",
				elite_shocktrooper,
				elite_shocktrooper,
				roamer_assault,
				roamer_assault
			}
		},
		{
			weight = 1,
			breeds = {
				roamer_assault,
				roamer_assault,
				roamer_assault,
				roamer_assault,
				roamer_assault
			}
		},
		{
			weight = 1,
			breeds = {
				elite_berzerker,
				elite_shocktrooper,
				roamer_assault,
				roamer_assault
			}
		},
		{
			weight = 2,
			breeds = {
				roamer_assault,
				roamer_assault,
				roamer_assault
			}
		},
		{
			weight = 0.5,
			breeds = {
				elite_shocktrooper,
				roamer_assault
			}
		}
	},
	cultist_close_high = {
		{
			weight = 1,
			breeds = {
				roamer_assault,
				roamer_assault,
				roamer_assault,
				roamer_assault,
				roamer_assault
			}
		},
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_bulwark",
				elite_berzerker,
				roamer_assault,
				roamer_assault,
				elite_shocktrooper,
				elite_shocktrooper
			}
		},
		{
			weight = 2,
			breeds = {
				"chaos_ogryn_executor",
				elite_shocktrooper,
				elite_shocktrooper,
				roamer_assault,
				roamer_assault
			}
		},
		{
			weight = 1,
			breeds = {
				elite_shocktrooper,
				elite_shocktrooper,
				elite_shocktrooper,
				roamer_assault,
				roamer_assault
			}
		},
		{
			weight = 2,
			breeds = {
				roamer_assault,
				roamer_assault,
				roamer_assault,
				roamer_assault,
				roamer_assault
			}
		},
		{
			weight = 0.5,
			breeds = {
				"chaos_ogryn_bulwark",
				elite_shocktrooper,
				roamer_assault,
				roamer_assault,
				roamer_assault,
				roamer_assault
			}
		},
		{
			weight = 1,
			breeds = {
				elite_shocktrooper,
				roamer_assault,
				roamer_assault,
				roamer_assault
			}
		}
	},
	cultist_far_low = {
		{
			weight = 1,
			breeds = {
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman
			}
		},
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_gunner",
				elite_gunner,
				elite_gunner,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman
			}
		},
		{
			weight = 2,
			breeds = {
				elite_gunner,
				elite_gunner,
				roamer_rifleman
			}
		},
		{
			weight = 1,
			breeds = {
				elite_gunner
			}
		},
		{
			weight = 0.5,
			breeds = {
				"chaos_ogryn_gunner",
				roamer_rifleman,
				roamer_rifleman,
				elite_gunner
			}
		},
		{
			weight = 0.5,
			breeds = {
				"chaos_ogryn_gunner"
			}
		}
	},
	cultist_far_high = {
		{
			weight = 1,
			breeds = {
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman
			}
		},
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_gunner",
				roamer_rifleman,
				roamer_rifleman,
				elite_gunner
			}
		},
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_gunner",
				elite_gunner,
				elite_gunner,
				roamer_rifleman,
				roamer_rifleman
			}
		},
		{
			weight = 0.5,
			breeds = {
				"chaos_ogryn_bulwark",
				elite_gunner,
				elite_gunner,
				"chaos_ogryn_gunner"
			}
		}
	},
	cultist_close_low_no_melee_ogryns = {
		{
			weight = 1,
			breeds = {
				elite_shocktrooper,
				roamer_assault,
				roamer_assault,
				roamer_assault
			}
		},
		{
			weight = 1,
			breeds = {
				elite_shocktrooper,
				elite_shocktrooper,
				roamer_assault,
				roamer_assault
			}
		},
		{
			weight = 1,
			breeds = {
				roamer_assault,
				roamer_assault,
				roamer_assault
			}
		},
		{
			weight = 2,
			breeds = {
				roamer_assault,
				roamer_assault,
				roamer_assault
			}
		},
		{
			weight = 0.5,
			breeds = {
				elite_shocktrooper,
				roamer_assault
			}
		}
	},
	cultist_close_high_no_melee_ogryns = {
		{
			weight = 1,
			breeds = {
				elite_shocktrooper,
				roamer_assault,
				roamer_assault,
				roamer_assault,
				roamer_assault
			}
		},
		{
			weight = 1,
			breeds = {
				roamer_assault,
				roamer_assault,
				elite_shocktrooper,
				elite_shocktrooper
			}
		},
		{
			weight = 2,
			breeds = {
				elite_shocktrooper,
				elite_shocktrooper,
				roamer_assault,
				roamer_assault
			}
		},
		{
			weight = 1,
			breeds = {
				elite_shocktrooper,
				roamer_assault,
				roamer_assault,
				roamer_assault,
				roamer_assault
			}
		},
		{
			weight = 2,
			breeds = {
				roamer_assault,
				roamer_assault,
				roamer_assault,
				roamer_assault,
				roamer_assault
			}
		},
		{
			weight = 0.5,
			breeds = {
				elite_shocktrooper,
				roamer_assault,
				roamer_assault,
				roamer_assault,
				roamer_assault
			}
		},
		{
			weight = 1,
			breeds = {
				elite_shocktrooper,
				roamer_assault,
				roamer_assault,
				roamer_assault
			}
		}
	},
	cultist_far_low_no_melee_ogryns = {
		{
			weight = 1,
			breeds = {
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman
			}
		},
		{
			weight = 1,
			breeds = {
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman
			}
		},
		{
			weight = 2,
			breeds = {
				elite_gunner,
				roamer_rifleman
			}
		},
		{
			weight = 1,
			breeds = {
				elite_gunner
			}
		},
		{
			weight = 0.5,
			breeds = {
				roamer_rifleman,
				roamer_rifleman,
				elite_gunner
			}
		},
		{
			weight = 0.5,
			breeds = {
				"chaos_ogryn_gunner"
			}
		}
	},
	cultist_far_high_no_melee_ogryns = {
		{
			weight = 1,
			breeds = {
				elite_gunner,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman
			}
		},
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_gunner",
				roamer_rifleman,
				roamer_rifleman,
				elite_gunner
			}
		},
		{
			weight = 1,
			breeds = {
				elite_gunner,
				elite_gunner,
				roamer_rifleman,
				roamer_rifleman
			}
		},
		{
			weight = 0.5,
			breeds = {
				elite_gunner,
				elite_gunner,
				"chaos_ogryn_gunner"
			}
		}
	}
}

return roamer_packs
