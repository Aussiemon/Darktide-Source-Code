-- chunkname: @scripts/settings/ability/archetype_talents/talents/cryptic_talents.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local special_rules = SpecialRulesSettings.special_rules
local talent_settings = TalentSettings.cryptic
local math_round = math.round

math_round = math_round or function (value)
	if value >= 0 then
		return math.floor(value + 0.5)
	else
		return math.ceil(value - 0.5)
	end
end

local archetype_talents = {
	archetype = "cryptic",
	talents = {
		cryptic_servo_skull_improved_tagging = {
			description = "loc_talent_cryptic_servo_skull_improved_tagging_fire_rate_cost_desc",
			display_name = "loc_talent_cryptic_servo_skull_improved_tagging",
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			large_icon = "content/ui/textures/icons/talents/cryptic/cryptic_servo_skull_improved_tagging",
			name = "cryptic_servo_skull_improved_tagging",
			special_rule = {
				identifier = "cryptic_servo_skull_improved_tagging",
				special_rule_name = special_rules.cryptic_servo_skull_improved_tagging,
			},
			format_values = {
				capacitance = {
					format_type = "percentage",
					value = talent_settings.servo_skull_shooting_tagging.capacitance,
				},
				attack_speed = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.servo_skull_shooting_tagging.cooldown_modifier,
					value_manipulation = function (value)
						local attack_speed = math_round((1 / value - 1) * 100)

						return attack_speed
					end,
				},
				duration = {
					format_type = "number",
					value = talent_settings.servo_skull_shooting_tagging.duration,
				},
				capacitance_keyword = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_power_keyword",
				},
			},
		},
		cryptic_discharge_base = {
			description = "loc_talent_cryptic_discharge_base_desc",
			display_name = "loc_talent_cryptic_discharge_base",
			large_icon = "content/ui/textures/icons/talents/cryptic/cryptic_discharge",
			name = "cryptic_discharge",
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.cryptic_discharge_base,
			},
			passive = {
				identifier = {
					"cryptic_ability_recharge",
				},
				buff_template_name = {
					"cryptic_ability_recharge",
				},
			},
			format_values = {
				range = {
					format_type = "number",
					value = ExplosionTemplates.cryptic_discharge_aoe_electrocution_base.radius,
				},
				range_two = {
					format_type = "number",
					value = ExplosionTemplates.cryptic_discharge_aoe_electrocution_base_two.radius,
				},
				range_three = {
					format_type = "number",
					value = ExplosionTemplates.cryptic_discharge_aoe_electrocution_base_three.radius,
				},
				duration = {
					format_type = "number",
					value = talent_settings.discharge_ability.stun_duration_base,
				},
				charge_two = {
					format_type = "number",
					value = 2,
				},
				charge_three = {
					format_type = "number",
					value = 3,
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_discharge_base",
				},
			},
		},
		cryptic_discharge = {
			description = "loc_talent_cryptic_discharge_desc",
			display_name = "loc_talent_cryptic_discharge",
			large_icon = "content/ui/textures/icons/talents/cryptic/cryptic_discharge",
			name = "cryptic_discharge",
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.cryptic_discharge,
			},
			passive = {
				identifier = {
					"cryptic_discharge_weapon_malfunction",
					"cryptic_ability_recharge",
				},
				buff_template_name = {
					"cryptic_discharge_weapon_malfunction",
					"cryptic_ability_recharge",
				},
			},
			format_values = {
				range = {
					format_type = "number",
					value = ExplosionTemplates.cryptic_discharge_aoe_electrocution.radius,
				},
				far_range = {
					format_type = "number",
					value = talent_settings.discharge_ability.weapon_malfunction_radius,
				},
				malfunction_duration = {
					format_type = "number",
					value = 12,
				},
				duration = {
					format_type = "number",
					value = talent_settings.discharge_ability.stun_duration_base,
				},
				buff_duration = {
					format_type = "number",
					value = talent_settings.discharge_ability.buff_duration,
				},
				short_duration = {
					format_type = "number",
					value = talent_settings.discharge_ability.stun_duration_weapon,
				},
				charge_two = {
					format_type = "number",
					value = 2,
				},
				charge_three = {
					format_type = "number",
					value = 3,
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_discharge",
				},
			},
		},
		cryptic_discharge_attack_speed_increase = {
			description = "loc_talent_cryptic_discharge_two_charge_bonus_desc",
			display_name = "loc_talent_cryptic_discharge_two_charge_bonus",
			name = "cryptic_discharge_attack_speed_increase",
			special_rule = {
				identifier = "cryptic_discharge_gives_attack_speed",
				special_rule_name = special_rules.cryptic_discharge_gives_attack_speed,
			},
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_discharge",
				},
				charge = {
					format_type = "number",
					value = talent_settings.discharge_ability.two_charge_bonus.num_charges_used_required,
				},
				attack_speed = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.discharge_ability.two_charge_bonus.attack_speed,
				},
				duration = {
					format_type = "number",
					value = talent_settings.discharge_ability.two_charge_bonus.duration,
				},
			},
		},
		cryptic_discharge_toughness = {
			description = "loc_talent_cryptic_discharge_toughness_desc",
			display_name = "loc_talent_cryptic_discharge_toughness",
			name = "cryptic_discharge_toughness",
			special_rule = {
				identifier = "cryptic_discharge_restores_toughness_on_use",
				special_rule_name = special_rules.cryptic_discharge_restores_toughness_on_use,
			},
			passive = {
				buff_template_name = "cryptic_discharge_toughness",
				identifier = "cryptic_discharge_toughness",
			},
			format_values = {
				ability_name = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_discharge",
				},
				toughness = {
					format_type = "percentage",
					value = talent_settings.discharge_ability.cryptic_discharge_toughness.toughness_percent_on_use,
				},
				toughness_per_hit = {
					format_type = "percentage",
					value = talent_settings.discharge_ability.cryptic_discharge_toughness.toughness_percent_per_hit,
				},
			},
		},
		cryptic_discharge_generates_arcs = {
			description = "loc_talent_cryptic_discharge_arc_bonus_desc",
			display_name = "loc_talent_cryptic_discharge_arc_bonus",
			name = "cryptic_discharge_generates_arcs",
			special_rule = {
				identifier = "cryptic_discharge_generates_arcs",
				special_rule_name = special_rules.cryptic_discharge_generates_arcs,
			},
			format_values = {
				ability_name = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_discharge",
				},
				num_arcs = {
					format_type = "number",
					value = talent_settings.discharge_ability.cryptic_discharge_arc_bonus.num_arcs_per_charge_used,
				},
			},
		},
		cryptic_precision_stance = {
			description = "loc_talent_cryptic_precision_stance_drain_cost_desc",
			display_name = "loc_talent_cryptic_precision_stance",
			large_icon = "content/ui/textures/icons/talents/cryptic/cryptic_precision_stance",
			name = "cryptic_precision_stance",
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.cryptic_precision_stance,
			},
			passive = {
				identifier = {
					"cryptic_ability_recharge",
				},
				buff_template_name = {
					"cryptic_ability_recharge",
				},
			},
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_precision_stance",
				},
				recoil = {
					format_type = "percentage",
					value = talent_settings.precision_stance.recoil_modifier,
				},
				spread = {
					format_type = "percentage",
					value = talent_settings.precision_stance.spread_modifier,
				},
				zero_charges = {
					format_type = "number",
					value = 0,
				},
				charge_min = {
					format_type = "number",
					value = 1,
				},
				two_charges = {
					format_type = "number",
					value = 2,
				},
				three_charges = {
					format_type = "number",
					value = 3,
				},
				capacitance_drain = {
					format_type = "percentage",
					value = talent_settings.precision_stance.cooldown_percent_lost_per_second,
				},
				capacitance_instant = {
					format_type = "percentage",
					value = talent_settings.precision_stance.cooldown_percent_cost_on_activation,
				},
				capacitance_shot = {
					format_type = "percentage",
					value = talent_settings.precision_stance.cooldown_percent_used_on_shoot,
				},
				capacitance_keyword = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_power_keyword",
				},
				zero_capacitance = {
					format_type = "percentage",
					value = 0,
				},
			},
		},
		cryptic_precision_stance_toughness_suppression = {
			description = "loc_talent_cryptic_precision_stance_toughness_suppression_desc",
			display_name = "loc_talent_cryptic_precision_stance_toughness_suppression",
			name = "cryptic_precision_stance_toughness_suppression",
			special_rule = {
				identifier = "cryptic_precision_stance_restores_toughness",
				special_rule_name = special_rules.cryptic_precision_stance_restores_toughness,
			},
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_precision_stance",
				},
				toughness = {
					format_type = "percentage",
					value = talent_settings.precision_stance.cryptic_precision_stance_toughness_suppression.toughness_regen_per_second,
				},
			},
		},
		cryptic_precision_stance_fire_rate_increased = {
			description = "loc_talent_cryptic_precision_stance_fire_rate_increased_desc",
			display_name = "loc_talent_cryptic_precision_stance_fire_rate_increased",
			name = "cryptic_precision_stance_fire_rate_increased",
			passive = {
				identifier = {
					"cryptic_precision_stance_fire_rate_increased_base",
					"cryptic_precision_stance_fire_rate_increased_delayed",
				},
				buff_template_name = {
					"cryptic_precision_stance_fire_rate_increased_base",
					"cryptic_precision_stance_fire_rate_increased_delayed",
				},
			},
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_precision_stance",
				},
				duration = {
					format_type = "number",
					value = talent_settings.precision_stance.cryptic_precision_stance_fire_rate_increased.buff_start_delay,
				},
				fire_rate = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.precision_stance.cryptic_precision_stance_fire_rate_increased.ranged_attack_speed,
				},
				fire_rate_increased = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.precision_stance.cryptic_precision_stance_fire_rate_increased.increased_ranged_attack_speed,
				},
			},
		},
		cryptic_precision_stance_reload_speed_delayed = {
			description = "loc_talent_cryptic_precision_stance_reload_speed_desc",
			display_name = "loc_talent_cryptic_precision_stance_reload_speed_delayed",
			name = "cryptic_precision_stance_reload_speed_delayed",
			passive = {
				buff_template_name = "cryptic_precision_stance_reload_speed_delayed",
				identifier = "cryptic_precision_stance_reload_speed_delayed",
			},
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_precision_stance",
				},
				ability_name = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_precision_stance",
				},
				initial_duration = {
					format_type = "number",
					value = talent_settings.precision_stance.cryptic_precision_stance_reload_speed_delayed.buff_start_delay,
				},
				reload_speed = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.precision_stance.cryptic_precision_stance_reload_speed_delayed.reload_speed,
				},
				duration = {
					format_type = "number",
					value = talent_settings.precision_stance.cryptic_precision_stance_reload_speed_delayed.lingering_buff_time,
				},
			},
		},
		cryptic_precision_stance_damage_on_elite_kill = {
			description = "loc_talent_cryptic_precision_stance_damage_on_elite_kill_desc",
			display_name = "loc_talent_cryptic_precision_stance_damage_on_elite_kill",
			name = "cryptic_precision_stance_damage_on_elite_kill",
			special_rule = {
				identifier = "cryptic_precision_stance_damage_on_elite_kill",
				special_rule_name = special_rules.cryptic_precision_stance_damage_on_elite_kill,
			},
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_precision_stance",
				},
				damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.precision_stance.cryptic_precision_stance_damage_on_elite_kill.damage,
				},
				duration = {
					format_type = "number",
					value = talent_settings.precision_stance.cryptic_precision_stance_damage_on_elite_kill.duration,
				},
				stacks = {
					format_type = "number",
					value = talent_settings.precision_stance.cryptic_precision_stance_damage_on_elite_kill.max_stacks,
				},
			},
		},
		cryptic_precision_stance_crit_cleave = {
			description = "loc_talent_cryptic_precision_stance_crit_cleave_desc",
			display_name = "loc_talent_cryptic_precision_stance_crit_cleave",
			name = "cryptic_precision_stance_crit_cleave",
			passive = {
				identifier = {
					"cryptic_precision_stance_crit_cleave_base",
					"cryptic_precision_stance_crit_cleave_increased",
				},
				buff_template_name = {
					"cryptic_precision_stance_crit_cleave_base",
					"cryptic_precision_stance_crit_cleave_increased",
				},
			},
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_precision_stance",
				},
				cleave = {
					format_type = "percentage",
					value = talent_settings.precision_stance.cryptic_precision_stance_crit_cleave.ranged_max_hit_mass_attack_modifier,
				},
				crit_chance = {
					format_type = "percentage",
					value = talent_settings.precision_stance.cryptic_precision_stance_crit_cleave.ranged_critical_strike_chance,
				},
				increased_cleave = {
					format_type = "percentage",
					value = talent_settings.precision_stance.cryptic_precision_stance_crit_cleave.increased_ranged_max_hit_mass_attack_modifier,
				},
				increased_crit_chance = {
					format_type = "percentage",
					value = talent_settings.precision_stance.cryptic_precision_stance_crit_cleave.increased_ranged_critical_strike_chance,
				},
				duration = {
					format_type = "number",
					value = talent_settings.precision_stance.cryptic_precision_stance_crit_cleave.increased_boost_delay,
				},
			},
		},
		cryptic_chordclaw = {
			description = "loc_talent_cryptic_chordclaw_desc",
			display_name = "loc_talent_cryptic_chordclaw",
			name = "cryptic_chordclaw",
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.cryptic_chordclaw,
			},
			format_values = {
				dr = {
					format_type = "percentage",
					prefix = "+",
					value = 1 - talent_settings.chordclaw_ability.damage_taken_multipler_while_wielding,
				},
				rending = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.chordclaw_ability.rending,
				},
			},
		},
		cryptic_chordclaw_quick_stab_combo = {
			description = "loc_talent_cryptic_chordclaw_quick_stab_combo_desc",
			display_name = "loc_talent_cryptic_chordclaw_quick_stab_combo",
			name = "cryptic_chordclaw_quick_stab_combo",
			special_rule = {
				identifier = "cryptic_chordclaw_do_quick_stab_combo",
				special_rule_name = special_rules.cryptic_chordclaw_do_quick_stab_combo,
			},
			format_values = {
				num_stab = {
					format_type = "number",
					value = 3,
				},
				bleed_stacks = {
					format_type = "number",
					value = 6,
				},
			},
		},
		cryptic_chordclaw_horizontal_swipe = {
			description = "loc_talent_cryptic_chordclaw_horizontal_swipe_desc",
			display_name = "loc_talent_cryptic_chordclaw_horizontal_swipe",
			name = "cryptic_chordclaw_do_horizontal_swipe",
			special_rule = {
				identifier = "cryptic_chordclaw_do_horizontal_swipe",
				special_rule_name = special_rules.cryptic_chordclaw_do_horizontal_swipe,
			},
			format_values = {},
		},
		cryptic_chordclaw_capacitance_restoration = {
			description = "loc_talent_cryptic_chordclaw_capacitance_restoration_desc",
			display_name = "loc_talent_cryptic_chordclaw_capacitance_restoration",
			name = "cryptic_chordclaw_capacitance_restoration",
			passive = {
				buff_template_name = "cryptic_chordclaw_capacitance_restoration",
				identifier = "cryptic_chordclaw_capacitance_restoration",
			},
			format_values = {
				capacitance_percent = {
					format_type = "percentage",
					value = talent_settings.chordclaw_ability.cooldown_restoration.cooldown_percent_over_time,
				},
				duration = {
					format_type = "number",
					value = talent_settings.chordclaw_ability.cooldown_restoration.cooldown_regen_time,
				},
				capacitance_keyword = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_power_keyword",
				},
			},
		},
		cryptic_chordclaw_consecutive_bonus = {
			description = "loc_talent_cryptic_chordclaw_consecutive_bonus_desc",
			display_name = "loc_talent_cryptic_chordclaw_consecutive_bonus",
			name = "cryptic_chordclaw_consecutive_bonus",
			special_rule = {
				identifier = "cryptic_chordclaw_gives_chordclaw_damage_on_use",
				special_rule_name = special_rules.cryptic_chordclaw_gives_chordclaw_damage_on_use,
			},
			format_values = {
				damage = {
					format_type = "percentage",
					value = talent_settings.chordclaw_ability.consecutive_bonus.chordclaw_damage,
				},
				duration = {
					format_type = "number",
					value = talent_settings.chordclaw_ability.consecutive_bonus.duration,
				},
				max_stacks = {
					format_type = "number",
					value = talent_settings.chordclaw_ability.consecutive_bonus.max_stacks,
				},
			},
		},
		cryptic_servo_skull_order = {
			description = "loc_talent_cryptic_servo_skull_base_burn_desc",
			display_name = "loc_talent_cryptic_servo_skull",
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			icon = "content/ui/textures/icons/talents/cryptic/cryptic_servo_skull_base",
			name = "cryptic_servo_skull_order",
			format_values = {
				damage_taken = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.servo_skull_shooting_base.damage_taken_multiplier,
				},
				burn_stacks = {
					format_type = "number",
					value = talent_settings.servo_skull_shooting_base.burn_stacks,
				},
				max_stacks = {
					format_type = "number",
					value = talent_settings.servo_skull_shooting_base.max_burn_stacks,
				},
				debuff_duration = {
					format_type = "number",
					value = talent_settings.servo_skull_shooting_base.debuff_duration,
				},
				attack_speed = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.servo_skull_shooting_base.cooldown_modifier,
					value_manipulation = function (value)
						return math_round((1 / value - 1) * 100)
					end,
				},
				damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.servo_skull_shooting_base.damage_modifier,
				},
				duration = {
					format_type = "number",
					value = talent_settings.servo_skull_shooting_base.duration,
				},
				cooldown = {
					format_type = "number",
					value = talent_settings.servo_skull_shooting_base.cooldown,
				},
			},
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.cryptic_servo_skull_order_base,
			},
			special_rule = {
				identifier = {
					"cryptic_servo_skull_hack",
					"no_grenades",
				},
				special_rule_name = {
					special_rules.cryptic_servo_skull_hack,
					special_rules.disable_grenade_pickups,
				},
			},
		},
		cryptic_servo_skull_improved = {
			description = "loc_talent_cryptic_servo_skull_improved_clarified_desc",
			display_name = "loc_talent_cryptic_servo_skull_improved",
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			icon = "content/ui/textures/icons/talents/cryptic/cryptic_servo_skull_improved",
			is_main_ability = true,
			large_icon = "content/ui/textures/icons/talents/cryptic/cryptic_servo_skull_improved",
			name = "cryptic_servo_skull_improved",
			format_values = {
				damage_taken = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.servo_skull_shooting_base.damage_taken_multiplier,
				},
				burn_stacks = {
					format_type = "number",
					value = talent_settings.servo_skull_shooting_base.burn_stacks,
				},
				debuff_duration = {
					format_type = "number",
					value = talent_settings.servo_skull_shooting_base.debuff_duration,
				},
			},
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.cryptic_servo_skull_order_base_inactive,
			},
			special_rule = {
				identifier = {
					"cryptic_servo_skull_improved",
					"no_grenades",
				},
				special_rule_name = {
					special_rules.cryptic_servo_skull_improved,
					special_rules.hack_to_allow_grenades,
				},
			},
			passive = {
				buff_template_name = "cryptic_servo_skull_order",
				identifier = "cryptic_servo_skull_order",
			},
		},
		cryptic_flamethrower = {
			description = "loc_talent_cryptic_servo_skull_flamethrower_desc",
			display_name = "loc_talent_cryptic_servo_skull_flamethrower",
			icon = "content/ui/textures/icons/talents/cryptic/cryptic_flamethrower",
			ignore_same_steps_conflict = true,
			is_main_ability = false,
			large_icon = "content/ui/textures/icons/talents/cryptic/cryptic_flamethrower",
			name = "cryptic_flamethrower",
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.cryptic_servo_skull_order,
			},
			special_rule = {
				identifier = {
					"cryptic_flamethrower",
					"no_grenades",
				},
				special_rule_name = {
					special_rules.cryptic_servo_skull_flamethrower,
					special_rules.hack_to_allow_grenades,
				},
			},
		},
		cryptic_servo_skull_inject_ally = {
			description = "loc_talent_cryptic_servo_skull_inject_ally_revive_desc",
			display_name = "loc_talent_cryptic_servo_skull_inject_ally",
			icon = "content/ui/textures/icons/talents/cryptic/cryptic_servo_skull_inject_ally",
			ignore_same_steps_conflict = true,
			is_main_ability = false,
			large_icon = "content/ui/textures/icons/talents/cryptic/cryptic_servo_skull_inject_ally",
			name = "cryptic_servo_skull_inject_ally",
			special_rule = {
				identifier = "cryptic_servo_skull_inject_ally",
				special_rule_name = special_rules.cryptic_servo_skull_inject_ally,
			},
			format_values = {
				toughness = {
					format_type = "number",
					prefix = "+",
					value = talent_settings.servo_skull_medicae.toughness_bonus,
				},
				tdr = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.servo_skull_medicae.tdr,
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end,
				},
				duration = {
					format_type = "number",
					value = talent_settings.servo_skull_medicae.duration,
				},
				toughness_instant = {
					format_type = "percentage",
					value = talent_settings.servo_skull_medicae.instant_toughness_percent,
				},
				toughness_per_second = {
					format_type = "percentage",
					value = talent_settings.servo_skull_medicae.toughness_percent,
				},
				knocked_down = {
					format_type = "loc_string",
					value = "loc_glossary_term_knocked_down",
				},
				hogtied = {
					format_type = "loc_string",
					value = "loc_glossary_term_hogtied",
				},
				netted = {
					format_type = "loc_string",
					value = "loc_glossary_term_netted",
				},
			},
			player_ability = {
				ability_type = "grenade_ability",
				is_ability_modifier = true,
				ability = PlayerAbilities.cryptic_servo_skull_order,
			},
		},
		cryptic_grenade_ability_force_field = {
			description = "loc_talent_cryptic_grenade_ability_force_field_clarified_desc",
			display_name = "loc_talent_cryptic_grenade_ability_force_field",
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			icon = "content/ui/textures/icons/talents/cryptic/cryptic_grenade_ability_force_field",
			name = "triggers a protective bubble around and attached to the player",
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.cryptic_force_field,
			},
			format_values = {
				duration = {
					format_type = "number",
					value = talent_settings.force_field.duration,
				},
				range = {
					format_values = "number",
					value = talent_settings.force_field.range,
				},
			},
			special_rule = {
				identifier = {
					"no_grenades",
					"disable_companion",
				},
				special_rule_name = {
					special_rules.hack_to_allow_grenades,
					special_rules.disable_companion,
				},
			},
		},
		cryptic_force_field_duration_increase = {
			description = "loc_talent_cryptic_force_field_duration_increase_desc",
			display_name = "loc_talent_cryptic_force_field_duration_increase",
			icon = "content/ui/textures/icons/talents/cryptic/cryptic_force_field_duration_increase",
			name = "force field increases duration and explodes at half time",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_grenade_ability_force_field",
				},
				increased_duration = {
					format_type = "number",
					value = talent_settings.force_field.increased_duration,
				},
			},
			special_rule = {
				identifier = {
					"cryptic_force_field_increased_duration_and_extra_explosion",
				},
				special_rule_name = {
					special_rules.cryptic_force_field_increased_duration_and_extra_explosion,
				},
			},
		},
		cryptic_force_field_health_damage_limit = {
			description = "loc_talent_cryptic_force_field_health_damage_limit_desc",
			display_name = "loc_talent_cryptic_force_field_health_damage_limit",
			icon = "content/ui/textures/icons/talents/cryptic/cryptic_force_field_health_damage_limit",
			name = "Limits damage taken while active",
			special_rule = {
				identifier = "cryptic_force_field_limit_damage_taken",
				special_rule_name = special_rules.cryptic_force_field_limit_damage_taken,
			},
			format_values = {
				force_field_name = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_grenade_ability_force_field",
				},
				limit = {
					format_type = "number",
					value = talent_settings.force_field.max_health_damage_taken_per_hit,
				},
			},
		},
		cryptic_force_field_arcs = {
			description = "loc_talent_cryptic_force_field_arcs_desc",
			display_name = "loc_talent_cryptic_force_field_arcs",
			icon = "content/ui/textures/icons/talents/cryptic/cryptic_force_field_arcs",
			name = "cryptic_force_field_arcs",
			special_rule = {
				identifier = "cryptic_force_field_generates_arcs_based_on_hits_blocked",
				special_rule_name = special_rules.cryptic_force_field_generates_arcs_based_on_hits_blocked,
			},
			format_values = {
				max_arcs = {
					format_type = "number",
					value = talent_settings.force_field.force_field_arcs.max_arcs,
				},
			},
		},
		cryptic_grenade_ability_arc_grenade = {
			description = "loc_talent_cryptic_arc_grenades_desc",
			display_name = "loc_talent_cryptic_arc_grenades",
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			icon = "content/ui/textures/icons/talents/cryptic/cryptic_grenade_ability_arc_grenade",
			name = "Base Cryptic Grenade",
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.arc_grenade,
			},
			format_values = {
				charges = {
					format_type = "number",
					value = talent_settings.arc_grenade.charges,
				},
				number = {
					format_type = "number",
					value = talent_settings.arc_grenade.base_num_arcs,
				},
			},
			special_rule = {
				identifier = {
					"disable_companion",
					"no_grenades",
				},
				special_rule_name = {
					special_rules.disable_companion,
					special_rules.hack_to_allow_grenades,
				},
			},
		},
		cryptic_arc_grenades_weapon_malfunction = {
			description = "loc_talent_cryptic_arc_grenades_weapon_malfunction_desc",
			display_name = "loc_talent_cryptic_arc_grenades_weapon_malfunction",
			name = "cryptic_arc_grenades_weapon_malfunction",
			passive = {
				buff_template_name = "cryptic_arc_grenades_weapon_malfunction",
				identifier = "cryptic_arc_grenades_weapon_malfunction",
			},
			format_values = {
				duration = {
					format_type = "number",
					value = 12,
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_arc_grenades",
				},
				range = {
					format_type = "number",
					value = talent_settings.arc_grenade.radius,
				},
			},
		},
		cryptic_arc_grenades_brittleness = {
			description = "loc_talent_cryptic_arc_grenades_brittleness_desc",
			display_name = "loc_talent_cryptic_arc_grenades_brittleness",
			name = "cryptic_arc_grenades_brittleness",
			passive = {
				buff_template_name = "cryptic_grenade_ability_arc_grenade_extra_arcs",
				identifier = "cryptic_grenade_ability_arc_grenade_extra_arcs",
			},
			special_rule = {
				identifier = {
					"cryptic_arc_grenade_gives_brittleness",
				},
				special_rule_name = {
					special_rules.cryptic_arc_grenade_gives_brittleness,
				},
			},
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_arc_grenades",
				},
				number = {
					format_type = "number",
					value = talent_settings.arc_grenade.extra_arcs,
				},
				stacks = {
					format_type = "number",
					value = talent_settings.arc_grenade.rending_stacks_on_minions_hit_by_arc,
				},
			},
		},
		cryptic_coherency_regen_aura = {
			description = "loc_talent_cryptic_coherency_regen_aura_desc",
			display_name = "loc_talent_cryptic_coherency_regen_aura",
			icon = "content/ui/textures/icons/talents/cryptic/cryptic_coherency_regen_aura",
			large_icon = "content/ui/textures/icons/talents/cryptic/cryptic_coherency_regen_aura",
			name = "cryptic_coherency_regen_aura",
			coherency = {
				buff_template_name = "cryptic_coherency_regen_aura",
				identifier = "cryptic_aura",
				priority = 1,
			},
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings.cryptic_coherency_regen_aura.min_toughness_coherency_regen_rate_modifier,
				},
			},
		},
		cryptic_coherency_regen_aura_improved = {
			description = "loc_talent_cryptic_coherency_regen_aura_improved_desc",
			display_name = "loc_talent_cryptic_coherency_regen_aura",
			name = "cryptic_coherency_regen_aura_improved",
			coherency = {
				buff_template_name = "cryptic_coherency_regen_aura_improved",
				identifier = "cryptic_aura",
				priority = 1,
			},
			passive = {
				buff_template_name = "cryptic_coherency_regen_aura_improved_personal_boost",
				identifier = "cryptic_coherency_regen_aura_improved_personal_boost",
			},
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings.cryptic_coherency_regen_aura_improved.min_toughness_coherency_regen_rate_modifier,
				},
				toughness_flat = {
					format_type = "number",
					prefix = "+",
					value = talent_settings.cryptic_coherency_regen_aura_improved.toughness,
				},
			},
		},
		cryptic_aura_weapon_improved = {
			description = "loc_talent_cryptic_aura_weapon_improved_desc",
			display_name = "loc_talent_cryptic_aura_weapon_improved",
			name = "cryptic_aura_weapon_improved",
			coherency = {
				buff_template_name = "cryptic_aura_weapon_improved",
				identifier = "cryptic_aura",
				priority = 1,
			},
			passive = {
				buff_template_name = "cryptic_aura_weapon_improved_personal_boost",
				identifier = "cryptic_aura_weapon_improved_personal_boost",
			},
			format_values = {
				rending = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_aura_weapon_improved.rending_multiplier,
				},
				cleave = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_aura_weapon_improved.max_hit_mass_attack_modifier,
				},
				toughness = {
					format_type = "number",
					prefix = "+",
					value = talent_settings.cryptic_aura_weapon_improved.toughness,
				},
			},
		},
		cryptic_ammo_aura = {
			description = "loc_talent_cryptic_ammo_aura_toughness_desc",
			display_name = "loc_talent_cryptic_ammo_aura",
			name = "cryptic_ammo_aura",
			coherency = {
				buff_template_name = "cryptic_coherency_empty",
				identifier = "cryptic_aura",
				priority = 1,
			},
			passive = {
				buff_template_name = "cryptic_ammo_aura",
				identifier = "cryptic_ammo_aura",
			},
			format_values = {
				toughness = {
					format_type = "number",
					prefix = "+",
					value = talent_settings.cryptic_ammo_aura.toughness,
				},
				ammo = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_ammo_aura.ammo_reserve_capacity,
				},
			},
		},
		cryptic_dissector = {
			description = "loc_talent_cryptic_dissector_desc",
			display_name = "loc_talent_cryptic_dissector",
			large_icon = "content/ui/textures/icons/talents/cryptic/cryptic_dissector",
			name = "cryptic_dissector",
			passive = {
				buff_template_name = "cryptic_dissector",
				identifier = "cryptic_dissector",
			},
			format_values = {
				max_stacks = {
					format_type = "number",
					value = talent_settings.dissector.max_stacks,
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_dissector",
				},
				damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.dissector.damage,
				},
				tdr = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.dissector.toughness_damage_taken_multiplier,
				},
				removed_stacks = {
					format_type = "number",
					value = talent_settings.dissector.stacks_lost_on_damage_taken,
				},
				icd = {
					format_type = "number",
					value = talent_settings.dissector.stacks_lost_on_damage_taken_cooldown,
				},
				elite_special_stack = {
					format_type = "number",
					value = talent_settings.dissector.stacks_per_elite_or_special_kill,
				},
				toughness = {
					format_type = "percentage",
					value = talent_settings.dissector.toughness_regen_percent_per_elite_or_special_kill,
				},
			},
		},
		cryptic_dissector_max_stacks = {
			description = "loc_talent_cryptic_dissector_max_stacks_desc",
			display_name = "loc_talent_cryptic_dissector_max_stacks",
			large_icon = "content/ui/textures/icons/talents/cryptic/cryptic_dissector_max_stacks",
			name = "cryptic_dissector_max_stacks",
			special_rule = {
				identifier = "cryptic_dissector_extra_max_stacks",
				special_rule_name = special_rules.cryptic_dissector_extra_max_stacks,
			},
			format_values = {
				max_stacks = {
					format_type = "number",
					value = talent_settings.dissector.max_stacks + talent_settings.dissector.extra_max_stacks,
				},
			},
		},
		cryptic_dissector_crit_attack_speed = {
			description = "loc_talent_cryptic_dissector_crit_attack_speed_desc",
			display_name = "loc_talent_cryptic_dissector_finesse",
			large_icon = "content/ui/textures/icons/talents/cryptic/cryptic_dissector_crit_attack_speed",
			name = "cryptic_dissector_crit_attack_speed",
			special_rule = {
				identifier = "cryptic_dissector_gives_crit_and_attack_speed",
				special_rule_name = special_rules.cryptic_dissector_gives_crit_and_attack_speed,
			},
			format_values = {
				crit_chance = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.dissector.critical_strike_chance,
				},
				attack_speed = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.dissector.melee_attack_speed,
				},
			},
		},
		cryptic_dissector_ability_stacks = {
			description = "loc_talent_cryptic_dissector_ability_stacks_desc",
			display_name = "loc_talent_cryptic_dissector_ability",
			large_icon = "content/ui/textures/icons/talents/cryptic/cryptic_dissector_ability_stacks",
			name = "cryptic_dissector_ability_stacks",
			special_rule = {
				identifier = "cryptic_dissector_combat_ability_restores_stacks",
				special_rule_name = special_rules.cryptic_dissector_combat_ability_restores_stacks,
			},
			format_values = {},
		},
		cryptic_dissector_power = {
			description = "loc_talent_cryptic_dissector_power_desc",
			display_name = "loc_talent_cryptic_dissector_power",
			large_icon = "content/ui/textures/icons/talents/cryptic/cryptic_dissector_power",
			name = "cryptic_dissector_power",
			special_rule = {
				identifier = "cryptic_dissector_increased_cooldown_gained_on_elite_or_special_kills",
				special_rule_name = special_rules.cryptic_dissector_increased_cooldown_gained_on_elite_or_special_kills,
			},
			format_values = {
				power = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.dissector.extra_cooldown_on_elite_or_special_kills,
				},
				capacitance_keyword = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_power_keyword",
				},
			},
		},
		cryptic_overload_keystone = {
			description = "loc_talent_cryptic_overload_keystone_coherency_desc",
			display_name = "loc_talent_cryptic_overload_keystone",
			name = "cryptic_overload_keystone",
			passive = {
				buff_template_name = "cryptic_overload_keystone",
				identifier = "cryptic_overload_keystone",
			},
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.overload.damage,
				},
				tdr = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.overload.toughness_damage_taken_multiplier,
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end,
				},
				low_stack = {
					format_type = "number",
					value = talent_settings.overload.num_stacks_per_kill,
				},
				low_stacks = {
					format_type = "number",
					value = talent_settings.overload.num_stacks_per_kill,
				},
				elite_stacks = {
					format_type = "number",
					value = talent_settings.overload.num_stacks_per_elite_or_special_kill,
				},
				max_stacks = {
					format_type = "number",
					value = talent_settings.overload.max_stacks,
				},
				zero = {
					format_type = "number",
					value = 0,
				},
				duration = {
					format_type = "number",
					value = talent_settings.overload.allies_buff_duration,
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_overload_keystone",
				},
			},
		},
		cryptic_overload_keystone_bigger_explosion = {
			description = "loc_talent_cryptic_overload_keystone_bigger_explosion_desc",
			display_name = "loc_talent_cryptic_overload_keystone_bigger_explosion",
			name = "cryptic_overload_keystone_bigger_explosion",
			special_rule = {
				identifier = "cryptic_overload_keystone_aoe_debuff",
				special_rule_name = special_rules.cryptic_overload_keystone_aoe_debuff,
			},
			format_values = {
				damage_taken = {
					format_type = "percentage",
					value = talent_settings.overload.aoe_damage_taken_multiplier_debuff,
					value_manipulation = function (value)
						return math_round((value - 1) * 100)
					end,
				},
				duration = {
					format_type = "number",
					value = talent_settings.overload.aoe_damage_taken_multiplier_debuff_duration,
				},
			},
		},
		cryptic_overload_keystone_toughness_stamina = {
			description = "loc_talent_cryptic_overload_keystone_toughness_stamina_desc",
			display_name = "loc_talent_cryptic_overload_keystone_toughness_stamina",
			name = "cryptic_overload_keystone_toughness_stamina",
			special_rule = {
				identifier = "cryptic_overload_keystone_explosion_restores_toughness_and_stamina",
				special_rule_name = special_rules.cryptic_overload_keystone_explosion_restores_toughness_and_stamina,
			},
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings.overload.toughness_percent_restored,
				},
				stamina = {
					format_type = "percentage",
					value = talent_settings.overload.stamina_percent_restored,
				},
			},
		},
		cryptic_overload_keystone_permastack = {
			description = "loc_talent_cryptic_overload_keystone_permastack_desc",
			display_name = "loc_talent_cryptic_overload_keystone_permastack",
			name = "cryptic_overload_keystone_permastack",
			special_rule = {
				identifier = "cryptic_overload_keystone_gives_permanent_boosts",
				special_rule_name = special_rules.cryptic_overload_keystone_gives_permanent_boosts,
			},
			format_values = {
				first_threshold = {
					format_type = "number",
					value = talent_settings.overload.permanent_buffs_to_give_per_trigger_count[1].num_triggers_needed,
				},
				second_threshold = {
					format_type = "number",
					value = talent_settings.overload.permanent_buffs_to_give_per_trigger_count[2].num_triggers_needed,
				},
				third_threshold = {
					format_type = "number",
					value = talent_settings.overload.permanent_buffs_to_give_per_trigger_count[3].num_triggers_needed,
				},
				damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.overload.permanent_damage,
				},
				tdr = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.overload.permanent_toughness_damage_taken_multiplier,
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end,
				},
				power = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.overload.permanent_combat_ability_cooldown_regen_modifier,
				},
				capacitance_keyword = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_power_keyword",
				},
				power_keyword = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_power_keyword",
				},
			},
		},
		cryptic_overload_keystone_abilities = {
			description = "loc_talent_cryptic_overload_keystone_abilities_desc",
			display_name = "loc_talent_cryptic_overload_keystone_abilities",
			name = "cryptic_overload_keystone_abilities",
			special_rule = {
				identifier = "cryptic_overload_keystone_gain_stacks_per_combat_ability_charge_used",
				special_rule_name = special_rules.cryptic_overload_keystone_gain_stacks_per_combat_ability_charge_used,
			},
			format_values = {
				stacks = {
					format_type = "number",
					value = talent_settings.overload.num_stacks_gained_per_combat_ability_charge,
				},
				overload = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_overload_keystone",
				},
			},
		},
		cryptic_redline = {
			description = "loc_talent_cryptic_redline_charge_stacking_clarified_desc",
			display_name = "loc_talent_cryptic_power_generation",
			large_icon = "content/ui/textures/icons/talents/cryptic/cryptic_redline",
			name = "cryptic_redline",
			passive = {
				buff_template_name = "cryptic_redline",
				identifier = "cryptic_redline",
			},
			format_values = {
				tdr = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.redline.toughness_damage_taken_multiplier_step,
				},
				capacitance = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.redline.combat_ability_cooldown_regen_modifier,
				},
				capacitance_keyword = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_power_keyword",
				},
				duration = {
					format_type = "number",
					value = talent_settings.redline.duration,
				},
				max_stacks = {
					format_type = "number",
					value = talent_settings.redline.max_stacks,
				},
				max_charges = {
					format_type = "number",
					prefix = "+",
					value = talent_settings.redline.ability_extra_charges,
				},
			},
		},
		cryptic_redline_strength = {
			description = "loc_talent_cryptic_redline_strength_clarified_desc",
			display_name = "loc_talent_cryptic_power_generation_toughness",
			large_icon = "content/ui/textures/icons/talents/cryptic/cryptic_redline_strength",
			name = "cryptic_redline_strength",
			passive = {
				buff_template_name = "cryptic_redline_strength",
				identifier = "cryptic_redline_strength",
			},
			format_values = {
				strength = {
					format_type = "percentage",
					value = talent_settings.redline.cryptic_redline_strength.power_level_modifier_per_stack,
				},
				duration = {
					format_type = "number",
					value = talent_settings.redline.cryptic_redline_strength.duration,
				},
			},
		},
		cryptic_redline_extra_max_stacks = {
			description = "loc_talent_cryptic_redline_stacks_clarified_desc",
			display_name = "loc_talent_cryptic_power_generation_capacitance_for_charge",
			large_icon = "content/ui/textures/icons/talents/cryptic/cryptic_redline_extra_max_stacks",
			name = "cryptic_redline_extra_max_stacks",
			passive = {
				buff_template_name = "cryptic_redline_extra_max_stacks",
				identifier = "cryptic_redline_extra_max_stacks",
			},
			special_rule = {
				identifier = "cryptic_redline_has_extra_max_stacks",
				special_rule_name = special_rules.cryptic_redline_has_extra_max_stacks,
			},
			format_values = {
				charges = {
					format_type = "number",
					prefix = "+",
					value = talent_settings.redline.cryptic_redline_extra_max_stacks.ability_extra_charges,
				},
				redline_stack = {
					format_type = "number",
					prefix = "+",
					value = talent_settings.redline.cryptic_redline_extra_max_stacks.extra_redline_max_stacks,
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_power_generation",
				},
			},
		},
		cryptic_redline_toughness = {
			description = "loc_talent_cryptic_redline_toughness_clarified_desc",
			display_name = "loc_talent_cryptic_power_generation_one_more_charge",
			large_icon = "content/ui/textures/icons/talents/cryptic/cryptic_redline_toughness",
			name = "cryptic_redline_toughness",
			passive = {
				buff_template_name = "cryptic_redline_toughness",
				identifier = "cryptic_redline_toughness",
			},
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings.redline.cryptic_redline_toughness.toughness_restored,
				},
				duration = {
					format_type = "number",
					value = talent_settings.redline.cryptic_redline_toughness.duration,
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_power_generation",
				},
			},
		},
		cryptic_redline_rending = {
			description = "loc_talent_cryptic_redline_rending_clarified_desc",
			display_name = "loc_talent_cryptic_power_generation_capacitance_bonuses",
			large_icon = "content/ui/textures/icons/talents/cryptic/cryptic_redline_rending",
			name = "cryptic_redline_rending",
			special_rule = {
				identifier = "cryptic_redline_gives_rending_while_above_stacks",
				special_rule_name = special_rules.cryptic_redline_gives_rending_while_above_stacks,
			},
			format_values = {
				rending = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.redline.cryptic_redline_rending.rending_multiplier,
				},
				stacks = {
					format_type = "number",
					value = talent_settings.redline.cryptic_redline_rending.num_stacks_needed,
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_power_generation",
				},
			},
		},
		cryptic_passive_cooldown_regen = {
			description = "loc_talent_cryptic_passive_cooldown_regen_desc",
			display_name = "loc_talent_cryptic_passive_cooldown_regen",
			hud_icon = "content/ui/materials/icons/abilities/default",
			name = "cryptic_passive_cooldown_regen",
			passive = {
				buff_template_name = "cryptic_passive_cooldown_regen",
				identifier = "cryptic_passive_cooldown_regen",
			},
			format_values = {
				power = {
					format_type = "percentage",
					value = talent_settings.cryptic_passive_cooldown_regen.cooldown_percent_regen_per_second,
				},
				num_base_charges = {
					format_type = "number",
					value = talent_settings.cryptic_passive_cooldown_regen.base_charges,
				},
				min_charge = {
					format_type = "number",
					value = talent_settings.cryptic_passive_cooldown_regen.min_charge,
				},
				max_charge = {
					format_type = "number",
					value = talent_settings.cryptic_passive_cooldown_regen.max_charge,
				},
				max_power = {
					format_type = "percentage",
					value = talent_settings.cryptic_passive_cooldown_regen.max_power,
				},
				gained_charges = {
					format_type = "number",
					value = talent_settings.cryptic_passive_cooldown_regen.charge_gain,
				},
				elite_power = {
					format_type = "percentage",
					value = talent_settings.combat_ability_cooldown_recharge_on_kill.cooldown_replenish_elite_or_special,
				},
				kill_power = {
					format_type = "percentage",
					value = talent_settings.combat_ability_cooldown_recharge_on_kill.cooldown_replenish_base,
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_passive_cooldown_regen",
				},
				capacitance_keyword = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_power_keyword",
				},
				power_keyword = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_power_keyword",
				},
			},
		},
		cryptic_crits_grant_power = {
			description = "loc_talent_cryptic_crits_grant_power_desc",
			display_name = "loc_talent_cryptic_crits_grant_power",
			name = "cryptic_crits_grant_power",
			passive = {
				buff_template_name = "cryptic_crits_grant_power",
				identifier = "cryptic_crits_grant_power",
			},
			format_values = {
				power = {
					format_type = "percentage",
					value = talent_settings.cryptic_crits_grant_power.cooldown_regen,
				},
				duration = {
					format_type = "number",
					value = talent_settings.cryptic_crits_grant_power.cooldown_regen_time,
				},
				capacitance_keyword = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_power_keyword",
				},
			},
		},
		cryptic_weakspot_kills_grant_power = {
			description = "loc_talent_cryptic_weakspot_kills_grant_power_desc",
			display_name = "loc_talent_cryptic_weakspot_kills_grant_power",
			name = "cryptic_weakspot_kills_grant_power",
			passive = {
				buff_template_name = "cryptic_weakspot_kills_grant_power",
				identifier = "cryptic_weakspot_kills_grant_power",
			},
			format_values = {
				power = {
					format_type = "percentage",
					value = talent_settings.cryptic_weakspot_kills_grant_power.cooldown_replenished_on_proc,
				},
				capacitance_keyword = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_power_keyword",
				},
			},
		},
		cryptic_multi_hits_grant_power = {
			description = "loc_talent_cryptic_multi_hits_grant_power_desc",
			display_name = "loc_talent_cryptic_multi_hits_grant_power",
			name = "cryptic_multi_hits_grant_power",
			passive = {
				buff_template_name = "cryptic_multi_hits_grant_power",
				identifier = "cryptic_multi_hits_grant_power",
			},
			format_values = {
				power = {
					format_type = "percentage",
					value = talent_settings.cryptic_multi_hits_grant_power.cooldown_replenished_on_proc,
				},
				number = {
					format_type = "number",
					value = talent_settings.cryptic_multi_hits_grant_power.num_hits,
				},
				capacitance_keyword = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_power_keyword",
				},
			},
		},
		cryptic_increased_passive_cooldown_regen = {
			description = "loc_talent_cryptic_increased_passive_cooldown_regen_desc",
			display_name = "loc_talent_cryptic_increased_passive_cooldown_regen",
			name = "cryptic_increased_passive_cooldown_regen",
			passive = {
				buff_template_name = "cryptic_increased_passive_cooldown_regen",
				identifier = "cryptic_increased_passive_cooldown_regen",
			},
			format_values = {
				power = {
					format_type = "percentage",
					value = talent_settings.cryptic_increased_passive_cooldown_regen.cooldown_percent_regen_per_second,
				},
				capacitance_keyword = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_power_keyword",
				},
				power_keyword = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_power_keyword",
				},
			},
		},
		cryptic_multi_hits_restore_toughness = {
			description = "loc_talent_cryptic_multi_hits_restore_toughness_desc",
			display_name = "loc_talent_cryptic_multi_hits_restore_toughness",
			name = "cryptic_multi_hits_restore_toughness",
			passive = {
				buff_template_name = "cryptic_multi_hits_restore_toughness",
				identifier = "cryptic_multi_hits_restore_toughness",
			},
			format_values = {
				number = {
					format_type = "number",
					value = talent_settings.cryptic_multi_hits_restore_toughness.num_hits,
				},
				toughness = {
					format_type = "percentage",
					value = talent_settings.cryptic_multi_hits_restore_toughness.toughness_regen,
				},
				duration = {
					format_type = "number",
					value = talent_settings.cryptic_multi_hits_restore_toughness.toughness_regen_time,
				},
			},
		},
		cryptic_weakspot_kills_restore_toughness = {
			description = "loc_talent_cryptic_weakspot_kills_restore_toughness_desc",
			display_name = "loc_talent_cryptic_weakspot_kills_restore_toughness",
			name = "cryptic_weakspot_kills_restore_toughness",
			passive = {
				buff_template_name = "cryptic_weakspot_kills_restore_toughness",
				identifier = "cryptic_weakspot_kills_restore_toughness",
			},
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings.cryptic_weakspot_kills_restore_toughness.toughness_restored,
				},
			},
		},
		cryptic_crits_grant_tdr = {
			description = "loc_talent_cryptic_crits_grant_tdr_desc",
			display_name = "loc_talent_cryptic_crits_grant_tdr",
			name = "cryptic_crits_grant_tdr",
			passive = {
				buff_template_name = "cryptic_crits_grant_tdr",
				identifier = "cryptic_crits_grant_tdr",
			},
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings.cryptic_crits_grant_tdr.toughness_restored,
				},
				tdr = {
					format_type = "percentage",
					prefix = "+",
					value = math.abs(1 - talent_settings.cryptic_crits_grant_tdr.toughness_damage_taken_multiplier),
				},
				duration = {
					format_type = "number",
					value = talent_settings.cryptic_crits_grant_tdr.duration,
				},
			},
		},
		cryptic_ammo_reserve = {
			description = "loc_talent_cryptic_ammo_reserve_desc",
			display_name = "loc_talent_cryptic_ammo_reserve",
			name = "cryptic_ammo_reserve",
			passive = {
				buff_template_name = "cryptic_ammo_reserve",
				identifier = "cryptic_ammo_reserve",
			},
			format_values = {
				ammo = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_ammo_reserve.ammo_reserve_capacity,
				},
			},
		},
		cryptic_ranged_kills_tdr = {
			description = "loc_talent_cryptic_ranged_kills_tdr_desc",
			display_name = "loc_talent_cryptic_ranged_kills_tdr",
			name = "cryptic_ranged_kills_tdr",
			passive = {
				buff_template_name = "cryptic_ranged_kills_tdr",
				identifier = "cryptic_ranged_kills_tdr",
			},
			format_values = {
				tdr = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_ranged_kills_tdr.toughness_damage_taken_multiplier_step,
				},
				stacks = {
					format_type = "number",
					value = talent_settings.cryptic_ranged_kills_tdr.max_stacks,
				},
				duration = {
					format_type = "number",
					value = talent_settings.cryptic_ranged_kills_tdr.duration,
				},
			},
		},
		cryptic_elite_kills_damage = {
			description = "loc_talent_cryptic_elite_kills_damage_desc",
			display_name = "loc_talent_cryptic_elite_kills_damage",
			name = "cryptic_elite_kills_damage",
			passive = {
				buff_template_name = "cryptic_elite_kills_damage",
				identifier = "cryptic_elite_kills_damage",
			},
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_elite_kills_damage.damage,
				},
				stacks = {
					format_type = "number",
					value = talent_settings.cryptic_elite_kills_damage.max_stacks,
				},
				duration = {
					format_type = "number",
					value = talent_settings.cryptic_elite_kills_damage.duration,
				},
			},
		},
		cryptic_weakspot_damage = {
			description = "loc_talent_cryptic_weakspot_damage_desc",
			display_name = "loc_talent_cryptic_weakspot_damage",
			name = "cryptic_weakspot_damage",
			passive = {
				buff_template_name = "cryptic_weakspot_damage",
				identifier = "cryptic_weakspot_damage",
			},
			format_values = {
				weakspot_damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_weakspot_damage.weakspot_damage,
				},
			},
		},
		cryptic_elite_kills_toughness = {
			description = "loc_talent_cryptic_elite_kills_toughness_desc",
			display_name = "loc_talent_cryptic_elite_kills_toughness",
			name = "cryptic_elite_kills_toughness",
			passive = {
				buff_template_name = "cryptic_elite_kills_toughness",
				identifier = "cryptic_elite_kills_toughness",
			},
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings.cryptic_elite_kills_toughness.toughness_regen,
				},
				duration = {
					format_type = "number",
					value = talent_settings.cryptic_elite_kills_toughness.toughness_regen_time,
				},
			},
		},
		cryptic_electrocution_defense = {
			description = "loc_talent_cryptic_electrocution_defense_desc",
			display_name = "loc_talent_cryptic_electrocution_defense",
			name = "cryptic_electrocution_defense",
			passive = {
				buff_template_name = "cryptic_electrocution_defense",
				identifier = "cryptic_electrocution_defense",
			},
			format_values = {
				range = {
					format_type = "number",
					value = talent_settings.cryptic_electrocution_defense.electrocution_radius,
				},
				cooldown = {
					format_type = "number",
					value = talent_settings.cryptic_electrocution_defense.cooldown_duration,
				},
			},
		},
		cryptic_mobile_defense = {
			description = "loc_talent_cryptic_mobile_defense_desc",
			display_name = "loc_talent_cryptic_mobile_defense",
			name = "cryptic_mobile_defense",
			passive = {
				buff_template_name = "cryptic_mobile_defense",
				identifier = "cryptic_mobile_defense",
			},
			format_values = {
				damage_resistance = {
					format_type = "percentage",
					value = math.abs(talent_settings.cryptic_mobile_defense.damage_taken_multiplier),
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end,
				},
			},
		},
		cryptic_stun_suppression_immune = {
			description = "loc_talent_cryptic_stun_suppression_immune_desc",
			display_name = "loc_talent_cryptic_stun_suppression_immune",
			name = "cryptic_stun_suppression_immune",
			passive = {
				buff_template_name = "cryptic_stun_suppression_immune",
				identifier = "cryptic_stun_suppression_immune",
			},
			format_values = {
				duration = {
					format_type = "number",
					value = talent_settings.cryptic_stun_suppression_immune.duration,
				},
			},
		},
		cryptic_stacking_tdr = {
			description = "loc_talent_cryptic_stacking_tdr_desc",
			display_name = "loc_talent_cryptic_stacking_tdr",
			name = "cryptic_stacking_tdr",
			passive = {
				buff_template_name = "cryptic_stacking_tdr",
				identifier = "cryptic_stacking_tdr",
			},
			format_values = {
				tdr = {
					format_type = "percentage",
					prefix = "+",
					value = math.abs(talent_settings.cryptic_stacking_tdr.toughness_damage_taken_multiplier),
				},
				duration = {
					format_type = "number",
					value = talent_settings.cryptic_stacking_tdr.duration,
				},
				stacks = {
					format_type = "number",
					value = talent_settings.cryptic_stacking_tdr.max_stacks,
				},
			},
		},
		cryptic_successful_dodge_stamina = {
			description = "loc_talent_cryptic_successful_dodge_stamina_desc",
			display_name = "loc_talent_cryptic_successful_dodge_stamina",
			name = "cryptic_successful_dodge_stamina",
			passive = {
				buff_template_name = "cryptic_successful_dodge_stamina",
				identifier = "cryptic_successful_dodge_stamina",
			},
			format_values = {
				stamina = {
					format_type = "percentage",
					value = talent_settings.cryptic_successful_dodge_stamina.stamina_replenished_percent,
				},
			},
		},
		cryptic_pushing_grants_cleave = {
			description = "loc_talent_cryptic_pushing_grants_cleave_alt_desc",
			display_name = "loc_talent_cryptic_pushing_grants_cleave",
			name = "cryptic_pushing_grants_cleave",
			passive = {
				buff_template_name = "cryptic_pushing_grants_cleave",
				identifier = "cryptic_pushing_grants_cleave",
			},
			format_values = {
				cleave = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_pushing_grants_cleave.max_melee_hit_mass_attack_modifier,
				},
				duration = {
					format_type = "number",
					value = talent_settings.cryptic_pushing_grants_cleave.duration,
				},
			},
		},
		cryptic_melee_crits_electrocute_first = {
			description = "loc_talent_cryptic_melee_crits_electrocute_first_desc",
			display_name = "loc_talent_cryptic_melee_crits_electrocute_first",
			name = "cryptic_melee_crits_electrocute_first",
			passive = {
				buff_template_name = "cryptic_melee_crits_electrocute_first",
				identifier = "cryptic_melee_crits_electrocute_first",
			},
			format_values = {},
		},
		cryptic_cleave_and_impact = {
			description = "loc_talent_cryptic_melee_cleave_and_impact_desc",
			display_name = "loc_talent_cryptic_cleave_and_impact",
			name = "cryptic_cleave_and_impact",
			passive = {
				identifier = {
					"cryptic_cleave_while_above_stamina_threshold",
					"cryptic_impact_while_below_stamina_threshold",
				},
				buff_template_name = {
					"cryptic_cleave_while_above_stamina_threshold",
					"cryptic_impact_while_below_stamina_threshold",
				},
			},
			format_values = {
				cleave = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_cleave_and_impact.max_hit_mass_attack_modifier,
				},
				toughness = {
					format_type = "percentage",
					value = talent_settings.cryptic_cleave_and_impact.stamina_threshold,
				},
				impact = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_cleave_and_impact.impact_modifier,
				},
			},
		},
		cryptic_electrocution_applies_brittleness = {
			description = "loc_talent_cryptic_electrocution_applies_brittleness_desc",
			display_name = "loc_talent_cryptic_electrocution_applies_brittleness",
			name = "cryptic_electrocution_applies_brittleness",
			passive = {
				buff_template_name = "cryptic_electrocution_applies_brittleness",
				identifier = "cryptic_electrocution_applies_brittleness",
			},
			format_values = {
				stacks = {
					format_type = "number",
					value = talent_settings.cryptic_electrocution_applies_brittleness.stacks,
				},
			},
		},
		cryptic_coherency_toughness_on_ability = {
			description = "loc_talent_cryptic_coherency_toughness_on_ability_desc",
			display_name = "loc_talent_cryptic_coherency_toughness_on_ability",
			name = "cryptic_coherency_toughness_on_ability",
			passive = {
				buff_template_name = "cryptic_coherency_toughness_on_ability",
				identifier = "cryptic_coherency_toughness_on_ability",
			},
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings.cryptic_coherency_toughness_on_ability.toughness_replenish_percent,
				},
			},
		},
		cryptic_hybrid_damage = {
			description = "loc_talent_cryptic_hybrid_damage_desc",
			display_name = "loc_talent_cryptic_hybrid_damage",
			name = "cryptic_hybrid_damage",
			passive = {
				buff_template_name = "cryptic_hybrid_damage",
				identifier = "cryptic_hybrid_damage",
			},
			format_values = {
				duration = {
					format_type = "number",
					value = talent_settings.cryptic_hybrid_damage.ranged_duration,
				},
				ranged_damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_hybrid_damage.ranged_damage,
				},
				stacks = {
					format_type = "number",
					value = talent_settings.cryptic_hybrid_damage.ranged_max_stacks,
				},
				melee_damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_hybrid_damage.melee_damage,
				},
				duration_two = {
					format_type = "number",
					value = talent_settings.cryptic_hybrid_damage.melee_duration,
				},
				max_stacks = {
					format_type = "number",
					value = talent_settings.cryptic_hybrid_damage.melee_max_stacks,
				},
			},
		},
		cryptic_electrocution_toughness = {
			description = "loc_talent_cryptic_electrocution_toughness_desc",
			display_name = "loc_talent_cryptic_electrocution_toughness",
			name = "cryptic_electrocution_toughness",
			passive = {
				buff_template_name = "cryptic_electrocution_toughness",
				identifier = "cryptic_electrocution_toughness",
			},
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings.cryptic_electrocution_toughness.toughness_regen,
				},
				duration = {
					format_type = "number",
					value = talent_settings.cryptic_electrocution_toughness.toughness_regen_time,
				},
			},
		},
		cryptic_afflicted_increased_damage = {
			description = "loc_talent_cryptic_afflicted_increased_damage_desc",
			display_name = "loc_talent_cryptic_afflicted_increased_damage",
			name = "cryptic_afflicted_increased_damage",
			passive = {
				buff_template_name = "cryptic_afflicted_increased_damage",
				identifier = "cryptic_afflicted_increased_damage",
			},
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_afflicted_increased_damage.damage,
				},
				duration = {
					format_type = "number",
					value = talent_settings.cryptic_afflicted_increased_damage.duration,
				},
			},
		},
		cryptic_stacking_melee_damage = {
			description = "loc_talent_cryptic_stacking_melee_damage_desc",
			display_name = "loc_talent_cryptic_stacking_melee_damage",
			name = "cryptic_stacking_melee_damage",
			passive = {
				buff_template_name = "cryptic_stacking_melee_damage",
				identifier = "cryptic_stacking_melee_damage",
			},
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_stacking_melee_damage.damage,
				},
				duration = {
					format_type = "number",
					value = talent_settings.cryptic_stacking_melee_damage.duration,
				},
				stacks = {
					format_type = "number",
					value = talent_settings.cryptic_stacking_melee_damage.max_stacks,
				},
			},
		},
		cryptic_shared_toughness = {
			description = "loc_talent_cryptic_shared_toughness_desc",
			display_name = "loc_talent_cryptic_shared_toughness",
			name = "cryptic_shared_toughness",
			passive = {
				buff_template_name = "cryptic_shared_toughness",
				identifier = "cryptic_shared_toughness",
			},
			format_values = {
				toughness_share = {
					format_type = "percentage",
					value = talent_settings.cryptic_shared_toughness.toughness_replenish_percent,
				},
			},
		},
		cryptic_stamina_increases_damage = {
			description = "loc_talent_cryptic_stamina_increases_damage_desc",
			display_name = "loc_talent_cryptic_stamina_increases_damage",
			name = "cryptic_stamina_increases_damage",
			passive = {
				buff_template_name = "cryptic_stamina_increases_damage",
				identifier = "cryptic_stamina_increases_damage",
			},
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_stamina_increases_damage.damage,
				},
				stamina = {
					format_type = "number",
					value = talent_settings.cryptic_stamina_increases_damage.stamina_consumed_to_proc,
				},
				duration = {
					format_type = "number",
					value = talent_settings.cryptic_stamina_increases_damage.duration,
				},
			},
		},
		cryptic_stacking_ranged_damage = {
			description = "loc_talent_cryptic_stacking_ranged_damage_desc",
			display_name = "loc_talent_cryptic_stacking_ranged_damage",
			name = "cryptic_stacking_ranged_damage",
			passive = {
				buff_template_name = "cryptic_stacking_ranged_damage",
				identifier = "cryptic_stacking_ranged_damage",
			},
			format_values = {
				duration = {
					format_type = "number",
					value = talent_settings.cryptic_stacking_ranged_damage.time_since_last_shot_before_stacking,
				},
				ranged_damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_stacking_ranged_damage.ranged_damage_per_stack,
				},
				stacks = {
					format_type = "number",
					value = talent_settings.cryptic_stacking_ranged_damage.max_stacks,
				},
			},
		},
		cryptic_passive_ammo_replenishment = {
			description = "loc_talent_cryptic_passive_ammo_replenishment_desc",
			display_name = "loc_talent_cryptic_passive_ammo_replenishment",
			name = "cryptic_passive_ammo_replenishment",
			passive = {
				buff_template_name = "cryptic_passive_ammo_replenishment",
				identifier = "cryptic_passive_ammo_replenishment",
			},
			format_values = {
				interval = {
					format_type = "number",
					value = talent_settings.cryptic_passive_ammo_replenishment.interval,
				},
				percent = {
					format_type = "percentage",
					value = talent_settings.cryptic_passive_ammo_replenishment.percent_ammo_replenish_per_tick,
				},
			},
		},
		cryptic_better_heavies = {
			description = "loc_talent_cryptic_better_heavies_desc",
			display_name = "loc_talent_cryptic_better_heavies",
			name = "cryptic_better_heavies",
			passive = {
				buff_template_name = "cryptic_better_heavies",
				identifier = "cryptic_better_heavies",
			},
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_better_heavies.melee_heavy_damage,
				},
			},
		},
		cryptic_stun_dr_power = {
			description = "loc_talent_cryptic_stun_dr_power_desc",
			display_name = "loc_talent_cryptic_stun_dr_power",
			name = "cryptic_stun_dr_power",
			passive = {
				buff_template_name = "cryptic_stun_dr_power",
				identifier = "cryptic_stun_dr_power",
			},
			format_values = {
				capacitance_keyword = {
					format_type = "loc_string",
					value = "loc_talent_cryptic_power_keyword",
				},
				damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_stun_dr_power.damage_taken_multiplier,
					value_manipulation = function (value)
						return math_round(100 * (1 - value))
					end,
				},
				power = {
					format_type = "percentage",
					value = talent_settings.cryptic_stun_dr_power.percent_cooldown_spent_per_melee_hit_taken,
				},
			},
		},
		cryptic_revive_speed_and_dr = {
			description = "loc_talent_cryptic_revive_speed_and_dr_desc",
			display_name = "loc_talent_cryptic_revive_speed_and_dr",
			name = "cryptic_revive_speed_and_dr",
			passive = {
				buff_template_name = "cryptic_revive_speed_and_dr",
				identifier = "cryptic_revive_speed_and_dr",
			},
			format_values = {
				damage_reduction = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_revive_speed_and_dr.damage_taken_multiplier,
					value_manipulation = function (value)
						return math_round(100 * (1 - value))
					end,
				},
				revive_speed = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_revive_speed_and_dr.revive_speed_modifier,
				},
			},
		},
		cryptic_corruption_resistance_doom = {
			description = "loc_talent_cryptic_corruption_resistance_doom_desc",
			display_name = "loc_talent_cryptic_corruption_resistance_doom",
			name = "cryptic_corruption_resistance_doom",
			passive = {
				buff_template_name = "cryptic_corruption_resistance_doom",
				identifier = "cryptic_corruption_resistance_doom",
			},
			format_values = {
				corruption_resistance = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_corruption_resistance_doom.corruption_taken_multiplier,
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end,
				},
				interval = {
					format_type = "number",
					value = talent_settings.cryptic_corruption_resistance_doom.interval,
				},
				corruption_damage_flat = {
					format_type = "number",
					value = talent_settings.cryptic_corruption_resistance_doom.corruption_damage_taken,
				},
			},
		},
		cryptic_ranged_stacking_toughness = {
			description = "loc_talent_cryptic_ranged_stacking_toughness_desc",
			display_name = "loc_talent_cryptic_ranged_stacking_toughness",
			name = "cryptic_ranged_stacking_toughness",
			passive = {
				buff_template_name = "cryptic_ranged_stacking_toughness",
				identifier = "cryptic_ranged_stacking_toughness",
			},
			format_values = {
				toughness = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_ranged_stacking_toughness.toughness_regen_per_second_per_stack,
				},
				max_stacks = {
					format_type = "number",
					value = talent_settings.cryptic_ranged_stacking_toughness.max_stacks,
				},
				duration = {
					format_type = "number",
					value = talent_settings.cryptic_ranged_stacking_toughness.duration,
				},
			},
		},
		cryptic_toughness_on_damage_taken = {
			description = "loc_talent_cryptic_toughness_on_damage_taken_desc",
			display_name = "loc_talent_cryptic_toughness_on_damage_taken",
			name = "cryptic_toughness_on_damage_taken",
			passive = {
				buff_template_name = "cryptic_toughness_on_damage_taken",
				identifier = "cryptic_toughness_on_damage_taken",
			},
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings.cryptic_toughness_on_damage_taken.toughness_regen,
				},
				cooldown = {
					format_type = "number",
					value = talent_settings.cryptic_toughness_on_damage_taken.cooldown,
				},
				duration = {
					format_type = "number",
					value = talent_settings.cryptic_toughness_on_damage_taken.toughness_regen_time,
				},
			},
		},
		cryptic_ranged_vs_bfg = {
			description = "loc_talent_cryptic_ranged_vs_bfg_desc",
			display_name = "loc_talent_cryptic_ranged_vs_bfg",
			name = "cryptic_ranged_vs_bfg",
			passive = {
				buff_template_name = "cryptic_ranged_vs_bfg",
				identifier = "cryptic_ranged_vs_bfg",
			},
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_ranged_vs_bfg.ranged_damage_vs_captains,
				},
			},
		},
		cryptic_crit_chance_based_on_charge = {
			description = "loc_talent_cryptic_crit_chance_based_on_charge_zero_desc",
			display_name = "loc_talent_cryptic_crit_chance_based_on_charge",
			name = "cryptic_crit_chance_based_on_charge",
			passive = {
				buff_template_name = "cryptic_crit_chance_based_on_charge",
				identifier = "cryptic_crit_chance_based_on_charge",
			},
			format_values = {
				crit_chance_high = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_crit_chance_based_on_charge.extra_critical_strike_chance + talent_settings.cryptic_crit_chance_based_on_charge.critical_strike_chance,
				},
				crit_chance_low = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_crit_chance_based_on_charge.critical_strike_chance,
				},
				low_charges = {
					format_type = "number",
					value = talent_settings.cryptic_crit_chance_based_on_charge.low_charges,
				},
			},
		},
		cryptic_melee_attacks_give_melee_attack_speed = {
			description = "loc_talent_cryptic_melee_attacks_give_melee_attack_speed_desc",
			display_name = "loc_talent_cryptic_melee_attacks_give_melee_attack_speed",
			name = "cryptic_melee_attacks_give_melee_attack_speed",
			passive = {
				buff_template_name = "cryptic_melee_attacks_give_melee_attack_speed",
				identifier = "cryptic_melee_attacks_give_melee_attack_speed",
			},
			format_values = {
				melee_attack_speed = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_melee_attacks_give_melee_attack_speed.melee_attack_speed,
				},
				stacks = {
					format_type = "number",
					value = talent_settings.cryptic_melee_attacks_give_melee_attack_speed.max_stacks,
				},
				duration = {
					format_type = "number",
					value = talent_settings.cryptic_melee_attacks_give_melee_attack_speed.duration,
				},
			},
		},
		cryptic_tdr_based_on_charge = {
			description = "loc_talent_cryptic_tdr_based_on_charge_base_desc",
			display_name = "loc_talent_cryptic_tdr_based_on_charge",
			name = "cryptic_tdr_based_on_charge",
			passive = {
				buff_template_name = "cryptic_tdr_based_on_charge",
				identifier = "cryptic_tdr_based_on_charge",
			},
			format_values = {
				tdr = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_tdr_based_on_charge.toughness_damage_taken_multiplier_base,
				},
				tdr_per_charge = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_tdr_based_on_charge.toughness_damage_taken_multiplier_per_charge,
				},
			},
		},
		cryptic_toughness_per_charge = {
			description = "loc_talent_cryptic_toughness_per_charge_desc",
			display_name = "loc_talent_cryptic_toughness_per_charge",
			name = "cryptic_toughness_per_charge",
			passive = {
				buff_template_name = "cryptic_toughness_per_charge",
				identifier = "cryptic_toughness_per_charge",
			},
			format_values = {
				toughness = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_toughness_per_charge.toughness_regen_per_second,
				},
				toughness_per_charge = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_toughness_per_charge.increased_toughness_regen_per_charge,
				},
			},
		},
		cryptic_no_braced_movement_penalty = {
			description = "loc_talent_cryptic_no_braced_movement_penalty_desc",
			display_name = "loc_talent_cryptic_no_braced_movement_penalty",
			name = "cryptic_no_braced_movement_penalty",
			passive = {
				buff_template_name = "cryptic_no_braced_movement_penalty",
				identifier = "cryptic_no_braced_movement_penalty",
			},
			format_values = {
				spread = {
					format_type = "percentage",
					value = talent_settings.cryptic_no_braced_movement_penalty.spread_modifier,
				},
				movement_speed_modifier = {
					format_type = "percentage",
					prefix = "-",
					value = talent_settings.cryptic_no_braced_movement_penalty.alternate_fire_movement_speed_reduction_modifier,
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end,
				},
			},
		},
		cryptic_damage_on_ability = {
			description = "loc_talent_cryptic_damage_on_ability_desc",
			display_name = "loc_talent_cryptic_damage_on_ability",
			name = "cryptic_damage_on_ability",
			passive = {
				buff_template_name = "cryptic_damage_on_ability",
				identifier = "cryptic_damage_on_ability",
			},
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_damage_on_ability.damage,
				},
				duration = {
					format_type = "number",
					value = talent_settings.cryptic_damage_on_ability.duration,
				},
			},
		},
		cryptic_dr_on_toughness_break = {
			description = "loc_talent_cryptic_dr_on_toughness_break_desc",
			display_name = "loc_talent_cryptic_dr_on_toughness_break",
			name = "cryptic_dr_on_toughness_break",
			passive = {
				buff_template_name = "cryptic_dr_on_toughness_break",
				identifier = "cryptic_dr_on_toughness_break",
			},
			format_values = {
				damage_resistance = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_dr_on_toughness_break.damage_taken_multiplier,
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end,
				},
				duration = {
					format_type = "number",
					value = talent_settings.cryptic_dr_on_toughness_break.active_duration,
				},
				cooldown = {
					format_type = "number",
					value = talent_settings.cryptic_dr_on_toughness_break.cooldown_duration,
				},
			},
		},
		cryptic_push_stagger_stamina = {
			description = "loc_talent_cryptic_push_stagger_stamina_desc",
			display_name = "loc_talent_cryptic_push_stagger_stamina",
			name = "cryptic_push_stagger_stamina",
			passive = {
				buff_template_name = "cryptic_push_stagger_stamina",
				identifier = "cryptic_push_stagger_stamina",
			},
			format_values = {
				push_strength = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_push_stagger_stamina.push_impact_modifier,
				},
				stamina = {
					format_type = "percentage",
					value = talent_settings.cryptic_push_stagger_stamina.target_stamina_percent,
				},
			},
		},
		cryptic_specials_marking = {
			description = "loc_talent_cryptic_specials_marking_desc",
			display_name = "loc_talent_cryptic_specials_marking",
			name = "cryptic_specials_marking",
			passive = {
				buff_template_name = "cryptic_specials_marking",
				identifier = "cryptic_specials_marking",
			},
			format_values = {
				range = {
					format_type = "number",
					value = talent_settings.cryptic_specials_marking.outline_range,
				},
			},
		},
		cryptic_electrocution_push = {
			description = "loc_talent_cryptic_electrocution_push_desc",
			display_name = "loc_talent_cryptic_electrocution_push",
			name = "cryptic_electrocution_push",
			passive = {
				buff_template_name = "cryptic_electrocution_push",
				identifier = "cryptic_electrocution_push",
			},
			format_values = {
				cooldown = {
					format_type = "number",
					value = talent_settings.cryptic_electrocution_push.cooldown_duration,
				},
			},
		},
		cryptic_toughness_replenishment_on_kill_bonus = {
			description = "loc_talent_cryptic_toughness_replenishment_on_kill_bonus_desc",
			display_name = "loc_talent_cryptic_toughness_replenishment_on_kill_bonus",
			name = "cryptic_toughness_replenishment_on_kill_bonus",
			passive = {
				buff_template_name = "cryptic_toughness_replenishment_on_kill_bonus",
				identifier = "cryptic_toughness_replenishment_on_kill_bonus",
			},
			format_values = {
				toughness_percent = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_toughness_replenishment_on_kill_bonus.toughness_melee_replenish,
				},
				toughness_percent_improved = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_toughness_replenishment_on_kill_bonus.improved_toughness_melee_replenish,
				},
				zero_charges = {
					format_type = "number",
					value = talent_settings.cryptic_toughness_replenishment_on_kill_bonus.improved_min_charges,
				},
			},
		},
		cryptic_strength_on_charge_gain = {
			description = "loc_talent_cryptic_strength_on_charge_gain_desc",
			display_name = "loc_talent_cryptic_strength_on_charge_gain",
			name = "cryptic_strength_on_charge_gain",
			passive = {
				buff_template_name = "cryptic_strength_on_charge_gain",
				identifier = "cryptic_strength_on_charge_gain",
			},
			format_values = {
				duration = {
					format_type = "number",
					value = talent_settings.cryptic_strength_on_charge_gain.active_duration,
				},
				strength = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_strength_on_charge_gain.power_level_modifier,
				},
			},
		},
		cryptic_disabled_allies_defense = {
			description = "loc_talent_cryptic_disabled_allies_defense_post_boost_desc",
			display_name = "loc_talent_cryptic_disabled_allies_defense",
			name = "cryptic_disabled_allies_defense",
			coherency = {
				buff_template_name = "cryptic_disabled_allies_defense",
				identifier = "cryptic_disabled_allies_defense",
				priority = 2,
			},
			passive = {
				buff_template_name = "cryptic_assisted_allies_defense",
				identifier = "cryptic_assisted_allies_defense",
			},
			format_values = {
				incapacitated_keyword = {
					format_type = "loc_string",
					value = "loc_glossary_term_incapacitated",
				},
				damage_resistance = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_disabled_allies_defense.damage_taken_multiplier,
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end,
				},
				damage_resistance_post = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_disabled_allies_defense.damage_taken_multiplier_post,
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end,
				},
				duration = {
					format_type = "number",
					value = talent_settings.cryptic_disabled_allies_defense.duration,
				},
			},
		},
		cryptic_auto_reload = {
			description = "loc_talent_cryptic_auto_reload_desc",
			display_name = "loc_talent_cryptic_reload_speed_based_on_charge",
			name = "cryptic_auto_reload",
			passive = {
				buff_template_name = "cryptic_auto_reload",
				identifier = "cryptic_auto_reload",
			},
			format_values = {
				duration = {
					format_type = "number",
					value = talent_settings.cryptic_auto_reload.cooldown_duration,
				},
				reload_speed = {
					format_type = "percentage",
					value = talent_settings.cryptic_auto_reload.reload_speed,
				},
				reload_percent = {
					format_type = "percentage",
					value = talent_settings.cryptic_auto_reload.ammo_replenish_percent,
				},
			},
		},
		cryptic_damage_vs_electrocuted_scaling_on_charge = {
			description = "loc_talent_cryptic_damage_vs_electrocuted_scaling_on_charge_desc",
			display_name = "loc_talent_cryptic_damage_vs_electrocuted_based_on_charge",
			name = "cryptic_damage_vs_electrocuted_scaling_on_charge",
			passive = {
				buff_template_name = "cryptic_damage_vs_electrocuted_scaling_on_charge",
				identifier = "cryptic_damage_vs_electrocuted_scaling_on_charge",
			},
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_damage_vs_electrocuted_scaling_on_charge.base_damage_vs_electrocuted,
				},
				more_damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_damage_vs_electrocuted_scaling_on_charge.damage_per_charge,
				},
			},
		},
		cryptic_ally_coherency_defenses = {
			description = "loc_talent_cryptic_ally_coherency_defenses_desc",
			display_name = "loc_talent_cryptic_allies_broken",
			name = "cryptic_ally_coherency_defenses",
			passive = {
				identifier = {
					"cryptic_ally_coherency_defenses_stamina",
					"cryptic_ally_coherency_defenses_toughness",
				},
				buff_template_name = {
					"cryptic_ally_coherency_defenses_stamina",
					"cryptic_ally_coherency_defenses_toughness",
				},
			},
			format_values = {
				stamina_cd = {
					format_type = "number",
					value = talent_settings.cryptic_ally_coherency_defenses.stamina_cooldown_duration,
				},
				stamina = {
					format_type = "percentage",
					value = talent_settings.cryptic_ally_coherency_defenses.stamina_percent_restored,
				},
				toughness_cd = {
					format_type = "number",
					value = talent_settings.cryptic_ally_coherency_defenses.toughness_cooldown_duration,
				},
				toughness = {
					format_type = "percentage",
					value = talent_settings.cryptic_ally_coherency_defenses.toughness_percent_to_regen,
				},
			},
		},
		cryptic_next_hit_all_damage_on_dodge = {
			description = "loc_talent_cryptic_next_attack_all_damage_on_dodge_desc",
			display_name = "loc_talent_cryptic_next_hit_damage_on_dodge",
			name = "cryptic_next_hit_all_damage_on_dodge",
			passive = {
				buff_template_name = "cryptic_next_hit_all_damage_on_dodge",
				identifier = "cryptic_next_hit_all_damage_on_dodge",
			},
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.cryptic_next_hit_all_damage_on_dodge.damage,
				},
			},
		},
	},
}

return archetype_talents
