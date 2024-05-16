-- chunkname: @scripts/settings/talent/talent_settings_veteran.lua

local DamageSettings = require("scripts/settings/damage/damage_settings")
local talent_settings = {
	veteran_1 = {
		combat_ability = {
			cooldown = 45,
		},
		grenade = {
			max_charges = 3,
		},
		coherency = {},
		passive_1 = {},
		passive_2 = {},
		mixed_1 = {},
		mixed_2 = {},
		mixed_3 = {},
		offensive_1 = {},
		offensive_2 = {},
		offensive_3 = {},
		defensive_1 = {},
		defensive_2 = {},
		defensive_3 = {},
		coop_1 = {},
		coop_2 = {},
		coop_3 = {},
		spec_passive_1 = {},
		spec_passive_2 = {},
		spec_passive_3 = {},
		combat_ability_1 = {},
		combat_ability_2 = {},
		combat_ability_3 = {},
	},
	veteran_2 = {
		combat_ability_base = {
			ranged_damage = 0.15,
			ranged_impact_modifier = 0.5,
			ranged_weakspot_damage = 0.15,
		},
		combat_ability = {
			cooldown = 30,
			duration = 5,
			fov_multiplier = 0.85,
			max_charges = 1,
			max_stacks = 1,
			movement_speed = 0,
			on_hit_proc_chance = 1,
			outline_angle = 0.5,
			outline_distance = 50,
			outline_duration = 5,
			outline_highlight_offset = 0.15,
			outline_highlight_offset_total_max_time = 0.6,
			push_speed_modifier = -0.5,
			ranged_damage = 0.25,
			ranged_impact_modifier = 1,
			ranged_weakspot_damage = 0.25,
			recoil_modifier = -0.24,
			spread_modifier = -0.38,
			sway_modifier = 0.4,
			toughness = 0.6,
		},
		grenade = {
			max_charges = 3,
		},
		coherency = {
			ammo_replenishment_percent = 0.0075,
			ammo_replenishment_percent_improved = 0.01,
			cooldown = 5,
		},
		passive_1 = {
			weakspot_damage = 0.3,
		},
		passive_2 = {
			ammo_reserve_capacity = 0.4,
		},
		toughness_1 = {
			duration = 10,
			instant_toughness = 0.1,
			toughness = 0.02,
		},
		toughness_2 = {
			duration = 8,
			max_stacks = 3,
			toughness = 0.15,
			toughness_damage_taken_multiplier = 0.9,
		},
		toughness_3 = {
			time = 0.1,
			toughness = 0.005,
			range = DamageSettings.in_melee_range,
		},
		offensive_1_1 = {
			damage_far = 0.2,
		},
		offensive_1_2 = {
			reload_speed = 0.25,
		},
		offensive_1_3 = {
			grenade_replenishment_cooldown = 60,
			grenade_restored = 1,
		},
		defensive_1 = {
			toughness_damage_taken_multiplier = 0.25,
		},
		defensive_2 = {
			stamina_percent = 0.3,
		},
		defensive_3 = {
			threat_weight_multiplier = 0.1,
		},
		coop_1 = {
			outline_short_duration = 5,
		},
		coop_2 = {
			proc_chance = 0.05,
		},
		coop_3 = {
			damage = 0.1,
			duration = 3,
			range = 5,
			toughness_percent = 0.15,
		},
		offensive_2_1 = {
			stacks = 6,
		},
		offensive_2_2 = {
			critical_strike_chance = 0.25,
			recoil_modifier = -0.12,
			shot_stamina = 0.25,
			spread_modifier = -0.19,
			stamina_per_second = 0.75,
			sway_modifier = 0.4,
		},
		offensive_2_3 = {
			reload_speed = 0.3,
		},
		combat_ability_1 = {},
		combat_ability_2 = {
			weakspot_damage = 0.5,
		},
		combat_ability_3 = {
			damage_vs_ogryn_and_monsters = 0.75,
		},
	},
	veteran_3 = {
		combat_ability = {
			cone_dot = 0.95,
			cone_range = 30,
			cooldown = 30,
			max_charges = 1,
			power_level = 500,
			radius = 9,
			toughness_replenish_percent = 0.5,
		},
		grenade = {
			max_charges = 2,
		},
		coherency = {
			damage = 0.05,
			max_stacks = 1,
		},
		passive_1 = {
			cooldown_reduction = 6,
			on_hit_proc_chance = 1,
			talent_cooldown_reduction = 10,
		},
		passive_2 = {},
		passive_3 = {
			damage_taken_modifier = 0.15,
			on_tag_unit_proc_chance = 1,
			on_untag_unit_proc_chance = 1,
		},
		toughness_1 = {
			max = 0.67,
			min = 1,
		},
		toughness_2 = {
			toughness_bonus = 1,
		},
		toughness_3 = {
			toughness = 0.05,
		},
		mixed_1 = {},
		mixed_2 = {
			krak_damage = 0.5,
		},
		mixed_3 = {},
		offensive_1 = {
			duration = 8,
			ranged_damage = 0.15,
		},
		offensive_2 = {
			max_charges = 4,
		},
		offensive_3 = {
			active_duration = 8,
			damage = 0.2,
			melee_impact_modifier = 0.2,
			on_minion_death_proc_chance = 0.025,
			suppression_dealt = 0.2,
		},
		defensive_1 = {
			damage_taken_multiplier = 0.67,
			duration = 5,
			movement_speed = 0.2,
		},
		defensive_2 = {
			damage = -0.5,
			damage_monsters = -0.3,
		},
		defensive_3 = {
			block_cost_multiplier = 0.5,
			stamina_duration = 5,
			toughness_damage_taken_multiplier = 0.67,
			toughness_duration = 5,
		},
		coop_1 = {},
		coop_2 = {},
		coop_3 = {
			percent = 0.15,
		},
		offensive_2_1 = {
			duration = 10,
			max_stacks = 5,
			melee_power_level_modifier = 0.04,
		},
		offensive_2_2 = {
			damage_taken_modifier = 0.1,
		},
		offensive_2_3 = {
			damage = 0.05,
			duration = 6,
		},
		combat_ability_1 = {
			charge_up_time = -0.25,
			duration = 10,
			recoil_modifier = -0.85,
			reload_speed = 0.6,
			spread_modifier = -0.85,
			sway_modifier = 0.15,
		},
		combat_ability_2 = {
			attack_speed = 0.1,
			block_cost_multiplier = 0.2,
			duration = 10,
			impact_modifier = 0.3,
			melee_damage = 0.1,
			movement_speed = 0.1,
		},
		combat_ability_3 = {},
	},
}

return talent_settings
