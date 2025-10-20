-- chunkname: @scripts/settings/stats/session_stats.lua

local BackendTypes = require("scripts/settings/stats/backend_stat_types")
local StatDefinitions = require("scripts/managers/stats/stat_definitions")
local SessionStats = {}

SessionStats.team_kills = {
	always_push = true,
	type = BackendTypes.statistic_by,
	stats = {
		none = "session_team_kills",
	},
}
SessionStats.team_deaths = {
	always_push = true,
	type = BackendTypes.statistic_by,
	stats = {
		none = "team_deaths",
	},
}

do
	local stats = {}

	for _, value in pairs({
		"plasteel",
		"diamantine",
	}) do
		local stat_id = string.format("seen_%s_collected", value)
		local specifier = string.format("type:%s", value)

		stats[specifier] = stat_id
	end

	SessionStats.collect_resource = {
		type = BackendTypes.ephemeral,
		stats = stats,
	}
end

SessionStats.blocked_damage = {
	type = BackendTypes.ephemeral,
	stats = {
		none = "session_my_blocked_damage",
	},
}
SessionStats.contract_team_blocked_damage = {
	type = BackendTypes.ephemeral,
	stats = {
		none = "session_team_blocked_damage",
	},
}

do
	local stats = {}

	for _, sub_faction_name in pairs({
		"chaos",
		"renegade",
		"cultist",
	}) do
		for _, attack_type in pairs({
			"melee",
			"ranged",
			"explosion",
		}) do
			local specifier = string.format("type:%s|name:%s", attack_type, sub_faction_name)
			local stat_name = string.format("%s_killed_with_%s", sub_faction_name, attack_type)

			stats[specifier] = stat_name
		end
	end

	SessionStats.kill_minion = {
		type = BackendTypes.statistic_by,
		stats = stats,
	}
end

do
	local stats = {}

	for _, sub_faction_name in pairs({
		"chaos",
		"renegade",
		"cultist",
	}) do
		for _, attack_type in pairs({
			"melee",
			"ranged",
			"explosion",
		}) do
			local specifier = string.format("type:%s|name:%s", attack_type, sub_faction_name)
			local stat_name = string.format("team_%s_killed_with_%s", sub_faction_name, attack_type)

			stats[specifier] = stat_name
		end
	end

	SessionStats.contract_team_kills = {
		type = BackendTypes.ephemeral,
		stats = stats,
	}
end

SessionStats.kill_boss = {
	type = BackendTypes.statistic_by,
	stats = {
		none = "session_boss_kills",
	},
}
SessionStats.rations = {
	fill_with_default = true,
	type = BackendTypes.statistic_by,
	stats = {
		destroyed = "stolen_rations_destroyed",
		recovered = "stolen_rations_recovered",
	},
}

return SessionStats
