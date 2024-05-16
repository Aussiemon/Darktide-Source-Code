-- chunkname: @scripts/settings/ability/archetype_talents/ogryn_talents.lua

local AbilityTemplates = require("scripts/settings/ability/ability_templates/ability_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local talent_settings_1 = TalentSettings.ogryn_1
local talent_settings_2 = TalentSettings.ogryn_2
local shared_talent_settings = TalentSettings.ogryn_shared
local special_rules = SpecialRulesSetting.special_rules
local stat_buffs = BuffSettings.stat_buffs
local ogryn_grenade_friend_rock = PlayerAbilities.ogryn_grenade_friend_rock
local ogryn_grenade_frag_ability = PlayerAbilities.ogryn_grenade_frag
local ogryn_ranged_stance = PlayerAbilities.ogryn_ranged_stance
local ogryn_grenade_box_cluster = ProjectileTemplates.ogryn_grenade_box_cluster
local ogryn_grenade_frag_explosion_template = ExplosionTemplates.ogryn_grenade_frag
local ogryn_taunt_shout = AbilityTemplates.ogryn_taunt_shout
local math_round = math.round

math_round = math_round or function (value)
	if value >= 0 then
		return math.floor(value + 0.5)
	else
		return math.ceil(value - 0.5)
	end
end

local archetype_talents = {
	archetype = "ogryn",
	talents = {
		ogryn_charge = {
			description = "loc_ability_ogryn_charge_description_new",
			display_name = "loc_ability_ogryn_charge",
			hud_icon = "content/ui/materials/icons/abilities/default",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_ability_bull_rush",
			large_icon = "content/ui/textures/icons/talents/ogryn/ogryn_ability_bull_rush",
			name = "Bull Rush - Charge forward, knocking enemies back. Grants movement speed and attack speed afterwards",
			format_values = {
				duration = {
					format_type = "number",
					value = talent_settings_2.combat_ability.active_duration,
				},
				attack_speed = {
					format_type = "percentage",
					value = talent_settings_2.combat_ability.melee_attack_speed,
				},
				move_speed = {
					format_type = "percentage",
					value = talent_settings_2.combat_ability.movement_speed,
				},
				cooldown = {
					format_type = "number",
					value = PlayerAbilities.ogryn_charge.cooldown,
				},
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.ogryn_charge,
			},
			passive = {
				identifier = {
					"ogryn_base_combat_ability_pasive",
					"ogryn_charge_speed_on_lunge",
				},
				buff_template_name = {
					"ogryn_base_lunge_toughness_and_damage_resistance",
					"ogryn_charge_speed_on_lunge",
				},
			},
		},
		ogryn_taunt_shout = {
			description = "loc_ability_ogryn_taunt_shout_desc",
			display_name = "loc_ability_ogryn_taunt_shout",
			hud_icon = "content/ui/materials/icons/abilities/default",
			large_icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_combat",
			name = "F-Ability - Stagger and Taunt surrounding enemies",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_ability_ogryn_taunt_shout",
				},
				radius = {
					format_type = "number",
					value = ogryn_taunt_shout.actions.action_shout.radius,
				},
				duration = {
					format_type = "number",
					find_value = {
						find_value_type = "buff_template",
						buff_template_name = ogryn_taunt_shout.actions.action_shout.buff_to_add,
						path = {
							"duration",
						},
					},
				},
				cooldown = {
					format_type = "number",
					value = PlayerAbilities.ogryn_taunt_shout.cooldown,
				},
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.ogryn_taunt_shout,
			},
		},
		ogryn_taunt_damage_taken_increase = {
			description = "loc_talent_ogryn_taunt_damage_taken_increase_description",
			display_name = "loc_talent_ogryn_taunt_damage_taken_increase",
			icon = "content/ui/textures/icons/talents/ogryn_1/ogryn_1_base_1",
			name = "Enemies you taunt take increased damage from all sources",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_ability_ogryn_taunt_shout",
				},
				base_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						find_value_type = "buff_template",
						buff_template_name = ogryn_taunt_shout.actions.action_shout.special_rule_buff_enemy,
						path = {
							"stat_buffs",
							stat_buffs.damage_taken_multiplier,
						},
					},
					value_manipulation = function (value)
						return (value - 1) * 100
					end,
				},
			},
			special_rule = {
				identifier = "shout_applies_buff_to_enemies",
				special_rule_name = special_rules.shout_applies_buff_to_enemies,
			},
		},
		ogryn_taunt_staggers_reduce_cooldown = {
			description = "loc_talent_ogryn_taunt_stagger_cd_description",
			display_name = "loc_talent_ogryn_taunt_stagger_cd",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_base_4",
			name = "Staggering enemies reduces the cooldown of your taunt",
			format_values = {
				cooldown_reduction = {
					format_type = "percentage",
					num_decimals = 1,
					find_value = {
						buff_template_name = "ogryn_taunt_staggers_reduce_cooldown",
						find_value_type = "buff_template",
						path = {
							"cooldown_reduction_percentage",
						},
					},
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_ability_ogryn_taunt_shout",
				},
			},
			passive = {
				buff_template_name = "ogryn_taunt_staggers_reduce_cooldown",
				identifier = "ogryn_taunt_staggers_reduce_cooldown",
			},
		},
		ogryn_taunt_radius_increase = {
			description = "loc_talent_ogryn_taunt_radius_increase_desc",
			display_name = "loc_talent_ogryn_taunt_radius_increase",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_base_4",
			name = "Staggering enemies reduces the cooldown of your taunt",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_ability_ogryn_taunt_shout",
				},
				radius = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "ogryn_taunt_radius_increase",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.shout_radius_modifier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "ogryn_taunt_radius_increase",
				identifier = "ogryn_taunt_radius_increase",
			},
		},
		ogryn_grenade_box = {
			description = "loc_ability_ogryn_grenade_box_description",
			display_name = "loc_ability_ogryn_grenade_box",
			hud_icon = "content/ui/materials/icons/abilities/throwables/default",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_blitz_big_box_of_hurt",
			name = "G-Ability - Ogryn Grenade Box",
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.ogryn_grenade_box,
			},
		},
		ogryn_grenade_friend_rock = {
			description = "loc_ability_ogryn_friend_rock_desc",
			display_name = "loc_ability_ogryn_friend_rock",
			hud_icon = "content/ui/textures/icons/abilities/hud/combat_ability_bonebreaker_hud",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tactical",
			name = "G-Ability - Big Friendly Rock (B.F Rock)",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_ability_ogryn_friend_rock",
				},
				base_damage = {
					format_type = "number",
					find_value = {
						damage_profile_name = "ogryn_grenade_box_impact",
						find_value_type = "base_damage",
					},
				},
				recharge = {
					format_type = "number",
					value = ogryn_grenade_friend_rock.cooldown,
				},
				max_charges = {
					format_type = "number",
					value = ogryn_grenade_friend_rock.max_charges,
				},
			},
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.ogryn_grenade_friend_rock,
			},
			passive = {
				buff_template_name = "ogryn_friend_grenade_replenishment",
				identifier = "ogryn_friend_grenade_replenishment",
			},
			special_rule = {
				identifier = "disable_grenade_pickups",
				special_rule_name = special_rules.disable_grenade_pickups,
			},
			dev_info = {
				{
					damage_profile_name = "ogryn_grenade_box_impact",
					info_func = "damage_profile",
				},
			},
		},
		ogryn_grenade_frag = {
			description = "loc_ability_ogryn_grenade_demolition_desc",
			display_name = "loc_ability_ogryn_grenade_demolition",
			hud_icon = "content/ui/textures/icons/abilities/hud/combat_ability_bonebreaker_hud",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tactical",
			name = "G-Ability - Demolition Frag Grenade (B.F Grenade)",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_ability_ogryn_grenade_demolition",
				},
				radius = {
					format_type = "number",
					value = ogryn_grenade_frag_explosion_template.radius,
				},
				base_damage = {
					format_type = "number",
					find_value = {
						damage_profile_name = "close_ogryn_grenade",
						find_value_type = "base_damage",
					},
				},
				max_charges = {
					format_type = "number",
					value = ogryn_grenade_frag_ability.max_charges,
				},
			},
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.ogryn_grenade_frag,
			},
			dev_info = {
				{
					damage_profile_name = "close_ogryn_grenade",
					info_func = "damage_profile",
				},
			},
			passive = {
				buff_template_name = "ogryn_frag_grenade_thrown",
				identifier = "ogryn_frag_grenade_thrown",
			},
		},
		ogryn_special_ammo = {
			description = "loc_talent_ogryn_combat_ability_special_ammo_desc",
			display_name = "loc_talent_ogryn_combat_ability_special_ammo",
			large_icon = "content/ui/textures/icons/talents/ogryn_1/ogryn_1_combat",
			name = "F-Ability - Enter a stance that reloads you ranged weapon with a custom magazine with 3 times capacity",
			format_values = {
				duration = {
					format_type = "number",
					find_value = {
						find_value_type = "buff_template",
						buff_template_name = ogryn_ranged_stance.ability_template_tweak_data.buff_to_add,
						path = {
							"duration",
						},
					},
				},
				ranged_attack_speed = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						find_value_type = "buff_template",
						buff_template_name = ogryn_ranged_stance.ability_template_tweak_data.buff_to_add,
						path = {
							"stat_buffs",
							stat_buffs.ranged_attack_speed,
						},
					},
				},
				reload_speed = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						find_value_type = "buff_template",
						buff_template_name = ogryn_ranged_stance.ability_template_tweak_data.buff_to_add,
						path = {
							"stat_buffs",
							stat_buffs.reload_speed,
						},
					},
				},
				cooldown = {
					format_type = "number",
					value = PlayerAbilities.ogryn_ranged_stance.cooldown,
				},
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.ogryn_ranged_stance,
			},
		},
		ogryn_leadbelcher_no_ammo_chance = {
			description = "loc_talent_ogryn_chance_to_not_consume_ammo_desc",
			display_name = "loc_talent_ogryn_chance_to_not_consume_ammo",
			icon = "content/ui/textures/icons/talents/ogryn_1/ogryn_1_base_1",
			name = "Leadbelcher: Chance not to consume ammo",
			format_values = {
				proc_chance = {
					format_type = "percentage",
					value = talent_settings_1.passive_1.free_ammo_proc_chance,
				},
			},
			special_rule = {
				identifier = "ogryn_no_ammo_consumption_passive",
				special_rule_name = special_rules.ogryn_leadbelcher,
			},
			passive = {
				buff_template_name = "ogryn_leadbelcher_aura_tracking_buff",
				identifier = "ogryn_leadbelcher_aura_tracking_buff",
			},
		},
		ogryn_leadbelcher_cooldown_reduction = {
			description = "loc_talent_ogryn_leadbelcher_grant_cooldown_reduction_desc",
			display_name = "loc_talent_ogryn_leadbelcher_grant_cooldown_reduction",
			icon = "content/ui/textures/icons/talents/ogryn_1/ogryn_1_tier_5_1",
			name = "Leadbelcher shots grants 5% cooldown reduction",
			format_values = {
				cooldown_reduction = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_1.spec_passive_1.increased_cooldown_regeneration,
				},
				duration = {
					format_type = "number",
					value = talent_settings_1.spec_passive_1.duration,
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_ogryn_chance_to_not_consume_ammo",
				},
			},
			passive = {
				buff_template_name = "ogryn_passive_proc_combat_ability_cooldown_reduction",
				identifier = "ogryn_passive_proc_combat_ability_cooldown_reduction",
			},
		},
		ogryn_leadbelcher_trigger_chance_increase = {
			description = "loc_talent_ogryn_increased_leadbelcher_chance_desc",
			display_name = "loc_talent_ogryn_increased_leadbelcher_chance",
			icon = "content/ui/textures/icons/talents/ogryn_1/ogryn_1_tier_5_2",
			name = "Increase Leadbelcher trigger chance to 12%",
			format_values = {
				proc_chance = {
					format_type = "percentage",
					value = talent_settings_1.spec_passive_2.increased_passive_proc_chance,
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_ogryn_chance_to_not_consume_ammo",
				},
			},
			special_rule = {
				identifier = "ogryn_no_ammo_consumption_passive",
				special_rule_name = special_rules.ogryn_leadbelcher_improved,
			},
		},
		ogryn_leadbelcher_crits = {
			description = "loc_talent_ogryn_critical_leadbelcher_desc",
			display_name = "loc_talent_ogryn_critical_leadbelcher",
			icon = "content/ui/textures/icons/talents/ogryn_1/ogryn_1_tier_5_3",
			name = "Leadbelcher shots are Critical.",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_ogryn_chance_to_not_consume_ammo",
				},
			},
			special_rule = {
				identifier = "ogryn_leadbelcher_auto_crit",
				special_rule_name = special_rules.ogryn_leadbelcher_auto_crit,
			},
		},
		ogryn_base_tank_passive = {
			description = "loc_talent_ogryn_2_base_3_description_new",
			display_name = "loc_talent_ogryn_2_base_3",
			hud_icon = "content/ui/materials/icons/abilities/default",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_base_3",
			name = "Tough skin - Reduces toughness damage taken by 50%. Reduces damage taken by 25%.",
			format_values = {
				toughness_reduction = {
					format_type = "percentage",
					prefix = "+",
					value = shared_talent_settings.tank.toughness_damage_taken_multiplier,
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end,
				},
				damage_reduction = {
					format_type = "percentage",
					prefix = "+",
					value = shared_talent_settings.tank.damage_taken_multiplier,
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end,
				},
			},
			passive = {
				buff_template_name = "ogryn_base_passive_tank",
				identifier = "ogryn_base_passive_tank",
			},
		},
		ogryn_helping_hand = {
			description = "loc_talent_bonebreaker_revive_uninterruptible_desc",
			display_name = "loc_talent_bonebreaker_revive_uninterruptible",
			hud_icon = "content/ui/materials/icons/abilities/default",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_base_4",
			name = "Helping Hand - Uninterruptible while reviving",
			format_values = {},
			passive = {
				buff_template_name = "ogryn_passive_revive",
				identifier = "ogryn_passive_revive",
			},
		},
		ogryn_passive_heavy_hitter = {
			description = "loc_talent_ogryn_passive_heavy_hitter_desc",
			display_name = "loc_talent_ogryn_passive_heavy_hitter",
			hud_icon = "content/ui/materials/icons/abilities/default",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_base_4",
			name = "Heavy Hitter - Heavy attacks grants damage for X seconds. Stacking.",
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "ogryn_heavy_hitter_damage_effect",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_damage,
						},
					},
				},
				stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "ogryn_heavy_hitter_damage_effect",
						find_value_type = "buff_template",
						path = {
							"max_stacks",
						},
					},
				},
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "ogryn_heavy_hitter_damage_effect",
						find_value_type = "buff_template",
						path = {
							"duration",
						},
					},
				},
			},
			passive = {
				buff_template_name = "ogryn_passive_heavy_hitter",
				identifier = "ogryn_passive_heavy_hitter",
			},
		},
		ogryn_heavy_hitter_light_attacks_refresh = {
			description = "loc_talent_ogryn_heavy_hitter_light_attacks_refresh_description",
			display_name = "loc_talent_ogryn_heavy_hitter_light_attacks_refresh",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_base_4",
			name = "Light attacks can refresh duration",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_ogryn_passive_heavy_hitter",
				},
			},
			special_rule = {
				identifier = "ogryn_heavy_hitter_light_attacks_refresh",
				special_rule_name = special_rules.ogryn_heavy_hitter_light_attacks_refresh_duration,
			},
		},
		ogryn_heavy_hitter_max_stacks_improves_attack_speed = {
			description = "loc_talent_ogryn_heavy_hitter_max_stacks_improves_attack_speed_description",
			display_name = "loc_talent_ogryn_heavy_hitter_max_stacks_improves_attack_speed",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_base_4",
			name = "At max stacks. Increase attack speed",
			format_values = {
				attack_speed = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "ogryn_heavy_hitter_attack_speed_effect",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.attack_speed,
						},
					},
				},
				stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "ogryn_heavy_hitter_damage_effect",
						find_value_type = "buff_template",
						path = {
							"max_stacks",
						},
					},
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_ogryn_passive_heavy_hitter",
				},
			},
			special_rule = {
				identifier = "ogryn_heavy_hitter_max_stacks_improves_attack_speed",
				special_rule_name = special_rules.ogryn_heavy_hitter_max_stacks_improves_attack_speed,
			},
		},
		ogryn_heavy_hitter_max_stacks_improves_toughness = {
			description = "loc_talent_ogryn_heavy_hitter_max_stacks_improves_toughness_description",
			display_name = "loc_talent_ogryn_heavy_hitter_max_stacks_improves_toughness",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_base_4",
			name = "At max stacks. Increase toughness gains",
			format_values = {
				toughness_melee_replenish = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "ogryn_heavy_hitter_toughness_regen_effect",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_melee_replenish,
						},
					},
				},
				stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "ogryn_heavy_hitter_damage_effect",
						find_value_type = "buff_template",
						path = {
							"max_stacks",
						},
					},
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_ogryn_passive_heavy_hitter",
				},
			},
			special_rule = {
				identifier = "ogryn_heavy_hitter_max_stacks_improves_toughness",
				special_rule_name = special_rules.ogryn_heavy_hitter_max_stacks_improves_toughness,
			},
		},
		ogryn_melee_damage_coherency = {
			description = "loc_talent_ogryn_2_base_4_description_new",
			display_name = "loc_talent_ogryn_2_base_4",
			icon = "content/ui/textures/icons/talents/ogryn/ogryn_aura_intimidating_presence",
			name = "Aura - Increased melee damage",
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_2.coherency.melee_damage,
				},
			},
			coherency = {
				buff_template_name = "ogryn_coherency_increased_melee_damage",
				identifier = "ogryn_aura",
				priority = 1,
			},
		},
		ogryn_melee_damage_coherency_improved = {
			description = "loc_talent_damage_aura_improved",
			display_name = "loc_talent_damage_aura",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_aura",
			name = "Aura - Increased melee damage",
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_2.coherency.melee_damage_improved,
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_ogryn_2_base_4",
				},
			},
			coherency = {
				buff_template_name = "ogryn_melee_damage_coherency_improved",
				identifier = "ogryn_aura",
				priority = 2,
			},
		},
		ogryn_damage_vs_suppressed_coherency = {
			description = "loc_talent_ogryn_damage_vs_suppressed_desc",
			display_name = "loc_talent_ogryn_damage_vs_suppressed",
			icon = "content/ui/textures/icons/talents/ogryn_1/ogryn_1_aura",
			name = "Aura - Increased Damage vs Suppressed",
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_1.aura.damage_vs_suppressed,
				},
			},
			coherency = {
				buff_template_name = "ogryn_aura_increased_damage_vs_suppressed",
				identifier = "ogryn_aura",
				priority = 2,
			},
		},
		ogryn_toughness_regen_aura = {
			description = "loc_talent_ogryn_toughness_regen_aura_desc",
			display_name = "loc_talent_ogryn_toughness_regen_aura",
			icon = "content/ui/textures/icons/talents/ogryn_1/ogryn_1_aura",
			name = "Aura - Toughness regen",
			format_values = {
				toughness_regen_rate_modifier = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "ogryn_toughness_regen_aura",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_regen_rate_modifier,
						},
					},
				},
			},
			coherency = {
				buff_template_name = "ogryn_toughness_regen_aura",
				identifier = "ogryn_aura",
				priority = 2,
			},
		},
		ogryn_movement_speed_after_ranged_kills = {
			description = "loc_talent_ogryn_ranged_kill_grant_movement_speed_desc",
			display_name = "loc_talent_ogryn_ranged_kill_grant_movement_speed",
			icon = "content/ui/textures/icons/talents/ogryn_1/ogryn_1_tier_3_2",
			name = "Ranged kills grant movement speed",
			format_values = {
				movement_speed = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_1.defensive_2.move_speed_on_ranged_kill,
				},
				duration = {
					format_type = "number",
					value = talent_settings_1.defensive_2.duration,
				},
			},
			passive = {
				buff_template_name = "ogryn_movement_speed_on_ranged_kill",
				identifier = "ogryn_movement_speed_on_ranged_kill",
			},
		},
		ogryn_toughness_while_bracing = {
			description = "loc_talent_ogryn_toughness_regen_while_bracing_desc",
			display_name = "loc_talent_ogryn_toughness_regen_while_bracing",
			icon = "content/ui/textures/icons/talents/ogryn_1/ogryn_1_tier_3_3",
			name = "Regenerate toughness while bracing.",
			format_values = {
				toughness_regen = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_1.defensive_3.braced_toughness_regen,
				},
			},
			passive = {
				buff_template_name = "ogryn_regen_toughness_on_braced",
				identifier = "ogryn_regen_toughness_on_braced",
			},
		},
		ogryn_increased_coherency_toughness = {
			description = "loc_talent_ogryn_coherency_toughness_increase_desc",
			display_name = "loc_talent_ogryn_coherency_toughness_increase",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_base_2",
			name = "Increased coherency toughness",
			format_values = {
				toughness_multiplier = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_2.toughness_1.toughness_bonus,
				},
			},
			passive = {
				buff_template_name = "ogryn_increased_coherency_regen",
				identifier = "ogryn_increased_coherency_regen",
			},
		},
		ogryn_single_heavy_toughness = {
			description = "loc_talent_ogryn_toughness_on_single_heavy_desc",
			display_name = "loc_talent_ogryn_toughness_on_single_heavy",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_1_2",
			name = "Toughness on single target heavies",
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings_2.toughness_2.toughness,
				},
			},
			passive = {
				buff_template_name = "ogryn_heavy_hits_toughness",
				identifier = "ogryn_heavy_hits_toughness",
			},
		},
		ogryn_multi_heavy_toughness = {
			description = "loc_talent_ogryn_toughness_on_multiple_desc",
			display_name = "loc_talent_ogryn_toughness_on_multiple",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_5_3",
			name = "Toughness on multi-target heavies",
			format_values = {
				toughness = {
					format_type = "percentage",
					value = talent_settings_2.toughness_3.toughness,
				},
			},
			passive = {
				buff_template_name = "ogryn_multiple_enemy_heavy_hits_restore_toughness",
				identifier = "ogryn_multiple_enemy_heavy_hits_restore_toughness",
			},
		},
		ogryn_nearby_bleeds_reduce_damage_taken = {
			description = "loc_talent_ogryn_damage_reduction_per_bleed_desc",
			display_name = "loc_talent_ogryn_damage_reduction_per_bleed",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_3_2",
			name = "X% damage reduction per nearby bleeding enemy",
			format_values = {
				damage_reduction = {
					format_type = "percentage",
					prefix = "+",
					value = (1 - talent_settings_2.defensive_1.max) / talent_settings_2.defensive_1.max_stacks,
				},
				max_stacks = {
					format_type = "number",
					value = talent_settings_2.defensive_1.max_stacks,
				},
			},
			passive = {
				buff_template_name = "ogryn_reduce_damage_taken_per_bleed",
				identifier = "ogryn_reduce_damage_taken_per_bleed",
			},
		},
		ogryn_knocked_allies_grant_damage_reduction = {
			description = "loc_talent_ogryn_tanky_with_downed_allies_desc",
			display_name = "loc_talent_ogryn_tanky_with_downed_allies",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_2_2",
			name = "Damage Reduction per knocked down ally",
			format_values = {
				damage_taken = {
					format_type = "percentage",
					prefix = "+",
					value = (1 - talent_settings_2.defensive_2.max) / 3,
				},
				range = {
					format_type = "number",
					value = talent_settings_2.defensive_2.distance,
				},
			},
			passive = {
				buff_template_name = "ogryn_reduce_damage_taken_on_disabled_allies",
				identifier = "ogryn_reduce_damage_taken_on_disabled_allies",
			},
		},
		ogryn_toughness_on_low_health = {
			description = "loc_talent_ogryn_toughness_gain_increase_on_low_health_desc",
			display_name = "loc_talent_ogryn_toughness_gain_increase_on_low_health",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_3_3",
			name = "More toughness on low health",
			format_values = {
				toughness_multiplier = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_2.defensive_3.toughness_replenish_multiplier,
				},
				health = {
					format_type = "percentage",
					value = talent_settings_2.defensive_3.increased_toughness_health_threshold,
				},
			},
			passive = {
				buff_template_name = "ogryn_increased_toughness_at_low_health",
				identifier = "ogryn_increased_toughness_at_low_health",
			},
		},
		ogryn_windup_reduces_damage_taken = {
			description = "loc_talent_ogryn_windup_reduces_damage_taken_desc",
			display_name = "loc_talent_ogryn_windup_reduces_damage_taken",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_3_3",
			name = "Damage taken while charging melee attacks is reduced",
			format_values = {
				damage_taken_multiplier = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "ogryn_windup_reduces_damage_taken",
						find_value_type = "buff_template",
						path = {
							"conditional_stat_buffs",
							stat_buffs.damage_taken_multiplier,
						},
					},
					value_manipulation = function (value)
						return (1 - value) * 100
					end,
				},
			},
			passive = {
				buff_template_name = "ogryn_windup_reduces_damage_taken",
				identifier = "ogryn_windup_reduces_damage_taken",
			},
		},
		ogryn_windup_is_uninterruptible = {
			description = "loc_talent_ogryn_windup_is_uninterruptible_desc",
			display_name = "loc_talent_ogryn_windup_is_uninterruptible",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_3_3",
			name = "Uninterruptible while charging melee attacks",
			passive = {
				buff_template_name = "ogryn_windup_is_uninterruptible",
				identifier = "ogryn_windup_is_uninterruptible",
			},
		},
		ogryn_bracing_reduces_damage_taken = {
			description = "loc_talent_ogryn_bracing_reduces_damage_taken_desc",
			display_name = "loc_talent_ogryn_bracing_reduces_damage_taken",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_3_3",
			name = "Reduced damage taken while braced",
			format_values = {
				damage_taken_multiplier = {
					format_type = "percentage",
					prefix = "-",
					find_value = {
						buff_template_name = "ogryn_bracing_reduces_damage_taken",
						find_value_type = "buff_template",
						path = {
							"conditional_stat_buffs",
							stat_buffs.damage_taken_multiplier,
						},
					},
					value_manipulation = function (value)
						return (1 - value) * 100
					end,
				},
			},
			passive = {
				buff_template_name = "ogryn_bracing_reduces_damage_taken",
				identifier = "ogryn_bracing_reduces_damage_taken",
			},
		},
		ogryn_kills_grant_crit_chance = {
			description = "loc_talent_ogryn_crit_chance_on_kill_desc",
			display_name = "loc_talent_ogryn_crit_chance_on_kill",
			icon = "content/ui/textures/icons/talents/ogryn_1/ogryn_1_tier_1_1",
			name = "Killing an enemy grants crit chance. Stacking",
			format_values = {
				crit_chance = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_1.offensive_1.crit_chance_on_kill,
				},
				duration = {
					format_type = "number",
					value = talent_settings_1.offensive_1.duration,
				},
				max_stacks = {
					format_type = "number",
					value = talent_settings_1.offensive_1.max_stacks,
				},
			},
			passive = {
				buff_template_name = "ogryn_crit_chance_on_kill",
				identifier = "ogryn_crit_chance_on_kill",
			},
		},
		ogryn_blocking_ranged_taunts = {
			description = "loc_talent_ranged_enemies_taunt_description",
			display_name = "loc_talent_ranged_enemies_taunt",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_base_4",
			name = "Blocking ranged attacks causes target to become focus on you for X seconds",
			format_values = {
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "taunted_short",
						find_value_type = "buff_template",
						path = {
							"duration",
						},
					},
				},
			},
			passive = {
				buff_template_name = "ogryn_blocking_ranged_taunts",
				identifier = "ogryn_blocking_ranged_taunts",
			},
		},
		ogryn_multi_hits_grant_reload_speed = {
			description = "loc_talent_ogryn_reload_speed_on_multiple_hits_desc",
			display_name = "loc_talent_ogryn_reload_speed_on_multiple_hits",
			icon = "content/ui/textures/icons/talents/ogryn_1/ogryn_1_tier_2_2",
			name = "Multiple hit shots grant reload speed",
			format_values = {
				multi_hit = {
					format_type = "number",
					value = talent_settings_1.offensive_3.num_multi_hit,
				},
				reload_speed = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_1.offensive_3.reload_speed_on_multi_hit,
				},
				duration = {
					format_type = "number",
					value = talent_settings_1.offensive_3.duration,
				},
			},
			passive = {
				buff_template_name = "ogryn_increased_reload_speed_on_multiple_hits",
				identifier = "ogryn_increased_reload_speed_on_multiple_hits",
			},
		},
		ogryn_increased_suppression = {
			description = "loc_talent_ogryn_increased_suppression_desc",
			display_name = "loc_talent_ogryn_increased_suppression",
			icon = "content/ui/textures/icons/talents/ogryn_1/ogryn_1_tier_2_3",
			name = "Increase suppression",
			format_values = {
				suppression = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_1.offensive_2.increased_suppression,
				},
			},
			passive = {
				buff_template_name = "ogryn_increased_suppression",
				identifier = "ogryn_increased_suppression",
			},
		},
		ogryn_increased_clip_size = {
			description = "loc_talent_ogryn_increased_clip_size_desc",
			display_name = "loc_talent_ogryn_increased_clip_size",
			icon = "content/ui/textures/icons/talents/ogryn_1/ogryn_1_tier_1_3",
			name = "Increase Clip size",
			format_values = {
				clip_size = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_1.mixed_3.increased_clip_size,
				},
			},
			passive = {
				buff_template_name = "ogryn_increased_clip_size",
				identifier = "ogryn_increased_clip_size",
			},
		},
		ogryn_reloading_grants_damage = {
			description = "loc_talent_ogryn_ranged_damage_on_reload_desc",
			display_name = "loc_talent_ogryn_ranged_damage_on_reload",
			icon = "content/ui/textures/icons/talents/ogryn_1/ogryn_1_tier_1_1",
			name = "Reloading grants 12% ranged damage for 6 seconds.",
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_1.mixed_1.damage_after_reload,
				},
				duration = {
					format_type = "number",
					value = talent_settings_1.mixed_1.duration,
				},
			},
			passive = {
				buff_template_name = "ogryn_increased_damage_after_reload",
				identifier = "ogryn_increased_damage_after_reload",
			},
		},
		ogryn_melee_stagger = {
			description = "loc_talent_ogryn_melee_stagger_desc",
			display_name = "loc_talent_ogryn_melee_stagger",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_base_1",
			name = "Increased melee stagger strength by x%",
			format_values = {
				stagger = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_2.passive_1.impact_modifier,
				},
			},
			passive = {
				buff_template_name = "ogryn_passive_stagger",
				identifier = "ogryn_passive_stagger",
			},
		},
		ogryn_increased_ammo_reserve = {
			description = "loc_talent_ogryn_increased_ammo_desc",
			display_name = "loc_talent_ogryn_increased_ammo",
			icon = "content/ui/textures/icons/talents/ogryn_1/ogryn_1_base_2",
			name = "Increased Ammo",
			format_values = {
				max_ammo = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_1.passive_3.increased_max_ammo,
				},
			},
			passive = {
				buff_template_name = "ogryn_increased_ammo_reserve_passive",
				identifier = "ogryn_increased_ammo_reserve_passive",
			},
		},
		ogryn_ogryn_killer = {
			description = "loc_talent_ogryn_ogryn_fighter_desc",
			display_name = "loc_talent_ogryn_ogryn_fighter",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_2_1",
			name = "Better vs Ogryns (Damage + DR)",
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_2.offensive_1.damage_vs_ogryn,
				},
				damage_reduction = {
					format_type = "percentage",
					prefix = "+",
					value = 1 - talent_settings_2.offensive_1.ogryn_damage_taken_multiplier,
				},
			},
			passive = {
				buff_template_name = "ogryn_better_ogryn_fighting",
				identifier = "ogryn_better_ogryn_fighting",
			},
		},
		ogryn_box_explodes = {
			description = "loc_talent_bonebreaker_grenade_super_armor_explosion_desc",
			display_name = "loc_talent_bonebreaker_grenade_super_armor_explosion",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_4_3",
			name = "Your direct grenade hits on super armored enemies creates a large explosion",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_ability_ogryn_grenade_box",
				},
				num_grenades = {
					format_type = "number",
					value = ogryn_grenade_box_cluster.damage.impact.cluster.number,
				},
			},
			dev_info = {
				{
					damage_profile_name = "close_frag_grenade",
					info_func = "damage_profile",
				},
			},
			player_ability = {
				ability_type = "grenade_ability",
				ability = PlayerAbilities.ogryn_grenade_box_cluster,
			},
		},
		ogryn_heavy_bleeds = {
			description = "loc_talent_ogryn_bleed_on_multiple_hit_desc",
			display_name = "loc_talent_ogryn_bleed_on_multiple_hit",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_2_3_b",
			name = "Heavy melee attacks apply bleed",
			format_values = {
				stacks = {
					format_type = "number",
					prefix = "+",
					value = talent_settings_2.offensive_3.stacks,
				},
			},
			passive = {
				buff_template_name = "ogryn_heavy_attacks_bleed",
				identifier = "ogryn_heavy_attacks_bleed",
			},
		},
		ogryn_revenge_damage = {
			description = "loc_talent_ogryn_revenge_damage_desc",
			display_name = "loc_talent_ogryn_revenge_damage",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_3_1",
			name = "Increased damage after taking melee damage",
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_2.offensive_2_1.damage,
				},
				duration = {
					format_type = "number",
					value = talent_settings_2.offensive_2_1.time,
				},
			},
			passive = {
				buff_template_name = "ogryn_melee_revenge_damage",
				identifier = "ogryn_melee_revenge_damage",
			},
		},
		ogryn_staggering_increases_damage = {
			description = "loc_talent_ogryn_big_bully_heavy_hits_desc",
			display_name = "loc_talent_ogryn_big_bully_heavy_hits",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_5_2",
			name = "Staggering enemies increases damage",
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_2.offensive_2_2.melee_heavy_damage,
				},
				stacks = {
					format_type = "number",
					value = talent_settings_2.offensive_2_2.max_stacks,
				},
				duration = {
					format_type = "number",
					value = talent_settings_2.offensive_2_2.duration,
				},
			},
			passive = {
				buff_template_name = "ogryn_big_bully_heavy_hits",
				identifier = "ogryn_big_bully_heavy_hits",
			},
		},
		ogryn_more_hits_more_damage = {
			description = "loc_talent_ogryn_damage_per_enemy_hit_previous_desc",
			display_name = "loc_talent_ogryn_damage_per_enemy_hit_previous",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_1_1",
			name = "Increases damage based on hits of previous attack",
			format_values = {
				damage = {
					format_type = "percentage",
					num_decimals = 1,
					prefix = "+",
					value = talent_settings_2.offensive_2_3.melee_damage,
				},
			},
			passive = {
				buff_template_name = "ogryn_hitting_multiple_with_melee_grants_melee_damage_bonus",
				identifier = "ogryn_hitting_multiple_with_melee_grants_melee_damage_bonus",
			},
		},
		ogryn_rending_on_elite_kills = {
			description = "loc_talent_ogryn_rending_on_elite_kills_desc",
			display_name = "loc_talent_ogryn_rending_on_elite_kills",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_1_1",
			name = "Elite kills grant armor piercing",
			format_values = {
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "ogryn_rending_on_elite_kills",
						find_value_type = "buff_template",
						path = {
							"active_duration",
						},
					},
				},
				rending_multiplier = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "ogryn_rending_on_elite_kills",
						find_value_type = "buff_template",
						path = {
							"proc_stat_buffs",
							stat_buffs.rending_multiplier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "ogryn_rending_on_elite_kills",
				identifier = "ogryn_rending_on_elite_kills",
			},
		},
		ogryn_coherency_radius_increase = {
			description = "loc_talent_ogryn_bigger_coherency_radius_desc",
			display_name = "loc_talent_ogryn_bigger_coherency_radius",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_3_1_b",
			name = "Increase coherency radius by x",
			format_values = {
				radius = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_2.coop_1.coherency_aura_size_increase,
				},
			},
			passive = {
				buff_template_name = "ogryn_bigger_coherency_radius",
				identifier = "ogryn_bigger_coherency_radius",
			},
		},
		ogryn_ally_movement_boost_on_ability = {
			description = "loc_talent_ogryn_ability_movement_speed_desc",
			display_name = "loc_talent_ogryn_bull_rush_movement_speed",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_1_3",
			name = "Combat Ability Grants allies movement boosts",
			format_values = {
				movement_speed = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_2.coop_2.movement_speed,
				},
				time = {
					format_type = "number",
					value = talent_settings_2.coop_2.duration,
				},
			},
			passive = {
				buff_template_name = "ogryn_charge_grants_allied_movement_speed",
				identifier = "ogryn_charge_grants_allied_movement_speed",
			},
		},
		ogryn_ally_elite_kills_grant_cooldown = {
			description = "loc_talent_ogryn_cooldown_on_elite_kills_desc",
			display_name = "loc_talent_ogryn_cooldown_on_elite_kills",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_4_1",
			name = "Ability CD on Coherency Elite Kills",
			format_values = {
				cooldown = {
					format_type = "percentage",
					value = talent_settings_2.coop_3.cooldown,
				},
			},
			passive = {
				buff_template_name = "ogryn_cooldown_on_elite_kills_by_coherence",
				identifier = "ogryn_cooldown_on_elite_kills_by_coherence",
			},
		},
		ogryn_charge_applies_bleed = {
			description = "loc_talent_ogryn_bleed_on_bull_rush_desc",
			display_name = "loc_talent_ogryn_bleed_on_bull_rush",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_6_1",
			name = "Bleed Enemies Hit by Bull Rush",
			format_values = {
				stacks = {
					format_type = "number",
					value = talent_settings_2.combat_ability_1.stacks,
				},
				ability = {
					format_type = "loc_string",
					value = "loc_talent_ogryn_bull_rush_distance",
				},
			},
			passive = {
				buff_template_name = "ogryn_charge_bleed",
				identifier = "ogryn_charge_bleed",
			},
		},
		ogryn_longer_charge = {
			description = "loc_talent_ogryn_bull_rush_distance_desc",
			display_name = "loc_talent_ogryn_bull_rush_distance",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_6_2",
			name = "Increase Distance and only Monsters can stop you",
			format_values = {
				distance = {
					format_type = "percentage",
					value = talent_settings_2.combat_ability_2.increase_visualizer,
				},
				ability = {
					format_type = "loc_string",
					value = "loc_ability_ogryn_charge",
				},
				duration = {
					format_type = "number",
					value = talent_settings_2.combat_ability.active_duration,
				},
				attack_speed = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_2.combat_ability.melee_attack_speed,
				},
				move_speed = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_2.combat_ability.movement_speed,
				},
				cooldown = {
					format_type = "number",
					value = PlayerAbilities.ogryn_charge_increased_distance.cooldown,
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_ability_ogryn_charge",
				},
			},
			player_ability = {
				ability_type = "combat_ability",
				ability = PlayerAbilities.ogryn_charge_increased_distance,
			},
		},
		ogryn_charge_toughness = {
			description = "loc_talent_ogryn_toughness_on_bull_rush_desc",
			display_name = "loc_talent_ogryn_toughness_on_bull_rush",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_6_3",
			name = "Restore Toughness on Bull Rush hits",
			format_values = {
				toughness = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_2.combat_ability_3.toughness,
				},
				ability = {
					format_type = "loc_string",
					value = "loc_talent_ogryn_bull_rush_distance",
				},
			},
			passive = {
				buff_template_name = "ogryn_bull_rush_hits_replenish_toughness",
				identifier = "ogryn_bull_rush_hits_replenish_toughness",
			},
		},
		ogryn_charge_trample = {
			description = "loc_talent_ogryn_ability_charge_trample_desc",
			display_name = "loc_talent_ogryn_ability_charge_trample",
			icon = "content/ui/textures/icons/talents/ogryn_2/ogryn_2_tier_6_3",
			name = "Restore Toughness on Bull Rush hits",
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "ogryn_charge_trample_buff",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.damage,
						},
					},
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_ability_ogryn_charge",
				},
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "ogryn_charge_trample_buff",
						find_value_type = "buff_template",
						path = {
							"duration",
						},
					},
				},
				stack = {
					format_type = "number",
					find_value = {
						buff_template_name = "ogryn_charge_trample_buff",
						find_value_type = "buff_template",
						path = {
							"max_stacks",
						},
					},
				},
			},
			passive = {
				buff_template_name = "ogryn_charge_trample",
				identifier = "ogryn_charge_trample",
			},
		},
		ogryn_special_ammo_fire_shots = {
			description = "loc_talent_ogryn_special_ammo_fire_shots_desc",
			display_name = "loc_talent_ogryn_special_ammo_fire_shots",
			icon = "content/ui/textures/icons/talents/ogryn_1/ogryn_1_tier_6_1",
			name = "grants 15% rate of fire and shots now ignite enemies.",
			format_values = {
				stacks = {
					format_type = "number",
					value = talent_settings_1.combat_ability_1.num_stacks,
				},
				ability = {
					format_type = "loc_string",
					value = "loc_talent_ogryn_combat_ability_special_ammo",
				},
			},
			special_rule = {
				identifier = "ogryn_ranged_stance_fire_shots",
				special_rule_name = special_rules.ogryn_ranged_stance_fire_shots,
			},
		},
		ogryn_ranged_stance_toughness_regen = {
			description = "loc_talent_ogryn_special_ammo_toughness_on_shot_and_reload_desc",
			display_name = "loc_talent_ogryn_special_ammo_toughness",
			icon = "content/ui/textures/icons/talents/ogryn_1/ogryn_1_tier_6_1",
			name = "Each shot fired during your Ability replenishes toughness",
			format_values = {
				toughness = {
					format_type = "percentage",
					prefix = "+",
					value = 0.02,
				},
				toughness_reload = {
					format_type = "percentage",
					prefix = "+",
					value = 0.1,
				},
				ability = {
					format_type = "loc_string",
					value = "loc_talent_ogryn_combat_ability_special_ammo",
				},
			},
			special_rule = {
				identifier = "ogryn_ranged_stance_toughness_regen",
				special_rule_name = special_rules.ogryn_ranged_stance_toughness_regen,
			},
		},
		ogryn_special_ammo_armor_pen = {
			description = "loc_talent_ogryn_special_ammo_armor_pen_desc",
			display_name = "loc_talent_ogryn_special_ammo_armor_pen",
			icon = "content/ui/textures/icons/talents/ogryn_1/ogryn_1_tier_6_2",
			name = "grants Armor Piercing rounds but reduces clip size by 30",
			format_values = {
				rending_multiplier = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "ogryn_ranged_stance_armor_pierce",
						find_value_type = "buff_template",
						path = {
							"conditional_stat_buffs",
							stat_buffs.rending_multiplier,
						},
					},
				},
				ability = {
					format_type = "loc_string",
					value = "loc_talent_ogryn_combat_ability_special_ammo",
				},
			},
			special_rule = {
				identifier = "ogryn_combat_armor_pierce",
				special_rule_name = special_rules.ogryn_combat_armor_pierce,
			},
		},
		ogryn_special_ammo_movement = {
			description = "loc_talent_ogryn_special_ammo_movement_desc",
			display_name = "loc_talent_ogryn_special_ammo_movement",
			icon = "content/ui/textures/icons/talents/ogryn_1/ogryn_1_tier_6_3",
			name = "No braced slowdown, increase close ranged dmg",
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_1.combat_ability_3.increased_damage_vs_close,
				},
				reduced_move_penalty = {
					format_type = "percentage",
					value = talent_settings_1.combat_ability_3.reduced_move_penalty,
				},
				ability = {
					format_type = "loc_string",
					value = "loc_talent_ogryn_combat_ability_special_ammo",
				},
			},
			special_rule = {
				identifier = "ogryn_combat_no_movement_penalty",
				special_rule_name = special_rules.ogryn_combat_no_movement_penalty,
			},
		},
		ogryn_carapace_armor = {
			description = "loc_talent_ogryn_carapace_armor_any_damage_desc",
			display_name = "loc_talent_ogryn_carapace_armor",
			icon = "content/ui/textures/icons/talents/ogryn_1/ogryn_1_base_3",
			name = "Carapace armor",
			format_values = {
				toughness_regen = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "ogryn_carapace_armor_child",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_regen_rate_modifier,
						},
					},
				},
				damage_reduction = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "ogryn_carapace_armor_child",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_multiplier,
						},
					},
					value_manipulation = function (value)
						return math.abs(1 - value) * 100
					end,
				},
				stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "ogryn_carapace_armor_child",
						find_value_type = "buff_template",
						path = {
							"max_stacks",
						},
					},
				},
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "ogryn_carapace_armor_parent",
						find_value_type = "buff_template",
						path = {
							"restore_child_duration",
						},
					},
				},
			},
			passive = {
				buff_template_name = "ogryn_carapace_armor_parent",
				identifier = "ogryn_carapace_armor_parent",
			},
		},
		ogryn_carapace_armor_add_stack_on_push = {
			description = "loc_talent_ogryn_carapace_armor_add_stack_on_push_desc",
			display_name = "loc_talent_ogryn_carapace_armor_add_stack_on_push",
			icon = "content/ui/textures/icons/talents/ogryn_1/ogryn_1_base_3",
			name = "Carapace armor restore astack on push",
			format_values = {
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_ogryn_carapace_armor",
				},
			},
			special_rule = {
				identifier = "ogryn_carapace_armor_add_stack_on_push",
				special_rule_name = special_rules.ogryn_carapace_armor_add_stack_on_push,
			},
		},
		ogryn_carapace_armor_trigger_on_zero_stacks = {
			description = "loc_talent_ogryn_carapace_armor_trigger_on_zero_stacks_desc",
			display_name = "loc_talent_ogryn_carapace_armor_trigger_on_zero_stacks",
			icon = "content/ui/textures/icons/talents/ogryn_1/ogryn_1_base_3",
			name = "Carapace armor shockwave + toughness replenish",
			format_values = {
				toughness_replenish = {
					format_type = "percentage",
					prefix = "+",
					value = talent_settings_2.toughness_2.toughness,
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_ogryn_carapace_armor",
				},
				cooldown = {
					format_type = "number",
					find_value = {
						buff_template_name = "ogryn_carapace_armor_explosion_on_zero_stacks_effect",
						find_value_type = "buff_template",
						path = {
							"duration",
						},
					},
				},
			},
			special_rule = {
				identifier = "ogryn_carapace_armor_explosion_on_zero_stacks",
				special_rule_name = special_rules.ogryn_carapace_armor_explosion_on_zero_stacks,
			},
		},
		ogryn_carapace_armor_more_toughness = {
			description = "loc_talent_ogryn_carapace_armor_more_toughness_desc",
			display_name = "loc_talent_ogryn_carapace_armor_more_toughness",
			icon = "content/ui/textures/icons/talents/ogryn_1/ogryn_1_base_3",
			name = "Carapace armor more toughness regen per stack",
			format_values = {
				toughness_regen = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "ogryn_carapace_armor_child",
						find_value_type = "buff_template",
						path = {
							"conditional_stat_buffs",
							stat_buffs.toughness_regen_rate_modifier,
						},
					},
				},
				talent_name = {
					format_type = "loc_string",
					value = "loc_talent_ogryn_carapace_armor",
				},
			},
			special_rule = {
				identifier = "ogryn_carapace_armor_more_toughness",
				special_rule_name = special_rules.ogryn_carapace_armor_more_toughness,
			},
		},
		ogryn_targets_recieve_damage_taken_increase_debuff = {
			description = "loc_talent_ogryn_targets_recieve_damage_increase_debuff_desc",
			display_name = "loc_talent_ogryn_targets_recieve_damage_increase_debuff",
			icon = "content/ui/textures/icons/talents/ogryn_1/ogryn_1_base_3",
			name = "Attacks cause target to take increased damage from all sources",
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "ogryn_recieve_damage_taken_increase_debuff",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.damage_taken_modifier,
						},
					},
				},
				stacks = {
					format_type = "number",
					find_value = {
						buff_template_name = "ogryn_recieve_damage_taken_increase_debuff",
						find_value_type = "buff_template",
						path = {
							"max_stacks",
						},
					},
				},
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "ogryn_recieve_damage_taken_increase_debuff",
						find_value_type = "buff_template",
						path = {
							"duration",
						},
					},
				},
			},
			passive = {
				buff_template_name = "ogryn_targets_recieve_damage_taken_increase_debuff",
				identifier = "targets_recieve_damage_taken_increase",
			},
		},
		ogryn_decrease_suppressed_decay = {
			description = "loc_talent_ogryn_decrease_suppressed_decay_desc",
			display_name = "loc_talent_ogryn_decrease_suppressed_decay",
			icon = "content/ui/textures/icons/talents/ogryn_1/ogryn_1_base_3",
			name = "Increase suppression duration",
			format_values = {
				suppressor_decay_multiplier = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "ogryn_decrease_suppressed_decay",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.suppressor_decay_multiplier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "ogryn_decrease_suppressed_decay",
				identifier = "suppression_dealt",
			},
		},
		ogryn_increase_explosion_radius = {
			description = "loc_talent_ogryn_increase_explosion_radius_desc",
			display_name = "loc_talent_ogryn_increase_explosion_radius",
			icon = "content/ui/textures/icons/talents/ogryn_1/ogryn_1_base_3",
			name = "Increase explosion AoE",
			format_values = {
				explosion_radius = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "ogryn_increase_explosion_radius",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.explosion_radius_modifier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "ogryn_increase_explosion_radius",
				identifier = "explosion_radius",
			},
		},
		ogryn_block_cost_reduction = {
			description = "loc_talent_ogryn_block_cost_reduction_desc",
			display_name = "loc_talent_ogryn_block_cost_reduction",
			icon = "content/ui/textures/icons/talents/ogryn_1/ogryn_1_base_3",
			name = "Reduce block cost",
			format_values = {
				block_cost_multiplier = {
					format_type = "percentage",
					prefix = "-",
					find_value = {
						buff_template_name = "ogryn_block_cost_reduction",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.block_cost_multiplier,
						},
						value_manipulation = function (value)
							return math.abs(value) * 100
						end,
					},
				},
			},
			passive = {
				buff_template_name = "ogryn_block_cost_reduction",
				identifier = "block_cost_reduction",
			},
		},
		ogryn_blocking_reduces_push_cost = {
			description = "loc_talent_ogryn_blocking_reduces_push_cost_desc",
			display_name = "loc_talent_ogryn_blocking_reduces_push_cost",
			icon = "content/ui/textures/icons/talents/ogryn_1/ogryn_1_base_3",
			name = "Blocking reduces push cost for X s",
			format_values = {
				push_cost_multiplier = {
					format_type = "percentage",
					find_value = {
						buff_template_name = "ogryn_blocking_reduces_push_cost",
						find_value_type = "buff_template",
						path = {
							"proc_stat_buffs",
							stat_buffs.push_cost_multiplier,
						},
					},
					value_manipulation = function (value)
						return math_round((1 - value) * 100)
					end,
				},
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "ogryn_blocking_reduces_push_cost",
						find_value_type = "buff_template",
						path = {
							"active_duration",
						},
					},
				},
			},
			passive = {
				buff_template_name = "ogryn_blocking_reduces_push_cost",
				identifier = "blocking_reduces_push_cost",
			},
		},
		ogryn_fully_charged_attacks_gain_damage_and_stagger = {
			description = "loc_talent_ogryn_fully_charged_attacks_gain_damage_and_stagger_desc",
			display_name = "loc_talent_ogryn_fully_charged_attacks_gain_damage_and_stagger",
			icon = "content/ui/textures/icons/talents/ogryn_1/ogryn_1_base_3",
			name = "Fully charged attackks deals more damage and stagger",
			format_values = {
				damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "ogryn_fully_charged_attacks_gain_damage_and_stagger",
						find_value_type = "buff_template",
						path = {
							"conditional_stat_buffs",
							stat_buffs.melee_damage,
						},
					},
				},
				stagger = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "ogryn_fully_charged_attacks_gain_damage_and_stagger",
						find_value_type = "buff_template",
						path = {
							"conditional_stat_buffs",
							stat_buffs.melee_impact_modifier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "ogryn_fully_charged_attacks_gain_damage_and_stagger",
				identifier = "blocking_reduces_push_cost",
			},
		},
	},
}

return archetype_talents
