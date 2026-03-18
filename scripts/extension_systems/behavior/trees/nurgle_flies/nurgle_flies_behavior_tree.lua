-- chunkname: @scripts/extension_systems/behavior/trees/nurgle_flies/nurgle_flies_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.nurgle_flies
local behavior_tree = {
	"BtSelectorNode",
	{
		"BtDieAction",
		condition = "is_dead",
		name = "death",
		action_data = action_data.death,
	},
	{
		"BTNurgleFliesChaseTargetAction",
		name = "nurgle_flies_chase_target",
		action_data = action_data.nurgle_flies_chase_target,
	},
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle,
	},
	name = "nurgle_flies",
}

return behavior_tree
