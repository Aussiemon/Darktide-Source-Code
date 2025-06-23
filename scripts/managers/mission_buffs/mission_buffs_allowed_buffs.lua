-- chunkname: @scripts/managers/mission_buffs/mission_buffs_allowed_buffs.lua

local HordesBuffsData = require("scripts/settings/buff/hordes_buffs/hordes_buffs_data")
local allowed_buffs = {}

allowed_buffs.legendary_buffs = {
	generic = {
		"hordes_buff_uninterruptible_more_damage_taken",
		"hordes_buff_combat_ability_cooldown_on_kills",
		"hordes_buff_auto_clip_fill_while_melee",
		"hordes_buff_weakspot_ranged_hit_always_stagger",
		"hordes_buff_explode_enemies_on_ranged_kill",
		"hordes_buff_aoe_shock_closest_enemy_on_interval",
		"hordes_buff_staggering_pulse",
		"hordes_buff_extra_ability_charge"
	}
}

local legendary_grenade_buffs_applied_to_all = {
	"hordes_buff_extra_grenade_throw_chance",
	"hordes_buff_grenade_duplication_on_explosion",
	"hordes_buff_grenade_heals_on_explosion",
	"hordes_buff_grenade_explosion_applies_elemental_weakness",
	"hordes_buff_grenade_explosion_applies_rending_debuff",
	"hordes_buff_grenade_replenishment_over_time"
}

