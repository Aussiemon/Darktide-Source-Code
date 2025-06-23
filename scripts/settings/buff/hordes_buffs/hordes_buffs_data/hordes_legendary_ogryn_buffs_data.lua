-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_buffs_data/hordes_legendary_ogryn_buffs_data.lua

local MissionBuffsSettings = require("scripts/managers/mission_buffs/mission_buffs_settings")
local filtering_categories = MissionBuffsSettings.filtering_categories
local hordes_legendary_ogryn_buffs_data = {}

table.make_unique(hordes_legendary_ogryn_buffs_data)

hordes_legendary_ogryn_buffs_data.hordes_buff_ogryn_box_of_surprises = {
	description = "Grenade box drops 2 frags, 1 krak, 1 smoke, 1 fire and 1 shock",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_ogryn_box_of_surprises",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Suprise !!!",
	filter_category = filtering_categories.jackpot,
	buff_stats = {}
}
hordes_legendary_ogryn_buffs_data.hordes_buff_ogryn_omega_lucky_rock = {
	description = "Ogryn rock has a 20% chance of one shotting the target hit",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_ogryn_omega_lucky_rock",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Hard rock",
	filter_category = filtering_categories.regular,
	buff_stats = {
		chance = {
			value = 0.2,
			prefix = "+",
			format_type = "percentage"
		}
	}
}
hordes_legendary_ogryn_buffs_data.hordes_buff_ogryn_taunt_on_lunge = {
	description = "Ogryn charge now taunt enemies touched and takes 40% less damage from taunt enemies for 10s",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_ogryn_taunt_on_lunge",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Make them confused",
	filter_category = filtering_categories.regular,
	buff_stats = {
		damage = {
			value = 0.4,
			prefix = "+",
			format_type = "percentage"
		}
	}
}
hordes_legendary_ogryn_buffs_data.hordes_buff_ogryn_apply_fire_on_shout = {
	description = "Ogryn taunt put 15 stacks of fire on ennemies",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_ogryn_apply_fire_on_shout",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Extremely offensive teasing",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		stacks = {
			value = 15,
			format_type = "number"
		}
	}
}
hordes_legendary_ogryn_buffs_data.hordes_buff_ogryn_fire_trail_on_lunge = {
	description = "Using your lunge ability burns enemies around you.",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_ogryn_fire_trail_on_lunge",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Dolorean",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		stacks = {
			value = 2,
			format_type = "number"
		}
	}
}
hordes_legendary_ogryn_buffs_data.hordes_buff_ogryn_rock_charge_while_wield = {
	description = "Gain 25% damage every second while holding your friendly rock. Max of 400% increase.",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_ogryn_rock_charge_while_wield",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Baby rock grow strong",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		damage = {
			value = 0.25,
			prefix = "+",
			format_type = "percentage"
		}
	}
}
hordes_legendary_ogryn_buffs_data.hordes_buff_ogryn_biggest_boom_grenade = {
	description = "Ogryn Grenade gains 100% damage and doubles the explosion size.",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_ogryn_biggest_boom_grenade",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Forbidden tek",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		dammage = {
			value = 1,
			prefix = "+",
			format_type = "percentage"
		}
	}
}
hordes_legendary_ogryn_buffs_data.hordes_buff_ogryn_increase_penetration_during_stance = {
	description = "Ranged attacks gain 100% penetration on critical hits during Point-Blank Barrage.",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_ogryn_increase_penetration_during_stance",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Balistic rock",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		penetration = {
			value = 1,
			prefix = "+",
			format_type = "percentage"
		}
	}
}

return hordes_legendary_ogryn_buffs_data
