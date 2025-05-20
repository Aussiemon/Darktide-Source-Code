-- chunkname: @scripts/settings/buff/hordes_buff_templates.lua

local Action = require("scripts/utilities/action/action")
local Ammo = require("scripts/utilities/ammo")
local Armor = require("scripts/utilities/attack/armor")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breeds = require("scripts/settings/breed/breeds")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local BurningSettings = require("scripts/settings/burning/burning_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local FixedFrame = require("scripts/utilities/fixed_frame")
local Health = require("scripts/utilities/health")
local HitZone = require("scripts/utilities/attack/hit_zone")
local HordesBuffsData = require("scripts/settings/buff/hordes_buffs/hordes_buffs_data")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local LiquidArea = require("scripts/extension_systems/liquid_area/utilities/liquid_area")
local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")
local MinionState = require("scripts/utilities/minion_state")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local SharedBuffFunctions = require("scripts/settings/buff/helper_functions/shared_buff_functions")
local ShoutAbilityImplementation = require("scripts/extension_systems/ability/utilities/shout_ability_implementation")
local Stagger = require("scripts/utilities/attack/stagger")
local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local Stamina = require("scripts/utilities/attack/stamina")
local Suppression = require("scripts/utilities/attack/suppression")
local Toughness = require("scripts/utilities/toughness/toughness")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local PI = math.pi
local PI_2 = PI * 2
local buff_categories = BuffSettings.buff_categories
local buff_keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local armor_types = ArmorSettings.types
local attack_types = AttackSettings.attack_types
local damage_types = DamageSettings.damage_types
local hit_zone_names = HitZone.hit_zone_names
local stagger_types = StaggerSettings.stagger_types
local stagger_impact_comparison = StaggerSettings.stagger_impact_comparison
local minion_burning_buff_effects = BurningSettings.buff_effects.minions
local BROADPHASE_RESULTS = {}
local range_melee = DamageSettings.in_melee_range
local range_close = DamageSettings.ranged_close
local range_far = DamageSettings.ranged_far
local grenade_replenishment_external_properties = {
	indicator_type = "human_grenade",
}
local GRENADE_IMPACT_DAMAGE_TEMPLATES = {
	fire_grenade_impact = true,
	frag_grenade_impact = true,
	krak_grenade_impact = true,
	ogryn_grenade_box_cluster_impact = true,
	ogryn_grenade_box_impact = true,
	ogryn_grenade_impact = true,
}
local GRENADE_EXPLOSION_DAMAGE_TYPES = {
	[damage_types.grenade_frag] = true,
	[damage_types.electrocution] = true,
	[damage_types.plasma] = true,
	[damage_types.physical] = true,
	[damage_types.laser] = true,
}
local VFX_NAMES = {
	big_shock = "content/fx/particles/player_buffs/buff_electricity_grenade_01",
	fire_pulse = "content/fx/particles/player_buffs/buff_fire_360angle_01",
	healing_explosion = "content/fx/particles/player_buffs/buff_healing_area",
	single_target_shock = "content/fx/particles/player_buffs/buff_electricity_one_target_01",
	stagger_pulse = "content/fx/particles/player_buffs/buff_staggering_pulse",
	veteran_shout = "content/fx/particles/abilities/squad_leader_ability_shout_activate",
}
local SFX_NAMES = {
	ammo_refil = "wwise/events/player/play_horde_mode_buff_ammo_refill",
	burning_proc = "wwise/events/player/play_horde_mode_buff_fire_ignite",
	duplication = "wwise/events/player/play_horde_mode_buff_dublicate",
	electric_pulse = "wwise/events/player/play_horde_mode_buff_electric_pulse",
	fire_burst = "wwise/events/player/play_horde_mode_buff_fire_burst",
	fire_pulse = "wwise/events/player/play_horde_mode_buff_fire_pulse",
	friendly_rock_charge_finish = "wwise/events/player/play_horde_mode_buff_rock_charge_finish",
	friendly_rock_charge_start = "wwise/events/player/play_horde_mode_buff_rock_charge_loop",
	friendly_rock_charge_stop = "wwise/events/player/stop_horde_mode_buff_rock_charge_loop",
	gravity_pull = "wwise/events/player/play_horde_mode_buff_gravitation",
	grenade_refil = "wwise/events/player/play_horde_mode_buff_grenade_refill",
	healing = "wwise/events/weapon/play_horde_mode_heal_self_confirmation",
	inferno = "wwise/events/player/play_horde_mode_buff_fire_inferno",
	reduced_damage_hit = "wwise/events/player/play_horde_mode_buff_shield_hit",
	shield = "wwise/events/weapon/play_horde_mode_buff_shield",
	shock_aoe_big = "wwise/events/player/play_horde_mode_buff_electric_shock",
	shock_crit = "wwise/events/player/play_horde_mode_buff_electric_crit",
	shock_proc = "wwise/events/player/play_horde_mode_buff_electric_damage",
	stagger_hit = "wwise/events/player/play_horde_mode_buff_stagger_hit",
	stagger_pulse = "wwise/events/player/play_horde_mode_buff_stagger_pulse",
	super_crit = "wwise/events/player/play_horde_mode_buff_super_crit",
}
local templates = {}

table.make_unique(templates)

local _compute_fire_pulse, _give_passive_grenade_replenishment_buff, _pull_enemies_towards_position

templates.hordes_buff_damage_immunity_after_game_end = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_sub_buff,
	keywords = {
		buff_keywords.invulnerable,
	},
}
templates.hordes_buff_max_grenades_increase = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.extra_max_amount_of_grenades] = 1,
	},
}

local extra_wounds = HordesBuffsData.hordes_buff_two_extra_wounds.buff_stats.wounds.value

templates.hordes_buff_two_extra_wounds = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.extra_max_amount_of_wounds] = extra_wounds,
	},
}

local extra_ability_charges = HordesBuffsData.hordes_buff_extra_ability_charge.buff_stats.stack.value

templates.hordes_buff_extra_ability_charge = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.ability_extra_charges] = extra_ability_charges,
	},
	keywords = {
		buff_keywords.allow_extra_ability_charges,
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		template_data.restored_ability_charge = false
	end,
	post_update_keywords_and_stats_func = function (template_data, template_context)
		if not template_context.is_server or template_data.restored_ability_charge then
			return
		end

		local player_unit = template_context.unit
		local ability_extension = ScriptUnit.has_extension(player_unit, "ability_system")

		if ability_extension then
			ability_extension:restore_ability_charge("combat_ability", 1)
		end

		template_data.restored_ability_charge = true
	end,
}
templates.hordes_buff_attack_speed_increase = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.attack_speed] = 0.15,
	},
}

local improved_dodge_speed_percent = HordesBuffsData.hordes_buff_improved_dodge_speed_and_distance.buff_stats.fast.value
local improved_dodge_range_percent = HordesBuffsData.hordes_buff_improved_dodge_speed_and_distance.buff_stats.range.value

templates.hordes_buff_improved_dodge_speed_and_distance = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.dodge_speed_multiplier] = 1 + improved_dodge_speed_percent,
		[stat_buffs.dodge_distance_modifier] = improved_dodge_range_percent,
	},
}

local percent_wield_speed_increase = HordesBuffsData.hordes_buff_reduce_swap_time.buff_stats.swap_time.value

templates.hordes_buff_reduce_swap_time = {
	class_name = "buff",
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.wield_speed] = percent_wield_speed_increase,
	},
}
templates.hordes_buff_rending_increase = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.rending_multiplier] = 0.15,
	},
}

local percent_decrease_range_hit_mass_consumption = HordesBuffsData.hordes_buff_ranged_attacks_hit_mass_penetration_increased.buff_stats.increase_hitmass.value

templates.hordes_buff_ranged_attacks_hit_mass_penetration_increased = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.consumed_hit_mass_modifier_on_ranged_hit] = 1 / (1 + percent_decrease_range_hit_mass_consumption),
	},
}

local percent_damage_taken_increase_for_elemental_weakness = HordesBuffsData.hordes_buff_grenade_explosion_applies_elemental_weakness.buff_stats.damage.value
local elemental_weakness_duration = HordesBuffsData.hordes_buff_grenade_explosion_applies_elemental_weakness.buff_stats.time.value

templates.hordes_buff_grenade_explosion_applies_elemental_weakness = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		_give_passive_grenade_replenishment_buff(template_context.unit)
	end,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		return params.attack_type == attack_types.explosion and GRENADE_EXPLOSION_DAMAGE_TYPES[params.damage_type]
	end,
	proc_func = function (params, template_data, template_context)
		local victim_unit = params.attacked_unit
		local victim_buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

		if HEALTH_ALIVE[victim_unit] and victim_buff_extension then
			local t = FixedFrame.get_latest_fixed_time()
			local player_unit = template_context.unit

			victim_buff_extension:add_internally_controlled_buff("hordes_buff_elemental_weakness", t, "owner_unit", player_unit)
		end
	end,
}
templates.hordes_buff_elemental_weakness = {
	class_name = "buff",
	max_stacks = 6,
	max_stacks_cap = 6,
	predicted = false,
	refresh_duration_on_stack = true,
	buff_category = buff_categories.hordes_sub_buff,
	duration = elemental_weakness_duration,
	stat_buffs = {
		[stat_buffs.damage_taken_from_burning] = percent_damage_taken_increase_for_elemental_weakness,
		[stat_buffs.damage_taken_from_bleeding] = percent_damage_taken_increase_for_elemental_weakness,
		[stat_buffs.damage_taken_from_electrocution] = percent_damage_taken_increase_for_elemental_weakness,
	},
}

local percent_rending_debuff_on_explosion = HordesBuffsData.hordes_buff_grenade_explosion_applies_rending_debuff.buff_stats.brittle.value

templates.hordes_buff_grenade_explosion_applies_rending_debuff = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		_give_passive_grenade_replenishment_buff(template_context.unit)
	end,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		return params.attack_type == attack_types.explosion and GRENADE_EXPLOSION_DAMAGE_TYPES[params.damage_type]
	end,
	proc_func = function (params, template_data, template_context)
		local victim_unit = params.attacked_unit
		local victim_buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

		if HEALTH_ALIVE[victim_unit] and victim_buff_extension then
			local t = FixedFrame.get_latest_fixed_time()
			local player_unit = template_context.unit

			victim_buff_extension:add_internally_controlled_buff("hordes_buff_grenade_explosion_applies_rending_debuff_effect", t, "owner_unit", player_unit)
		end
	end,
}
templates.hordes_buff_grenade_explosion_applies_rending_debuff_effect = {
	class_name = "buff",
	max_stacks = 6,
	max_stacks_cap = 6,
	predicted = false,
	buff_category = buff_categories.hordes_sub_buff,
	stat_buffs = {
		[stat_buffs.rending_multiplier] = percent_rending_debuff_on_explosion,
	},
}

local percent_chance_grenade_kill_replenishes_grenade = HordesBuffsData.hordes_buff_grenade_explosion_kill_replenish_grenades.buff_stats.chance.value

templates.hordes_buff_grenade_explosion_kill_replenish_grenades = {
	class_name = "proc_buff",
	cooldown_duration = 1,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_kill] = percent_chance_grenade_kill_replenishes_grenade,
	},
	check_proc_func = function (params, template_data, template_context, t)
		return params.attack_type == attack_types.explosion and GRENADE_EXPLOSION_DAMAGE_TYPES[params.damage_type]
	end,
	proc_func = function (params, template_data, template_context)
		local player_unit = template_context.unit
		local ability_extension = ScriptUnit.has_extension(player_unit, "ability_system")

		if ability_extension and ability_extension:has_ability_type("grenade_ability") then
			ability_extension:restore_ability_charge("grenade_ability", 3)

			local player_fx_extension = ScriptUnit.has_extension(player_unit, "fx_system")

			if player_fx_extension then
				player_fx_extension:trigger_wwise_events_local_only(SFX_NAMES.grenade_refil, nil, player_unit)
			end
		end
	end,
}

local basic_damage_increase = HordesBuffsData.hordes_buff_damage_increase.buff_stats.damage.value

templates.hordes_buff_damage_increase = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.damage] = basic_damage_increase,
	},
}

local percent_extra_damage_vs_burning_enemies = HordesBuffsData.hordes_buff_damage_vs_burning.buff_stats.damage.value

templates.hordes_buff_damage_vs_burning = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.damage_vs_burning] = percent_extra_damage_vs_burning_enemies,
	},
}
templates.hordes_buff_damage_vs_bleeding = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.damage_vs_bleeding] = 0.1,
	},
}

local percent_extra_damage_vs_electructuted_enemies = HordesBuffsData.hordes_buff_damage_vs_electrocuted.buff_stats.damage.value

templates.hordes_buff_damage_vs_electrocuted = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.damage_vs_electrocuted] = percent_extra_damage_vs_electructuted_enemies,
	},
}
templates.hordes_buff_burning_duration_increase = {
	class_name = "buff",
	max_stacks = 6,
	max_stacks_cap = 6,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.burning_duration] = 0.5,
	},
}
templates.hordes_buff_heavy_attacks_gain_damage_and_stagger = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_sweep_start] = 1,
		[proc_events.on_sweep_finish] = 1,
	},
	conditional_stat_buffs = {
		[stat_buffs.melee_damage] = 0.15,
		[stat_buffs.melee_impact_modifier] = 0.3,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.is_heavy
	end,
	check_active_func = function (template_data, template_context)
		return template_data.is_heavy
	end,
	specific_proc_func = {
		[proc_events.on_sweep_start] = function (params, template_data, template_context)
			template_data.is_heavy = params.is_heavy
		end,
		[proc_events.on_sweep_finish] = function (params, template_data, template_context)
			template_data.is_heavy = false
		end,
	},
}
templates.hordes_buff_damage_vs_ogryn_and_monsters_increase = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.damage_vs_ogryn_and_monsters] = 0.35,
	},
}
templates.hordes_buff_damage_vs_super_armor_and_armored_increase = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.super_armor_damage] = 0.15,
		[stat_buffs.armored_damage] = 0.15,
	},
}

local percent_dmg_reduction_vs_flammers_grenadiers = HordesBuffsData.hordes_buff_damage_taken_by_flamers_and_grenadier_reduced.buff_stats.damage_reduce.value

templates.hordes_buff_damage_taken_by_flamers_and_grenadier_reduced = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.damage_taken_by_cultist_flamer_multiplier] = percent_dmg_reduction_vs_flammers_grenadiers,
		[stat_buffs.damage_taken_by_renegade_flamer_multiplier] = percent_dmg_reduction_vs_flammers_grenadiers,
		[stat_buffs.damage_taken_by_cultist_grenadier_multiplier] = percent_dmg_reduction_vs_flammers_grenadiers,
		[stat_buffs.damage_taken_by_renegade_grenadier_multiplier] = percent_dmg_reduction_vs_flammers_grenadiers,
	},
}
templates.hordes_buff_ammo_reserve_capacity_increase = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.ammo_reserve_capacity] = 0.15,
	},
}
templates.hordes_buff_weakspot_damage_increase = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.weakspot_damage] = 0.5,
	},
}
templates.hordes_buff_suppression_immunity = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	keywords = {
		buff_keywords.suppression_immune,
	},
}
templates.hordes_buff_no_ammo_consumption_on_crits = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	conditional_keywords = {
		buff_keywords.no_ammo_consumption_on_crits,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.inventory_slot_component = unit_data_extension:read_component("slot_secondary")
	end,
	conditional_stat_buffs_func = function (template_data, template_context, t)
		local inventory_slot_component = template_data.inventory_slot_component

		if inventory_slot_component and inventory_slot_component.current_ammunition_clip < 1 then
			return false
		end

		return true
	end,
}
templates.hordes_buff_windup_is_uninterruptible = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	conditional_keywords = {
		buff_keywords.uninterruptible,
	},
	start_func = function (template_data, template_context)
		local player_unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")

		template_data.weapon_action_component = unit_data_extension:read_component("weapon_action")
	end,
	conditional_keywords_func = function (template_data, template_context)
		local weapon_action_component = template_data.weapon_action_component
		local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
		local _, action_settings = Action.current_action(weapon_action_component, weapon_template)
		local is_windup = action_settings and action_settings.kind == "windup"

		return is_windup
	end,
}

local zealot_aiming_pulse_burning_stacks = 1

templates.hordes_buff_zealot_fire_pulse_while_aiming_lunge = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_lunge_aim_start] = 1,
		[proc_events.on_lunge_aim_end] = 1,
	},
	start_func = function (template_data, template_context)
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase

		local player_unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[player_unit]
		local enemy_side_names = side:relation_side_names("enemy")

		template_data.enemy_side_names = enemy_side_names
		template_data.fire_pulse_interval = 1
		template_data.next_pulse_t = -1
		template_data.is_active = false
	end,
	update_func = function (template_data, template_context, dt, t)
		if template_context.is_server and template_data.is_active and t >= template_data.next_pulse_t then
			_compute_fire_pulse(template_context.is_server, template_context.unit, template_data.broadphase, template_data.enemy_side_names, t, zealot_aiming_pulse_burning_stacks)

			template_data.next_pulse_t = t + template_data.fire_pulse_interval
		end
	end,
	specific_proc_func = {
		[proc_events.on_lunge_aim_start] = function (params, template_data, template_context)
			if template_context.is_server then
				template_data.is_active = true
			end
		end,
		[proc_events.on_lunge_aim_end] = function (params, template_data, template_context)
			if template_context.is_server then
				template_data.is_active = false
			end
		end,
	},
}

