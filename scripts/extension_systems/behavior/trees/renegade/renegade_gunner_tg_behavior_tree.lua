-- chunkname: @scripts/extension_systems/behavior/trees/renegade/renegade_gunner_tg_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.renegade_gunner
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
		name = "shoot_spray_n_pray",
		action_data = action_data.shoot_spray_n_pray,
	},
	name = "renegade_gunner_tg",
}

return behavior_tree
