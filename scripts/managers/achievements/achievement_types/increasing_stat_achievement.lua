-- chunkname: @scripts/managers/achievements/achievement_types/increasing_stat_achievement.lua

local StatDefinitions = require("scripts/managers/stats/stat_definitions")
local IncreasingStatAchievement = {}

IncreasingStatAchievement.trigger_type = "stat"

IncreasingStatAchievement.trigger = function (achievement_definition, scratch_pad, player_id, stat_name, stat_value)
	return stat_value >= achievement_definition.target
end

IncreasingStatAchievement.setup = function (achievement_definition, scratch_pad, player_id)
	local stat_value = Managers.stats:read_user_stat(player_id, achievement_definition.stat_name)

	return stat_value and stat_value >= achievement_definition.target
end

IncreasingStatAchievement.verifier = function (achievement_definition)
	local has_stat = type(achievement_definition.stat_name) == "string"
	local has_target = type(achievement_definition.target) == "number"
	local stat_exists = StatDefinitions[achievement_definition.stat_name] ~= nil

	return has_stat and has_target and stat_exists
end

IncreasingStatAchievement.get_triggers = function (achievement_definition)
	return achievement_definition.stat_name
end

IncreasingStatAchievement.get_progress = function (achievement_definition, player, prioritize_running)
	local player_id = player.remote and player.stat_id or player:local_player_id()
	local stat_name = achievement_definition.stat_name
	local prefer_running = achievement_definition.flags.prioritize_running or prioritize_running

	if prefer_running and StatDefinitions[stat_name].running_stat then
		stat_name = StatDefinitions[stat_name].running_stat
	end

	return Managers.stats:read_user_stat(player_id, stat_name), achievement_definition.target
end

return IncreasingStatAchievement
