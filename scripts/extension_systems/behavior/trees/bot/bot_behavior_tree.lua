-- chunkname: @scripts/extension_systems/behavior/trees/bot/bot_behavior_tree.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.bot
local behavior_tree = {
	"BtSelectorNode",
	{
		"BtBotIdleAction",
		condition = "is_disabled",
		name = "disabled",
	},
	{
		"BtBotInteractAction",
		condition = "can_revive",
		name = "do_revive",
		action_data = action_data.do_revive,
	},
	{
		"BtBotInteractAction",
		condition = "can_remove_net",
		name = "do_remove_net",
		action_data = action_data.do_remove_net,
	},
	{
		"BtBotInteractAction",
		condition = "can_rescue_ledge_hanging",
		name = "do_rescue_ledge_hanging",
		action_data = action_data.do_rescue_ledge_hanging,
	},
	{
		"BtBotInteractAction",
		condition = "can_rescue_hogtied",
		name = "do_rescue_hogtied",
		action_data = action_data.do_rescue_hogtied,
	},
	{
		"BtBotInteractAction",
		condition = "can_use_health_station",
		name = "use_healing_station",
	},
	{
		"BtBotInteractAction",
		condition = "can_loot",
		name = "loot",
	},
	{
		"BtBotActivateAbilityAction",
		condition = "can_activate_ability",
		name = "activate_combat_ability",
		action_data = action_data.activate_combat_ability,
	},
	{
		"BtBotActivateAbilityAction",
		condition = "can_activate_ability",
		name = "activate_grenade_ability",
		action_data = action_data.activate_grenade_ability,
	},
	{
		"BtSelectorNode",
		{
			"BtBotInventorySwitchAction",
			condition = "wrong_slot_for_target_type",
			name = "switch_melee",
			condition_args = {
				target_type = "melee",
			},
			action_data = action_data.switch_melee,
		},
		{
			"BtBotInventorySwitchAction",
			condition = "wrong_slot_for_target_type",
			name = "switch_ranged",
			condition_args = {
				target_type = "ranged",
			},
			action_data = action_data.switch_ranged,
		},
		condition = "has_target",
		name = "switch_to_proper_weapon",
	},
	{
		"BtSelectorNode",
		{
			"BtSelectorNode",
			{
				"BtBotMeleeAction",
				name = "fight_melee_priority_target",
				action_data = action_data.fight_melee_priority_target,
			},
			condition = "bot_in_melee_range",
			name = "melee_priority_target",
		},
		{
			"BtSelectorNode",
			condition_args = {
				ammo_percentage = 0,
				overheat_limit = 0.9,
				overheat_limit_type = "critical_threshold",
			},
			{
				"BtBotShootAction",
				name = "shoot_priority_target",
				action_data = action_data.shoot_priority_target,
			},
			condition = "has_target_and_ammo_greater_than",
			name = "ranged_priority_target",
		},
		condition = "has_priority_or_urgent_target",
		name = "attack_priority_target",
	},
	{
		"BtBotTeleportToAllyAction",
		condition = "is_too_far_from_ally",
		name = "teleport_out_of_range",
	},
	{
		"BtRandomUtilityNode",
		{
			"BtSelectorNode",
			action_data = action_data.combat,
			{
				"BtSelectorNode",
				{
					"BtBotMeleeAction",
					name = "fight_melee",
					action_data = action_data.fight_melee,
				},
				condition = "bot_in_melee_range",
				name = "melee",
			},
			{
				"BtSelectorNode",
				condition_args = {
					ammo_percentage = 0.5,
					overheat_limit = 0.9,
					overheat_limit_type = "low_threshold",
				},
				{
					"BtBotShootAction",
					name = "shoot",
					action_data = action_data.shoot,
				},
				condition = "has_target_and_ammo_greater_than",
				name = "ranged",
			},
			name = "combat",
		},
		{
			"BtSelectorNode",
			action_data = action_data.follow,
			{
				"BtBotTeleportToAllyAction",
				condition = "cant_reach_ally",
				name = "teleport_no_path",
			},
			{
				"BtSelectorNode",
				condition_args = {
					overheat_limit_type = "low_threshold",
					start_max_percentage = 0.99,
					start_min_percentage = 0.5,
					stop_percentage = 0.1,
				},
				{
					"BtBotInventorySwitchAction",
					condition = "is_slot_not_wielded",
					name = "switch_ranged_overheat",
					action_data = action_data.switch_ranged_overheat,
				},
				{
					"BtBotReloadAction",
					name = "vent",
				},
				condition = "should_vent_overheat",
				name = "vent_overheat",
			},
			{
				"BtSelectorNode",
				{
					"BtBotInventorySwitchAction",
					condition = "is_slot_not_wielded",
					name = "switch_ranged_reload",
					action_data = action_data.switch_ranged_reload,
				},
				{
					"BtBotReloadAction",
					name = "do_reload",
				},
				condition = "should_reload",
				name = "reload",
			},
			{
				"BtBotFollowAction",
				name = "successful_follow",
			},
			name = "follow",
		},
		name = "in_combat",
	},
	{
		"BtBotIdleAction",
		name = "idle",
	},
	name = "bot",
}

return behavior_tree