local liquid_areas_in_position = {}
local zealot_percent_toughness_regen_inside_fire = HordesBuffsData.hordes_buff_zealot_regen_toughness_inside_fire_grenade.buff_stats.thoughness.value
local zealot_interval_regen_inside_fire = HordesBuffsData.hordes_buff_zealot_regen_toughness_inside_fire_grenade.buff_stats.time.value

templates.hordes_buff_zealot_regen_toughness_inside_fire_grenade = {
	class_name = "interval_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	interval = zealot_interval_regen_inside_fire,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		template_data.liquid_area_system = Managers.state.extension:system("liquid_area_system")
		template_data.side_system = Managers.state.extension:system("side_system")
	end,
	interval_func = function (template_data, template_context, template, time_since_start, t)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit
		local player_position = POSITION_LOOKUP[player_unit]
		local side_system = template_data.side_system
		local player_side = side_system.side_by_unit[player_unit]
		local player_side_name = player_side:name()

		table.clear_array(liquid_areas_in_position, #liquid_areas_in_position)
		template_data.liquid_area_system:find_liquid_areas_in_position(player_position, liquid_areas_in_position)

		for _, liquid_area_extension in pairs(liquid_areas_in_position) do
			local area_template_name = liquid_area_extension:area_template_name()
			local source_side_name = liquid_area_extension:source_side_name()
			local is_friendly_area = source_side_name and player_side_name == source_side_name
			local is_fire_grenade_area = area_template_name == "fire_grenade"

			if is_fire_grenade_area and is_friendly_area then
				local recovered_toughness = Toughness.replenish_percentage(player_unit, zealot_percent_toughness_regen_inside_fire, true)
				local player_fx_extension = ScriptUnit.has_extension(player_unit, "fx_system")

				if recovered_toughness > 0 and player_fx_extension then
					player_fx_extension:trigger_wwise_events_local_only(SFX_NAMES.shield, nil, player_unit)
				end

				break
			end
		end
	end,
}
templates.hordes_buff_zealot_lunge_hit_triggers_shout = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_lunge_start] = 1,
		[proc_events.on_hit] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.locomotion_component = unit_data_extension:read_component("locomotion")
		template_data.first_person_component = unit_data_extension:read_component("first_person")
		template_data.shout_triggered = true
		template_data.shout_radius = 9
		template_data.shout_target_template = "hordes_zealot_lunge_shout"
	end,
	specific_check_proc_funcs = {
		[proc_events.on_hit] = function (params, template_data)
			return params.damage_profile and params.damage_profile.name == "zealot_dash_impact"
		end,
	},
	specific_proc_func = {
		[proc_events.on_lunge_start] = function (params, template_data, template_context)
			template_data.shout_triggered = false
		end,
		[proc_events.on_hit] = function (params, template_data, template_context, t)
			if template_data.shout_triggered or not template_context.is_server then
				return
			end

			local player_unit = template_context.unit
			local rotation = template_data.first_person_component.rotation
			local forward = Vector3.normalize(Vector3.flat(Quaternion.forward(rotation)))

			ShoutAbilityImplementation.execute(template_data.shout_radius, template_data.shout_target_template, player_unit, t, template_data.locomotion_component, forward)

			local player_fx_extension = ScriptUnit.extension(player_unit, "fx_system")

			if HEALTH_ALIVE[player_unit] and player_fx_extension then
				local variable_name = "size"
				local variable_value = Vector3(8, 8, 8)
				local vfx_position = POSITION_LOOKUP[player_unit] + Vector3.up()

				player_fx_extension:spawn_particles(VFX_NAMES.veteran_shout, vfx_position, nil, nil, variable_name, variable_value, true)
			end
		end,
	},
}
templates.hordes_buff_zealot_channel_heals_corruption = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	keywords = {
		buff_keywords.zealot_channel_heals_corruption,
	},
}

local zealot_percent_damage_taken_increase_after_shock = HordesBuffsData.hordes_buff_zealot_shock_grenade_increase_next_hit_damage.buff_stats.damage.value

templates.hordes_buff_zealot_shock_grenade_increase_next_hit_damage = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		return params.attack_type == attack_types.explosion and params.damage_type == damage_types.electrocution
	end,
	proc_func = function (params, template_data, template_context)
		local victim_unit = params.attacked_unit
		local victim_buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

		if HEALTH_ALIVE[victim_unit] and victim_buff_extension then
			local t = FixedFrame.get_latest_fixed_time()
			local player_unit = template_context.unit

			victim_buff_extension:add_internally_controlled_buff("hordes_buff_increase_next_hit_damage", t, "owner_unit", player_unit)
		end
	end,
}
templates.hordes_buff_increase_next_hit_damage = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_sub_buff,
	stat_buffs = {
		[stat_buffs.damage_taken_modifier] = zealot_percent_damage_taken_increase_after_shock,
	},
	proc_events = {
		[proc_events.on_minion_damage_taken] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.hit_taken = false
	end,
	check_proc_func = function (params, template_data, template_context, t)
		return params.attack_type ~= attack_types.buff
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		template_data.hit_taken = true
	end,
	conditional_exit_func = function (template_data, template_context)
		return template_data.hit_taken
	end,
}

local zealot_percent_toughness_replenished_on_bleeding_enemy_kill = HordesBuffsData.hordes_buff_zealot_knives_bleed_and_restore_thoughness_on_kill.buff_stats.thoughness.value

templates.hordes_buff_zealot_knives_bleed_and_restore_thoughness_on_kill = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_bleeding_minion_death] = 1,
	},
	start_func = function (template_data, template_context)
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase

		local player_unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[player_unit]
		local enemy_side_names = side:relation_side_names("enemy")

		template_data.enemy_side_names = enemy_side_names
	end,
	specific_check_proc_funcs = {
		[proc_events.on_hit] = function (params, template_data)
			return params.damage_type == damage_types.throwing_knife_zealot
		end,
	},
	specific_proc_func = {
		[proc_events.on_hit] = function (params, template_data, template_context)
			if not template_context.is_server then
				return
			end

			local victim_unit = params.attacked_unit
			local victim_buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

			if HEALTH_ALIVE[victim_unit] and victim_buff_extension then
				local t = FixedFrame.get_latest_fixed_time()
				local player_unit = template_context.unit

				victim_buff_extension:add_internally_controlled_buff_with_stacks("bleed", 1, t, "owner_unit", player_unit)
			end
		end,
		[proc_events.on_bleeding_minion_death] = function (params, template_data, template_context)
			if not template_context.is_server then
				return
			end

			local player_unit = template_context.unit
			local bleed_stacks = params.bleed_stacks
			local toughness_recovered = bleed_stacks * zealot_percent_toughness_replenished_on_bleeding_enemy_kill

			Toughness.replenish_percentage(player_unit, toughness_recovered, true)
		end,
	},
}
templates.hordes_buff_psyker_smite_always_max_damage = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	keywords = {
		buff_keywords.psyker_chain_lightning_full_charge,
	},
}
templates.hordes_buff_psyker_shout_always_stagger = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	keywords = {
		buff_keywords.shout_forces_strong_stagger,
	},
}

local percent_damage_taken_reduction_during_overcharge = HordesBuffsData.hordes_buff_psyker_overcharge_reduced_damage_taken.buff_stats.dammage.value

templates.hordes_buff_psyker_overcharge_reduced_damage_taken = {
	class_name = "proc_buff",
	force_predicted_proc = true,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_damage_taken] = 1,
	},
	conditional_stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = percent_damage_taken_reduction_during_overcharge,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.is_active
	end,
	start_func = function (template_data, template_context)
		template_data.player_fx_extension = ScriptUnit.has_extension(template_context.unit, "fx_system")

		local buff_extension = ScriptUnit.extension(template_context.unit, "buff_system")

		template_data.buff_extension = buff_extension
	end,
	update_func = function (template_data, template_context)
		template_data.is_active = template_data.buff_extension:has_keyword(buff_keywords.psyker_overcharge)
	end,
	check_proc_func = function (params, template_data, template_context, t)
		return template_data.is_active
	end,
	proc_func = function (params, template_data, template_context, t)
		template_data.player_fx_extension:trigger_wwise_event(SFX_NAMES.reduced_damage_hit, false, template_context.unit)
	end,
}

local burn_bleed_stacks_on_psyker_brain_burst = HordesBuffsData.hordes_buff_psyker_brain_burst_burns_and_bleeds_on_hit.buff_stats.stack.value

templates.hordes_buff_psyker_brain_burst_burns_and_bleeds_on_hit = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_smite_attack,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit
		local target_unit = params.attacked_unit

		if HEALTH_ALIVE[target_unit] then
			local buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

			if buff_extension then
				local t = FixedFrame.get_latest_fixed_time()

				buff_extension:add_internally_controlled_buff_with_stacks("flamer_assault", burn_bleed_stacks_on_psyker_brain_burst, t, "owner_unit", player_unit)
				buff_extension:add_internally_controlled_buff_with_stacks("bleed", burn_bleed_stacks_on_psyker_brain_burst, t, "owner_unit", player_unit)
			end
		end
	end,
}

local max_num_enemies_hit_by_brain_burst = HordesBuffsData.hordes_buff_psyker_brain_burst_hits_nearby_enemies.buff_stats.ennemies.value

templates.hordes_buff_psyker_brain_burst_hits_nearby_enemies = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	start_func = function (template_data, template_context)
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase

		local player_unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[player_unit]
		local enemy_side_names = side:relation_side_names("enemy")

		template_data.enemy_side_names = enemy_side_names
		template_data.next_target_index = 1
		template_data.hit_targets_left = 0
		template_data.target_units = {}
		template_data.delay_between_hits = 0.1
		template_data.next_hit_t = 0
	end,
	check_proc_func = function (params, template_data, template_context, t)
		return CheckProcFunctions.on_smite_attack(params, template_data, template_context, t) and params.attack_type ~= attack_types.buff
	end,
	proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return
		end

		local broadphase = template_data.broadphase
		local enemy_side_names = template_data.enemy_side_names
		local dying_unit = params.attacked_unit
		local enemy_position = params.attacked_unit_position and params.attacked_unit_position:unbox()
		local range = 5
		local targets_left_to_spread = max_num_enemies_hit_by_brain_burst
		local num_hits = broadphase.query(broadphase, enemy_position, range, BROADPHASE_RESULTS, enemy_side_names)

		template_data.next_target_index = 1
		template_data.hit_targets_left = 0
		template_data.next_hit_t = t + template_data.delay_between_hits

		table.clear(template_data.target_units)

		for i = 1, num_hits do
			local nearby_enemy_unit = BROADPHASE_RESULTS[i]

			if nearby_enemy_unit ~= dying_unit and HEALTH_ALIVE[nearby_enemy_unit] then
				if HEALTH_ALIVE[nearby_enemy_unit] then
					table.insert(template_data.target_units, nearby_enemy_unit)

					template_data.hit_targets_left = template_data.hit_targets_left + 1
				end

				targets_left_to_spread = targets_left_to_spread - 1
			end

			if targets_left_to_spread <= 0 then
				break
			end
		end
	end,
	update_func = function (template_data, template_context, dt, t)
		local hit_targets_left = template_data.hit_targets_left

		if hit_targets_left <= 0 or t < template_data.next_hit_t then
			return
		end

		local target_units = template_data.target_units
		local target_unit_index = template_data.next_target_index
		local target_unit = target_units[target_unit_index]

		template_data.next_target_index = template_data.next_target_index + 1
		template_data.hit_targets_left = template_data.hit_targets_left - 1
		template_data.next_hit_t = t + template_data.delay_between_hits

		if not HEALTH_ALIVE[target_unit] then
			return
		end

		local player_unit = template_context.unit
		local player_pos = POSITION_LOOKUP[player_unit]
		local damage_profile = DamageProfileTemplates.psyker_smite_kill
		local hit_unit_pos = POSITION_LOOKUP[target_unit]
		local target_unit_data_extension = ScriptUnit.has_extension(target_unit, "unit_data_system")
		local target_breed = target_unit_data_extension and target_unit_data_extension:breed()
		local attack_direction = Vector3.normalize(hit_unit_pos - player_pos)
		local hit_world_position = hit_unit_pos
		local hit_zone_name, hit_actor

		if target_breed then
			local hit_zone_weakspot_types = target_breed.hit_zone_weakspot_types
			local preferred_hit_zone_name = "head"
			local hit_zone = hit_zone_weakspot_types and (hit_zone_weakspot_types[preferred_hit_zone_name] and preferred_hit_zone_name or next(hit_zone_weakspot_types)) or hit_zone_names.center_mass
			local actors = HitZone.get_actor_names(target_unit, hit_zone)
			local hit_actor_name = actors[1]

			hit_zone_name = hit_zone
			hit_actor = Unit.actor(target_unit, hit_actor_name)

			local actor_node = Actor.node(hit_actor)

			hit_world_position = Unit.world_position(target_unit, actor_node)
		end

		local damage_dealt, attack_result, damage_efficiency = Attack.execute(target_unit, damage_profile, "power_level", 500, "charge_level", 1, "hit_zone_name", hit_zone_name, "hit_actor", hit_actor, "attacking_unit", player_unit, "attack_type", attack_types.buff, "damage_type", damage_types.smite)

		ImpactEffect.play(target_unit, hit_actor, damage_dealt, damage_types.smite, hit_zone_name, attack_result, hit_world_position, nil, attack_direction, player_unit, nil, nil, nil, damage_efficiency, damage_profile)
	end,
}

local function _spread_fire_to_nearby_units(broadphase, query_side_name, query_results, player_unit, origin_unit, origin_position, range, max_units_to_spread, fire_stacks, warp_fire_stacks)
	if fire_stacks == 0 and warp_fire_stacks == 0 then
		warp_fire_stacks = 10
	end

	local t = FixedFrame.get_latest_fixed_time()
	local num_hits = broadphase.query(broadphase, origin_position, range, query_results, query_side_name)
	local targets_left_to_spread = max_units_to_spread

	for i = 1, num_hits do
		local nearby_enemy_unit = query_results[i]
		local nearby_enemy_buff_extension = ScriptUnit.has_extension(nearby_enemy_unit, "buff_system")

		if nearby_enemy_unit ~= origin_unit and HEALTH_ALIVE[nearby_enemy_unit] and nearby_enemy_buff_extension then
			if fire_stacks > 0 then
				nearby_enemy_buff_extension:add_internally_controlled_buff_with_stacks("flamer_assault", fire_stacks, t, "owner_unit", player_unit)
			end

			if warp_fire_stacks > 0 then
				nearby_enemy_buff_extension:add_internally_controlled_buff_with_stacks("warp_fire", warp_fire_stacks, t, "owner_unit", player_unit)
			end

			targets_left_to_spread = targets_left_to_spread - 1
		end

		if targets_left_to_spread <= 0 then
			break
		end
	end
end

templates.hordes_buff_psyker_brain_burst_spreads_fire_on_hit = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_kill] = 1,
	},
	start_func = function (template_data, template_context)
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase

		local player_unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[player_unit]
		local enemy_side_names = side:relation_side_names("enemy")

		template_data.enemy_side_names = enemy_side_names
	end,
	check_proc_func = CheckProcFunctions.on_smite_attack,
	specific_proc_func = {
		[proc_events.on_hit] = function (params, template_data, template_context)
			local player_unit = template_context.unit
			local target_unit = params.attacked_unit
			local target_unit_buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

			if target_unit_buff_extension then
				local is_target_alive_and_not_burning = HEALTH_ALIVE[target_unit] and not target_unit_buff_extension:has_keyword(buff_keywords.burning)

				if is_target_alive_and_not_burning then
					return
				end

				local fire_stacks = target_unit_buff_extension:current_stacks("flamer_assault")
				local warp_fire_stacks = target_unit_buff_extension:current_stacks("warp_fire")
				local broadphase = template_data.broadphase
				local enemy_position = POSITION_LOOKUP[target_unit]
				local enemy_side_names = template_data.enemy_side_names
				local range = 5

				_spread_fire_to_nearby_units(broadphase, enemy_side_names, BROADPHASE_RESULTS, player_unit, target_unit, enemy_position, range, 100, fire_stacks, warp_fire_stacks)
			end
		end,
		[proc_events.on_kill] = function (params, template_data, template_context)
			local player_unit = template_context.unit
			local target_unit = params.attacked_unit
			local fire_stacks = 10
			local warp_fire_stacks = 0
			local broadphase = template_data.broadphase
			local enemy_position = params.attacked_unit_position and params.attacked_unit_position:unbox()
			local enemy_side_names = template_data.enemy_side_names
			local range = 5

			_spread_fire_to_nearby_units(broadphase, enemy_side_names, BROADPHASE_RESULTS, player_unit, target_unit, enemy_position, range, 100, fire_stacks, warp_fire_stacks)
		end,
	},
}

local percent_stat_value_from_psyker_shout = HordesBuffsData.hordes_buff_psyker_shout_boosts_allies.buff_stats.dammage.value
local psyker_shout_ally_boost_duration = HordesBuffsData.hordes_buff_psyker_shout_boosts_allies.buff_stats.time.value

