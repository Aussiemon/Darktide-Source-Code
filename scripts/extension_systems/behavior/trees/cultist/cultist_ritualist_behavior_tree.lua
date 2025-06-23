-- chunkname: @scripts/extension_systems/behavior/trees/cultist/cultist_ritualist_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.cultist_ritualist
local behavior_tree = {
	"BtSelectorNode",
	{
		"BtDieAction",
		name = "death",
		condition = "is_dead",
		action_data = action_data.death
	},
	{
		"BtDisableAction",
		name = "disable",
		condition = "is_minion_disabled",
		action_data = action_data.disable
	},
	{
		"BtStaggerAction",
		name = "stagger",
		condition = "is_staggered",
		action_data = action_data.stagger
	},
	{
		"BtCultistRitualistChantingAction",
		name = "chanting",
		action_data = action_data.chanting
	},
	name = "cultist_ritualist"
}

return behavior_tree
