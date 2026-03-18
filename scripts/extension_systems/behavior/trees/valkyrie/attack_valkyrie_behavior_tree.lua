-- chunkname: @scripts/extension_systems/behavior/trees/valkyrie/attack_valkyrie_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.attack_valkyrie
local behavior_tree = {
	"BtSelectorNode",
	{
		"BtDieAction",
		condition = "is_dead",
		name = "death",
		action_data = action_data.death,
	},
	{
		"BtStaggerAction",
		condition = "is_staggered",
		name = "stagger",
		action_data = action_data.stagger,
	},
	{
		"BtFleeAction",
		condition = "wants_flee",
		name = "flee",
		action_data = action_data.flee,
	},
	{
		"BtRendezvousAction",
		condition = "should_rendezvous",
		name = "rendezvous",
		action_data = action_data.rendezvous,
	},
	{
		"BtValkyrieShootAction",
		condition = "has_or_had_target_unit",
		name = "shoot",
		action_data = action_data.shoot,
	},
	{
		"BtRendezvousAction",
		condition = "should_rendezvous",
		name = "fallback_rendezvous",
		action_data = action_data.fallback_rendezvous,
	},
	{
		"BtNilAction",
		name = "idle",
		action_data = action_data.idle,
	},
	name = "attack_valkyrie",
}

return behavior_tree