templates.hordes_buff_psyker_shout_boosts_allies = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_psyker_shout_hit_ally] = 1,
	},
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local ally_unit = params.ally_unit

		if HEALTH_ALIVE[ally_unit] then
			local buff_extension = ScriptUnit.has_extension(ally_unit, "buff_system")

			if buff_extension then
				local t = FixedFrame.get_latest_fixed_time()

				buff_extension:add_internally_controlled_buff("hordes_buff_psyker_shout_boosts_allies_effect", t)
			end
		end
	end,
}
templates.hordes_buff_psyker_shout_boosts_allies_effect = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	buff_category = buff_categories.hordes_sub_buff,
	duration = psyker_shout_ally_boost_duration,
	stat_buffs = {
		[stat_buffs.damage] = percent_stat_value_from_psyker_shout,
		[stat_buffs.toughness_damage_taken_multiplier] = percent_stat_value_from_psyker_shout,
	},
}
templates.hordes_buff_psyker_burning_on_throwing_knife_hit = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		return params.damage_type == damage_types.throwing_knife
	end,
	proc_func = function (params, template_data, template_context)
		local victim_unit = params.attacked_unit
		local victim_buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

		if HEALTH_ALIVE[victim_unit] and victim_buff_extension then
			local t = FixedFrame.get_latest_fixed_time()
			local player_unit = template_context.unit

			victim_buff_extension:add_internally_controlled_buff_with_stacks("flamer_assault", 2, t, "owner_unit", player_unit)
		end
	end,
}
templates.hordes_buff_psyker_recover_knife_on_knife_kill = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.ability_extension = ScriptUnit.has_extension(unit, "ability_system")
	end,
	check_proc_func = function (params, template_data, template_context, t)
		return params.damage_type == damage_types.throwing_knife
	end,
	proc_func = function (params, template_data, template_context)
		local ability_extension = template_data.ability_extension

		if not ability_extension or not ability_extension:has_ability_type("grenade_ability") then
			return
		end

		local missing_charges = ability_extension:missing_ability_charges("grenade_ability")

		if missing_charges == 0 then
			return
		end

		ability_extension:restore_ability_charge("grenade_ability", 1)

		local player_unit = template_context.uni
		local player_fx_extension = ScriptUnit.has_extension(player_unit, "fx_system")

		if player_fx_extension then
			player_fx_extension:trigger_wwise_events_local_only(SFX_NAMES.grenade_refil, nil, player_unit)
		end
	end,
}
templates.hordes_buff_weakspot_ranged_hit_always_stagger = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_weakspot_hit_ranged,
	proc_func = function (params, template_data, template_context, t)
		local player_unit = template_context.unit
		local enemy_unit = params.attacked_unit
		local attack_direction = params.attack_direction:unbox()
		local stagger_result = params.stagger_result
		local is_critical_strike = params.is_critical_strike
		local target_stagger_type = is_critical_strike and stagger_types.medium or stagger_types.light
		local is_enemy_staggered_with_stronger_force = stagger_impact_comparison[stagger_result] and stagger_impact_comparison[target_stagger_type] < stagger_impact_comparison[stagger_result]

		if HEALTH_ALIVE[enemy_unit] and not is_enemy_staggered_with_stronger_force then
			Stagger.force_stagger(enemy_unit, target_stagger_type, attack_direction, 4, 1, 4, player_unit)
		end
	end,
}

local num_weakspot_hit_streak_needed_for_infinite_ammo = HordesBuffsData.hordes_buff_weakspot_ranged_hit_gives_infinite_ammo.buff_stats.headshot.value
local duration_infinite_ammo_on_weakspot_hit_streak = HordesBuffsData.hordes_buff_weakspot_ranged_hit_gives_infinite_ammo.buff_stats.time.value
local cooldown_infinite_ammo_on_weakspot_hit_streak = HordesBuffsData.hordes_buff_weakspot_ranged_hit_gives_infinite_ammo.buff_stats.cooldown.value

templates.hordes_buff_weakspot_ranged_hit_gives_infinite_ammo = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	active_duration = duration_infinite_ammo_on_weakspot_hit_streak,
	cooldown_duration = cooldown_infinite_ammo_on_weakspot_hit_streak,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	proc_keywords = {
		buff_keywords.no_ammo_consumption,
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		template_data.hits_in_a_row = 0
	end,
	check_proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return false
		end

		local hit_weakspot = params.hit_weakspot
		local is_ranged_hit = CheckProcFunctions.on_ranged_hit(params, template_data, template_context, t)

		if not hit_weakspot or not is_ranged_hit then
			template_data.hits_in_a_row = 0

			return false
		end

		template_data.hits_in_a_row = template_data.hits_in_a_row + 1

		return template_data.hits_in_a_row >= num_weakspot_hit_streak_needed_for_infinite_ammo
	end,
	proc_func = function (params, template_data, template_context, t)
		template_data.hits_in_a_row = 0
	end,
}

local percent_damage_increase_per_missing_ammo_in_clip = HordesBuffsData.hordes_buff_melee_damage_missing_ammo_in_clip.buff_stats.dammage.value

templates.hordes_buff_melee_damage_missing_ammo_in_clip = {
	class_name = "proc_buff",
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_ammo_consumed] = 1,
		[proc_events.on_reload] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.ammo_missing = 0
		template_data.lerp_t = 0
		template_data.update_t = -1
	end,
	specific_proc_func = {
		[proc_events.on_ammo_consumed] = function (params, template_data, template_context)
			local unit = template_context.unit
			local ammo_missing = Ammo.missing_slot_clip_amount(unit, "slot_secondary")

			template_data.ammo_missing = ammo_missing
			template_data.lerp_t = ammo_missing * percent_damage_increase_per_missing_ammo_in_clip
		end,
		[proc_events.on_reload] = function (params, template_data, template_context)
			template_data.ammo_missing = 0
			template_data.lerp_t = 0
		end,
	},
	lerped_stat_buffs = {
		[stat_buffs.melee_damage] = {
			max = 1,
			min = 0,
		},
	},
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		return template_data.lerp_t
	end,
}

local percent_ranged_damage_increase_after_reload = HordesBuffsData.hordes_buff_increased_damage_after_reload.buff_stats.range.value
local duration_ranged_damage_increase_after_reload = HordesBuffsData.hordes_buff_increased_damage_after_reload.buff_stats.time.value

templates.hordes_buff_increased_damage_after_reload = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	active_duration = duration_ranged_damage_increase_after_reload,
	proc_events = {
		[proc_events.on_reload] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.ranged_damage] = percent_ranged_damage_increase_after_reload,
	},
}

local percent_damage_reduction_per_near_disabled_ally = HordesBuffsData.hordes_buff_reduce_damage_taken_on_disabled_allies.buff_stats.damage.value
local max_percent_damage_reduction_near_disabled_allies = 1 - percent_damage_reduction_per_near_disabled_ally * 4
local range_detection_for_disabled_allies = HordesBuffsData.hordes_buff_reduce_damage_taken_on_disabled_allies.buff_stats.range.value

templates.hordes_buff_reduce_damage_taken_on_disabled_allies = {
	class_name = "proc_buff",
	force_predicted_proc = true,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_damage_taken] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		return template_data.lerp_t > 0
	end,
	proc_func = function (params, template_data, template_context, t)
		template_data.player_fx_extension:trigger_wwise_event(SFX_NAMES.reduced_damage_hit, false, template_context.unit)
	end,
	lerped_stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = {
			min = 1,
			max = max_percent_damage_reduction_near_disabled_allies,
		},
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]

		template_data.side = side
		template_data.player_fx_extension = ScriptUnit.has_extension(template_context.unit, "fx_system")
		template_data.lerp_t = 0
		template_data.range_squared = range_detection_for_disabled_allies * range_detection_for_disabled_allies

		local t = Managers.time:time("gameplay")

		template_data.update_t = t + 0.1
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		if t > template_data.update_t then
			local max_players = 3
			local player_units = template_data.side.valid_player_units
			local valid_units = 0
			local unit = template_context.unit
			local pos = POSITION_LOOKUP[unit]

			for i = 1, #player_units do
				local player_unit = player_units[i]

				if player_unit ~= unit then
					local player_pos = POSITION_LOOKUP[player_unit]
					local distance = Vector3.distance_squared(pos, player_pos)

					if distance < template_data.range_squared then
						local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
						local character_state_component = unit_data_extension:read_component("character_state")
						local requires_help = PlayerUnitStatus.requires_help(character_state_component)

						if requires_help then
							valid_units = valid_units + 1
						end
					end
				end
			end

			template_data.lerp_t = valid_units / max_players
			template_data.update_t = t + 0.1
		end

		return template_data.lerp_t
	end,
}
templates.hordes_buff_melee_damage_on_missing_wounds = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	lerped_stat_buffs = {
		[stat_buffs.melee_damage] = {
			max = 0.35000000000000003,
			min = 0,
		},
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.health_extension = ScriptUnit.extension(unit, "health_system")
		template_data.max_wounds = 7
	end,
	update_func = function (template_data, template_context, dt, t)
		local health_extension = template_data.health_extension

		if health_extension then
			local max_wounds = health_extension:max_wounds()
			local max_health = health_extension:max_health()
			local damage_taken = health_extension:damage_taken()
			local permanent_damage_taken = health_extension:permanent_damage_taken()
			local current_wounds = Health.calculate_num_segments(math.max(damage_taken, permanent_damage_taken), max_health, max_wounds)
			local missing_wounds = (max_wounds or 0) - (current_wounds or 0)

			template_data.missing_wounds = math.min(missing_wounds, max_wounds)
		end
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local max_wounds = template_data.max_wounds
		local missing_wounds = template_data.missing_wounds or 0

		return math.clamp01(missing_wounds / max_wounds)
	end,
}

local max_stacks_improved_weapon_reload_on_melee_kill = HordesBuffsData.hordes_buff_improved_weapon_reload_on_melee_kill.buff_stats.time.value
local percent_improved_weapon_reload_on_melee_kill = HordesBuffsData.hordes_buff_improved_weapon_reload_on_melee_kill.buff_stats.reload_speed.value

templates.hordes_buff_improved_weapon_reload_on_melee_kill = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_melee_kill,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.buff_extension = ScriptUnit.extension(unit, "buff_system")
	end,
	proc_func = function (params, template_data, template_context, t)
		template_data.buff_extension:add_internally_controlled_buff("hordes_buff_improved_weapon_reload_on_melee_kill_effect", t)
	end,
}
templates.hordes_buff_improved_weapon_reload_on_melee_kill_effect = {
	class_name = "proc_buff",
	predicted = false,
	buff_category = buff_categories.hordes_sub_buff,
	max_stacks = max_stacks_improved_weapon_reload_on_melee_kill,
	max_stacks_cap = max_stacks_improved_weapon_reload_on_melee_kill,
	proc_events = {
		[proc_events.on_reload] = 1,
	},
	stat_buffs = {
		[stat_buffs.reload_speed] = percent_improved_weapon_reload_on_melee_kill,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")

		local unit_data_extension = ScriptUnit.extension(template_context.unit, "unit_data_system")

		template_data.weapon_action_component = unit_data_extension:read_component("weapon_action")
		template_data.inventory_component = unit_data_extension:read_component("inventory")
	end,
	proc_func = function (params, template_data, template_context, t)
		template_data.done = true
	end,
	conditional_exit_func = function (template_data, template_context)
		local inventory_component = template_data.inventory_component
		local visual_loadout_extension = template_data.visual_loadout_extension
		local wielded_slot_id = inventory_component.wielded_slot
		local weapon_template = visual_loadout_extension:weapon_template_from_slot(wielded_slot_id)
		local _, current_action = Action.current_action(template_data.weapon_action_component, weapon_template)
		local action_kind = current_action and current_action.kind
		local is_reloading = action_kind and (action_kind == "reload_shotgun" or action_kind == "reload_state" or action_kind == "ranged_load_special")

		return template_data.done and not is_reloading
	end,
}
templates.hordes_buff_improved_weapon_reload_on_non_empty_clip = {
	class_name = "buff",
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	conditional_stat_buffs = {
		[stat_buffs.reload_speed] = 0.25,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.is_active
	end,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local inventory_component = unit_data_extension:read_component("inventory")

		template_data.inventory_component = inventory_component
	end,
	update_func = function (template_data, template_context)
		local unit = template_context.unit
		local inventory_component = template_data.inventory_component
		local wielded_slot = inventory_component.wielded_slot
		local ammo_percentage = Ammo.current_slot_clip_percentage(unit, wielded_slot)
		local is_reloading = ConditionalFunctions.is_reloading(template_data, template_context)
		local active = ammo_percentage > 0

		if not is_reloading then
			template_data.is_active = active
		end
	end,
	check_active_func = ConditionalFunctions.is_reloading,
}
templates.hordes_buff_improved_weapon_reload_on_elite_kill = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_elite_or_special_kill,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.buff_extension = ScriptUnit.extension(unit, "buff_system")
	end,
	proc_func = function (params, template_data, template_context, t)
		template_data.buff_extension:add_internally_controlled_buff("hordes_buff_improved_weapon_reload_on_elite_kill_effect", t)
	end,
}
templates.hordes_buff_improved_weapon_reload_on_elite_kill_effect = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_sub_buff,
	proc_events = {
		[proc_events.on_reload] = 1,
	},
	stat_buffs = {
		[stat_buffs.reload_speed] = 0.3,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")

		local unit_data_extension = ScriptUnit.extension(template_context.unit, "unit_data_system")

		template_data.weapon_action_component = unit_data_extension:read_component("weapon_action")
		template_data.inventory_component = unit_data_extension:read_component("inventory")
	end,
	proc_func = function (params, template_data, template_context, t)
		template_data.done = true
	end,
	conditional_exit_func = function (template_data, template_context)
		local inventory_component = template_data.inventory_component
		local visual_loadout_extension = template_data.visual_loadout_extension
		local wielded_slot_id = inventory_component.wielded_slot
		local weapon_template = visual_loadout_extension:weapon_template_from_slot(wielded_slot_id)
		local _, current_action = Action.current_action(template_data.weapon_action_component, weapon_template)
		local action_kind = current_action and current_action.kind
		local is_reloading = action_kind and (action_kind == "reload_shotgun" or action_kind == "reload_state" or action_kind == "ranged_load_special")

		return template_data.done and not is_reloading
	end,
}

local percent_ammo_gets_increased_crit_chance_after_reload = HordesBuffsData.hordes_buff_bonus_crit_chance_on_ammo.buff_stats.ammo.value
local percent_crit_chance_increase_after_reload = HordesBuffsData.hordes_buff_bonus_crit_chance_on_ammo.buff_stats.crit_chance.value

templates.hordes_buff_bonus_crit_chance_on_ammo = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	conditional_stat_buffs = {
		[stat_buffs.ranged_critical_strike_chance] = percent_crit_chance_increase_after_reload,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.slot_component = unit_data_extension:read_component("slot_secondary")
		template_data.inventory_component = unit_data_extension:read_component("inventory")
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		if template_data.inventory_component.wielded_slot ~= "slot_secondary" then
			return false
		end

		local slot_component = template_data.slot_component
		local current_animation_clip, max_ammunition_clip = slot_component.current_ammunition_clip, slot_component.max_ammunition_clip
		local current_animation_percentage = current_animation_clip / max_ammunition_clip
		local ammunition_percentage = 1 - percent_ammo_gets_increased_crit_chance_after_reload

		return ammunition_percentage <= current_animation_percentage
	end,
}
templates.hordes_buff_ranged_damage_on_enemy_on_melee_hit = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_melee_hit,
	proc_func = function (params, template_data, template_context)
		local victim_unit = params.attacked_unit
		local victim_buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

		if HEALTH_ALIVE[victim_unit] and victim_buff_extension then
			local t = FixedFrame.get_latest_fixed_time()
			local player_unit = template_context.unit
			local num_stacks = 1

			for ii = 1, num_stacks do
				victim_buff_extension:add_internally_controlled_buff("hordes_buff_ranged_damage_on_enemy_on_melee_hit_minion_effect", t, "owner_unit", player_unit)
			end
		end
	end,
}
templates.hordes_buff_ranged_damage_on_enemy_on_melee_hit_minion_effect = {
	class_name = "proc_buff",
	duration = 3,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	buff_category = buff_categories.hordes_sub_buff,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.is_active = true
	end,
	check_proc_func = CheckProcFunctions.on_ranged_hit,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local attacked_unit = template_context.unit
		local attacking_unit = params.attacking_unit
		local valid_attacker_unit = template_context.owner_unit

		if HEALTH_ALIVE[attacked_unit] and attacking_unit == valid_attacker_unit then
			local damage_template = DamageProfileTemplates.burning
			local power_level = 500
			local optional_owner_unit = template_context.is_server and template_context.owner_unit or nil

			Attack.execute(attacked_unit, damage_template, "power_level", power_level, "damage_type", "burning", "attacking_unit", optional_owner_unit)

			template_data.is_active = false
		end
	end,
	conditional_exit_func = function (template_data, template_context)
		if not template_context.is_server then
			return false
		end

		return not template_data.is_active
	end,
}

