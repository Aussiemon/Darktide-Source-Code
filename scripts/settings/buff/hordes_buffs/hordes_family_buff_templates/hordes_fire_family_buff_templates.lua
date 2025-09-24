-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_family_buff_templates/hordes_fire_family_buff_templates.lua

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
local HordesBuffsUtilities = require("scripts/settings/buff/hordes_buffs/hordes_buffs_utilities")
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
local SFX_NAMES = HordesBuffsUtilities.SFX_NAMES
local VFX_NAMES = HordesBuffsUtilities.VFX_NAMES
local BROADPHASE_RESULTS = {}
local range_melee = DamageSettings.in_melee_range
local range_close = DamageSettings.ranged_close
local range_far = DamageSettings.ranged_far
local templates = {}

table.make_unique(templates)

local burning_stacks_on_melee_hit = HordesBuffsData.hordes_buff_burning_on_melee_hit.buff_stats.stacks.value

templates.hordes_buff_burning_on_melee_hit = {
	class_name = "server_only_proc_buff",
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
	class_name = "server_only_proc_buff",
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
	class_name = "server_only_proc_buff",
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

		HordesBuffsUtilities.compute_fire_pulse(template_context.is_server, template_context.unit, template_data.broadphase, template_data.enemy_side_names, t, fire_pulse_burning_stacks)
	end,
}

local percentage_toughness_per_fire_damage_dealt = HordesBuffsData.hordes_buff_toughness_on_fire_damage_dealt.buff_stats.thoughness_regen.value

templates.hordes_buff_toughness_on_fire_damage_dealt = {
	class_name = "server_only_proc_buff",
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

return templates
