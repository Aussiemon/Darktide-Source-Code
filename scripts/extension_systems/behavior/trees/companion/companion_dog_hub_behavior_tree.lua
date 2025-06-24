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
				args = {},
			},
			{
				hook = "set_component_value",
				args = {
					component_name = "behavior",
					field = "current_state",
					value = "follow",
				},
			},
		},
	},
	{
		"BtSelectorNode",
		{
			"BtSelectorNode",
			action_data = action_data.companion_has_move_position,
			{
				"BtCompanionMoveToPositionAction",
				name = "move_to_position",
				action_data = action_data.move_to_position,
			},
			condition = "companion_has_move_position",
			name = "companion_has_move_position",
		},
		{
			"BtIdleAction",
			name = "idle",
			action_data = action_data.idle,
		},
		name = "move_or_idle_selector",
	},
	condition = "should_companion_moving",
	leave_hook = "companion_leaving_movement",
	name = "follow",
}
local START_HUB_INTERACTION = {
	"BtSelectorNode",
	action_data = action_data.hub_interaction_with_player_selector,
	{
		"BtSequenceNode",
		{
			"BtCompanionMoveToPositionAction",
			name = "hub_interaction_move_to_position",
			action_data = action_data.hub_interaction_move_to_position,
		},
		{
			"BtCompanionHubInteractionWithPlayerAction",
			name = "start_hub_interaction_with_player",
			action_data = action_data.start_hub_interaction_with_player,
		},
		condition = "should_reposition_for_hub_interaction",
		name = "hub_interaction_with_player_sequence",
	},
	condition = "should_reposition_for_hub_interaction",
	enter_hook = "companion_prepare_for_movement",
	leave_hook = "companion_leaving_movement",
	name = "hub_interaction_with_player_selector",
}
local MOVE_CLOSE_TO_OWNER = {
	"BtSelectorNode",
	action_data = action_data.move_close_to_owner_selector,
	{
		"BtCompanionMoveToPositionAction",
		name = "move_close_to_owner_action",
		action_data = action_data.move_close_to_owner_action,
	},
	condition = "should_move_close_to_owner",
	enter_hook = "companion_prepare_for_movement",
	leave_hook = "companion_leaving_movement",
	name = "move_close_to_owner_selector",
}
local IDLE = {
	"BtSelectorNode",
	enter_hook = {
		hook = "set_component_values",
		args = {
			{
				component_name = "behavior",
				field = "current_state",
				value = "idle",
			},
			{
				component_name = "follow",
				field = "current_movement_type",
				value = "none",
			},
		},
	},
	MOVE_CLOSE_TO_OWNER,
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle,
	},
	name = "rest",
}
local behavior_tree = {
	"BtSelectorNode",
	{
		"BtManualTeleportAction",
		condition = "has_manual_teleport",
		name = "manual_teleport",
		action_data = action_data.manual_teleport,
	},
	START_HUB_INTERACTION,
	FOLLOW,
	IDLE,
	name = "companion_dog_hub",
}

return behavior_tree
