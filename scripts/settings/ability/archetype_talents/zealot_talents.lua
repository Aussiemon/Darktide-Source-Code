-- chunkname: @scripts/settings/ability/archetype_talents/zealot_talents.lua

local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local talent_settings = TalentSettings.zealot
local talent_settings_1 = TalentSettings.zealot_1
local talent_settings_2 = TalentSettings.zealot_2
local talent_settings_3 = TalentSettings.zealot_3
local special_rules = SpecialRulesSetting.special_rules
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
	archetype = "zealot",
	talents = {
		zealot_dash = {
			description = "loc_talent_zealot_2_combat_description_new",
			display_name = "loc_talent_zealot_2_combat",
			large_icon = "content/ui/textures/icons/talents/zealot/zealot_ability_chastise_the_wicked",
			name = "Chastise the Wicked",
			format_values = {
				damage = {
					format_type = "percentage",
					value = talent_settings_2.combat_ability.melee_damage,
				},
				toughness = {
					format_type = "percentage",
					value = talent_settings_2.combat_ability.toughness,
				},
				cooldown = {
					format_type = "number",
					value = PlayerAbilities.zealot_targeted_dash.cooldown,
				},
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.zealot_targeted_dash,
			},
		},
		zealot_shock_grenade = {
			description = "loc_ability_shock_grenade_description",
			display_name = "loc_ability_shock_grenade",
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			icon = "content/ui/textures/icons/talents/zealot/zealot_blitz_stun_grenade",
			name = "G-Ability - Shock Grenade",
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.zealot_shock_grenade,
			},
		},
		zealot_improved_stun_grenade = {
			description = "loc_zealot_improved_stun_grenade_desc",
			display_name = "loc_zealot_improved_stun_grenade",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_5_2",
			name = "Improved Stun Grenade",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_ability_shock_grenade",
				},
				radius = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "zealot_improved_stun_grenade",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.explosion_radius_modifier_shock,
						},
					},
				},
			},
			passive = {
				buff_template_name = "zealot_improved_stun_grenade",
				identifier = "zealot_improved_stun_grenade",
			},
		},
		zealot_bolstering_prayer = {
			description = "loc_talent_zealot_bolstering_prayer_variant_two_description",
			display_name = "loc_talent_zealot_bolstering_prayer",
			large_icon = "content/ui/textures/icons/talents/zealot_3/zealot_3_combat",
			name = "Bolstering Prayer",
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings_3.bolstering_prayer.toughness_percentage + talent_settings_3.bolstering_prayer.team_toughness,
				},
				team_toughness = {
					format_type = "percentage",
					value = talent_settings_3.bolstering_prayer.team_toughness,
				},
				self_toughness = {
					format_type = "percentage",
					value = talent_settings_3.bolstering_prayer.self_toughness,
				},
				flat_toughness = {
					format_type = "number",
					prefix = "+",
					find_value = {
						buff_template_name = "zealot_channel_toughness_bonus",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_bonus_flat,
						},
					},
				},
				max_toughness = {
					format_type = "number",
					prefix = "+",
					find_value = {
						buff_template_name = "zealot_channel_toughness_bonus",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_bonus_flat,
						},
					},
					value_manipulation = function (value)
						return math.abs(value) * 5
					end,
				},
				interval = {
					format_type = "number",
					value = talent_settings_3.bolstering_prayer.tick_rate,
				},
				stacks = {
					format_type = "number",
					value = PlayerAbilities.zealot_relic.max_charges,
				},
				cooldown = {
					format_type = "number",
					value = PlayerAbilities.zealot_relic.cooldown,
				},
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.zealot_relic,
			},
		},
		zealot_flame_grenade = {
			description = "loc_talent_ability_fire_grenade_desc",
			display_name = "loc_talent_ability_fire_grenade",
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			icon = "content/ui/textures/icons/talents/zealot_3/zealot_3_tactical",
			name = "G-Ability - Flame Grenade",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_ability_fire_grenade",
				},
			},
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.zealot_fire_grenade,
			},
			dev_info = {
				{
					info_func = "text",
					value = "liquid_area:",
				},
				{
					damage_profile_name = "liquid_area_fire_burning",
					info_func = "damage_profile",
				},
			},
			passive = {
				buff_template_name = "zealot_flame_grenade_thrown",
				identifier = "zealot_flame_grenade_thrown",
			},
		},
		zealot_throwing_knives = {
			description = "loc_ability_zealot_throwing_knifes_desc",
			display_name = "loc_ability_zealot_throwing_knifes",
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tactical",
			name = "G-Ability - Throwing Knives",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_ability_zealot_throwing_knifes",
				},
				refill_amount = {
					format_type = "number",
					value = talent_settings_2.throwing_knives.melee_kill_refill_amount,
				},
			},
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.zealot_throwing_knives,
			},
			special_rule = {
				identifier = {
					"no_grenades",
					"ammo_gives_grenades",
					"quick_throw_grenades",
				},
				special_rule_name = {
					special_rules.disable_grenade_pickups,
					special_rules.ammo_pickups_refills_grenades,
					special_rules.enable_quick_throw_grenades,
				},
			},
			passive = {
				buff_template_name = "zealot_passive_replenish_throwing_knives_from_melee_kills",
				identifier = "zealot_passive_replenish_throwing_knives_from_melee_kills",
			},
			dev_info = {
				{
					damage_profile_name = "zealot_throwing_knives",
					info_func = "damage_profile",
				},
			},
		},
		zealot_stealth = {
			description = "loc_ability_zealot_stealth_description",
			display_name = "loc_ability_zealot_stealth",
			large_icon = "content/ui/textures/icons/talents/zealot_1/zealot_1_combat",
			name = "Zealot Stealth",
			format_values = {
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "zealot_invisibility",
						find_value_type = "buff_template",
						path = {
							"duration",
						},
					},
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_ability_zealot_stealth",
				},
				movement_speed = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "zealot_invisibility",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.movement_speed,
						},
					},
				},
				backstab_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "zealot_invisibility",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.backstab_damage,
						},
					},
				},
				finesse_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "zealot_invisibility",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.finesse_modifier_bonus,
						},
					},
				},
				crit_chance = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "zealot_invisibility",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.critical_strike_chance,
						},
					},
				},
				cooldown = {
					format_type = "number",
					value = PlayerAbilities.zealot_invisibility.cooldown,
				},
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.zealot_invisibility,
			},
		},
		zealot_bleed_generates_throwing_knife = {
			description = "loc_talent_zealot_bleed_generates_throwing_knife_desc",
			display_name = "loc_talent_zealot_bleed_generates_throwing_knife",
			icon = "",
			name = "Bleed Generates Knives",
			format_values = {
				chance = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "zealot_throwing_knife_on_bleed_kill",
						find_value_type = "buff_template",
						path = {
							"proc_events",
							proc_events.on_minion_death,
						},
					},
				},
			},
			passive = {
				buff_template_name = "zealot_throwing_knife_on_bleed_kill",
				identifier = "zealot_throwing_knife_on_bleed_kill",
			},
		},
		zealot_crits_grant_cd = {
			description = "loc_talent_maniac_cooldown_on_melee_crits_buff_desc",
			display_name = "loc_talent_maniac_cooldown_on_melee_crits",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_5_2",
			name = "Melee Crits grants Cooldown",
			format_values = {
				time = {
					format_type = "value",
					value = talent_settings_2.combat_ability_1.time,
				},
				duration = {
					format_type = "number",
					value = 4,
				},
				cooldown_regen = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings.crits_grants_cd.cooldown_regen,
				},
			},
			passive = {
				buff_template_name = "zealot_combat_ability_crits_reduce_cooldown",
				identifier = "zealot_combat_ability_crits_reduce_cooldown",
			},
		},
		zealot_attack_speed_post_ability = {
			description = "loc_talent_zealot_attack_speed_after_dash_desc",
			display_name = "loc_talent_maniac_attack_speed_after_dash",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_6_2",
			name = "Gain attack speed after charge",
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_2.combat_ability.melee_damage,
				},
				toughness = {
					format_type = "percentage",
					value = talent_settings_2.combat_ability.toughness,
				},
				attack_speed = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_2.combat_ability_2.attack_speed,
				},
				time = {
					format_type = "value",
					value = talent_settings_2.combat_ability_2.active_duration,
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_zealot_2_combat",
				},
				cooldown = {
					format_type = "number",
					value = PlayerAbilities.zealot_targeted_dash_improved.cooldown,
				},
			},
			passive = {
				buff_template_name = "zealot_combat_ability_attack_speed_increase",
				identifier = "zealot_combat_ability_attack_speed_increase",
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.zealot_targeted_dash_improved,
			},
		},
		zealot_additional_charge_of_ability = {
			description = "loc_talent_zealot_dash_has_more_charges_desc",
			display_name = "loc_talent_zealot_dash_has_more_charges",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_6_3",
			name = "Gain an additional charge of Combat Ability",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_maniac_attack_speed_after_dash",
				},
				charges = {
					format_type = "number",
					value = talent_settings_2.combat_ability_3.max_charges,
				},
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.zealot_targeted_dash_improved_double,
			},
		},
		zealot_increased_duration = {
			description = "loc_talent_zealot_increased_stealth_duration_description",
			display_name = "loc_talent_zealot_increased_stealth_duration",
			icon = "content/ui/textures/icons/talents/zealot_1/zealot_1_tier_5_1",
			name = "Increases duration of Stealth by X seconds.",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_ability_zealot_stealth",
				},
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "zealot_invisibility",
						find_value_type = "buff_template",
						path = {
							"duration",
						},
					},
				},
				duration_2 = {
					format_type = "number",
					find_value = {
						buff_template_name = "zealot_invisibility_increased_duration",
						find_value_type = "buff_template",
						path = {
							"duration",
						},
					},
				},
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.zealot_invisibility_improved,
			},
		},
		zealot_stealth_more_cd_more_damage = {
			description = "loc_talent_zealot_stealth_increased_damage_description",
			display_name = "loc_talent_zealot_stealth_increased_damage",
			icon = "content/ui/textures/icons/talents/zealot_1/zealot_1_tier_5_2",
			name = "Increase cooldown for Stealth by X00%. Increases damage bonus to Y00%.",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_ability_zealot_stealth",
				},
				cooldown = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "zealot_increase_ability_cooldown_increase_bonus",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.ability_cooldown_modifier,
						},
					},
				},
				damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "zealot_increase_ability_cooldown_increase_bonus",
						find_value_type = "buff_template",
						path = {
							"conditional_stat_buffs",
							stat_buffs.finesse_modifier_bonus,
						},
					},
					value_manipulation = function (value)
						return value * 100
					end,
				},
				damage_2 = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "zealot_increase_ability_cooldown_increase_bonus",
						find_value_type = "buff_template",
						path = {
							"conditional_stat_buffs",
							stat_buffs.backstab_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "zealot_increase_ability_cooldown_increase_bonus",
				identifier = "zealot_increase_ability_cooldown_increase_bonus",
			},
		},
		zealot_leaving_stealth_restores_toughness = {
			description = "loc_talent_zealot_leaving_stealth_restores_toughness_desc",
			display_name = "loc_talent_zealot_leaving_stealth_restores_toughness",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_base_3",
			name = "Leaving Stealth restores toughness over time + reduces damage taken.",
			format_values = {
				toughness = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "zealot_leaving_stealth_restores_toughness",
						find_value_type = "buff_template",
						path = {
							"total_toughness_restored",
						},
					},
				},
				time = {
					format_type = "value",
					find_value = {
						buff_template_name = "zealot_leaving_stealth_restores_toughness",
						find_value_type = "buff_template",
						path = {
							"duration",
						},
					},
				},
				damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "zealot_leaving_stealth_restores_toughness",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.damage_taken_multiplier,
						},
					},
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end,
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_ability_zealot_stealth",
				},
			},
			special_rule = {
				identifier = "zealot_leaving_stealth_restores_toughness",
				special_rule_name = special_rules.zealot_leave_stealth_toughness_regen,
			},
		},
		zealot_restore_stealth_cd_on_damage = {
			description = "loc_talent_zealot_damage_taken_restores_cd_description",
			display_name = "loc_talent_zealot_damage_taken_restores_cd",
			icon = "content/ui/textures/icons/talents/zealot_1/zealot_1_tier_2_3",
			name = "Taking damage restores ability cooldown based on damage taken",
			format_values = {
				cooldown_restore = {
					format_type = "percentage",
					value = talent_settings_3.combat_ability_cd_restore_on_damage.damage_taken_to_ability_cd_percentage,
				},
			},
			passive = {
				buff_template_name = "zealot_ability_cooldown_on_heavy_melee_damage",
				identifier = "zealot_ability_cooldown_on_heavy_melee_damage",
			},
		},
		zealot_channel_staggers = {
			description = "loc_talent_zealot_channel_staggers_desc",
			display_name = "loc_talent_zealot_channel_staggers",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_base_3",
			name = "Bolstering Prayer staggers enemies while active.",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_zealot_bolstering_prayer",
				},
			},
			special_rule = {
				identifier = "zealot_channel_staggers",
				special_rule_name = special_rules.zealot_channel_staggers,
			},
		},
		zealot_channel_grants_damage = {
			description = "loc_talent_zealot_zealot_channel_grants_offensive_buff_desc",
			display_name = "loc_talent_zealot_zealot_channel_grants_offensive_buff",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_base_3",
			name = "Bolstering Prayer grants a stacking damage buff",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_zealot_bolstering_prayer",
				},
				damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "zealot_channel_damage",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.damage,
						},
					},
				},
				max_stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "zealot_channel_damage",
						find_value_type = "buff_template",
						path = {
							"max_stacks",
						},
					},
				},
				stacks = {
					format_type = "number",
					value = 5,
				},
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "zealot_channel_damage",
						find_value_type = "buff_template",
						path = {
							"duration",
						},
					},
				},
			},
			special_rule = {
				identifier = "zealot_channel_grants_offensive_buff",
				special_rule_name = special_rules.zealot_channel_grants_offensive_buff,
			},
		},
		zealot_channel_grants_toughness_damage_reduction = {
			description = "loc_talent_zealot_zealot_channel_grants_defensive_buff_desc",
			display_name = "loc_talent_zealot_zealot_channel_grants_defensive_buff",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_base_3",
			name = "Bolstering Prayer grants a stacking toughness damage reduction buff",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_zealot_bolstering_prayer",
				},
				toughness = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "zealot_channel_toughness_damage_reduction",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_multiplier,
						},
					},
					value_manipulation = function (value)
						return (1 - value) * 100
					end,
				},
				max_stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "zealot_channel_toughness_damage_reduction",
						find_value_type = "buff_template",
						path = {
							"max_stacks",
						},
					},
				},
				stacks = {
					format_type = "number",
					value = 5,
				},
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "zealot_channel_toughness_damage_reduction",
						find_value_type = "buff_template",
						path = {
							"duration",
						},
					},
				},
			},
			special_rule = {
				identifier = "zealot_channel_grants_defensive_buff",
				special_rule_name = special_rules.zealot_channel_grants_defensive_buff,
			},
		},
		zealot_toughness_damage_coherency = {
			description = "loc_talent_zealot_aura_toughness_damage_coherency_desc",
			display_name = "loc_talent_zealot_2_base_3",
			icon = "content/ui/textures/icons/talents/zealot/zealot_aura_the_emperor_will",
			name = "Aura - Reduced toughness damage taken",
			format_values = {
				damage_reduction = {
					format_type = "percentage",
					num_decimals = 1,
					prefix = "+",
					value = 1 - talent_settings_2.coherency.toughness_damage_taken_multiplier,
				},
			},
			coherency = {
				buff_template_name = "zealot_coherency_toughness_damage_resistance",
				identifier = "zealot_aura",
				priority = 1,
			},
			passive = {
				buff_template_name = "zealot_toughness_on_aura_tracking_buff",
				identifier = "zealot_toughness_on_aura_tracking_buff",
			},
		},
		zealot_toughness_damage_reduction_coherency_improved = {
			description = "loc_talent_zealot_toughness_aura_efficiency_desc",
			display_name = "loc_talent_zealot_aura_efficiency",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_4_2",
			name = "Stronger Coherency",
			format_values = {
				damage_reduction = {
					format_type = "percentage",
					prefix = "+",
					value = 1 - talent_settings_2.coop_2.toughness_damage_taken_multiplier,
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_zealot_2_base_3",
				},
			},
			coherency = {
				buff_template_name = "zealot_coherency_toughness_damage_resistance_improved",
				identifier = "zealot_aura",
				priority = 2,
			},
			passive = {
				buff_template_name = "zealot_improved_toughness_on_aura_tracking_buff",
				identifier = "zealot_improved_toughness_on_aura_tracking_buff",
			},
		},
		zealot_corruption_healing_coherency = {
			description = "loc_talent_zealot_corruption_aura_description",
			display_name = "loc_talent_zealot_corruption_aura",
			icon = "content/ui/textures/icons/talents/zealot_3/zealot_3_aura",
			name = "Aura: Corruption Healing",
			coherency = {
				buff_template_name = "zealot_preacher_coherency_corruption_healing",
				identifier = "zealot_aura",
				priority = 1,
			},
		},
		zealot_corruption_healing_coherency_improved = {
			description = "loc_talent_zealot_corruption_healing_coherency_improved_desc",
			display_name = "loc_talent_zealot_corruption_healing_coherency_improved",
			icon = "content/ui/textures/icons/talents/zealot_3/zealot_3_tier_4_2",
			name = "Greatly increase the efficiency of your Aura",
			format_values = {
				corruption = {
					format_type = "number",
					value = talent_settings_3.coop_2.corruption_heal_amount_increased,
				},
				interval = {
					format_type = "number",
					value = talent_settings_3.coop_2.interval,
				},
			},
			coherency = {
				buff_template_name = "zealot_preacher_coherency_corruption_healing_improved",
				identifier = "zealot_aura",
				priority = 2,
			},
		},
		zealot_always_in_coherency = {
			description = "loc_talent_zealot_always_in_coherency_description",
			display_name = "loc_talent_zealot_always_in_coherency",
			icon = "content/ui/textures/icons/talents/zealot_1/zealot_1_base_3",
			name = "Aura: Always count as in at least 2 coherency",
			format_values = {
				coherency_min_stack = {
					format_type = "number",
					value = talent_settings_1.coherency.toughness_min_stack_override,
				},
			},
			special_rule = {
				identifier = "zealot_always_at_least_one_coherency",
				special_rule_name = special_rules.zealot_always_at_least_one_coherency,
			},
			coherency = {
				buff_template_name = "zealot_always_in_coherency_buff",
				identifier = "zealot_aura",
				priority = 2,
			},
			passive = {
				buff_template_name = "zealot_backstab_kills_while_loner_aura_tracking_buff",
				identifier = "zealot_backstab_kills_while_loner_aura_tracking_buff",
			},
		},
		zealot_always_in_coherency_improved = {
			description = "loc_ability_zealot_pious_stabguy_tier_3_ability_2_description",
			display_name = "loc_ability_zealot_pious_stabguy_tier_3_ability_2",
			icon = "content/ui/textures/icons/talents/zealot_1/zealot_1_tier_3_2",
			name = "Count as in at least 3 coherency",
			special_rule = {
				identifier = "zealot_always_at_least_two_coherency",
				special_rule_name = special_rules.zealot_always_at_least_two_coherency,
			},
			coherency = {
				buff_template_name = "zealot_always_in_coherency_buff",
				identifier = "zealot_aura",
				priority = 2,
			},
		},
		zealot_martyrdom = {
			description = "loc_talent_zealot_martyrdom_desc",
			display_name = "loc_talent_zealot_martyrdom",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_base_3",
			name = "Martyrdom - For each x% health missing, gain martyrdom (damage)",
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_2.passive_1.damage_per_step,
				},
				max_wounds = {
					format_type = "number",
					value = talent_settings_2.passive_1.martyrdom_max_stacks,
				},
			},
			passive = {
				buff_template_name = "zealot_martyrdom_base",
				identifier = "zealot_martyrdom_base",
			},
		},
		zealot_quickness_passive = {
			description = "loc_talent_zealot_quickness_desc",
			display_name = "loc_talent_zealot_quickness",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_base_3",
			name = "Moving grants stacks. On Hit gain Attack Speed and Rate of Fire per stack",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_zealot_quickness",
				},
				max_stacks = {
					format_type = "number",
					value = talent_settings_3.quickness.max_stacks,
				},
				melee_attack_speed = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "zealot_quickness_active",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_attack_speed,
						},
					},
				},
				ranged_attack_speed = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "zealot_quickness_active",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.ranged_attack_speed,
						},
					},
				},
				damage_modifier = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "zealot_quickness_active",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.damage,
						},
					},
				},
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "zealot_quickness_active",
						find_value_type = "buff_template",
						path = {
							"duration",
						},
					},
				},
			},
			passive = {
				buff_template_name = "zealot_quickness_passive",
				identifier = "zealot_quickness_passive",
			},
		},
		zealot_quickness_passive_dodge_stacks = {
			description = "loc_talent_zealot_quickness_dodge_stacks_desc",
			display_name = "loc_talent_zealot_quickness_dodge_stacks",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_base_3",
			name = "Successful dodges grant Quickness stacks",
			format_values = {
				stacks = {
					format_type = "number",
					value = talent_settings_3.quickness.dodge_stacks,
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_zealot_quickness",
				},
			},
			special_rule = {
				identifier = "zealot_quickness_passive_dodge_stacks",
				special_rule_name = special_rules.zealot_quickness_dodge_stacks,
			},
		},
		zealot_quickness_toughness_per_stack = {
			description = "loc_talent_zealot_quickness_toughness_per_stack_desc",
			display_name = "loc_talent_zealot_quickness_toughness_per_stack",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_base_3",
			name = "Replenish toughness per stack on activation",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_zealot_quickness",
				},
				toughness = {
					format_type = "percentage",
					value = talent_settings_3.quickness.toughness_percentage,
				},
			},
			special_rule = {
				identifier = "zealot_quickness_toughness_per_stack",
				special_rule_name = special_rules.zealot_quickness_toughness_per_stack,
			},
		},
		zealot_fanatic_rage = {
			description = "loc_talent_zealot_fanatic_rage_desc",
			display_name = "loc_talent_zealot_fanatic_rage",
			icon = "content/ui/textures/icons/talents/zealot_3/zealot_3_base_1",
			name = "Fanatic Rage - Enemies dying grants fury. Gain Crit at max stacks",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_zealot_fanatic_rage",
				},
				radius = {
					format_type = "number",
					value = talent_settings_3.passive_1.max_dist,
				},
				max_stacks = {
					format_type = "number",
					value = talent_settings_3.passive_1.max_resource,
				},
				duration = {
					format_type = "number",
					value = talent_settings_3.passive_1.duration,
				},
				crit_chance = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_3.passive_1.crit_chance,
				},
			},
			passive = {
				buff_template_name = "zealot_fanatic_rage",
				identifier = "zealot_fanatic_rage",
			},
		},
		zealot_fanatic_rage_improved = {
			description = "loc_talent_zealot_fanatic_rage_improved_desc",
			display_name = "loc_talent_zealot_fanatic_rage_improved",
			icon = "content/ui/textures/icons/talents/zealot_3/zealot_3_tier_5_2",
			name = "Fanatic Rage crit chance increased to X%",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_zealot_fanatic_rage",
				},
				crit_chance = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_3.spec_passive_2.crit_chance,
				},
			},
			special_rule = {
				identifier = "zealot_preacher_increased_crit_chance",
				special_rule_name = special_rules.zealot_preacher_increased_crit_chance,
			},
		},
		zealot_fanatic_rage_stacks_on_crit = {
			description = "loc_talent_zealot_fanatic_rage_crits_desc",
			display_name = "loc_talent_zealot_fanatic_rage_crits",
			icon = "content/ui/textures/icons/talents/zealot_3/zealot_3_tier_5_3",
			name = "Your critical hits grant a stack of fury",
			special_rule = {
				identifier = "zealot_preacher_crits_grants_stack",
				special_rule_name = special_rules.zealot_preacher_crits_grants_stack,
			},
		},
		zealot_fanatic_rage_toughness_on_max = {
			description = "loc_talent_zealot_fanatic_rage_toughness_reduction_desc",
			display_name = "loc_talent_zealot_fanatic_rage_toughness",
			icon = "content/ui/textures/icons/talents/zealot_3/zealot_3_tier_5_3",
			name = "Fanatic Rage restores toughness on full stacks",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_zealot_fanatic_rage",
				},
				toughness = {
					format_type = "percentage",
					value = talent_settings_3.passive_1.toughness_on_max_stacks,
				},
				toughness_damage_reduction = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "zealot_fanatic_rage",
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
				identifier = "zealot_fanatic_rage_toughness",
				special_rule_name = special_rules.zealot_fanatic_rage_toughness,
			},
		},
		zealot_shared_fanatic_rage = {
			description = "loc_talent_zealot_shared_fanatic_rage_desc",
			display_name = "loc_talent_zealot_shared_fanatic_rage",
			icon = "content/ui/textures/icons/talents/zealot_3/zealot_3_tier_2_2",
			name = "Allies in coherency gain a lesser version of your fanatic rage",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_zealot_fanatic_rage",
				},
				crit_chance = {
					format_type = "percentage",
					num_decimals = 0,
					prefix = "+",
					value = talent_settings_3.offensive_2.crit_share,
				},
			},
			special_rule = {
				identifier = "zealot_preacher_spread_fanatic_rage",
				special_rule_name = special_rules.zealot_preacher_spread_fanatic_rage,
			},
		},
		zealot_increased_stagger_on_weakspot_melee = {
			description = "loc_talent_zealot_increased_stagger_on_weakspot_melee_description",
			display_name = "loc_talent_zealot_increased_stagger_on_weakspot_melee",
			icon = "content/ui/textures/icons/talents/zealot_1/zealot_1_tier_1_3",
			name = "increased_weaskpot_impact",
			format_values = {
				impact_modifier = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "zealot_pious_stabguy_increased_weaskpot_impact",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_weakspot_impact_modifier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "zealot_pious_stabguy_increased_weaskpot_impact",
				identifier = "melee_weakspot_stagger_bonus",
			},
		},
		zealot_more_damage_when_low_on_stamina = {
			description = "loc_talent_zealot_increased_damage_on_low_stamina_description",
			display_name = "loc_talent_zealot_increased_damage_on_low_stamina",
			icon = "content/ui/textures/icons/talents/zealot_1/zealot_1_tier_1_2",
			name = "Increase melee damage when at low stamina",
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "zealot_melee_damage_on_stamina_depleted",
						find_value_type = "buff_template",
						path = {
							"proc_stat_buffs",
							stat_buffs.melee_damage,
						},
					},
				},
				duration = {
					format_type = "value",
					find_value = {
						buff_template_name = "zealot_melee_damage_on_stamina_depleted",
						find_value_type = "buff_template",
						path = {
							"active_duration",
						},
					},
				},
			},
			passive = {
				buff_template_name = "zealot_melee_damage_on_stamina_depleted",
				identifier = "zealot_melee_damage_on_stamina_depleted",
			},
		},
		zealot_backstab_kills_restore_cd = {
			description = "loc_talent_zealot_backstab_kills_restore_cd_description",
			display_name = "loc_talent_zealot_backstab_kills_restore_cd",
			icon = "content/ui/textures/icons/talents/zealot_1/zealot_1_tier_4_2",
			name = "Backstab kills refunds X% cooldown for Combat ability",
			format_values = {
				ability_cooldown = {
					format_type = "percentage",
					value = talent_settings_3.zealot_backstab_kills_restore_cd.combat_ability_cd_percentage,
				},
			},
			passive = {
				buff_template_name = "zealot_ability_cooldown_on_leaving_coherency_on_backstab",
				identifier = "zealot_ability_cooldown_on_leaving_coherency_on_backstab",
			},
		},
		zealot_increased_damage_when_flanking = {
			description = "loc_talent_zealot_increased_flanking_damage_description",
			display_name = "loc_talent_zealot_increased_flanking_damage",
			icon = "content/ui/textures/icons/talents/zealot_1/zealot_1_tier_4_3",
			name = "Increased damage when flanking",
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "zealot_flanking_damage",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.flanking_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "zealot_flanking_damage",
				identifier = "zealot_flanking_damage",
			},
		},
		zealot_increased_crit_and_weakspot_damage_after_dodge = {
			description = "loc_talent_zealot_increased_finesse_post_dodge_description",
			display_name = "loc_talent_zealot_increased_finesse_post_dodge",
			icon = "content/ui/textures/icons/talents/zealot_1/zealot_1_tier_1_1",
			name = "Increase crit and weakspot damage after successful dodge",
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "zealot_critstrike_damage_on_dodge",
						find_value_type = "buff_template",
						path = {
							"proc_stat_buffs",
							stat_buffs.weakspot_damage,
						},
					},
				},
				duration = {
					format_type = "value",
					find_value = {
						buff_template_name = "zealot_critstrike_damage_on_dodge",
						find_value_type = "buff_template",
						path = {
							"active_duration",
						},
					},
				},
			},
			passive = {
				buff_template_name = "zealot_critstrike_damage_on_dodge",
				identifier = "zealot_critstrike_damage_on_dodge",
			},
		},
		zealot_backstab_damage = {
			description = "loc_talent_zealot_increased_backstab_damage_description",
			display_name = "loc_talent_zealot_increased_backstab_damage",
			icon = "content/ui/textures/icons/talents/zealot_1/zealot_1_base_1",
			name = "Your backstab damage increased by X%.",
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "zealot_backstab_damage",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.backstab_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "zealot_backstab_damage",
				identifier = "zealot_backstab_damage",
			},
		},
		zealot_increased_damage_vs_resilient = {
			description = "loc_talent_zealot_3_passive_2_description",
			display_name = "loc_talent_zealot_3_passive_2",
			icon = "content/ui/textures/icons/talents/zealot_3/zealot_3_base_2",
			name = "Increased Damage vs Disgustingly Resilient",
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_3.passive_2.damage_vs_disgusting,
				},
			},
			passive = {
				buff_template_name = "zealot_preacher_damage_vs_disgusting",
				identifier = "zealot_preacher_damage_vs_disgusting",
			},
		},
		zealot_increased_impact = {
			description = "loc_talent_zealot_3_tier_1_ability_1_description",
			display_name = "loc_talent_zealot_3_tier_1_ability_1",
			icon = "content/ui/textures/icons/talents/zealot_3/zealot_3_tier_1_1",
			name = "Impact power level increased by 25%",
			format_values = {
				stagger = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_3.mixed_1.impact_modifier,
				},
			},
			passive = {
				buff_template_name = "zealot_preacher_impact_power",
				identifier = "zealot_preacher_impact_power",
			},
		},
		zealot_multi_hits_increase_damage = {
			description = "loc_talent_zealot_3_tier_2_ability_1_description",
			display_name = "loc_talent_zealot_3_tier_2_ability_1",
			icon = "content/ui/textures/icons/talents/zealot_3/zealot_3_tier_2_1",
			name = "For each enemy hit with a melee attack, your next melee attack deals X% increased damage. Maximum of 5 stacks.",
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_3.offensive_1.melee_damage,
				},
				max_stacks = {
					format_type = "value",
					value = talent_settings_3.offensive_1.max_stacks,
				},
			},
			passive = {
				buff_template_name = "zealot_preacher_melee_increase_next_melee_proc",
				identifier = "zealot_preacher_melee_increase_next_melee_proc",
			},
		},
		zealot_increased_cleave = {
			description = "loc_talent_zealot_3_tier_2_ability_3_description",
			display_name = "loc_talent_zealot_3_tier_2_ability_3",
			icon = "content/ui/textures/icons/talents/zealot_3/zealot_3_tier_2_3",
			name = "Increased cleave",
			format_values = {
				max_hit = {
					format_type = "percentage",
					value = talent_settings_3.offensive_3.max_hit_mass_impact_modifier,
				},
			},
			passive = {
				buff_template_name = "zealot_preacher_increased_cleave",
				identifier = "zealot_preacher_increased_cleave",
			},
		},
		zealot_attack_speed = {
			description = "loc_talent_zealot_attack_speed_desc",
			display_name = "loc_talent_zealot_attack_speed",
			hud_icon = "content/ui/materials/icons/abilities/default",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_base_4",
			name = "Increase Melee Attack Speed",
			format_values = {
				attack_speed = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_2.passive_3.melee_attack_speed,
				},
			},
			passive = {
				buff_template_name = "zealot_increased_melee_attack_speed",
				identifier = "zealot_increased_melee_attack_speed",
			},
		},
		zealot_crits_apply_bleed = {
			description = "loc_talent_zealot_bleed_melee_crit_chance_desc",
			display_name = "loc_talent_zealot_bleed_melee_crit_chance",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_2_1",
			name = "Crits apply bleed. Hitting bleeding targets grants crit",
			format_values = {
				crit_chance = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_2.offensive_1.melee_critical_strike_chance,
				},
				duration = {
					format_type = "number",
					value = talent_settings_2.offensive_1.duration,
				},
				max_stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "zealot_bleeding_crits_effect",
						find_value_type = "buff_template",
						path = {
							"max_stacks",
						},
					},
				},
			},
			passive = {
				buff_template_name = "zealot_bleeding_crits",
				identifier = "zealot_bleeding_crits",
			},
			dev_info = {
				{
					info_func = "text",
					value = "Bleed: damage is at max stacks",
				},
				{
					buff_template_name = "bleed",
					info_func = "buff_template",
					values_to_show = {
						{
							format_type = "number",
							path = {
								"duration",
							},
						},
						{
							format_type = "number",
							path = {
								"interval",
							},
						},
						{
							format_type = "number",
							path = {
								"max_stacks",
							},
						},
					},
				},
				{
					damage_profile_name = "bleeding",
					info_func = "damage_profile",
				},
			},
		},
		zealot_multi_hits_grant_impact_and_uninterruptible = {
			description = "loc_talent_zealot_multi_hits_increase_impact_desc",
			display_name = "loc_talent_zealot_multi_hits_increase_impact",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_2_2_b",
			name = "Melee hits grant impact and uninterruptible",
			format_values = {
				min_hits = {
					format_type = "number",
					value = talent_settings_2.offensive_2.min_hits,
				},
				impact_modifier = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_2.offensive_2.impact_modifier,
				},
				time = {
					format_type = "number",
					value = talent_settings_2.offensive_2.duration,
				},
				max_stacks = {
					format_type = "number",
					value = talent_settings_2.offensive_2.max_stacks,
				},
			},
			passive = {
				buff_template_name = "zealot_multi_hits_increase_impact",
				identifier = "zealot_multi_hits_increase_impact",
			},
		},
		zealot_martyrdom_grants_attack_speed = {
			description = "loc_talent_zealot_attack_speed_per_martyrdom_desc",
			display_name = "loc_talent_zealot_attack_speed_per_martyrdom",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_2_3",
			name = "Martyrdom grants attack speed",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_zealot_martyrdom",
				},
				attack_speed = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_2.offensive_3.attack_speed_per_segment,
				},
			},
			passive = {
				buff_template_name = "zealot_martyrdom_attack_speed",
				identifier = "zealot_martyrdom_attack_speed",
			},
		},
		zealot_improved_weapon_handling_after_dodge = {
			description = "loc_talent_zealot_improved_spread_post_dodge_desc",
			display_name = "loc_talent_zealot_improved_spread_post_dodge",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_base_3",
			name = "Successful dodging drastically improves spread and recoil",
			format_values = {
				duration = {
					format_type = "value",
					find_value = {
						buff_template_name = "zealot_improved_weapon_handling_after_dodge",
						find_value_type = "buff_template",
						path = {
							"active_duration",
						},
					},
				},
				spread = {
					format_type = "percentage",
					prefix = "-",
					find_value = {
						buff_template_name = "zealot_improved_weapon_handling_after_dodge",
						find_value_type = "buff_template",
						path = {
							"proc_stat_buffs",
							stat_buffs.spread_modifier,
						},
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end,
				},
				recoil = {
					format_type = "percentage",
					prefix = "-",
					find_value = {
						buff_template_name = "zealot_improved_weapon_handling_after_dodge",
						find_value_type = "buff_template",
						path = {
							"proc_stat_buffs",
							stat_buffs.recoil_modifier,
						},
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end,
				},
			},
			passive = {
				buff_template_name = "zealot_improved_weapon_handling_after_dodge",
				identifier = "zealot_improved_weapon_handling_after_dodge",
			},
		},
		zealot_improved_melee_after_no_ammo = {
			description = "loc_talent_zealot_improved_melee_after_no_ammo_desc",
			display_name = "loc_talent_zealot_improved_melee_after_no_ammo",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_base_3",
			name = "Increased Impact and Attack Speed after emptying a clip",
			format_values = {
				impact = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "zealot_improved_weapon_swapping_impact",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_impact_modifier,
						},
					},
				},
				attack_speed = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "zealot_improved_weapon_swapping_impact",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_attack_speed,
						},
					},
				},
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "zealot_improved_weapon_swapping_impact",
						find_value_type = "buff_template",
						path = {
							"duration",
						},
					},
				},
			},
			passive = {
				buff_template_name = "zealot_improved_weapon_swapping_no_ammo",
				identifier = "zealot_improved_weapon_swapping_no_ammo",
			},
		},
		zealot_increased_reload_speed_on_melee_kills = {
			description = "loc_talent_zealot_increased_reload_speed_on_melee_kills_desc",
			display_name = "loc_talent_zealot_increased_reload_speed_on_melee_kills",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_base_3",
			name = "Melee Kills increase Reload Speed of next Reload",
			format_values = {
				reload_speed = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "zealot_improved_weapon_swapping_reload_speed_buff",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.reload_speed,
						},
					},
				},
				max_stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "zealot_improved_weapon_swapping_reload_speed_buff",
						find_value_type = "buff_template",
						path = {
							"max_stacks",
						},
					},
				},
			},
			passive = {
				buff_template_name = "zealot_improved_weapon_swapping_melee_kills_reload_speed",
				identifier = "zealot_improved_weapon_swapping_melee_kills_reload_speed",
			},
		},
		zealot_increase_ranged_close_damage = {
			description = "loc_talent_zealot_ranged_damage_increased_to_close_desc",
			display_name = "loc_talent_zealot_ranged_damage_increased_to_close",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_5_1_b",
			name = "Deal between x% and y% ranged damage based on the proximity to the target",
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_2.offensive_2_1.damage,
				},
			},
			passive = {
				buff_template_name = "zealot_close_ranged_damage",
				identifier = "zealot_close_ranged_damage",
			},
		},
		zealot_hits_grant_stacking_damage = {
			description = "loc_talent_zealot_increased_damage_stacks_on_hit_desc",
			display_name = "loc_talent_zealot_increased_damage_stacks_on_hit",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_5_1",
			name = "Hits grant stacking damage buff",
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_2.offensive_2_2.melee_damage,
				},
				time = {
					format_type = "number",
					value = talent_settings_2.offensive_2_2.duration,
				},
				amount = {
					format_type = "number",
					value = talent_settings_2.offensive_2_2.max_stacks,
				},
			},
			passive = {
				buff_template_name = "zealot_stacking_melee_damage",
				identifier = "zealot_stacking_melee_damage",
			},
		},
		zealot_reduced_sprint_cost = {
			description = "loc_talent_zealot_reduced_sprint_cost_description",
			display_name = "loc_talent_zealot_reduced_sprint_cost",
			icon = "content/ui/textures/icons/talents/zealot_1/zealot_1_base_2",
			name = "Reduced stamina cost  from sprinting",
			format_values = {
				cost = {
					format_type = "percentage",
					prefix = "-",
					find_value = {
						buff_template_name = "zealot_sprinting_cost_reduction",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.sprinting_cost_multiplier,
						},
					},
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end,
				},
			},
			passive = {
				buff_template_name = "zealot_sprinting_cost_reduction",
				identifier = "zealot_sprinting_cost_reduction",
			},
		},
		zealot_reduced_damage_after_dodge = {
			description = "loc_talent_reduced_damage_after_dodge_description",
			display_name = "loc_talent_reduced_damage_after_dodge",
			icon = "content/ui/textures/icons/talents/zealot_1/zealot_1_tier_2_1",
			name = "Reduced damage taken after dodge",
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "zealot_damage_reduction_after_dodge",
						find_value_type = "buff_template",
						path = {
							"proc_stat_buffs",
							stat_buffs.damage_taken_multiplier,
						},
					},
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end,
				},
				duration = {
					format_type = "value",
					find_value = {
						buff_template_name = "zealot_damage_reduction_after_dodge",
						find_value_type = "buff_template",
						path = {
							"active_duration",
						},
					},
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end,
				},
			},
			passive = {
				buff_template_name = "zealot_damage_reduction_after_dodge",
				identifier = "zealot_damage_reduction_after_dodge",
			},
		},
		zealot_improved_sprint = {
			description = "loc_talent_zealot_improved_sprint_description",
			display_name = "loc_talent_zealot_improved_sprint",
			icon = "content/ui/textures/icons/talents/zealot_1/zealot_1_tier_2_2",
			name = "Increase sprint speed. Always count as dodging when sprinting defensively",
			format_values = {
				speed = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "zealot_increased_sprint_speed",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.sprint_movement_speed,
						},
					},
				},
			},
			passive = {
				buff_template_name = "zealot_increased_sprint_speed",
				identifier = "zealot_increased_sprint_speed",
			},
		},
		zealot_reduced_corruption_damage_taken = {
			description = "loc_talent_zealot_3_passive_3_description",
			display_name = "loc_talent_zealot_3_passive_3",
			icon = "content/ui/textures/icons/talents/zealot_3/zealot_3_base_3",
			name = "Reduced corruption damage taken",
			format_values = {
				format_type = "percentage",
				corruption_reduction = {
					value = talent_settings_3.passive_3.corruption_taken_multiplier,
				},
			},
			passive = {
				buff_template_name = "zealot_preacher_reduce_corruption_damage",
				identifier = "zealot_preacher_reduce_corruption_damage",
			},
		},
		zealot_additional_wounds = {
			description = "loc_talent_zealot_3_tier_1_ability_3_description",
			display_name = "loc_talent_zealot_3_tier_1_ability_3",
			icon = "content/ui/textures/icons/talents/zealot_3/zealot_3_tier_1_3",
			name = "Gain 2 more health segments (wounds)",
			format_values = {
				health_segment = {
					format_type = "value",
					prefix = "+",
					value = talent_settings_3.mixed_3.extra_max_amount_of_wounds,
				},
			},
			passive = {
				buff_template_name = "zealot_preacher_more_segments",
				identifier = "zealot_preacher_more_segments",
			},
		},
		zealot_resist_death = {
			description = "loc_talent_zealot_resist_death_desc",
			display_name = "loc_talent_zealot_resist_death",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_base_2",
			name = "Upon taking lethal damage, gain resist death for Xs",
			format_values = {
				cooldown_duration = {
					format_type = "number",
					value = talent_settings_2.passive_2.cooldown_duration,
				},
				active_duration = {
					format_type = "number",
					value = talent_settings_2.passive_2.active_duration,
				},
			},
			passive = {
				buff_template_name = "zealot_resist_death",
				identifier = "zealot_resist_death",
			},
		},
		zealot_more_toughness_on_melee = {
			description = "loc_talent_zealot_toughness_on_melee_kill_desc",
			display_name = "loc_talent_zealot_toughness_on_melee_kill",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_3_2",
			name = "Toughness on Melee Kills",
			format_values = {
				toughness = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "zealot_increased_toughness_recovery_from_kills",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.toughness_melee_replenish,
						},
					},
				},
			},
			passive = {
				buff_template_name = "zealot_increased_toughness_recovery_from_kills",
				identifier = "zealot_increased_toughness_recovery_from_kills",
			},
		},
		zealot_toughness_on_heavy_kills = {
			description = "loc_talent_zealot_toughness_on_heavy_kills_desc",
			display_name = "loc_talent_zealot_toughness_on_heavy_kills",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_3_2",
			name = "Toughness on Heavy Melee Kills",
			format_values = {
				toughness = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "zealot_toughness_on_heavy_kills",
						find_value_type = "buff_template",
						path = {
							"toughness_percentage",
						},
					},
				},
			},
			passive = {
				buff_template_name = "zealot_toughness_on_heavy_kills",
				identifier = "zealot_toughness_on_heavy_kills",
			},
		},
		zealot_increased_coherency_toughness = {
			description = "loc_talent_zealot_increased_coherency_regen_desc",
			display_name = "loc_talent_zealot_increased_coherency_regen",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_3_2",
			name = "Increased coherency regen",
			format_values = {
				toughness = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "zealot_increased_coherency_regen",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_coherency_regen_rate_modifier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "zealot_increased_coherency_regen",
				identifier = "zealot_increased_coherency_regen",
			},
		},
		zealot_toughness_on_dodge = {
			description = "loc_talent_zealot_toughness_on_dodge_desc",
			display_name = "loc_talent_zealot_toughness_on_dodge",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_3_2",
			name = "Toughness on Successful Dodge",
			format_values = {
				toughness = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "zealot_toughness_on_dodge",
						find_value_type = "buff_template",
						path = {
							"toughness_percentage",
						},
					},
				},
			},
			passive = {
				buff_template_name = "zealot_toughness_on_dodge",
				identifier = "zealot_toughness_on_dodge",
			},
		},
		zealot_toughness_on_ranged_kill = {
			description = "loc_talent_zealot_toughness_on_ranged_kill_desc",
			display_name = "loc_talent_zealot_toughness_on_ranged_kill",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_3_2",
			name = "Toughness on Ranged Kills",
			format_values = {
				toughness = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "zealot_toughness_on_ranged_kill",
						find_value_type = "buff_template",
						path = {
							"toughness_percentage",
						},
					},
				},
			},
			passive = {
				buff_template_name = "zealot_toughness_on_ranged_kill",
				identifier = "zealot_toughness_on_ranged_kill",
			},
		},
		zealot_crits_reduce_toughness_damage = {
			description = "loc_talent_zealot_toughness_melee_effectiveness_desc",
			display_name = "loc_talent_zealot_toughness_melee_effectiveness",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_5_3",
			name = "critical hits reduce toughness damage taken",
			format_values = {
				toughness_damage_reduction = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_2.toughness_2.toughness_damage_taken_multiplier,
				},
				time = {
					format_type = "number",
					value = talent_settings_2.toughness_2.duration,
				},
			},
			passive = {
				buff_template_name = "zealot_reduced_toughness_damage_taken_on_critical_strike_hits",
				identifier = "zealot_reduced_toughness_damage_taken_on_critical_strike_hits",
			},
		},
		zealot_toughness_in_melee = {
			description = "loc_talent_zealot_toughness_regen_in_melee_desc",
			display_name = "loc_talent_zealot_toughness_regen_in_melee",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_4_1",
			name = "Toughness in Melee",
			format_values = {
				toughness = {
					format_type = "percentage",
					num_decimals = 1,
					find_value = {
						buff_template_name = "zealot_toughness_regen_in_melee",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"toughness_percentage",
						},
					},
				},
				range = {
					format_type = "number",
					value = talent_settings_2.toughness_3.range,
				},
				num_enemies = {
					format_type = "number",
					value = talent_settings_2.toughness_3.num_enemies,
				},
			},
			passive = {
				buff_template_name = "zealot_toughness_regen_in_melee",
				identifier = "zealot_toughness_regen_in_melee",
			},
		},
		zealot_resist_death_healing = {
			description = "loc_talent_zealot_heal_during_resist_death_clamped_desc",
			display_name = "loc_talent_zealot_heal_during_resist_death",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_6_1",
			name = "Heal during Resist Death",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_zealot_resist_death",
				},
				melee_multiplier = {
					format_type = "number",
					value = talent_settings_2.defensive_1.melee_multiplier,
				},
				max_health = {
					format_type = "percentage",
					value = 0.25,
				},
			},
			passive = {
				buff_template_name = "zealot_resist_death_improved_with_leech",
				identifier = "zealot_resist_death",
			},
		},
		zealot_damage_boosts_movement = {
			description = "loc_talent_zealot_movement_speed_on_damaged_desc",
			display_name = "loc_talent_zealot_movement_speed_on_damaged",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_3_3",
			name = "Taking damage increases movement + immune to stun",
			format_values = {
				movement_speed = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_2.defensive_2.movement_speed,
				},
				time = {
					format_type = "number",
					value = talent_settings_2.defensive_2.active_duration,
				},
			},
			passive = {
				buff_template_name = "zealot_movement_enhanced",
				identifier = "zealot_movement_enhanced",
			},
		},
		zealot_heal_part_of_damage_taken = {
			description = "loc_talent_zealot_heal_damage_taken_desc",
			display_name = "loc_talent_zealot_heal_damage_taken",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_4_3_b",
			name = "Heal part of damage taken over time",
			format_values = {
				damage_reduction = {
					format_type = "percentage",
					value = talent_settings_2.defensive_3.recuperate_percentage,
				},
				time = {
					format_type = "number",
					value = talent_settings_2.defensive_3.duration,
				},
			},
			passive = {
				buff_template_name = "zealot_recuperate_a_portion_of_damage_taken",
				identifier = "zealot_recuperate_a_portion_of_damage_taken",
			},
		},
		zealot_defensive_knockback = {
			description = "loc_talent_zealot_3_tier_3_ability_1_description",
			display_name = "loc_talent_zealot_3_tier_3_ability_1",
			icon = "content/ui/textures/icons/talents/zealot_3/zealot_3_tier_3_1",
			name = "On melee hit taken, knock back in attacker direction",
			format_values = {
				cooldown = {
					format_type = "value",
					value = talent_settings_3.defensive_1.cooldown_duration,
				},
			},
			passive = {
				buff_template_name = "zealot_preacher_push_on_hit",
				identifier = "zealot_preacher_push_on_hit",
			},
		},
		zealot_reduced_damage_on_wound = {
			description = "loc_talent_zealot_3_tier_3_ability_2_description",
			display_name = "loc_talent_zealot_3_tier_3_ability_2",
			icon = "content/ui/textures/icons/talents/zealot_3/zealot_3_tier_3_2",
			name = "Reduce damage of damage that would go below 1 segment",
			format_values = {
				damage_reduction = {
					format_type = "percentage",
					value = 1 - talent_settings_3.defensive_2.health_segment_damage_taken_multiplier,
				},
			},
			passive = {
				buff_template_name = "zealot_preacher_segment_breaking_half_damage",
				identifier = "zealot_preacher_segment_breaking_half_damage",
			},
		},
		zealot_martyrdom_grants_toughness = {
			description = "loc_talent_zealot_martyrdom_grants_toughness_desc",
			display_name = "loc_talent_zealot_martyrdom_grants_toughness",
			icon = "content/ui/textures/icons/talents/zealot_3/zealot_3_tier_3_3",
			name = "Gain X% toughness damage reduction per Martrydom stack",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_zealot_martyrdom",
				},
				toughness_damage_reduction = {
					format_type = "percentage",
					prefix = "+",
					value = math.abs(talent_settings_2.passive_1.toughness_reduction_per_stack),
				},
			},
			passive = {
				buff_template_name = "zealot_martyrdom_toughness",
				identifier = "zealot_martyrdom_toughness",
			},
		},
		zealot_combat_ability_grants_ally_toughness = {
			description = "loc_talent_maniac_ability_grants_toughness_to_allies_desc",
			display_name = "loc_talent_maniac_ability_grants_toughness_to_allies",
			icon = "content/ui/textures/icons/talents/zealot_2/zealot_2_tier_4_3",
			name = "Combat Ability restores toughness to allies",
			format_values = {
				toughness = talent_settings_2.coop_3.toughness * 100,
			},
			passive = {
				buff_template_name = "zealot_toughness_on_combat_ability",
				identifier = "zealot_toughness_on_combat_ability",
			},
		},
		zealot_ally_damage_taken_reduced = {
			description = "loc_talent_zealot_3_tier_4_ability_3_description",
			display_name = "loc_talent_zealot_3_tier_4_ability_3",
			icon = "content/ui/textures/icons/talents/zealot_3/zealot_3_tier_4_3",
			name = "Whenever an ally in coherency takes damage, they gain  damage reduction",
			format_values = {
				damage_reduction = {
					format_type = "percentage",
					prefix = "+",
					value = 1 - talent_settings_3.coop_3.damage_taken_multiplier,
				},
				duration = {
					format_type = "value",
					value = talent_settings_3.coop_3.duration,
				},
				cooldown = {
					format_type = "value",
					value = talent_settings_3.coop_3.cooldown_duration,
				},
			},
			passive = {
				buff_template_name = "zealot_preacher_ally_defensive",
				identifier = "zealot_preacher_ally_defensive",
			},
		},
		zealot_restore_cd_on_coherency_leave = {
			description = "loc_ability_zealot_pious_stabguy_tier_3_ability_3_description",
			display_name = "loc_ability_zealot_pious_stabguy_tier_3_ability_3",
			icon = "content/ui/textures/icons/talents/zealot_1/zealot_1_tier_3_3",
			name = "Leaving allies coherency restores full cooldown of Stealth (internal cd)",
			passive = {
				buff_template_name = "zealot_ability_cooldown_on_leaving_coherency",
				identifier = "zealot_ability_cooldown_on_leaving_coherency",
			},
		},
	},
}

return archetype_talents
