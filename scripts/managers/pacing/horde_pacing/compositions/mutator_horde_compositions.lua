-- chunkname: @scripts/managers/pacing/horde_pacing/compositions/mutator_horde_compositions.lua

local ResistanceUtils = require("scripts/managers/pacing/utilities/resistance_utils")
local horde_compositions = {
	mutator_chaos_hounds = {
		chaos_hound = ResistanceUtils.constant(1, 1, 4),
		chaos_hound_mutator = {
			{
				2,
				3,
			},
			{
				3,
				5,
			},
			{
				7,
				9,
			},
			{
				8,
				10,
			},
			{
				10,
				12,
			},
			{
				12,
				15,
			},
		},
	},
	mutator_snipers = {
		renegade_sniper = ResistanceUtils.constant(1, 1),
	},
	mutator_poxwalker_bombers = {
		chaos_poxwalker_bomber = ResistanceUtils.constant(1, 1),
	},
	mutator_armored_bombers = {
		chaos_armored_bomber = ResistanceUtils.constant(1, 1),
	},
	mutator_mutants = {
		cultist_mutant_mutator = ResistanceUtils.constant(1, 1),
	},
	mutator_cultist_grenadier = {
		cultist_grenadier = ResistanceUtils.constant(1, 1),
	},
	mutator_renegade_grenadier = {
		renegade_grenadier = ResistanceUtils.constant(1, 1),
	},
	mutator_riflemen = {
		renegade_rifleman = {
			{
				10,
				12,
			},
			{
				15,
				17,
			},
			{
				18,
				21,
			},
			{
				21,
				24,
			},
			{
				24,
				26,
			},
			{
				26,
				28,
			},
		},
	},
	mutator_renegade_shocktrooper = {
		renegade_shocktrooper = ResistanceUtils.add(ResistanceUtils.constant(1, 1), ResistanceUtils.linear({
			0,
			0,
		}, {
			0,
			3,
		}, 3)),
		renegade_assault = ResistanceUtils.linear({
			1,
			2,
		}, {
			2,
			4,
		}, 4),
	},
	mutator_cultist_shocktrooper = {
		cultist_shocktrooper = ResistanceUtils.add(ResistanceUtils.constant(1, 1), ResistanceUtils.linear({
			0,
			0,
		}, {
			0,
			3,
		}, 3)),
		cultist_assault = ResistanceUtils.linear({
			1,
			2,
		}, {
			2,
			4,
		}, 4),
	},
	mutator_live_abhuman = {
		chaos_ogryn_executor = ResistanceUtils.linear({
			1,
			1,
		}, {
			1,
			4,
		}, 1),
		chaos_ogryn_gunner = ResistanceUtils.linear({
			1,
			1,
		}, {
			1,
			4,
		}, 1),
		chaos_ogryn_bulwark = ResistanceUtils.linear({
			1,
			1,
		}, {
			1,
			4,
		}, 1),
	},
	mutator_live_rotten_armor = {
		chaos_ogryn_executor = ResistanceUtils.linear({
			1,
			1,
		}, {
			1,
			4,
		}, 1),
		renegade_executor = ResistanceUtils.linear({
			1,
			1,
		}, {
			1,
			4,
		}, 1),
		renegade_berzerker = ResistanceUtils.linear({
			1,
			1,
		}, {
			1,
			4,
		}, 1),
	},
}

for name, comp in pairs(horde_compositions) do
	local expanded = {}

	for i = 1, ResistanceUtils.MAX_RESISTANCE do
		expanded[i] = {
			breeds = {},
		}

		for breed_name, spawn_range_by_difficulty in pairs(comp) do
			local spawn_range = spawn_range_by_difficulty[i] or spawn_range_by_difficulty[#spawn_range_by_difficulty]

			if spawn_range[1] > 0 or spawn_range[2] > 0 then
				table.insert(expanded[i].breeds, {
					name = breed_name,
					amount = spawn_range,
				})
			end
		end
	end

	horde_compositions[name] = expanded
end

return horde_compositions
