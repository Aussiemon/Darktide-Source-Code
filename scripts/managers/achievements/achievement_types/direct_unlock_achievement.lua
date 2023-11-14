local DirectUnlockAchievement = {
	trigger_type = nil,
	trigger = nil,
	get_triggers = nil,
	get_progress = nil,
	setup = function ()
		return false
	end,
	verifier = function (achievement_definition)
		return true
	end
}

return DirectUnlockAchievement