local percent_melee_damage_increase_on_ranged_kill = HordesBuffsData.hordes_buff_other_slot_damage_increase_on_kill.buff_stats.dammage.value
local percent_range_damage_increase_on_melee_kill = HordesBuffsData.hordes_buff_other_slot_damage_increase_on_kill.buff_stats.range.value

templates.hordes_buff_other_slot_damage_increase_on_kill = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local current_time = FixedFrame.get_latest_fixed_time()
		local buff_extension = ScriptUnit.extension(template_context.unit, "buff_system")
		local _, buff_index, component_index = buff_extension:add_externally_controlled_buff("hordes_buff_melee_kills_grant_range_damage", current_time)

		template_data.melee_kills_buff = {
			buff_index = buff_index,
			component_index = component_index,
		}
		_, buff_index, component_index = buff_extension:add_externally_controlled_buff("hordes_buff_ranged_kills_grant_melee_damage", current_time)
		template_data.range_kills_buff = {
			buff_index = buff_index,
			component_index = component_index,
		}
		template_data.buff_extension = buff_extension
	end,
}
templates.hordes_buff_melee_kills_grant_range_damage = {
	active_duration = 5,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_sub_buff,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_melee_kill,
	proc_stat_buffs = {
		[stat_buffs.ranged_damage] = percent_range_damage_increase_on_melee_kill,
	},
}
templates.hordes_buff_ranged_kills_grant_melee_damage = {
	active_duration = 5,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_sub_buff,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_ranged_kill,
	proc_stat_buffs = {
		[stat_buffs.melee_damage] = percent_melee_damage_increase_on_ranged_kill,
	},
}
templates.hordes_buff_shock_on_blocking_melee_attack = {
	class_name = "proc_buff",
	cooldown_duration = 0.2,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_block] = 1,
	},
	start_func = function (template_data, template_context)
		return
	end,
	check_proc_func = CheckProcFunctions.on_melee_hit,
	proc_func = function (params, template_data, template_context)
		local victim_unit = params.attacking_unit
		local victim_buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

		if HEALTH_ALIVE[victim_unit] and victim_buff_extension then
			local t = FixedFrame.get_latest_fixed_time()
			local player_unit = template_context.unit

			victim_buff_extension:add_internally_controlled_buff("hordes_ailment_shock", t, "owner_unit", player_unit)

			local fx_system = Managers.state.extension:system("fx_system")
			local enemy_position = POSITION_LOOKUP[victim_unit]

			fx_system:trigger_wwise_event(SFX_NAMES.shock_proc, enemy_position)
			fx_system:trigger_vfx(VFX_NAMES.single_target_shock, enemy_position)
		end
	end,
}

local max_toughness_stacks_gained_per_burning_shocked_enemy = 20
local toughness_gained_per_burning_shocked_enemy = HordesBuffsData.hordes_buff_extra_toughness_near_burning_shocked_enemies.buff_stats.extra_thoughness.value

templates.hordes_buff_extra_toughness_near_burning_shocked_enemies = {
	class_name = "buff",
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	lerped_stat_buffs = {
		[stat_buffs.toughness_bonus_flat] = {
			min = 0,
			max = toughness_gained_per_burning_shocked_enemy * max_toughness_stacks_gained_per_burning_shocked_enemy,
		},
	},
	start_func = function (template_data, template_context)
		template_data.range = range_close

		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase
		template_data.num_enemies_in_range = 0

		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")
		local t = FixedFrame.get_latest_fixed_time()

		template_data.next_check_t = t + 1
		template_data.enemy_side_names = enemy_side_names
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local next_check_t = template_data.next_check_t

		if next_check_t < t then
			local player_unit = template_context.unit
			local player_position = POSITION_LOOKUP[player_unit]
			local broadphase = template_data.broadphase
			local enemy_side_names = template_data.enemy_side_names
			local num_stacks = 0
			local num_hits = broadphase.query(broadphase, player_position, template_data.range, BROADPHASE_RESULTS, enemy_side_names)

			for i = 1, num_hits do
				local enemy_unit = BROADPHASE_RESULTS[i]
				local buff_extension = ScriptUnit.has_extension(enemy_unit, "buff_system")

				if buff_extension then
					local target_is_burning_or_electrocuted = buff_extension:has_keyword(buff_keywords.burning) or buff_extension:has_keyword(buff_keywords.electrocuted)

					if target_is_burning_or_electrocuted then
						num_stacks = num_stacks + 1

						if num_stacks >= max_toughness_stacks_gained_per_burning_shocked_enemy then
							break
						end
					end
				end
			end

			template_data.num_enemies_in_range = num_stacks
			template_data.next_check_t = t + 1
		end

		return math.clamp(template_data.num_enemies_in_range / max_toughness_stacks_gained_per_burning_shocked_enemy, 0, 1)
	end,
}

local melee_instakill_on_electrocuted_enemy_chance = HordesBuffsData.hordes_buff_instakill_melee_hit_on_electrocuted_enemy.buff_stats.kill_chance.value

templates.hordes_buff_instakill_melee_hit_on_electrocuted_enemy = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_hit] = melee_instakill_on_electrocuted_enemy_chance,
	},
	check_proc_func = CheckProcFunctions.on_melee_hit,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server or params.attacked_unit == nil or params.attack_direction == nil then
			return
		end

		local player_unit = template_context.unit
		local target_unit = params.attacked_unit

		if HEALTH_ALIVE[target_unit] then
			local buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

			if buff_extension then
				local target_is_electrocuted = buff_extension:has_keyword(buff_keywords.electrocuted)

				if target_is_electrocuted then
					local player_pos = POSITION_LOOKUP[player_unit]
					local damage_profile = DamageProfileTemplates.kill_volume_with_gibbing
					local hit_unit_pos = POSITION_LOOKUP[target_unit]
					local target_unit_data_extension = ScriptUnit.has_extension(target_unit, "unit_data_system")
					local target_breed = target_unit_data_extension and target_unit_data_extension:breed()
					local attack_direction = Vector3.normalize(hit_unit_pos - player_pos)
					local hit_world_position = hit_unit_pos
					local hit_zone_name, hit_actor

					if target_breed then
						local hit_zone_weakspot_types = target_breed.hit_zone_weakspot_types
						local preferred_hit_zone_name = "head"
						local hit_zone = hit_zone_weakspot_types and (hit_zone_weakspot_types[preferred_hit_zone_name] and preferred_hit_zone_name or next(hit_zone_weakspot_types)) or hit_zone_names.center_mass
						local actors = HitZone.get_actor_names(target_unit, hit_zone)
						local hit_actor_name = actors[1]

						hit_zone_name = hit_zone
						hit_actor = Unit.actor(target_unit, hit_actor_name)

						local actor_node = Actor.node(hit_actor)

						hit_world_position = Unit.world_position(target_unit, actor_node)
					end

					Attack.execute(target_unit, damage_profile, "instakill", true, "hit_zone_name", hit_zone_name, "hit_actor", hit_actor, "attacking_unit", player_unit, "attack_direction", attack_direction)

					local player_fx_extension = ScriptUnit.has_extension(player_unit, "fx_system")

					if player_fx_extension then
						player_fx_extension:trigger_wwise_events_local_only(SFX_NAMES.shock_crit, nil, player_unit)
					end
				end
			end
		end
	end,
}
templates.hordes_buff_shock_on_hit_after_dodge = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_successful_dodge] = 1,
	},
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit
		local buff_extension = ScriptUnit.has_extension(player_unit, "buff_system")

		if buff_extension then
			local t = FixedFrame.get_latest_fixed_time()

			buff_extension:add_internally_controlled_buff("hordes_buff_shock_on_hit_after_dodge_effect", t, "owner_unit", player_unit)
		end
	end,
}
templates.hordes_buff_shock_on_hit_after_dodge_effect = {
	class_name = "proc_buff",
	duration = 5,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	buff_category = buff_categories.hordes_sub_buff,
	proc_events = {
		[proc_events.on_player_hit_received] = 1,
	},
	check_proc_func = CheckProcFunctions.on_melee_hit,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit
		local target_unit = params.attacking_unit

		if HEALTH_ALIVE[target_unit] then
			local buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

			if buff_extension then
				local t = FixedFrame.get_latest_fixed_time()

				buff_extension:add_internally_controlled_buff_with_stacks("hordes_ailment_shock", 2, t, "owner_unit", player_unit)

				local fx_system = Managers.state.extension:system("fx_system")
				local enemy_position = POSITION_LOOKUP[target_unit]

				fx_system:trigger_wwise_event(SFX_NAMES.shock_proc, enemy_position)
				fx_system:trigger_vfx(VFX_NAMES.big_shock, enemy_position)
			end
		end
	end,
}
templates.hordes_buff_shock_on_grenade_impact = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local coherency_system = Managers.state.extension:system("coherency_system")

		coherency_system:add_external_buff(unit, "hordes_buff_coherency_shock_on_grenade_impact_effect")
	end,
}
templates.hordes_buff_coherency_shock_on_grenade_impact_effect = {
	class_name = "proc_buff",
	coherency_id = "hordes_buff_coherency_shock_on_grenade_impact_effect",
	coherency_priority = 2,
	cooldown_duration = 1,
	max_stacks = 1,
	predicted = false,
	buff_category = buff_categories.hordes_sub_buff,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server or params.damage_profile == nil then
			return false
		end

		local damage_profile_name = params.damage_profile.name

		return GRENADE_IMPACT_DAMAGE_TEMPLATES[damage_profile_name]
	end,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase

		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")

		template_data.enemy_side_names = enemy_side_names
	end,
	proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit
		local attacked_unit = params.attacked_unit
		local shock_area_position = Unit.alive(attacked_unit) and POSITION_LOOKUP[attacked_unit] or params.hit_world_position and params.hit_world_position:unbox()
		local broadphase = template_data.broadphase
		local enemy_side_names = template_data.enemy_side_names
		local num_hits = broadphase.query(broadphase, shock_area_position, range_melee, BROADPHASE_RESULTS, enemy_side_names)

		for i = 1, num_hits do
			local enemy_unit = BROADPHASE_RESULTS[i]
			local buff_extension = ScriptUnit.has_extension(enemy_unit, "buff_system")

			if buff_extension then
				buff_extension:add_internally_controlled_buff("shock_grenade_interval", t, "owner_unit", player_unit)
			end
		end

		local fx_system = Managers.state.extension:system("fx_system")

		fx_system:trigger_wwise_event(SFX_NAMES.shock_aoe_big, shock_area_position)
		fx_system:trigger_vfx(VFX_NAMES.big_shock, shock_area_position)
	end,
}

local burning_stacks_on_melee_hit = HordesBuffsData.hordes_buff_burning_on_melee_hit.buff_stats.stacks.value

templates.hordes_buff_burning_on_melee_hit = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		local is_ogryn_lunge_hit = params.damage_type == "ogryn_lunge"
		local is_zealot_dash_hit = params.damage_profile and params.damage_profile.name == "zealot_dash_impact"

		return CheckProcFunctions.on_melee_hit(params, template_data, template_context, t) and not is_ogryn_lunge_hit and not is_zealot_dash_hit
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local victim_unit = params.attacked_unit
		local victim_buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

		if HEALTH_ALIVE[victim_unit] and victim_buff_extension then
			local t = FixedFrame.get_latest_fixed_time()
			local player_unit = template_context.unit

			victim_buff_extension:add_internally_controlled_buff_with_stacks("flamer_assault", burning_stacks_on_melee_hit, t, "owner_unit", player_unit)

			local fx_system = Managers.state.extension:system("fx_system")
			local enemy_position = POSITION_LOOKUP[victim_unit]

			fx_system:trigger_wwise_event(SFX_NAMES.burning_proc, enemy_position)
		end
	end,
}

local burning_stacks_on_ranged_hit = HordesBuffsData.hordes_buff_burning_on_ranged_hit.buff_stats.stacks.value

templates.hordes_buff_burning_on_ranged_hit = {
	class_name = "proc_buff",
	cooldown_duration = 0.5,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_ranged_hit,
	proc_func = function (params, template_data, template_context)
		local victim_unit = params.attacked_unit
		local victim_buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

		if HEALTH_ALIVE[victim_unit] and victim_buff_extension then
			local t = FixedFrame.get_latest_fixed_time()
			local player_unit = template_context.unit

			victim_buff_extension:add_internally_controlled_buff_with_stacks("flamer_assault", burning_stacks_on_ranged_hit, t, "owner_unit", player_unit)

			local fx_system = Managers.state.extension:system("fx_system")
			local enemy_position = POSITION_LOOKUP[victim_unit]

			fx_system:trigger_wwise_event(SFX_NAMES.burning_proc, enemy_position)
		end
	end,
}

local burning_stacks_on_melee_hit_taken = HordesBuffsData.hordes_buff_burning_on_melee_hit_taken.buff_stats.stacks.value

templates.hordes_buff_burning_on_melee_hit_taken = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_player_hit_received] = 1,
	},
	check_proc_func = CheckProcFunctions.on_melee_hit,
	proc_func = function (params, template_data, template_context)
		if params.damage == 0 then
			return
		end

		local attacker_unit = params.attack_instigator_unit
		local attacker_buff_extension = ScriptUnit.has_extension(attacker_unit, "buff_system")

		if HEALTH_ALIVE[attacker_unit] and attacker_buff_extension then
			local t = FixedFrame.get_latest_fixed_time()
			local player_unit = template_context.unit

			attacker_buff_extension:add_internally_controlled_buff_with_stacks("flamer_assault", burning_stacks_on_melee_hit_taken, t, "owner_unit", player_unit)

			local fx_system = Managers.state.extension:system("fx_system")
			local enemy_position = POSITION_LOOKUP[attacker_unit]

			fx_system:trigger_wwise_event(SFX_NAMES.burning_proc, enemy_position)
		end
	end,
}

local shock_on_melee_hit_chance = HordesBuffsData.hordes_buff_shock_on_melee_hit.buff_stats.shock_chance.value

templates.hordes_buff_shock_on_melee_hit = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_hit] = shock_on_melee_hit_chance,
	},
	check_proc_func = CheckProcFunctions.on_melee_hit,
	proc_func = function (params, template_data, template_context)
		local victim_unit = params.attacked_unit
		local victim_buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

		if HEALTH_ALIVE[victim_unit] and victim_buff_extension then
			local t = FixedFrame.get_latest_fixed_time()
			local player_unit = template_context.unit

			victim_buff_extension:add_internally_controlled_buff_with_stacks("hordes_ailment_shock", 1, t, "owner_unit", player_unit)

			local fx_system = Managers.state.extension:system("fx_system")
			local enemy_position = POSITION_LOOKUP[victim_unit]

			fx_system:trigger_wwise_event(SFX_NAMES.shock_proc, enemy_position)
			fx_system:trigger_vfx(VFX_NAMES.single_target_shock, enemy_position)
		end
	end,
}

local shock_on_ranged_hit_chance = HordesBuffsData.hordes_buff_shock_on_ranged_hit.buff_stats.shock_chance.value

templates.hordes_buff_shock_on_ranged_hit = {
	class_name = "proc_buff",
	cooldown_duration = 1,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_hit] = shock_on_ranged_hit_chance,
	},
	check_proc_func = CheckProcFunctions.on_ranged_hit,
	proc_func = function (params, template_data, template_context)
		local victim_unit = params.attacked_unit
		local victim_buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")

		if HEALTH_ALIVE[victim_unit] and victim_buff_extension then
			local t = FixedFrame.get_latest_fixed_time()
			local player_unit = template_context.unit

			victim_buff_extension:add_internally_controlled_buff_with_stacks("hordes_ailment_shock", 2, t, "owner_unit", player_unit)

			local fx_system = Managers.state.extension:system("fx_system")
			local enemy_position = POSITION_LOOKUP[victim_unit]

			fx_system:trigger_wwise_event(SFX_NAMES.shock_proc, enemy_position)
			fx_system:trigger_vfx(VFX_NAMES.single_target_shock, enemy_position)
		end
	end,
}
templates.hordes_buff_movement_bonuses_on_toughness_broken = {
	active_duration = 6,
	class_name = "proc_buff",
	cooldown_duration = 30,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_player_hit_received] = 1,
	},
	keywords = {
		buff_keywords.stun_immune_toughness_broken,
	},
	proc_keywords = {
		buff_keywords.stun_immune,
		buff_keywords.slowdown_immune,
	},
	check_proc_func = function (params, template_data, template_context, t)
		return params.attack_result == "toughness_broken"
	end,
	proc_func = function (params, template_data, template_context)
		Stamina.add_stamina_percent(template_context.unit, 0.5)
	end,
}

local percent_damage_increase_toughness_broken = HordesBuffsData.hordes_buff_damage_increase_on_toughness_broken.buff_stats.damage.value

templates.hordes_buff_damage_increase_on_toughness_broken = {
	active_duration = 10,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_player_hit_received] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.damage] = percent_damage_increase_toughness_broken,
	},
	check_proc_func = function (params, template_data, template_context, t)
		return params.attack_result == "toughness_broken"
	end,
}
templates.hordes_buff_toughness_on_melee_kills = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_melee_kill,
	proc_func = function (params, template_data, template_context)
		Toughness.replenish_percentage(template_context.unit, 0.05, false)
	end,
}

local percent_toughness_regen_on_ranged_kill = HordesBuffsData.hordes_buff_toughness_on_ranged_kill.buff_stats.thoughness_regen.value