allowed_buffs.legendary_buffs.veteran = {
	generic = {},
	grenade_ability = {
		veteran_frag_grenade = table.append(table.shallow_copy(legendary_grenade_buffs_applied_to_all), {
			"hordes_buff_spawn_dome_shield_on_grenade_explosion",
			"hordes_buff_grenade_explosion_kill_replenish_grenades",
			"hordes_buff_shock_on_grenade_impact"
		}),
		veteran_smoke_grenade = table.append(table.shallow_copy(legendary_grenade_buffs_applied_to_all), {
			"hordes_buff_spawn_dome_shield_on_grenade_explosion",
			"hordes_buff_veteran_shock_units_in_smoke_grenade",
			"hordes_buff_shock_on_grenade_impact"
		}),
		veteran_krak_grenade = table.append(table.shallow_copy(legendary_grenade_buffs_applied_to_all), {
			"hordes_buff_spawn_dome_shield_on_grenade_explosion",
			"hordes_buff_grenade_explosion_kill_replenish_grenades",
			"hordes_buff_veteran_sticky_grenade_pulls_enemies"
		})
	},
	combat_ability = {
		volley_fire_stance = {
			"hordes_buff_veteran_infinite_ammo_during_stance"
		},
		veteran_stealth = {
			"hordes_buff_veteran_increased_damage_after_stealth",
			"hordes_buff_veteran_grouped_upgraded_stealth"
		},
		voice_of_command = {
			"hordes_buff_veteran_apply_infinite_bleed_on_shout"
		}
	}
}
allowed_buffs.legendary_buffs.zealot = {
	generic = {},
	grenade_ability = {
		zealot_shock_grenade = table.append(table.shallow_copy(legendary_grenade_buffs_applied_to_all), {
			"hordes_buff_spawn_dome_shield_on_grenade_explosion",
			"hordes_buff_zealot_shock_grenade_increase_next_hit_damage",
			"hordes_buff_shock_on_grenade_impact"
		}),
		zealot_fire_grenade = table.append(table.shallow_copy(legendary_grenade_buffs_applied_to_all), {
			"hordes_buff_spawn_dome_shield_on_grenade_explosion",
			"hordes_buff_zealot_regen_toughness_inside_fire_grenade",
			"hordes_buff_shock_on_grenade_impact"
		}),
		zealot_throwing_knives = {
			"hordes_buff_zealot_knives_bleed_and_restore_thoughness_on_kill"
		}
	},
	combat_ability = {
		zealot_dash = {
			"hordes_buff_zealot_fire_trail_on_lunge"
		},
		bolstering_prayer = {
			"hordes_buff_zealot_channel_heals_corruption"
		},
		zealot_invisibility = {}
	}
}
allowed_buffs.legendary_buffs.psyker = {
	generic = {},
	grenade_ability = {
		psyker_smite = {
			"hordes_buff_psyker_brain_burst_burns_and_bleeds_on_hit",
			"hordes_buff_psyker_brain_burst_spreads_fire_on_hit",
			"hordes_buff_psyker_brain_burst_hits_nearby_enemies"
		},
		psyker_chain_lightning = {
			"hordes_buff_psyker_smite_always_max_damage"
		},
		psyker_throwing_knives = {
			"hordes_buff_psyker_recover_knife_on_knife_kill",
			"hordes_buff_psyker_burning_on_throwing_knife_hit"
		}
	},
	combat_ability = {
		psyker_shout = {
			"hordes_buff_psyker_shout_always_stagger",
			"hordes_buff_psyker_shout_boosts_allies"
		},
		psyker_shield = {
			"hordes_buff_psyker_shock_on_touch_force_field"
		},
		psyker_overcharge_stance = {
			"hordes_buff_psyker_overcharge_reduced_damage_taken"
		}
	}
}
allowed_buffs.legendary_buffs.ogryn = {
	generic = {},
	grenade_ability = {
		ogryn_grenade_frag = table.append(table.shallow_copy(legendary_grenade_buffs_applied_to_all), {
			"hordes_buff_spawn_dome_shield_on_grenade_explosion",
			"hordes_buff_grenade_explosion_kill_replenish_grenades",
			"hordes_buff_ogryn_biggest_boom_grenade",
			"hordes_buff_shock_on_grenade_impact"
		}),
		ogryn_grenade_box_cluster = table.append(table.shallow_copy(legendary_grenade_buffs_applied_to_all), {
			"hordes_buff_ogryn_box_of_surprises",
			"hordes_buff_grenade_explosion_kill_replenish_grenades"
		}),
		ogryn_grenade_box = table.append(table.shallow_copy(legendary_grenade_buffs_applied_to_all), {
			"hordes_buff_ogryn_box_of_surprises",
			"hordes_buff_grenade_explosion_kill_replenish_grenades"
		}),
		ogryn_grenade_friend_rock = {
			"hordes_buff_ogryn_omega_lucky_rock",
			"hordes_buff_ogryn_rock_charge_while_wield"
		}
	},
	combat_ability = {
		ogryn_charge = {
			"hordes_buff_ogryn_taunt_on_lunge",
			"hordes_buff_ogryn_fire_trail_on_lunge"
		},
		ogryn_taunt_shout = {
			"hordes_buff_ogryn_apply_fire_on_shout"
		},
		ogryn_gunlugger_stance = {
			"hordes_buff_ogryn_increase_penetration_during_stance"
		}
	}
}
allowed_buffs.legendary_buffs.adamant = {
	generic = {},
	grenade_ability = {
		adamant_shock_mine = {
			"hordes_buff_adamant_mine_explosion"
		},
		adamant_grenade = table.append(table.shallow_copy(legendary_grenade_buffs_applied_to_all), {
			"hordes_buff_adamant_grenade_multi"
		}),
		adamant_whistle = {
			"hordes_buff_adamant_auto_detonate"
		}
	},
	combat_ability = {
		adamant_area_buff_drone = {
			"hordes_buff_adamant_drone_stun"
		},
		adamant_stance = {
			"hordes_buff_adamant_stance_immunity"
		},
		adamant_charge = {
			"hordes_buff_adamant_random_bash"
		}
	}
}
allowed_buffs.legendary_buffs.adamant.grenade_ability.adamant_grenade_improved = table.clone(allowed_buffs.legendary_buffs.adamant.grenade_ability.adamant_grenade)
allowed_buffs.available_family_builds = {
	"fire",
	"unkillable",
	"cowboy",
	"electric",
	"elementalist"
}
allowed_buffs.buff_families = {
	fire = {
		sfx = "wwise/events/world/play_horde_mode_buff_family_fire",
		name = "Fire Build",
		priority_buffs = {
			"hordes_buff_burning_on_melee_hit"
		},
		buffs = {
			"hordes_buff_burning_on_ranged_hit",
			"hordes_buff_burning_on_melee_hit_taken",
			"hordes_buff_damage_vs_burning",
			"hordes_buff_fire_pulse",
			"hordes_buff_toughness_on_fire_damage_dealt",
			"hordes_buff_burning_damage_per_burning_enemy",
			"hordes_buff_damage_taken_by_flamers_and_grenadier_reduced",
			"hordes_buff_coherency_damage_vs_burning",
			"hordes_buff_coherency_burning_duration"
		}
	},
	electric = {
		sfx = "wwise/events/world/play_horde_mode_buff_family_electric",
		name = "Electric Build",
		id = "electric",
		priority_buffs = {
			"hordes_buff_shock_on_ranged_hit"
		},
		buffs = {
			"hordes_buff_shock_on_melee_hit",
			"hordes_buff_damage_vs_electrocuted",
			"hordes_buff_shock_pulse_on_toughness_broken",
			"hordes_buff_instakill_melee_hit_on_electrocuted_enemy",
			"hordes_buff_improved_dodge_speed_and_distance",
			"hordes_buff_shock_on_hit_after_dodge",
			"hordes_buff_shock_closest_enemy_on_interval",
			"hordes_buff_damage_taken_close_to_electrocuted_enemy",
			"hordes_buff_coherency_damage_taken_close_to_electrocuted_enemy"
		}
	},
	elementalist = {
		sfx = "wwise/events/world/play_horde_mode_buff_family_elemental",
		name = "Elementalist Build",
		id = "elementalist",
		priority_buffs = {
			"hordes_buff_shock_on_blocking_melee_attack"
		},
		buffs = {
			"hordes_buff_burning_on_ranged_hit",
			"hordes_buff_burning_on_melee_hit_taken",
			"hordes_buff_shock_on_melee_hit",
			"hordes_buff_damage_vs_electrocuted",
			"hordes_buff_shock_pulse_on_toughness_broken",
			"hordes_buff_improved_dodge_speed_and_distance",
			"hordes_buff_combat_ability_cooldown_on_damage_taken",
			"hordes_buff_extra_toughness_near_burning_shocked_enemies",
			"hordes_buff_coherency_burning_duration"
		}
	},
	unkillable = {
		sfx = "wwise/events/world/play_horde_mode_buff_family_unkillable",
		name = "Unkillable Build",
		id = "unkillable",
		priority_buffs = {
			"hordes_buff_shock_pulse_on_toughness_broken"
		},
		buffs = {
			"hordes_buff_toughness_regen_in_melee_range",
			"hordes_buff_reduce_damage_taken_on_disabled_allies",
			"hordes_buff_coherency_corruption_healing",
			"hordes_buff_combat_ability_cooldown_on_damage_taken",
			"hordes_buff_two_extra_wounds",
			"hordes_buff_toughness_damage_taken_above_threshold",
			"hordes_buff_damage_taken_by_flamers_and_grenadier_reduced",
			"hordes_buff_health_regen",
			"hordes_buff_damage_increase_on_toughness_broken"
		}
	},
	cowboy = {
		sfx = "wwise/events/world/play_horde_mode_buff_family_cowboy",
		name = "Cowboy Build",
		id = "cowboy",
		priority_buffs = {
			"hordes_buff_no_ammo_consumption_on_crits"
		},
		buffs = {
			"hordes_buff_damage_increase",
			"hordes_buff_reduce_swap_time",
			"hordes_buff_toughness_regen_in_melee_range",
			"hordes_buff_toughness_on_ranged_kill",
			"hordes_buff_increased_damage_after_reload",
			"hordes_buff_improved_weapon_reload_on_melee_kill",
			"hordes_buff_bonus_crit_chance_on_ammo",
			"hordes_buff_other_slot_damage_increase_on_kill",
			"hordes_buff_ranged_attacks_hit_mass_penetration_increased",
			"hordes_buff_melee_damage_missing_ammo_in_clip",
			"hordes_buff_weakspot_ranged_hit_gives_infinite_ammo"
		}
	}
}

return allowed_buffs
