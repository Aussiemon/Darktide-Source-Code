-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_buffs_data/hordes_legendary_adamant_buffs_data.lua

local MissionBuffsSettings = require("scripts/managers/mission_buffs/mission_buffs_settings")
local filtering_categories = MissionBuffsSettings.filtering_categories
local hordes_legendary_adamant_buffs_data = {}

table.make_unique(hordes_legendary_adamant_buffs_data)

hordes_legendary_adamant_buffs_data.hordes_buff_adamant_stance_immunity = {
	description = "You are immune to all damage during Stance's duration",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_adamant_stance_immunity",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "The Lex Protects",
	filter_category = filtering_categories.regular,
	buff_stats = {
		talent_name = {
			value = "loc_talent_adamant_stance_ability_name",
			format_type = "loc_string"
		}
	}
}
hordes_legendary_adamant_buffs_data.hordes_buff_adamant_drone_stun = {
	description = "Your Nuncio Aquila shocks enemies inside its area every X seconds",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_adamant_drone_stun",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Shocking Condemnation",
	filter_category = filtering_categories.regular,
	buff_stats = {
		talent_name = {
			value = "loc_talent_ability_area_buff_drone",
			format_type = "loc_string"
		},
		time = {
			value = 5,
			format_type = "number"
		}
	}
}
hordes_legendary_adamant_buffs_data.hordes_buff_adamant_random_bash = {
	description = "Your Bash applies Soulblaze, Burn or Bleed on Hit. Random which one for each enemy",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_adamant_random_bash",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Uncalculated Reactions",
	filter_category = filtering_categories.regular,
	buff_stats = {
		talent_name = {
			value = "loc_talent_adamant_charge_ability_name",
			format_type = "loc_string"
		}
	}
}
hordes_legendary_adamant_buffs_data.hordes_buff_adamant_mine_explosion = {
	description = "Your Shock Mine explodes when its duration expires",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_adamant_mine_explosion",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Aftershock",
	filter_category = filtering_categories.regular,
	buff_stats = {
		talent_name = {
			value = "loc_talent_ability_shock_mine",
			format_type = "loc_string"
		}
	}
}
hordes_legendary_adamant_buffs_data.hordes_buff_adamant_grenade_multi = {
	description = "Replenish a grenade if your Grenade kills X or more enemies.",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_adamant_grenade_multi",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Bombardment",
	filter_category = filtering_categories.regular,
	buff_stats = {
		talent_name = {
			value = "loc_talent_ability_adamant_grenade_improved",
			format_type = "loc_string"
		},
		amount = {
			value = 10,
			format_type = "number"
		}
	}
}
hordes_legendary_adamant_buffs_data.hordes_buff_adamant_auto_detonate = {
	description = "Trigger Detonation whenever the Cyber-Mastiff Poundes an Elite/Special/Monster at no Charge Cost. Xs internal Cooldown.",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_adamant_auto_detonate",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Trigger-Happy",
	filter_category = filtering_categories.regular,
	buff_stats = {
		talent_name = {
			value = "loc_talent_ability_detonate",
			format_type = "loc_string"
		},
		time = {
			value = 10,
			format_type = "number"
		}
	}
}

return hordes_legendary_adamant_buffs_data
