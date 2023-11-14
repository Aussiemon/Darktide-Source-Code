local StatDefinitions = require("scripts/managers/stats/stat_definitions")
local DecreasingStatAchievement = {
	trigger_type = "stat",
	trigger = function (achievement_definition, scratch_pad, player_id, stat_name, stat_value)
		return stat_value <= achievement_definition.target
	end,
	setup = function (achievement_definition, scratch_pad, player_id)
		local stat_value = Managers.stats:read_user_stat(player_id, achievement_definition.stat_name)

		return stat_value and stat_value <= achievement_definition.target
	end,
	verifier = function (achievement_definition)
		local has_stat = type(achievement_definition.stat_name) == "string"
		local has_target = type(achievement_definition.target) == "number"
		local stat_exists = StatDefinitions[achievement_definition.stat_name] ~= nil

		return has_stat and has_target and stat_exists
	end,
	get_triggers = function (achievement_definition)
		return achievement_definition.stat_name
	end,
	get_progress = nil
}

return DecreasingStatAchievement
