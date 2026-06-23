-- chunkname: @scripts/extension_systems/behavior/trees/companion/companion_servo_skull_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local CompanionServoSkullSettings = require("scripts/settings/companion/companion_servo_skull_settings")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local action_data = BreedActions.companion_servo_skull
local servo_skull_states = CompanionServoSkullSettings.STATES
local special_rules = SpecialRulesSettings.special_rules
local ABILITIES = {
	"BtSelectorNode",
	{
		"BtHackDecodeAction",
		condition = "is_correct_state",
		name = "hack_decode",
		condition_args = {
			state = servo_skull_states.hacking,
		},
		action_data = action_data.hack_decode,
	},
	{
		"BtInjectSyringeAction",
		condition = "is_correct_state",
		name = "inject_ally",
		condition_args = {
			state = servo_skull_states.inject_ally,
		},
		action_data = action_data.inject_ally,
	},
	{
		"BtShootFlamesAroundAction",
		condition = "is_correct_state",
		name = "shoot_flames",
		condition_args = {
			state = {
				servo_skull_states.flamethrower,
				servo_skull_states.flamethrower_shooting,
			},
		},
		action_data = action_data.shoot_flames,
	},
	name = "ABILITIES",
}
local behavior_tree = {
	"BtSelectorNode",
	ABILITIES,
	{
		"BtSelectorNode",
		{
			"BtShootAction",
			name = "shoot",
			action_data = action_data.shoot,
		},
		condition = "can_servo_skull_shoot",
		name = "shoots",
	},
	{
		"BtIdleAction",
		name = "idle",
		action_data = action_data.idle,
	},
	name = "companion_servo_skull",
}

return behavior_tree
