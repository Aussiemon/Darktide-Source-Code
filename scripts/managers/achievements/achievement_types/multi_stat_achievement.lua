-- chunkname: @scripts/managers/achievements/achievement_types/multi_stat_achievement.lua

local StatDefinitions = require("scripts/managers/stats/stat_definitions")
local MultiStatAchievements = {}

MultiStatAchievements.trigger_type = "stat"

MultiStatAchievements.trigger = function (achievement_definition, scratch_pad, _, stat_name, stat_value)
	local stats = achievement_definition.stats
	local stat = stats[stat_name]
	local stat_target = stat.target
	local increasing = stat.increasing
	local done = increasing and stat_target <= stat_value or not increasing and stat_value <= stat_target
	local _scratch_pad = scratch_pad[achievement_definition.id]

	if done and not _scratch_pad[stat_name] then
		_scratch_pad[stat_name] = true
		_scratch_pad.__size = _scratch_pad.__size + 1
	end

	return _scratch_pad.__size >= achievement_definition.target
end

MultiStatAchievements.setup = function (achievement_definition, scratch_pad, player_id)
	local _scratch_pad = {
		__size = 0,
	}
	local stats = achievement_definition.stats

	for stat_name, stat in pairs(stats) do
		local stat_value = Managers.stats:read_user_stat(player_id, stat_name)
		local stat_target = stat.target
		local increasing = stat.increasing
		local done = stat_value and (increasing and stat_target <= stat_value or not increasing and stat_value <= stat_target)

		if done then
			_scratch_pad[stat_name] = true
			_scratch_pad.__size = _scratch_pad.__size + 1
		end
	end

	scratch_pad[achievement_definition.id] = _scratch_pad

	return _scratch_pad.__size >= achievement_definition.target
end

MultiStatAchievements.verifier = function (achievement_definition)
	local target = achievement_definition.target
	local stats = achievement_definition.stats
	local has_target = type(target) == "number"
	local has_stats = type(stats) == "table"

	if not has_target or not has_stats then
		return false
	end

	if target > table.size(stats) then
		return false
	end

	for stat_name, stat in pairs(stats) do
		local has_increasing = type(stat.increasing) == "boolean"
		local has_target = type(stat.target) == "number"
		local has_name = type(stat_name) == "string"

		if not has_increasing or not has_target or not has_name then
			return false
		end

		local stat_exists = StatDefinitions[stat_name] ~= nil

		if not stat_exists then
			return false
		end
	end

	return true
end

MultiStatAchievements.get_triggers = function (achievement_definition)
	return achievement_definition.stats
end

MultiStatAchievements.get_progress = function (achievement_definition, player)
	local player_id = player.remote and player.stat_id or player:local_player_id()
	local result = 0
	local stats = achievement_definition.stats

	for stat_name, stat in pairs(stats) do
		local target = stat.target
		local increasing = stat.increasing
		local value = Managers.stats:read_user_stat(player_id, stat_name)
		local done = increasing and target <= value or not increasing and value <= target

		if done then
			result = result + 1
		end
	end

	return result, achievement_definition.target
end

return MultiStatAchievements
