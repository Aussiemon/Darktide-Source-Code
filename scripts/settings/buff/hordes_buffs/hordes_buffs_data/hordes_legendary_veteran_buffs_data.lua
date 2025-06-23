-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_buffs_data/hordes_legendary_veteran_buffs_data.lua

local MissionBuffsSettings = require("scripts/managers/mission_buffs/mission_buffs_settings")
local filtering_categories = MissionBuffsSettings.filtering_categories
local hordes_legendary_veteran_buffs_data = {}

table.make_unique(hordes_legendary_veteran_buffs_data)

hordes_legendary_veteran_buffs_data.hordes_buff_veteran_infinite_ammo_during_stance = {
	description = "Veteran stance give infinite ammos capacity in magazine",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_veteran_infinite_ammo_during_stance",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "No holding back",
	filter_category = filtering_categories.jackpot,
	buff_stats = {}
}
hordes_legendary_veteran_buffs_data.hordes_buff_veteran_increased_damage_after_stealth = {
	description = "Veteran infiltrate increase damage of 70% for 3sc after leaving stealth",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_veteran_increased_damage_after_stealth",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Strike first, think later",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		time = {
			value = 10,
			format_type = "number"
		},
		dammage = {
			value = 0.7,
			format_type = "percentage"
		}
	}
}
hordes_legendary_veteran_buffs_data.hordes_buff_veteran_shock_units_in_smoke_grenade = {
	description = "Smoke Grenade's are electrified shocking enemies entering it. Once per enemy.",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_veteran_shock_units_in_smoke_grenade",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Charged clouds",
	filter_category = filtering_categories.jackpot,
	buff_stats = {}
}
hordes_legendary_veteran_buffs_data.hordes_buff_veteran_grouped_upgraded_stealth = {
	description = "Give stealth to nearby allies upon entering stealth. While in stealth become invulnerable and able to attack without canceling stealth.",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_veteran_grouped_upgraded_stealth",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Ambusher",
	filter_category = filtering_categories.jackpot,
	buff_stats = {}
}
hordes_legendary_veteran_buffs_data.hordes_buff_veteran_apply_infinite_bleed_on_shout = {
	description = "Shout now applies infinite bleed on enemies hit.",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_veteran_apply_infinite_bleed_on_shout",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Death by bleeding",
	filter_category = filtering_categories.jackpot,
	buff_stats = {}
}
hordes_legendary_veteran_buffs_data.hordes_buff_veteran_sticky_grenade_pulls_enemies = {
	description = "Pull all ennemies at the grenade impact in  {radius} radius",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_veteran_sticky_grenade_pulls_enemies",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Black hole",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		radius = {
			value = 5,
			format_type = "number"
		}
	}
}

return hordes_legendary_veteran_buffs_data
