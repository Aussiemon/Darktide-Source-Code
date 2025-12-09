-- chunkname: @scripts/settings/ability/archetype_talents/talents/broker_talents.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local talent_settings = TalentSettings.broker
local stimm_talent_settings = TalentSettings.broker_stimm
local special_rules = SpecialRulesSettings.special_rules
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local math_round = math.round

math_round = math_round or function (value)
	if value >= 0 then
		return math.floor(value + 0.5)
	else
		return math.ceil(value - 0.5)
	end
end

local archetype_talents = {
	archetype = "broker",
}

archetype_talents.talents = {
	broker_ability_focus = {
		description = "loc_talent_broker_ability_focus_desc",
		display_name = "loc_talent_broker_ability_focus",
		icon = "content/ui/textures/icons/talents/broker/broker_talent_ability_focus",
		name = "",
		format_values = {
			talent_name = {
				format_type = "loc_string",
				value = "loc_talent_broker_ability_focus",
			},
			duration = {
				format_type = "number",
				value = talent_settings.combat_ability.focus.duration,
			},
			sprint_movement_speed = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.combat_ability.focus.sprint_movement_speed,
			},
			cooldown = {
				format_type = "number",
				value = talent_settings.combat_ability.focus.cooldown,
			},
		},
		player_ability = {
			ability_type = "combat_ability",
			ability = PlayerAbilities.broker_ability_focus,
		},
	},
	broker_ability_focus_improved = {
		description = "loc_talent_broker_ability_focus_improved_desc",
		display_name = "loc_talent_broker_ability_focus_improved",
		icon = "content/ui/textures/icons/talents/broker/broker_talent_ability_focus_improved",
		name = "",
		format_values = {
			talent_name = {
				format_type = "loc_string",
				value = "loc_talent_broker_ability_focus_improved",
			},
			duration = {
				format_type = "number",
				value = talent_settings.combat_ability.focus.duration,
			},
			sprint_movement_speed = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.combat_ability.focus.sprint_movement_speed,
			},
			duration_extend = {
				format_type = "number",
				value = talent_settings.combat_ability.focus.duration_extend,
			},
			duration_max = {
				format_type = "number",
				value = talent_settings.combat_ability.focus.duration_max,
			},
			cooldown = {
				format_type = "number",
				value = talent_settings.combat_ability.focus.cooldown,
			},
			default_talent = {
				format_type = "loc_string",
				value = "loc_talent_broker_ability_focus",
			},
		},
		player_ability = {
			ability_type = "combat_ability",
			ability = PlayerAbilities.broker_ability_focus_improved,
		},
		special_rule = {
			identifier = {
				"broker_focus_improved",
			},
			special_rule_name = {
				special_rules.broker_focus_improved,
			},
		},
	},
	broker_ability_focus_noclip = {
		description = "loc_talent_broker_ability_focus_noclip_desc",
		display_name = "loc_talent_broker_ability_focus_noclip",
		name = "broker_ability_focus_noclip",
		format_values = {
			ability = {
				format_type = "loc_string",
				value = "loc_talent_broker_ability_focus_improved",
			},
		},
		special_rule = {
			identifier = {
				"broker_focus_noclip",
			},
			special_rule_name = {
				special_rules.broker_focus_noclip,
			},
		},
	},
	broker_ability_focus_sub_2 = {
		description = "loc_talent_broker_ability_focus_sub_2_desc",
		display_name = "loc_talent_broker_ability_focus_sub_2",
		name = "broker_ability_focus_sub_2",
		format_values = {
			rending = {
				format_type = "percentage",
				prefix = "+",
				find_value = {
					buff_template_name = "broker_focus_stance",
					find_value_type = "buff_template",
					path = {
						"conditional_stat_buffs",
						stat_buffs.ranged_rending_multiplier,
					},
				},
			},
			focus = {
				format_type = "loc_string",
				value = "loc_talent_broker_ability_focus_improved",
			},
			damage = {
				format_type = "percentage",
				prefix = "+",
				find_value = {
					buff_template_name = "broker_focus_sub_2_damage",
					find_value_type = "buff_template",
					path = {
						"stat_buffs",
						stat_buffs.ranged_damage,
					},
				},
			},
			stacks = {
				format_type = "number",
				find_value = {
					buff_template_name = "broker_focus_sub_2_damage",
					find_value_type = "buff_template",
					path = {
						"max_stacks",
					},
				},
			},
		},
		special_rule = {
			identifier = "broker_focus_rending",
			special_rule_name = special_rules.broker_focus_rending,
		},
	},
	broker_ability_focus_sub_3 = {
		description = "loc_talent_broker_ability_focus_sub_3_desc",
		display_name = "loc_talent_broker_ability_focus_sub_3",
		name = "broker_ability_focus_sub_3",
		format_values = {
			cooldown_base = {
				format_type = "number",
				find_value = {
					buff_template_name = "broker_focus_stance",
					find_value_type = "buff_template",
					path = {
						"sub_3_cooldown_replenish",
					},
				},
			},
			cooldown_elite = {
				format_type = "number",
				find_value = {
					buff_template_name = "broker_focus_stance",
					find_value_type = "buff_template",
					path = {
						"sub_3_cooldown_replenish_elite",
					},
				},
			},
			cooldown_max = {
				format_type = "number",
				find_value = {
					buff_template_name = "broker_focus_stance",
					find_value_type = "buff_template",
					path = {
						"sub_3_cooldown_replenish_max",
					},
				},
			},
		},
		special_rule = {
			identifier = "broker_focus_cooldown_regain",
			special_rule_name = special_rules.broker_focus_cooldown_regain,
		},
	},
	broker_ability_punk_rage = {
		description = "loc_talent_broker_ability_punk_rage_desc_2",
		display_name = "loc_talent_broker_ability_punk_rage",
		icon = "content/ui/textures/icons/talents/broker/broker_talent_ability_punk_rage",
		name = "",
		format_values = {
			talent_name = {
				format_type = "loc_string",
				value = "loc_talent_broker_ability_punk_rage",
			},
			duration = {
				format_type = "number",
				value = talent_settings.combat_ability.punk_rage.rage_duration,
			},
			power = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.combat_ability.punk_rage.rage_melee_power_level_modifier,
			},
			attack_speed = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.combat_ability.punk_rage.rage_melee_attack_speed,
			},
			damage_taken = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.combat_ability.punk_rage.rage_damage_taken_multiplier,
				value_manipulation = function (value)
					return math.abs(1 - value) * 100
				end,
			},
			rage_duration_extend = {
				format_type = "number",
				num_decimals = 1,
				value = talent_settings.combat_ability.punk_rage.rage_duration_extend,
			},
			rage_duration_max = {
				format_type = "number",
				value = talent_settings.combat_ability.punk_rage.rage_duration_max,
			},
			exhaust_duration = {
				format_type = "number",
				value = talent_settings.combat_ability.punk_rage.exhaust_duration,
			},
			exhaust_damage_taken = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.combat_ability.punk_rage.exhaust_damage_taken_multiplier,
				value_manipulation = function (value)
					return math.abs(1 - value) * 100
				end,
			},
			exhaust_stamina_regeneration = {
				format_type = "percentage",
				prefix = "-",
				value = talent_settings.combat_ability.punk_rage.exhaust_stamina_regeneration_multiplier,
				value_manipulation = function (value)
					return (1 - value) * 100
				end,
			},
			cooldown = {
				format_type = "number",
				value = talent_settings.combat_ability.punk_rage.cooldown,
			},
		},
		player_ability = {
			ability_type = "combat_ability",
			ability = PlayerAbilities.broker_ability_punk_rage,
		},
	},
	broker_ability_punk_rage_sub_1 = {
		description = "loc_talent_broker_ability_punk_rage_sub_1_desc",
		display_name = "loc_talent_broker_ability_punk_rage_sub_1",
		name = "broker_ability_punk_rage_sub_1",
		format_values = {
			punk_rage = {
				format_type = "loc_string",
				value = "loc_talent_broker_ability_punk_rage",
			},
			ability_progress = {
				format_type = "percentage",
				find_value = {
					buff_template_name = "broker_punk_rage_stance",
					find_value_type = "buff_template",
					path = {
						"sub_1_rending_threshold_t",
					},
				},
			},
			rending = {
				format_type = "percentage",
				prefix = "+",
				find_value = {
					buff_template_name = "broker_punk_rage_stance",
					find_value_type = "buff_template",
					path = {
						"conditional_stat_buffs",
						stat_buffs.melee_heavy_rending_multiplier,
					},
				},
			},
		},
		special_rule = {
			identifier = {
				"broker_rage_rending",
			},
			special_rule_name = {
				special_rules.broker_rage_rending,
			},
		},
	},
	broker_ability_punk_rage_sub_2 = {
		description = "loc_talent_broker_ability_punk_rage_sub_2_desc",
		display_name = "loc_talent_broker_ability_punk_rage_sub_2",
		name = "broker_ability_punk_rage_sub_2",
		format_values = {
			cleave = {
				format_type = "percentage",
				prefix = "+",
				find_value = {
					buff_template_name = "broker_punk_rage_stance",
					find_value_type = "buff_template",
					path = {
						"conditional_stat_buffs",
						stat_buffs.max_hit_mass_attack_modifier,
					},
				},
			},
			punk_rage = {
				format_type = "loc_string",
				value = "loc_talent_broker_ability_punk_rage",
			},
			melee_power = {
				format_type = "percentage",
				prefix = "+",
				find_value = {
					buff_template_name = "broker_punk_rage_ramping_melee_power",
					find_value_type = "buff_template",
					path = {
						"stat_buffs",
						stat_buffs.melee_power_level_modifier,
					},
				},
			},
			max_stacks = {
				format_type = "number",
				find_value = {
					buff_template_name = "broker_punk_rage_ramping_melee_power",
					find_value_type = "buff_template",
					path = {
						"max_stacks",
					},
				},
			},
		},
		special_rule = {
			identifier = {
				"broker_rage_cleave",
			},
			special_rule_name = {
				special_rules.broker_rage_cleave,
			},
		},
	},
	broker_ability_punk_rage_sub_3 = {
		description = "loc_talent_broker_ability_punk_rage_sub_3_desc",
		display_name = "loc_talent_broker_ability_punk_rage_sub_3",
		name = "broker_ability_punk_rage_sub_3",
		format_values = {
			punk_rage = {
				format_type = "loc_string",
				value = "loc_talent_broker_ability_punk_rage",
			},
			attack_speed_reduction = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.combat_ability.punk_rage.improved_shout_enemy_melee_attack_speed,
				value_manipulation = function (value)
					return 50
				end,
			},
			duration = {
				format_type = "number",
				value = talent_settings.combat_ability.punk_rage.improved_shout_duration,
			},
		},
		special_rule = {
			identifier = {
				"broker_rage_improved_shout",
			},
			special_rule_name = {
				special_rules.broker_rage_improved_shout,
			},
		},
	},
	broker_ability_punk_rage_sub_4 = {
		description = "loc_talent_broker_ability_punk_rage_sub_4_desc",
		display_name = "loc_talent_broker_ability_punk_rage_sub_4",
		name = "broker_ability_punk_rage_sub_4",
		format_values = {
			punk_rage = {
				format_type = "loc_string",
				value = "loc_talent_broker_ability_punk_rage",
			},
			rage_duration_extend_elites = {
				format_type = "number",
				find_value = {
					buff_template_name = "broker_punk_rage_stance",
					find_value_type = "buff_template",
					path = {
						"sub_4_duration_extend_elite",
					},
				},
			},
			rage_duration_max_upgrade = {
				format_type = "number",
				find_value = {
					buff_template_name = "broker_punk_rage_stance",
					find_value_type = "buff_template",
					path = {
						"sub_4_duration_max_improved",
					},
				},
			},
		},
		special_rule = {
			identifier = {
				"broker_rage_duration_extend",
			},
			special_rule_name = {
				special_rules.broker_rage_duration_extend,
			},
		},
	},
	broker_ability_stimm_field = {
		description = "loc_talent_broker_ability_stimm_field_desc_3",
		display_name = "loc_talent_broker_ability_stimm_field",
		icon = "content/ui/textures/icons/talents/broker/broker_talent_ability_stimm_field",
		name = "",
		format_values = {
			duration = {
				format_type = "number",
				value = talent_settings.combat_ability.stimm_field.life_time,
			},
			total_corruption_heal = {
				format_type = "number",
				value = talent_settings.combat_ability.stimm_field.life_time / talent_settings.combat_ability.stimm_field.interval * talent_settings.combat_ability.stimm_field.corruption_heal_amount,
			},
			stimm_field = {
				format_type = "loc_string",
				value = "loc_talent_broker_ability_stimm_field",
			},
			cooldown = {
				format_type = "number",
				value = talent_settings.combat_ability.stimm_field.cooldown,
			},
		},
		player_ability = {
			ability_type = "combat_ability",
			ability = PlayerAbilities.broker_ability_stimm_field,
		},
	},
	broker_ability_stimm_field_sub_1 = {
		description = "loc_talent_broker_ability_stimm_field_sub_1_desc",
		display_name = "loc_talent_broker_ability_stimm_field_sub_1",
		icon = "content/ui/textures/icons/talents/broker/broker_talent_ability_stimm_field",
		name = "broker_ability_stimm_field_sub_1",
		format_values = {
			stimm_field = {
				format_type = "loc_string",
				value = "loc_talent_broker_ability_stimm_field",
			},
			duration = {
				format_type = "number",
				value = talent_settings.combat_ability.stimm_field.sub_1_life_time,
			},
			linger_duration = {
				format_type = "number",
				value = talent_settings.combat_ability.stimm_field.sub_1_linger_time,
			},
		},
		special_rule = {
			identifier = {
				"broker_stimm_field_linger",
			},
			special_rule_name = {
				special_rules.broker_stimm_field_linger,
			},
		},
	},
	broker_ability_stimm_field_sub_2 = {
		description = "loc_talent_broker_ability_stimm_field_sub_2_desc",
		display_name = "loc_talent_broker_ability_stimm_field_sub_2",
		name = "broker_ability_stimm_field_sub_2",
		format_values = {
			stimm_field = {
				format_type = "loc_string",
				value = "loc_talent_broker_ability_stimm_field",
			},
			stacks = {
				format_type = "number",
				value = math.max(DamageProfileTemplates.broker_stimm_field_close.num_buffs_on_damage, DamageProfileTemplates.broker_stimm_field.num_buffs_on_damage),
			},
			toxin = {
				format_type = "loc_string",
				value = "loc_term_glossary_broker_toxin",
			},
		},
		special_rule = {
			identifier = "broker_stimm_field_explode",
			special_rule_name = special_rules.broker_stimm_field_explode,
		},
	},
	broker_ability_stimm_field_sub_3 = {
		description = "loc_talent_broker_ability_stimm_field_sub_3_desc",
		display_name = "loc_talent_broker_ability_stimm_field_sub_3",
		name = "broker_ability_stimm_field_sub_3",
		format_values = {
			stimm_field = {
				format_type = "loc_string",
				value = "loc_talent_broker_ability_stimm_field",
			},
		},
		passive = {
			buff_template_name = "broker_ability_stimm_field_sub_3",
			identifier = "broker_ability_stimm_field_sub_3",
		},
	},
	broker_syringe = {
		large_icon = "content/ui/textures/icons/talents/zealot/zealot_ability_chastise_the_wicked",
		name = "Broker Stim",
		display_name = string.format("*BROKER STIM"),
		description = string.format("*Wield a specialized stim."),
		format_values = {},
		player_ability = {
			ability_type = "pocketable_ability",
			ability = PlayerAbilities.broker_ability_syringe,
		},
	},
	broker_blitz_flash_grenade = {
		description = "loc_talent_broker_blitz_flash_grenade_desc",
		display_name = "loc_talent_broker_blitz_flash_grenade",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		icon = "content/ui/textures/icons/talents/broker/broker_talent_blitz_flash_grenade",
		name = "",
		format_values = {
			max_charges = {
				format_type = "number",
				value = talent_settings.blitz.flash_grenade.max_charges_default,
			},
			num_kills = {
				format_type = "number",
				value = talent_settings.blitz.flash_grenade.num_kills,
			},
			num_charges = {
				format_type = "number",
				value = talent_settings.blitz.flash_grenade.num_charges,
			},
		},
		player_ability = {
			ability_type = "grenade_ability",
			ability = PlayerAbilities.broker_flash_grenade,
		},
		special_rule = {
			identifier = {
				"quick_flash_grenade",
			},
			special_rule_name = {
				special_rules.quick_flash_grenade,
			},
		},
		passive = {
			identifier = {
				"broker_passive_blitz_charge_on_kill",
				"broker_flash_grenade_cluster_stagger_tracking_buff",
			},
			buff_template_name = {
				"broker_passive_blitz_charge_on_kill",
				"broker_flash_grenade_cluster_stagger_tracking_buff",
			},
		},
	},
	broker_blitz_flash_grenade_improved = {
		description = "loc_talent_broker_blitz_flash_grenade_improved_desc",
		display_name = "loc_talent_broker_blitz_flash_grenade_improved",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		icon = "content/ui/textures/icons/talents/broker/broker_talent_blitz_flash_grenade",
		name = "",
		format_values = {
			max_charges = {
				format_type = "number",
				value = talent_settings.blitz.flash_grenade.max_charges_improved,
			},
			num_kills = {
				format_type = "number",
				value = talent_settings.blitz.flash_grenade.num_kills,
			},
			num_charges = {
				format_type = "number",
				value = talent_settings.blitz.flash_grenade.num_charges,
			},
			talent_name = {
				format_type = "loc_string",
				value = "loc_talent_broker_blitz_flash_grenade",
			},
		},
		player_ability = {
			ability_type = "grenade_ability",
			ability = PlayerAbilities.broker_flash_grenade_improved,
		},
	},
	broker_blitz_tox_grenade = {
		description = "loc_talent_broker_blitz_tox_grenade_desc",
		display_name = "loc_talent_broker_blitz_tox_grenade",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		icon = "content/ui/textures/icons/talents/zealot_3/zealot_3_tactical",
		name = "",
		format_values = {
			toxin = {
				format_type = "loc_string",
				value = "loc_term_glossary_broker_toxin",
			},
			max_charges = {
				format_type = "number",
				value = talent_settings.blitz.tox_grenade.max_charges,
			},
		},
		player_ability = {
			ability_type = "grenade_ability",
			ability = PlayerAbilities.broker_tox_grenade,
		},
		special_rule = {
			identifier = {
				"tox_grenade",
				"quick_flash_grenade",
			},
			special_rule_name = {
				special_rules.tox_grenade,
			},
		},
		passive = {
			identifier = {
				"broker_passive_blitz_charge_on_kill",
				"broker_flash_grenade_cluster_stagger_tracking_buff",
			},
			buff_template_name = {},
		},
	},
	broker_blitz_missile_launcher = {
		description = "loc_talent_broker_blitz_missile_launcher_desc",
		display_name = "loc_talent_broker_blitz_missile_launcher",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		icon = "content/ui/textures/icons/talents/zealot/zealot_blitz_stun_grenade",
		name = "",
		format_values = {
			max_charges = {
				format_type = "number",
				value = talent_settings.blitz.missile_launcher.max_charges,
			},
		},
		player_ability = {
			ability_type = "grenade_ability",
			ability = PlayerAbilities.broker_missile_launcher,
		},
		special_rule = {
			identifier = {
				"broker_missile_launcher",
				"quick_flash_grenade",
			},
			special_rule_name = {
				special_rules.broker_missile_launcher,
			},
		},
		passive = {
			identifier = {
				"broker_passive_blitz_charge_on_kill",
				"broker_flash_grenade_cluster_stagger_tracking_buff",
			},
			buff_template_name = {},
		},
	},
	broker_aura_gunslinger = {
		description = "loc_talent_broker_aura_gunslinger_desc",
		display_name = "loc_talent_broker_aura_gunslinger",
		icon = "content/ui/textures/icons/talents/broker/broker_talent_aura_gunslinger",
		name = "broker_aura_gunslinger",
		format_values = {
			ammo = {
				format_type = "percentage",
				find_value = {
					buff_template_name = "broker_aura_gunslinger",
					find_value_type = "buff_template",
					path = {
						"ammo_share",
					},
				},
			},
			talent = {
				format_type = "loc_string",
				value = "loc_talent_broker_aura_gunslinger",
			},
		},
		coherency = {
			buff_template_name = "broker_aura_gunslinger",
			identifier = "broker_aura",
			priority = 1,
		},
	},
	broker_aura_gunslinger_improved = {
		description = "loc_talent_broker_aura_gunslinger_improved_desc",
		display_name = "loc_talent_broker_aura_gunslinger_improved",
		name = "broker_aura_gunslinger_improved",
		format_values = {
			ammo = {
				format_type = "percentage",
				find_value = {
					buff_template_name = "broker_aura_gunslinger_improved",
					find_value_type = "buff_template",
					path = {
						"ammo_share",
					},
				},
			},
			talent = {
				format_type = "loc_string",
				value = "loc_talent_broker_aura_gunslinger",
			},
		},
		coherency = {
			buff_template_name = "broker_aura_gunslinger_improved",
			identifier = "broker_aura",
			priority = 1,
		},
	},
	broker_coherency_melee_damage = {
		description = "loc_talent_broker_aura_ruffian_desc",
		display_name = "loc_talent_broker_aura_ruffian",
		icon = "content/ui/textures/icons/talents/broker/broker_talent_temp_icon_ruffian",
		name = "",
		format_values = {
			melee_damage = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.coherency.ruffian.melee_damage,
			},
		},
		coherency = {
			buff_template_name = "broker_coherency_melee_damage",
			identifier = "broker_aura",
			priority = 1,
		},
	},
	broker_coherency_anarchist = {
		description = "loc_talent_broker_aura_anarchist_desc",
		display_name = "loc_talent_broker_aura_anarchist",
		icon = "content/ui/textures/icons/talents/broker/broker_talent_temp_icon_psycho",
		name = "",
		format_values = {
			critical_chance = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.coherency.anarchist.critical_strike_chance,
			},
		},
		coherency = {
			buff_template_name = "broker_coherency_critical_chance",
			identifier = "broker_aura",
			priority = 1,
		},
	},
	broker_passive_repeated_melee_hits_increases_damage = {
		description = "loc_talent_broker_passive_repeated_melee_hits_increases_damage_desc",
		display_name = "loc_talent_broker_passive_repeated_melee_hits_increases_damage",
		name = "",
		format_values = {
			damage = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_repeated_melee_hits_increases_damage.damage,
			},
			req_hits = {
				format_type = "number",
				value = talent_settings.broker_passive_repeated_melee_hits_increases_damage.req_hits,
			},
		},
		passive = {
			buff_template_name = "broker_passive_repeated_melee_hits_increases_damage",
			identifier = "broker_passive_repeated_melee_hits_increases_damage",
		},
	},
	broker_passive_first_target_damage = {
		description = "loc_talent_broker_passive_first_target_damage_desc",
		display_name = "loc_talent_broker_passive_first_target_damage",
		name = "",
		format_values = {
			damage = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_first_target_damage.damage,
			},
		},
		passive = {
			buff_template_name = "broker_passive_first_target_damage",
			identifier = "broker_passive_first_target_damage",
		},
	},
	broker_passive_reduce_swap_time = {
		description = "loc_talent_broker_passive_reduce_swap_time_desc",
		display_name = "loc_talent_broker_passive_reduce_swap_time",
		name = "",
		format_values = {
			wield_speed = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_reduce_swap_time.wield_speed,
			},
			recoil = {
				format_type = "percentage",
				prefix = "-",
				value = talent_settings.broker_passive_reduce_swap_time.recoil_modifier,
				value_manipulation = function (value)
					return math.abs(value) * 100
				end,
			},
			spread = {
				format_type = "percentage",
				prefix = "-",
				value = talent_settings.broker_passive_reduce_swap_time.spread_modifier,
				value_manipulation = function (value)
					return math.abs(value) * 100
				end,
			},
		},
		passive = {
			buff_template_name = "broker_passive_reduce_swap_time",
			identifier = "broker_passive_reduce_swap_time",
		},
	},
	broker_passive_increased_ranged_dodges = {
		description = "loc_talent_broker_passive_increased_ranged_dodges_desc",
		display_name = "loc_talent_broker_passive_increased_ranged_dodges",
		name = "",
		format_values = {
			extra_consecutive_dodges = {
				format_type = "number",
				prefix = "+",
				value = talent_settings.broker_passive_increased_ranged_dodges.extra_consecutive_dodges,
			},
		},
		passive = {
			buff_template_name = "broker_passive_increased_ranged_dodges",
			identifier = "broker_passive_increased_ranged_dodges",
		},
	},
	broker_passive_close_ranged_damage = {
		description = "loc_talent_broker_passive_close_ranged_damage_desc",
		display_name = "loc_talent_broker_passive_close_ranged_damage",
		name = "",
		format_values = {
			damage_near = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_close_ranged_damage.damage_near,
			},
			damage_far = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_close_ranged_damage.damage_far,
			},
			range_near = {
				format_type = "number",
				value = 12.5,
			},
			range_far = {
				format_type = "number",
				value = 30,
			},
		},
		passive = {
			buff_template_name = "broker_passive_close_ranged_damage",
			identifier = "broker_passive_close_ranged_damage",
		},
	},
	broker_passive_ninja_grants_crit_chance = {
		description = "loc_talent_broker_passive_ninja_grants_crit_chance_desc",
		display_name = "loc_talent_broker_passive_ninja_grants_crit_chance",
		name = "",
		format_values = {
			critical_strike_chance = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_ninja_grants_crit_chance.critical_strike_chance,
			},
			duration = {
				format_type = "number",
				value = talent_settings.broker_passive_ninja_grants_crit_chance.duration,
			},
		},
		passive = {
			buff_template_name = "broker_passive_ninja_grants_crit_chance",
			identifier = "broker_passive_ninja_grants_crit_chance",
		},
	},
	broker_passive_parries_grant_crit_chance = {
		description = "loc_talent_broker_passive_parries_grant_crit_chance_desc",
		display_name = "loc_talent_broker_passive_parries_grant_crit_chance",
		name = "",
		format_values = {
			critical_strike_chance = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_parries_grant_crit_chance.critical_strike_chance,
			},
			duration = {
				format_type = "number",
				value = talent_settings.broker_passive_parries_grant_crit_chance.duration,
			},
		},
		passive = {
			buff_template_name = "broker_passive_parries_grant_crit_chance",
			identifier = "broker_passive_parries_grant_crit_chance",
		},
	},
	broker_passive_backstabs_grant_crit_chance = {
		description = "loc_talent_broker_passive_backstabs_grant_crit_chance_desc",
		display_name = "loc_talent_broker_passive_backstabs_grant_crit_chance",
		name = "",
		format_values = {
			critical_strike_chance = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_backstabs_grant_crit_chance.critical_strike_chance,
			},
			duration = {
				format_type = "number",
				value = talent_settings.broker_passive_backstabs_grant_crit_chance.duration,
			},
		},
		passive = {
			buff_template_name = "broker_passive_backstabs_grant_crit_chance",
			identifier = "broker_passive_backstabs_grant_crit_chance",
		},
	},
	broker_passive_punk_grit = {
		description = "loc_talent_broker_passive_punk_grit_desc",
		display_name = "loc_talent_broker_passive_punk_grit",
		name = "",
		format_values = {
			ranged_damage = {
				format_type = "percentage",
				prefix = "+",
				find_value = {
					buff_template_name = "broker_passive_punk_grit",
					find_value_type = "buff_template",
					path = {
						"stat_buffs",
						stat_buffs.ranged_damage,
					},
				},
			},
			toughness_damage_taken_modifier = {
				format_type = "percentage",
				prefix = "+",
				find_value = {
					buff_template_name = "broker_passive_punk_grit",
					find_value_type = "buff_template",
					path = {
						"stat_buffs",
						stat_buffs.toughness_damage_taken_multiplier,
					},
				},
				value_manipulation = function (value)
					return math.round((1 - value) * 100)
				end,
			},
		},
		passive = {
			buff_template_name = "broker_passive_punk_grit",
			identifier = "broker_passive_punk_grit",
		},
	},
	broker_passive_stamina_on_successful_dodge = {
		description = "loc_talent_broker_passive_stamina_on_successful_dodge_desc",
		display_name = "loc_talent_broker_passive_stamina_on_successful_dodge",
		name = "",
		format_values = {
			stamina = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_stamina_on_successful_dodge.stamina,
			},
		},
		passive = {
			buff_template_name = "broker_passive_stamina_on_successful_dodge",
			identifier = "broker_passive_stamina_on_successful_dodge",
		},
	},
	broker_passive_improved_dodges = {
		description = "loc_talent_broker_passive_improved_dodges_desc",
		display_name = "loc_talent_broker_passive_improved_dodges",
		name = "",
		format_values = {
			dodge_distance_modifier = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_improved_dodges.dodge_distance_modifier,
			},
			dodge_linger_time = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_improved_dodges.dodge_linger_time_modifier,
			},
		},
		passive = {
			buff_template_name = "broker_passive_improved_dodges",
			identifier = "broker_passive_improved_dodges",
		},
	},
	broker_passive_dodge_melee_on_slide = {
		description = "loc_talent_broker_passive_dodge_melee_on_slide_desc",
		display_name = "loc_talent_broker_passive_dodge_melee_on_slide",
		name = "",
		passive = {
			buff_template_name = "broker_passive_dodge_melee_on_slide",
			identifier = "broker_passive_dodge_melee_on_slide",
		},
	},
	broker_passive_restore_toughness_on_close_ranged_kill = {
		description = "loc_talent_broker_passive_restore_toughness_on_close_ranged_kill_desc",
		display_name = "loc_talent_broker_passive_restore_toughness_on_close_ranged_kill",
		name = "",
		format_values = {
			toughness = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_restore_toughness_on_close_ranged_kill.toughness_percentage,
			},
			toughness_elites = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_restore_toughness_on_close_ranged_kill.toughness_elites,
			},
		},
		passive = {
			buff_template_name = "broker_passive_restore_toughness_on_close_ranged_kill",
			identifier = "broker_passive_restore_toughness_on_close_ranged_kill",
		},
	},
	broker_passive_restore_toughness_on_weakspot_kill = {
		description = "loc_talent_broker_passive_restore_toughness_on_weakspot_kill_desc",
		display_name = "loc_talent_broker_passive_restore_toughness_on_weakspot_kill",
		name = "",
		format_values = {
			default = {
				format_type = "percentage",
				value = talent_settings.broker_passive_restore_toughness_on_weakspot_kill.default,
			},
			weakspot = {
				format_type = "percentage",
				value = talent_settings.broker_passive_restore_toughness_on_weakspot_kill.weakspot,
			},
			critical = {
				format_type = "percentage",
				value = talent_settings.broker_passive_restore_toughness_on_weakspot_kill.critical,
			},
		},
		passive = {
			buff_template_name = "broker_passive_restore_toughness_on_weakspot_kill",
			identifier = "broker_passive_restore_toughness_on_weakspot_kill",
		},
	},
	broker_passive_reduced_toughness_damage_during_reload = {
		description = "loc_talent_broker_passive_reduced_toughness_damage_during_reload_desc",
		display_name = "loc_talent_broker_passive_reduced_toughness_damage_during_reload",
		name = "",
		format_values = {
			toughness_damage_taken_modifier = {
				format_type = "percentage",
				value = talent_settings.broker_passive_reduced_toughness_damage_during_reload.toughness_damage_taken_modifier,
			},
			duration = {
				format_type = "number",
				value = talent_settings.broker_passive_reduced_toughness_damage_during_reload.duration,
			},
		},
		passive = {
			buff_template_name = "broker_passive_reduced_toughness_damage_during_reload",
			identifier = "broker_passive_reduced_toughness_damage_during_reload",
		},
	},
	broker_passive_sprinting_reduces_threat = {
		description = "loc_talent_broker_passive_sprinting_reduces_threat_desc",
		display_name = "loc_talent_broker_passive_sprinting_reduces_threat",
		name = "",
		format_values = {
			threshold = {
				format_type = "number",
				value = talent_settings.broker_passive_sprinting_reduces_threat.threshold,
			},
			threat_weight_multiplier = {
				format_type = "percentage",
				prefix = "-",
				value = talent_settings.broker_passive_sprinting_reduces_threat.threat_weight_multiplier,
				value_manipulation = function (value)
					return (1 - value) * 100
				end,
			},
			duration = {
				format_type = "number",
				value = talent_settings.broker_passive_sprinting_reduces_threat.duration,
			},
			max_stacks = {
				format_type = "number",
				value = talent_settings.broker_passive_sprinting_reduces_threat.max_stacks,
			},
		},
		passive = {
			buff_template_name = "broker_passive_sprinting_reduces_threat",
			identifier = "broker_passive_sprinting_reduces_threat",
		},
	},
	broker_passive_reload_speed_on_close_kill = {
		description = "loc_talent_broker_passive_reload_speed_on_close_kill_desc",
		display_name = "loc_talent_broker_passive_reload_speed_on_close_kill",
		name = "",
		format_values = {
			reload_speed = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_reload_speed_on_close_kill.reload_speed,
			},
			duration = {
				format_type = "number",
				value = talent_settings.broker_passive_reload_speed_on_close_kill.duration,
			},
		},
		passive = {
			buff_template_name = "broker_passive_reload_speed_on_close_kill",
			identifier = "broker_passive_reload_speed_on_close_kill",
		},
	},
	broker_passive_blitz_charge_on_kill = {
		description = "loc_talent_broker_passive_blitz_charge_on_kill_desc",
		display_name = "loc_talent_broker_passive_blitz_charge_on_kill",
		name = "",
		format_values = {
			num_kills = {
				format_type = "number",
				value = talent_settings.broker_passive_blitz_charge_on_kill.num_kills,
			},
			num_charges = {
				format_type = "number",
				value = talent_settings.broker_passive_blitz_charge_on_kill.num_charges,
			},
		},
		passive = {
			buff_template_name = "broker_passive_blitz_charge_on_kill",
			identifier = "broker_passive_blitz_charge_on_kill",
		},
	},
	broker_passive_weakspot_on_x_hit = {
		description = "Every {num_hits:%s} hit counts as a Weakspot Hit",
		name = "Augmented Precision",
		display_name = string.format("*Augmented Precision"),
		format_values = {
			num_hits = {
				format_type = "number",
				value = talent_settings.broker_passive_weakspot_on_x_hit.num_hits,
			},
		},
		passive = {
			buff_template_name = "broker_passive_weakspot_on_x_hit",
			identifier = "broker_passive_weakspot_on_x_hit",
		},
	},
	broker_passive_close_range_rending = {
		description = "{multiplier:%s} Rending while in Close Range",
		name = "Lethal Aggression",
		display_name = string.format("*Lethal Aggression"),
		format_values = {
			multiplier = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_close_range_rending.multiplier,
			},
		},
		passive = {
			buff_template_name = "broker_passive_close_range_rending",
			identifier = "broker_passive_close_range_rending",
		},
	},
	broker_passive_crit_to_damage = {
		description = "Crit Chance is converted into Damage",
		name = "Gritty Consistency",
		display_name = string.format("*Gritty Consistency"),
		passive = {
			buff_template_name = "broker_passive_crit_to_damage",
			identifier = "broker_passive_crit_to_damage",
		},
	},
	broker_passive_strength_vs_aggroed = {
		description = "loc_talent_broker_passive_strength_vs_aggroed_desc",
		display_name = "loc_talent_broker_passive_strength_vs_aggroed",
		name = "",
		format_values = {
			power = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_strength_vs_aggroed.power_level_modifier,
			},
		},
		passive = {
			buff_template_name = "broker_passive_strength_vs_aggroed",
			identifier = "broker_passive_strength_vs_aggroed",
		},
	},
	broker_passive_improved_sprint_dodge = {
		description = "loc_talent_broker_passive_improved_sprint_dodge_desc",
		display_name = "loc_talent_broker_passive_improved_sprint_dodge",
		name = "",
		format_values = {
			angle = {
				format_type = "number",
				num_decimals = 0,
				prefix = "+",
				value = talent_settings.broker_passive_improved_sprint_dodge.sprint_dodge_reduce_angle_threshold_rad,
				value_manipulation = function (value)
					return math_round(math.radians_to_degrees(value))
				end,
			},
		},
		passive = {
			buff_template_name = "broker_passive_improved_sprint_dodge",
			identifier = "broker_passive_improved_sprint_dodge",
		},
	},
	broker_passive_extra_consecutive_dodges = {
		description = "*Number of Dodges before Dodges starts becoming ineffective increased by {extra_consecutive_dodges:%s}.",
		name = "Extra Consecutive Dodges",
		display_name = string.format("*Extra Consecutive Dodges"),
		format_values = {
			extra_consecutive_dodges = {
				format_type = "number",
				value = talent_settings.broker_passive_extra_consecutive_dodges.extra_consecutive_dodges,
			},
		},
		passive = {
			buff_template_name = "broker_passive_extra_consecutive_dodges",
			identifier = "broker_passive_extra_consecutive_dodges",
		},
	},
	broker_passive_improved_dodges_at_full_stamina = {
		description = "loc_talent_broker_passive_improved_dodges_at_full_stamina_desc",
		display_name = "loc_talent_broker_passive_improved_dodges_at_full_stamina",
		name = "",
		format_values = {
			dodge_cooldown_reset_modifier = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_improved_dodges_at_full_stamina.dodge_cooldown_reset_modifier,
				value_manipulation = function (value)
					return math.abs(value * 100)
				end,
			},
			stamina = {
				format_type = "percentage",
				value = talent_settings.broker_passive_improved_dodges_at_full_stamina.conditional_threshold,
			},
		},
		passive = {
			buff_template_name = "broker_passive_improved_dodges_at_full_stamina",
			identifier = "broker_passive_improved_dodges_at_full_stamina",
		},
	},
	broker_passive_stamina_grants_atk_speed = {
		description = "loc_talent_broker_passive_stamina_grants_atk_speed_desc",
		display_name = "loc_talent_broker_passive_stamina_grants_atk_speed",
		name = "",
		format_values = {
			attack_speed_increase = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_stamina_grants_atk_speed.attack_speed_increase,
			},
		},
		passive = {
			buff_template_name = "broker_passive_stamina_grants_atk_speed",
			identifier = "broker_passive_stamina_grants_atk_speed",
		},
	},
	broker_passive_increased_weakspot_damage = {
		description = "loc_talent_broker_passive_increased_weakspot_damage_desc",
		display_name = "loc_talent_broker_passive_increased_weakspot_damage",
		name = "",
		format_values = {
			weakspot_damage = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_increased_weakspot_damage.weakspot_damage,
			},
		},
		passive = {
			buff_template_name = "broker_passive_increased_weakspot_damage",
			identifier = "broker_passive_increased_weakspot_damage",
		},
	},
	broker_passive_extended_mag = {
		description = "loc_talent_broker_passive_extended_mag_desc",
		display_name = "loc_talent_broker_passive_extended_mag",
		name = "",
		format_values = {
			clip_size = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_extended_mag.clip_size_modifier,
			},
		},
		passive = {
			buff_template_name = "broker_passive_extended_mag",
			identifier = "broker_passive_extended_mag",
		},
	},
	broker_passive_reload_on_crit = {
		description = "{ammo:%s} of your clip is refilled from Ammo Reserve on Ranged Critical Strike.",
		name = "Reload On Ranged Crit",
		display_name = string.format("*Reload On Ranged Crit"),
		format_values = {
			ammo = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_reload_on_crit.ammo_replenish_percent,
			},
		},
		passive = {
			buff_template_name = "broker_passive_reload_on_crit",
			identifier = "broker_passive_reload_on_crit",
		},
	},
	broker_passive_crit_kill_at_close_range_reload = {
		description = "Close Ranged Critical Kills instantly reloads your Ranged Weapon.",
		name = "Reload on Close Range Crit Kills",
		display_name = string.format("*Close Ranged Critical Kills Reload."),
		passive = {
			buff_template_name = "broker_passive_crit_kill_at_close_range_reload",
			identifier = "broker_passive_crit_kill_at_close_range_reload",
		},
	},
	broker_passive_hollowtip_bullets = {
		description = "Full reload on close range crit.",
		name = "Hollow-tip bullets",
		display_name = string.format("*Revolvers have higher stagger. Human-sized enemies have a chance to be sent flying when staggered"),
		passive = {
			buff_template_name = "broker_passive_hollowtip_bullets",
			identifier = "broker_passive_hollowtip_bullets",
		},
	},
	broker_passive_heavy_attack_dash = {
		description = "Full reload on close range crit.",
		name = "Charge",
		display_name = string.format("*On melee hit: Next time you heavy attack whilst sprinting, leap forward and and apply extra damage and impact on hit"),
		passive = {
			buff_template_name = "broker_passive_heavy_attack_dash",
			identifier = "broker_passive_heavy_attack_dash",
		},
	},
	broker_passive_close_ranged_finesse_damage = {
		description = "Close Ranged Finesse Damage.",
		name = "Close Ranged Finesse Damage",
		display_name = string.format("*Close Ranged Finesse Damage"),
		passive = {
			buff_template_name = "broker_passive_close_ranged_finesse_damage",
			identifier = "broker_passive_close_ranged_finesse_damage",
		},
	},
	broker_passive_close_range_damage_on_dodge = {
		description = "loc_talent_broker_passive_close_range_damage_on_dodge_desc",
		display_name = "loc_talent_broker_passive_close_range_damage_on_dodge",
		name = "",
		format_values = {
			damage_near = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_close_range_damage_on_dodge.damage_near,
			},
			duration = {
				format_type = "number",
				value = talent_settings.broker_passive_close_range_damage_on_dodge.active_duration,
			},
		},
		passive = {
			buff_template_name = "broker_passive_close_range_damage_on_dodge",
			identifier = "broker_passive_close_range_damage_on_dodge",
		},
	},
	broker_passive_close_range_damage_on_slide = {
		description = "Close Range Damage on Slide.",
		name = "Close Range Damage on Slide",
		display_name = string.format("*Close Range Damage on Slide"),
		passive = {
			buff_template_name = "broker_passive_close_range_damage_on_slide",
			identifier = "broker_passive_close_range_damage_on_slide",
		},
	},
	broker_passive_finesse_damage = {
		description = "Finesse Damage.",
		name = "Finesse Damage",
		display_name = string.format("*Finesse Damage"),
		passive = {
			buff_template_name = "broker_passive_finesse_damage",
			identifier = "broker_passive_finesse_damage",
		},
	},
	broker_passive_ramping_backstabs = {
		description = "loc_talent_broker_passive_ramping_backstabs_desc",
		display_name = "loc_talent_broker_passive_ramping_backstabs",
		name = "",
		format_values = {
			power = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_ramping_backstabs.melee_power_level_modifier,
			},
			stacks = {
				format_type = "number",
				value = talent_settings.broker_passive_ramping_backstabs.max_stacks,
			},
		},
		passive = {
			buff_template_name = "broker_passive_ramping_backstabs",
			identifier = "broker_passive_ramping_backstabs",
		},
	},
	broker_passive_stun_immunity_on_toughness_broken = {
		description = "loc_talent_broker_passive_stun_immunity_on_toughness_broken_desc",
		display_name = "loc_talent_broker_passive_stun_immunity_on_toughness_broken",
		name = "Stun Immunity when Toughness is broken",
		format_values = {
			duration = {
				format_type = "number",
				value = talent_settings.broker_passive_stun_immunity_on_toughness_broken.duration,
			},
			toughness = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_stun_immunity_on_toughness_broken.toughness,
			},
			cooldown = {
				format_type = "number",
				value = talent_settings.broker_passive_stun_immunity_on_toughness_broken.cooldown,
			},
		},
		passive = {
			buff_template_name = "broker_passive_stun_immunity_on_toughness_broken",
			identifier = "broker_passive_stun_immunity_on_toughness_broken",
		},
	},
	broker_passive_push_on_damage_taken = {
		description = "loc_talent_broker_passive_push_on_damage_taken_desc",
		display_name = "loc_talent_broker_passive_push_on_damage_taken",
		name = "",
		format_values = {
			damage_reduction = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_push_on_damage_taken.damage_reduction,
			},
			impact = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_push_on_damage_taken.impact,
			},
			angle = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_push_on_damage_taken.angle,
			},
			max_stacks = {
				format_type = "number",
				value = talent_settings.broker_passive_push_on_damage_taken.max_stacks,
			},
		},
		passive = {
			buff_template_name = "broker_passive_push_on_damage_taken",
			identifier = "broker_passive_push_on_damage_taken",
		},
	},
	broker_passive_replenish_toughness_on_ranged_toughness_damage = {
		description = "loc_talent_broker_passive_replenish_toughness_on_ranged_toughness_damage_desc",
		display_name = "loc_talent_broker_passive_replenish_toughness_on_ranged_toughness_damage",
		name = "",
		format_values = {
			toughness = {
				format_type = "percentage",
				value = talent_settings.broker_passive_replenish_toughness_on_ranged_toughness_damage.toughness,
			},
			duration = {
				format_type = "number",
				value = talent_settings.broker_passive_replenish_toughness_on_ranged_toughness_damage.duration,
			},
		},
		passive = {
			buff_template_name = "broker_passive_replenish_toughness_on_ranged_toughness_damage",
			identifier = "broker_passive_replenish_toughness_on_ranged_toughness_damage",
		},
	},
	broker_passive_ammo_on_backstab = {
		description = "loc_talent_broker_passive_ammo_on_backstab_desc",
		display_name = "loc_talent_broker_passive_ammo_on_backstab",
		name = "",
		format_values = {
			ammo = {
				format_type = "percentage",
				value = talent_settings.broker_passive_ammo_on_backstab.ammo_regain,
			},
			cooldown = {
				format_type = "number",
				value = talent_settings.broker_passive_ammo_on_backstab.cooldown,
			},
		},
		passive = {
			buff_template_name = "broker_passive_ammo_on_backstab",
			identifier = "broker_passive_ammo_on_backstab",
		},
	},
	broker_passive_stimm_increased_duration = {
		description = "loc_talent_broker_passive_stimm_increased_duration_desc",
		display_name = "loc_talent_broker_passive_stimm_increased_duration",
		name = "Stimm Increased Duration",
		format_values = {
			duration_increase = {
				format_type = "number",
				prefix = "+",
				value = talent_settings.broker_passive_stimm_increased_duration.duration_increase,
			},
		},
		passive = {
			buff_template_name = "broker_passive_stimm_increased_duration",
			identifier = "broker_passive_stimm_increased_duration",
		},
	},
	broker_passive_stimm_cleanse_on_kill = {
		description = "loc_talent_broker_passive_stimm_cleanse_on_kill_desc",
		display_name = "loc_talent_broker_passive_stimm_cleanse_on_kill",
		name = "Stimm Increased Duration",
		format_values = {
			cleanse_amount = {
				format_type = "percentage",
				find_value = {
					buff_template_name = "broker_passive_stimm_cleanse_on_kill_buff",
					find_value_type = "buff_template",
					path = {
						"cleanse_amount",
					},
				},
			},
			cleanse_threshold = {
				format_type = "percentage",
				find_value = {
					buff_template_name = "broker_passive_stimm_cleanse_on_kill_buff",
					find_value_type = "buff_template",
					path = {
						"cleanse_threshold",
					},
				},
			},
		},
		passive = {
			buff_template_name = "broker_passive_stimm_cleanse_on_kill",
			identifier = "broker_passive_stimm_cleanse_on_kill",
		},
	},
	broker_passive_damage_on_reload = {
		description = "loc_talent_broker_passive_damage_on_reload_desc",
		display_name = "loc_talent_broker_passive_damage_on_reload",
		name = "broker_passive_damage_on_reload",
		format_values = {
			damage = {
				format_type = "percentage",
				prefix = "+",
				find_value = {
					buff_template_name = "broker_passive_damage_on_reload_buff",
					find_value_type = "buff_template",
					path = {
						"base_damage",
					},
				},
			},
			duration = {
				format_type = "number",
				find_value = {
					buff_template_name = "broker_passive_damage_on_reload_buff",
					find_value_type = "buff_template",
					path = {
						"duration",
					},
				},
			},
			ammo_per_stack = {
				format_type = "percentage",
				find_value = {
					buff_template_name = "broker_passive_damage_on_reload_buff",
					find_value_type = "buff_template",
					path = {
						"ammo_percentage_per_stage",
					},
				},
			},
			damage_per_stack = {
				format_type = "percentage",
				prefix = "+",
				find_value = {
					buff_template_name = "broker_passive_damage_on_reload_buff",
					find_value_type = "buff_template",
					path = {
						"damage_per_ammo_stage",
					},
				},
			},
		},
		passive = {
			buff_template_name = "broker_passive_damage_on_reload",
			identifier = "broker_passive_damage_on_reload",
		},
	},
	broker_passive_melee_crit_instakill = {
		description = "loc_talent_broker_passive_melee_crit_instakill_desc",
		display_name = "loc_talent_broker_passive_melee_crit_instakill",
		name = "broker_passive_melee_crit_instakill",
		format_values = {
			threshold = {
				format_type = "number",
				find_value = {
					buff_template_name = "broker_passive_melee_crit_instakill",
					find_value_type = "buff_template",
					path = {
						"health_by_damage_threshold",
					},
				},
			},
		},
		passive = {
			buff_template_name = "broker_passive_melee_crit_instakill",
			identifier = "broker_passive_melee_crit_instakill",
		},
	},
	broker_passive_dr_damage_tradeoff_on_stamina = {
		description = "loc_talent_broker_passive_dr_damage_tradeoff_on_stamina_desc",
		display_name = "loc_talent_broker_passive_dr_damage_tradeoff_on_stamina",
		name = "broker_passive_dr_damage_tradeoff_on_stamina",
		format_values = {
			damage_increase = {
				format_type = "percentage",
				find_value = {
					buff_template_name = "broker_passive_dr_damage_tradeoff_on_stamina",
					find_value_type = "buff_template",
					prefix = "+",
					path = {
						"damage_multiplier",
					},
				},
			},
			damage_reduction = {
				format_type = "percentage",
				find_value = {
					buff_template_name = "broker_passive_dr_damage_tradeoff_on_stamina",
					find_value_type = "buff_template",
					path = {
						"damage_reduction_multiplier",
					},
				},
			},
		},
		passive = {
			buff_template_name = "broker_passive_dr_damage_tradeoff_on_stamina",
			identifier = "broker_passive_dr_damage_tradeoff_on_stamina",
		},
	},
	broker_passive_damage_vs_elites_monsters = {
		description = "loc_talent_broker_passive_damage_vs_elites_monsters_desc",
		display_name = "loc_talent_broker_passive_damage_vs_elites_monsters",
		name = "broker_passive_damage_vs_elites_monsters",
		format_values = {
			multiplier = {
				format_type = "percentage",
				prefix = "+",
				find_value = {
					buff_template_name = "broker_passive_damage_vs_elites_monsters",
					find_value_type = "buff_template",
					path = {
						"stat_buffs",
						stat_buffs.damage_vs_elites,
					},
				},
			},
		},
		passive = {
			buff_template_name = "broker_passive_damage_vs_elites_monsters",
			identifier = "broker_passive_damage_vs_elites_monsters",
		},
	},
	broker_passive_melee_damage_carry_over = {
		description = "loc_talent_broker_passive_melee_damage_carry_over_desc",
		display_name = "loc_talent_broker_passive_melee_damage_carry_over",
		name = "broker_passive_melee_damage_carry_over",
		format_values = {
			percentage = {
				format_type = "percentage",
				prefix = "+",
				find_value = {
					buff_template_name = "broker_passive_melee_damage_carry_over",
					find_value_type = "buff_template",
					path = {
						"carry_over_percentage",
					},
				},
			},
			duration = {
				format_type = "number",
				find_value = {
					buff_template_name = "broker_passive_melee_damage_carry_over",
					find_value_type = "buff_template",
					path = {
						"active_duration",
					},
				},
			},
		},
		passive = {
			buff_template_name = "broker_passive_melee_damage_carry_over",
			identifier = "broker_passive_melee_damage_carry_over",
		},
	},
	broker_passive_melee_cleave_on_melee_kill = {
		description = "loc_talent_broker_passive_melee_cleave_on_melee_kill_desc",
		display_name = "loc_talent_broker_passive_melee_cleave_on_melee_kill",
		name = "broker_passive_melee_cleave_on_melee_kill",
		format_values = {
			duration = {
				format_type = "number",
				find_value = {
					buff_template_name = "broker_passive_melee_cleave_on_melee_kill_buff",
					find_value_type = "buff_template",
					path = {
						"duration",
					},
				},
			},
			max_stacks = {
				format_type = "number",
				find_value = {
					buff_template_name = "broker_passive_melee_cleave_on_melee_kill_buff",
					find_value_type = "buff_template",
					path = {
						"max_stacks",
					},
				},
			},
			multiplier = {
				format_type = "percentage",
				prefix = "+",
				find_value = {
					buff_template_name = "broker_passive_melee_cleave_on_melee_kill_buff",
					find_value_type = "buff_template",
					path = {
						"stat_buffs",
						stat_buffs.max_melee_hit_mass_attack_modifier,
					},
				},
			},
		},
		passive = {
			buff_template_name = "broker_passive_melee_cleave_on_melee_kill",
			identifier = "broker_passive_melee_cleave_on_melee_kill",
		},
	},
	broker_passive_cleave_on_cleave = {
		description = "loc_talent_broker_passive_cleave_on_cleave_desc",
		display_name = "loc_talent_broker_passive_cleave_on_cleave",
		name = "broker_passive_cleave_on_cleave",
		format_values = {
			min_targets = {
				format_type = "number",
				find_value = {
					buff_template_name = "broker_passive_cleave_on_cleave",
					find_value_type = "buff_template",
					path = {
						"min_targets",
					},
				},
			},
			multiplier = {
				format_type = "percentage",
				prefix = "+",
				find_value = {
					buff_template_name = "broker_passive_cleave_on_cleave_buff",
					find_value_type = "buff_template",
					path = {
						"stat_buffs",
						stat_buffs.max_hit_mass_attack_modifier,
					},
				},
			},
		},
		passive = {
			buff_template_name = "broker_passive_cleave_on_cleave",
			identifier = "broker_passive_cleave_on_cleave",
		},
	},
	broker_passive_increased_blitz_ammo = {
		description = "loc_talent_broker_passive_increased_blitz_ammo_desc",
		display_name = "loc_talent_broker_passive_increased_blitz_ammo",
		name = "broker_passive_increased_blitz_ammo",
		format_values = {
			ammo = {
				format_type = "number",
				prefix = "+",
				find_value = {
					buff_template_name = "broker_passive_increased_blitz_ammo",
					find_value_type = "buff_template",
					path = {
						"stat_buffs",
						stat_buffs.extra_max_amount_of_grenades,
					},
				},
			},
		},
		passive = {
			buff_template_name = "broker_passive_increased_blitz_ammo",
			identifier = "broker_passive_increased_blitz_ammo",
		},
	},
	broker_passive_stimm_cd_on_kill = {
		description = "loc_talent_broker_passive_stimm_cd_on_kill_desc",
		display_name = "loc_talent_broker_passive_stimm_cd_on_kill",
		name = "broker_passive_stimm_cd_on_kill",
		format_values = {
			toxin = {
				format_type = "loc_string",
				value = "loc_term_glossary_broker_toxin",
			},
			stimm = {
				format_type = "loc_string",
				value = "loc_talent_broker_stimm",
			},
			restore = {
				format_type = "percentage",
				find_value = {
					buff_template_name = "broker_passive_stimm_cd_on_kill",
					find_value_type = "buff_template",
					path = {
						"restore",
					},
				},
			},
			restore_toxined = {
				format_type = "percentage",
				find_value = {
					buff_template_name = "broker_passive_stimm_cd_on_kill",
					find_value_type = "buff_template",
					path = {
						"restore_toxined",
					},
				},
			},
		},
		passive = {
			buff_template_name = "broker_passive_stimm_cd_on_kill",
			identifier = "broker_passive_stimm_cd_on_kill",
		},
	},
	broker_passive_increased_aura_size = {
		description = "loc_talent_broker_passive_increased_aura_size_desc",
		display_name = "loc_talent_broker_passive_increased_aura_size",
		name = "broker_passive_increased_aura_size",
		format_values = {
			multiplier = {
				format_type = "percentage",
				prefix = "+",
				find_value = {
					buff_template_name = "broker_passive_increased_aura_size",
					find_value_type = "buff_template",
					path = {
						"stat_buffs",
						stat_buffs.coherency_radius_modifier,
					},
				},
			},
		},
		passive = {
			buff_template_name = "broker_passive_increased_aura_size",
			identifier = "broker_passive_increased_aura_size",
		},
	},
	broker_passive_damage_vs_heavy_staggered = {
		description = "loc_talent_broker_passive_damage_vs_heavy_staggered_desc",
		display_name = "loc_talent_broker_passive_damage_vs_heavy_staggered",
		name = "",
		format_values = {
			multiplier = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_damage_vs_heavy_staggered.multiplier,
			},
		},
		passive = {
			buff_template_name = "broker_passive_damage_vs_heavy_staggered",
			identifier = "broker_passive_damage_vs_heavy_staggered",
		},
	},
	broker_passive_reduced_damage_by_toxined = {
		description = "loc_talent_broker_passive_reduced_damage_by_toxined_desc",
		display_name = "loc_talent_broker_passive_reduced_damage_by_toxined",
		name = "broker_passive_reduced_damage_by_toxined",
		format_values = {
			default = {
				format_type = "percentage",
				value = talent_settings.broker_passive_reduced_damage_by_toxined.default_damage_debuff,
			},
			monster = {
				format_type = "percentage",
				value = talent_settings.broker_passive_reduced_damage_by_toxined.monster_damage_debuff,
			},
			toxin = {
				format_type = "loc_string",
				value = "loc_term_glossary_broker_toxin",
			},
		},
		passive = {
			buff_template_name = "broker_passive_reduced_damage_by_toxined",
			identifier = "broker_passive_reduced_damage_by_toxined",
		},
	},
	broker_passive_stun_on_max_toxin_stacks = {
		description = "loc_talent_broker_passive_stun_on_max_toxin_stacks_desc",
		display_name = "loc_talent_broker_passive_stun_on_max_toxin_stacks",
		name = "broker_passive_stun_on_max_toxin_stacks",
		format_values = {
			duration = {
				format_type = "number",
				value = talent_settings.broker_passive_stun_on_max_toxin_stacks.duration,
			},
			toxin = {
				format_type = "loc_string",
				value = "loc_term_glossary_broker_toxin",
			},
		},
		passive = {
			buff_template_name = "broker_passive_stun_on_max_toxin_stacks",
			identifier = "broker_passive_stun_on_max_toxin_stacks",
		},
	},
	broker_passive_damage_after_toxined_enemies = {
		description = "loc_talent_broker_damage_after_toxined_enemies_desc",
		display_name = "loc_talent_broker_damage_after_toxined_enemies",
		name = "broker_passive_damage_after_toxined_enemies",
		format_values = {
			damage = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_damage_after_toxined_enemies.damage_per_stack,
			},
			damage_max = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_damage_after_toxined_enemies.max_increase,
			},
			toxin = {
				format_type = "loc_string",
				value = "loc_term_glossary_broker_toxin",
			},
		},
		passive = {
			buff_template_name = "broker_passive_damage_after_toxined_enemies",
			identifier = "broker_passive_damage_after_toxined_enemies",
		},
	},
	broker_passive_toughness_on_toxined_kill = {
		description = "loc_talent_broker_toughness_on_toxined_kill_desc",
		display_name = "loc_talent_broker_toughness_on_toxined_kill",
		name = "broker_passive_toughness_on_toxined_kill",
		format_values = {
			toxin = {
				format_type = "loc_string",
				value = "loc_term_glossary_broker_toxin",
			},
			toughness = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_toughness_on_toxined_kill.toughness_replenish,
			},
		},
		passive = {
			buff_template_name = "broker_passive_toughness_on_toxined_kill",
			identifier = "broker_passive_toughness_on_toxined_kill",
		},
	},
	broker_passive_increased_toxin_damage = {
		description = "loc_talent_broker_passive_increased_toxin_damage_desc",
		display_name = "loc_talent_broker_passive_increased_toxin_damage",
		name = "broker_passive_toughness_on_toxined_kill",
		format_values = {
			damage = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_passive_increased_toxin_damage.increase,
			},
		},
		passive = {
			buff_template_name = "broker_passive_increased_toxin_damage",
			identifier = "broker_passive_increased_toxin_damage",
		},
	},
	broker_passive_low_ammo_regen = {
		description = "loc_talent_broker_passive_low_ammo_regen_desc",
		display_name = "loc_talent_broker_passive_low_ammo_regen",
		name = "broker_passive_low_ammo_regen",
		format_values = {
			ammo_threshold = {
				format_type = "percentage",
				prefix = "+",
				find_value = {
					buff_template_name = "broker_passive_low_ammo_regen",
					find_value_type = "buff_template",
					path = {
						"ammo_threshold",
					},
				},
			},
		},
		passive = {
			buff_template_name = "broker_passive_low_ammo_regen",
			identifier = "broker_passive_low_ammo_regen",
		},
	},
	broker_passive_melee_attacks_apply_toxin = {
		description = "loc_talent_broker_passive_melee_attacks_apply_toxin_desc",
		display_name = "loc_talent_broker_passive_melee_attacks_apply_toxin",
		name = "broker_passive_melee_attacks_apply_toxin",
		format_values = {
			stacks = {
				format_type = "value",
				find_value = {
					buff_template_name = "broker_passive_melee_attacks_apply_toxin",
					find_value_type = "buff_template",
					path = {
						"stacks_to_add",
					},
				},
			},
			toxin = {
				format_type = "loc_string",
				value = "loc_term_glossary_broker_toxin",
			},
		},
		passive = {
			buff_template_name = "broker_passive_melee_attacks_apply_toxin",
			identifier = "broker_passive_melee_attacks_apply_toxin",
		},
	},
	broker_passive_blitz_inflicts_toxin = {
		description = "loc_talent_broker_passive_blitz_inflicts_toxin_desc",
		display_name = "loc_talent_broker_passive_blitz_inflicts_toxin",
		name = "broker_passive_blitz_inflicts_toxin",
		format_values = {
			stacks = {
				format_type = "value",
				find_value = {
					buff_template_name = "broker_passive_blitz_inflicts_toxin",
					find_value_type = "buff_template",
					path = {
						"stacks_to_add",
					},
				},
			},
			toxin = {
				format_type = "loc_string",
				value = "loc_term_glossary_broker_toxin",
			},
		},
		passive = {
			buff_template_name = "broker_passive_blitz_inflicts_toxin",
			identifier = "broker_passive_blitz_inflicts_toxin",
		},
	},
	broker_keystone_vultures_mark_on_kill = {
		description = "loc_talent_broker_keystone_vultures_mark_on_kill_desc",
		display_name = "loc_talent_broker_keystone_vultures_mark_on_kill",
		name = "",
		format_values = {
			duration = {
				format_type = "number",
				value = talent_settings.broker_keystone_vultures_mark_on_kill.duration,
			},
			max_stacks = {
				format_type = "number",
				value = talent_settings.broker_keystone_vultures_mark_on_kill.max_stacks,
			},
			ranged_damage = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_keystone_vultures_mark_on_kill.ranged_damage,
			},
			crit_chance = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_keystone_vultures_mark_on_kill.crit_chance,
			},
			movement_speed = {
				format_type = "percentage",
				prefix = "+",
				value = talent_settings.broker_keystone_vultures_mark_on_kill.movement_speed,
			},
			toughness = {
				format_type = "percentage",
				value = talent_settings.broker_keystone_vultures_mark_on_kill.toughness_percent,
			},
		},
		passive = {
			buff_template_name = "broker_keystone_vultures_mark_on_kill",
			identifier = "broker_keystone_vultures_mark_on_kill",
		},
	},
	broker_keystone_vultures_mark_aoe_stagger = {
		description = "loc_talent_broker_keystone_vultures_mark_aoe_stagger_desc",
		display_name = "loc_talent_broker_keystone_vultures_mark_aoe_stagger",
		name = "",
		passive = {
			buff_template_name = "broker_keystone_vultures_mark_aoe_stagger",
			identifier = "broker_keystone_vultures_mark_aoe_stagger",
		},
	},
	broker_keystone_vultures_mark_increased_duration = {
		description = "loc_talent_broker_keystone_vultures_mark_increased_duration_desc",
		display_name = "loc_talent_broker_keystone_vultures_mark_increased_duration",
		name = "",
		format_values = {
			duration = {
				format_type = "number",
				value = talent_settings.broker_keystone_vultures_mark_increased_duration.duration,
			},
		},
		special_rule = {
			identifier = "broker_keystone_vultures_mark_increased_duration",
			special_rule_name = special_rules.broker_keystone_vultures_mark_increased_duration,
		},
	},
	broker_keystone_vultures_mark_dodge_on_ranged_crit = {
		description = "loc_talent_broker_keystone_vultures_mark_dodge_on_ranged_crit_desc",
		display_name = "loc_talent_broker_keystone_vultures_mark_dodge_on_ranged_crit",
		name = "",
		format_values = {
			duration = {
				format_type = "number",
				value = talent_settings.broker_keystone_vultures_mark_dodge_on_ranged_crit.duration,
			},
		},
		passive = {
			buff_template_name = "broker_keystone_vultures_mark_dodge_on_ranged_crit",
			identifier = "broker_keystone_vultures_mark_dodge_on_ranged_crit",
		},
	},
	broker_keystone_chemical_dependency = {
		description = "loc_talent_broker_keystone_chemical_dependency_desc",
		display_name = "loc_talent_broker_keystone_chemical_dependency",
		name = "broker_keystone_chemical_dependency",
		format_values = {
			dependency = {
				format_type = "loc_string",
				value = "loc_term_glossary_chemical_dependency",
			},
			duration = {
				format_type = "number",
				find_value = {
					buff_template_name = "broker_keystone_chemical_dependency_stack",
					find_value_type = "buff_template",
					path = {
						"duration",
					},
				},
			},
			cooldown_reduction = {
				format_type = "percentage",
				prefix = "+",
				find_value = {
					buff_template_name = "broker_keystone_chemical_dependency_stack",
					find_value_type = "buff_template",
					path = {
						"stat_buffs",
						stat_buffs.combat_ability_cooldown_regen_modifier,
					},
				},
			},
			max_stacks = {
				format_type = "number",
				find_value = {
					buff_template_name = "broker_keystone_chemical_dependency_stack",
					find_value_type = "buff_template",
					path = {
						"max_stacks",
					},
				},
			},
		},
		passive = {
			buff_template_name = "broker_keystone_chemical_dependency",
			identifier = "broker_keystone_chemical_dependency",
		},
	},
	broker_keystone_chemical_dependency_sub_1 = {
		description = "loc_talent_broker_keystone_chemical_dependency_sub_1_desc",
		display_name = "loc_talent_broker_keystone_chemical_dependency_sub_1",
		name = "broker_keystone_chemical_dependency_sub_1",
		format_values = {
			dependency = {
				format_type = "loc_string",
				value = "loc_term_glossary_chemical_dependency",
			},
			critical_chance = {
				format_type = "percentage",
				prefix = "+",
				find_value = {
					buff_template_name = "broker_keystone_chemical_dependency_stack",
					find_value_type = "buff_template",
					path = {
						"conditional_stat_buffs",
						stat_buffs.critical_strike_chance,
					},
				},
			},
		},
		special_rule = {
			identifier = "broker_keystone_chemical_dependency_sub_1_crit_chance",
			special_rule_name = special_rules.broker_keystone_chemical_dependency_sub_1_crit_chance,
		},
	},
	broker_keystone_chemical_dependency_sub_2 = {
		description = "loc_talent_broker_keystone_chemical_dependency_sub_2_desc",
		display_name = "loc_talent_broker_keystone_chemical_dependency_sub_2",
		name = "broker_keystone_chemical_dependency_sub_2",
		format_values = {
			toughness = {
				format_type = "percentage",
				find_value = {
					buff_template_name = "broker_keystone_chemical_dependency",
					find_value_type = "buff_template",
					path = {
						"sub_2_toughness_grant",
					},
				},
			},
			dependency = {
				format_type = "loc_string",
				value = "loc_term_glossary_chemical_dependency",
			},
			toughness_damage_reduction = {
				format_type = "percentage",
				prefix = "+",
				find_value = {
					buff_template_name = "broker_keystone_chemical_dependency_stack",
					find_value_type = "buff_template",
					path = {
						"conditional_stat_buffs",
						stat_buffs.toughness_damage_taken_multiplier,
					},
				},
				value_manipulation = function (value)
					return (1 - value) * 100
				end,
			},
		},
		special_rule = {
			identifier = "broker_keystone_chemical_dependency_sub_2_toughness",
			special_rule_name = special_rules.broker_keystone_chemical_dependency_sub_2_toughness,
		},
	},
	broker_keystone_chemical_dependency_sub_3 = {
		description = "loc_talent_broker_keystone_chemical_dependency_sub_3_desc",
		display_name = "loc_talent_broker_keystone_chemical_dependency_sub_3",
		name = "broker_keystone_chemical_dependency_sub_3",
		format_values = {
			dependency = {
				format_type = "loc_string",
				value = "loc_term_glossary_chemical_dependency",
			},
			duration = {
				format_value = "number",
				find_value = {
					buff_template_name = "broker_keystone_chemical_dependency_stack",
					find_value_type = "buff_template",
					path = {
						"sub_3_duration",
					},
				},
			},
			max_stacks = {
				format_type = "number",
				find_value = {
					buff_template_name = "broker_keystone_chemical_dependency_stack",
					find_value_type = "buff_template",
					path = {
						"sub_3_max_stacks",
					},
				},
			},
		},
		special_rule = {
			identifier = "broker_keystone_chemical_dependency_sub_3_duration",
			special_rule_name = special_rules.broker_keystone_chemical_dependency_sub_3_duration,
		},
	},
	broker_keystone_adrenaline_junkie = {
		description = "loc_talent_broker_keystone_adrenaline_junkie_desc",
		display_name = "loc_talent_broker_keystone_adrenaline_junkie",
		name = "Adrenaline Junkie",
		format_values = {
			on_crit = {
				format_type = "number",
				prefix = "+",
				find_value = {
					buff_template_name = "broker_keystone_adrenaline_junkie",
					find_value_type = "buff_template",
					path = {
						"crit_grant",
					},
				},
			},
			duration = {
				format_type = "number",
				find_value = {
					buff_template_name = "broker_keystone_adrenaline_junkie_stack",
					find_value_type = "buff_template",
					path = {
						"duration",
					},
				},
			},
			max_stacks = {
				format_type = "number",
				find_value = {
					buff_template_name = "broker_keystone_adrenaline_junkie_stack",
					find_value_type = "buff_template",
					path = {
						"max_stacks",
					},
				},
			},
			frenzy = {
				format_type = "loc_string",
				value = "loc_term_glossary_adrenaline_frenzy",
			},
			adrenaline = {
				format_type = "loc_string",
				value = "loc_term_glossary_adrenaline",
			},
			attack_speed = {
				format_type = "percentage",
				prefix = "+",
				find_value = {
					buff_template_name = "broker_keystone_adrenaline_junkie_proc",
					find_value_type = "buff_template",
					path = {
						"stat_buffs",
						stat_buffs.melee_attack_speed,
					},
				},
			},
			melee_damage = {
				format_type = "percentage",
				prefix = "+",
				find_value = {
					buff_template_name = "broker_keystone_adrenaline_junkie_proc",
					find_value_type = "buff_template",
					path = {
						"stat_buffs",
						stat_buffs.melee_damage,
					},
				},
			},
			frenzy_duration = {
				format_type = "number",
				find_value = {
					buff_template_name = "broker_keystone_adrenaline_junkie_proc",
					find_value_type = "buff_template",
					path = {
						"duration",
					},
				},
			},
		},
		passive = {
			buff_template_name = "broker_keystone_adrenaline_junkie",
			identifier = "broker_keystone_adrenaline_junkie",
		},
	},
	broker_keystone_adrenaline_junkie_sub_1 = {
		description = "loc_talent_broker_keystone_adrenaline_junkie_sub_1_desc",
		display_name = "loc_talent_broker_keystone_adrenaline_junkie_sub_1",
		name = "broker_keystone_adrenaline_junkie_sub_1",
		format_values = {
			stacks = {
				format_type = "number",
				prefix = "+",
				find_value = {
					buff_template_name = "broker_keystone_adrenaline_junkie",
					find_value_type = "buff_template",
					path = {
						"sub_1_weakspot_additional_grant",
					},
				},
			},
			adrenaline = {
				format_type = "loc_string",
				value = "loc_term_glossary_adrenaline",
			},
		},
		special_rule = {
			identifier = {
				"broker_keystone_adrenaline_junkie_no_regular_stacks",
			},
			special_rule_name = {
				special_rules.broker_keystone_adrenaline_junkie_no_regular_stacks,
			},
		},
	},
	broker_keystone_adrenaline_junkie_sub_2 = {
		description = "loc_talent_broker_keystone_adrenaline_junkie_sub_2_desc",
		display_name = "loc_talent_broker_keystone_adrenaline_junkie_sub_2",
		name = "broker_keystone_adrenaline_junkie_sub_2",
		format_values = {
			stacks = {
				format_type = "number",
				prefix = "+",
				find_value = {
					buff_template_name = "broker_keystone_adrenaline_junkie",
					find_value_type = "buff_template",
					path = {
						"sub_2_kill_additional_grant",
					},
				},
			},
			elite_stacks = {
				format_type = "number",
				prefix = "+",
				find_value = {
					buff_template_name = "broker_keystone_adrenaline_junkie",
					find_value_type = "buff_template",
					path = {
						"sub_2_kill_additional_elite_grant",
					},
				},
			},
			adrenaline = {
				format_type = "loc_string",
				value = "loc_term_glossary_adrenaline",
			},
		},
		special_rule = {
			identifier = {
				"broker_keystone_adrenaline_junkie_extra_killing_blow_stacks",
			},
			special_rule_name = {
				special_rules.broker_keystone_adrenaline_junkie_extra_killing_blow_stacks,
			},
		},
	},
	broker_keystone_adrenaline_junkie_sub_3 = {
		description = "loc_talent_broker_keystone_adrenaline_junkie_sub_3_desc",
		display_name = "loc_talent_broker_keystone_adrenaline_junkie_sub_3",
		name = "broker_keystone_adrenaline_junkie_sub_3",
		format_values = {
			frenzy = {
				format_type = "loc_string",
				value = "loc_term_glossary_adrenaline_frenzy",
			},
			duration = {
				format_type = "number",
				find_value = {
					buff_template_name = "broker_keystone_adrenaline_junkie_proc",
					find_value_type = "buff_template",
					path = {
						"sub_3_frenzy_duration",
					},
				},
			},
		},
		special_rule = {
			identifier = {
				"broker_keystone_adrenaline_junkie_extra_duration",
			},
			special_rule_name = {
				special_rules.broker_keystone_adrenaline_junkie_extra_duration,
			},
		},
	},
	broker_keystone_adrenaline_junkie_sub_4 = {
		description = "loc_talent_broker_keystone_adrenaline_junkie_sub_4_desc",
		display_name = "loc_talent_broker_keystone_adrenaline_junkie_sub_4",
		name = "broker_keystone_adrenaline_junkie_sub_4",
		format_values = {
			adrenaline = {
				format_type = "loc_string",
				value = "loc_term_glossary_adrenaline",
			},
			duration = {
				format_type = "number",
				find_value = {
					buff_template_name = "broker_keystone_adrenaline_junkie_stack",
					find_value_type = "buff_template",
					path = {
						"sub_4_duration",
					},
				},
			},
		},
		special_rule = {
			identifier = {
				"broker_keystone_adrenaline_junkie_stack_extra_duration",
			},
			special_rule_name = {
				special_rules.broker_keystone_adrenaline_junkie_stack_extra_duration,
			},
		},
	},
	broker_keystone_adrenaline_junkie_sub_5 = {
		description = "loc_talent_broker_keystone_adrenaline_junkie_sub_5_desc",
		display_name = "loc_talent_broker_keystone_adrenaline_junkie_sub_5",
		name = "broker_keystone_adrenaline_junkie_sub_5",
		format_values = {
			frenzy = {
				format_type = "loc_string",
				value = "loc_term_glossary_adrenaline_frenzy",
			},
			toughness = {
				format_type = "percentage",
				find_value = {
					buff_template_name = "broker_keystone_adrenaline_junkie_proc",
					find_value_type = "buff_template",
					path = {
						"sub_5_toughness_per_tick",
					},
				},
			},
		},
		special_rule = {
			identifier = {
				"broker_keystone_adrenaline_junkie_restore_toughness",
			},
			special_rule_name = {
				special_rules.broker_keystone_adrenaline_junkie_restore_toughness,
			},
		},
	},
	broker_stimm_description_talent = {
		description = "loc_talent_broker_stimm_desc",
		display_name = "",
		name = "",
		format_values = {
			stimm_lab = {
				format_type = "loc_string",
				value = "loc_broker_stimm_builder_view_display_name",
			},
			broker_stimm = {
				format_type = "loc_string",
				value = "loc_talent_broker_stimm",
			},
		},
	},
	broker_stimm_activation_talent = {
		description = "loc_talent_broker_stimm_activation_talent_desc",
		display_name = "loc_talent_broker_stimm_activation_talent",
		name = "",
	},
}

for talent_name, data in pairs(stimm_talent_settings) do
	archetype_talents.talents[talent_name] = table.clone(data.talent_data)
end

return archetype_talents