templates.hordes_buff_toughness_on_ranged_kill = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_ranged_kill,
	proc_func = function (params, template_data, template_context)
		Toughness.replenish_percentage(template_context.unit, percent_toughness_regen_on_ranged_kill, false)
	end,
}

local percentage_toughness_per_fire_damage_dealt = HordesBuffsData.hordes_buff_toughness_on_fire_damage_dealt.buff_stats.thoughness_regen.value

templates.hordes_buff_toughness_on_fire_damage_dealt = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_damage_dealt] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		return params.damage_type and params.damage_type == "burning"
	end,
	proc_func = function (params, template_data, template_context)
		Toughness.replenish_percentage(template_context.unit, percentage_toughness_per_fire_damage_dealt, false)
	end,
}
templates.hordes_buff_toughness_regen_out_of_melee_range = {
	always_show_in_hud = true,
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase
		template_data.ticks_per_second = 1
		template_data.toughness_percentage_per_tick = 0.05

		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")

		template_data.enemy_side_names = enemy_side_names
	end,
	update_func = function (template_data, template_context, dt, t, template)
		local next_regen_t = template_data.next_regen_t

		if not next_regen_t then
			template_data.next_regen_t = t + 1 / template_data.ticks_per_second

			return
		end

		if next_regen_t < t then
			local player_unit = template_context.unit
			local player_position = POSITION_LOOKUP[player_unit]
			local broadphase = template_data.broadphase
			local enemy_side_names = template_data.enemy_side_names
			local num_hits = broadphase.query(broadphase, player_position, range_melee, BROADPHASE_RESULTS, enemy_side_names)

			if num_hits == 0 then
				if template_context.is_server then
					Toughness.replenish_percentage(template_context.unit, template_data.toughness_percentage_per_tick, false)
				end

				template_data.next_regen_t = t + 1 / template_data.ticks_per_second
				template_data.is_active = true
			else
				template_data.is_active = false
			end
		end
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.is_active
	end,
}

local percentage_toughness_regen_close_to_enemies = HordesBuffsData.hordes_buff_toughness_regen_in_melee_range.buff_stats.thoughness_regen.value
local detection_range_for_tougness_regen_close_to_enemies = HordesBuffsData.hordes_buff_toughness_regen_in_melee_range.buff_stats.range.value
local enemies_in_range_needed_for_tougness_regen = HordesBuffsData.hordes_buff_toughness_regen_in_melee_range.buff_stats.ennemies_count.value

templates.hordes_buff_toughness_regen_in_melee_range = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase

		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local character_state_component = unit_data_extension:read_component("character_state")

		template_data.min_num_enemies = enemies_in_range_needed_for_tougness_regen
		template_data.ticks_per_second = 1
		template_data.toughness_percentage_per_tick = percentage_toughness_regen_close_to_enemies
		template_data.enemy_side_names = enemy_side_names
		template_data.character_state_component = character_state_component
		template_data.check_enemy_proximity_t = 0
	end,
	update_func = function (template_data, template_context, dt, t, template)
		if template_data.is_active and t >= template_data.next_toughness_regen then
			template_data.next_toughness_regen = t + 1 / template_data.ticks_per_second

			if template_context.is_server then
				Toughness.replenish_percentage(template_context.unit, template_data.toughness_percentage_per_tick, false)
			end
		end

		local check_enemy_proximity_t = template_data.check_enemy_proximity_t

		if t < check_enemy_proximity_t then
			return
		end

		template_data.check_enemy_proximity_t = t + 0.1

		local is_disabled = PlayerUnitStatus.is_disabled(template_data.character_state_component)

		if is_disabled then
			template_data.is_active = false

			return
		end

		local player_unit = template_context.unit
		local player_position = POSITION_LOOKUP[player_unit]
		local broadphase = template_data.broadphase
		local enemy_side_names = template_data.enemy_side_names
		local num_hits = broadphase.query(broadphase, player_position, detection_range_for_tougness_regen_close_to_enemies, BROADPHASE_RESULTS, enemy_side_names)
		local was_active = template_data.is_active
		local is_active = num_hits >= template_data.min_num_enemies

		if was_active ~= is_active then
			if is_active then
				template_data.next_toughness_regen = t + 1 / template_data.ticks_per_second
			end

			template_data.is_active = is_active
		end
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.is_active
	end,
}
templates.hordes_buff_toughness_coherency_regen_increase = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.toughness_coherency_regen_rate_modifier] = 0.5,
	},
}

local percent_toughness_damage_reduction_while_above_threshold = HordesBuffsData.hordes_buff_toughness_damage_taken_above_threshold.buff_stats.damage_reduce.value
local percent_toughness_threshold_for_damage_reduction = HordesBuffsData.hordes_buff_toughness_damage_taken_above_threshold.buff_stats.toughness.value

templates.hordes_buff_toughness_damage_taken_above_threshold = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	conditional_stat_buffs = {
		[stat_buffs.toughness_damage_taken_modifier] = -percent_toughness_damage_reduction_while_above_threshold,
	},
	start_func = function (template_data, template_context)
		local player_unit = template_context.unit

		template_data.player_toughness_extension = ScriptUnit.has_extension(player_unit, "toughness_system")
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		local current_toughness_percent = template_data.player_toughness_extension:current_toughness_percent()

		return current_toughness_percent >= percent_toughness_threshold_for_damage_reduction
	end,
}

local percent_burning_dmg_per_burning_enemy = HordesBuffsData.hordes_buff_burning_damage_per_burning_enemy.buff_stats.damage.value

templates.hordes_buff_burning_damage_per_burning_enemy = {
	class_name = "buff",
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	lerped_stat_buffs = {
		[stat_buffs.burning_damage] = {
			min = 0,
			max = percent_burning_dmg_per_burning_enemy,
		},
	},
	start_func = function (template_data, template_context)
		template_data.burn_extra_damage_max_stacks = 10

		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase
		template_data.num_stacks = 0

		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")
		local t = FixedFrame.get_latest_fixed_time()

		template_data.next_check_t = t + 1
		template_data.enemy_side_names = enemy_side_names
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local next_check_t = template_data.next_check_t

		if next_check_t < t then
			local player_unit = template_context.unit
			local player_position = POSITION_LOOKUP[player_unit]
			local broadphase = template_data.broadphase
			local enemy_side_names = template_data.enemy_side_names
			local num_stacks = 0
			local num_hits = broadphase.query(broadphase, player_position, range_close, BROADPHASE_RESULTS, enemy_side_names)

			for i = 1, num_hits do
				local enemy_unit = BROADPHASE_RESULTS[i]
				local buff_extension = ScriptUnit.has_extension(enemy_unit, "buff_system")

				if buff_extension then
					local target_is_burning = buff_extension:has_keyword(buff_keywords.burning)

					if target_is_burning then
						num_stacks = num_stacks + 1
					end
				end
			end

			template_data.num_stacks = num_stacks
			template_data.next_check_t = t + 1
		end

		return math.clamp(template_data.num_stacks / template_data.burn_extra_damage_max_stacks, 0, 1)
	end,
	visual_stack_count = function (template_data, template_context)
		return math.clamp(template_data.num_stacks, 0, template_data.burn_extra_damage_max_stacks)
	end,
}

local percent_damage_reduction_close_to_electrocuted_enemy = HordesBuffsData.hordes_buff_damage_taken_close_to_electrocuted_enemy.buff_stats.damage_reduce.value

templates.hordes_buff_damage_taken_close_to_electrocuted_enemy = {
	class_name = "proc_buff",
	force_predicted_proc = true,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_damage_taken] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		return template_data.is_active
	end,
	proc_func = function (params, template_data, template_context, t)
		template_data.player_fx_extension:trigger_wwise_event(SFX_NAMES.reduced_damage_hit, false, template_context.unit)
	end,
	conditional_stat_buffs = {
		[stat_buffs.damage_taken_modifier] = -percent_damage_reduction_close_to_electrocuted_enemy,
	},
	start_func = function (template_data, template_context)
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase

		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local character_state_component = unit_data_extension:read_component("character_state")

		template_data.player_fx_extension = ScriptUnit.has_extension(template_context.unit, "fx_system")
		template_data.proximity_check_interval = 1
		template_data.check_enemy_proximity_t = 0
		template_data.enemy_side_names = enemy_side_names
		template_data.character_state_component = character_state_component
	end,
	update_func = function (template_data, template_context, dt, t, template)
		local check_enemy_proximity_t = template_data.check_enemy_proximity_t

		if t < check_enemy_proximity_t then
			return
		end

		template_data.check_enemy_proximity_t = t + template_data.proximity_check_interval

		local is_disabled = PlayerUnitStatus.is_disabled(template_data.character_state_component)

		if is_disabled then
			template_data.is_active = false

			return
		end

		local player_unit = template_context.unit
		local player_position = POSITION_LOOKUP[player_unit]
		local broadphase = template_data.broadphase
		local enemy_side_names = template_data.enemy_side_names
		local num_hits = broadphase.query(broadphase, player_position, range_melee, BROADPHASE_RESULTS, enemy_side_names)
		local was_active = template_data.is_active
		local is_active = false

		for i = 1, num_hits do
			local enemy_unit = BROADPHASE_RESULTS[i]

			if HEALTH_ALIVE[enemy_unit] then
				local buff_extension = ScriptUnit.extension(enemy_unit, "buff_system")

				is_active = buff_extension:has_keyword(buff_keywords.electrocuted)

				if is_active then
					break
				end
			end
		end

		if was_active ~= is_active then
			template_data.is_active = is_active
		end
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.is_active
	end,
}

local grenade_replenishment_over_time_interval = HordesBuffsData.hordes_buff_grenade_replenishment_over_time.buff_stats.time.value

templates.hordes_buff_grenade_replenishment_over_time = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		template_data.ability_extension = ScriptUnit.has_extension(unit, "ability_system")
		template_data.fx_extension = ScriptUnit.extension(unit, "fx_system")
		template_data.first_person_extension = ScriptUnit.extension(unit, "first_person_system")
		template_data.missing_charges = 0
		template_data.grenade_replenishment_cooldown = grenade_replenishment_over_time_interval
	end,
	update_func = function (template_data, template_context, dt, t, template)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		if not template_data.ability_extension then
			local ability_extension = ScriptUnit.has_extension(unit, "ability_system")

			if not ability_extension then
				return
			end

			template_data.ability_extension = ability_extension
		end

		local ability_extension = template_data.ability_extension

		if not ability_extension or not ability_extension:has_ability_type("grenade_ability") then
			template_data.next_grenade_t = nil
			template_data.missing_charges = 0

			return
		end

		local missing_charges = ability_extension and ability_extension:missing_ability_charges("grenade_ability")

		if missing_charges == 0 then
			template_data.next_grenade_t = nil
			template_data.missing_charges = 0

			return
		end

		template_data.missing_charges = missing_charges

		local next_grenade_t = template_data.next_grenade_t

		if not next_grenade_t then
			template_data.next_grenade_t = t + template_data.grenade_replenishment_cooldown

			return
		end

		if next_grenade_t < t then
			if ability_extension and ability_extension:has_ability_type("grenade_ability") then
				ability_extension:restore_ability_charge("grenade_ability", 1)

				local player_fx_extension = ScriptUnit.has_extension(unit, "fx_system")

				if player_fx_extension then
					player_fx_extension:trigger_wwise_events_local_only(SFX_NAMES.grenade_refil, nil, unit)
				end
			end

			template_data.next_grenade_t = nil
		end
	end,
}

function _give_passive_grenade_replenishment_buff(unit)
	local current_time = FixedFrame.get_latest_fixed_time()
	local buff_extension = ScriptUnit.extension(unit, "buff_system")

	if buff_extension then
		local _, buff_index, component_index = buff_extension:add_externally_controlled_buff("hordes_buff_grenade_replenishment_over_time_passive", current_time)
	end
end

templates.hordes_buff_grenade_replenishment_over_time_passive = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_sub_buff,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		template_data.ability_extension = ScriptUnit.has_extension(unit, "ability_system")
		template_data.fx_extension = ScriptUnit.extension(unit, "fx_system")
		template_data.first_person_extension = ScriptUnit.extension(unit, "first_person_system")
		template_data.missing_charges = 0
		template_data.grenade_replenishment_cooldown = 180
	end,
	update_func = function (template_data, template_context, dt, t, template)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		if not template_data.ability_extension then
			local ability_extension = ScriptUnit.has_extension(unit, "ability_system")

			if not ability_extension then
				return
			end

			template_data.ability_extension = ability_extension
		end

		local ability_extension = template_data.ability_extension

		if not ability_extension:has_ability_type("grenade_ability") then
			template_data.next_grenade_t = nil
			template_data.missing_charges = 0

			return
		end

		local missing_charges = ability_extension and ability_extension:missing_ability_charges("grenade_ability")

		if missing_charges == 0 then
			template_data.next_grenade_t = nil
			template_data.missing_charges = 0

			return
		end

		template_data.missing_charges = missing_charges

		local next_grenade_t = template_data.next_grenade_t

		if not next_grenade_t then
			template_data.next_grenade_t = t + template_data.grenade_replenishment_cooldown

			return
		end

		if next_grenade_t < t then
			if ability_extension and ability_extension:has_ability_type("grenade_ability") then
				ability_extension:restore_ability_charge("grenade_ability", 1)

				local player_fx_extension = ScriptUnit.has_extension(unit, "fx_system")

				if player_fx_extension then
					player_fx_extension:trigger_wwise_events_local_only(SFX_NAMES.grenade_refil, nil, unit)
				end
			end

			template_data.next_grenade_t = nil
		end
	end,
}
templates.hordes_buff_grenade_replenishment_on_elite_kill = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_minion_death] = 0.05,
	},
	check_proc_func = CheckProcFunctions.on_elite_or_special_minion_death,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local attacking_unit = params.attacking_unit
		local units_in_coherence = template_data.coherency_extension:in_coherence_units()
		local attacking_unit_is_in_coherency = false

		for coherency_unit, _ in pairs(units_in_coherence) do
			if coherency_unit == attacking_unit then
				attacking_unit_is_in_coherency = true

				break
			end
		end

		if not attacking_unit_is_in_coherency then
			return
		end

		local unit = template_context.unit
		local fx_extension = ScriptUnit.has_extension(unit, "fx_system")

		if fx_extension then
			local position = POSITION_LOOKUP[unit]

			fx_extension:trigger_exclusive_wwise_event("wwise/events/player/play_pick_up_ammo_01", position)
		end

		local ability_extension = ScriptUnit.has_extension(unit, "ability_system")

		if ability_extension and ability_extension:has_ability_type("grenade_ability") then
			ability_extension:restore_ability_charge("grenade_ability", 1)

			local player_fx_extension = ScriptUnit.has_extension(unit, "fx_system")

			if player_fx_extension then
				player_fx_extension:trigger_wwise_events_local_only(SFX_NAMES.grenade_refil, nil, unit)
			end
		end
	end,
}
templates.hordes_buff_combat_ability_cooldown_reduction_on_elite_kills = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_special_kill,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local ability_extension = ScriptUnit.extension(unit, "ability_system")

		template_data.ability_extension = ability_extension
	end,
	proc_func = function (params, template_data, template_context)
		local cooldown_reduction = 10

		template_data.ability_extension:reduce_ability_cooldown_time("combat_ability", cooldown_reduction)
	end,
}

local percent_damage_taken_to_ability_cooldown_conversion_rate = HordesBuffsData.hordes_buff_combat_ability_cooldown_on_damage_taken.buff_stats.damage_to_cooldown.value

templates.hordes_buff_combat_ability_cooldown_on_damage_taken = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_damage_taken] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local health_extension = ScriptUnit.extension(unit, "health_system")

		template_data.health_extension = health_extension

		local ability_extension = ScriptUnit.extension(unit, "ability_system")

		template_data.ability_extension = ability_extension

		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local character_state_read_component = unit_data_extension:read_component("character_state")

		template_data.character_state_read_component = character_state_read_component
	end,
	check_proc_func = function (params, template_data, template_context)
		if params.attacked_unit ~= template_context.unit then
			return false
		end

		local character_state_read_component = template_data.character_state_read_component
		local is_knocked_down = PlayerUnitStatus.is_knocked_down(character_state_read_component)

		if is_knocked_down then
			return false
		end

		return true
	end,
	proc_func = function (params, template_data, template_context)
		local ability_extension = template_data.ability_extension
		local damage_taken = params.damage_amount
		local damage_taken_to_ability_cd_percentage = percent_damage_taken_to_ability_cooldown_conversion_rate
		local cooldown_percent = damage_taken * damage_taken_to_ability_cd_percentage

		ability_extension:reduce_ability_cooldown_percentage("combat_ability", cooldown_percent)
	end,
}

local percent_ability_cooldown_recovered_per_kill = HordesBuffsData.hordes_buff_combat_ability_cooldown_on_kills.buff_stats.cooldown.value

