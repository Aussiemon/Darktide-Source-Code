-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_buffs_data/hordes_legendary_buffs_data.lua

local MissionBuffsSettings = require("scripts/managers/mission_buffs/mission_buffs_settings")
local filtering_categories = MissionBuffsSettings.filtering_categories
local hordes_legendary_buffs_data = {}

table.make_unique(hordes_legendary_buffs_data)

hordes_legendary_buffs_data.hordes_buff_combat_ability_cooldown_on_kills = {
	description = "Dealing damage in melee reduce your ability cooldown by 1%",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_combat_ability_cooldown_on_kills",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Violence inspire me",
	filter_category = filtering_categories.regular,
	buff_stats = {
		cooldown = {
			value = 0.01,
			format_type = "percentage"
		}
	}
}
hordes_legendary_buffs_data.hordes_buff_auto_clip_fill_while_melee = {
	description = "Magazine refil itself when using melee weapon. Every second it reload 5% of the magazine",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_auto_clip_fill_while_melee",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Third hand",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		ammo = {
			value = 0.05,
			prefix = "+",
			format_type = "percentage"
		}
	}
}
hordes_legendary_buffs_data.hordes_buff_uninterruptible_more_damage_taken = {
	description = "Cannot be staggered anymore ",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_uninterruptible_more_damage_taken",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Hold still",
	filter_category = filtering_categories.regular,
	buff_stats = {}
}
hordes_legendary_buffs_data.hordes_buff_weakspot_ranged_hit_always_stagger = {
	description = "micro stagger target being hit by ranged weapon",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_weakspot_ranged_hit_always_stagger",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Don't move",
	filter_category = filtering_categories.jackpot,
	buff_stats = {}
}
hordes_legendary_buffs_data.hordes_buff_explode_enemies_on_ranged_kill = {
	description = "Enemies killed with ranged attacks have a 5% chance to explode.",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_explode_enemies_on_ranged_kill",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Unatural strength",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		chance = {
			value = 0.1,
			format_type = "percentage"
		}
	}
}
hordes_legendary_buffs_data.hordes_buff_extra_ability_charge = {
	description = "Adds one extra stackable ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_extra_ability_charge",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Empowered",
	filter_category = filtering_categories.regular,
	buff_stats = {
		stack = {
			value = 2,
			format_type = "number"
		}
	}
}
hordes_legendary_buffs_data.hordes_buff_aoe_shock_closest_enemy_on_interval = {
	description = "Every 10s, randomly trigger an AOE shock on an enemy around a 10m radius of the player.",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_aoe_shock_closest_enemy_on_interval",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Out of control",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		time = {
			value = 10,
			format_type = "number"
		},
		range = {
			value = 10,
			format_type = "number"
		}
	}
}
hordes_legendary_buffs_data.hordes_buff_staggering_pulse = {
	description = "Every 15s, emit a 360 degree staggering and suppressing pulse.",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_staggering_pulse",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	title = "Social distance",
	filter_category = filtering_categories.jackpot,
	buff_stats = {
		time = {
			value = 10,
			format_type = "number"
		}
	}
}
hordes_legendary_buffs_data.hordes_buff_extra_grenade_throw_chance = {
	description = "40% chance do throw 2 grenades at once",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_extra_grenade_throw_chance",
	gradient = "content/ui/textures/color_ramps/talent_blitz",
	title = "Lucky me",
	filter_category = filtering_categories.grenade,
	buff_stats = {
		chance = {
			value = 0.9,
			format_type = "percentage"
		}
	}
}
hordes_legendary_buffs_data.hordes_buff_grenade_duplication_on_explosion = {
	description = "50% chance for a duplicate grenade to pop out when a grenade explodes.",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_grenade_duplication_on_explosion",
	gradient = "content/ui/textures/color_ramps/talent_blitz",
	title = "If one, why not two",
	filter_category = filtering_categories.grenade,
	buff_stats = {
		chance = {
			value = 0.5,
			format_type = "percentage"
		}
	}
}
hordes_legendary_buffs_data.hordes_buff_grenade_heals_on_explosion = {
	description = "Grenade explosion heals 100 health to you or your allies",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_grenade_heals_on_explosion",
	gradient = "content/ui/textures/color_ramps/talent_blitz",
	title = "Unexpected medic",
	filter_category = filtering_categories.grenade,
	buff_stats = {
		health = {
			value = 0.3,
			format_type = "percentage"
		}
	}
}
hordes_legendary_buffs_data.hordes_buff_spawn_dome_shield_on_grenade_explosion = {
	description = "After a grenade explodes it creates a warp shield",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_spawn_dome_shield_on_grenade_explosion",
	gradient = "content/ui/textures/color_ramps/talent_blitz",
	title = "Best defense is attacking",
	filter_category = filtering_categories.grenade,
	buff_stats = {}
}
hordes_legendary_buffs_data.hordes_buff_grenade_explosion_applies_elemental_weakness = {
	description = "Grenade explosion applie elemental weakness to electrocute,bleeding, fire for 10sc. +40% damage ",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_grenade_explosion_applies_elemental_weakness",
	gradient = "content/ui/textures/color_ramps/talent_blitz",
	title = "Everything is a weakspot",
	filter_category = filtering_categories.grenade,
	buff_stats = {
		damage = {
			value = 1,
			prefix = "+",
			format_type = "percentage"
		},
		time = {
			value = 10,
			format_type = "number"
		}
	}
}
hordes_legendary_buffs_data.hordes_buff_grenade_explosion_applies_rending_debuff = {
	description = "Grenade explosion applies 30% brittleness on targets hits",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_grenade_explosion_applies_rending_debuff",
	gradient = "content/ui/textures/color_ramps/talent_blitz",
	title = "Brittle technology ",
	filter_category = filtering_categories.grenade,
	buff_stats = {
		brittle = {
			value = 0.75,
			prefix = "+",
			format_type = "percentage"
		}
	}
}
hordes_legendary_buffs_data.hordes_buff_grenade_explosion_kill_replenish_grenades = {
	description = "5% chance of resplenishing 3 grenades when killing an ennemy with a grenade explosion ",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_grenade_explosion_kill_replenish_grenades",
	gradient = "content/ui/textures/color_ramps/talent_blitz",
	title = "Feed from death",
	filter_category = filtering_categories.grenade,
	buff_stats = {
		chance = {
			value = 0.1,
			prefix = "+",
			format_type = "percentage"
		}
	}
}
hordes_legendary_buffs_data.hordes_buff_shock_on_grenade_impact = {
	description = "All grenades apply AOE shock on hit.",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_shock_on_grenade_impact",
	gradient = "content/ui/textures/color_ramps/talent_blitz",
	title = "Manual bolter",
	filter_category = filtering_categories.grenade,
	buff_stats = {}
}
hordes_legendary_buffs_data.hordes_buff_grenade_replenishment_over_time = {
	description = "Replenish 1 Grenade every 30s.",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_grenade_replenishment_over_time",
	gradient = "content/ui/textures/color_ramps/talent_blitz",
	title = "Scrapper boy",
	filter_category = filtering_categories.grenade,
	buff_stats = {
		time = {
			value = 20,
			format_type = "number"
		}
	}
}

return hordes_legendary_buffs_data
