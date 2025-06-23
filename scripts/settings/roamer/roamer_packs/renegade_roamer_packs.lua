-- chunkname: @scripts/settings/roamer/roamer_packs/renegade_roamer_packs.lua

local roamer_melee = "renegade_melee"
local roamer_assault = "renegade_assault"
local roamer_rifleman = "renegade_rifleman"
local elite_executor = "renegade_executor"
local elite_berzerker = "renegade_berzerker"
local elite_gunner = "renegade_gunner"
local elite_gunner_two = "renegade_gunner"
local bulwark = "chaos_ogryn_bulwark"
local ogryn_gunner = "chaos_ogryn_gunner"
local ogryn_executor = "chaos_ogryn_executor"
local elite_shocktrooper = "renegade_shocktrooper"
local shocktrooper_two = "renegade_shocktrooper"
local roamer_packs = {
	renegade_traitor_mix_none = {
		{
			weight = 1,
			breeds = {
				"chaos_newly_infected"
			}
		},
		{
			weight = 2,
			breeds = {
				"chaos_newly_infected",
				"chaos_newly_infected"
			}
		},
		{
			weight = 1,
			breeds = {
				"chaos_newly_infected",
				"chaos_newly_infected",
				"chaos_newly_infected"
			}
		},
		{
			weight = 1,
			breeds = {
				"chaos_newly_infected",
				"chaos_newly_infected",
				"chaos_newly_infected",
				"chaos_newly_infected",
				roamer_melee
			}
		}
	},
	renegade_melee_low = {
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_executor",
				elite_executor,
				roamer_melee,
				roamer_melee
			}
		},
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_executor",
				"chaos_newly_infected",
				"chaos_newly_infected",
				"chaos_newly_infected",
				"chaos_newly_infected"
			}
		},
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_executor",
				roamer_melee,
				"chaos_newly_infected",
				"chaos_newly_infected"
			}
		},
		{
			weight = 2,
			breeds = {
				"chaos_ogryn_bulwark",
				roamer_melee,
				elite_executor
			}
		},
		{
			weight = 0.5,
			breeds = {
				"chaos_ogryn_bulwark",
				elite_executor
			}
		},
		{
			weight = 0.5,
			breeds = {
				"chaos_ogryn_bulwark",
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
	renegade_melee_high = {
		{
			weight = 2,
			breeds = {
				elite_executor,
				elite_executor,
				elite_executor,
				elite_executor,
				elite_executor,
				roamer_melee,
				roamer_melee
			}
		},
		{
			weight = 1,
			breeds = {
				elite_executor,
				elite_executor,
				roamer_melee,
				roamer_melee
			}
		},
		{
			weight = 2,
			breeds = {
				"chaos_ogryn_executor",
				elite_executor,
				elite_executor,
				elite_executor,
				roamer_melee,
				roamer_melee,
				roamer_melee,
				roamer_melee
			}
		},
		{
			weight = 2,
			breeds = {
				"chaos_ogryn_executor",
				elite_executor,
				elite_executor,
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
				"chaos_ogryn_executor",
				elite_executor,
				roamer_melee,
				roamer_melee,
				roamer_melee
			}
		},
		{
			weight = 2,
			breeds = {
				"chaos_ogryn_bulwark",
				elite_executor,
				roamer_melee,
				roamer_melee,
				roamer_melee
			}
		},
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_bulwark",
				elite_executor,
				roamer_melee,
				roamer_melee
			}
		},
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_executor",
				elite_executor,
				elite_executor,
				elite_executor,
				elite_executor
			}
		},
		{
			weight = 0.5,
			breeds = {
				"chaos_ogryn_bulwark",
				roamer_melee,
				roamer_melee
			}
		},
		{
			weight = 0.5,
			breeds = {
				"chaos_ogryn_bulwark",
				"chaos_ogryn_executor",
				roamer_melee
			}
		},
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_executor",
				elite_berzerker,
				elite_berzerker,
				elite_berzerker,
				roamer_melee
			}
		},
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_executor",
				elite_berzerker,
				elite_berzerker,
				elite_executor
			}
		},
		{
			weight = 2,
			breeds = {
				"chaos_ogryn_bulwark",
				elite_berzerker,
				elite_berzerker,
				elite_executor,
				roamer_melee,
				roamer_melee,
				roamer_melee,
				roamer_melee
			}
		},
		{
			weight = 2,
			breeds = {
				elite_berzerker,
				elite_berzerker,
				elite_berzerker
			}
		}
	},
	renegade_close_low = {
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_bulwark",
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
				elite_shocktrooper,
				roamer_assault,
				roamer_assault
			}
		},
		{
			weight = 1,
			breeds = {
				shocktrooper_two,
				roamer_assault,
				roamer_assault,
				roamer_assault
			}
		},
		{
			weight = 2,
			breeds = {
				elite_shocktrooper,
				elite_shocktrooper,
				roamer_assault
			}
		},
		{
			weight = 0.5,
			breeds = {
				elite_shocktrooper,
				elite_shocktrooper
			}
		},
		{
			weight = 0.5,
			breeds = {
				shocktrooper_two,
				roamer_assault
			}
		}
	},
	renegade_close_high = {
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
				elite_shocktrooper,
				elite_shocktrooper,
				elite_shocktrooper,
				roamer_assault,
				roamer_assault
			}
		},
		{
			weight = 1,
			breeds = {
				bulwark,
				shocktrooper_two,
				roamer_assault,
				roamer_assault,
				roamer_assault,
				roamer_assault
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
			weight = 2,
			breeds = {
				bulwark,
				shocktrooper_two,
				shocktrooper_two,
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
				shocktrooper_two,
				"chaos_ogryn_bulwark",
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
				shocktrooper_two,
				elite_shocktrooper,
				roamer_assault,
				roamer_assault,
				roamer_assault
			}
		},
		{
			weight = 0.5,
			breeds = {
				shocktrooper_two,
				"chaos_ogryn_bulwark",
				elite_shocktrooper,
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
				shocktrooper_two,
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
				elite_shocktrooper,
				roamer_assault,
				roamer_assault
			}
		},
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_bulwark",
				shocktrooper_two,
				roamer_assault,
				roamer_assault,
				roamer_assault
			}
		}
	},
	renegade_far_low = {
		{
			weight = 1,
			breeds = {
				elite_gunner,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman
			}
		},
		{
			weight = 2,
			breeds = {
				"chaos_ogryn_gunner",
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
				elite_gunner,
				roamer_rifleman
			}
		},
		{
			weight = 0.5,
			breeds = {
				"chaos_ogryn_gunner",
				elite_gunner_two,
				roamer_rifleman,
				roamer_rifleman
			}
		},
		{
			weight = 0.5,
			breeds = {
				"chaos_ogryn_gunner",
				elite_gunner,
				roamer_rifleman,
				roamer_rifleman
			}
		}
	},
	renegade_far_high = {
		{
			weight = 1,
			breeds = {
				shocktrooper_two,
				"chaos_ogryn_gunner",
				elite_gunner,
				elite_gunner,
				elite_gunner,
				elite_gunner,
				elite_gunner,
				roamer_rifleman,
				roamer_rifleman
			}
		},
		{
			weight = 1,
			breeds = {
				shocktrooper_two,
				elite_gunner,
				elite_gunner,
				elite_gunner,
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
			weight = 0.5,
			breeds = {
				shocktrooper_two,
				elite_gunner,
				"chaos_ogryn_bulwark",
				"chaos_ogryn_bulwark",
				elite_gunner,
				elite_gunner_two,
				roamer_rifleman,
				roamer_rifleman
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
				"chaos_ogryn_bulwark",
				elite_gunner,
				"chaos_ogryn_gunner"
			}
		}
	},
	renegade_mixed_low = {
		{
			weight = 1,
			breeds = {
				elite_gunner,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				bulwark
			}
		},
		{
			weight = 2,
			breeds = {
				ogryn_gunner,
				roamer_rifleman,
				elite_berzerker,
				roamer_rifleman
			}
		},
		{
			weight = 1,
			breeds = {
				ogryn_gunner,
				elite_gunner,
				elite_berzerker,
				elite_gunner,
				roamer_rifleman
			}
		},
		{
			weight = 0.5,
			breeds = {
				ogryn_gunner,
				elite_gunner_two,
				bulwark,
				roamer_rifleman,
				roamer_rifleman
			}
		},
		{
			weight = 0.5,
			breeds = {
				ogryn_gunner,
				elite_gunner,
				bulwark,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman
			}
		}
	},
	renegade_mixed_high = {
		{
			weight = 1,
			breeds = {
				shocktrooper_two,
				ogryn_gunner,
				elite_gunner,
				ogryn_executor,
				bulwark,
				bulwark,
				elite_executor,
				roamer_rifleman,
				roamer_rifleman
			}
		},
		{
			weight = 1,
			breeds = {
				shocktrooper_two,
				elite_gunner,
				elite_gunner,
				ogryn_executor,
				roamer_rifleman,
				bulwark,
				elite_executor,
				roamer_rifleman,
				roamer_rifleman
			}
		},
		{
			weight = 1,
			breeds = {
				elite_executor,
				roamer_rifleman,
				roamer_rifleman,
				elite_gunner,
				bulwark
			}
		},
		{
			weight = 0.5,
			breeds = {
				shocktrooper_two,
				elite_gunner,
				bulwark,
				bulwark,
				elite_gunner,
				elite_gunner_two,
				roamer_rifleman,
				roamer_rifleman
			}
		},
		{
			weight = 1,
			breeds = {
				elite_gunner,
				elite_gunner,
				roamer_rifleman,
				roamer_rifleman,
				elite_executor
			}
		},
		{
			weight = 0.5,
			breeds = {
				bulwark,
				elite_gunner,
				ogryn_gunner
			}
		}
	},
	renegade_flamers_mutator = {
		{
			weight = 1,
			breeds = {
				"renegade_flamer_mutator"
			}
		}
	},
	renegade_close_low_no_melee_ogryns = {
		{
			weight = 1,
			breeds = {
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
	renegade_close_high_no_melee_ogryns = {
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
			weight = 2,
			breeds = {
				elite_shocktrooper,
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
	renegade_far_low_no_melee_ogryns = {
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
			weight = 2,
			breeds = {
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman
			}
		},
		{
			weight = 1,
			breeds = {
				elite_gunner,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman
			}
		},
		{
			weight = 0.5,
			breeds = {
				elite_gunner_two,
				roamer_rifleman,
				roamer_rifleman
			}
		},
		{
			weight = 0.5,
			breeds = {
				"chaos_ogryn_gunner",
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman
			}
		}
	},
	renegade_far_high_no_melee_ogryns = {
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
			weight = 0.5,
			breeds = {
				elite_gunner,
				elite_gunner_two,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman
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
				"chaos_ogryn_gunner"
			}
		}
	}
}

return roamer_packs