templates.hordes_buff_combat_ability_cooldown_on_kills = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local health_extension = ScriptUnit.extension(unit, "health_system")

		template_data.health_extension = health_extension

		local ability_extension = ScriptUnit.extension(unit, "ability_system")

		template_data.ability_extension = ability_extension

		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local character_state_read_component = unit_data_extension:read_component("character_state")

		template_data.character_state_read_component = character_state_read_component
	end,
	check_proc_func = function (params, template_data, template_context)
		local is_melee_hit = CheckProcFunctions.on_melee_hit(params, template_data, template_context)

		if not is_melee_hit then
			return false
		end

		local character_state_read_component = template_data.character_state_read_component
		local is_knocked_down = PlayerUnitStatus.is_knocked_down(character_state_read_component)

		if is_knocked_down then
			return false
		end

		return true
	end,
	proc_func = function (params, template_data, template_context)
		local ability_extension = template_data.ability_extension

		ability_extension:reduce_ability_cooldown_percentage("combat_ability", percent_ability_cooldown_recovered_per_kill)
	end,
}

function _compute_fire_pulse(is_server, player_unit, broadphase, enemy_side_names, t, optional_stacks, optional_skip_effects)
	if not is_server then
		return
	end

	local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
	local character_state_component = unit_data_extension:read_component("character_state")
	local requires_help = PlayerUnitStatus.requires_help(character_state_component)

	if not HEALTH_ALIVE[player_unit] or requires_help then
		return
	end

	local player_position = POSITION_LOOKUP[player_unit]
	local num_hits = broadphase.query(broadphase, player_position, 12, BROADPHASE_RESULTS, enemy_side_names)

	for i = 1, num_hits do
		local enemy_unit = BROADPHASE_RESULTS[i]
		local buff_extension = ScriptUnit.has_extension(enemy_unit, "buff_system")

		if buff_extension then
			buff_extension:add_internally_controlled_buff_with_stacks("flamer_assault", optional_stacks or 1, t, "owner_unit", player_unit)

			local fx_system = Managers.state.extension:system("fx_system")
			local enemy_position = POSITION_LOOKUP[enemy_unit]

			fx_system:trigger_wwise_event(SFX_NAMES.burning_proc, enemy_position)
		end
	end

	if not optional_skip_effects then
		local fx_system = Managers.state.extension:system("fx_system")

		fx_system:trigger_wwise_event(num_hits >= 10 and SFX_NAMES.inferno or SFX_NAMES.fire_pulse, nil, player_unit)

		local player_fx_extension = ScriptUnit.extension(player_unit, "fx_system")

		if player_fx_extension then
			local variable_name = "radius"
			local variable_value = Vector3(10, 10, 10)
			local vfx_position = player_position + Vector3(0, 0, 0.65)

			player_fx_extension:spawn_particles(VFX_NAMES.fire_pulse, vfx_position, nil, nil, variable_name, variable_value, true)
		end
	end
end

function _compute_stagger_and_supression_pulse(is_server, player_unit, broadphase, enemy_side_names, t, optional_skip_effects)
	if not is_server then
		return
	end

	local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
	local character_state_component = unit_data_extension:read_component("character_state")
	local requires_help = PlayerUnitStatus.requires_help(character_state_component)

	if not HEALTH_ALIVE[player_unit] or requires_help then
		return
	end

	local player_position = POSITION_LOOKUP[player_unit]
	local num_hits = broadphase.query(broadphase, player_position, range_melee, BROADPHASE_RESULTS, enemy_side_names)
	local fx_system = Managers.state.extension:system("fx_system")

	for i = 1, num_hits do
		local enemy_unit = BROADPHASE_RESULTS[i]
		local blackboard = BLACKBOARDS[enemy_unit]
		local stagger_component = blackboard.stagger
		local is_staggered = stagger_component.num_triggered_staggers > 0

		if HEALTH_ALIVE[enemy_unit] and not is_staggered then
			local enemy_position = POSITION_LOOKUP[enemy_unit]
			local attack_direction = Vector3.normalize(Vector3.flat(enemy_position - player_position))
			local random_duration_range = math.random_range(2.6666666666666665, 4)

			Stagger.force_stagger(enemy_unit, stagger_types.medium, attack_direction, random_duration_range, 1, 0.3333333333333333, player_unit)

			if not optional_skip_effects and i <= 5 then
				fx_system:trigger_wwise_event(SFX_NAMES.stagger_hit, enemy_position)
			end
		end
	end

	if not optional_skip_effects then
		fx_system:trigger_wwise_event(SFX_NAMES.stagger_pulse, nil, player_unit)

		local player_fx_extension = ScriptUnit.extension(player_unit, "fx_system")

		if player_fx_extension then
			local vfx_position = player_position + Vector3(0, 0, 0.65)

			player_fx_extension:spawn_particles(VFX_NAMES.stagger_pulse, vfx_position, nil, nil, nil, nil, true)
		end
	end
end

local fire_pulse_burning_stacks = HordesBuffsData.hordes_buff_fire_pulse.buff_stats.stacks.value

templates.hordes_buff_fire_pulse = {
	class_name = "interval_buff",
	interval = 20,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase

		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")

		template_data.enemy_side_names = enemy_side_names
	end,
	interval_func = function (template_data, template_context, template, time_since_start, t)
		if not template_context.is_server then
			return
		end

		_compute_fire_pulse(template_context.is_server, template_context.unit, template_data.broadphase, template_data.enemy_side_names, t, fire_pulse_burning_stacks)
	end,
}

local staggering_pulse_interval = HordesBuffsData.hordes_buff_staggering_pulse.buff_stats.time.value

templates.hordes_buff_staggering_pulse = {
	class_name = "interval_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	interval = staggering_pulse_interval,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase

		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")

		template_data.enemy_side_names = enemy_side_names
	end,
	interval_func = function (template_data, template_context, template, time_since_start, t)
		if not template_context.is_server then
			return
		end

		_compute_stagger_and_supression_pulse(template_context.is_server, template_context.unit, template_data.broadphase, template_data.enemy_side_names, t)
	end,
}
templates.hordes_buff_shock_closest_enemy_on_interval = {
	class_name = "interval_buff",
	interval = 10,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		template_data.broadphase, template_data.enemy_side_names = SharedBuffFunctions.get_broadphase_and_enemy_side_names(unit)
	end,
	interval_func = function (template_data, template_context, template, time_since_start, t)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
		local character_state_component = unit_data_extension:read_component("character_state")
		local requires_help = PlayerUnitStatus.requires_help(character_state_component)

		if not HEALTH_ALIVE[player_unit] or requires_help then
			return
		end

		local player_position = POSITION_LOOKUP[player_unit]
		local broadphase = template_data.broadphase
		local enemy_side_names = template_data.enemy_side_names
		local num_hits = broadphase.query(broadphase, player_position, range_melee, BROADPHASE_RESULTS, enemy_side_names)

		if num_hits > 0 then
			local enemy_unit = BROADPHASE_RESULTS[1]
			local buff_extension = ScriptUnit.has_extension(enemy_unit, "buff_system")

			if buff_extension then
				buff_extension:add_internally_controlled_buff("hordes_ailment_shock", t, "owner_unit", player_unit)

				local fx_system = Managers.state.extension:system("fx_system")
				local enemy_position = POSITION_LOOKUP[enemy_unit]

				fx_system:trigger_wwise_event(SFX_NAMES.shock_proc, enemy_position)
				fx_system:trigger_vfx(VFX_NAMES.single_target_shock, enemy_position)
			end
		end
	end,
}

local function _trigger_brain_burst_on_target(target_unit, attacking_unit)
	if not HEALTH_ALIVE[target_unit] then
		return
	end

	local player_unit = attacking_unit
	local player_pos = POSITION_LOOKUP[player_unit]
	local damage_profile = DamageProfileTemplates.psyker_smite_kill
	local hit_unit_pos = POSITION_LOOKUP[target_unit]
	local target_unit_data_extension = ScriptUnit.has_extension(target_unit, "unit_data_system")
	local target_breed = target_unit_data_extension and target_unit_data_extension:breed()
	local attack_direction = Vector3.normalize(hit_unit_pos - player_pos)
	local hit_world_position = hit_unit_pos
	local hit_zone_name, hit_actor

	if target_breed then
		local hit_zone_weakspot_types = target_breed.hit_zone_weakspot_types
		local preferred_hit_zone_name = "head"
		local hit_zone = hit_zone_weakspot_types and (hit_zone_weakspot_types[preferred_hit_zone_name] and preferred_hit_zone_name or next(hit_zone_weakspot_types)) or hit_zone_names.center_mass
		local actors = HitZone.get_actor_names(target_unit, hit_zone)
		local hit_actor_name = actors[1]

		hit_zone_name = hit_zone
		hit_actor = Unit.actor(target_unit, hit_actor_name)

		local actor_node = Actor.node(hit_actor)

		hit_world_position = Unit.world_position(target_unit, actor_node)
	end

	local damage_dealt, attack_result, damage_efficiency = Attack.execute(target_unit, damage_profile, "power_level", 500, "charge_level", 1, "hit_zone_name", hit_zone_name, "hit_actor", hit_actor, "attacking_unit", player_unit, "attack_type", attack_types.buff, "damage_type", damage_types.smite)

	ImpactEffect.play(target_unit, hit_actor, damage_dealt, damage_types.smite, hit_zone_name, attack_result, hit_world_position, nil, attack_direction, player_unit, nil, nil, nil, damage_efficiency, damage_profile)
end

local function _trigger_aoe_shock_at_position(target_position, owner_unit, broadphase, target_side_names, range, t)
	local num_hits = broadphase.query(broadphase, target_position, range, BROADPHASE_RESULTS, target_side_names)

	for i = 1, num_hits do
		local enemy_unit = BROADPHASE_RESULTS[i]
		local buff_extension = ScriptUnit.has_extension(enemy_unit, "buff_system")

		if buff_extension then
			buff_extension:add_internally_controlled_buff("hordes_ailment_shock", t, "owner_unit", owner_unit)
		end
	end

	local fx_system = Managers.state.extension:system("fx_system")

	fx_system:trigger_wwise_event(SFX_NAMES.shock_aoe_big, target_position)
	fx_system:trigger_vfx(VFX_NAMES.big_shock, target_position)
end

local function _get_random_nearby_alive_enemy_from_position(target_position, broadphase, target_side_names, range)
	local num_hits = broadphase.query(broadphase, target_position, range, BROADPHASE_RESULTS, target_side_names)

	if num_hits == 0 then
		return nil
	end

	local picked_unit

	for i = 1, num_hits do
		local target_unit = BROADPHASE_RESULTS[i]

		if HEALTH_ALIVE[target_unit] then
			local pick_chance = i / num_hits
			local picked = pick_chance >= math.random()

			if picked then
				picked_unit = target_unit

				break
			elseif picked_unit == nil then
				picked_unit = target_unit
			end
		end
	end

	return picked_unit
end

local aoe_shock_interval = HordesBuffsData.hordes_buff_aoe_shock_closest_enemy_on_interval.buff_stats.time.value
local aoe_shock_on_interval_range = HordesBuffsData.hordes_buff_aoe_shock_closest_enemy_on_interval.buff_stats.range.value

templates.hordes_buff_aoe_shock_closest_enemy_on_interval = {
	class_name = "interval_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	interval = aoe_shock_interval,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		template_data.broadphase, template_data.enemy_side_names = SharedBuffFunctions.get_broadphase_and_enemy_side_names(unit)
	end,
	interval_func = function (template_data, template_context, template, time_since_start, t)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
		local character_state_component = unit_data_extension:read_component("character_state")
		local requires_help = PlayerUnitStatus.requires_help(character_state_component)

		if not HEALTH_ALIVE[player_unit] or requires_help then
			return
		end

		local player_position = POSITION_LOOKUP[player_unit]
		local broadphase = template_data.broadphase
		local enemy_side_names = template_data.enemy_side_names
		local num_hits = broadphase.query(broadphase, player_position, 10, BROADPHASE_RESULTS, enemy_side_names)

		if num_hits > 0 then
			local random_enemy_unit_index = math.random(num_hits)
			local enemy_unit = BROADPHASE_RESULTS[random_enemy_unit_index]

			if HEALTH_ALIVE[enemy_unit] then
				local enemy_unit_position = POSITION_LOOKUP[enemy_unit]

				_trigger_aoe_shock_at_position(enemy_unit_position, player_unit, broadphase, enemy_side_names, aoe_shock_on_interval_range, t)
			end
		end
	end,
}

local percent_chance_enemy_explodes_on_ranged_kill = HordesBuffsData.hordes_buff_explode_enemies_on_ranged_kill.buff_stats.chance.value

templates.hordes_buff_explode_enemies_on_ranged_kill = {
	class_name = "proc_buff",
	cooldown_duration = 1,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_kill] = percent_chance_enemy_explodes_on_ranged_kill,
	},
	check_proc_func = CheckProcFunctions.on_ranged_hit,
	proc_func = function (params, template_data, template_context)
		local dyring_unit_position = params.attacked_unit_position and params.attacked_unit_position:unbox()
		local explosion_position = dyring_unit_position + Vector3.up()
		local explosion_template = ExplosionTemplates.frag_grenade

		Explosion.create_explosion(template_context.world, template_context.physics_world, explosion_position, Vector3.up(), template_context.unit, explosion_template, DEFAULT_POWER_LEVEL, 1, attack_types.explosion)
	end,
}

local function _spawn_telekine_dome_at_position(physics_world, owner_unit, target_position)
	local ray_origin = target_position + Vector3.up()
	local down_direction = Vector3.down()
	local ray_distance = 10
	local hit, spawn_position, _, _, _ = PhysicsWorld.raycast(physics_world, ray_origin, down_direction, ray_distance, "closest", "types", "both", "collision_filter", "filter_player_place_deployable")

	if not hit then
		spawn_position = target_position
	end

	local unit_name = "content/characters/player/human/attachments_combat/psyker_shield/shield_sphere_functional"
	local husk_unit_name = "content/characters/player/human/attachments_combat/psyker_shield/shield_sphere_functional"
	local unit_template = "force_field"
	local material
	local rotation = Quaternion.identity()
	local unit = Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template, spawn_position, rotation, material, husk_unit_name, nil, owner_unit, "sphere")
end

local shock_on_toughness_broken_range = HordesBuffsData.hordes_buff_shock_pulse_on_toughness_broken.buff_stats.range.value

templates.hordes_buff_shock_pulse_on_toughness_broken = {
	class_name = "proc_buff",
	cooldown_duration = 10,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_player_toughness_broken] = 1,
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase

		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")

		template_data.enemy_side_names = enemy_side_names
	end,
	check_proc_func = function (params, template_data, template_context, t)
		return template_context.unit == params.unit
	end,
	proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit
		local player_position = POSITION_LOOKUP[player_unit]
		local broadphase = template_data.broadphase
		local enemy_side_names = template_data.enemy_side_names
		local num_hits = broadphase.query(broadphase, player_position, shock_on_toughness_broken_range, BROADPHASE_RESULTS, enemy_side_names)

		for i = 1, num_hits do
			local enemy_unit = BROADPHASE_RESULTS[i]
			local buff_extension = ScriptUnit.has_extension(enemy_unit, "buff_system")

			if buff_extension then
				buff_extension:add_internally_controlled_buff_with_stacks("hordes_ailment_shock", 1, t, "owner_unit", player_unit)
			end
		end

		local fx_system = Managers.state.extension:system("fx_system")

		fx_system:trigger_wwise_event(SFX_NAMES.shock_aoe_big, player_position)
		fx_system:trigger_vfx(VFX_NAMES.big_shock, player_position)
	end,
}
templates.hordes_buff_spawn_dome_shield_on_grenade_explosion = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		_give_passive_grenade_replenishment_buff(template_context.unit)
	end,
	proc_events = {
		[proc_events.on_player_grenade_exploded] = 1,
	},
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit
		local grenade_position = params.position:unbox()
		local world = template_context.world
		local physics_world = World.physics_world(world)

		_spawn_telekine_dome_at_position(physics_world, player_unit, grenade_position)
	end,
}
templates.hordes_buff_psyker_shock_on_touch_force_field = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_unit_touch_force_field] = 1,
	},
	proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return
		end

		local is_player_unit = params.is_player_unit

		if is_player_unit then
			return
		end

		local player_unit = template_context.unit
		local enemy_unit = params.passing_unit
		local buff_extension = ScriptUnit.has_extension(enemy_unit, "buff_system")

		if HEALTH_ALIVE[enemy_unit] and buff_extension then
			buff_extension:add_internally_controlled_buff_with_stacks("hordes_ailment_shock", 1, t, "owner_unit", player_unit)

			local enemy_position = POSITION_LOOKUP[enemy_unit]
			local fx_system = Managers.state.extension:system("fx_system")

			fx_system:trigger_wwise_event(SFX_NAMES.shock_proc, enemy_position)
			fx_system:trigger_vfx(VFX_NAMES.single_target_shock, enemy_position)
		end
	end,
}

local percentage_health_regen_on_interval = HordesBuffsData.hordes_buff_health_regen.buff_stats.hp_regen.value
local health_regen_interval = HordesBuffsData.hordes_buff_health_regen.buff_stats.time.value

