-- chunkname: @scripts/extension_systems/behavior/trees/companion/companion_dog_hub_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.companion_dog_hub
local FOLLOW = {
	"BtSelectorNode",
	action_data = action_data.follow,
	enter_hook = {
		hook = "execute_multiple_hooks",
		args = {
			{
				hook = "companion_prepare_for_movement",
				args = {}
			},
			{
				hook = "set_component_value",
				args = {
					value = "follow",
					field = "current_state",
					component_name = "behavior"
				}
			}
		}
	},
	{
		"BtSelectorNode",
		{
			"BtSelectorNode",
			action_data = action_data.companion_has_move_position,
			{
				"BtCompanionMoveToPositionAction",
				name = "move_to_position",
				action_data = action_data.move_to_position
			},
			name = "companion_has_move_position",
			condition = "companion_has_move_position"
		},
		{
			"BtIdleAction",
			name = "idle",
			action_data = action_data.idle
		},
		name = "move_or_idle_selector"
	},
	name = "follow",
	leave_hook = "companion_leaving_movement",
	condition = "should_companion_moving"
}
local START_HUB_INTERACTION = {
	"BtSelectorNode",
	action_data = action_data.hub_interaction_with_player_selector,
	{
		"BtSequenceNode",
		{
			"BtCompanionMoveToPositionAction",
			name = "hub_interaction_move_to_position",
			action_data = action_data.hub_interaction_move_to_position
		},
		{
			"BtCompanionHubInteractionWithPlayerAction",
			name = "start_hub_interaction_with_player",
			action_data = action_data.start_hub_interaction_with_player
		},
		condition = "should_reposition_for_hub_interaction",
		name = "hub_interaction_with_player_sequence"
	},
	name = "hub_interaction_with_player_selector",
	leave_hook = "companion_leaving_movement",
	condition = "should_reposition_for_hub_interaction",
	enter_hook = "companion_prepare_for_movement"
}
local MOVE_CLOSE_TO_OWNER = {
	"BtSelectorNode",
	action_data = action_data.move_close_to_owner_selector,
	{
		"BtCompanionMoveToPositionAction",
		name = "move_close_to_owner_action",
		action_data = action_data.move_close_to_owner_action
	},
	name = "move_close_to_owner_selector",
	leave_hook = "companion_leaving_movement",
	condition = "should_move_close_to_owner",
	enter_hook = "companion_prepare_for_movement"
}
local IDLE = {
	"BtSelectorNode",
	enter_hook = {
		hook = "set_component_values",
		args = {
			{
				value = "idle",
				field = "current_state",
				component_name = "behavior"
			},
			{
				value = "none",
				field = "current_movement_type",
				component_name = "follow"
			}
		}
	},
	MOVE_CLOSE_TO_OWNER,
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle
	},
	name = "rest"
}
local behavior_tree = {
	"BtSelectorNode",
	{
		"BtManualTeleportAction",
		name = "manual_teleport",
		condition = "has_manual_teleport",
		action_data = action_data.manual_teleport
	},
	START_HUB_INTERACTION,
	FOLLOW,
	IDLE,
	name = "companion_dog_hub"
}

return behavior_tree
