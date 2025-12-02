-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_buffs_data/hordes_legendary_broker_buffs_data.lua

local MissionBuffsSettings = require("scripts/managers/mission_buffs/mission_buffs_settings")
local filtering_categories = MissionBuffsSettings.filtering_categories
local hordes_legendary_broker_buffs_data = {}

table.make_unique(hordes_legendary_broker_buffs_data)

hordes_legendary_broker_buffs_data.hordes_buff_broker_damage_increase_over_time_during_focus_stance = {
	description = "After entering *Focus Stance, build-up {damage_increase:%s} Ranged Damage over {time:%s} seconds.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_broker_damage_increase_over_time_during_focus_stance",
	title = "Hyperfocus",
	filter_category = filtering_categories.regular,
	buff_stats = {
		damage_increase = {
			format_type = "percentage",
			prefix = "+",
			value = 2,
		},
		time = {
			format_type = "number",
			value = 5,
		},
	},
}
hordes_legendary_broker_buffs_data.hordes_buff_broker_bleedfire_on_melee_hits_during_punk_rage = {
	description = "Melee attacks during *Punk Rage apply {bleed:%s} stacks of bleeding and {burn:%s} stacks of burning to enemies.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_adamant_stance_immunity",
	title = "Fiery Bloodthirst",
	filter_category = filtering_categories.regular,
	buff_stats = {},
}
hordes_legendary_broker_buffs_data.hordes_buff_broker_health_regen_during_punk_rage = {
	description = "While in *Punk Rage, regenerate {hp_regen:%s} HP every {time} seconds. This includes Corruption",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_broker_health_regen_during_punk_rage",
	title = "Holy Rage",
	filter_category = filtering_categories.regular,
	buff_stats = {
		hp_regen = {
			format_type = "percentage",
			value = 0.015,
		},
		time = {
			format_type = "number",
			value = 0.5,
		},
	},
}
hordes_legendary_broker_buffs_data.hordes_buff_broker_stimm_field_shock_on_interval = {
	description = "*Stimm Field shocks enemies in range every {time:%s} seconds.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_broker_stimm_field_shock_on_interval",
	title = "Short Circuited Pack",
	filter_category = filtering_categories.regular,
	buff_stats = {
		time = {
			format_type = "number",
			value = 4,
		},
	},
}
hordes_legendary_broker_buffs_data.hordes_buff_broker_missile_launcher_special_kill_restores_grenade = {
	description = "Killing a Special with the Missile Launcher restores a charge. Only once per use.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_broker_missile_launcher_special_kill_restores_grenade",
	title = "Infinite Rocket Glitch",
	filter_category = filtering_categories.regular,
	buff_stats = {},
}
hordes_legendary_broker_buffs_data.hordes_buff_broker_tox_grenade_applies_self_propagating_toxin = {
	description = "*Tox Grenade explosion applies a toxin that lasts {time:%s}s and propagates to nearby enemies upon the enemy's death.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_broker_tox_grenade_applies_self_propagating_toxin",
	title = "Viral Chemistry",
	filter_category = filtering_categories.regular,
	buff_stats = {
		time = {
			format_type = "number",
			value = 3,
		},
	},
}
hordes_legendary_broker_buffs_data.hordes_buff_broker_flash_grenade_increase_damage_taken = {
	description = "Enemies hit by a *Flash Grenade will take {damage_taken:%s} more damage for {time:%s} seconds.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_broker_flash_grenade_increase_damage_taken",
	title = "Blinding Weakness",
	filter_category = filtering_categories.regular,
	buff_stats = {
		damage_taken = {
			format_type = "percentage",
			value = 2,
		},
		time = {
			format_type = "number",
			value = 30,
		},
	},
}

return hordes_legendary_broker_buffs_data
