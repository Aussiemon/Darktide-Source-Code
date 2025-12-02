-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_traits_bespoke_powersword_2h_p1_buff_templates.lua

local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BaseWeaponTraitBuffTemplates = require("scripts/settings/buff/weapon_traits_buff_templates/base_weapon_trait_buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local FixedFrame = require("scripts/utilities/fixed_frame")
local Stamina = require("scripts/utilities/attack/stamina")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local Overheat = require("scripts/utilities/overheat")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local attack_types = AttackSettings.attack_types
local slot_configuration = PlayerCharacterConstants.slot_configuration
local keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local stat_buffs = BuffSettings.stat_buffs
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_powersword_2h_p1_power_bonus_scaled_on_heat = {
	class_name = "stepped_stat_buff",
	max_stacks = 1,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.power_level_modifier] = 0.01,
	},
	conditional_stepped_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
	min_max_step_func = function (template_data, template_context)
		return 0, 5
	end,
	bonus_step_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local inventory_component = unit_data_extension:read_component("inventory")
		local wielded_slot = inventory_component.wielded_slot

		if wielded_slot == "none" or not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
			return 0
		end

		local wielded_slot_configuration = slot_configuration[wielded_slot]
		local slot_type = wielded_slot_configuration and wielded_slot_configuration.slot_type

		if slot_type == "weapon" then
			local slot_inventory_component = unit_data_extension:read_component(wielded_slot)
			local overheat_current_percentage = slot_inventory_component.overheat_current_percentage

			overheat_current_percentage = math.clamp01((overheat_current_percentage - 0.1) / 0.9)

			local steps = math.round(overheat_current_percentage * 5)

			return steps
		end

		return 0
	end,
}
templates.weapon_trait_bespoke_powersword_2h_p1_reduce_fixed_overheat_amount = {
	class_name = "proc_buff",
	overheat_reduction = 0.01,
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.inventory_slot_component = unit_data_extension:write_component(template_context.item_slot_name)
	end,
	check_proc_func = function (params)
		return params.target_number == 1 and (params.hit_weakspot or params.is_critical_strike)
	end,
	proc_func = function (params, template_data, template_context)
		Overheat.decrease_immediate(override_data.overheat_reduction, template_data.inventory_slot_component)
	end,
}
templates.weapon_trait_bespoke_powersword_2h_p1_reduce_fixed_overheat_amount_parent = {
	allow_proc_while_active = true,
	child_buff_template = "weapon_trait_bespoke_powersword_2h_p1_reduce_fixed_overheat_amount_child",
	child_duration = 3,
	class_name = "weapon_trait_parent_proc_buff",
	hud_always_never_stacks = true,
	max_stacks = 1,
	predicted = false,
	stack_offset = -1,
	stacks_to_remove = 1,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	add_child_proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = function (params)
		return params.target_number == 1 and (params.hit_weakspot or params.is_critical_strike)
	end,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_bespoke_powersword_2h_p1_reduce_fixed_overheat_amount_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 1,
	predicted = false,
	stack_offset = -1,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local fixed_t = FixedFrame.get_latest_fixed_time()

		template_data.timer = fixed_t + 1

		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.inventory_slot_component = unit_data_extension:write_component(template_context.item_slot_name)
	end,
	update_func = function (template_data, template_context, dt, t)
		if not template_context.is_server then
			return
		end

		if t > template_data.timer then
			template_data.timer = template_data.timer + 1

			if template_context.stack_count > 1 then
				local override_data = template_context.template_override_data
				local state = template_data.inventory_slot_component.overheat_state
				local duration = override_data.duration
				local base_amount = override_data.overheat_reduction * (1 / duration)
				local amount = state == "lockout" and base_amount or base_amount * 0.25

				Overheat.decrease_immediate(amount, template_data.inventory_slot_component)
			end
		end
	end,
}
templates.weapon_trait_bespoke_powersword_2h_p1_chained_weakspot_hits_increase_finesse_and_reduce_overheat_parent = {
	child_buff_template = "weapon_trait_bespoke_powersword_2h_p1_chained_weakspot_hits_increase_finesse_and_reduce_overheat_child",
	child_duration = 3,
	class_name = "weapon_trait_activated_parent_proc_buff",
	max_stacks = 1,
	predicted = false,
	stack_offset = -1,
	stacks_to_remove = 5,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	add_child_proc_events = {
		[proc_events.on_hit] = 1,
	},
	active_proc_func = {
		on_hit = function (params)
			return params.hit_weakspot
		end,
	},
	check_proc_func = function (params)
		return params.target_number == 1 and params.hit_weakspot
	end,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_bespoke_powersword_2h_p1_chained_weakspot_hits_increase_finesse_and_reduce_overheat_child = {
	class_name = "buff",
	hide_icon_in_hud = true,
	max_stacks = 5,
	predicted = false,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.overheat_amount] = 0.97,
		[stat_buffs.finesse_modifier_bonus] = 0.01,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_bespoke_powersword_2h_p1_increased_melee_damage_on_multiple_hits = table.clone(BaseWeaponTraitBuffTemplates.increased_melee_damage_on_multiple_hits)
templates.weapon_trait_bespoke_powersword_2h_p1_chained_hits_increases_melee_cleave_parent = table.clone(BaseWeaponTraitBuffTemplates.chained_hits_increases_melee_cleave_parent)
templates.weapon_trait_bespoke_powersword_2h_p1_chained_hits_increases_melee_cleave_parent.child_buff_template = "weapon_trait_bespoke_powersword_2h_p1_chained_hits_increases_melee_cleave_child"
templates.weapon_trait_bespoke_powersword_2h_p1_chained_hits_increases_melee_cleave_child = table.clone(BaseWeaponTraitBuffTemplates.chained_hits_increases_melee_cleave_child)
templates.weapon_trait_bespoke_powersword_2h_p1_windup_increases_power_parent = table.clone(BaseWeaponTraitBuffTemplates.windup_increases_power_parent)
templates.weapon_trait_bespoke_powersword_2h_p1_windup_increases_power_parent.child_buff_template = "weapon_trait_bespoke_powersword_2h_p1_windup_increases_power_child"
templates.weapon_trait_bespoke_powersword_2h_p1_windup_increases_power_child = table.clone(BaseWeaponTraitBuffTemplates.windup_increases_power_child)
templates.weapon_trait_bespoke_powersword_2h_p1_infinite_melee_cleave_on_crit = table.clone(BaseWeaponTraitBuffTemplates.infinite_melee_cleave_on_crit)

local _external_properties = {}

templates.weapon_trait_bespoke_bespoke_powersword_2h_p1_block_activate_weapon_special = {
	class_name = "proc_buff",
	cooldown_duration = 15,
	predicted = false,
	proc_events = {
		[proc_events.on_block] = 0.25,
	},
	start_func = function (template_data, template_context)
		local player_unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
		local item_slot_name = template_context.item_slot_name

		template_data.inventory_slot_component = unit_data_extension:write_component(item_slot_name)

		local fx_extension = ScriptUnit.extension(player_unit, "fx_system")

		template_data.fx_extension = fx_extension
	end,
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	proc_func = function (params, template_data, template_context, t)
		local visual_loadout_extension = template_data.visual_loadout_extension

		if not visual_loadout_extension then
			visual_loadout_extension = ScriptUnit.extension(template_context.unit, "visual_loadout_system")
			template_data.visual_loadout_extension = visual_loadout_extension
		end

		local inventory_slot_component = template_data.inventory_slot_component

		inventory_slot_component.special_active = true
		inventory_slot_component.num_special_charges = 0
		inventory_slot_component.special_active_start_t = t

		local fx_extension = template_data.fx_extension
		local external_properties = _external_properties
		local include_client = true
		local effect_alias = "vfx_weapon_special_start"
		local sound_alias = "sfx_special_activate"
		local source_alias = "_special_active"
		local item_slot_name = template_context.item_slot_name
		local fx_sources = template_data.visual_loadout_extension:source_fx_for_slot(item_slot_name)
		local source_name = fx_sources and fx_sources[source_alias]

		if sound_alias and sound_alias ~= "" then
			local sync_to_clients = true

			fx_extension:trigger_gear_wwise_event_with_source(sound_alias, external_properties, source_name, sync_to_clients, include_client)
		end

		if effect_alias and effect_alias ~= "" then
			local link = true
			local orphaned_policy = "stop"

			fx_extension:spawn_gear_particle_effect_with_source(effect_alias, external_properties, source_name, link, orphaned_policy, nil, nil, nil, true)
		end
	end,
}
templates.weapon_trait_bespoke_bespoke_powersword_2h_p1_regain_toughness_on_multiple_hits_by_weapon_special = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	predicted = false,
	toughness_fixed_percentage = 0.15,
	proc_events = {
		[proc_events.on_sweep_start] = 1,
		[proc_events.on_hit] = 1,
		[proc_events.on_sweep_finish] = 1,
	},
	buff_data = {
		required_num_hits = 3,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	specific_check_proc_funcs = {
		on_sweep_start = function (params, template_data, template_context)
			template_data.can_activate = params.is_weapon_special_active
		end,
		on_hit = function (params, template_data, template_context)
			if not CheckProcFunctions.on_item_match(params, template_data, template_context) then
				return false
			end

			if not template_data.can_activate then
				return false
			end

			local is_multi = CheckProcFunctions.on_multiple_melee_hit(params, template_data, template_context)

			if is_multi then
				template_data.can_activate = false

				return true
			end

			return false
		end,
		on_sweep_finish = function (params, template_data, template_context)
			template_data.can_activate = false
		end,
	},
	specific_proc_func = {
		on_hit = function (params, template_data, template_context)
			local toughness_extension = template_data.toughness_extension

			if not toughness_extension then
				local unit = template_context.unit

				toughness_extension = ScriptUnit.extension(unit, "toughness_system")
				template_data.toughness_extension = toughness_extension
			end

			local buff_template = template_context.template
			local override_data = template_context.template_override_data
			local fixed_percentage = override_data.toughness_fixed_percentage or buff_template.toughness_fixed_percentage
			local ignore_stat_buffs = true

			toughness_extension:recover_percentage_toughness(fixed_percentage, ignore_stat_buffs)
		end,
	},
}
templates.weapon_trait_bespoke_bespoke_powersword_2h_p1_regain_stamina_on_weapon_special_hit = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	predicted = false,
	stamina_fixed_percentage = 0.15,
	proc_events = {
		[proc_events.on_sweep_start] = 1,
		[proc_events.on_hit] = 1,
		[proc_events.on_sweep_finish] = 1,
	},
	buff_data = {
		required_num_hits = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.melee_power_level_modifier] = 0.5,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	specific_check_proc_funcs = {
		on_sweep_start = function (params, template_data, template_context)
			template_data.can_activate = params.is_weapon_special_active
		end,
		on_hit = function (params, template_data, template_context)
			if not CheckProcFunctions.on_item_match(params, template_data, template_context) then
				return false
			end

			if not template_data.can_activate then
				return false
			end

			local is_multi = CheckProcFunctions.on_multiple_melee_hit(params, template_data, template_context)

			if is_multi then
				template_data.can_activate = false

				return true
			end

			return false
		end,
		on_sweep_finish = function (params, template_data, template_context)
			template_data.can_activate = false
		end,
	},
	specific_proc_func = {
		on_hit = function (params, template_data, template_context)
			local unit = template_context.unit
			local buff_template = template_context.template
			local override_data = template_context.template_override_data
			local fixed_percentage = override_data.stamina_fixed_percentage or buff_template.stamina_fixed_percentage

			Stamina.add_stamina_percent(unit, fixed_percentage)
		end,
	},
}
templates.weapon_trait_bespoke_powersword_2h_p1_slower_heat_buildup_on_perfect_block = {
	active_duration = 3,
	class_name = "proc_buff",
	cooldown_duration = 5,
	predicted = false,
	proc_events = {
		[proc_events.on_perfect_block] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.overheat_over_time_amount] = 0.8,
		[stat_buffs.overheat_dissipation_multiplier] = 1.5,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_bespoke_powersword_2h_p1_attack_speed_on_perfect_block = {
	active_duration = 3,
	class_name = "proc_buff",
	cooldown_duration = 5,
	predicted = false,
	proc_events = {
		[proc_events.on_perfect_block] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.melee_attack_speed] = 1.5,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
}
templates.weapon_trait_bespoke_powersword_2h_p1_explosion_on_overheat_lockout = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_overheat_lockout] = 1,
	},
	proc_data = {
		explosion_template = ExplosionTemplates.trait_buff_powersword_2h_lockout_proc_explosion_4,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	proc_func = function (params, template_data, template_context)
		local template_override_data = template_context.template_override_data
		local template = template_context.template
		local proc_data = template_override_data and template_override_data.proc_data or template.proc_data
		local explosion_template = proc_data.explosion_template
		local unit = template_context.unit
		local position = Unit.local_position(unit, 1) + Vector3.up()

		Explosion.create_explosion(template_context.world, template_context.physics_world, position, Vector3.up(), template_context.unit, explosion_template, DEFAULT_POWER_LEVEL, 1, attack_types.explosion)

		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local inventory_slot_component = unit_data_extension:write_component(template_context.item_slot_name)
		local base_amount = template_override_data.overheat_reduction

		Overheat.decrease_immediate(base_amount, inventory_slot_component)
	end,
}
templates.weapon_trait_bespoke_powersword_2h_p1_trade_overheat_lockout_for_damage = {
	class_name = "proc_buff",
	interval = 0.25,
	predicted = false,
	proc_events = {
		[proc_events.on_overheat_soft_lockout] = 1,
	},
	keywords = {
		keywords.use_overheat_soft_lockout,
	},
	power_level = DEFAULT_POWER_LEVEL,
	damage_template = DamageProfileTemplates.trait_powersword_2h_p1_trade_overheat_lockout_for_damage,
	power_level_scale_per_tick = {
		1,
		1,
		1,
		1,
		1.25,
		1.25,
		1.25,
		1.5,
		1.5,
		1.5,
		1.75,
		1.75,
		2,
		3,
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		template_data.buff_extension = buff_extension

		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.inventory_slot_read_component = unit_data_extension:read_component(template_context.item_slot_name)
		template_data.active = false
		template_data.num_ticks = nil
		template_data.start_t = nil
		template_data.next_interval_t = nil
		template_data.special_active = false
	end,
	specific_proc_func = {
		[proc_events.on_overheat_soft_lockout] = function (params, template_data, template_context, t)
			template_data.active = true
			template_data.start_t = t

			local template = template_context.template
			local override_data = template_context.template_override_data
			local interval = override_data and override_data.interval or template.interval

			template_data.next_interval_t = t + interval
		end,
	},
	update_func = function (template_data, template_context, dt, t, template)
		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return
		end

		if not template_data.active then
			return
		end

		local was_special_active = template_data.special_active
		local inventory_slot_read_component = template_data.inventory_slot_read_component
		local is_special_active = inventory_slot_read_component.special_active

		template_data.special_active = is_special_active

		if was_special_active and not is_special_active then
			template_data.active = false
			template_data.num_ticks = nil
			template_data.start_t = nil
			template_data.next_interval_t = nil

			return
		end

		local next_interval_t = template_data.next_interval_t

		if next_interval_t < t then
			local override_data = template_context.template_override_data
			local power_level = template.power_level
			local num_ticks = template_data.num_ticks or 1
			local power_level_scale_per_tick_table = override_data and override_data.power_level_scale_per_tick or template.power_level_scale_per_tick
			local power_level_scale_per_tick = power_level_scale_per_tick_table[math.min(num_ticks, #power_level_scale_per_tick_table)]

			power_level = power_level * power_level_scale_per_tick

			local damage_template, damage_type = template.damage_template, template.damage_type

			Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_type)

			template_data.num_ticks = num_ticks + 1

			local interval = override_data and override_data.interval or template.interval

			template_data.next_interval_t = t + interval
		end
	end,
}
templates.weapon_trait_bespoke_powersword_2h_p1_trade_overheat_lockout_for_damage_active_effect = {
	class_name = "interval_buff",
	interval = 0.25,
	predicted = false,
	power_level = DEFAULT_POWER_LEVEL * 0.1,
	damage_template = DamageProfileTemplates.trait_powersword_2h_p1_trade_overheat_lockout_for_damage,
	power_level_scale_per_tick = {
		1,
		1,
		1,
		1,
		1.25,
		1.25,
		1.25,
		1.5,
		1.5,
		1.5,
		1.75,
		1.75,
		2,
		3,
	},
	interval_func = function (template_data, template_context, template)
		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return
		end

		local power_level = template.power_level
		local num_ticks = template_data.num_ticks or 1
		local power_level_scale_per_tick = template.power_level_scale_per_tick[math.min(num_ticks, #template.power_level_scale_per_tick)]

		power_level = power_level * power_level_scale_per_tick

		local damage_template, damage_type = template.damage_template, template.damage_type

		Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_type)

		template_data.num_ticks = num_ticks + 1
	end,
}

return templates
