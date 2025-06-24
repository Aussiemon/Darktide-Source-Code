-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_buffs_data/hordes_legendary_adamant_buffs_data.lua

local MissionBuffsSettings = require("scripts/managers/mission_buffs/mission_buffs_settings")
local filtering_categories = MissionBuffsSettings.filtering_categories
local hordes_legendary_adamant_buffs_data = {}

table.make_unique(hordes_legendary_adamant_buffs_data)

hordes_legendary_adamant_buffs_data.hordes_buff_adamant_stance_immunity = {
	description = "You are immune to all damage during Stance's duration",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_adamant_stance_immunity",
	title = "The Lex Protects",
	filter_category = filtering_categories.regular,
	buff_stats = {
		talent_name = {
			format_type = "loc_string",
			value = "loc_talent_adamant_stance_ability_name",
		},
	},
}
hordes_legendary_adamant_buffs_data.hordes_buff_adamant_drone_stun = {
	description = "Your Nuncio Aquila shocks enemies inside its area every X seconds",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_adamant_drone_stun",
	title = "Shocking Condemnation",
	filter_category = filtering_categories.regular,
	buff_stats = {
		talent_name = {
			format_type = "loc_string",
			value = "loc_talent_ability_area_buff_drone",
		},
		time = {
			format_type = "number",
			value = 5,
		},
	},
}
hordes_legendary_adamant_buffs_data.hordes_buff_adamant_random_bash = {
	description = "Your Bash applies Soulblaze, Burn or Bleed on Hit. Random which one for each enemy",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_adamant_random_bash",
	title = "Uncalculated Reactions",
	filter_category = filtering_categories.regular,
	buff_stats = {
		talent_name = {
			format_type = "loc_string",
			value = "loc_talent_adamant_charge_ability_name",
		},
	},
}
hordes_legendary_adamant_buffs_data.hordes_buff_adamant_mine_explosion = {
	description = "Your Shock Mine explodes when its duration expires",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_adamant_mine_explosion",
	title = "Aftershock",
	filter_category = filtering_categories.regular,
	buff_stats = {
		talent_name = {
			format_type = "loc_string",
			value = "loc_talent_ability_shock_mine",
		},
	},
}
hordes_legendary_adamant_buffs_data.hordes_buff_adamant_grenade_multi = {
	description = "Replenish a grenade if your Grenade kills X or more enemies.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_adamant_grenade_multi",
	title = "Bombardment",
	filter_category = filtering_categories.regular,
	buff_stats = {
		talent_name = {
			format_type = "loc_string",
			value = "loc_talent_ability_adamant_grenade_improved",
		},
		amount = {
			format_type = "number",
			value = 10,
		},
	},
}
hordes_legendary_adamant_buffs_data.hordes_buff_adamant_auto_detonate = {
	description = "Trigger Detonation whenever the Cyber-Mastiff Poundes an Elite/Special/Monster at no Charge Cost. Xs internal Cooldown.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_adamant_auto_detonate",
	title = "Trigger-Happy",
	filter_category = filtering_categories.regular,
	buff_stats = {
		talent_name = {
			format_type = "loc_string",
			value = "loc_talent_ability_detonate",
		},
		time = {
			format_type = "number",
			value = 10,
		},
	},
}

return hordes_legendary_adamant_buffs_data
