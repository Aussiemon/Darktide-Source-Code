-- chunkname: @scripts/managers/pacing/auto_event/templates/live_event_skulls_guns_auto_event_template.lua

local expedition_template = require("scripts/managers/pacing/auto_event/templates/expedition_auto_event_template")
local live_event_skulls_guns_auto_event_template = table.clone_instance(expedition_template.expedition_auto_event_template)

live_event_skulls_guns_auto_event_template.name = "live_event_skulls_guns_auto_event_template"
live_event_skulls_guns_auto_event_template.check_radius_to_players = false
live_event_skulls_guns_auto_event_template.optional_disallowed_positions = false
live_event_skulls_guns_auto_event_template.points_base = {
	35,
	40,
	40,
	45,
	50,
}

live_event_skulls_guns_auto_event_template.conditional_function = function (t)
	local mutator = Managers.state.mutator:mutator("mutator_live_event_skulls_guns_full")

	if not mutator then
		return t[1]
	end

	local scratchpad = mutator.scratchpad

	if not scratchpad then
		return t[1]
	end

	local events_completed = scratchpad.events_completed or 1

	events_completed = math.clamp(events_completed, 1, #t)

	return t[events_completed]
end

live_event_skulls_guns_auto_event_template.cooldown = {
	{
		16,
		18,
	},
	{
		14,
		16,
	},
	{
		8,
		10,
	},
	{
		3,
		6,
	},
	{
		1,
		4,
	},
}
live_event_skulls_guns_auto_event_template.waves_cooldown = {
	{
		7,
		8,
	},
	{
		6,
		7,
	},
	{
		3,
		4,
	},
	{
		2,
		3,
	},
	{
		1,
		3,
	},
}

local captain_chance_for_injection = {
	conditional_values = {
		0,
		0,
		0.1,
		0.4,
		0.5,
	},
	chance_indexed_by_resistance = {
		0,
		0,
		0.3,
		0.4,
		0.5,
		0.6,
	},
}

live_event_skulls_guns_auto_event_template.captains_settings = {
	execute = function (force_spawn)
		local num_to_spawn = 1

		if force_spawn then
			if type(force_spawn) == "number" then
				num_to_spawn = force_spawn
			end

			return true, num_to_spawn
		end

		local heat_chance = live_event_skulls_guns_auto_event_template.conditional_function(captain_chance_for_injection.conditional_values)
		local resistance_chance = Managers.state.difficulty:get_table_entry_by_resistance(captain_chance_for_injection.chance_indexed_by_resistance)
		local randomized_heat_chance = math.random(0, heat_chance)
		local randomized_resistance_chance = math.random(0, resistance_chance)
		local chance = math.clamp(randomized_heat_chance + randomized_resistance_chance, 0, 1)

		if chance > math.random() then
			return true, num_to_spawn
		else
			return false
		end
	end,
}

local monster_chance_for_injection = {
	conditional_values = {
		0,
		0,
		0.2,
		0.3,
		0.35,
	},
	chance_indexed_by_resistance = {
		0,
		0,
		0.2,
		0.25,
		0.3,
		0.35,
	},
}

live_event_skulls_guns_auto_event_template.monster_settings = {
	monster_breeds = {
		"chaos_spawn",
		"chaos_beast_of_nurgle",
		"chaos_plague_ogryn",
	},
	execute = function (force_spawn)
		local num_to_spawn = 1

		if force_spawn then
			if type(force_spawn) == "number" then
				num_to_spawn = force_spawn
			end

			return true, num_to_spawn
		end

		local heat_chance = live_event_skulls_guns_auto_event_template.conditional_function(monster_chance_for_injection.conditional_values)
		local resistance_chance = Managers.state.difficulty:get_table_entry_by_resistance(monster_chance_for_injection.chance_indexed_by_resistance)
		local randomized_heat_chance = math.random(0, heat_chance)
		local randomized_resistance_chance = math.random(0, resistance_chance)
		local chance = math.clamp(randomized_heat_chance + randomized_resistance_chance, 0, 1)

		if chance > math.random() then
			return true, num_to_spawn
		else
			return false
		end
	end,
}

local twins_chance_for_injection = {
	conditional_values = {
		0,
		0,
		0,
		0.1,
		0.5,
	},
	chance_indexed_by_resistance = {
		0,
		0,
		0,
		0,
		0.7,
		0.8,
	},
}

live_event_skulls_guns_auto_event_template.twins_settings = {
	execute = function (force_spawn, num_twins)
		if force_spawn then
			if type(force_spawn) == "number" then
				num_to_spawn = force_spawn
			end

			return true, num_to_spawn
		end

		local heat_chance = live_event_skulls_guns_auto_event_template.conditional_function(twins_chance_for_injection.conditional_values)
		local resistance_chance = Managers.state.difficulty:get_table_entry_by_resistance(twins_chance_for_injection.chance_indexed_by_resistance)
		local randomized_heat_chance = math.random(0, heat_chance)
		local randomized_resistance_chance = math.random(0, resistance_chance)
		local chance = math.clamp(randomized_heat_chance + randomized_resistance_chance, 0, 1)

		if chance > math.random() then
			return true, 2
		else
			return false
		end
	end,
}

return {
	live_event_skulls_guns_auto_event_template = live_event_skulls_guns_auto_event_template,
}
