-- chunkname: @scripts/settings/buff/hordes_buffs/hordes_legendary_buff_templates/hordes_legendary_ogryn_buff_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local HordesBuffsData = require("scripts/settings/buff/hordes_buffs/hordes_buffs_data")
local HordesBuffsUtilities = require("scripts/settings/buff/hordes_buffs/hordes_buffs_utilities")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local buff_categories = BuffSettings.buff_categories
local buff_keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local armor_types = ArmorSettings.types
local attack_types = AttackSettings.attack_types
local damage_types = DamageSettings.damage_types
local hit_zone_names = HitZone.hit_zone_names
local stagger_types = StaggerSettings.stagger_types
local SFX_NAMES = HordesBuffsUtilities.SFX_NAMES
local VFX_NAMES = HordesBuffsUtilities.VFX_NAMES
local BROADPHASE_RESULTS = {}
local templates = {}

table.make_unique(templates)

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

		HordesBuffsUtilities.give_passive_grenade_replenishment_buff(template_context.unit)
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
			HordesBuffsUtilities.compute_fire_pulse(template_context.is_server, template_context.unit, template_data.broadphase, template_data.enemy_side_names, t, ogryn_fire_trail_burning_stacks, true)

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

		HordesBuffsUtilities.give_passive_grenade_replenishment_buff(template_context.unit)
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

return templates
