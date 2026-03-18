-- chunkname: @scripts/settings/roamer/roamer_packs/expeditions/expeditions_renegade_roamer_packs.lua

local roamer_melee = "renegade_melee"
local roamer_rifleman = "renegade_assault"
local elite_shocktrooper = "renegade_shocktrooper"
local elite_plasma_gunner = "renegade_plasma_gunner"
local elite_berzerker = "renegade_berzerker"
local elite_gunner = "renegade_gunner"
local roamer_packs = {
	expeditions_renegade_melee_high = {
		{
			weight = 2,
			breeds = {
				elite_berzerker,
				elite_berzerker,
				elite_berzerker,
				roamer_melee,
				roamer_melee,
				roamer_melee,
				roamer_melee,
			},
		},
		{
			weight = 1,
			breeds = {
				elite_berzerker,
				roamer_melee,
				roamer_melee,
				roamer_melee,
			},
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
			},
		},
		{
			weight = 2,
			breeds = {
				"chaos_ogryn_executor",
				roamer_melee,
				roamer_melee,
				roamer_melee,
				roamer_melee,
			},
		},
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_bulwark",
				roamer_melee,
				roamer_melee,
			},
		},
		{
			weight = 1,
			breeds = {
				elite_berzerker,
				elite_berzerker,
				roamer_melee,
				roamer_melee,
			},
		},
		{
			weight = 2,
			breeds = {
				"chaos_ogryn_bulwark",
				roamer_melee,
				roamer_melee,
				elite_berzerker,
			},
		},
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_bulwark",
				roamer_melee,
				roamer_melee,
			},
		},
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_executor",
				"chaos_ogryn_bulwark",
			},
		},
		{
			weight = 0.5,
			breeds = {
				"chaos_ogryn_bulwark",
				roamer_melee,
				roamer_melee,
			},
		},
	},
	expeditions_renegade_close_high = {
		{
			weight = 1,
			breeds = {
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_melee,
			},
		},
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_bulwark",
				elite_berzerker,
				roamer_rifleman,
				roamer_rifleman,
				roamer_melee,
				elite_shocktrooper,
			},
		},
		{
			weight = 2,
			breeds = {
				"chaos_ogryn_executor",
				elite_shocktrooper,
				roamer_melee,
				roamer_rifleman,
				roamer_rifleman,
			},
		},
		{
			weight = 1,
			breeds = {
				elite_shocktrooper,
				elite_shocktrooper,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
			},
		},
		{
			weight = 2,
			breeds = {
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_melee,
				roamer_melee,
				roamer_melee,
			},
		},
		{
			weight = 0.5,
			breeds = {
				"chaos_ogryn_bulwark",
				elite_shocktrooper,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_melee,
				roamer_melee,
			},
		},
		{
			weight = 1,
			breeds = {
				elite_shocktrooper,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
			},
		},
	},
	expeditions_renegade_far_high = {
		{
			weight = 1,
			breeds = {
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_melee,
				roamer_melee,
				roamer_melee,
			},
		},
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_gunner",
				roamer_rifleman,
				roamer_rifleman,
				elite_gunner,
				elite_plasma_gunner,
			},
		},
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_gunner",
				elite_gunner,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
			},
		},
		{
			weight = 0.5,
			breeds = {
				"chaos_ogryn_bulwark",
				elite_shocktrooper,
				elite_gunner,
				"chaos_ogryn_gunner",
				elite_plasma_gunner,
			},
		},
	},
	expeditions_renegade_mixed_high = {
		{
			weight = 1,
			breeds = {
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_melee,
				roamer_melee,
				elite_plasma_gunner,
			},
		},
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_gunner",
				roamer_rifleman,
				roamer_rifleman,
				elite_gunner,
				elite_plasma_gunner,
			},
		},
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_gunner",
				elite_gunner,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
			},
		},
		{
			weight = 0.5,
			breeds = {
				"chaos_ogryn_bulwark",
				elite_shocktrooper,
				elite_gunner,
				"chaos_ogryn_gunner",
			},
		},
	},
	expeditions_renegade_melee_low = {
		{
			weight = 2,
			breeds = {
				elite_berzerker,
				roamer_melee,
				roamer_melee,
				roamer_melee,
				roamer_melee,
			},
		},
		{
			weight = 1,
			breeds = {
				elite_berzerker,
				roamer_melee,
				roamer_melee,
				roamer_melee,
			},
		},
		{
			weight = 2,
			breeds = {
				elite_berzerker,
				roamer_melee,
				roamer_melee,
			},
		},
		{
			weight = 2,
			breeds = {
				roamer_melee,
				roamer_melee,
				roamer_melee,
				roamer_melee,
			},
		},
		{
			weight = 1,
			breeds = {
				roamer_melee,
				roamer_melee,
			},
		},
		{
			weight = 1,
			breeds = {
				elite_berzerker,
				roamer_melee,
				roamer_melee,
				roamer_melee,
				roamer_melee,
			},
		},
		{
			weight = 2,
			breeds = {
				roamer_melee,
				roamer_melee,
				roamer_melee,
				roamer_melee,
				elite_berzerker,
			},
		},
		{
			weight = 1,
			breeds = {
				roamer_melee,
				roamer_melee,
				roamer_melee,
				roamer_melee,
				roamer_melee,
				roamer_melee,
			},
		},
		{
			weight = 0.5,
			breeds = {
				roamer_melee,
				roamer_melee,
			},
		},
	},
	expeditions_renegade_close_low = {
		{
			weight = 1,
			breeds = {
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_melee,
			},
		},
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_bulwark",
				elite_berzerker,
				roamer_rifleman,
				roamer_rifleman,
				roamer_melee,
				elite_shocktrooper,
			},
		},
		{
			weight = 2,
			breeds = {
				"chaos_ogryn_executor",
				elite_shocktrooper,
				roamer_melee,
				roamer_rifleman,
				roamer_rifleman,
			},
		},
		{
			weight = 1,
			breeds = {
				elite_shocktrooper,
				elite_shocktrooper,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
			},
		},
		{
			weight = 2,
			breeds = {
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_melee,
				roamer_melee,
				roamer_melee,
			},
		},
		{
			weight = 0.5,
			breeds = {
				"chaos_ogryn_bulwark",
				elite_shocktrooper,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_melee,
				roamer_melee,
			},
		},
		{
			weight = 1,
			breeds = {
				elite_shocktrooper,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
			},
		},
	},
	expeditions_renegade_far_low = {
		{
			weight = 1,
			breeds = {
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
			},
		},
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_gunner",
				roamer_rifleman,
				roamer_rifleman,
				elite_gunner,
			},
		},
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_gunner",
				elite_gunner,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
			},
		},
		{
			weight = 0.5,
			breeds = {
				elite_shocktrooper,
				elite_gunner,
				roamer_rifleman,
				roamer_rifleman,
			},
		},
	},
	expeditions_renegade_mixed_low = {
		{
			weight = 1,
			breeds = {
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_melee,
				roamer_melee,
			},
		},
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_gunner",
				roamer_rifleman,
				roamer_rifleman,
				elite_gunner,
			},
		},
		{
			weight = 1,
			breeds = {
				"chaos_ogryn_gunner",
				elite_gunner,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
				roamer_rifleman,
			},
		},
		{
			weight = 0.5,
			breeds = {
				"chaos_ogryn_bulwark",
				elite_shocktrooper,
				elite_gunner,
				"chaos_ogryn_gunner",
			},
		},
	},
}

return roamer_packs
