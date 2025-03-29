-- chunkname: @scripts/extension_systems/behavior/trees/cultist/cultist_ritualist_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.cultist_ritualist
local behavior_tree = {
	"BtSelectorNode",
	{
		"BtDieAction",
		condition = "is_dead",
		name = "death",
		action_data = action_data.death,
	},
	{
		"BtDisableAction",
		condition = "is_minion_disabled",
		name = "disable",
		action_data = action_data.disable,
	},
	{
		"BtStaggerAction",
		condition = "is_staggered",
		name = "stagger",
		action_data = action_data.stagger,
	},
	{
		"BtCultistRitualistChantingAction",
		name = "chanting",
		action_data = action_data.chanting,
	},
	name = "cultist_ritualist",
}

return behavior_tree