templates.hordes_buff_health_regen = {
	class_name = "interval_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	interval = health_regen_interval,
	interval_func = function (template_data, template_context, template, time_since_start, t)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit
		local health_extension = ScriptUnit.extension(player_unit, "health_system")

		if health_extension then
			local max_health = health_extension:max_health()
			local heal_amount = max_health * percentage_health_regen_on_interval

			health_extension:add_heal(heal_amount, DamageSettings.heal_types.buff)
		end
	end,
}
templates.hordes_buff_veteran_shock_units_in_smoke_grenade = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_unit_enter_fog] = 1,
	},
	start_func = function (template_data, template_context)
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase

		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]

		template_data.side_system = side_system
		template_data.player_side = side
	end,
	proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit
		local entring_unit = params.target_unit
		local side_system = template_data.side_system
		local player_side = template_data.player_side
		local target_unit_side = side_system.side_by_unit[entring_unit]
		local is_unit_enemy = side_system:is_enemy_by_side(player_side, target_unit_side)
		local buff_extension = ScriptUnit.has_extension(entring_unit, "buff_system")

		if is_unit_enemy and HEALTH_ALIVE[entring_unit] and buff_extension then
			buff_extension:add_internally_controlled_buff_with_stacks("hordes_ailment_shock", 1, t, "owner_unit", player_unit)

			local enemy_position = POSITION_LOOKUP[entring_unit]
			local fx_system = Managers.state.extension:system("fx_system")

			fx_system:trigger_wwise_event(SFX_NAMES.shock_proc, enemy_position)
			fx_system:trigger_vfx(VFX_NAMES.single_target_shock, enemy_position)
		end
	end,
}

local coherency_corruption_healing_amount = HordesBuffsData.hordes_buff_coherency_corruption_healing.buff_stats.heal.value

templates.hordes_buff_coherency_corruption_healing = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local coherency_system = Managers.state.extension:system("coherency_system")

		coherency_system:add_external_buff(unit, "hordes_buff_coherency_corruption_healing_effect")
	end,
}
templates.hordes_buff_coherency_corruption_healing_effect = {
	class_name = "interval_buff",
	coherency_id = "hordes_buff_coherency_corruption_healing_effect",
	coherency_priority = 2,
	interval = 0.5,
	max_stacks = 4,
	max_stacks_cap = 4,
	predicted = false,
	buff_category = buff_categories.hordes_sub_buff,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		template_data.health_extension = ScriptUnit.extension(unit, "health_system")
	end,
	interval_func = function (template_data, template_context, template)
		if not template_context.is_server then
			return
		end

		local corruption_heal_amount = coherency_corruption_healing_amount

		template_data.health_extension:reduce_permanent_damage(corruption_heal_amount)
	end,
}

local coherency_extra_burning_duration_percent = HordesBuffsData.hordes_buff_coherency_burning_duration.buff_stats.linger.value

templates.hordes_buff_coherency_burning_duration = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local coherency_system = Managers.state.extension:system("coherency_system")

		coherency_system:add_external_buff(unit, "hordes_buff_coherency_burning_duration_effect")
	end,
}
templates.hordes_buff_coherency_burning_duration_effect = {
	class_name = "buff",
	coherency_id = "hordes_buff_coherency_burning_duration_increased",
	coherency_priority = 4,
	max_stacks = 4,
	max_stacks_cap = 4,
	predicted = false,
	buff_category = buff_categories.hordes_sub_buff,
	stat_buffs = {
		[stat_buffs.burning_duration] = coherency_extra_burning_duration_percent,
	},
}

local coherency_damage_vs_burning_enemies = HordesBuffsData.hordes_buff_coherency_damage_vs_burning.buff_stats.damage.value

templates.hordes_buff_coherency_damage_vs_burning = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local coherency_system = Managers.state.extension:system("coherency_system")

		coherency_system:add_external_buff(unit, "hordes_buff_coherency_damage_vs_burning_effect")
	end,
}
templates.hordes_buff_coherency_damage_vs_burning_effect = {
	class_name = "buff",
	coherency_id = "hordes_buff_coherency_damage_vs_burning",
	coherency_priority = 4,
	max_stacks = 6,
	max_stacks_cap = 6,
	predicted = false,
	buff_category = buff_categories.hordes_sub_buff,
	stat_buffs = {
		[stat_buffs.damage_vs_burning] = coherency_damage_vs_burning_enemies,
	},
}

local coherency_percent_damage_reduction_close_to_electrocuted_enemy = HordesBuffsData.hordes_buff_coherency_damage_taken_close_to_electrocuted_enemy.buff_stats.damage_reduce.value

templates.hordes_buff_coherency_damage_taken_close_to_electrocuted_enemy = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local coherency_system = Managers.state.extension:system("coherency_system")

		coherency_system:add_external_buff(unit, "hordes_buff_coherency_damage_taken_close_to_electrocuted_enemy_effect")
	end,
}
templates.hordes_buff_coherency_damage_taken_close_to_electrocuted_enemy_effect = {
	class_name = "buff",
	coherency_id = "hordes_buff_coherency_damage_taken_close_to_electrocuted_enemy",
	coherency_priority = 4,
	max_stacks = 6,
	max_stacks_cap = 6,
	predicted = false,
	buff_category = buff_categories.hordes_sub_buff,
	conditional_stat_buffs = {
		[stat_buffs.damage_taken_modifier] = -coherency_percent_damage_reduction_close_to_electrocuted_enemy,
	},
	start_func = function (template_data, template_context)
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase

		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local character_state_component = unit_data_extension:read_component("character_state")

		template_data.proximity_check_interval = 1
		template_data.check_enemy_proximity_t = 0
		template_data.enemy_side_names = enemy_side_names
		template_data.character_state_component = character_state_component
	end,
	update_func = function (template_data, template_context, dt, t, template)
		local check_enemy_proximity_t = template_data.check_enemy_proximity_t

		if t < check_enemy_proximity_t then
			return
		end

		template_data.check_enemy_proximity_t = t + template_data.proximity_check_interval

		local is_disabled = PlayerUnitStatus.is_disabled(template_data.character_state_component)

		if is_disabled then
			template_data.is_active = false

			return
		end

		local player_unit = template_context.unit
		local player_position = POSITION_LOOKUP[player_unit]
		local broadphase = template_data.broadphase
		local enemy_side_names = template_data.enemy_side_names
		local num_hits = broadphase.query(broadphase, player_position, range_melee, BROADPHASE_RESULTS, enemy_side_names)
		local was_active = template_data.is_active
		local is_active = false

		for i = 1, num_hits do
			local enemy_unit = BROADPHASE_RESULTS[i]

			if HEALTH_ALIVE[enemy_unit] then
				local buff_extension = ScriptUnit.extension(enemy_unit, "buff_system")

				is_active = buff_extension:has_keyword(buff_keywords.electrocuted)

				if is_active then
					break
				end
			end
		end

		if was_active ~= is_active then
			template_data.is_active = is_active
		end
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.is_active
	end,
}

local percent_chance_grenade_duplication_on_explosion = HordesBuffsData.hordes_buff_grenade_duplication_on_explosion.buff_stats.chance.value

templates.hordes_buff_grenade_duplication_on_explosion = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		_give_passive_grenade_replenishment_buff(template_context.unit)
	end,
	proc_events = {
		[proc_events.on_player_grenade_exploded] = percent_chance_grenade_duplication_on_explosion,
	},
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local owner_unit = params.owner_unit
		local owner_side = "heroes"
		local item_name = params.item_name
		local projectile_template = params.projectile_template
		local position = params.position:unbox()

		SharedBuffFunctions.spawn_grenade_at_position(owner_unit, owner_side, item_name, projectile_template, position, Vector3.up(), 1)

		local player_fx_extension = ScriptUnit.has_extension(owner_unit, "fx_system")

		if player_fx_extension then
			player_fx_extension:trigger_wwise_events_local_only(SFX_NAMES.duplication, nil, owner_unit)
		end
	end,
}

function _pull_enemies_towards_position(player_unit, target_position, stagger_type, broadphase, target_side_names, range)
	local num_hits = broadphase.query(broadphase, target_position, range, BROADPHASE_RESULTS, target_side_names)

	for i = 1, num_hits do
		local enemy_unit = BROADPHASE_RESULTS[i]

		if HEALTH_ALIVE[enemy_unit] then
			local enemy_position = POSITION_LOOKUP[enemy_unit]
			local pull_direction = Vector3.normalize(Vector3.flat(target_position - enemy_position))

			if Vector3.length_squared(pull_direction) > 0 then
				Stagger.force_stagger(enemy_unit, stagger_type, pull_direction, 5, 1, 5, player_unit)
			end
		end
	end
end

function _pull_enemies_towards_target_unit(player_unit, target_unit, stagger_type, broadphase, target_side_names, range)
	local target_position = POSITION_LOOKUP[target_unit]
	local num_hits = broadphase.query(broadphase, target_position, range, BROADPHASE_RESULTS, target_side_names)

	for i = 1, num_hits do
		local enemy_unit = BROADPHASE_RESULTS[i]

		if enemy_unit ~= target_unit and HEALTH_ALIVE[enemy_unit] then
			local enemy_position = POSITION_LOOKUP[enemy_unit]
			local pull_direction = Vector3.normalize(Vector3.flat(target_position - enemy_position))

			if Vector3.length_squared(pull_direction) > 0 then
				Stagger.force_stagger(enemy_unit, stagger_type, pull_direction, 5, 1, 5, player_unit)
			end
		end
	end
end

local veteran_sticky_grenade_pull_radius = HordesBuffsData.hordes_buff_veteran_sticky_grenade_pulls_enemies.buff_stats.radius.value

templates.hordes_buff_veteran_sticky_grenade_pulls_enemies = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		template_data.broadphase, template_data.enemy_side_names = SharedBuffFunctions.get_broadphase_and_enemy_side_names(unit)
	end,
	proc_events = {
		[proc_events.on_projectile_stick] = 1,
	},
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit
		local target_unit = params.target_unit
		local target_position = POSITION_LOOKUP[target_unit]
		local broadphase = template_data.broadphase
		local enemy_side_names = template_data.enemy_side_names
		local target_stagger_type = stagger_types.heavy

		_pull_enemies_towards_target_unit(player_unit, target_unit, target_stagger_type, broadphase, enemy_side_names, veteran_sticky_grenade_pull_radius)

		local fx_system = Managers.state.extension:system("fx_system")

		fx_system:trigger_wwise_event(SFX_NAMES.gravity_pull, nil, target_unit)
	end,
}

local percent_max_health_regen_on_grenade_explosion = HordesBuffsData.hordes_buff_grenade_heals_on_explosion.buff_stats.health.value

templates.hordes_buff_grenade_heals_on_explosion = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase

		_give_passive_grenade_replenishment_buff(template_context.unit)
	end,
	proc_events = {
		[proc_events.on_player_grenade_exploded] = 1,
	},
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local owner_unit = params.owner_unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[owner_unit]
		local side_name = side:name()
		local position = params.position:unbox()
		local broadphase = template_data.broadphase
		local num_hits = broadphase.query(broadphase, position, range_close, BROADPHASE_RESULTS, side_name)

		for i = 1, num_hits do
			local ally_unit = BROADPHASE_RESULTS[i]
			local health_extension = ScriptUnit.extension(ally_unit, "health_system")

			if health_extension then
				local max_health = health_extension:max_health()
				local heal_amount = max_health * percent_max_health_regen_on_grenade_explosion

				health_extension:add_heal(heal_amount, DamageSettings.heal_types.buff)

				local player_fx_extension = ScriptUnit.has_extension(ally_unit, "fx_system")

				if player_fx_extension then
					player_fx_extension:trigger_wwise_events_local_only(SFX_NAMES.healing, nil, ally_unit)

					local vfx_position = position + Vector3(0, 0, 0)

					player_fx_extension:spawn_particles(VFX_NAMES.healing_explosion, vfx_position, nil, nil, nil, nil, true)
				end
			end
		end
	end,
}

local percent_chance_extra_grenade_throw = HordesBuffsData.hordes_buff_extra_grenade_throw_chance.buff_stats.chance.value

templates.hordes_buff_extra_grenade_throw_chance = {
	class_name = "buff",
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.extra_grenade_throw_chance] = percent_chance_extra_grenade_throw,
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		_give_passive_grenade_replenishment_buff(template_context.unit)
	end,
}

local percent_ammo_refil_while_holding_melee = HordesBuffsData.hordes_buff_auto_clip_fill_while_melee.buff_stats.ammo.value

templates.hordes_buff_auto_clip_fill_while_melee = {
	class_name = "proc_buff",
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_wield_ranged] = 1,
		[proc_events.on_wield_melee] = 1,
	},
	specific_proc_func = {
		[proc_events.on_wield_ranged] = function (params, template_data, template_context)
			template_data.is_wielding_melee = false
		end,
		[proc_events.on_wield_melee] = function (params, template_data, template_context)
			template_data.is_wielding_melee = true

			local t = FixedFrame.get_latest_fixed_time()

			template_data.next_check_time = t + 5
		end,
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.inventory_slot_secondary_component = unit_data_extension:write_component("slot_secondary")

		local start_time = 0

		template_context.item_slot_name = "slot_primary"

		local is_wielding_melee = ConditionalFunctions.is_item_slot_wielded(template_data, template_context)

		if is_wielding_melee then
			local t = FixedFrame.get_latest_fixed_time()

			start_time = t + 5
		end

		template_data.next_check_time = start_time
		template_data.is_wielding_melee = is_wielding_melee
	end,
	update_func = function (template_data, template_context, dt, t, template)
		if not template_context.is_server or not template_data.is_wielding_melee then
			return
		end

		local next_check_time = template_data.next_check_time

		if next_check_time < t then
			template_data.next_check_time = t + 5

			local player_unit = template_context.unit
			local missing_ammo_in_clip = Ammo.missing_slot_clip_amount(player_unit, "slot_secondary")
			local current_reserve_percentage = Ammo.current_slot_percentage(player_unit, "slot_secondary")

			if missing_ammo_in_clip <= 0 or current_reserve_percentage <= 0 then
				return
			end

			local ammo_replenished_amount = math.ceil(template_data.inventory_slot_secondary_component.max_ammunition_clip * percent_ammo_refil_while_holding_melee)

			Ammo.transfer_from_reserve_to_clip(template_data.inventory_slot_secondary_component, ammo_replenished_amount)

			local player_fx_extension = ScriptUnit.has_extension(player_unit, "fx_system")

			if player_fx_extension then
				player_fx_extension:trigger_wwise_events_local_only(SFX_NAMES.ammo_refil, nil, player_unit)
			end
		end
	end,
}
templates.hordes_buff_uninterruptible_more_damage_taken = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	keywords = {
		buff_keywords.uninterruptible,
	},
	stat_buffs = {
		[stat_buffs.damage_taken_modifier] = 0,
	},
}
templates.hordes_buff_ogryn_basic_box_spawns_cluster = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_sub_buff,
	keywords = {
		buff_keywords.ogryn_basic_box_spawns_cluster,
	},
}

local ogryn_big_boom_stat_increase = HordesBuffsData.hordes_buff_ogryn_biggest_boom_grenade.buff_stats.dammage.value

templates.hordes_buff_ogryn_biggest_boom_grenade = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	stat_buffs = {
		[stat_buffs.frag_damage] = ogryn_big_boom_stat_increase,
		[stat_buffs.explosion_impact_modifier] = 1,
		[stat_buffs.explosion_radius_modifier] = 1,
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		_give_passive_grenade_replenishment_buff(template_context.unit)
	end,
}

local ogryn_fire_trail_burning_stacks = HordesBuffsData.hordes_buff_ogryn_fire_trail_on_lunge.buff_stats.stacks.value

templates.hordes_buff_ogryn_fire_trail_on_lunge = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	keywords = {
		buff_keywords.fire_trail_on_lunge,
	},
	proc_events = {
		[proc_events.on_lunge_start] = 1,
		[proc_events.on_lunge_end] = 1,
	},
	specific_proc_func = {
		[proc_events.on_lunge_start] = function (params, template_data, template_context)
			template_data.is_lunging = true
			template_data.next_pulse_t = -1

			if template_context.is_server then
				local fx_system = Managers.state.extension:system("fx_system")

				fx_system:trigger_wwise_event(SFX_NAMES.fire_burst, nil, template_context.unit)
			end
		end,
		[proc_events.on_lunge_end] = function (params, template_data, template_context, t)
			template_data.is_lunging = false
		end,
	},
	start_func = function (template_data, template_context)
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase

		local player_unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[player_unit]
		local enemy_side_names = side:relation_side_names("enemy")

		template_data.enemy_side_names = enemy_side_names
		template_data.fire_pulse_interval = 0.5
		template_data.next_pulse_t = -1
		template_data.is_lunging = false
	end,
	update_func = function (template_data, template_context, dt, t)
		if template_context.is_server and template_data.is_lunging and t >= template_data.next_pulse_t then
			_compute_fire_pulse(template_context.is_server, template_context.unit, template_data.broadphase, template_data.enemy_side_names, t, ogryn_fire_trail_burning_stacks, true)

			template_data.next_pulse_t = t + template_data.fire_pulse_interval
		end
	end,
}
templates.hordes_buff_zealot_fire_trail_on_lunge = table.clone(templates.hordes_buff_ogryn_fire_trail_on_lunge)
templates.hordes_buff_ogryn_box_of_surprises = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	keywords = {
		buff_keywords.ogryn_box_of_surprise,
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		_give_passive_grenade_replenishment_buff(template_context.unit)
	end,
}

