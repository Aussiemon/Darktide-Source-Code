-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_buffs_data/hordes_legendary_zealot_buffs_data.lua

local MissionBuffsSettings = require("scripts/managers/mission_buffs/mission_buffs_settings")
local filtering_categories = MissionBuffsSettings.filtering_categories
local hordes_legendary_zealot_buffs_data = {}

table.make_unique(hordes_legendary_zealot_buffs_data)

hordes_legendary_zealot_buffs_data.hordes_buff_zealot_channel_heals_corruption = {
	description = "Zealot chorus of spiritual fortitude heals corruption up to 25% of Max HP.",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_zealot_channel_heals_corruption",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Uncorrupted",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		health = {
			value = 0.25,
			format_type = "percentage"
		}
	}
}
hordes_legendary_zealot_buffs_data.hordes_buff_zealot_shock_grenade_increase_next_hit_damage = {
	description = "Stun grenades increases the damage done by the next damage taken when hit by 150%",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_zealot_shock_grenade_increase_next_hit_damage",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Weak to greatness",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		damage = {
			value = 1.5,
			format_type = "percentage"
		}
	}
}
hordes_legendary_zealot_buffs_data.hordes_buff_zealot_fire_pulse_while_aiming_lunge = {
	description = "Fury of the faithful create a ring of fire around the player until you charge forward",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_zealot_fire_pulse_while_aiming_lunge",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Unfaithfulls, follow my steps",
	filter_category = filtering_categories.jackpot,
	buff_stats = {}
}
hordes_legendary_zealot_buffs_data.hordes_buff_zealot_lunge_hit_triggers_shout = {
	description = "Fury of the faithful trigger voice of command on impact",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_zealot_lunge_hit_triggers_shout",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Born a leader",
	filter_category = filtering_categories.jackpot,
	buff_stats = {}
}
hordes_legendary_zealot_buffs_data.hordes_buff_zealot_regen_toughness_inside_fire_grenade = {
	description = "Standing in the fire of a fire grenade regenerate 100% thoughness every 3 seconds",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_zealot_regen_toughness_inside_fire_grenade",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Fire addict",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		thoughness = {
			value = 1,
			format_type = "percentage"
		},
		time = {
			value = 3,
			format_type = "number"
		}
	}
}
hordes_legendary_zealot_buffs_data.hordes_buff_zealot_knives_bleed_and_restore_thoughness_on_kill = {
	description = "Throwing knife applies bleeding, if the target die while bleeding recover %thoughness = to stacks of bleeding remaining",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_zealot_knives_bleed_and_restore_thoughness_on_kill",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Dracula",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		thoughness = {
			value = 0.1,
			format_type = "percentage"
		}
	}
}
hordes_legendary_zealot_buffs_data.hordes_buff_zealot_fire_trail_on_lunge = {
	description = "Using your lunge ability burns enemies around you.",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_zealot_fire_trail_on_lunge",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Dolorean",
	filter_category = filtering_categories.jackpot,
	buff_stats = {}
}

return hordes_legendary_zealot_buffs_data
