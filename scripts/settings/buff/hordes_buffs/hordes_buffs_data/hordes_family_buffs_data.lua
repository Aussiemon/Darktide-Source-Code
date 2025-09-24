-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_buffs_data/hordes_family_buffs_data.lua

local hordes_family_buffs_data = {}

table.make_unique(hordes_family_buffs_data)

hordes_family_buffs_data.hordes_family_fire = {
	description = "Build specialized at dealing fire damage, or improved capactiy in some ways while shooting targets on fire.",
	gradient = "content/ui/textures/color_ramps/hordes/horde_buff_family_gradient",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/buff_families/hordes_buff_family_fire",
	id = "fire",
	is_family = true,
	sfx = "wwise/events/ui/play_horde_mode_buff_family_fire",
	title = "Ignitor",
}
hordes_family_buffs_data.hordes_family_electric = {
	description = "Build specialized at dealing electric damage, or improved capactiy in some ways while shooting targets being electrified.",
	gradient = "content/ui/textures/color_ramps/hordes/horde_buff_family_gradient",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/buff_families/hordes_buff_family_electric",
	id = "electric",
	is_family = true,
	sfx = "wwise/events/ui/play_horde_mode_buff_family_electric",
	title = "Electromania",
}
hordes_family_buffs_data.hordes_family_elementalist = {
	description = "Mix of electric and fire families. Applies both electric and fire on enemies and has some bonuses when fighting among electrified or burned enemies.",
	gradient = "content/ui/textures/color_ramps/hordes/horde_buff_family_gradient",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/buff_families/hordes_buff_family_elementalist",
	id = "elementalist",
	is_family = true,
	sfx = "wwise/events/ui/play_horde_mode_buff_family_elemental",
	title = "Blaze and Thunder",
}
hordes_family_buffs_data.hordes_family_cowboy = {
	description = "Close quarters shooting and melee. Quick swapping between weapons and quicker reloads.",
	gradient = "content/ui/textures/color_ramps/hordes/horde_buff_family_gradient",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/buff_families/hordes_buff_family_cowboy",
	id = "cowboy",
	is_family = true,
	sfx = "wwise/events/ui/play_horde_mode_buff_family_cowboy",
	title = "All Master",
}
hordes_family_buffs_data.hordes_family_unkillable = {
	description = "Survivability focused around close quarters melee combat.",
	gradient = "content/ui/textures/color_ramps/hordes/horde_buff_family_gradient",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/buff_families/hordes_buff_family_unkillable",
	id = "unkillable",
	is_family = true,
	sfx = "wwise/events/ui/play_horde_mode_buff_family_unkillable",
	title = "Panzer",
}
hordes_family_buffs_data.hordes_family_critical = {
	description = "Focuses on critical hits and critical damage",
	gradient = "content/ui/textures/color_ramps/hordes/horde_buff_family_gradient",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/buff_families/hordes_buff_family_critical",
	id = "critical",
	is_family = true,
	sfx = "wwise/events/ui/play_horde_mode_buff_family_critical",
	title = "Lucky Roll",
}
hordes_family_buffs_data.hordes_family_unstoppable = {
	description = "Focuses on movement restriction immunities",
	gradient = "content/ui/textures/color_ramps/hordes/horde_buff_family_gradient",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/buff_families/hordes_buff_family_unstoppable",
	id = "unstoppable",
	is_family = true,
	sfx = "wwise/events/ui/play_horde_mode_buff_family_unstoppable",
	title = "Bulldozer",
}
hordes_family_buffs_data.hordes_buff_burning_on_ranged_hit = {
	description = "Ranged attacks apply 1 stack of burn",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_burning_on_ranged_hit",
	title = "Rain of fire",
	buff_stats = {
		stacks = {
			format_type = "number",
			value = 2,
		},
	},
}
hordes_family_buffs_data.hordes_buff_burning_on_melee_hit_taken = {
	description = "Puts a stacks fire to enemies hitting you in melee",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_burning_on_melee_hit_taken",
	title = "Can't touch me",
	buff_stats = {
		stacks = {
			format_type = "number",
			value = 5,
		},
	},
}
hordes_family_buffs_data.hordes_buff_burning_on_melee_hit = {
	description = "Puts a stack of fire when hitting ennemies in melee",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_burning_on_melee_hit",
	title = "Burn heretic",
	buff_stats = {
		stacks = {
			format_type = "number",
			value = 1,
		},
	},
}
hordes_family_buffs_data.hordes_buff_damage_vs_burning = {
	description = "Deals 70% more damage against target on fire",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_damage_vs_burning",
	title = "You burn, you die",
	buff_stats = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			value = 0.7,
		},
	},
}
hordes_family_buffs_data.hordes_buff_fire_pulse = {
	description = "A red pulse is activated in a 360 angle around the player every 20 seconds. It applies 2 burning stacks on all target being touched",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_fire_pulse",
	title = "The emperor will burn in me",
	buff_stats = {
		stacks = {
			format_type = "number",
			value = 5,
		},
	},
}
hordes_family_buffs_data.hordes_buff_toughness_on_fire_damage_dealt = {
	description = "Gain 1% toughness back from dealt fire damage",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_toughness_on_fire_damage_dealt",
	title = "Fed from fire",
	buff_stats = {
		thoughness_regen = {
			format_type = "percentage",
			value = 0.02,
		},
	},
}
hordes_family_buffs_data.hordes_buff_burning_damage_per_burning_enemy = {
	description = "Burning damage are improved by the amount of targets being on fire, up to 50%",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_burning_damage_per_burning_enemy",
	title = "The more the burner",
	buff_stats = {
		damage = {
			format_type = "percentage",
			value = 0.9,
		},
	},
}
hordes_family_buffs_data.hordes_buff_damage_taken_by_flamers_and_grenadier_reduced = {
	description = "flamethrower and grenadier deals 50% less damage to you",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_damage_taken_by_flamers_and_grenadier_reduced",
	title = "Born from fire",
	buff_stats = {
		damage_reduce = {
			format_type = "percentage",
			value = 0.7,
		},
	},
}
hordes_family_buffs_data.hordes_buff_coherency_damage_vs_burning = {
	description = "Allies has 8% improved damage against target being on fire",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_coherency_damage_vs_burning",
	title = "Burn with me friends",
	buff_stats = {
		damage = {
			format_type = "percentage",
			value = 0.2,
		},
	},
}
hordes_family_buffs_data.hordes_buff_coherency_burning_duration = {
	description = "Fire stacks linger 40% longer on target while on coherency",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_coherency_burning_duration",
	title = "FLesh will melt",
	buff_stats = {
		linger = {
			format_type = "percentage",
			value = 0.4,
		},
	},
}
hordes_family_buffs_data.hordes_buff_shock_on_melee_hit = {
	description = "20% to shock enemy on melee hit for 2 seconds",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_shock_on_melee_hit",
	title = "Stay where you are",
	buff_stats = {
		shock_chance = {
			format_type = "percentage",
			value = 0.2,
		},
		time = {
			format_type = "number",
			value = 2,
		},
	},
}
hordes_family_buffs_data.hordes_buff_damage_vs_electrocuted = {
	description = "Deals 10% more damage against electrocuted target",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_damage_vs_electrocuted",
	title = "Perfect catalyser",
	buff_stats = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			value = 0.5,
		},
	},
}
hordes_family_buffs_data.hordes_buff_shock_pulse_on_toughness_broken = {
	description = "When your toughness is being broken, shocked every enemies in a 5m area",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_shock_pulse_on_toughness_broken",
	title = "My weakness is my strength",
	buff_stats = {
		range = {
			format_type = "number",
			value = 5,
		},
	},
}
hordes_family_buffs_data.hordes_buff_instakill_melee_hit_on_electrocuted_enemy = {
	description = "1 % chance of instantaneously killing a shock enemie when being hit in melee ",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_instakill_melee_hit_on_electrocuted_enemy",
	title = "Smile, you die",
	buff_stats = {
		kill_chance = {
			format_type = "percentage",
			value = 0.05,
		},
	},
}
hordes_family_buffs_data.hordes_buff_shock_on_ranged_hit = {
	description = "5% to shock enemy on ranged hit",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_shock_on_ranged_hit",
	title = "Natural conduit",
	buff_stats = {
		shock_chance = {
			format_type = "percentage",
			value = 0.05,
		},
	},
}
hordes_family_buffs_data.hordes_buff_improved_dodge_speed_and_distance = {
	description = "Dodge is 15% faster and have 10% more range",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_improved_dodge_speed_and_distance",
	title = "Catch me if you can",
	buff_stats = {
		fast = {
			format_type = "percentage",
			value = 0.2,
		},
		range = {
			format_type = "percentage",
			value = 0.15,
		},
	},
}
hordes_family_buffs_data.hordes_buff_shock_on_hit_after_dodge = {
	description = "If being hit 3 seconds after a sucessful dodge, shock the assaillant",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_shock_on_hit_after_dodge",
	title = "Preternatural Perception",
	buff_stats = {
		time = {
			format_type = "number",
			value = 2,
		},
	},
}
hordes_family_buffs_data.hordes_buff_shock_closest_enemy_on_interval = {
	description = "All grenades apply shock on hit",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_shock_closest_enemy_on_interval",
	title = "Manual bolter",
	buff_stats = {
		time = {
			format_type = "number",
			value = 2,
		},
	},
}
hordes_family_buffs_data.hordes_buff_damage_taken_close_to_electrocuted_enemy = {
	description = "Take 25% less damage from enemies if one target is still being in shock state",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_damage_taken_close_to_electrocuted_enemy",
	title = "Shocking resilience",
	buff_stats = {
		damage_reduce = {
			format_type = "percentage",
			value = 0.25,
		},
	},
}
hordes_family_buffs_data.hordes_buff_coherency_damage_taken_close_to_electrocuted_enemy = {
	description = "Your team take 5% less damage from enemies if one enemy is still in shock state",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_coherency_damage_taken_close_to_electrocuted_enemy",
	title = "Shocking resilience Team",
	buff_stats = {
		damage_reduce = {
			format_type = "percentage",
			value = 0.25,
		},
	},
}
hordes_family_buffs_data.hordes_buff_extra_toughness_near_burning_shocked_enemies = {
	description = "For each enemy on fire or shocked in close range, you gain 8 extra toughness",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_extra_toughness_near_burning_shocked_enemies",
	title = "hardener",
	buff_stats = {
		extra_thoughness = {
			format_type = "number",
			prefix = "+",
			value = 8,
		},
	},
}
hordes_family_buffs_data.hordes_buff_shock_on_blocking_melee_attack = {
	description = "Blocking an attack in melee shock the target for {time} sc",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_shock_on_blocking_melee_attack",
	title = "ubeatable",
	buff_stats = {
		time = {
			format_type = "number",
			value = 3,
		},
	},
}
hordes_family_buffs_data.hordes_buff_toughness_regen_in_melee_range = {
	description = "replenish 2.5% toughness per second while with 5 meters of at least 3 enemies",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_toughness_regen_in_melee_range",
	title = "Feed from the weak",
	buff_stats = {
		thoughness_regen = {
			format_type = "percentage",
			value = 0.025,
		},
		range = {
			format_type = "number",
			value = 5,
		},
		ennemies_count = {
			format_type = "number",
			value = 3,
		},
	},
}
hordes_family_buffs_data.hordes_buff_reduce_damage_taken_on_disabled_allies = {
	description = "20% damage reduction for each knocked down or incapacitated ally within 20m",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_reduce_damage_taken_on_disabled_allies",
	title = "Stand against the odd",
	buff_stats = {
		damage = {
			format_type = "percentage",
			value = 0.2,
		},
		range = {
			format_type = "number",
			value = 20,
		},
	},
}
hordes_family_buffs_data.hordes_buff_coherency_corruption_healing = {
	description = "Heal 3s corruption from the current wound for you and allies in coherency",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_coherency_corruption_healing",
	title = "Share the boon",
	buff_stats = {
		heal = {
			format_type = "number",
			value = 3,
		},
	},
}
hordes_family_buffs_data.hordes_buff_combat_ability_cooldown_on_damage_taken = {
	description = "20% of damage taken is converted to ability cooldown reduction",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_combat_ability_cooldown_on_damage_taken",
	title = "Hit me harder",
	buff_stats = {
		damage_to_cooldown = {
			format_type = "percentage",
			prefix = "+",
			value = 0.2,
		},
	},
}
hordes_family_buffs_data.hordes_buff_two_extra_wounds = {
	description = "Give 2 additional wounds",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_two_extra_wounds",
	title = "Always coming back",
	buff_stats = {
		wounds = {
			format_type = "number",
			value = 2,
		},
	},
}
hordes_family_buffs_data.hordes_buff_toughness_damage_taken_above_threshold = {
	description = "Boosts toughness damage reduction by 50% while above 75% toughness",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_toughness_damage_taken_above_threshold",
	title = "Adamant skin",
	buff_stats = {
		damage_reduce = {
			format_type = "percentage",
			prefix = "+",
			value = 0.5,
		},
		toughness = {
			format_type = "percentage",
			value = 0.75,
		},
	},
}
hordes_family_buffs_data.hordes_buff_health_regen = {
	description = "Regenerate 1% Hp every 5 seconds. Does not heals corruption",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_health_regen",
	title = "Fast metabolism",
	buff_stats = {
		hp_regen = {
			format_type = "percentage",
			value = 0.01,
		},
		time = {
			format_type = "number",
			value = 5,
		},
	},
}
hordes_family_buffs_data.hordes_buff_damage_increase_on_toughness_broken = {
	description = "When your toughness is being broken, deal 10% more damage for 10s",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_damage_increase_on_toughness_broken",
	title = "Cornered",
	buff_stats = {
		damage = {
			format_type = "percentage",
			value = 0.6,
		},
	},
}
hordes_family_buffs_data.hordes_buff_damage_increase = {
	description = "Additional 25% damage from all sources",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_damage_increase",
	title = "Force of nature",
	buff_stats = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			value = 0.25,
		},
	},
}
hordes_family_buffs_data.hordes_buff_reduce_swap_time = {
	description = "Reduce swap time by 25%",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_reduce_swap_time",
	title = "Fast drawer",
	buff_stats = {
		swap_time = {
			format_type = "percentage",
			prefix = "+",
			value = 0.25,
		},
	},
}
hordes_family_buffs_data.hordes_buff_no_ammo_consumption_on_crits = {
	description = "No ammo consumption on critical hits",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_no_ammo_consumption_on_crits",
	title = "Crits does not count right ?",
	buff_stats = {},
}
hordes_family_buffs_data.hordes_buff_toughness_on_ranged_kill = {
	description = "Replenish 5% toughness on ranged kill",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_toughness_on_ranged_kill",
	title = "Born into combat",
	buff_stats = {
		thoughness_regen = {
			format_type = "percentage",
			value = 0.05,
		},
	},
}
hordes_family_buffs_data.hordes_buff_increased_damage_after_reload = {
	description = "+80% ranged damage for 5s after reload",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_increased_damage_after_reload",
	title = "It is all about confidence",
	buff_stats = {
		range = {
			format_type = "percentage",
			prefix = "+",
			value = 0.8,
		},
		time = {
			format_type = "number",
			value = 5,
		},
	},
}
hordes_family_buffs_data.hordes_buff_improved_weapon_reload_on_melee_kill = {
	description = "6% reload speed on melee kill. Stacks 5 times",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_improved_weapon_reload_on_melee_kill",
	title = "Guerrila fighter",
	buff_stats = {
		time = {
			format_type = "number",
			value = 5,
		},
		reload_speed = {
			format_type = "percentage",
			prefix = "+",
			value = 0.07,
		},
	},
}
hordes_family_buffs_data.hordes_buff_bonus_crit_chance_on_ammo = {
	description = "The first 35% ammo after a reload has +30% ranged critical hit chance",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_bonus_crit_chance_on_ammo",
	title = "Fresh bullets",
	buff_stats = {
		ammo = {
			format_type = "percentage",
			value = 0.35,
		},
		crit_chance = {
			format_type = "percentage",
			prefix = "+",
			value = 0.3,
		},
	},
}
hordes_family_buffs_data.hordes_buff_other_slot_damage_increase_on_kill = {
	description = "25% Melee damage on ranged kill/25% Range damage on melee kill Lasts 5s",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_other_slot_damage_increase_on_kill",
	title = "Versatile champion",
	buff_stats = {
		dammage = {
			format_type = "percentage",
			prefix = "+",
			value = 0.25,
		},
		range = {
			format_type = "percentage",
			value = 0.25,
		},
	},
}
hordes_family_buffs_data.hordes_buff_weakspot_ranged_hit_gives_infinite_ammo = {
	description = "Landing 2 Headshots in a row with a ranged weapon gives 6s of infinite ammo. Has a 10s cooldown.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_weakspot_ranged_hit_gives_infinite_ammo",
	title = "Fast killer",
	buff_stats = {
		headshot = {
			format_type = "number",
			value = 2,
		},
		time = {
			format_type = "number",
			value = 6,
		},
		cooldown = {
			format_type = "number",
			value = 10,
		},
	},
}
hordes_family_buffs_data.hordes_buff_ranged_attacks_hit_mass_penetration_increased = {
	description = "50% increase of max hit mass penetration for ranged attacks.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_ranged_attacks_hit_mass_penetration_increased",
	title = "slice'n'pierce",
	buff_stats = {
		increase_hitmass = {
			format_type = "percentage",
			value = 1,
		},
	},
}
hordes_family_buffs_data.hordes_buff_melee_damage_missing_ammo_in_clip = {
	description = "For every missing ammo in clip, gain 1% melee damage.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_melee_damage_missing_ammo_in_clip",
	title = "Light weight power",
	buff_stats = {
		dammage = {
			format_type = "percentage",
			value = 0.01,
		},
	},
}
hordes_family_buffs_data.hordes_buff_weakspot_damage_increase = {
	description = "Increases weakspot damage by 50%.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_weakspot_damage_increase",
	title = "Weakspot Damage Increase",
	buff_stats = {
		damage = {
			format_type = "percentage",
			value = 0.5,
		},
	},
}
hordes_family_buffs_data.hordes_buff_melee_critical_damage_increase = {
	description = "Increases melee critical damage by 70%.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_melee_critical_damage_increase",
	title = "Melee Crit Damage Increase",
	buff_stats = {
		crit_damage = {
			format_type = "percentage",
			value = 0.7,
		},
	},
}
hordes_family_buffs_data.hordes_buff_critical_chance_on_dodge = {
	description = "Increases critical chance by 30% on successful dodge.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_critical_chance_on_dodge",
	title = "Crit Chance Increase On Dodge",
	buff_stats = {
		crit_chance = {
			format_type = "percentage",
			value = 0.2,
		},
		time = {
			value = 3,
		},
	},
}
hordes_family_buffs_data.hordes_buff_rending_on_ranged_critical_hit = {
	description = "Increases rending by 60% on ranged critical hit.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_rending_on_ranged_critical_hit",
	title = "Rending on Ranged Critical Hit",
	buff_stats = {
		rending = {
			format_type = "percentage",
			value = 0.6,
		},
		time = {
			value = 5,
		},
	},
}
hordes_family_buffs_data.hordes_buff_critical_melee_hit_infinite_cleave = {
	description = "Critical hits have infinite cleave.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_critical_melee_hit_infinite_cleave",
	title = "Critical Cleave",
	buff_stats = {},
}
hordes_family_buffs_data.hordes_buff_melee_damage_on_melee_critical_hit = {
	description = "After a melee critical hit, the next melee hit gets it's damage boosted by 100%.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_melee_damage_on_melee_critical_hit",
	title = "Lucky Melee",
	buff_stats = {
		damage = {
			format_type = "percentage",
			value = 1,
		},
	},
}
hordes_family_buffs_data.hordes_buff_increase_super_armor_impact_on_crit = {
	description = "Critical hits on Carapaced Armoured enemies gain 65% more Impact..",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_increase_super_armor_impact_on_crit",
	title = "Hunt for the strong",
	buff_stats = {
		impact = {
			format_type = "percentage",
			value = 0.65,
		},
	},
}
hordes_family_buffs_data.hordes_buff_stacking_crit_damage_on_critical_hit = {
	description = "Gain 0.01% critical strike damage after a critical strike. Up to 100%.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_stacking_crit_damage_on_critical_hit",
	title = "Special treat",
	buff_stats = {
		crit_damage = {
			format_type = "percentage",
			value = 0.01,
		},
		max_crit_damage = {
			format_type = "percentage",
			value = 2.5,
		},
	},
}
hordes_family_buffs_data.hordes_buff_damage_reduction_on_critical_hit = {
	description = "Gain 30% damage reduction after a critical strike for 3sc.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_damage_reduction_on_critical_hit",
	title = "Critical Armor",
	buff_stats = {
		damage_reduction = {
			format_type = "percentage",
			value = 0.4,
		},
		time = {
			value = 3,
		},
	},
}
hordes_family_buffs_data.hordes_buff_explode_enemies_on_critical_kill = {
	description = "Enemies killed by a critical hit explode.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_explode_enemies_on_critical_kill",
	title = "Critical Explosion",
	buff_stats = {},
}
hordes_family_buffs_data.hordes_buff_guaranteed_next_melee_attack_on_ranged_critical_hit = {
	description = "When killing an enemy with a Ranged Critical Attack, the next Melee Attack will be a guaranteed Critical Attack.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_guaranteed_next_melee_attack_on_ranged_critical_hit",
	title = "Melee Crit on Ranged Crit",
	buff_stats = {},
}
hordes_family_buffs_data.hordes_buff_guaranteed_next_ranged_attack_on_melee_critical_hit = {
	description = "When killing an enemy with a Melee Critical Attack, the next Range Attack will be a guaranteed Critical Attack.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_guaranteed_next_ranged_attack_on_melee_critical_hit",
	title = "Ranged Crit on Melee Crit",
	buff_stats = {},
}
hordes_family_buffs_data.hordes_buff_increase_melee_crit_chance_on_ranged_critical_kill = {
	description = "When killing an enemy with a Ranged Critical Attack, gain 60% Melee Crit Chance for 5s.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_increase_melee_crit_chance_on_ranged_critical_kill",
	title = "Melee Follow-up",
	buff_stats = {
		crit_chance = {
			format_type = "percentage",
			value = 0.6,
		},
		time = {
			value = 5,
		},
	},
}
hordes_family_buffs_data.hordes_buff_increase_ranged_crit_chance_on_melee_critical_kill = {
	description = "When killing an enemy with a Melee Critical Attack, gain 60% ranged Crit Chance for 5s.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_increase_ranged_crit_chance_on_melee_critical_kill",
	title = "Ranged Follow-up",
	buff_stats = {
		crit_chance = {
			format_type = "percentage",
			value = 0.6,
		},
		time = {
			value = 5,
		},
	},
}
hordes_family_buffs_data.hordes_buff_crit_chance_per_missing_stamina_bar = {
	description = "Gain 5% Critical Strike Chance per missing stamina bar.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_crit_chance_per_missing_stamina",
	title = "Critical Stamina Per Bar Version",
	buff_stats = {
		crit_chance = {
			format_type = "percentage",
			value = 0.04,
		},
	},
}
hordes_family_buffs_data.hordes_buff_critical_damage_from_consecutive_critical_hits = {
	description = "Gain 10% Critical Strike Damage after a Critical Strike. Up to 100%. Loses all stacks if 2.5s pass before your next Critical Strike.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_critical_damage_from_consecutive_critical_hits",
	title = "On a Roll",
	buff_stats = {
		crit_damage = {
			format_type = "percentage",
			value = 0.1,
		},
		max_crit_damage = {
			format_type = "percentage",
			value = 1,
		},
		time = {
			format_type = "number",
			value = 2.5,
		},
	},
}
hordes_family_buffs_data.hordes_buff_dodge_staggers = {
	description = "Dodging staggers nearby Non Elite/Specialist, human-sized, enemies.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_dodge_staggers",
	title = "Wrecking Ball",
	buff_stats = {},
}
hordes_family_buffs_data.hordes_buff_sprinting_staggers = {
	description = "Sprinting staggers nearby Non Elite/Specialist, human-sized, enemies.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_sprinting_staggers",
	title = "Bulldozer",
	buff_stats = {},
}
hordes_family_buffs_data.hordes_buff_uninterruptible_while_aiming_and_shooting = {
	description = "Becomes Uninterruptible while aiming or shooting.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_uninterruptible_while_aiming_and_shooting",
	title = "Relentless Shooting",
	buff_stats = {},
}
hordes_family_buffs_data.hordes_buff_replenish_stamina_from_ranged_or_melee_hit = {
	description = "Regain 1% stamina per 100 damage dealt with melee or ranged attacks.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_replenish_stamina_from_ranged_or_melee_hit",
	title = "Shooting & Shmoving",
	buff_stats = {
		stamina = {
			format_type = "percentage",
			value = 0.009,
		},
	},
}
hordes_family_buffs_data.hordes_buff_toughness_coherency_regen_increase = {
	description = "Toughness Regeneration in coherency is increased by 50%",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_toughness_coherency_regen_increase",
	title = "Comerades",
	buff_stats = {
		toughness = {
			format_type = "percentage",
			value = 0.5,
		},
	},
}
hordes_family_buffs_data.hordes_buff_toughness_on_melee_kills = {
	description = "Replenish an additional 7% toughness from melee kills.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_toughness_on_melee_kills",
	title = "Melee Survival",
	buff_stats = {
		toughness = {
			format_type = "percentage",
			value = 0.07,
		},
	},
}
hordes_family_buffs_data.hordes_buff_movement_bonuses_on_toughness_broken = {
	description = "Stun immunity, slow immunity for 6sc and restore 50% stamina when your toughness is broken",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_movement_bonuses_on_toughness_broken",
	title = "Grit",
	buff_stats = {
		stamina = {
			format_type = "percentage",
			value = 0.5,
		},
		time = {
			format_type = "number",
			value = 4,
		},
	},
}
hordes_family_buffs_data.hordes_buff_suppression_immunity = {
	description = "Gain suppression immunity",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_suppression_immunity",
	title = "Unfaced",
	buff_stats = {},
}
hordes_family_buffs_data.hordes_buff_windup_is_uninterruptible = {
	description = "Become uninterruptible while charging heavy attack.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_windup_is_uninterruptible",
	title = "No stopping me either.",
	buff_stats = {},
}
hordes_family_buffs_data.hordes_buff_no_movement_speed_reduction_on_aim_and_windup = {
	description = "Remove Movement Speed Penalty from Aiming and Charging Melee Attacks",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_no_movement_speed_reduction_on_aim_and_windup",
	title = "Speedy Gonazales",
	buff_stats = {},
}
hordes_family_buffs_data.hordes_buff_increase_impact_on_push_attacks = {
	description = "Doubles staggering strength of Push Attacks",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_increase_impact_on_push_attacks",
	title = "PUSH PUSH PUSH",
	buff_stats = {},
}
hordes_family_buffs_data.hordes_buff_dodge_incapacitating_attacks = {
	description = "Automatically nullifies a Netgunner and Chaos Hound incapacitating attack. 30s Cooldown.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_dodge_incapacitating_attacks",
	title = "Can't Touch This",
	buff_stats = {
		cooldown = {
			format_type = "number",
			value = 30,
		},
	},
}
hordes_family_buffs_data.hordes_buff_damage_per_full_stamina_bar = {
	description = "Gain 2 Stamina. Increase Damage by 5% per full stamina bar.",
	gradient = "content/ui/textures/color_ramps/talent_ability",
	icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_damage_per_full_stamina_bar",
	title = "Spinach power",
	buff_stats = {
		stamina = {
			format_type = "number",
			value = 2,
		},
		damage = {
			format_type = "percentage",
			value = 0.05,
		},
	},
}

return hordes_family_buffs_data
