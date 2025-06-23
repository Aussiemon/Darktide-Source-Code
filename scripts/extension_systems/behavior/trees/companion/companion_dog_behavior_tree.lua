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
		"BtCompanionUnstuckAction",
		name = "companion_unstuck",
		condition = "companion_is_out_of_bound",
		action_data = action_data.companion_unstuck
	},
	{
		"BtMoveWithPlatformAction",
		name = "move_with_platform",
		condition = "companion_is_on_platform",
		action_data = action_data.move_with_platform
	},
	{
		"BtManualTeleportAction",
		name = "manual_teleport",
		condition = "has_manual_teleport",
		action_data = action_data.manual_teleport
	},
	{
		"BtSelectorNode",
		{
			"BtTeleportAction",
			name = "teleport",
			condition = "at_teleport_smart_object",
			action_data = action_data.teleport
		},
		{
			"BtClimbAction",
			name = "climb",
			condition = "at_climb_smart_object",
			action_data = action_data.climb
		},
		{
			"BtJumpAcrossAction",
			name = "jump_across",
			condition = "at_jump_smart_object",
			action_data = action_data.jump_across
		},
		{
			"BtOpenDoorAction",
			name = "open_door",
			condition = "at_door_smart_object",
			action_data = action_data.open_door
		},
		condition = "at_smart_object",
		name = "smart_object"
	},
	{
		"BtSelectorNode",
		{
			"BtSequenceNode",
			{
				"BtCompanionApproachAction",
				name = "approach_target",
				action_data = action_data.approach_target
			},
			{
				"BtCompanionLeapAction",
				name = "leap",
				action_data = action_data.leap
			},
			{
				"BtSelectorNode",
				{
					"BtSelectorNode",
					{
						"BtCompanionTargetPouncedAction",
						name = "target_pounced",
						condition = "is_correct_pounce_action",
						condition_args = {
							pounce_action = "human"
						},
						action_data = action_data.target_pounced
					},
					{
						"BtCompanionTargetPounceAndEscapeAction",
						name = "target_pounced_and_escape",
						action_data = action_data.target_pounced_and_escape
					},
					condition = "companion_has_pounce_target_and_alive",
					name = "pounce"
				},
				{
					"BtCompanionFallAction",
					name = "falling",
					condition = "companion_has_pounce_target",
					action_data = action_data.falling
				},
				name = "pounce_or_fall"
			},
			condition = "companion_can_pounce",
			name = "leap_sequence"
		},
		{
			"BtCompanionMoveAroundEnemyAction",
			name = "move_around_enemy",
			action_data = action_data.move_around_enemy
		},
		leave_hook = "companion_restore_pounce_state",
		name = "combat",
		condition = "companion_is_aggroed"
	},
	FOLLOW,
	IDLE,
	name = "companion_dog"
}

return behavior_tree
