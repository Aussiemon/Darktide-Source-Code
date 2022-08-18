local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.bot
local behavior_tree = {
	"BtSelectorNode",
	{
		"BtBotIdleAction",
		condition = "is_disabled",
		name = "disabled"
	},
	{
		"BtBotInteractAction",
		name = "do_revive",
		condition = "can_revive",
		action_data = action_data.do_revive
	},
	{
		"BtBotInteractAction",
		name = "do_remove_net",
		condition = "can_remove_net",
		action_data = action_data.do_remove_net
	},
	{
		"BtBotInteractAction",
		name = "do_rescue_ledge_hanging",
		condition = "can_rescue_ledge_hanging",
		action_data = action_data.do_rescue_ledge_hanging
	},
	{
		"BtBotInteractAction",
		name = "do_rescue_hogtied",
		condition = "can_rescue_hogtied",
		action_data = action_data.do_rescue_hogtied
	},
	{
		"BtBotInteractAction",
		condition = "can_use_health_station",
		name = "use_healing_station"
	},
	{
		"BtBotInteractAction",
		condition = "can_loot",
		name = "loot"
	},
	{
		"BtBotActivateAbilityAction",
		name = "activate_combat_ability",
		condition = "can_activate_ability",
		action_data = action_data.activate_combat_ability
	},
	{
		"BtBotActivateAbilityAction",
		name = "activate_grenade_ability",
		condition = "can_activate_ability",
		action_data = action_data.activate_grenade_ability
	},
	{
		"BtSelectorNode",
		{
			"BtBotInventorySwitchAction",
			name = "switch_melee",
			condition = "wrong_slot_for_target_type",
			condition_args = {
				target_type = "melee"
			},
			action_data = action_data.switch_melee
		},
		{
			"BtBotInventorySwitchAction",
			name = "switch_ranged",
			condition = "wrong_slot_for_target_type",
			condition_args = {
				target_type = "ranged"
			},
			action_data = action_data.switch_ranged
		},
		condition = "has_target",
		name = "switch_to_proper_weapon"
	},
	{
		"BtSelectorNode",
		{
			"BtSelectorNode",
			{
				"BtBotMeleeAction",
				name = "fight_melee_priority_target",
				action_data = action_data.fight_melee_priority_target
			},
			condition = "bot_in_melee_range",
			name = "melee_priority_target"
		},
		{
			"BtSelectorNode",
			{
				"BtBotShootAction",
				name = "shoot_priority_target",
				action_data = action_data.shoot_priority_target
			},
			name = "ranged_priority_target",
			condition = "has_target_and_ammo_greater_than",
			condition_args = {
				overheat_limit_type = "critical_threshold",
				overheat_limit = 0.9,
				ammo_percentage = 0
			}
		},
		condition = "has_priority_or_urgent_target",
		name = "attack_priority_target"
	},
	{
		"BtBotTeleportToAllyAction",
		condition = "is_too_far_from_ally",
		name = "teleport_out_of_range"
	},
	{
		"BtRandomUtilityNode",
		{
			"BtSelectorNode",
			{
				"BtSelectorNode",
				{
					"BtBotMeleeAction",
					name = "fight_melee",
					action_data = action_data.fight_melee
				},
				condition = "bot_in_melee_range",
				name = "melee"
			},
			{
				"BtSelectorNode",
				{
					"BtBotShootAction",
					name = "shoot",
					action_data = action_data.shoot
				},
				name = "ranged",
				condition = "has_target_and_ammo_greater_than",
				condition_args = {
					overheat_limit_type = "low_threshold",
					overheat_limit = 0.9,
					ammo_percentage = 0.5
				}
			},
			name = "combat",
			action_data = action_data.combat
		},
		{
			"BtSelectorNode",
			{
				"BtBotTeleportToAllyAction",
				condition = "cant_reach_ally",
				name = "teleport_no_path"
			},
			{
				"BtSelectorNode",
				{
					"BtBotInventorySwitchAction",
					name = "switch_ranged_overheat",
					condition = "is_slot_not_wielded",
					action_data = action_data.switch_ranged_overheat
				},
				{
					"BtBotReloadAction",
					name = "vent"
				},
				name = "vent_overheat",
				condition = "should_vent_overheat",
				condition_args = {
					start_min_percentage = 0.5,
					start_max_percentage = 0.99,
					overheat_limit_type = "low_threshold",
					stop_percentage = 0.1
				}
			},
			{
				"BtSelectorNode",
				{
					"BtBotInventorySwitchAction",
					name = "switch_ranged_reload",
					condition = "is_slot_not_wielded",
					action_data = action_data.switch_ranged_reload
				},
				{
					"BtBotReloadAction",
					name = "do_reload"
				},
				condition = "should_reload",
				name = "reload"
			},
			{
				"BtBotFollowAction",
				name = "successful_follow"
			},
			name = "follow",
			action_data = action_data.follow
		},
		name = "in_combat"
	},
	{
		"BtBotIdleAction",
		name = "idle"
	},
	name = "bot"
}

return behavior_tree
