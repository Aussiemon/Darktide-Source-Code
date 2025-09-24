-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_buffs_data/hordes_legendary_buffs_data.lua

local MissionBuffsSettings = require("scripts/managers/mission_buffs/mission_buffs_settings")
local filtering_categories = MissionBuffsSettings.filtering_categories
local hordes_legendary_buffs_data = {}

table.make_unique(hordes_legendary_buffs_data)

hordes_legendary_buffs_data.hordes_buff_combat_ability_cooldown_on_kills = {
	description = "Dealing damage in melee reduce your ability cooldown by 1%",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_combat_ability_cooldown_on_kills",
	title = "Violence inspire me",
	filter_category = filtering_categories.regular,
	buff_stats = {
		cooldown = {
			format_type = "percentage",
			value = 0.01,
		},
	},
}
hordes_legendary_buffs_data.hordes_buff_auto_clip_fill_while_melee = {
	description = "Magazine refil itself when using melee weapon. Every second it reload 5% of the magazine",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_auto_clip_fill_while_melee",
	title = "Third hand",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		ammo = {
			format_type = "percentage",
			prefix = "+",
			value = 0.07,
		},
	},
}
hordes_legendary_buffs_data.hordes_buff_uninterruptible_more_damage_taken = {
	description = "Cannot be staggered anymore ",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_uninterruptible_more_damage_taken",
	title = "Hold still",
	filter_category = filtering_categories.regular,
	buff_stats = {},
}
hordes_legendary_buffs_data.hordes_buff_weakspot_ranged_hit_always_stagger = {
	description = "micro stagger target being hit by ranged weapon",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_weakspot_ranged_hit_always_stagger",
	title = "Don't move",
	filter_category = filtering_categories.jackpot,
	buff_stats = {},
}
hordes_legendary_buffs_data.hordes_buff_explode_enemies_on_ranged_kill = {
	description = "Enemies killed with ranged attacks have a 5% chance to explode.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_explode_enemies_on_ranged_kill",
	title = "Unatural strength",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		chance = {
			format_type = "percentage",
			value = 0.1,
		},
	},
}
hordes_legendary_buffs_data.hordes_buff_extra_ability_charge = {
	description = "Adds one extra stackable ability",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_extra_ability_charge",
	title = "Empowered",
	filter_category = filtering_categories.regular,
	buff_stats = {
		stack = {
			format_type = "number",
			value = 2,
		},
	},
}
hordes_legendary_buffs_data.hordes_buff_aoe_shock_closest_enemy_on_interval = {
	description = "Every 10s, randomly trigger an AOE shock on an enemy around a 10m radius of the player.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_aoe_shock_closest_enemy_on_interval",
	title = "Out of control",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		time = {
			format_type = "number",
			value = 10,
		},
		range = {
			format_type = "number",
			value = 10,
		},
	},
}
hordes_legendary_buffs_data.hordes_buff_staggering_pulse = {
	description = "Every 15s, emit a 360 degree staggering and suppressing pulse.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_staggering_pulse",
	title = "Social distance",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		time = {
			format_type = "number",
			value = 10,
		},
	},
}
hordes_legendary_buffs_data.hordes_buff_random_damage_immunity = {
	description = "Gain 10% evasive chance, ignoring any damage taken if triggered",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_random_damage_immunity",
	title = "Spiky skin",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		chance = {
			format_type = "percentage",
			value = 0.15,
		},
	},
}
hordes_legendary_buffs_data.hordes_buff_big_weakspot_damage_increase = {
	description = "Weakspot damage are increase by 175%",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_big_weakspot_damage_increase",
	title = "Big head",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		damage = {
			format_type = "percentage",
			value = 2,
		},
	},
}
hordes_legendary_buffs_data.hordes_buff_toughness_coherency_from_enemies_instead_of_players = {
	description = "You become immune  to allies bonus in coherency every 5  Enemies count as an ally for coherency bonuses",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_toughness_coherency_from_enemies_instead_of_players",
	title = "Keep your foes close",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		count = {
			format_type = "number",
			value = 5,
		},
	},
}
hordes_legendary_buffs_data.hordes_buff_bleeding_and_burning_on_melee_hit = {
	description = "Each melee attack applies + 5 bleeding / 5 burns to ennemies",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_bleeding_and_burning_on_melee_hit",
	title = "Multitasks",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		burn = {
			format_type = "number",
			value = 5,
		},
		bleed = {
			format_type = "number",
			value = 5,
		},
	},
}
hordes_legendary_buffs_data.hordes_buff_boosted_melee_attack_on_cooldown = {
	description = "Gain enhanced melee attack every 15sc increase damage and stagger by 300%",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_boosted_melee_attack_on_cooldown",
	title = "Hold my beer",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		time = {
			format_type = "number",
			value = 15,
		},
		enhanced = {
			format_type = "percentage",
			value = 3.5,
		},
	},
}
hordes_legendary_buffs_data.hordes_buff_explosion_on_toughness_broken = {
	description = "Trigger an ogryn big bomba when breaking toughness, 60sc cooldown",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_explosion_on_toughness_broken",
	title = "Surprise mozard faker",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		time = {
			format_type = "number",
			value = 25,
		},
	},
}
hordes_legendary_buffs_data.hordes_buff_reflect_melee_damage = {
	description = "Deal damage taken in melee back to the target",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_reflect_melee_damage",
	title = "Who is laughing now ?",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		time = {
			format_type = "percentage",
			value = 0.5,
		},
	},
}
hordes_legendary_buffs_data.hordes_buff_extra_grenade_throw_chance = {
	description = "40% chance do throw 2 grenades at once",
	gradient = "content/ui/textures/color_ramps/talent_blitz",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_extra_grenade_throw_chance",
	title = "Lucky me",
	filter_category = filtering_categories.grenade,
	buff_stats = {
		chance = {
			format_type = "percentage",
			value = 0.9,
		},
	},
}
hordes_legendary_buffs_data.hordes_buff_grenade_duplication_on_explosion = {
	description = "50% chance for a duplicate grenade to pop out when a grenade explodes.",
	gradient = "content/ui/textures/color_ramps/talent_blitz",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_grenade_duplication_on_explosion",
	title = "If one, why not two",
	filter_category = filtering_categories.grenade,
	buff_stats = {
		chance = {
			format_type = "percentage",
			value = 0.5,
		},
	},
}
hordes_legendary_buffs_data.hordes_buff_grenade_heals_on_explosion = {
	description = "Grenade explosion heals 100 health to you or your allies",
	gradient = "content/ui/textures/color_ramps/talent_blitz",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_grenade_heals_on_explosion",
	title = "Unexpected medic",
	filter_category = filtering_categories.grenade,
	buff_stats = {
		health = {
			format_type = "percentage",
			value = 0.3,
		},
	},
}
hordes_legendary_buffs_data.hordes_buff_spawn_dome_shield_on_grenade_explosion = {
	description = "After a grenade explodes it creates a warp shield",
	gradient = "content/ui/textures/color_ramps/talent_blitz",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_spawn_dome_shield_on_grenade_explosion",
	title = "Best defense is attacking",
	filter_category = filtering_categories.grenade,
	buff_stats = {},
}
hordes_legendary_buffs_data.hordes_buff_grenade_explosion_applies_elemental_weakness = {
	description = "Grenade explosion applie elemental weakness to electrocute,bleeding, fire for 10sc. +40% damage ",
	gradient = "content/ui/textures/color_ramps/talent_blitz",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_grenade_explosion_applies_elemental_weakness",
	title = "Everything is a weakspot",
	filter_category = filtering_categories.grenade,
	buff_stats = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			value = 1,
		},
		time = {
			format_type = "number",
			value = 10,
		},
	},
}
hordes_legendary_buffs_data.hordes_buff_grenade_explosion_applies_rending_debuff = {
	description = "Grenade explosion applies 30% brittleness on targets hits",
	gradient = "content/ui/textures/color_ramps/talent_blitz",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_grenade_explosion_applies_rending_debuff",
	title = "Brittle technology ",
	filter_category = filtering_categories.grenade,
	buff_stats = {
		brittle = {
			format_type = "percentage",
			prefix = "+",
			value = 0.75,
		},
	},
}
hordes_legendary_buffs_data.hordes_buff_grenade_explosion_kill_replenish_grenades = {
	description = "5% chance of resplenishing 3 grenades when killing an ennemy with a grenade explosion ",
	gradient = "content/ui/textures/color_ramps/talent_blitz",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_grenade_explosion_kill_replenish_grenades",
	title = "Feed from death",
	filter_category = filtering_categories.grenade,
	buff_stats = {
		chance = {
			format_type = "percentage",
			prefix = "+",
			value = 0.1,
		},
	},
}
hordes_legendary_buffs_data.hordes_buff_shock_on_grenade_impact = {
	description = "All grenades apply AOE shock on hit.",
	gradient = "content/ui/textures/color_ramps/talent_blitz",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_shock_on_grenade_impact",
	title = "Manual bolter",
	filter_category = filtering_categories.grenade,
	buff_stats = {},
}
hordes_legendary_buffs_data.hordes_buff_grenade_replenishment_over_time = {
	description = "Replenish 1 Grenade every 30s.",
	gradient = "content/ui/textures/color_ramps/talent_blitz",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_grenade_replenishment_over_time",
	title = "Scrapper boy",
	filter_category = filtering_categories.grenade,
	buff_stats = {
		time = {
			format_type = "number",
			value = 20,
		},
	},
}

return hordes_legendary_buffs_data
