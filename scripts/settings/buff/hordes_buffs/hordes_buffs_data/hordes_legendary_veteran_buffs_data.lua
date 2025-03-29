-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_buffs_data/hordes_legendary_veteran_buffs_data.lua

local MissionBuffsSettings = require("scripts/managers/mission_buffs/mission_buffs_settings")
local filtering_categories = MissionBuffsSettings.filtering_categories
local hordes_legendary_veteran_buffs_data = {}

table.make_unique(hordes_legendary_veteran_buffs_data)

hordes_legendary_veteran_buffs_data.hordes_buff_veteran_infinite_ammo_during_stance = {
	description = "Veteran stance give infinite ammos capacity in magazine",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_veteran_infinite_ammo_during_stance",
	title = "No holding back",
	filter_category = filtering_categories.jackpot,
	buff_stats = {},
}
hordes_legendary_veteran_buffs_data.hordes_buff_veteran_increased_damage_after_stealth = {
	description = "Veteran infiltrate increase damage of 70% for 3sc after leaving stealth",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_veteran_increased_damage_after_stealth",
	title = "Strike first, think later",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		time = {
			format_type = "number",
			value = 10,
		},
		dammage = {
			format_type = "percentage",
			value = 0.7,
		},
	},
}
hordes_legendary_veteran_buffs_data.hordes_buff_veteran_shock_units_in_smoke_grenade = {
	description = "Smoke Grenade's are electrified shocking enemies entering it. Once per enemy.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_veteran_shock_units_in_smoke_grenade",
	title = "Charged clouds",
	filter_category = filtering_categories.jackpot,
	buff_stats = {},
}
hordes_legendary_veteran_buffs_data.hordes_buff_veteran_grouped_upgraded_stealth = {
	description = "Give stealth to nearby allies upon entering stealth. While in stealth become invulnerable and able to attack without canceling stealth.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_veteran_grouped_upgraded_stealth",
	title = "Ambusher",
	filter_category = filtering_categories.jackpot,
	buff_stats = {},
}
hordes_legendary_veteran_buffs_data.hordes_buff_veteran_apply_infinite_bleed_on_shout = {
	description = "Shout now applies infinite bleed on enemies hit.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_veteran_apply_infinite_bleed_on_shout",
	title = "Death by bleeding",
	filter_category = filtering_categories.jackpot,
	buff_stats = {},
}
hordes_legendary_veteran_buffs_data.hordes_buff_veteran_sticky_grenade_pulls_enemies = {
	description = "Pull all ennemies at the grenade impact in  {radius} radius",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_veteran_sticky_grenade_pulls_enemies",
	title = "Black hole",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		radius = {
			format_type = "number",
			value = 5,
		},
	},
}

return hordes_legendary_veteran_buffs_data
