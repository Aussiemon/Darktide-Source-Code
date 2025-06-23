-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_buffs_data/hordes_family_buffs_data.lua

local hordes_family_buffs_data = {}

table.make_unique(hordes_family_buffs_data)

hordes_family_buffs_data.hordes_family_fire = {
	description = "Build specialized at dealing fire damage, or improved capactiy in some ways while shooting targets on fire.",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/buff_families/hordes_buff_family_fire",
	gradient = "content/ui/textures/color_ramps/hordes/horde_buff_family_gradient",
	is_family = true,
	id = "fire",
	title = "Ignitor",
	sfx = "wwise/events/ui/play_horde_mode_buff_family_fire"
}
hordes_family_buffs_data.hordes_family_electric = {
	description = "Build specialized at dealing electric damage, or improved capactiy in some ways while shooting targets being electrified.",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/buff_families/hordes_buff_family_electric",
	gradient = "content/ui/textures/color_ramps/hordes/horde_buff_family_gradient",
	is_family = true,
	id = "electric",
	title = "Electromania",
	sfx = "wwise/events/ui/play_horde_mode_buff_family_electric"
}
hordes_family_buffs_data.hordes_family_elementalist = {
	description = "Mix of electric and fire families. Applies both electric and fire on enemies and has some bonuses when fighting among electrified or burned enemies.",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/buff_families/hordes_buff_family_elementalist",
	gradient = "content/ui/textures/color_ramps/hordes/horde_buff_family_gradient",
	is_family = true,
	id = "elementalist",
	title = "Blaze and Thunder",
	sfx = "wwise/events/ui/play_horde_mode_buff_family_elemental"
}
hordes_family_buffs_data.hordes_family_cowboy = {
	description = "Close quarters shooting and melee. Quick swapping between weapons and quicker reloads.",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/buff_families/hordes_buff_family_cowboy",
	gradient = "content/ui/textures/color_ramps/hordes/horde_buff_family_gradient",
	is_family = true,
	id = "cowboy",
	title = "All Master",
	sfx = "wwise/events/ui/play_horde_mode_buff_family_cowboy"
}
hordes_family_buffs_data.hordes_family_unkillable = {
	description = "Survivability focused around close quarters melee combat.",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/buff_families/hordes_buff_family_unkillable",
	gradient = "content/ui/textures/color_ramps/hordes/horde_buff_family_gradient",
	is_family = true,
	id = "unkillable",
	title = "Panzer",
	sfx = "wwise/events/ui/play_horde_mode_buff_family_unkillable"
}
hordes_family_buffs_data.hordes_buff_burning_on_ranged_hit = {
	description = "Ranged attacks apply 1 stack of burn",
	title = "Rain of fire",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_burning_on_ranged_hit",
	buff_stats = {
		stacks = {
			value = 2,
			format_type = "number"
		}
	}
}
hordes_family_buffs_data.hordes_buff_burning_on_melee_hit_taken = {
	description = "Puts a stacks fire to enemies hitting you in melee",
	title = "Can't touch me",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_burning_on_melee_hit_taken",
	buff_stats = {
		stacks = {
			value = 5,
			format_type = "number"
		}
	}
}
hordes_family_buffs_data.hordes_buff_burning_on_melee_hit = {
	description = "Puts a stack of fire when hitting ennemies in melee",
	title = "Burn heretic",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_burning_on_melee_hit",
	buff_stats = {
		stacks = {
			value = 1,
			format_type = "number"
		}
	}
}
hordes_family_buffs_data.hordes_buff_damage_vs_burning = {
	description = "Deals 70% more damage against target on fire",
	title = "You burn, you die",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_damage_vs_burning",
	buff_stats = {
		damage = {
			value = 0.7,
			prefix = "+",
			format_type = "percentage"
		}
	}
}
hordes_family_buffs_data.hordes_buff_fire_pulse = {
	description = "A red pulse is activated in a 360 angle around the player every 20 seconds. It applies 2 burning stacks on all target being touched",
	title = "The emperor will burn in me",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_fire_pulse",
	buff_stats = {
		stacks = {
			value = 5,
			format_type = "number"
		}
	}
}
hordes_family_buffs_data.hordes_buff_toughness_on_fire_damage_dealt = {
	description = "Gain 1% toughness back from dealt fire damage",
	title = "Fed from fire",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_toughness_on_fire_damage_dealt",
	buff_stats = {
		thoughness_regen = {
			value = 0.02,
			format_type = "percentage"
		}
	}
}
hordes_family_buffs_data.hordes_buff_burning_damage_per_burning_enemy = {
	description = "Burning damage are improved by the amount of targets being on fire, up to 50%",
	title = "The more the burner",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_burning_damage_per_burning_enemy",
	buff_stats = {
		damage = {
			value = 0.9,
			format_type = "percentage"
		}
	}
}
hordes_family_buffs_data.hordes_buff_damage_taken_by_flamers_and_grenadier_reduced = {
	description = "flamethrower and grenadier deals 50% less damage to you",
	title = "Born from fire",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_damage_taken_by_flamers_and_grenadier_reduced",
	buff_stats = {
		damage_reduce = {
			value = 0.7,
			format_type = "percentage"
		}
	}
}
hordes_family_buffs_data.hordes_buff_coherency_damage_vs_burning = {
	description = "Allies has 8% improved damage against target being on fire",
	title = "Burn with me friends",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_coherency_damage_vs_burning",
	buff_stats = {
		damage = {
			value = 0.2,
			format_type = "percentage"
		}
	}
}
hordes_family_buffs_data.hordes_buff_coherency_burning_duration = {
	description = "Fire stacks linger 40% longer on target while on coherency",
	title = "FLesh will melt",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_coherency_burning_duration",
	buff_stats = {
		linger = {
			value = 0.4,
			format_type = "percentage"
		}
	}
}
hordes_family_buffs_data.hordes_buff_shock_on_melee_hit = {
	description = "20% to shock enemy on melee hit for 2 seconds",
	title = "Stay where you are",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_shock_on_melee_hit",
	buff_stats = {
		shock_chance = {
			value = 0.2,
			format_type = "percentage"
		},
		time = {
			value = 2,
			format_type = "number"
		}
	}
}
hordes_family_buffs_data.hordes_buff_damage_vs_electrocuted = {
	description = "Deals 10% more damage against electrocuted target",
	title = "Perfect catalyser",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_damage_vs_electrocuted",
	buff_stats = {
		damage = {
			value = 0.5,
			prefix = "+",
			format_type = "percentage"
		}
	}
}
hordes_family_buffs_data.hordes_buff_shock_pulse_on_toughness_broken = {
	description = "When your toughness is being broken, shocked every enemies in a 5m area",
	title = "My weakness is my strength",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_shock_pulse_on_toughness_broken",
	buff_stats = {
		range = {
			value = 5,
			format_type = "number"
		}
	}
}
hordes_family_buffs_data.hordes_buff_instakill_melee_hit_on_electrocuted_enemy = {
	description = "1 % chance of instantaneously killing a shock enemie when being hit in melee ",
	title = "Smile, you die",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_instakill_melee_hit_on_electrocuted_enemy",
	buff_stats = {
		kill_chance = {
			value = 0.05,
			format_type = "percentage"
		}
	}
}
hordes_family_buffs_data.hordes_buff_shock_on_ranged_hit = {
	description = "5% to shock enemy on ranged hit",
	title = "Natural conduit",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_shock_on_ranged_hit",
	buff_stats = {
		shock_chance = {
			value = 0.05,
			format_type = "percentage"
		}
	}
}
hordes_family_buffs_data.hordes_buff_improved_dodge_speed_and_distance = {
	description = "Dodge is 15% faster and have 10% more range",
	title = "Catch me if you can",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_improved_dodge_speed_and_distance",
	buff_stats = {
		fast = {
			value = 0.2,
			format_type = "percentage"
		},
		range = {
			value = 0.15,
			format_type = "percentage"
		}
	}
}
hordes_family_buffs_data.hordes_buff_shock_on_hit_after_dodge = {
	description = "If being hit 3 seconds after a sucessful dodge, shock the assaillant",
	title = "Preternatural Perception",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_shock_on_hit_after_dodge",
	buff_stats = {
		time = {
			value = 2,
			format_type = "number"
		}
	}
}
hordes_family_buffs_data.hordes_buff_shock_closest_enemy_on_interval = {
	description = "All grenades apply shock on hit",
	title = "Manual bolter",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_shock_closest_enemy_on_interval",
	buff_stats = {
		time = {
			value = 2,
			format_type = "number"
		}
	}
}
hordes_family_buffs_data.hordes_buff_damage_taken_close_to_electrocuted_enemy = {
	description = "Take 25% less damage from enemies if one target is still being in shock state",
	title = "Shocking resilience",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_damage_taken_close_to_electrocuted_enemy",
	buff_stats = {
		damage_reduce = {
			value = 0.25,
			format_type = "percentage"
		}
	}
}
hordes_family_buffs_data.hordes_buff_coherency_damage_taken_close_to_electrocuted_enemy = {
	description = "Your team take 5% less damage from enemies if one enemy is still in shock state",
	title = "Shocking resilience Team",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_coherency_damage_taken_close_to_electrocuted_enemy",
	buff_stats = {
		damage_reduce = {
			value = 0.25,
			format_type = "percentage"
		}
	}
}
hordes_family_buffs_data.hordes_buff_extra_toughness_near_burning_shocked_enemies = {
	description = "For each enemy on fire or shocked in close range, you gain 5 extra toughness",
	title = "hardener",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_extra_toughness_near_burning_shocked_enemies",
	buff_stats = {
		extra_thoughness = {
			value = 5,
			prefix = "+",
			format_type = "number"
		}
	}
}
hordes_family_buffs_data.hordes_buff_shock_on_blocking_melee_attack = {
	description = "Blocking an attack in melee shock the target for {time} sc",
	title = "ubeatable",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_shock_on_blocking_melee_attack",
	buff_stats = {
		time = {
			value = 2,
			format_type = "number"
		}
	}
}
hordes_family_buffs_data.hordes_buff_toughness_regen_in_melee_range = {
	description = "replenish 2.5% toughness per second while with 5 meters of at least 3 enemies",
	title = "Feed from the weak",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_toughness_regen_in_melee_range",
	buff_stats = {
		thoughness_regen = {
			value = 0.025,
			format_type = "percentage"
		},
		range = {
			value = 5,
			format_type = "number"
		},
		ennemies_count = {
			value = 3,
			format_type = "number"
		}
	}
}
hordes_family_buffs_data.hordes_buff_reduce_damage_taken_on_disabled_allies = {
	description = "20% damage reduction for each knocked down or incapacitated ally within 20m",
	title = "Stand against the odd",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_reduce_damage_taken_on_disabled_allies",
	buff_stats = {
		damage = {
			value = 0.2,
			format_type = "percentage"
		},
		range = {
			value = 20,
			format_type = "number"
		}
	}
}
hordes_family_buffs_data.hordes_buff_coherency_corruption_healing = {
	description = "Heal 3s corruption from the current wound for you and allies in coherency",
	title = "Share the boon",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_coherency_corruption_healing",
	buff_stats = {
		heal = {
			value = 3,
			format_type = "number"
		}
	}
}
hordes_family_buffs_data.hordes_buff_combat_ability_cooldown_on_damage_taken = {
	description = "20% of damage taken is converted to ability cooldown reduction",
	title = "Hit me harder",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_combat_ability_cooldown_on_damage_taken",
	buff_stats = {
		damage_to_cooldown = {
			value = 0.2,
			prefix = "+",
			format_type = "percentage"
		}
	}
}
hordes_family_buffs_data.hordes_buff_two_extra_wounds = {
	description = "Give 2 additional wounds",
	title = "Always coming back",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_two_extra_wounds",
	buff_stats = {
		wounds = {
			value = 2,
			format_type = "number"
		}
	}
}
hordes_family_buffs_data.hordes_buff_toughness_damage_taken_above_threshold = {
	description = "Boosts toughness damage reduction by 50% while above 75% toughness",
	title = "Adamant skin",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_toughness_damage_taken_above_threshold",
	buff_stats = {
		damage_reduce = {
			value = 0.5,
			prefix = "+",
			format_type = "percentage"
		},
		toughness = {
			value = 0.75,
			format_type = "percentage"
		}
	}
}
hordes_family_buffs_data.hordes_buff_health_regen = {
	description = "Regenerate 1% Hp every 5 seconds. Does not heals corruption",
	title = "Fast metabolism",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_health_regen",
	buff_stats = {
		hp_regen = {
			value = 0.01,
			format_type = "percentage"
		},
		time = {
			value = 5,
			format_type = "number"
		}
	}
}
hordes_family_buffs_data.hordes_buff_damage_increase_on_toughness_broken = {
	description = "When your toughness is being broken, deal 10% more damage for 10s",
	title = "Cornered",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_damage_increase_on_toughness_broken",
	buff_stats = {
		damage = {
			value = 0.6,
			format_type = "percentage"
		}
	}
}
hordes_family_buffs_data.hordes_buff_damage_increase = {
	description = "Additional 10% damage from all sources",
	title = "Force of nature",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_damage_increase",
	buff_stats = {
		damage = {
			value = 0.2,
			prefix = "+",
			format_type = "percentage"
		}
	}
}
hordes_family_buffs_data.hordes_buff_reduce_swap_time = {
	description = "Reduce swap time by 25%",
	title = "Fast drawer",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_reduce_swap_time",
	buff_stats = {
		swap_time = {
			value = 0.25,
			prefix = "+",
			format_type = "percentage"
		}
	}
}
hordes_family_buffs_data.hordes_buff_no_ammo_consumption_on_crits = {
	description = "No ammo consumption on critical hits",
	title = "Crits does not count right ?",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_no_ammo_consumption_on_crits",
	buff_stats = {}
}
hordes_family_buffs_data.hordes_buff_toughness_on_ranged_kill = {
	description = "Replenish 4% toughness on ranged kill",
	title = "Born into combat",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_toughness_on_ranged_kill",
	buff_stats = {
		thoughness_regen = {
			value = 0.05,
			format_type = "percentage"
		}
	}
}
hordes_family_buffs_data.hordes_buff_increased_damage_after_reload = {
	description = "+50% ranged damage for 7s after reload",
	title = "It is all about confidence",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_increased_damage_after_reload",
	buff_stats = {
		range = {
			value = 0.8,
			prefix = "+",
			format_type = "percentage"
		},
		time = {
			value = 5,
			format_type = "number"
		}
	}
}
hordes_family_buffs_data.hordes_buff_improved_weapon_reload_on_melee_kill = {
	description = "6% reload speed on melee kill. Stacks 5 times",
	title = "Guerrila fighter",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_improved_weapon_reload_on_melee_kill",
	buff_stats = {
		time = {
			value = 5,
			format_type = "number"
		},
		reload_speed = {
			value = 0.07,
			prefix = "+",
			format_type = "percentage"
		}
	}
}
hordes_family_buffs_data.hordes_buff_bonus_crit_chance_on_ammo = {
	description = "The first 20% ammo after a reload has +10% ranged critical hit chance",
	title = "Fresh bullets",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_bonus_crit_chance_on_ammo",
	buff_stats = {
		ammo = {
			value = 0.25,
			format_type = "percentage"
		},
		crit_chance = {
			value = 0.3,
			prefix = "+",
			format_type = "percentage"
		}
	}
}
hordes_family_buffs_data.hordes_buff_other_slot_damage_increase_on_kill = {
	description = "25% Melee damage on ranged kill/25% Range damage on melee kill Lasts 5s",
	title = "Versatile champion",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_other_slot_damage_increase_on_kill",
	buff_stats = {
		dammage = {
			value = 0.25,
			prefix = "+",
			format_type = "percentage"
		},
		range = {
			value = 0.25,
			format_type = "percentage"
		}
	}
}
hordes_family_buffs_data.hordes_buff_weakspot_ranged_hit_gives_infinite_ammo = {
	description = "Landing 3 Headshots in a row with a ranged weapon gives 6s of infinite ammo. Has a 10s cooldown.",
	title = "Fast killer",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_weakspot_ranged_hit_gives_infinite_ammo",
	buff_stats = {
		headshot = {
			value = 3,
			format_type = "number"
		},
		time = {
			value = 6,
			format_type = "number"
		},
		cooldown = {
			value = 10,
			format_type = "number"
		}
	}
}
hordes_family_buffs_data.hordes_buff_ranged_attacks_hit_mass_penetration_increased = {
	description = "50% increase of max hit mass penetration for ranged attacks.",
	title = "slice'n'pierce",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_ranged_attacks_hit_mass_penetration_increased",
	buff_stats = {
		increase_hitmass = {
			value = 1,
			format_type = "percentage"
		}
	}
}
hordes_family_buffs_data.hordes_buff_melee_damage_missing_ammo_in_clip = {
	description = "For every missing ammo in clip, gain 1% melee damage.",
	title = "Light weight power",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_melee_damage_missing_ammo_in_clip",
	buff_stats = {
		dammage = {
			value = 0.01,
			format_type = "percentage"
		}
	}
}

return hordes_family_buffs_data
