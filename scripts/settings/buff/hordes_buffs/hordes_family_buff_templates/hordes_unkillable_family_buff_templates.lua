-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_family_buff_templates/hordes_unkillable_family_buff_templates.lua

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

local percent_damage_reduction_per_near_disabled_ally = HordesBuffsData.hordes_buff_reduce_damage_taken_on_disabled_allies.buff_stats.damage.value
local max_percent_damage_reduction_near_disabled_allies = 1 - percent_damage_reduction_per_near_disabled_ally * 4
local range_detection_for_disabled_allies = HordesBuffsData.hordes_buff_reduce_damage_taken_on_disabled_allies.buff_stats.range.value

templates.hordes_buff_reduce_damage_taken_on_disabled_allies = {
	class_name = "server_only_proc_buff",
	cooldown_duration = 1,
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
		template_data.player_fx_extension:trigger_wwise_events_local_only(SFX_NAMES.reduced_damage_hit, false, template_context.unit)
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

return templates
