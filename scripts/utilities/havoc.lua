-- chunkname: @scripts/utilities/havoc.lua

local HavocSettings = require("scripts/settings/havoc_settings")
local HavocModifierConfig = require("scripts/settings/havoc/havoc_modifier_config")
local Havoc = {}
local SEED = 2023062419930608

local function _random(...)
	local seed, value = math.next_random(SEED, ...)

	SEED = seed

	return value
end

Havoc.generate_havoc_data = function (havoc_rank, seed)
	seed = seed or math.random(23062419930608, 2023062419930608)
	SEED = seed

	local num_circumstances = math.min(math.floor(havoc_rank / HavocSettings.num_ranks_per_circumstance) + 1, HavocSettings.max_circumstances)
	local extra_circumstance, increased_difficulty, theme
	local themes = HavocSettings.themes
	local chance_for_default_theme = HavocSettings.chance_for_default_theme
	local forced_themes_ranks = HavocSettings.forced_themes_ranks
	local circumstances_per_theme = HavocSettings.circumstances_per_theme
	local use_theme = false

	for i = 1, #forced_themes_ranks do
		local checked_rank = forced_themes_ranks[i]

		if havoc_rank == checked_rank then
			use_theme = true

			break
		end
	end

	local value = _random(0, 100)

	value = value * 0.01

	if chance_for_default_theme < value then
		use_theme = true
	end

	if not use_theme then
		theme = "default"
	else
		theme = themes[_random(1, #themes)]

		local possible_circumstances = circumstances_per_theme[theme]

		extra_circumstance = possible_circumstances[_random(1, #possible_circumstances)]
	end

	local missions = HavocSettings.missions[theme]
	local mission = missions[_random(1, #missions)]
	local factions = HavocSettings.factions
	local faction = factions[_random(1, #factions)]
	local chosen_circumstances = ""
	local circumstances = table.clone(HavocSettings.circumstances)

	for i = 1, num_circumstances do
		local random_index = _random(1, #circumstances)
		local circumstance = circumstances[random_index]

		if i == 1 then
			chosen_circumstances = circumstance
		else
			chosen_circumstances = chosen_circumstances .. ":" .. circumstance
		end

		table.remove(circumstances, random_index)

		if #circumstances == 0 then
			break
		end
	end

	if extra_circumstance then
		if num_circumstances > 0 then
			chosen_circumstances = chosen_circumstances .. ":" .. extra_circumstance
		else
			chosen_circumstances = extra_circumstance
		end
	end

	if havoc_rank >= 16 and havoc_rank <= 29 then
		increased_difficulty = "mutator_increased_difficulty"
		chosen_circumstances = chosen_circumstances .. ":" .. increased_difficulty
	elseif havoc_rank >= 30 then
		increased_difficulty = "mutator_highest_difficulty"
		chosen_circumstances = chosen_circumstances .. ":" .. increased_difficulty
	end

	local chosen_modifiers = ""
	local current_modifer_level = HavocModifierConfig[havoc_rank]
	local index = 1

	for name, tier_level in pairs(current_modifer_level) do
		local hashed_modifier_name = NetworkLookup.havoc_modifiers[name]

		if index == 1 then
			chosen_modifiers = hashed_modifier_name .. "." .. tier_level
		else
			chosen_modifiers = chosen_modifiers .. ":" .. hashed_modifier_name .. "." .. tier_level
		end

		index = index + 1

		if index == #current_modifer_level then
			break
		end
	end

	local difficulty = {}

	if havoc_rank <= 10 then
		difficulty.challenge = 3
		difficulty.resistance = 3
	elseif havoc_rank >= 11 and havoc_rank <= 20 then
		difficulty.challenge = 4
		difficulty.resistance = 4
	elseif havoc_rank >= 21 and havoc_rank <= 30 then
		difficulty.challenge = 5
		difficulty.resistance = 4
	else
		difficulty.challenge = 5
		difficulty.resistance = 5
	end

	local data = string.format("%s;%d;%s;%s;%s;%s;%s;%s", mission, havoc_rank, theme, faction, chosen_circumstances, chosen_modifiers, difficulty.challenge, difficulty.resistance)

	return data
end

Havoc.parse_data = function (data)
	local parsed_data = {}
	local split1 = string.split(data, ";")
	local mission = split1[1]

	parsed_data.mission = mission

	local havoc_rank = tonumber(split1[2])

	parsed_data.havoc_rank = havoc_rank

	local theme = split1[3]

	parsed_data.theme = theme

	local faction = split1[4]

	parsed_data.faction = faction

	local circumstances = split1[5]
	local split2 = string.split(circumstances, ":")
	local circumstances_entry = {}

	for i = 1, #split2 do
		circumstances_entry[#circumstances_entry + 1] = split2[i]
	end

	parsed_data.circumstances = circumstances_entry

	local modifiers = split1[6]
	local split3 = string.split(modifiers, ":")
	local modifiers_entry = {}

	for i = 1, #split3 do
		local modifier_raw = split3[i]
		local modifier_split = string.split(modifier_raw, ".")
		local modifier_name = NetworkLookup.havoc_modifiers[tonumber(modifier_split[1])]
		local modifier_level = tonumber(modifier_split[2])

		modifiers_entry[#modifiers_entry + 1] = {
			name = modifier_name,
			level = modifier_level
		}
	end

	parsed_data.modifiers = modifiers_entry

	local challenge = split1[7]

	parsed_data.challenge = tonumber(challenge)

	local resistance = split1[8]

	parsed_data.resistance = tonumber(resistance)

	return parsed_data
end

return Havoc
