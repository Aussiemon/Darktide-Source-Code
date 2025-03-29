-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_buffs_data/hordes_legendary_ogryn_buffs_data.lua

local MissionBuffsSettings = require("scripts/managers/mission_buffs/mission_buffs_settings")
local filtering_categories = MissionBuffsSettings.filtering_categories
local hordes_legendary_ogryn_buffs_data = {}

table.make_unique(hordes_legendary_ogryn_buffs_data)

hordes_legendary_ogryn_buffs_data.hordes_buff_ogryn_box_of_surprises = {
	description = "Grenade box drops 2 frags, 1 krak, 1 smoke, 1 fire and 1 shock",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_ogryn_box_of_surprises",
	title = "Suprise !!!",
	filter_category = filtering_categories.jackpot,
	buff_stats = {},
}
hordes_legendary_ogryn_buffs_data.hordes_buff_ogryn_omega_lucky_rock = {
	description = "Ogryn rock has a 20% chance of one shotting the target hit",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_ogryn_omega_lucky_rock",
	title = "Hard rock",
	filter_category = filtering_categories.regular,
	buff_stats = {
		chance = {
			format_type = "percentage",
			prefix = "+",
			value = 0.2,
		},
	},
}
hordes_legendary_ogryn_buffs_data.hordes_buff_ogryn_taunt_on_lunge = {
	description = "Ogryn charge now taunt enemies touched and takes 40% less damage from taunt enemies for 10s",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_ogryn_taunt_on_lunge",
	title = "Make them confused",
	filter_category = filtering_categories.regular,
	buff_stats = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			value = 0.4,
		},
	},
}
hordes_legendary_ogryn_buffs_data.hordes_buff_ogryn_apply_fire_on_shout = {
	description = "Ogryn taunt put 15 stacks of fire on ennemies",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_ogryn_apply_fire_on_shout",
	title = "Extremely offensive teasing",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		stacks = {
			format_type = "number",
			value = 15,
		},
	},
}
hordes_legendary_ogryn_buffs_data.hordes_buff_ogryn_fire_trail_on_lunge = {
	description = "Using your lunge ability burns enemies around you.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_ogryn_fire_trail_on_lunge",
	title = "Dolorean",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		stacks = {
			format_type = "number",
			value = 2,
		},
	},
}
hordes_legendary_ogryn_buffs_data.hordes_buff_ogryn_rock_charge_while_wield = {
	description = "Gain 25% damage every second while holding your friendly rock. Max of 400% increase.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_ogryn_rock_charge_while_wield",
	title = "Baby rock grow strong",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			value = 0.25,
		},
	},
}
hordes_legendary_ogryn_buffs_data.hordes_buff_ogryn_biggest_boom_grenade = {
	description = "Ogryn Grenade gains 100% damage and doubles the explosion size.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_ogryn_biggest_boom_grenade",
	title = "Forbidden tek",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		dammage = {
			format_type = "percentage",
			prefix = "+",
			value = 1,
		},
	},
}
hordes_legendary_ogryn_buffs_data.hordes_buff_ogryn_increase_penetration_during_stance = {
	description = "Ranged attacks gain 100% penetration on critical hits during Point-Blank Barrage.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_ogryn_increase_penetration_during_stance",
	title = "Balistic rock",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		penetration = {
			format_type = "percentage",
			prefix = "+",
			value = 1,
		},
	},
}

return hordes_legendary_ogryn_buffs_data
