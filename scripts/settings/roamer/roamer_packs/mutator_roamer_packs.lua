-- chunkname: @scripts/settings/roamer/roamer_packs/mutator_roamer_packs.lua

local ogryn_gunner = "chaos_ogryn_gunner"
local ogryn_executor = "chaos_ogryn_executor"
local ogryn_bulwark = "chaos_ogryn_bulwark"
local renegade_gunner = "renegade_gunner"
local renegade_executor = "renegade_executor"
local renegade_berzerker = "renegade_berzerker"
local renegade_plasma_gunner = "renegade_plasma_gunner"
local renegade_shocktrooper = "renegade_shocktrooper"
local cultist_gunner = "cultist_gunner"
local cultist_berzerker = "cultist_berzerker"
local cultist_shocktrooper = "cultist_shocktrooper"
local roamer_packs = {
	mutator_renegade_mixed_low_elite_only = {
		{
			weight = 1,
			breeds = {
				renegade_gunner,
				renegade_gunner,
				renegade_gunner,
				renegade_executor,
				renegade_berzerker,
			},
		},
		{
			weight = 2,
			breeds = {
				ogryn_gunner,
				renegade_plasma_gunner,
				renegade_berzerker,
				renegade_gunner,
			},
		},
		{
			weight = 1,
			breeds = {
				ogryn_gunner,
				renegade_plasma_gunner,
				renegade_berzerker,
				renegade_plasma_gunner,
				renegade_gunner,
			},
		},
		{
			weight = 1,
			breeds = {
				ogryn_gunner,
				renegade_gunner,
				renegade_berzerker,
				renegade_shocktrooper,
				renegade_shocktrooper,
			},
		},
		{
			weight = 0.5,
			breeds = {
				ogryn_gunner,
				ogryn_bulwark,
				renegade_shocktrooper,
				renegade_shocktrooper,
			},
		},
		{
			weight = 0.5,
			breeds = {
				ogryn_gunner,
				renegade_plasma_gunner,
				ogryn_bulwark,
				ogryn_executor,
				renegade_gunner,
				renegade_gunner,
			},
		},
	},
	mutator_renegade_mixed_high_elite_only = {
		{
			weight = 1,
			breeds = {
				renegade_shocktrooper,
				ogryn_gunner,
				renegade_plasma_gunner,
				ogryn_executor,
				ogryn_bulwark,
				renegade_berzerker,
				renegade_executor,
				renegade_gunner,
				renegade_gunner,
			},
		},
		{
			weight = 1,
			breeds = {
				renegade_shocktrooper,
				renegade_berzerker,
				renegade_plasma_gunner,
				ogryn_executor,
				renegade_plasma_gunner,
				ogryn_bulwark,
				ogryn_bulwark,
				renegade_gunner,
				renegade_gunner,
			},
		},
		{
			weight = 1,
			breeds = {
				renegade_executor,
				renegade_gunner,
				renegade_gunner,
				ogryn_gunner,
				ogryn_bulwark,
			},
		},
		{
			weight = 0.5,
			breeds = {
				renegade_shocktrooper,
				renegade_gunner,
				ogryn_gunner,
				ogryn_gunner,
				renegade_berzerker,
				renegade_gunner,
				renegade_plasma_gunner,
				renegade_plasma_gunner,
			},
		},
		{
			weight = 1,
			breeds = {
				renegade_plasma_gunner,
				renegade_plasma_gunner,
				renegade_gunner,
				renegade_gunner,
				renegade_executor,
			},
		},
		{
			weight = 1,
			breeds = {
				ogryn_gunner,
				renegade_berzerker,
				renegade_gunner,
				renegade_gunner,
				renegade_gunner,
				ogryn_bulwark,
				ogryn_bulwark,
				renegade_shocktrooper,
			},
		},
		{
			weight = 0.5,
			breeds = {
				ogryn_bulwark,
				ogryn_bulwark,
				ogryn_bulwark,
				ogryn_bulwark,
				ogryn_bulwark,
				ogryn_bulwark,
				ogryn_bulwark,
				renegade_shocktrooper,
				renegade_shocktrooper,
				renegade_shocktrooper,
				renegade_shocktrooper,
			},
		},
		{
			weight = 0.5,
			breeds = {
				ogryn_bulwark,
				renegade_berzerker,
				renegade_berzerker,
				ogryn_gunner,
			},
		},
	},
	mutator_cultist_mixed_low_elite_only = {
		{
			weight = 1,
			breeds = {
				cultist_gunner,
				cultist_gunner,
				ogryn_bulwark,
				cultist_berzerker,
				cultist_gunner,
				cultist_gunner,
			},
		},
		{
			weight = 1,
			breeds = {
				ogryn_gunner,
				cultist_gunner,
				cultist_gunner,
				ogryn_bulwark,
				ogryn_bulwark,
				cultist_shocktrooper,
				cultist_shocktrooper,
				cultist_berzerker,
			},
		},
		{
			weight = 2,
			breeds = {
				cultist_gunner,
				cultist_gunner,
				ogryn_bulwark,
				cultist_shocktrooper,
				cultist_berzerker,
			},
		},
		{
			weight = 1,
			breeds = {
				cultist_gunner,
				cultist_gunner,
				cultist_gunner,
				cultist_gunner,
				ogryn_bulwark,
			},
		},
		{
			weight = 0.5,
			breeds = {
				ogryn_gunner,
				cultist_gunner,
				cultist_berzerker,
				cultist_shocktrooper,
			},
		},
		{
			weight = 0.5,
			breeds = {
				ogryn_gunner,
				cultist_berzerker,
				ogryn_executor,
				ogryn_executor,
			},
		},
	},
	mutator_cultist_mixed_high_elite_only = {
		{
			weight = 1,
			breeds = {
				cultist_gunner,
				cultist_gunner,
				ogryn_bulwark,
				ogryn_bulwark,
				cultist_berzerker,
				cultist_gunner,
				cultist_gunner,
				cultist_gunner,
				cultist_gunner,
			},
		},
		{
			weight = 1,
			breeds = {
				ogryn_gunner,
				cultist_gunner,
				cultist_gunner,
				cultist_shocktrooper,
				ogryn_bulwark,
				cultist_berzerker,
			},
		},
		{
			weight = 1,
			breeds = {
				ogryn_gunner,
				cultist_gunner,
				cultist_gunner,
				cultist_shocktrooper,
				cultist_shocktrooper,
				cultist_berzerker,
				cultist_berzerker,
			},
		},
		{
			weight = 0.5,
			breeds = {
				ogryn_bulwark,
				cultist_gunner,
				cultist_gunner,
				ogryn_gunner,
				ogryn_executor,
				ogryn_executor,
			},
		},
	},
}

return roamer_packs
