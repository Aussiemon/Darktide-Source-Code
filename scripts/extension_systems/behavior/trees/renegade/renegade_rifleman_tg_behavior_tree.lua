﻿-- chunkname: @scripts/extension_systems/behavior/trees/renegade/renegade_rifleman_tg_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.renegade_rifleman
local behavior_tree = {
	"BtSelectorNode",
	{
		"BtDieAction",
		condition = "is_dead",
		name = "death",
		action_data = action_data.death,
	},
	{
		"BtShootPositionAction",
		name = "shoot_training_grounds_sprint",
		action_data = action_data.shoot_training_grounds_sprint,
	},
	name = "renegade_rifleman_tg",
}

return behavior_tree
