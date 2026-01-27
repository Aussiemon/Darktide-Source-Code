-- chunkname: @scripts/settings/talent/talent_settings_broker.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local Text = require("scripts/utilities/ui/text")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local stat_buffs = BuffSettings.stat_buffs
local STIMM_ICON_BY_GROUP = {}
local STAT_NAME_ALIAS = {
	power_level_modifier = "power_level",
}
local talent_settings = {}

local function _generate_stimm_talent(talent_name, display_name, tier, description, icon_group)
	local data = {
		talent_data = {
			name = "",
			display_name = display_name,
			description = description,
			icon = STIMM_ICON_BY_GROUP[icon_group],
			passive = {
				identifier = talent_name,
				buff_template_name = talent_name,
			},
			format_values = {},
		},
		buff_data = {},
	}

	data.talent_data.format_values.tier = tier and Text.convert_to_roman_numerals(tier) or ""
	talent_settings.broker_stimm[talent_name] = data

	local modifier = {}

	modifier.stat = function (...)
		data.buff_data.stat_buffs = data.buff_data.stat_buffs or {}
		data.talent_data.format_values = data.talent_data.format_values or {}

		if type(data.talent_data.description) ~= "table" then
			data.talent_data.description = {
				data.talent_data.description,
			}
		end

		for i = 1, select("#", ...), 2 do
			local stat_name = select(i, ...)
			local format_values = select(i + 1, ...)
			local stat_value = format_values.value
			local description_alias = STAT_NAME_ALIAS[stat_name] or stat_name

			table.insert(data.talent_data.description, "loc_talent_stat_" .. description_alias)

			data.buff_data.stat_buffs[stat_name] = stat_value
			data.talent_data.format_values[description_alias] = format_values
		end

		return modifier
	end

	modifier.buff = function (buff_name, buff_params, buff_target_description, ...)
		data.buff_data.buff_target = buff_name
		data.buff_data.buff_params = buff_params

		if buff_target_description then
			if type(data.talent_data.description) ~= "table" then
				data.talent_data.description = {
					data.talent_data.description,
				}
			end

			data.talent_data.description[#data.talent_data.description + 1] = buff_target_description

			local keyword_span_n = select("#", ...)

			if keyword_span_n > 0 then
				local format_values = {}

				for i = 1, keyword_span_n, 2 do
					local keyword_key = select(i, ...)
					local keyword_data = select(i + 1, ...)

					format_values[keyword_key] = keyword_data
				end

				local format_values_per_index = data.talent_data.format_values_per_index or {}

				data.talent_data.format_values_per_index = format_values_per_index
				format_values_per_index[#data.talent_data.description] = format_values
			end
		end

		return modifier
	end

	modifier.keyword = function (...)
		for i = 1, select("#", ...), 5 do
			local keyword_format_type = select(i, ...)
			local keyword_prefix = select(i + 1, ...)
			local keyword_key = select(i + 2, ...)
			local keyword_value = select(i + 3, ...)
			local keyword_value_manipulation = select(i + 4, ...)

			table.insert(data.talent_data.description, "loc_talent_keyword_" .. keyword_key)

			data.talent_data.format_values[keyword_key] = {
				format_type = keyword_format_type,
				prefix = keyword_prefix,
				value = keyword_value,
				value_manipulation = keyword_value_manipulation,
			}
		end

		return modifier
	end

	return modifier
end

talent_settings.broker = {
	combat_ability = {
		focus = {
			ammo_refill_amount = 0.1,
			cooldown = 45,
			cooldown_base = 0.5,
			cooldown_elite = 1,
			cooldown_max = 5,
			duration = 10,
			duration_divisor = 5,
			duration_extend = 1,
			duration_max = 20,
			extend_on_kill = true,
			fov_multiplier = 1.1,
			max_charges = 1,
			max_stacks = 1,
			outline_angle = 0.5,
			outline_duration = 10,
			outline_highlight_offset = 0,
			outline_highlight_offset_total_max_time = 0,
			reload_on_kill = false,
			reload_speed = 0.5,
			sprint_movement_speed = 0.2,
			sprinting_cost_multiplier = 0,
		},
		punk_rage = {
			cooldown = 30,
			exhaust_damage_taken_multiplier = 1.25,
			exhaust_duration = 7,
			exhaust_stamina_regeneration_multiplier = 0.25,
			improved_shout_duration = 5,
			improved_shout_enemy_melee_attack_speed = -0.5,
			max_charges = 1,
			max_hit_mass_modifier = 0.5,
			max_stacks = 1,
			melee_rending_multiplier = 0.25,
			rage_damage_taken_multiplier = 0.75,
			rage_duration = 10,
			rage_duration_divisor = 2,
			rage_duration_extend = 0.3,
			rage_duration_max = 20,
			rage_duration_max_upgrade = 40,
			rage_fov_multiplier = 1.1,
			rage_melee_attack_speed = 0.2,
			rage_melee_power_level_modifier = 0.5,
			rage_toughness_replenished = 0.1,
			shout_radius = 4.5,
			stacking_melee_power = 0.025,
			sub_1_rending_threshold_t = 0.5,
			sub_4_duration_extend_elite = 1,
			sub_4_duration_max_improved = 30,
		},
		stimm_field = {
			buff_to_add = "syringe_broker_buff_stimm_field",
			consume_broker_syringe = true,
			consume_pickup_syringe = true,
			cooldown = 60,
			corruption_heal_amount = 0.5,
			disable_ability_for_duration = true,
			hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_stimm_field",
			hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
			hud_priority = 1,
			interval = 0.25,
			life_time = 20,
			max_charges = 1,
			proximity_radius = 3,
			skip_tactical_overlay = true,
			stickiness_limit = 5,
			stickiness_time = 1,
			sub_1_life_time = 5,
			sub_1_linger_time = 15,
		},
	},
	blitz = {
		flash_grenade = {
			max_charges_default = 3,
			max_charges_improved = 5,
			num_charges = 1,
			num_kills = 20,
		},
		tox_grenade = {
			max_charges = 3,
		},
		missile_launcher = {
			max_charges = 3,
		},
	},
	coherency = {
		ruffian = {
			max_stacks = 1,
			melee_damage = 0.1,
		},
		anarchist = {
			critical_strike_chance = 0.05,
			max_stacks = 1,
		},
	},
	broker_passive_repeated_melee_hits_increases_damage = {
		damage = 0.25,
		req_hits = 2,
	},
	broker_passive_first_target_damage = {
		damage = 0.15,
	},
	broker_passive_reduce_swap_time = {
		recoil_modifier = -0.1,
		spread_modifier = -0.3,
		wield_speed = 0.4,
	},
	broker_passive_increased_ranged_dodges = {
		extra_consecutive_dodges = 1,
	},
	broker_passive_close_ranged_damage = {
		damage_far = 0.1,
		damage_near = 0.25,
	},
	broker_passive_ninja_grants_crit_chance = {
		allow_proc_while_active = true,
		critical_strike_chance = 0.2,
		duration = 3,
		max_stacks = 1,
		proc_chance = 1,
	},
	broker_passive_parries_grant_crit_chance = {
		allow_proc_while_active = true,
		critical_strike_chance = 0.2,
		duration = 2,
		max_stacks = 1,
		proc_chance = 1,
	},
	broker_passive_backstabs_grant_crit_chance = {
		allow_proc_while_active = true,
		critical_strike_chance = 0.2,
		duration = 2,
		max_stacks = 1,
		proc_chance = 1,
	},
	broker_passive_improved_dodges = {
		dodge_distance_modifier = 0.25,
		dodge_linger_time_modifier = 0.5,
	},
	broker_passive_dodge_melee_on_slide = {},
	broker_passive_restore_toughness_on_close_ranged_kill = {
		toughness_elites = 0.15,
		toughness_percentage = 0.08,
	},
	broker_passive_restore_toughness_on_weakspot_kill = {
		critical = 0.12,
		default = 0.04,
		weakspot = 0.08,
	},
	broker_passive_reduced_toughness_damage_during_reload = {
		duration = 4,
		toughness_damage_taken_modifier = -0.25,
	},
	broker_passive_sprinting_reduces_threat = {
		duration = 3,
		max_stacks = 4,
		threat_weight_multiplier = 0.875,
		threshold = 1,
	},
	broker_passive_reload_speed_on_close_kill = {
		duration = 8,
		reload_speed = 0.3,
	},
	broker_passive_melee_attacks_apply_toxin = {
		stacks = 1,
		toxin_buff = "neurotoxin_interval_buff3",
	},
	broker_passive_blitz_charge_on_kill = {
		num_charges = 1,
		num_kills = 20,
	},
	broker_passive_weakspot_on_x_hit = {
		num_hits = 6,
	},
	broker_passive_close_range_rending = {
		multiplier = 0.15,
	},
	broker_passive_strength_vs_aggroed = {
		power_level_modifier = 0.1,
	},
	broker_passive_improved_sprint_dodge = {
		sprint_dodge_reduce_angle_threshold_rad = math.rad(15),
	},
	broker_passive_extra_consecutive_dodges = {
		extra_consecutive_dodges = 1,
	},
	broker_passive_extended_mag = {
		clip_size_modifier = 0.15,
	},
	broker_passive_reload_on_crit = {
		ammo_replenish_percent = 0.15,
	},
	broker_passive_close_ranged_finesse_damage = {
		finesse_close_range_modifier = 0.25,
	},
	broker_passive_close_range_damage_on_dodge = {
		active_duration = 3,
		damage_near = 0.15,
	},
	broker_passive_close_range_damage_on_slide = {
		damage_near = 0.15,
	},
	broker_passive_finesse_damage = {
		finesse_modifier_bonus = 0.15,
	},
	broker_passive_ramping_backstabs = {
		max_stacks = 5,
		melee_power_level_modifier = 0.1,
	},
	broker_passive_punk_grit = {
		ranged_damage = 0.1,
		toughness_damage_taken_multiplier = 0.9,
	},
	broker_passive_stamina_on_successful_dodge = {
		stamina = 0.1,
	},
	broker_passive_improved_dodges_at_full_stamina = {
		conditional_threshold = 0.75,
		dodge_cooldown_reset_modifier = -0.4,
	},
	broker_passive_stamina_grants_atk_speed = {
		attack_speed_increase = 0.02,
		max_stacks = 15,
	},
	broker_passive_increased_weakspot_damage = {
		weakspot_damage = 0.25,
	},
	broker_passive_stun_immunity_on_toughness_broken = {
		cooldown = 10,
		duration = 6,
		toughness = 0.5,
	},
	broker_passive_push_on_damage_taken = {
		angle = 0.5,
		damage_reduction = 0.1,
		impact = 0.5,
		max_stacks = 3,
		push_cost_multiplier = 0,
	},
	broker_passive_replenish_toughness_on_ranged_toughness_damage = {
		duration = 3,
		toughness = 0.3,
	},
	broker_passive_ammo_on_backstab = {
		ammo_regain = 0.01,
		cooldown = 5,
	},
	broker_passive_stimm_increased_duration = {
		duration_increase = 5,
	},
	broker_passive_stimm_cleanse_on_kill = {
		cleanse_amount = 0.01,
		cleanse_threshold = 0.5,
	},
	broker_passive_damage_vs_heavy_staggered = {
		multiplier = 0.15,
	},
	broker_passive_stun_on_max_toxin_stacks = {
		cooldown = 0,
		duration = 3,
		threshold = nil,
	},
	broker_passive_reduced_damage_by_toxined = {
		default_damage_debuff = -0.15,
		monster_damage_debuff = -0.3,
	},
	broker_passive_damage_after_toxined_enemies = {
		check_interval = 0.2,
		damage_per_stack = 0.05,
		max_increase = 0.15,
		range = DamageSettings.ranged_close,
	},
	broker_passive_toughness_on_toxined_kill = {
		toughness_replenish = 0.15,
	},
	broker_passive_increased_toxin_damage = {
		increase = 0.1,
	},
	broker_passive_melee_damage_carry_over = {
		active_duration = 1,
		percentage = 0.25,
	},
	broker_passive_increased_aura_size = {
		coherency_radius_modifier = 0.75,
	},
	broker_passive_cleave_on_cleave = {
		max_hit_mass_attack_modifier = 0.5,
		min_targets = 3,
	},
	broker_passive_dr_damage_tradeoff_on_stamina = {
		damage_multiplier = 0.2,
		damage_reduction_multiplier = 0.2,
	},
	broker_passive_damage_on_reload = {
		ammo_percentage_per_stage = 0.1,
		base_damage = 0.02,
		damage_per_ammo_stage = 0.02,
		duration = 7,
	},
	broker_keystone_vultures_mark_on_kill = {
		crit_chance = 0.05,
		duration = 8,
		max_stacks = 3,
		movement_speed = 0.05,
		ranged_damage = 0.05,
		toughness_percent = 0.15,
	},
	broker_keystone_vultures_mark_increased_duration = {
		duration = 12,
	},
	broker_keystone_vultures_mark_dodge_on_ranged_crit = {
		duration = 1,
	},
	broker_keystone_chemical_dependency = {
		combat_ability_cooldown_regen_modifier = 0.1,
		critical_strike_chance = 0.05,
		duration = 90,
		max_stacks = 3,
		sub_2_toughness_grant = 0.5,
		sub_3_duration = 60,
		sub_3_max_stacks = 4,
		toughness_damage_taken_multiplier = 0.95,
	},
	broker_keystone_adrenaline_junkie = {
		adrenaline_duration = 2,
		adrenaline_max_stacks = 30,
		crit_grant = 1,
		frenzy_duration = 10,
		frenzy_max_stacks = 1,
		melee_attack_speed = 0.1,
		melee_damage = 0.25,
		regular_grant = 1,
		sub_1_regular_grant = 0,
		sub_1_weakspot_additional_grant = 2,
		sub_2_kill_additional_elite_grant = 10,
		sub_2_kill_additional_grant = 4,
		sub_3_frenzy_duration = 20,
		sub_4_duration = 4,
		sub_5_toughness_per_tick = 0.05,
	},
}
talent_settings.broker_stimm = {}

local stimm_icons = {
	celerity_a = "icon here!",
	celerity_b = "icon here!",
	celerity_c = "icon here!",
	combat_a = "icon here!",
	combat_b = "icon here!",
	combat_c = "icon here!",
	concentration_a = "icon here!",
	concentration_b = "icon here!",
	concentration_c = "icon here!",
	durability_a = "icon here!",
	durability_b = "icon here!",
	durability_c = "icon here!",
}

_generate_stimm_talent("broker_stimm_celerity_1", "loc_talent_broker_stimm_celerity_a", 1, nil, stimm_icons.celerity_a).stat(stat_buffs.attack_speed, {
	format_type = "percentage",
	prefix = "+",
	value = 0.04,
}, stat_buffs.wield_speed, {
	format_type = "percentage",
	prefix = "+",
	value = 0.25,
})
_generate_stimm_talent("broker_stimm_celerity_2", "loc_talent_broker_stimm_celerity_a", 2, nil, stimm_icons.celerity_a).stat(stat_buffs.attack_speed, {
	format_type = "percentage",
	prefix = "+",
	value = 0.04,
}, stat_buffs.wield_speed, {
	format_type = "percentage",
	prefix = "+",
	value = 0.25,
}, stat_buffs.stamina_cost_multiplier, {
	format_type = "percentage",
	value = 0.85,
	value_manipulation = function (value)
		return math.round((value - 1) * 100)
	end,
})
_generate_stimm_talent("broker_stimm_celerity_3", "loc_talent_broker_stimm_celerity_a", 3, nil, stimm_icons.celerity_a).stat(stat_buffs.attack_speed, {
	format_type = "percentage",
	prefix = "+",
	value = 0.04,
}, stat_buffs.stamina_cost_multiplier, {
	format_type = "percentage",
	value = 0.85,
	value_manipulation = function (value)
		return math.round((value - 1) * 100)
	end,
})
_generate_stimm_talent("broker_stimm_celerity_4", "loc_talent_broker_stimm_celerity_a", 4, nil, stimm_icons.celerity_a).stat(stat_buffs.attack_speed, {
	format_type = "percentage",
	prefix = "+",
	value = 0.04,
}, stat_buffs.stamina_cost_multiplier, {
	format_type = "percentage",
	value = 0.8,
	value_manipulation = function (value)
		return math.round((value - 1) * 100)
	end,
})
_generate_stimm_talent("broker_stimm_celerity_5a", "loc_talent_broker_stimm_celerity_a", 5, nil, stimm_icons.celerity_a).stat(stat_buffs.attack_speed, {
	format_type = "percentage",
	prefix = "+",
	value = 0.04,
}).keyword("loc_string", "+", "stun_immune", 1, nil, "loc_string", "+", "slowdown_immune", 1, nil)
_generate_stimm_talent("broker_stimm_celerity_5b", "loc_talent_broker_stimm_celerity_b", nil, nil, stimm_icons.celerity_b).stat(stat_buffs.reload_speed, {
	format_type = "percentage",
	prefix = "+",
	value = 0.3,
}, stat_buffs.recoil_modifier, {
	format_type = "percentage",
	value = -0.5,
})
_generate_stimm_talent("broker_stimm_celerity_5c", "loc_talent_broker_stimm_celerity_c", nil, nil, stimm_icons.celerity_c).stat(stat_buffs.movement_speed, {
	format_type = "percentage",
	prefix = "+",
	value = 0.1,
}, stat_buffs.dodge_distance_modifier, {
	format_type = "percentage",
	prefix = "+",
	value = 0.1,
}, stat_buffs.dodge_speed_multiplier, {
	format_type = "percentage",
	prefix = "+",
	value = 1.1,
	value_manipulation = function (value)
		return (value - 1) * 100
	end,
}, stat_buffs.dodge_cooldown_reset_modifier, {
	format_type = "percentage",
	prefix = "+",
	value = -0.1,
	value_manipulation = function (value)
		return math.abs(value * 100)
	end,
})
_generate_stimm_talent("broker_stimm_combat_1", "loc_talent_broker_stimm_combat_a", 1, nil, stimm_icons.combat_a).stat(stat_buffs.power_level_modifier, {
	format_type = "percentage",
	prefix = "+",
	value = 0.04,
})
_generate_stimm_talent("broker_stimm_combat_2", "loc_talent_broker_stimm_combat_a", 2, nil, stimm_icons.combat_a).stat(stat_buffs.power_level_modifier, {
	format_type = "percentage",
	prefix = "+",
	value = 0.04,
})
_generate_stimm_talent("broker_stimm_combat_3", "loc_talent_broker_stimm_combat_a", 3, nil, stimm_icons.combat_a).stat(stat_buffs.power_level_modifier, {
	format_type = "percentage",
	prefix = "+",
	value = 0.04,
})
_generate_stimm_talent("broker_stimm_combat_4a", "loc_talent_broker_stimm_combat_a", 4, nil, stimm_icons.combat_a).stat(stat_buffs.power_level_modifier, {
	format_type = "percentage",
	prefix = "+",
	value = 0.04,
}, stat_buffs.finesse_modifier_bonus, {
	format_type = "percentage",
	prefix = "+",
	value = 0.1,
})
_generate_stimm_talent("broker_stimm_combat_5a", "loc_talent_broker_stimm_combat_a", 5, nil, stimm_icons.combat_a).stat(stat_buffs.power_level_modifier, {
	format_type = "percentage",
	prefix = "+",
	value = 0.04,
}, stat_buffs.finesse_modifier_bonus, {
	format_type = "percentage",
	prefix = "+",
	value = 0.25,
})
_generate_stimm_talent("broker_stimm_combat_4b", "loc_talent_broker_stimm_combat_b", 1, nil, stimm_icons.combat_b).stat(stat_buffs.power_level_modifier, {
	format_type = "percentage",
	prefix = "+",
	value = 0.04,
}, stat_buffs.rending_multiplier, {
	format_type = "percentage",
	prefix = "+",
	value = 0.05,
})
_generate_stimm_talent("broker_stimm_combat_5b", "loc_talent_broker_stimm_combat_b", 2, nil, stimm_icons.combat_b).stat(stat_buffs.power_level_modifier, {
	format_type = "percentage",
	prefix = "+",
	value = 0.04,
}, stat_buffs.rending_multiplier, {
	format_type = "percentage",
	prefix = "+",
	value = 0.1,
})
_generate_stimm_talent("broker_stimm_combat_4c", "loc_talent_broker_stimm_combat_c", 1, nil, stimm_icons.combat_c).stat(stat_buffs.power_level_modifier, {
	format_type = "percentage",
	prefix = "+",
	value = 0.04,
}, stat_buffs.critical_strike_chance, {
	format_type = "percentage",
	prefix = "+",
	value = 0.05,
})
_generate_stimm_talent("broker_stimm_combat_5c", "loc_talent_broker_stimm_combat_c", 2, nil, stimm_icons.combat_c).stat(stat_buffs.power_level_modifier, {
	format_type = "percentage",
	prefix = "+",
	value = 0.04,
}, stat_buffs.critical_strike_chance, {
	format_type = "percentage",
	prefix = "+",
	value = 0.1,
})
_generate_stimm_talent("broker_stimm_durability_1", "loc_talent_broker_stimm_durability_a", 1, nil, stimm_icons.durability_a).stat(stat_buffs.toughness_regen_rate_modifier, {
	format_type = "percentage",
	prefix = "+",
	value = 0.2,
}).stat(stat_buffs.damage_taken_modifier, {
	format_type = "percentage",
	value = -0.04,
})
_generate_stimm_talent("broker_stimm_durability_2", "loc_talent_broker_stimm_durability_a", 2, nil, stimm_icons.durability_a).stat(stat_buffs.toughness_regen_rate_modifier, {
	format_type = "percentage",
	prefix = "+",
	value = 0.2,
}).stat(stat_buffs.damage_taken_modifier, {
	format_type = "percentage",
	value = -0.04,
})
_generate_stimm_talent("broker_stimm_durability_3", "loc_talent_broker_stimm_durability_a", 3, nil, stimm_icons.durability_a).stat(stat_buffs.toughness_regen_rate_modifier, {
	format_type = "percentage",
	prefix = "+",
	value = 0.2,
}).stat(stat_buffs.damage_taken_modifier, {
	format_type = "percentage",
	value = -0.04,
})
_generate_stimm_talent("broker_stimm_durability_4", "loc_talent_broker_stimm_durability_a", 4, nil, stimm_icons.durability_a).buff("broker_syringe_toughness_restore", {
	toughness_amount = 0.25,
}, "loc_talent_buff_toughness_on_stimm", "toughness_amount", {
	format_type = "percentage",
	value = 0.25,
}).stat(stat_buffs.toughness_regen_rate_modifier, {
	format_type = "percentage",
	prefix = "+",
	value = 0.2,
}).stat(stat_buffs.damage_taken_modifier, {
	format_type = "percentage",
	value = -0.04,
})
_generate_stimm_talent("broker_stimm_durability_5a", "loc_talent_broker_stimm_durability_b", nil, nil, stimm_icons.durability_b).stat(stat_buffs.toughness_regen_rate_modifier, {
	format_type = "percentage",
	prefix = "+",
	value = 0.2,
})
_generate_stimm_talent("broker_stimm_durability_5b", "loc_talent_broker_stimm_durability_c", nil, nil, stimm_icons.durability_c).buff("broker_syringe_toughness_restore", {
	toughness_amount = 0.25,
}, "loc_talent_buff_toughness_on_stimm", "toughness_amount", {
	format_type = "percentage",
	value = 0.25,
})
_generate_stimm_talent("broker_stimm_concentration_1", "loc_talent_broker_stimm_concentration_a", 1, nil, stimm_icons.concentration_a).stat(stat_buffs.combat_ability_cooldown_regen_modifier, {
	format_type = "percentage",
	prefix = "+",
	value = 0.0625,
})
_generate_stimm_talent("broker_stimm_concentration_2", "loc_talent_broker_stimm_concentration_a", 2, nil, stimm_icons.concentration_a).stat(stat_buffs.combat_ability_cooldown_regen_modifier, {
	format_type = "percentage",
	prefix = "+",
	value = 0.0625,
})
_generate_stimm_talent("broker_stimm_concentration_3", "loc_talent_broker_stimm_concentration_a", 3, nil, stimm_icons.concentration_a).stat(stat_buffs.combat_ability_cooldown_regen_modifier, {
	format_type = "percentage",
	prefix = "+",
	value = 0.0625,
})
_generate_stimm_talent("broker_stimm_concentration_4", "loc_talent_broker_stimm_concentration_a", 4, nil, stimm_icons.concentration_a).stat(stat_buffs.combat_ability_cooldown_regen_modifier, {
	format_type = "percentage",
	prefix = "+",
	value = 0.0625,
})
_generate_stimm_talent("broker_stimm_concentration_5a", "loc_talent_broker_stimm_concentration_a", 5, nil, stimm_icons.concentration_a).stat(stat_buffs.combat_ability_cooldown_regen_modifier, {
	format_type = "percentage",
	prefix = "+",
	value = 0.25,
})
_generate_stimm_talent("broker_stimm_concentration_5b", "loc_talent_broker_stimm_concentration_b", nil, nil, stimm_icons.concentration_b).buff("broker_syringe_cooldown_on_melee_kills", {
	melee_cd_duration = 1,
	melee_cd_regen = 0.75,
}, "loc_talent_buff_cooldown_on_melee_kills", "duration", {
	format_type = "number",
	value = 1,
}, "cooldown", {
	format_type = "percentage",
	prefix = "+",
	value = 0.75,
})
_generate_stimm_talent("broker_stimm_concentration_5c", "loc_talent_broker_stimm_concentration_c", nil, nil, stimm_icons.concentration_c).buff("broker_syringe_cooldown_on_ranged_kills", {
	ranged_cd_duration = 1,
	ranged_cd_regen = 0.75,
}, "loc_talent_buff_cooldown_on_ranged_kills", "duration", {
	format_type = "number",
	value = 1,
}, "cooldown", {
	format_type = "percentage",
	prefix = "+",
	value = 0.75,
})

return talent_settings
