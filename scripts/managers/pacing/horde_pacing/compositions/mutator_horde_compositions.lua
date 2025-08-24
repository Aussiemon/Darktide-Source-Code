-- chunkname: @scripts/managers/pacing/horde_pacing/compositions/mutator_horde_compositions.lua

local max_resistance = 6

local function _empty()
	local t = {}

	for i = 1, max_resistance do
		t[i] = {
			0,
			0,
		}
	end

	return t
end

local function _constant(lo, hi, from_resistance)
	local t = _empty()

	from_resistance = from_resistance or 1

	for i = from_resistance, max_resistance do
		t[i] = {
			lo,
			hi,
		}
	end

	return t
end

local function _interpolate(from, target, from_resistance, interpolate_function)
	local t = _empty()

	from_resistance = from_resistance or 1

	for i = from_resistance, max_resistance do
		local percent_to_max = interpolate_function((i - from_resistance) / (max_resistance - from_resistance))
		local lo = math.round(from[1] + percent_to_max * (target[1] - from[1]))
		local hi = math.round(from[2] + percent_to_max * (target[2] - from[2]))

		t[i] = {
			lo,
			hi,
		}
	end

	return t
end

local function _linear(from, target, from_resistance)
	return _interpolate(from, target, from_resistance, function (x)
		return x
	end)
end

local function _add(a, b)
	local t = _empty()

	for i = 1, max_resistance do
		local _a = a[i] or a[#a]
		local _b = b[i] or b[#b]

		t[i] = {
			_a[1] + _b[1],
			_a[2] + _b[2],
		}
	end

	return t
end

local horde_compositions = {
	mutator_chaos_hounds = {
		chaos_hound = _constant(1, 1, 4),
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
		renegade_sniper = _constant(1, 1),
	},
	mutator_poxwalker_bombers = {
		chaos_poxwalker_bomber = _constant(1, 1),
	},
	mutator_armored_bombers = {
		chaos_armored_bomber = _constant(1, 1),
	},
	mutator_mutants = {
		cultist_mutant_mutator = _constant(1, 1),
	},
	mutator_cultist_grenadier = {
		cultist_grenadier = _constant(1, 1),
	},
	mutator_renegade_grenadier = {
		renegade_grenadier = _constant(1, 1),
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
		renegade_shocktrooper = _add(_constant(1, 1), _linear({
			0,
			0,
		}, {
			0,
			3,
		}, 3)),
		renegade_assault = _linear({
			1,
			2,
		}, {
			2,
			4,
		}, 4),
	},
	mutator_cultist_shocktrooper = {
		cultist_shocktrooper = _add(_constant(1, 1), _linear({
			0,
			0,
		}, {
			0,
			3,
		}, 3)),
		cultist_assault = _linear({
			1,
			2,
		}, {
			2,
			4,
		}, 4),
	},
	mutator_live_abhuman = {
		chaos_ogryn_executor = _linear({
			1,
			1,
		}, {
			1,
			4,
		}, 3),
		chaos_ogryn_gunner = _linear({
			1,
			1,
		}, {
			1,
			4,
		}, 3),
		chaos_ogryn_bulwark = _linear({
			1,
			1,
		}, {
			1,
			4,
		}, 3),
	},
	mutator_live_rotten_armor = {
		chaos_ogryn_executor = _linear({
			1,
			1,
		}, {
			1,
			4,
		}, 3),
		renegade_executor = _linear({
			1,
			1,
		}, {
			1,
			4,
		}, 3),
		renegade_berzerker = _linear({
			1,
			1,
		}, {
			1,
			4,
		}, 3),
	},
}

for name, comp in pairs(horde_compositions) do
	local expanded = {}

	for i = 1, max_resistance do
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
