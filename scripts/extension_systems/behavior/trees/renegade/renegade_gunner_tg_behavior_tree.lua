local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.renegade_gunner
local behavior_tree = {
	"BtSelectorNode",
	{
		"BtDieAction",
		name = "death",
		condition = "is_dead",
		action_data = action_data.death
	},
	{
		"BtShootPositionAction",
		name = "shoot_spray_n_pray",
		action_data = action_data.shoot_spray_n_pray
	},
	name = "renegade_gunner_tg"
}

return behavior_tree
