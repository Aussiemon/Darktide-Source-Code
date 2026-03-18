-- chunkname: @scripts/extension_systems/behavior/trees/sand_vortex/sand_vortex_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.sand_vortex
local behavior_tree = {
	"BtSelectorNode",
	{
		"BtDieAction",
		condition = "is_dead",
		name = "death",
		action_data = action_data.death,
	},
	{
		"BTVortexWanderAction",
		name = "vortex_wander",
		action_data = action_data.vortex_wander,
	},
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle,
	},
	name = "sand_vortex",
}

return behavior_tree
