-- chunkname: @scripts/extension_systems/behavior/trees/companion/companion_dog_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.companion_dog
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
	{
		"BtCompanionUnstuckAction",
		condition = "companion_is_out_of_bound",
		name = "companion_unstuck",
		action_data = action_data.companion_unstuck,
	},
	{
		"BtMoveWithPlatformAction",
		condition = "companion_is_on_platform",
		name = "move_with_platform",
		action_data = action_data.move_with_platform,
	},
	{
		"BtSelectorNode",
		{
			"BtTeleportAction",
			condition = "at_teleport_smart_object",
			name = "teleport",
			action_data = action_data.teleport,
		},
		{
			"BtClimbAction",
			condition = "at_climb_smart_object",
			name = "climb",
			action_data = action_data.climb,
		},
		{
			"BtJumpAcrossAction",
			condition = "at_jump_smart_object",
			name = "jump_across",
			action_data = action_data.jump_across,
		},
		{
			"BtOpenDoorAction",
			condition = "at_door_smart_object",
			name = "open_door",
			action_data = action_data.open_door,
		},
		condition = "at_smart_object",
		name = "smart_object",
	},
	{
		"BtSelectorNode",
		{
			"BtSequenceNode",
			{
				"BtCompanionApproachAction",
				name = "approach_target",
				action_data = action_data.approach_target,
			},
			{
				"BtCompanionLeapAction",
				name = "leap",
				action_data = action_data.leap,
			},
			{
				"BtSelectorNode",
				{
					"BtSelectorNode",
					{
						"BtCompanionTargetPouncedAction",
						condition = "is_correct_pounce_action",
						name = "target_pounced",
						condition_args = {
							pounce_action = "human",
						},
						action_data = action_data.target_pounced,
					},
					{
						"BtCompanionTargetPounceAndEscapeAction",
						name = "target_pounced_and_escape",
						action_data = action_data.target_pounced_and_escape,
					},
					condition = "companion_has_pounce_target_and_alive",
					name = "pounce",
				},
				{
					"BtCompanionFallAction",
					condition = "companion_has_pounce_target",
					name = "falling",
					action_data = action_data.falling,
				},
				name = "pounce_or_fall",
			},
			condition = "companion_can_pounce",
			name = "leap_sequence",
		},
		{
			"BtCompanionMoveAroundEnemyAction",
			name = "move_around_enemy",
			action_data = action_data.move_around_enemy,
		},
		condition = "companion_is_aggroed",
		leave_hook = "companion_restore_pounce_state",
		name = "combat",
	},
	FOLLOW,
	IDLE,
	name = "companion_dog",
}

return behavior_tree
