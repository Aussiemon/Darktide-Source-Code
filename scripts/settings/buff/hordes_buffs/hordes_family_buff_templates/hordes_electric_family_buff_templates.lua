-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_family_buff_templates/hordes_electric_family_buff_templates.lua

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
local SFX_NAMES = HordesBuffsUtilities.SFX_NAMES
local VFX_NAMES = HordesBuffsUtilities.VFX_NAMES
local BROADPHASE_RESULTS = {}
local range_melee = DamageSettings.in_melee_range
local range_close = DamageSettings.ranged_close
local range_far = DamageSettings.ranged_far
local templates = {}

table.make_unique(templates)

local shock_on_ranged_hit_chance = HordesBuffsData.hordes_buff_shock_on_ranged_hit.buff_stats.shock_chance.value

templates.hordes_buff_shock_on_ranged_hit = {
	class_name = "server_only_proc_buff",
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

local shock_on_melee_hit_chance = HordesBuffsData.hordes_buff_shock_on_melee_hit.buff_stats.shock_chance.value

templates.hordes_buff_shock_on_melee_hit = {
	class_name = "server_only_proc_buff",
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

local melee_instakill_on_electrocuted_enemy_chance = HordesBuffsData.hordes_buff_instakill_melee_hit_on_electrocuted_enemy.buff_stats.kill_chance.value

templates.hordes_buff_instakill_melee_hit_on_electrocuted_enemy = {
	class_name = "server_only_proc_buff",
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
templates.hordes_buff_shock_on_hit_after_dodge = {
	class_name = "server_only_proc_buff",
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
	class_name = "server_only_proc_buff",
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

local percent_damage_reduction_close_to_electrocuted_enemy = HordesBuffsData.hordes_buff_damage_taken_close_to_electrocuted_enemy.buff_stats.damage_reduce.value

templates.hordes_buff_damage_taken_close_to_electrocuted_enemy = {
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
		return template_data.is_active
	end,
	proc_func = function (params, template_data, template_context, t)
		template_data.player_fx_extension:trigger_wwise_events_local_only(SFX_NAMES.reduced_damage_hit, false, template_context.unit)
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

return templates
