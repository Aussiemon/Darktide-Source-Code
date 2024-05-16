-- chunkname: @scripts/settings/breed/breed_actions/bot_actions.lua

local UtilityConsiderations = require("scripts/extension_systems/behavior/utility_considerations")
local action_data = {
	name = "bot",
	activate_combat_ability = {
		ability_component_name = "combat_ability_action",
	},
	activate_grenade_ability = {
		ability_component_name = "grenade_ability_action",
	},
	combat = {
		utility_weight = 1,
		considerations = UtilityConsiderations.bot_combat,
	},
	do_rescue_ledge_hanging = {
		aim_node = "j_head",
		interaction_type = "pull_up",
	},
	do_revive = {
		aim_node = "j_head",
		interaction_type = "revive",
	},
	do_rescue_hogtied = {
		aim_node = "j_head",
		interaction_type = "rescue",
	},
	do_remove_net = {
		aim_node = "j_head",
		interaction_type = "remove_net",
	},
	fight_melee = {
		engage_range = 6,
		engage_range_near_follow_position = 10,
		override_engage_range_to_follow_position = 12,
		override_engage_range_to_follow_position_challenge = 6,
	},
	fight_melee_priority_target = {
		engage_range = math.huge,
		engage_range_near_follow_position = math.huge,
		override_engage_range_to_follow_position = math.huge,
		override_engage_range_to_follow_position_challenge = math.huge,
	},
	follow = {
		utility_weight = 1,
		considerations = UtilityConsiderations.bot_follow,
	},
	shoot = {
		evaluation_duration = 2,
		evaluation_duration_without_firing = 3,
		maximum_obstruction_reevaluation_time = 0.3,
		minimum_obstruction_reevaluation_time = 0.2,
		aim_speed = {
			10,
			10,
			12,
			20,
			20,
		},
		gestalt_behaviors = {
			none = {},
			killshot = {
				wants_aim = true,
			},
		},
	},
	shoot_priority_target = {
		evaluation_duration = 2,
		evaluation_duration_without_firing = 3,
		maximum_obstruction_reevaluation_time = 0.3,
		minimum_obstruction_reevaluation_time = 0.2,
		gestalt_behaviors = {
			none = {},
			killshot = {
				wants_aim = true,
			},
		},
	},
	switch_melee = {
		wanted_slot = "slot_primary",
	},
	switch_ranged = {
		wanted_slot = "slot_secondary",
	},
	switch_ranged_overheat = {
		wanted_slot = "slot_secondary",
	},
	switch_ranged_reload = {
		wanted_slot = "slot_secondary",
	},
}

return action_data
