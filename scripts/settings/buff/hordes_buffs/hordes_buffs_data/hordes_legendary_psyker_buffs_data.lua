-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_buffs_data/hordes_legendary_psyker_buffs_data.lua

local MissionBuffsSettings = require("scripts/managers/mission_buffs/mission_buffs_settings")
local filtering_categories = MissionBuffsSettings.filtering_categories
local hordes_legendary_psyker_buffs_data = {}

table.make_unique(hordes_legendary_psyker_buffs_data)

hordes_legendary_psyker_buffs_data.hordes_buff_psyker_brain_burst_burns_and_bleeds_on_hit = {
	description = "Brain burst applies 5 stacks of burning and bleeding on impact",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_psyker_brain_burst_burns_and_bleeds_on_hit",
	title = "No escape",
	filter_category = filtering_categories.regular,
	buff_stats = {
		stack = {
			format_type = "number",
			value = 5,
		},
	},
}
hordes_legendary_psyker_buffs_data.hordes_buff_psyker_brain_burst_spreads_fire_on_hit = {
	description = "Brain Burst spreads fire to nearby enemies when hitting enemies on fire. Killing any enemy with Brain Burst always spreads fire.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_psyker_brain_burst_spreads_fire_on_hit",
	title = "Unleash hell",
	filter_category = filtering_categories.jackpot,
	buff_stats = {},
}
hordes_legendary_psyker_buffs_data.hordes_buff_psyker_smite_always_max_damage = {
	description = "Smite does not need to charge to be at max damage anymore",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_psyker_smite_always_max_damage",
	title = "Unlimited power",
	filter_category = filtering_categories.jackpot,
	buff_stats = {},
}
hordes_legendary_psyker_buffs_data.hordes_buff_psyker_recover_knife_on_knife_kill = {
	description = "Recover one flying shard by enemy killed with flying shards hits",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_psyker_recover_knife_on_knife_kill",
	title = "Houdini trick",
	filter_category = filtering_categories.jackpot,
	buff_stats = {},
}
hordes_legendary_psyker_buffs_data.hordes_buff_psyker_burning_on_throwing_knife_hit = {
	description = "Flying shards applies burning on hit",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_psyker_burning_on_throwing_knife_hit",
	title = "Burning knife",
	filter_category = filtering_categories.jackpot,
	buff_stats = {},
}
hordes_legendary_psyker_buffs_data.hordes_buff_psyker_shout_always_stagger = {
	description = "Psyker venting shriek stagger any type of enemies",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_psyker_shout_always_stagger",
	title = "FUS RO DAH",
	filter_category = filtering_categories.jackpot,
	buff_stats = {},
}
hordes_legendary_psyker_buffs_data.hordes_buff_psyker_shout_boosts_allies = {
	description = "Venting shreik boost allies damage and thoughness resistance of 50% for 5 seconds if they are touched by the ability",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_psyker_shout_boosts_allies",
	title = "Sweet dream",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		dammage = {
			format_type = "number",
			num_decimals = 2,
			prefix = "+",
			value = 0.5,
		},
		time = {
			format_type = "number",
			value = 5,
		},
	},
}
hordes_legendary_psyker_buffs_data.hordes_buff_psyker_shock_on_touch_force_field = {
	description = "Telekine dome electrocute enemies passing through",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_psyker_shock_on_touch_force_field",
	title = "Shocking dome",
	filter_category = filtering_categories.jackpot,
	buff_stats = {},
}
hordes_legendary_psyker_buffs_data.hordes_buff_psyker_overcharge_reduced_damage_taken = {
	description = "While being under scriers gaze, the psyker take 50% less damage from all source",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_psyker_overcharge_reduced_damage_taken",
	title = "Psybarian rage",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		dammage = {
			format_type = "percentage",
			value = 0.65,
		},
	},
}
hordes_legendary_psyker_buffs_data.hordes_buff_psyker_brain_burst_hits_nearby_enemies = {
	description = "Using brain burst on a target head pops 10 enemies around target.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_psyker_brain_burst_hits_nearby_enemies",
	title = "Behold, the god of thunder",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		ennemies = {
			format_type = "number",
			value = 10,
		},
	},
}

return hordes_legendary_psyker_buffs_data