local ogryn_percent_chance_rock_instakill = HordesBuffsData.hordes_buff_ogryn_omega_lucky_rock.buff_stats.chance.value

templates.hordes_buff_ogryn_omega_lucky_rock = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_hit] = ogryn_percent_chance_rock_instakill,
	},
	check_proc_func = function (params, template_data, template_context, t)
		return params.damage_type and params.damage_type == "ogryn_friend_rock"
	end,
	proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server or params.attacked_unit == nil or params.attack_direction == nil then
			return
		end

		local player_unit = template_context.unit
		local target_unit = params.attacked_unit

		if HEALTH_ALIVE[target_unit] then
			local damage_profile = DamageProfileTemplates.kill_volume_with_gibbing
			local attack_direction = params.attack_direction:unbox()

			Attack.execute(target_unit, damage_profile, "instakill", true, "attack_direction", attack_direction, "attacking_unit", player_unit)
		end

		local player_fx_extension = ScriptUnit.has_extension(player_unit, "fx_system")

		if player_fx_extension then
			player_fx_extension:trigger_wwise_events_local_only(SFX_NAMES.super_crit, nil, player_unit)
		end
	end,
}

local ogryn_rock_charge_max_damage_increase = 4
local ogryn_rock_charge_damage_per_stack = HordesBuffsData.hordes_buff_ogryn_rock_charge_while_wield.buff_stats.damage.value
local ogryn_rock_charge_max_stacks = ogryn_rock_charge_max_damage_increase / ogryn_rock_charge_damage_per_stack

templates.hordes_buff_ogryn_rock_charge_while_wield = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	start_func = function (template_data, template_context)
		template_data.damage_increase_interval = 1
		template_data.next_damage_increase_t = nil
		template_data.max_stacks = ogryn_rock_charge_max_stacks
		template_data.damage_increase_stacks = 0

		local player_unit_data = ScriptUnit.extension(template_context.unit, "unit_data_system")
		local character_state_component = player_unit_data:read_component("character_state")
		local inventory_component = player_unit_data:read_component("inventory")

		template_data.character_state_component = character_state_component
		template_data.inventory_component = inventory_component
		template_data.player_fx_extension = ScriptUnit.has_extension(template_context.unit, "fx_system")
		template_data.build_up_enabled = false
	end,
	update_func = function (template_data, template_context, dt, t)
		local wwise_world = template_context.wwise_world
		local character_state_component = template_data.character_state_component
		local inventory_component = template_data.inventory_component
		local wielded_slot = inventory_component.wielded_slot
		local is_wielding_rock = wielded_slot == "slot_grenade_ability"
		local requires_help = PlayerUnitStatus.requires_help(character_state_component)
		local is_at_max_stacks = template_data.damage_increase_stacks >= template_data.max_stacks

		if template_data.build_up_enabled and (requires_help or not is_wielding_rock) then
			if template_data.wwise_source_id then
				WwiseWorld.trigger_resource_event(wwise_world, SFX_NAMES.friendly_rock_charge_stop, template_data.wwise_source_id)

				template_data.wwise_source_id = nil
			end

			template_data.build_up_enabled = false

			return
		end

		if is_wielding_rock and not template_data.build_up_enabled and not is_at_max_stacks then
			template_data.wwise_playing_id, template_data.wwise_source_id = WwiseWorld.trigger_resource_event(wwise_world, SFX_NAMES.friendly_rock_charge_start, template_context.unit)
			template_data.next_damage_increase_t = t + template_data.damage_increase_interval
			template_data.damage_increase_stacks = 0
			template_data.build_up_enabled = true
		end

		if template_data.build_up_enabled and t >= template_data.next_damage_increase_t then
			template_data.damage_increase_stacks = template_data.damage_increase_stacks + 1
			template_data.next_damage_increase_t = t + template_data.damage_increase_interval

			if template_data.damage_increase_stacks >= template_data.max_stacks then
				if template_data.wwise_source_id then
					WwiseWorld.trigger_resource_event(wwise_world, SFX_NAMES.friendly_rock_charge_finish, template_data.wwise_source_id)
					WwiseWorld.trigger_resource_event(wwise_world, SFX_NAMES.friendly_rock_charge_stop, template_data.wwise_source_id)

					template_data.wwise_playing_id = nil
					template_data.wwise_source_id = nil
				end

				template_data.build_up_enabled = false
			end
		end
	end,
	stop_func = function (template_data, template_context)
		local wwise_playing_id = template_data.wwise_playing_id

		if wwise_playing_id then
			WwiseWorld.stop_event(template_context.wwise_world, wwise_playing_id)

			template_data.wwise_playing_id = nil
			template_data.wwise_source_id = nil
		end
	end,
	lerped_stat_buffs = {
		[stat_buffs.ogryn_friendly_rock_damage_modifier] = {
			min = 0,
			max = ogryn_rock_charge_max_damage_increase,
		},
	},
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		return template_data.damage_increase_stacks / ogryn_rock_charge_max_stacks
	end,
}

local ogryn_percent_damage_taken_reduction_from_taunted_enemies = HordesBuffsData.hordes_buff_ogryn_taunt_on_lunge.buff_stats.damage.value

templates.hordes_buff_ogryn_taunt_on_lunge = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	conditional_stat_buffs = {
		[stat_buffs.damage_taken_vs_taunted] = -ogryn_percent_damage_taken_reduction_from_taunted_enemies,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.is_damage_reduction_active
	end,
	update_func = function (template_data, template_context, dt)
		if template_data.damage_reduction_time > 0 then
			template_data.damage_reduction_time = template_data.damage_reduction_time - dt
			template_data.is_damage_reduction_active = template_data.damage_reduction_time > 0
		end
	end,
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_lunge_end] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.is_damage_reduction_active = false
		template_data.damage_reduction_time = -1
	end,
	specific_check_proc_funcs = {
		[proc_events.on_hit] = function (params, template_data)
			if not params.damage_type or params.damage_type ~= damage_types.ogryn_lunge then
				return false
			end

			return true
		end,
		[proc_events.on_lunge_end] = function (params, template_data)
			return true
		end,
	},
	specific_proc_func = {
		[proc_events.on_lunge_end] = function (params, template_data, template_context, t)
			template_data.damage_reduction_time = 10
			template_data.is_damage_reduction_active = true
		end,
		[proc_events.on_hit] = function (params, template_data, template_context, t)
			local player_unit = template_context.unit
			local hit_unit = params.attacked_unit

			if HEALTH_ALIVE[hit_unit] then
				local buff_extension = ScriptUnit.has_extension(hit_unit, "buff_system")

				if buff_extension then
					buff_extension:add_internally_controlled_buff("taunted", t, "owner_unit", player_unit)
				end
			end
		end,
	},
}

local ogryn_num_burning_stacks_on_shout = HordesBuffsData.hordes_buff_ogryn_apply_fire_on_shout.buff_stats.stacks.value

templates.hordes_buff_ogryn_apply_fire_on_shout = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.hit_units = {}
	end,
	check_proc_func = CheckProcFunctions.on_shout_hit,
	proc_func = function (params, template_data, template_context, t)
		local player_unit = template_context.unit
		local hit_unit = params.attacked_unit
		local hit_units = template_data.hit_units

		if HEALTH_ALIVE[hit_unit] and not hit_units[hit_unit] then
			local buff_extension = ScriptUnit.has_extension(hit_unit, "buff_system")

			if buff_extension then
				buff_extension:add_internally_controlled_buff_with_stacks("flamer_assault", ogryn_num_burning_stacks_on_shout, t, "owner_unit", player_unit)

				local fx_system = Managers.state.extension:system("fx_system")
				local enemy_position = POSITION_LOOKUP[hit_unit]

				fx_system:trigger_wwise_event(SFX_NAMES.burning_proc, enemy_position)
			end
		end
	end,
}

local ogryn_percent_decrease_range_hit_mass_consumption_on_crits = HordesBuffsData.hordes_buff_ogryn_increase_penetration_during_stance.buff_stats.penetration.value

templates.hordes_buff_ogryn_increase_penetration_during_stance = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	conditional_stat_buffs = {
		[stat_buffs.consumed_hit_mass_modifier_on_ranged_critical_hit] = 1 / (1 + ogryn_percent_decrease_range_hit_mass_consumption_on_crits),
	},
	start_func = function (template_data, template_context)
		template_data.is_active = false
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.is_active
	end,
	update_func = function (template_data, template_context)
		template_data.is_active = template_context.buff_extension and template_context.buff_extension:has_keyword(buff_keywords.ogryn_combat_ability_stance)
	end,
}
templates.hordes_buff_veteran_infinite_ammo_during_stance = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	conditional_keywords = {
		buff_keywords.no_ammo_consumption,
	},
	start_func = function (template_data, template_context)
		template_data.is_active = false
	end,
	conditional_keywords_func = function (template_data, template_context)
		return template_data.is_active
	end,
	update_func = function (template_data, template_context)
		template_data.is_active = template_context.buff_extension and template_context.buff_extension:has_keyword(buff_keywords.veteran_combat_ability_stance)
	end,
}
templates.hordes_buff_veteran_apply_infinite_bleed_on_shout = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.hit_units = {}
	end,
	check_proc_func = CheckProcFunctions.on_shout_hit,
	proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit
		local hit_unit = params.attacked_unit
		local hit_units = template_data.hit_units

		if HEALTH_ALIVE[hit_unit] and not hit_units[hit_unit] then
			local buff_extension = ScriptUnit.has_extension(hit_unit, "buff_system")

			if buff_extension then
				buff_extension:add_internally_controlled_buff_with_stacks("hordes_ailment_infinite_minion_bleed", 10, t, "owner_unit", player_unit)
			end
		end
	end,
}

local veteran_duration_damage_increase_after_stealth = HordesBuffsData.hordes_buff_veteran_increased_damage_after_stealth.buff_stats.time.value
local veteran_percent_damage_increase_after_stealth = HordesBuffsData.hordes_buff_veteran_increased_damage_after_stealth.buff_stats.dammage.value

templates.hordes_buff_veteran_increased_damage_after_stealth = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	proc_events = {
		[proc_events.on_combat_ability] = 1,
	},
	proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return
		end

		local buff_extension = template_context.buff_extension

		buff_extension:add_internally_controlled_buff("hordes_buff_veteran_increased_damage_after_stealth_effect", t)
	end,
}
templates.hordes_buff_veteran_increased_damage_after_stealth_effect = {
	class_name = "veteran_stealth_bonuses_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_sub_buff,
	duration = veteran_duration_damage_increase_after_stealth,
	stat_buffs = {
		[stat_buffs.damage] = veteran_percent_damage_increase_after_stealth,
	},
}
templates.hordes_buff_veteran_grouped_upgraded_stealth = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_buff,
	keywords = {
		buff_keywords.can_attack_during_invisibility,
	},
	proc_events = {
		[proc_events.on_combat_ability] = 1,
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local side_system = Managers.state.extension:system("side_system")

		template_data.side = side_system.side_by_unit[template_context.unit]
	end,
	proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return
		end

		local buff_extension = template_context.buff_extension

		buff_extension:add_internally_controlled_buff("hordes_buff_veteran_upgraded_stealth_effect", t)

		local range_squared = 64
		local ally_player_units = template_data.side.valid_player_units
		local source_player_position = POSITION_LOOKUP[template_context.unit]

		for _, ally_player_unit in pairs(ally_player_units) do
			if HEALTH_ALIVE[ally_player_unit] and ally_player_unit ~= template_context.unit then
				local unit_data_extension = ScriptUnit.extension(ally_player_unit, "unit_data_system")
				local character_state_component = unit_data_extension:read_component("character_state")
				local requires_help = PlayerUnitStatus.requires_help(character_state_component)

				if not requires_help then
					local distance_to_player_squared = Vector3.distance_squared(source_player_position, POSITION_LOOKUP[ally_player_unit])
					local player_buff_extension = ScriptUnit.has_extension(ally_player_unit, "buff_system")

					if player_buff_extension and distance_to_player_squared <= range_squared then
						player_buff_extension:add_internally_controlled_buff("hordes_buff_veteran_stealth_group_allies_effect", t)
					end
				end
			end
		end
	end,
}
templates.hordes_buff_veteran_upgraded_stealth_effect = {
	class_name = "veteran_stealth_bonuses_buff",
	duration = 0.2,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	buff_category = buff_categories.hordes_sub_buff,
	keywords = {
		buff_keywords.invulnerable,
		buff_keywords.can_attack_during_invisibility,
	},
}
templates.hordes_buff_veteran_stealth_group_allies_effect = {
	class_name = "buff",
	duration = 8,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	buff_category = buff_categories.hordes_sub_buff,
	keywords = {
		buff_keywords.invisible,
		buff_keywords.invulnerable,
		buff_keywords.can_attack_during_invisibility,
	},
}
templates.hordes_ailment_minion_burning = {
	class_name = "interval_buff",
	duration = 4,
	interval = 0.5,
	interval_stack_removal = true,
	max_stacks = 31,
	max_stacks_cap = 31,
	predicted = false,
	refresh_duration_on_stack = true,
	buff_category = buff_categories.hordes_sub_buff,
	keywords = {
		buff_keywords.burning,
	},
	interval_func = function (template_data, template_context, template)
		local unit = template_context.unit

		if HEALTH_ALIVE[unit] then
			local damage_template = DamageProfileTemplates.burning
			local stack_multiplier = template_context.stack_count / template.max_stacks
			local smoothstep_multiplier = stack_multiplier * stack_multiplier * (3 - 2 * stack_multiplier)
			local power_level = smoothstep_multiplier * 500
			local optional_owner_unit = template_context.is_server and template_context.owner_unit or nil

			Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", "burning", "attacking_unit", optional_owner_unit)
		end
	end,
	minion_effects = minion_burning_buff_effects.chemfire,
}
templates.hordes_ailment_minion_bleed = {
	class_name = "interval_buff",
	duration = 1.5,
	interval = 0.5,
	interval_stack_removal = true,
	max_stacks = 16,
	max_stacks_cap = 16,
	predicted = false,
	refresh_duration_on_stack = true,
	buff_category = buff_categories.hordes_sub_buff,
	keywords = {
		buff_keywords.bleeding,
	},
	interval_func = function (template_data, template_context, template)
		local unit = template_context.unit

		if HEALTH_ALIVE[unit] then
			local damage_template = DamageProfileTemplates.bleeding
			local stack_multiplier = template_context.stack_count / template.max_stacks
			local smoothstep_multiplier = stack_multiplier * stack_multiplier * (3 - 2 * stack_multiplier)
			local power_level = smoothstep_multiplier * 500
			local source_item = template_context.is_server and template_context.source_item
			local owner_unit = template_context.is_server and template_context.owner_unit or template_context.unit

			Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_types.bleeding, "attacking_unit", owner_unit, "item", source_item)
		end
	end,
	minion_effects = {
		node_effects = {
			{
				node_name = "j_spine",
				vfx = {
					material_emission = true,
					orphaned_policy = "destroy",
					particle_effect = "content/fx/particles/enemies/buff_bleeding",
					stop_type = "stop",
				},
			},
		},
	},
}
templates.hordes_ailment_infinite_minion_bleed = table.clone(templates.hordes_ailment_minion_bleed)
templates.hordes_ailment_infinite_minion_bleed.duration = nil
templates.hordes_ailment_infinite_minion_bleed.interval_stack_removal = false
templates.hordes_ailment_infinite_minion_bleed.refresh_duration_on_stack = false
templates.hordes_ailment_shock = {
	class_name = "interval_buff",
	duration = 2,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	start_interval_on_apply = true,
	start_with_frame_offset = true,
	buff_category = buff_categories.hordes_sub_buff,
	keywords = {
		buff_keywords.electrocuted,
	},
	interval = {
		0.3,
		0.8,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data = ScriptUnit.has_extension(unit, "unit_data_system")
		local breed = unit_data and unit_data:breed()
		local is_poxwalker_bomber = breed and breed.tags and breed.name == "chaos_poxwalker_bomber"

		template_data.is_poxwalker_bomber = is_poxwalker_bomber
	end,
	interval_func = function (template_data, template_context, template, dt, t)
		local is_server = template_context.is_server

		if not is_server then
			return
		end

		local unit = template_context.unit
		local is_staggered_poxwalker_bomber = template_data.is_poxwalker_bomber and MinionState.is_staggered(unit)

		if HEALTH_ALIVE[unit] and not is_staggered_poxwalker_bomber then
			local damage_template = DamageProfileTemplates.shock_grenade_stun_interval
			local owner_unit = template_context.owner_unit
			local power_level = DEFAULT_POWER_LEVEL
			local random_radians = math.random_range(0, PI_2)
			local attack_direction = Vector3(math.sin(random_radians), math.cos(random_radians), 0)

			attack_direction = Vector3.normalize(attack_direction)

			Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_types.electrocution, "attacking_unit", HEALTH_ALIVE[owner_unit] and owner_unit, "attack_direction", attack_direction, "attack_type", attack_types.buff)
		end
	end,
	minion_effects = {
		node_effects = {
			{
				node_name = "j_spine",
				vfx = {
					material_emission = false,
					orphaned_policy = "destroy",
					particle_effect = "content/fx/particles/enemies/buff_stummed",
					stop_type = "stop",
				},
			},
		},
	},
}

return templates
