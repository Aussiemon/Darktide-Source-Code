﻿-- chunkname: @scripts/settings/buff/archetype_buff_templates/psyker_buff_templates.lua

local Action = require("scripts/utilities/weapon/action")
local AilmentSettings = require("scripts/settings/ailments/ailment_settings")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local BurningSettings = require("scripts/settings/burning/burning_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local HitZone = require("scripts/utilities/attack/hit_zone")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local MasterItems = require("scripts/backend/master_items")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local Toughness = require("scripts/utilities/toughness/toughness")
local WarpCharge = require("scripts/utilities/warp_charge")
local WeaponChargeTemplates = require("scripts/settings/equipment/weapon_handling_templates/weapon_charge_templates")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local ailment_effects = AilmentSettings.effects
local attack_results = AttackSettings.attack_results
local hit_zone_names = HitZone.hit_zone_names
local minion_burning_buff_effects = BurningSettings.buff_effects.minions
local attack_types = AttackSettings.attack_types
local damage_types = DamageSettings.damage_types
local buff_categories = BuffSettings.buff_categories
local keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local special_rules = SpecialRulesSetting.special_rules
local stat_buffs = BuffSettings.stat_buffs
local warp_damage_types = DamageSettings.warp_damage_types
local talent_settings = TalentSettings.psyker
local talent_settings_2 = TalentSettings.psyker_2
local talent_settings_3 = TalentSettings.psyker_3
local _psyker_passive_start, _psyker_passive_stop, _psyker_passive_conditional_stat_buffs, _psyker_passive_lerp_t, _psyker_passive_proc_on_kill, _psyker_passive_proc_on_combat_ability, _add_soul_function, _start_soul_function, _update_soul_function, _souls_stop_function, _souls_conditional_exit_function, _souls_proc_func, _psyker_marked_enemies_select_unit

local function _overcharge_stance_penance_start(template_data, template_context)
	local player = template_context.player

	Managers.stats:record_private("hook_overcharge_stance_start", player)
end

local function _overcharge_stance_penance_stop(template_data, template_context)
	local player = template_context.player

	Managers.stats:record_private("hook_overcharge_stance_stop", player)
end

local templates = {}

table.make_unique(templates)

local function _penance_start_func(buff_name)
	return function (template_data, template_context)
		local unit = template_context.unit
		local t = FixedFrame.get_latest_fixed_time()
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		buff_extension:add_internally_controlled_buff(buff_name, t)
	end
end

local base_max_souls = talent_settings_2.passive_1.base_max_souls
local max_souls_talent = talent_settings_2.offensive_2_1.max_souls_talent
local soul_duration = talent_settings_2.passive_1.soul_duration

function _psyker_passive_start(template_data, template_context)
	local unit = template_context.unit
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local buff_extension = ScriptUnit.extension(unit, "buff_system")
	local talent_extension = ScriptUnit.extension(unit, "talent_system")
	local fx_extension = ScriptUnit.extension(unit, "fx_system")
	local first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	local coherency_extension = ScriptUnit.extension(unit, "coherency_system")

	template_data.action_module_targeting_component = unit_data_extension:read_component("action_module_targeting")
	template_data.talent_resource_component = unit_data_extension:write_component("talent_resource")
	template_data.warp_charge_component = unit_data_extension:read_component("warp_charge")
	template_data.buff_extension = buff_extension
	template_data.fx_extension = fx_extension
	template_data.coherency_extension = coherency_extension
	template_data.num_souls = 0

	local first_person_unit = first_person_extension:first_person_unit()

	template_data.first_person_unit = first_person_unit
	template_data.psyker_all_kills_can_generate_souls = talent_extension:has_special_rule(special_rules.psyker_all_kills_can_generate_souls)
	template_data.psyker_increased_max_souls = talent_extension:has_special_rule(special_rules.psyker_increased_max_souls)
	template_data.psyker_increased_soul_generation = talent_extension:has_special_rule(special_rules.psyker_increased_soul_generation)
	template_data.psyker_restore_cooldown_per_soul = talent_extension:has_special_rule(special_rules.psyker_restore_cooldown_per_soul)
	template_data.psyker_toughness_regen_soul = talent_extension:has_special_rule(special_rules.psyker_toughness_regen_soul)
	template_data.buff_name = template_data.psyker_increased_max_souls and "psyker_souls_increased_max_stacks" or "psyker_souls"

	local is_playing = fx_extension:is_looping_particles_playing("psyker_biomancer_soul")

	if not is_playing then
		local data = {
			particle_name = "content/fx/particles/abilities/biomancer_soul",
		}
		local spawner_name = "hips"

		fx_extension:spawn_looping_particles("psyker_biomancer_soul", spawner_name, data)
	end

	local toughness_talent_soul_requirement = talent_settings_2.defensive_2.soul_threshold

	template_data.toughness_talent_soul_requirement = toughness_talent_soul_requirement
	template_data.max_souls_talent = max_souls_talent
	template_data.max_souls = template_data.psyker_increased_max_souls and max_souls_talent or base_max_souls
	template_data.talent_resource_component.max_resource = max_souls_talent
	template_data.talent_resource_component.current_resource = 0
end

function _psyker_passive_stop(template_data, template_context)
	local is_playing = template_data.fx_extension:is_looping_particles_playing("psyker_biomancer_soul")

	if is_playing then
		template_data.fx_extension:stop_looping_particles("psyker_biomancer_soul", true)
	end
end

function _psyker_passive_conditional_stat_buffs(template_data, template_context)
	if template_data.psyker_toughness_regen_soul then
		local soul_requirement = template_data.toughness_talent_soul_requirement
		local num_souls = template_data.talent_resource_component.current_resource

		return soul_requirement <= num_souls
	end
end

function _psyker_passive_lerp_t(t, start_time, duration, template_data, template_context)
	local current_num_souls = template_data.talent_resource_component.current_resource
	local max_num_souls = template_data.talent_resource_component.max_resource

	return current_num_souls / max_num_souls
end

function _psyker_passive_proc_on_kill(params, template_data, template_context)
	local is_elite = params.tags and (params.tags.elite or params.tags.special)

	if not is_elite then
		return false
	end

	local t = FixedFrame.get_latest_fixed_time()
	local buff_name = template_data.buff_name
	local num_stacks = template_data.psyker_increased_soul_generation and talent_settings_2.combat_ability_1.stacks or 1

	template_data.buff_extension:add_internally_controlled_buff_with_stacks(buff_name, num_stacks, t)
end

function _psyker_passive_proc_on_combat_ability(params, template_data, template_context)
	return
end

templates.psyker_passive_souls_from_elite_kills = {
	class_name = "psyker_passive_buff",
	predicted = false,
	use_talent_resource = true,
	keywords = {},
	stat_buffs = {},
	proc_events = {
		[proc_events.on_kill] = talent_settings_2.passive_1.on_hit_proc_chance,
		[proc_events.on_combat_ability] = talent_settings_2.passive_1.on_combat_ability_proc_chance,
	},
	conditional_stat_buffs = {
		toughness_replenish_modifier = talent_settings_2.defensive_2.toughness_replenish_modifier,
	},
	conditional_stat_buffs_func = _psyker_passive_conditional_stat_buffs,
	lerp_t_func = _psyker_passive_lerp_t,
	start_func = _psyker_passive_start,
	stop_func = _psyker_passive_stop,
	specific_proc_func = {
		on_kill = _psyker_passive_proc_on_kill,
		on_combat_ability = _psyker_passive_proc_on_combat_ability,
	},
}

function _add_soul_function(template_data, template_context, t, previous_stack_count)
	local stacks = template_context.stack_count
	local max_stacks = template_context.template.max_stacks

	template_data.talent_resource_component.current_resource = math.clamp(stacks, 0, max_stacks)

	local soul_screenspace_effect

	soul_screenspace_effect = stacks == max_stacks and "content/fx/particles/screenspace/screen_biomancer_maxsouls" or "content/fx/particles/screenspace/screen_biomancer_souls"

	template_data.fx_extension:spawn_exclusive_particle(soul_screenspace_effect, Vector3(0, 0, 1))

	if template_context.is_server then
		Managers.stats:record_private("hook_psyker_reached_max_souls", template_context.player)
	end

	if template_data.psyker_toughness_on_soul and template_context.is_server then
		local player_unit = template_context.unit
		local buff_extension = ScriptUnit.has_extension(player_unit, "buff_system")

		if buff_extension then
			local buff_name = "psyker_souls_replenish_toughness_stacking_buff"

			buff_extension:add_internally_controlled_buff(buff_name, t)
		end
	end
end

function _start_soul_function(template_data, template_context)
	local unit = template_context.unit
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local fx_extension = ScriptUnit.extension(unit, "fx_system")
	local talent_resource_component = unit_data_extension:write_component("talent_resource")
	local talent_extension = ScriptUnit.extension(unit, "talent_system")

	template_data.psyker_warpfire_on_max_souls = talent_extension:has_special_rule(special_rules.psyker_warpfire_on_max_souls)
	template_data.psyker_toughness_on_soul = talent_extension:has_special_rule(special_rules.psyker_toughness_on_soul)
	template_data.psyker_restore_cooldown_per_soul = talent_extension:has_special_rule(special_rules.psyker_restore_cooldown_per_soul)
	template_data.remove_on_ability = template_data.psyker_restore_cooldown_per_soul
	template_data.talent_resource_component = talent_resource_component
	template_data.fx_extension = fx_extension

	if template_context.is_server then
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase
		template_data.broadphase_results = {}

		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")

		template_data.enemy_side_names = enemy_side_names
	end

	local t = FixedFrame.get_latest_fixed_time()

	_add_soul_function(template_data, template_context, t, 0)
end

local REPORT_INTERVALL = 1

function _update_soul_function(template_data, template_context, dt, t)
	local stacks = template_context.stack_count
	local max_stacks = template_context.template.max_stacks
	local is_on_max = max_stacks <= stacks
	local time_at_max = template_data.time_at_max or 0

	time_at_max = is_on_max and time_at_max + dt or 0
	template_data.time_at_max = time_at_max

	local report_time = is_on_max and template_data.report_time or 0

	report_time = report_time + (is_on_max and dt or 0)

	if report_time > REPORT_INTERVALL then
		Managers.stats:record_private("hook_psyker_time_at_max_souls", template_context.player, time_at_max)
	end

	template_data.report_time = report_time % REPORT_INTERVALL

	local stacks = template_context.stack_count
	local current_stacks = template_data.talent_resource_component.current_resource

	if current_stacks ~= stacks then
		local max_stacks = template_context.template.max_stacks

		template_data.talent_resource_component.current_resource = math.clamp(stacks, 0, max_stacks)

		if stacks < current_stacks then
			Managers.stats:record_private("hook_psyker_lost_max_souls", template_context.player)
		end
	end
end

function _souls_stop_function(template_data, template_context)
	template_data.talent_resource_component.current_resource = 0
end

function _souls_conditional_exit_function(template_data, template_context)
	if not template_data.remove_on_ability then
		return
	end

	return template_data.ability_done
end

function _souls_proc_func(params, template_data, template_context)
	if template_data.psyker_restore_cooldown_per_soul then
		local num_souls = template_data.talent_resource_component.current_resource
		local unit = template_context.unit
		local ability_extension = ScriptUnit.has_extension(unit, "ability_system")

		if num_souls > 0 and ability_extension then
			local cooldown_reduction_percent = talent_settings_2.combat_ability_1.cooldown_reduction_percent
			local cooldown_percentage = cooldown_reduction_percent * num_souls

			ability_extension:reduce_ability_cooldown_percentage("combat_ability", cooldown_percentage)
		end
	end

	template_data.ability_done = true
end

local souls_proc_events = {
	[proc_events.on_combat_ability] = 1,
}

templates.psyker_souls = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_keystone_warp_syphon",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 1,
	predicted = false,
	refresh_duration_on_remove_stack = true,
	refresh_duration_on_stack = true,
	proc_events = souls_proc_events,
	max_stacks = base_max_souls,
	duration = soul_duration,
	proc_func = _souls_proc_func,
	start_func = _start_soul_function,
	update_func = _update_soul_function,
	refresh_func = _add_soul_function,
	stop_func = _souls_stop_function,
	conditional_exit_func = _souls_conditional_exit_function,
}
templates.psyker_souls_increased_max_stacks = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_keystone_warp_syphon",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 1,
	predicted = false,
	refresh_duration_on_remove_stack = true,
	refresh_duration_on_stack = true,
	proc_events = souls_proc_events,
	max_stacks = max_souls_talent,
	duration = soul_duration,
	proc_func = _souls_proc_func,
	start_func = _start_soul_function,
	update_func = _update_soul_function,
	refresh_func = _add_soul_function,
	stop_func = _souls_stop_function,
	conditional_exit_func = _souls_conditional_exit_function,
}
templates.psyker_shout_applies_warpfire = {
	class_name = "proc_buff",
	predicted = false,
	warpfire_max_stacks = 6,
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_combat_ability] = talent_settings_2.passive_1.on_combat_ability_proc_chance,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local warp_charge_component = unit_data_extension:write_component("warp_charge")

		template_data.warp_charge_component = warp_charge_component
	end,
	specific_proc_func = {
		on_combat_ability = function (params, template_data, template_context)
			local percent = params.warp_charge_percent
			local template = template_context.template
			local max_stacks = template.warpfire_max_stacks
			local num_stacks = math.ceil(percent * max_stacks)
			local num_warpfire_stacks = math.clamp(num_stacks, 1, max_stacks)

			template_data.stacks = num_warpfire_stacks
		end,
		on_hit = function (params, template_data, template_context)
			local damage_type = params.damage_type

			if damage_type ~= damage_types.psyker_biomancer_discharge then
				return
			end

			local t = FixedFrame.get_latest_fixed_time()
			local unit_hit = params.attacked_unit
			local buff_extension = ScriptUnit.has_extension(unit_hit, "buff_system")
			local num_warpfire_stacks = template_data.stacks or 1

			if buff_extension and HEALTH_ALIVE[unit_hit] and num_warpfire_stacks > 0 then
				buff_extension:add_internally_controlled_buff_with_stacks("warp_fire", num_warpfire_stacks, t, "owner_unit", template_context.unit)
			end
		end,
	},
}
templates.psyker_shout_reduces_warp_generation = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_psyker_shout_finish] = 1,
	},
	proc_func = function (params, template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()
		local buff_name = "psyker_shout_warp_generation_reduction"
		local num_hits = params.num_hits

		template_context.buff_extension:add_internally_controlled_buff_with_stacks(buff_name, num_hits, t, "parent_buff_template", "psyker_shout_reduces_warp_generation")
	end,
}
templates.psyker_shout_warp_generation_reduction = {
	class_name = "buff",
	duration = 5,
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_shout_reduces_warp_charge_generation",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 1,
	max_stacks = 25,
	predicted = false,
	stat_buffs = {
		[stat_buffs.warp_charge_amount] = 0.99,
	},
	talent_overrides = {
		{
			stat_buffs = {
				[stat_buffs.warp_charge_amount] = 0.99,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.warp_charge_amount] = 0.98,
			},
		},
	},
}
templates.psyker_combat_ability_extra_charge = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	stat_buffs = {
		[stat_buffs.ability_extra_charges] = 1,
	},
}
templates.psyker_ability_increase_brain_burst_speed = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_combat_ability] = 1,
	},
	proc_func = function (params, template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()
		local buff_name = "psyker_efficient_smites"

		template_context.buff_extension:add_internally_controlled_buff(buff_name, t)
	end,
}
templates.psyker_efficient_smites = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_ability_increase_brain_burst_speed",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 3,
	predicted = false,
	duration = talent_settings_2.combat_ability_3.duration,
	stat_buffs = {
		[stat_buffs.warp_charge_amount_smite] = talent_settings_2.combat_ability_3.warp_charge_amount_smite,
		[stat_buffs.smite_attack_speed] = talent_settings_2.combat_ability_3.smite_attack_speed,
	},
	player_effects = {
		on_screen_effect = "content/fx/particles/screenspace/psyker_biomancer_fast_smites",
	},
}
templates.psyker_chance_to_vent_on_kill = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = talent_settings_2.passive_2.on_hit_proc_chance,
	},
	check_proc_func = CheckProcFunctions.on_kill,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local warp_charge_component = unit_data_extension:write_component("warp_charge")

		template_data.warp_charge_component = warp_charge_component
		template_data.counter = 0
	end,
	proc_func = function (params, template_data, template_context)
		template_data.procced = true
	end,
	update_func = function (template_data, template_context, dt, t)
		if template_data.procced then
			local warp_charge_component = template_data.warp_charge_component
			local remove_percentage = talent_settings_2.passive_2.warp_charge_percent
			local unit = template_context.unit

			WarpCharge.decrease_immediate(remove_percentage, warp_charge_component, unit)

			template_data.procced = false
		end
	end,
}
templates.psyker_brain_burst_improved = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.smite_damage] = 0.5,
	},
}
templates.psyker_reduced_throwing_knife_cooldown = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.grenade_ability_cooldown_modifier] = -0.3,
	},
}
templates.psyker_weakspot_kills_can_refund_knife = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 0.25,
	},
	check_proc_func = CheckProcFunctions.on_weakspot_kill,
	proc_func = function (params, template_data, template_context)
		local unit = template_context.unit
		local position = POSITION_LOOKUP[unit]
		local fx_extension = ScriptUnit.extension(unit, "fx_system")

		fx_extension:trigger_exclusive_wwise_event("wwise/events/player/play_pick_up_ammo_01", position)

		local ability_extension = ScriptUnit.has_extension(unit, "ability_system")

		if ability_extension then
			local ABILITY_TYPE = "grenade_ability"
			local knifes_restored = 1

			ability_extension:restore_ability_charge(ABILITY_TYPE, knifes_restored)
		end
	end,
}

local external_properties = {}

templates.psyker_knife_replenishment = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_throwing_knives_reduced_cooldown",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_blitz",
	hud_priority = 4,
	predicted = false,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.ability_extension = ScriptUnit.has_extension(unit, "ability_system")
		template_data.fx_extension = ScriptUnit.extension(unit, "fx_system")
		template_data.first_person_extension = ScriptUnit.extension(unit, "first_person_system")
		template_data.missing_charges = 0
	end,
	update_func = function (template_data, template_context, dt, t, template)
		if not template_data.ability_extension then
			local unit = template_context.unit
			local ability_extension = ScriptUnit.has_extension(unit, "ability_system")

			if not ability_extension then
				return
			end

			template_data.ability_extension = ability_extension
		end

		local ability_extension = template_data.ability_extension

		if not ability_extension or not ability_extension:has_ability_type("grenade_ability") then
			template_data.next_knife_t = nil
			template_data.missing_charges = 0

			return
		end

		local missing_charges = ability_extension and ability_extension:missing_ability_charges("grenade_ability")

		if missing_charges == 0 then
			template_data.next_knife_t = nil
			template_data.missing_charges = 0

			return
		end

		template_data.missing_charges = missing_charges

		local next_knife_t = template_data.next_knife_t

		if not next_knife_t then
			local cooldown = ability_extension:max_ability_cooldown("grenade_ability")

			template_data.next_knife_t = t + cooldown
			template_data.cooldown = cooldown

			return
		end

		if next_knife_t < t then
			template_data.next_knife_t = nil

			local first_person_extension = template_data.first_person_extension

			if first_person_extension and first_person_extension:is_in_first_person_mode() and missing_charges == 1 then
				external_properties.indicator_type = "psyker_throwing_knives"

				template_data.fx_extension:trigger_gear_wwise_event("grenade_recover_indicator", external_properties)
			end
		end
	end,
	check_active_func = function (template_data, template_context)
		local is_missing_charges = template_data.missing_charges > 0

		return is_missing_charges
	end,
	duration_func = function (template_data, template_context)
		local next_knife_t = template_data.next_knife_t

		if not next_knife_t then
			return 1
		end

		local t = FixedFrame.get_latest_fixed_time()
		local time_until_next = next_knife_t - t
		local percentage_left = time_until_next / template_data.cooldown

		return 1 - percentage_left
	end,
}

local marked_targets = {}

function _psyker_marked_enemies_select_unit(template_data, template_context, last_unit_pos, t)
	local broadphase = template_data.broadphase
	local enemy_side_names = template_data.enemy_side_names
	local broadphase_results = template_data.broadphase_results

	table.clear(broadphase_results)
	table.clear(marked_targets)

	local unit = template_context.unit
	local rotation = template_data.first_person_component.rotation
	local direction = Vector3.normalize(Vector3.flat(Quaternion.forward(rotation)))
	local position = POSITION_LOOKUP[unit]
	local distance = template_data.distance
	local num_results = broadphase.query(broadphase, position, distance, broadphase_results, enemy_side_names)

	for i = 1, num_results do
		local enemy_unit = broadphase_results[i]

		if HEALTH_ALIVE[enemy_unit] then
			local unit_data_extension = ScriptUnit.extension(enemy_unit, "unit_data_system")
			local breed = unit_data_extension:breed()
			local valid_breed = breed.psyker_mark_target

			if valid_breed then
				local unit_pos = POSITION_LOOKUP[enemy_unit]
				local direction_to_target = Vector3.normalize(unit_pos - position)
				local dot = Vector3.dot(direction, direction_to_target)

				if dot > 0.5 then
					local perception_extension = ScriptUnit.has_extension(enemy_unit, "perception_system")
					local has_line_of_sight = perception_extension and perception_extension:has_line_of_sight(unit)

					if has_line_of_sight then
						local distance_to_unit = Vector3.distance_squared(last_unit_pos or unit_pos, position)

						marked_targets[enemy_unit] = distance_to_unit
					end
				end
			end
		end
	end

	local chosen_unit

	if last_unit_pos then
		local chosen_distance = math.huge

		for enemy_unit, distance_to_unit in pairs(marked_targets) do
			if distance_to_unit < chosen_distance then
				chosen_unit = enemy_unit
				chosen_distance = distance_to_unit
			end
		end
	else
		chosen_unit = next(marked_targets)
	end

	if chosen_unit and template_data.current_target then
		local unit_id = Managers.state.unit_spawner:game_object_id(template_data.current_target)
		local outline_name = "psyker_marked_target"
		local outline_id = NetworkLookup.outline_types[outline_name]
		local channel_id = template_context.player:channel_id()

		if channel_id and unit_id then
			RPC.rpc_remove_outline_from_unit(channel_id, unit_id, outline_id)
		end

		if not DEDICATED_SERVER then
			local outline_system = Managers.state.extension:system("outline_system")

			outline_system:remove_outline(template_data.current_target, "psyker_marked_target")
		end
	end

	if chosen_unit then
		local unit_id = Managers.state.unit_spawner:game_object_id(chosen_unit)
		local outline_name = "psyker_marked_target"
		local outline_id = NetworkLookup.outline_types[outline_name]
		local channel_id = template_context.player:channel_id()

		template_data.last_los = t
		template_data.last_seen = t

		if channel_id and unit_id then
			RPC.rpc_add_outline_to_unit(channel_id, unit_id, outline_id)
		end

		if not DEDICATED_SERVER then
			local outline_system = Managers.state.extension:system("outline_system")

			outline_system:add_outline(chosen_unit, outline_name)
		end

		template_data.current_target = chosen_unit
	end
end

local function _give_stack_of_unnatural_talent(template_data, template_context, weakspot)
	local template = template_context.template

	if template_data.has_chance_to_vent then
		local portable_random = template_context.buff_extension:portable_random()
		local random_value = portable_random:next_random()
		local chance = template_data.vent_chance

		if random_value < chance then
			template_data.procced = true
		end
	end

	local t = FixedFrame.get_latest_fixed_time()

	template_data.buff_extension:add_internally_controlled_buff("psyker_marked_enemies_passive_bonus", t)

	local num_buffs = weakspot and TalentSettings.mark_passive.weakspot_stacks or 1

	template_data.buff_extension:add_internally_controlled_buff_with_stacks(template_data.mark_bonus_buff, num_buffs, t)
	Toughness.replenish_percentage(template_context.unit, template.toughness_percentage)
end

local function _send_time_spent_to_stat_system(player, time_spent)
	local rounded_time_value = math.floor(time_spent)

	Managers.stats:record_private("hook_psyker_spent_max_unnatural_stack", player, rounded_time_value)

	return 0
end

templates.psyker_marked_enemies_passive = {
	chance_to_vent_proc_chance = 0.2,
	chance_to_vent_warp_charge_percent = 0.15,
	class_name = "proc_buff",
	predicted = false,
	target_distance_base = 25,
	target_distance_improved = 40,
	toughness_percentage = 0.1,
	proc_events = {
		[proc_events.on_minion_death] = 1,
		[proc_events.on_hit] = 1,
		[proc_events.on_damage_taken] = 1,
	},
	start_func = function (template_data, template_context)
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase
		local template = template_context.template

		template_data.broadphase = broadphase
		template_data.broadphase_results = {}

		local max_stacks = 15
		local last_stack = 0
		local current_stack = 0
		local final_time_spent = 0

		template_data.unmodified_max_stacks = max_stacks
		template_data.max_stacks = max_stacks
		template_data.last_stack = last_stack
		template_data.current_stack = current_stack
		template_data.final_time_spent = final_time_spent
		template_data.default_max_stacks = max_stacks

		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")

		template_data.enemy_side_names = enemy_side_names
		template_data.current_target = nil
		template_data.secondary_target = nil
		template_data.visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")

		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.first_person_component = unit_data_extension:read_component("first_person")

		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		template_data.buff_extension = buff_extension
		template_data.last_seen = 0
		template_data.last_los = 0
		template_data.last_encountered = 0
		template_data.last_seen_check = 0

		local talent_extension = ScriptUnit.extension(unit, "talent_system")
		local increased_stacks = talent_extension:has_special_rule(special_rules.psyker_mark_increased_max_stacks)
		local increased_duration = talent_extension:has_special_rule(special_rules.psyker_mark_increased_duration)

		if increased_stacks then
			template_data.mark_bonus_buff = "psyker_marked_enemies_passive_bonus_stacking_increased_stacks"
		elseif increased_duration then
			template_data.mark_bonus_buff = "psyker_marked_enemies_passive_bonus_stacking_increased_duration"
		else
			template_data.mark_bonus_buff = "psyker_marked_enemies_passive_bonus_stacking"
		end

		template_data.distance = 40
		template_data.all_weakspot_kills_grant_buff = talent_extension:has_special_rule(special_rules.psyker_mark_weakspot_kills)
		template_data.has_chance_to_vent = talent_extension:has_special_rule(special_rules.psyker_mark_kills_can_vent)

		if template_data.has_chance_to_vent then
			template_data.warp_charge_component = unit_data_extension:write_component("warp_charge")
			template_data.warp_charge_percent = template.chance_to_vent_warp_charge_percent
			template_data.vent_chance = template.chance_to_vent_proc_chance
		end
	end,
	update_func = function (template_data, template_context, dt, t)
		local current_target = template_data.current_target

		if current_target and t > template_data.last_seen_check + 1 then
			if HEALTH_ALIVE[current_target] then
				local unit_pos = POSITION_LOOKUP[current_target]
				local position = POSITION_LOOKUP[template_context.unit]
				local to_target = unit_pos - position
				local distance = Vector3.length(to_target)

				if distance < template_data.distance + 5 then
					template_data.last_seen = t

					if distance > 15 then
						local unit = template_context.unit
						local rotation = template_data.first_person_component.rotation
						local direction = Vector3.normalize(Vector3.flat(Quaternion.forward(rotation)))
						local direction_to_target = Vector3.normalize(unit_pos - position)
						local dot = Vector3.dot(direction, direction_to_target)

						if dot > 0.5 then
							local perception_extension = ScriptUnit.has_extension(current_target, "perception_system")
							local has_line_of_sight = perception_extension and perception_extension:has_line_of_sight(unit)

							if has_line_of_sight then
								template_data.last_los = t
							end
						end
					end
				end
			end

			template_data.last_seen_check = t
		end

		if not current_target or (t > template_data.last_seen + 2 or t > template_data.last_los + 5) and t > template_data.last_encountered + 5 then
			_psyker_marked_enemies_select_unit(template_data, template_context, nil, t)
		end

		if template_data.procced then
			local warp_charge_component = template_data.warp_charge_component
			local remove_percentage = template_data.warp_charge_percent
			local unit = template_context.unit

			WarpCharge.decrease_immediate(remove_percentage, warp_charge_component, unit)

			template_data.procced = false
		end

		template_data.current_stack = template_context.buff_extension:current_stacks(template_data.mark_bonus_buff)

		if template_data.current_stack >= template_data.default_max_stacks and dt then
			template_data.final_time_spent = template_data.final_time_spent + dt
		end

		if template_data.current_stack < template_data.unmodified_max_stacks and template_data.last_stack > template_data.current_stack then
			template_data.final_time_spent = _send_time_spent_to_stat_system(template_context.player, template_data.final_time_spent)
		elseif template_data.final_time_spent >= 10 then
			template_data.final_time_spent = _send_time_spent_to_stat_system(template_context.player, template_data.final_time_spent)
		end

		template_data.last_stack = template_data.current_stack

		if template_data.attacked_unit and t > template_data.attacked_unit_t then
			template_data.attacked_unit = nil
		end
	end,
	specific_proc_func = {
		on_minion_death = function (params, template_data, template_context, t)
			if params.attacking_unit == template_context.unit then
				return
			end

			local victim_unit = params.dying_unit

			if victim_unit ~= template_data.current_target then
				return
			end

			if victim_unit ~= template_data.attacked_unit then
				return
			end

			local hit_pos = params.hit_world_position and params.hit_world_position:unbox() or POSITION_LOOKUP[victim_unit]

			_psyker_marked_enemies_select_unit(template_data, template_context, hit_pos, t)
			_give_stack_of_unnatural_talent(template_data, template_context)
		end,
		on_hit = function (params, template_data, template_context, t)
			if params.attacking_unit ~= template_context.unit then
				return
			end

			local victim_unit = params.attacked_unit
			local current_target = template_data.current_target
			local kill = params.attack_result == attack_results.died

			if kill then
				local valid_target = victim_unit == current_target

				if valid_target then
					local weakspot = template_data.all_weakspot_kills_grant_buff and params.hit_weakspot

					_give_stack_of_unnatural_talent(template_data, template_context, weakspot)

					local hit_pos = params.hit_world_position and params.hit_world_position:unbox() or POSITION_LOOKUP[victim_unit]

					_psyker_marked_enemies_select_unit(template_data, template_context, hit_pos, t)
				end
			elseif victim_unit == current_target then
				template_data.attacked_unit = victim_unit
				template_data.attacked_unit_t = t + 1
				template_data.last_seen_check = t

				local current_stacks = template_context.buff_extension:current_stacks(template_data.mark_bonus_buff)

				if current_stacks > 0 and victim_unit == current_target then
					template_context.buff_extension:refresh_duration_of_stacking_buff(template_data.mark_bonus_buff, t)
				end
			end

			if template_data.current_target and (params.attacked_unit == template_data.current_target or params.attacking_unit == template_data.current_target) then
				template_data.last_encountered = t
			end
		end,
		on_damage_taken = function (params, template_data, template_context, t)
			if template_data.current_target and (params.attacked_unit == template_data.current_target or params.attacking_unit == template_data.current_target) then
				template_data.last_encountered = t
			end
		end,
	},
}
templates.psyker_marked_enemies_passive_bonus_stacking = {
	class_name = "buff",
	duration = 4,
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_keystone_unnatural_talent",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 1,
	max_stacks = 15,
	predicted = false,
	refresh_duration_on_remove_stack = true,
	refresh_duration_on_stack = true,
	stat_buffs = {
		[stat_buffs.damage] = 0.01,
		[stat_buffs.critical_strike_damage] = 0.02,
		[stat_buffs.weakspot_damage] = 0.025,
	},
}
templates.psyker_marked_enemies_passive_bonus_stacking_increased_stacks = table.clone(templates.psyker_marked_enemies_passive_bonus_stacking)
templates.psyker_marked_enemies_passive_bonus_stacking_increased_stacks.max_stacks = 25
templates.psyker_marked_enemies_passive_bonus_stacking_increased_duration = table.clone(templates.psyker_marked_enemies_passive_bonus_stacking)
templates.psyker_marked_enemies_passive_bonus_stacking_increased_duration.duration = 10
templates.psyker_marked_enemies_passive_bonus = {
	class_name = "buff",
	duration = 2.5,
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_keystone_unnatural_talent",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 1,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	stat_buffs = {
		[stat_buffs.movement_speed] = 0.2,
	},
	keywords = {
		[keywords.count_as_dodge_vs_ranged] = true,
	},
}

local overcharge_max_stacks = TalentSettings.overcharge_stance.max_stacks

templates.psyker_overcharge_stance = {
	always_show_in_hud = true,
	class_name = "proc_buff",
	early_out_percentage = 1,
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_ability_overcharge_stance",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 1,
	max_stacks = 1,
	predicted = false,
	player_effects = {
		looping_wwise_start_event = "wwise/events/player/play_ability_gunslinger_on",
		looping_wwise_stop_event = "wwise/events/player/play_ability_gunslinger_off",
		on_screen_effect = "content/fx/particles/screenspace/screen_psyker_overcharge_stance",
		wwise_state = {
			group = "player_ability",
			off_state = "none",
			on_state = "psyker_gunslinger_ability",
		},
	},
	stat_buffs = {
		[stat_buffs.weakspot_damage] = 0.1,
		[stat_buffs.damage] = TalentSettings.overcharge_stance.base_damage,
		[stat_buffs.critical_strike_chance] = TalentSettings.overcharge_stance.crit_chance,
	},
	lerped_stat_buffs = {
		[stat_buffs.damage] = {
			min = 0,
			max = TalentSettings.overcharge_stance.damage_per_stack * overcharge_max_stacks,
		},
	},
	conditional_lerped_stat_buffs = {
		[stat_buffs.finesse_modifier_bonus] = {
			min = 0,
			max = TalentSettings.overcharge_stance.finesse_damage_per_stack * overcharge_max_stacks,
		},
	},
	keywords = {
		keywords.psyker_overcharge,
		keywords.suppression_immune,
	},
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.on_hit_charge_template = WeaponChargeTemplates.psyker_overcharge_stance_hit
		template_data.on_kill_charge_template = WeaponChargeTemplates.psyker_overcharge_stance_kill
		template_data.passive_charge_template = WeaponChargeTemplates.psyker_overcharge_stance_passive

		local unit = template_context.unit
		local talent_extension = ScriptUnit.extension(unit, "talent_system")
		local weakspot_stacks = talent_extension:has_special_rule(special_rules.psyker_overchage_stance_weakspot_kills)

		template_data.weakspot_stacks = weakspot_stacks

		local prevent_overload_talent = talent_extension:has_special_rule(special_rules.psyker_overcharge_stance_infinite_casting)

		template_data.prevent_overload_talent = prevent_overload_talent

		local unit_data_extension = ScriptUnit.extension(template_context.unit, "unit_data_system")

		template_data.warp_charge_component = unit_data_extension:write_component("warp_charge")
		template_data.start_t = FixedFrame.get_latest_fixed_time()
		template_data.negative_value = 0
		template_data.stacks = 0
		template_data.bonus_stacks = 0

		_overcharge_stance_penance_start(template_data, template_context)
	end,
	update_func = function (template_data, template_context, dt, t)
		local start_t = template_data.start_t
		local wanted_stacks = math.clamp(math.ceil(t - start_t), 0, overcharge_max_stacks)

		if wanted_stacks ~= template_data.stacks then
			template_data.stacks = wanted_stacks
		end

		local max_duration = 12
		local multiplier = 1 + (t - start_t) / max_duration
		local amount = math.max(multiplier * multiplier - template_data.negative_value, 1)

		WarpCharge.increase_immediate(t, amount, template_data.warp_charge_component, template_data.passive_charge_template, template_context.unit, 1, true)

		template_data.negative_value = math.max(template_data.negative_value - dt * 3, 0)
	end,
	proc_func = function (params, template_data, template_context, t)
		if params.damage == 0 then
			return
		end

		local attack_result = params.attack_result

		if attack_result == "died" then
			template_data.negative_value = template_data.negative_value + 1

			if template_data.weakspot_stacks and CheckProcFunctions.on_weakspot_kill(params, template_data, template_context, t) then
				template_data.bonus_stacks = template_data.bonus_stacks + TalentSettings.overcharge_stance.second_per_weakspot
			end
		end
	end,
	conditional_exit_func = function (template_data, template_context)
		return template_data.warp_charge_component.current_percentage == template_context.template.early_out_percentage
	end,
	conditional_lerped_stat_buffs_func = function (template_data, template_context)
		return template_data.weakspot_stacks
	end,
	stop_func = function (template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()

		if template_data.prevent_overload_talent then
			template_context.buff_extension:add_internally_controlled_buff("psyker_overcharge_stance_infinite_casting", t)
		else
			template_context.buff_extension:add_internally_controlled_buff("psyker_overcharge_stance_cool_off", t)
		end

		local stacks = math.min(overcharge_max_stacks, template_data.stacks + template_data.bonus_stacks)
		local buff_name

		buff_name = template_data.weakspot_stacks and "psyker_overcharge_stance_finesse_damage" or "psyker_overcharge_stance_damage"

		template_context.buff_extension:add_internally_controlled_buff_with_stacks(buff_name, stacks, t)
		_overcharge_stance_penance_stop(template_data, template_context)
	end,
	visual_stack_count = function (template_data, template_context)
		return math.min(overcharge_max_stacks, template_data.stacks + template_data.bonus_stacks)
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		return math.min(overcharge_max_stacks, template_data.stacks + template_data.bonus_stacks) / overcharge_max_stacks
	end,
}
templates.psyker_overcharge_stance_cool_off = {
	class_name = "buff",
	predicted = false,
	duration = TalentSettings.overcharge_stance.cooloff_duration,
	keywords = {
		keywords.psychic_fortress,
	},
}
templates.psyker_overcharge_stance_damage = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_ability_overcharge_stance",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 1,
	predicted = false,
	max_stacks = overcharge_max_stacks,
	max_stacks_cap = overcharge_max_stacks,
	duration = TalentSettings.overcharge_stance.post_stance_duration,
	player_effects = {
		looping_wwise_start_event = "wwise/events/player/play_ability_gunslinger_second_buff_on",
		looping_wwise_stop_event = "wwise/events/player/play_ability_gunslinger_second_buff_off",
		on_screen_effect = "content/fx/particles/screenspace/screen_psyker_overcharge_stance_minor",
		wwise_state = {
			group = "player_ability",
			off_state = "none",
			on_state = "psyker_gunslinger_ability",
		},
	},
	stat_buffs = {
		[stat_buffs.damage] = TalentSettings.overcharge_stance.damage_per_stack,
	},
}
templates.psyker_overcharge_stance_finesse_damage = table.clone(templates.psyker_overcharge_stance_damage)
templates.psyker_overcharge_stance_finesse_damage.stat_buffs = {
	[stat_buffs.damage] = TalentSettings.overcharge_stance.damage_per_stack,
	[stat_buffs.finesse_modifier_bonus] = TalentSettings.overcharge_stance.finesse_damage_per_stack,
}
templates.psyker_overcharge_reduced_warp_charge = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.warp_charge_amount] = 0.8,
	},
	start_func = function (template_data, template_context)
		local buff_extension = ScriptUnit.extension(template_context.unit, "buff_system")

		template_data.buff_extension = buff_extension
	end,
	update_func = function (template_data, template_context)
		template_data.active = template_data.buff_extension:has_keyword(keywords.psyker_overcharge)
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.active
	end,
}
templates.psyker_overcharge_stance_infinite_casting = {
	class_name = "buff",
	predicted = false,
	duration = TalentSettings.overcharge_stance.post_stance_duration + TalentSettings.overcharge_stance.cooloff_duration,
	keywords = {
		keywords.psychic_fortress,
	},
}
templates.psyker_overcharge_reduced_toughness_damage_taken = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = 0.8,
	},
	start_func = function (template_data, template_context)
		local buff_extension = ScriptUnit.extension(template_context.unit, "buff_system")

		template_data.buff_extension = buff_extension
	end,
	update_func = function (template_data, template_context)
		template_data.active = template_data.buff_extension:has_keyword(keywords.psyker_overcharge)
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.active
	end,
}
templates.psyker_overcharge_increased_movement_speed = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.movement_speed] = 0.2,
	},
	start_func = function (template_data, template_context)
		local buff_extension = ScriptUnit.extension(template_context.unit, "buff_system")

		template_data.buff_extension = buff_extension
	end,
	update_func = function (template_data, template_context)
		template_data.active = template_data.buff_extension:has_keyword(keywords.psyker_overcharge)
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.active
	end,
}
templates.psyker_overcharge_weakspot_kill_bonuses = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	update_func = function (template_data, template_context)
		template_data.active = template_context.buff_extension:has_keyword(keywords.psyker_overcharge)
	end,
	check_proc_func = CheckProcFunctions.on_weakspot_kill,
	conditional_proc_func = function (template_data, template_context)
		return template_data.active
	end,
	proc_func = function (params, template_data, template_context, dt, t)
		template_context.buff_extension:add_internally_controlled_buff("psyker_overcharge_weakspot_kill_bonuses_buff", t)
	end,
}
templates.psyker_overcharge_weakspot_kill_bonuses_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_overcharge_weakspot_kill_bonuses",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 3,
	max_stacks = 25,
	predicted = false,
	stat_buffs = {
		[stat_buffs.finesse_modifier_bonus] = 0.1,
	},
	start_func = function (template_data, template_context)
		template_data.buff_extension = ScriptUnit.extension(template_context.unit, "buff_system")
	end,
	update_func = function (template_data, template_context)
		template_data.inactive = not template_data.buff_extension:has_keyword(keywords.psyker_overcharge)
	end,
	conditional_exit_func = function (template_data, template_context)
		return template_data.inactive
	end,
}
templates.psyker_aura_damage_vs_elites = {
	class_name = "buff",
	coherency_id = "psyker_bionmancer_coherency_aura",
	coherency_priority = 2,
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_aura_kinetic_presence",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 5,
	predicted = false,
	buff_category = buff_categories.aura,
	max_stacks = talent_settings_2.coherency.max_stacks,
	stat_buffs = {
		[stat_buffs.damage_vs_elites] = talent_settings_2.coherency.damage_vs_elites,
	},
	start_func = _penance_start_func("psyker_elite_kills_aura_tracking_buff"),
}
templates.psyker_elite_kills_aura_tracking_buff = {
	class_name = "proc_buff",
	predicted = false,
	unique_buff_id = "psyker_elite_kills_aura_tracking_buff",
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_elite_or_special_minion_death,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.parent_buff_name = "psyker_aura_damage_vs_elites"
		template_data.hook_name = "hook_psyker_team_elite_aura_kills"
		template_data.last_num_in_coherency = 0
		template_data.valid_buff_owners = {}
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		if unit ~= params.attacking_unit then
			return
		end

		template_data.last_num_in_coherency, template_data.valid_buff_owners = template_data.coherency_extension:evaluate_and_send_achievement_data(template_data.last_num_in_coherency, template_data.valid_buff_owners, template_data.parent_buff_name, template_data.hook_name)
	end,
}
templates.psyker_aura_crit_chance_aura = {
	class_name = "buff",
	coherency_id = "psyker_coherency_aura",
	coherency_priority = 2,
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_aura_gunslinger_aura",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 5,
	max_stacks = 1,
	predicted = false,
	buff_category = buff_categories.aura,
	stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.05,
	},
	start_func = _penance_start_func("psyker_crit_hits_aura_tracking_buff"),
}
templates.psyker_crit_hits_aura_tracking_buff = {
	buff_id = "psyker_crit_hits_aura_tracking_buff",
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.last_num_in_coherency = 0
		template_data.valid_buff_owners = {}
		template_data.num_crits_made = 0
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		if not params.is_critical_strike then
			return
		end

		local unit = template_context.unit

		if unit ~= params.attacking_unit then
			return
		end

		if template_data.num_crits_made >= 2 then
			local hook_name = "hook_psyker_team_critical_hits_aura"
			local parent_buff_name = "psyker_aura_crit_chance_aura"

			template_data.last_num_in_coherency, template_data.valid_buff_owners = template_data.coherency_extension:evaluate_and_send_achievement_data(template_data.last_num_in_coherency, template_data.valid_buff_owners, parent_buff_name, hook_name, template_data.num_crits_made)
			template_data.num_crits_made = 0
		end

		template_data.num_crits_made = template_data.num_crits_made + 1
	end,
}
templates.psyker_aura_crit_chance_aura_improved = {
	class_name = "buff",
	coherency_id = "psyker_coherency_aura",
	coherency_priority = 1,
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_aura_gunslinger_aura",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 5,
	max_stacks = 1,
	predicted = false,
	stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.06,
	},
}

local percent_toughness = talent_settings_2.toughness_1.percent_toughness

templates.psyker_souls_replenish_toughness_stacking_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_2_tier_1_name_1",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = talent_settings_2.toughness_1.max_stacks,
	duration = talent_settings_2.toughness_1.duration,
	update_func = function (template_data, template_context, dt, t)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local percent_to_replenish = percent_toughness * dt

		Toughness.replenish_percentage(unit, percent_to_replenish, false, "talent_toughness_1")
	end,
}
templates.psyker_toughness_on_warp_kill = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_warp_kill,
	proc_func = function (params, template_data, template_context)
		local percentage = talent_settings_2.toughness_2.percent_toughness

		Toughness.replenish_percentage(template_context.unit, percentage, false, "talent_toughness_2")
	end,
}
templates.psyker_toughness_on_warp_generation = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_warp_charge_changed] = 1,
	},
	proc_func = function (params, template_data, template_context)
		local percentage_change = params.percentage_change

		if percentage_change < 0 then
			local toughness_percentage = talent_settings_2.toughness_4.multiplier

			percentage_change = math.abs(percentage_change * toughness_percentage)

			Toughness.replenish_percentage(template_context.unit, percentage_change, false, "toughness_on_warp_generation")
		end
	end,
}
templates.psyker_toughness_on_vent = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_warp_charge_changed] = 1,
	},
	proc_func = function (params, template_data, template_context)
		local percentage_change = params.percentage_change

		if percentage_change > 0 then
			local toughness_percentage = percentage_change * talent_settings_2.toughness_3.multiplier

			Toughness.replenish_percentage(template_context.unit, toughness_percentage, false, "toughness_on_vent")
		end
	end,
}
templates.psyker_warp_charge_increase_force_weapon_damage = {
	class_name = "buff",
	predicted = false,
	lerped_stat_buffs = {
		[stat_buffs.damage] = {
			min = talent_settings_2.offensive_1_1.damage_min,
			max = talent_settings_2.offensive_1_1.damage,
		},
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.warp_charge_component = unit_data_extension:read_component("warp_charge")
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local current_percent = template_data.warp_charge_component.current_percentage

		return current_percent
	end,
}
templates.psyker_reduced_warp_charge_cost_and_venting_speed = {
	class_name = "buff",
	predicted = false,
	lerped_stat_buffs = {
		[stat_buffs.warp_charge_amount] = {
			min = 1,
			max = talent_settings_2.offensive_1_2.warp_charge_capacity,
		},
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local talent_resource_component = unit_data_extension:read_component("talent_resource")

		template_data.talent_resource_component = talent_resource_component
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local current_souls = template_data.talent_resource_component.current_resource

		return current_souls / max_souls_talent
	end,
}
templates.psyker_souls_increase_damage = {
	class_name = "buff",
	predicted = false,
	lerped_stat_buffs = {
		[stat_buffs.damage] = {
			min = 0,
			max = talent_settings_2.passive_1.damage,
		},
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local talent_resource_component = unit_data_extension:read_component("talent_resource")

		template_data.talent_resource_component = talent_resource_component
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local current_souls = template_data.talent_resource_component.current_resource

		return current_souls / max_souls_talent
	end,
}
templates.psyker_elite_kills_add_warpfire = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	start_func = function (template_data, template_context)
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase
		template_data.broadphase_results = {}

		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")

		template_data.enemy_side_names = enemy_side_names
	end,
	check_proc_func = function (params)
		if params.attack_result ~= attack_results.died then
			return false
		end

		if not params.tags then
			return false
		end

		if not params.tags.elite and not params.tags.special then
			return false
		end

		return true
	end,
	proc_func = function (params, template_data, template_context)
		local broadphase = template_data.broadphase
		local enemy_side_names = template_data.enemy_side_names
		local broadphase_results = template_data.broadphase_results

		table.clear(broadphase_results)

		local attacked_unit = params.attacked_unit
		local position = Unit.alive(attacked_unit) and POSITION_LOOKUP[attacked_unit] or params.hit_world_position and params.hit_world_position:unbox()

		if not position then
			return
		end

		local distance = talent_settings_2.offensive_1_3.distance
		local num_results = broadphase.query(broadphase, position, distance, broadphase_results, enemy_side_names)
		local has_extension = ScriptUnit.has_extension

		if params.damage_type and params.damage_type == "warpfire" and not params.attack_type then
			return
		end

		for ii = 1, num_results do
			local hit_unit = broadphase_results[ii]
			local buff_extension = has_extension(hit_unit, "buff_system")

			if buff_extension then
				local t = FixedFrame.get_latest_fixed_time()
				local num_stacks = talent_settings_2.offensive_1_3.num_stacks
				local owner_unit = template_context.unit

				buff_extension:add_internally_controlled_buff_with_stacks("warp_fire", num_stacks, t, "owner_unit", owner_unit)
			end
		end
	end,
}
templates.psyker_aura_souls_on_kill = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_minion_death] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local talent_extension = ScriptUnit.extension(unit, "talent_system")
		local has_psyker_increased_max_souls = talent_extension:has_special_rule(special_rules.psyker_increased_max_souls)

		template_data.buff_name = has_psyker_increased_max_souls and "psyker_souls_increased_max_stacks" or "psyker_souls"
		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit_in_coherency = params.attacking_unit and template_data.coherency_extension:is_unit_in_coherency(params.attacking_unit)

		if not unit_in_coherency then
			return
		end

		local proc_chance = talent_settings_2.coop_1.on_kill_proc_chance

		if proc_chance > math.random() then
			local t = FixedFrame.get_latest_fixed_time()
			local buff_extension = ScriptUnit.extension(template_context.unit, "buff_system")

			buff_extension:add_internally_controlled_buff(template_data.buff_name, t)
		end
	end,
}
templates.psyker_aura_cooldown_reduction_on_elite_kill = {
	class_name = "proc_buff",
	predicted = false,
	stat_buffs = {},
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_elite_or_special_kill,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.coherency_extension = ScriptUnit.has_extension(unit, "coherency_system")
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local coherency_extension = template_data.coherency_extension

		if not coherency_extension then
			return
		end

		local percent = talent_settings_2.coop_2.percent
		local in_coherence_units = coherency_extension:in_coherence_units()

		for coherence_unit, _ in pairs(in_coherence_units) do
			local ability_extension = ScriptUnit.has_extension(coherence_unit, "ability_system")

			if ability_extension then
				local ability_type = "combat_ability"
				local has_ability_type = ability_extension:has_ability_type(ability_type)

				if has_ability_type then
					ability_extension:reduce_ability_cooldown_percentage(ability_type, percent)
				end
			end
		end
	end,
}
templates.psyker_smite_makes_victim_vulnerable = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_smite_attack,
	proc_func = function (params, template_data, template_context)
		local hit_unit = params.attacked_unit

		if HEALTH_ALIVE[hit_unit] then
			local buff_extension = ScriptUnit.has_extension(hit_unit, "buff_system")

			if buff_extension then
				local t = FixedFrame.get_latest_fixed_time()
				local buff_name = "psyker_smite_vulnerable_debuff"

				buff_extension:add_internally_controlled_buff(buff_name, t, "owner_unit", template_context.unit)
			end
		end
	end,
}
templates.psyker_smite_vulnerable_debuff = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	duration = talent_settings_2.coop_3.duration,
	stat_buffs = {
		[stat_buffs.non_warp_damage_taken_multiplier] = talent_settings_2.coop_3.damage_taken_multiplier,
	},
}
templates.psyker_block_costs_warp_charge = {
	always_show_in_hud = true,
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_2_tier_4_name_1",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	predicted = false,
	conditional_keywords = {
		keywords.block_gives_warp_charge,
	},
	conditional_stat_buffs = {
		[stat_buffs.warp_charge_block_cost] = talent_settings_2.defensive_1.warp_charge_cost_multiplier,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local warp_charge_component = unit_data_extension:read_component("warp_charge")

		template_data.warp_charge_component = warp_charge_component
	end,
	visual_stack_count = function (template_data, template_context)
		if ConditionalFunctions.is_blocking(template_data, template_context) then
			return 1
		end

		return 0
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		local current_percent = template_data.warp_charge_component.current_percentage
		local is_too_high = current_percent >= 0.97

		return not is_too_high
	end,
	duration_func = function (template_data, template_context)
		local current_percent = template_data.warp_charge_component.current_percentage
		local duration = 1 - math.clamp01(current_percent / 0.97)

		return duration
	end,
}
templates.psyker_warp_charge_reduces_toughness_damage_taken = {
	class_name = "buff",
	predicted = false,
	lerped_stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = {
			min = talent_settings_2.defensive_2.min_toughness_damage_multiplier,
			max = talent_settings_2.defensive_2.max_toughness_damage_multiplier,
		},
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local warp_charge_component = unit_data_extension:read_component("warp_charge")

		template_data.warp_charge_component = warp_charge_component
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local current_percent = template_data.warp_charge_component.current_percentage

		return current_percent
	end,
}
templates.psyker_venting_improvements = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_2_tier_4_name_3",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	stat_buffs = {
		[stat_buffs.vent_warp_charge_decrease_movement_reduction] = talent_settings_2.defensive_3.vent_warp_charge_decrease_movement_reduction,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = unit and ScriptUnit.has_extension(unit, "unit_data_system")

		template_data.weapon_action_component = unit_data_extension and unit_data_extension:read_component("weapon_action")
	end,
	check_active_func = function (template_data, template_context)
		local weapon_action_component = template_data.weapon_action_component
		local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
		local _, current_action_settings = Action.current_action(weapon_action_component, weapon_template)
		local current_action_kind = current_action_settings and current_action_settings.kind
		local is_venting = current_action_kind == "vent_warp_charge"

		return is_venting
	end,
}
templates.psyker_smite_on_hit = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_2_tier_5_name_3",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_blitz",
	hud_priority = 4,
	predicted = false,
	cooldown_duration = talent_settings_2.offensive_2_3.cooldown,
	proc_events = {
		[proc_events.on_hit] = talent_settings_2.offensive_2_3.smite_chance,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.next_allowed_t = 0
		template_data.fx_extension = ScriptUnit.extension(unit, "fx_system")
	end,
	update_func = function (template_data, template_context, dt, t)
		if not template_context.is_server then
			return
		end

		local smite_target = template_data.smite_target

		if not smite_target then
			return
		end

		if not HEALTH_ALIVE[smite_target] then
			template_data.smite_target = nil

			return
		end

		local critical_peril = 0.97
		local player_unit = template_context.unit
		local unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")
		local warp_charge_component = unit_data_extension and unit_data_extension:read_component("warp_charge")

		if not warp_charge_component or critical_peril < warp_charge_component.current_percentage then
			template_data.smite_target = nil

			return
		end

		local hit_unit_pos = POSITION_LOOKUP[smite_target]
		local player_pos = POSITION_LOOKUP[player_unit]
		local attack_direction = Vector3.normalize(hit_unit_pos - player_pos)

		if Vector3.length(attack_direction) == 0 then
			attack_direction = Vector3.up()
		end

		local damage_profile = DamageProfileTemplates.psyker_smite_kill
		local damage_type = damage_types.smite
		local hit_world_position = hit_unit_pos
		local attacked_unit_data_extension = ScriptUnit.has_extension(smite_target, "unit_data_system")
		local target_breed = attacked_unit_data_extension and attacked_unit_data_extension:breed()
		local hit_zone_name, hit_actor

		if target_breed then
			local hit_zone_weakspot_types = target_breed.hit_zone_weakspot_types
			local preferred_hit_zone_name = "head"
			local hit_zone = hit_zone_weakspot_types and (hit_zone_weakspot_types[preferred_hit_zone_name] and preferred_hit_zone_name or next(hit_zone_weakspot_types)) or hit_zone_names.center_mass
			local actors = HitZone.get_actor_names(smite_target, hit_zone)
			local hit_actor_name = actors and actors[1]

			hit_zone_name = hit_zone

			if hit_actor_name then
				hit_actor = Unit.actor(smite_target, hit_actor_name)

				local actor_node = Actor.node(hit_actor)

				hit_world_position = Unit.world_position(smite_target, actor_node)
			end
		end

		local damage_dealt, attack_result, damage_efficiency = Attack.execute(smite_target, damage_profile, "power_level", DEFAULT_POWER_LEVEL, "hit_world_position", hit_world_position, "hit_zone_name", hit_zone_name, "hit_actor", hit_actor, "attacking_unit", player_unit, "attack_direction", attack_direction, "attack_type", AttackSettings.attack_types.ranged, "damage_type", damage_type)

		ImpactEffect.play(smite_target, hit_actor, damage_dealt, damage_type, hit_zone_name, attack_result, hit_world_position, nil, attack_direction, player_unit, nil, nil, nil, damage_efficiency, damage_profile)

		template_data.smite_target = nil
	end,
	check_proc_func = function (params, template_data, template_context, t)
		local attack_type = params.attack_type

		if not attack_type then
			return false
		end

		local damage = params.damage

		if damage == 0 then
			return false
		end

		local attacked_unit = params.attacked_unit
		local unit_data_extension = ScriptUnit.has_extension(attacked_unit, "unit_data_system")

		if not unit_data_extension then
			return
		end

		local breed = unit_data_extension:breed()

		if not breed then
			return false
		end

		if not params.tags.elite and not params.tags.special and not params.tags.monster then
			return false
		end

		local is_prop = Breed.is_prop(breed)

		if is_prop then
			return false
		end

		local is_living_prop = Breed.is_living_prop(breed)

		if is_living_prop then
			return false
		end

		if not HEALTH_ALIVE[attacked_unit] then
			return false
		end

		return true
	end,
	proc_func = function (params, template_data, template_context, t)
		local attacked_unit = params.attacked_unit

		template_data.smite_target = attacked_unit
	end,
}
templates.psyker_soul_on_warpfire_kill = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_minion_death] = talent_settings_2.combat_ability_2.soul_chance,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local talent_extension = ScriptUnit.has_extension(unit, "talent_system")
		local has_psyker_increased_max_souls = talent_extension:has_special_rule(special_rules.psyker_increased_max_souls)

		template_data.buff_name = has_psyker_increased_max_souls and "psyker_souls_increased_max_stacks" or "psyker_souls"
		template_data.buff_extension = ScriptUnit.extension(unit, "buff_system")
		template_data.psyker_increased_soul_generation = talent_extension:has_special_rule(special_rules.psyker_increased_soul_generation)
	end,
	proc_func = function (params, template_data, template_context)
		local killed_unit = params.dying_unit
		local killed_unit_buff_extension = ScriptUnit.has_extension(killed_unit, "buff_system")
		local valid_target = killed_unit_buff_extension and (killed_unit_buff_extension:has_keyword(keywords.warpfire_burning) or killed_unit_buff_extension:had_keyword(keywords.warpfire_burning))

		if not valid_target then
			local own_unit = template_context.unit
			local attacking_unit = params.attacking_unit

			if own_unit == attacking_unit then
				local damage_type = params.damage_type

				valid_target = damage_type == damage_types.warpfire
			end
		end

		if valid_target then
			local buff_name = template_data.buff_name
			local buff_extension = template_data.buff_extension
			local t = FixedFrame.get_latest_fixed_time()
			local num_stacks = template_data.psyker_increased_soul_generation and talent_settings_2.combat_ability_1.stacks or 1

			buff_extension:add_internally_controlled_buff_with_stacks(buff_name, num_stacks, t)
		end
	end,
}
templates.psyker_biomancer_warpfire_debuff = {
	class_name = "interval_buff",
	duration = 15,
	interval = 0.75,
	max_stacks = 4,
	predicted = false,
	refresh_duration_on_stack = true,
	keywords = {
		keywords.burning,
		keywords.warpfire_burning,
	},
	interval_func = function (template_data, template_context, template)
		local unit = template_context.unit
		local stacks = template_context.stack_count

		if HEALTH_ALIVE[unit] then
			local damage_template = DamageProfileTemplates.warpfire
			local owner_unit = template_context.is_server and template_context.owner_unit or nil
			local damage_dealt, attack_result = Attack.execute(unit, damage_template, "power_level", 125 * stacks, "damage_type", damage_types.warpfire, "attacking_unit", owner_unit)
		end
	end,
	minion_effects = minion_burning_buff_effects.warpfire,
}
templates.psyker_increased_chain_lightning_size = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.chain_lightning_max_jumps] = talent_settings_3.offensive_1.chain_lightning_max_jumps,
		[stat_buffs.chain_lightning_max_radius] = talent_settings_3.offensive_1.chain_lightning_max_radius,
		[stat_buffs.chain_lightning_max_angle] = talent_settings_3.offensive_1.chain_lightning_max_angle,
	},
}
templates.psyker_kills_during_smite_tracking = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_chain_lightning_jump] = 1,
		[proc_events.on_chain_lightning_finish] = 1,
		[proc_events.on_minion_death] = 1,
	},
	specific_proc_func = {
		on_chain_lightning_jump = function (params, template_data, template_context)
			if not template_context.is_server then
				return
			end

			if ALIVE[params.attacked_unit] then
				local is_level_unit, unit_id_or_index = Managers.state.unit_spawner:game_object_id_or_level_index(params.attacked_unit)

				if not unit_id_or_index then
					return
				end

				if is_level_unit then
					template_data.afflicted_unit_level_index[unit_id_or_index] = true
				elseif not is_level_unit then
					template_data.afflicted_units_object_id[unit_id_or_index] = true
				end
			end
		end,
		on_chain_lightning_finish = function (params, template_data, template_context)
			if not template_context.is_server then
				return
			end

			local hook_name = "hook_chain_lightning_ability"
			local parent_buff_name = "psyker_grenade_chain_lightning"

			if template_data.afflicted_units_killed >= 1 then
				template_data.last_num_in_coherency, template_data.valid_buff_owners = template_data.coherency_extension:evaluate_and_send_achievement_data(template_data.last_num_in_coherency, template_data.valid_buff_owners, parent_buff_name, hook_name, template_data.afflicted_units_killed)
				template_data.afflicted_units_killed = 0
			end

			table.clear(template_data.afflicted_unit_level_index)
			table.clear(template_data.afflicted_units_object_id)
		end,
		on_minion_death = function (params, template_data, template_context)
			if not template_context.is_server then
				return
			end

			local killed_unit_id_or_index = params.dying_unit_id_or_level_index.unit_id

			if not killed_unit_id_or_index then
				return
			end

			local is_level_unit = params.dying_unit_id_or_level_index.is_level_unit

			if is_level_unit and template_data.afflicted_unit_level_index[killed_unit_id_or_index] then
				template_data.afflicted_units_killed = template_data.afflicted_units_killed + 1
			elseif not is_level_unit and template_data.afflicted_units_object_id[killed_unit_id_or_index] then
				template_data.afflicted_units_killed = template_data.afflicted_units_killed + 1
			end
		end,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.afflicted_units_object_id = {}
		template_data.afflicted_unit_level_index = {}
		template_data.afflicted_units_killed = 0
		template_data.last_num_in_coherency = 0
		template_data.valid_buff_owners = {}
		template_data.talent_extension = ScriptUnit.extension(unit, "talent_system")
		template_data.buff_extension = ScriptUnit.has_extension(unit, "buff_system")
		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
	end,
}

local empowered_chain_lightning_chance = talent_settings_3.passive_1.empowered_chain_lightning_chance
local max_stack = talent_settings_3.passive_1.max_stacks
local max_stack_talent = talent_settings_3.offensive_2.max_stacks_talent
local toughness_for_allies = talent_settings_3.spec_passive_1.toughness_for_allies

local function _on_empowered_ability_used(template_data, template_context)
	if template_data.charges < 1 then
		return
	end

	template_data.charges = template_data.charges - 1

	return true
end

local function _on_empowered_ability_gained(template_data, template_context)
	local max_stacks = template_data.increased_stacks and max_stack_talent or max_stack

	template_data.charges = math.clamp(template_data.charges + 1, 0, max_stacks)

	local buff_name = template_data.increased_stacks and "psyker_empowered_grenades_passive_visual_buff_increased" or "psyker_empowered_grenades_passive_visual_buff"
	local t = FixedFrame.get_latest_fixed_time()

	template_data.buff_extension:add_internally_controlled_buff(buff_name, t)
end

templates.psyker_empowered_grenades_passive = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = empowered_chain_lightning_chance,
		[proc_events.on_kill] = 1,
		[proc_events.on_chain_lightning_finish] = 1,
		[proc_events.on_chain_lightning_start] = 1,
		[proc_events.on_action_damage_target] = 1,
		[proc_events.on_shoot_projectile] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local talent_extension = ScriptUnit.extension(unit, "talent_system")

		template_data.increased_stacks = talent_extension:has_special_rule(special_rules.psyker_empowered_grenades_increased_max_stacks)
		template_data.toughness_on_attack = talent_extension:has_special_rule(special_rules.psyker_empowered_grenades_toughness_on_attack)
		template_data.stack_on_elite_kills = talent_extension:has_special_rule(special_rules.psyker_empowered_grenades_stack_on_elite_kills)
		template_data.buff_extension = ScriptUnit.extension(unit, "buff_system")
		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.fx_extension = ScriptUnit.extension(unit, "fx_system")

		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.warp_charge_component = unit_data_extension:write_component("warp_charge")
		template_data.charges = 0
	end,
	specific_proc_func = {
		on_shoot_projectile = function (params, template_data, template_context)
			if not params.projectile_template_name then
				return
			end

			local projectile_template = ProjectileTemplates[params.projectile_template_name]

			if not projectile_template.psyker_smite then
				return
			end

			local used = _on_empowered_ability_used(template_data, template_context)

			if not used then
				return
			end

			if template_data.toughness_on_attack then
				local coherency_extension = template_data.coherency_extension
				local units_in_coherence = coherency_extension:in_coherence_units()

				for coherency_unit, _ in pairs(units_in_coherence) do
					Toughness.replenish_percentage(coherency_unit, toughness_for_allies)
				end
			end
		end,
		on_action_damage_target = function (params, template_data, template_context)
			if params.damage_type ~= "smite" then
				return
			end

			local used = _on_empowered_ability_used(template_data, template_context)

			if not used then
				return
			end

			if template_data.toughness_on_attack then
				local coherency_extension = template_data.coherency_extension
				local units_in_coherence = coherency_extension:in_coherence_units()

				for coherency_unit, _ in pairs(units_in_coherence) do
					Toughness.replenish_percentage(coherency_unit, toughness_for_allies)
				end
			end
		end,
		on_kill = function (params, template_data, template_context)
			if not template_data.stack_on_elite_kills then
				return
			end

			if not params.tags or not params.tags.elite then
				return
			end

			_on_empowered_ability_gained(template_data, template_context)
		end,
		on_hit = function (params, template_data, template_context)
			if not CheckProcFunctions.on_kill(params) then
				return
			end

			if template_data.stack_on_elite_kills and params.tags and params.tags.elite then
				return
			end

			_on_empowered_ability_gained(template_data, template_context)
		end,
		on_chain_lightning_finish = function (params, template_data, template_context)
			_on_empowered_ability_used(template_data, template_context)
		end,
		on_chain_lightning_start = function (params, template_data, template_context)
			if template_data.charges < 1 then
				return
			end

			if template_data.toughness_on_attack then
				local coherency_extension = template_data.coherency_extension
				local units_in_coherence = coherency_extension:in_coherence_units()

				for coherency_unit, _ in pairs(units_in_coherence) do
					Toughness.replenish_percentage(coherency_unit, toughness_for_allies)
				end
			end
		end,
	},
}
templates.psyker_empowered_grenades_passive_improved = table.clone(templates.psyker_empowered_grenades_passive)
templates.psyker_empowered_grenades_passive_improved.proc_events[proc_events.on_hit] = talent_settings_3.spec_passive_2.empowered_chain_lightning_chance
templates.psyker_empowered_grenades_passive_visual_buff = {
	always_show_in_hud = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_keystone_empowered_psyche",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 1,
	max_stat_stacks = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_shoot_projectile] = 1,
		[proc_events.on_kill] = 1,
		[proc_events.on_action_damage_target] = 1,
		[proc_events.on_chain_lightning_start] = 1,
		[proc_events.on_chain_lightning_finish] = 1,
	},
	stat_buffs = {
		[stat_buffs.chain_lightning_damage] = talent_settings_3.passive_1.chain_lightning_damage,
		[stat_buffs.chain_lightning_jump_time_multiplier] = 0.5,
		[stat_buffs.psyker_smite_cost_multiplier] = talent_settings_3.passive_1.psyker_smite_cost_multiplier,
		[stat_buffs.smite_attack_speed] = 0.5,
		[stat_buffs.smite_damage] = 0.5,
	},
	keywords = {
		keywords.psyker_empowered_grenade,
	},
	visual_stack_count = function (template_data, template_context)
		return math.min(template_context.stack_count, template_data.max_stacks)
	end,
	max_stacks = max_stack + 1,
	max_stacks_cap = max_stack + 1,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local talent_extension = ScriptUnit.extension(unit, "talent_system")
		local increased_stacks = talent_extension:has_special_rule(special_rules.psyker_empowered_grenades_increased_max_stacks)

		template_data.max_stacks = increased_stacks and max_stack_talent or max_stack

		local fx_extension = ScriptUnit.extension(template_context.unit, "fx_system")

		template_data.fx_extension = fx_extension

		local screenspace_effect = "content/fx/particles/screenspace/screen_psyker_protectorate_passive_add_stack"

		fx_extension:spawn_exclusive_particle(screenspace_effect, Vector3(0, 0, 1))
	end,
	on_stack_added_func = function (template_data, template_context, t)
		local screenspace_effect = "content/fx/particles/screenspace/screen_psyker_protectorate_passive_add_stack"

		template_data.fx_extension:spawn_exclusive_particle(screenspace_effect, Vector3(0, 0, 1))
	end,
	specific_proc_func = {
		on_shoot_projectile = function (params, template_data, template_context)
			if not params.projectile_template_name then
				return
			end

			local projectile_template = ProjectileTemplates[params.projectile_template_name]

			if not projectile_template.psyker_smite then
				return
			end

			template_data.finish = true
		end,
		on_action_damage_target = function (params, template_data, template_context)
			if params.damage_type ~= "smite" then
				return
			end

			template_data.finish = true
		end,
		on_chain_lightning_start = function (params, template_data, template_context)
			template_data.can_finish = true
		end,
		on_chain_lightning_finish = function (params, template_data, template_context)
			if template_data.can_finish then
				template_data.finish = true
				template_data.can_finish = false
			end
		end,
		on_kill = function (params, template_data, template_context)
			if params.damage_type == "smite" or params.damage_type == "throwing_knife" or params.damage_type == "electrocution" then
				Managers.stats:record_private("hook_psyker_empowered_ability", template_context.player, params)
			end
		end,
	},
	conditional_stack_exit_func = function (template_data, template_context)
		if template_data.finish or template_context.stack_count > template_data.max_stacks then
			template_data.finish = false

			return true
		end
	end,
	player_effects = {
		on_screen_effect = "content/fx/particles/screenspace/screen_psyker_protectorate_passive",
	},
}
templates.psyker_empowered_grenades_passive_visual_buff_increased = table.clone(templates.psyker_empowered_grenades_passive_visual_buff)
templates.psyker_empowered_grenades_passive_visual_buff_increased.max_stacks = max_stack_talent + 1
templates.psyker_empowered_grenades_passive_visual_buff_increased.max_stacks_cap = max_stack_talent + 1
templates.psyker_shield_stun_passive = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_unit_touch_force_field] = 1,
	},
	start_func = function (template_data, template_context)
		return
	end,
	proc_func = function (params, template_data, template_context)
		local force_field_owner_unit = params.force_field_owner_unit

		if force_field_owner_unit ~= template_context.unit then
			return
		end

		local unit = params.passing_unit
		local breed = Breed.unit_breed_or_nil(unit)
		local breed_tags = breed and breed.tags
		local is_monster = breed_tags and breed_tags.monster
		local is_special = breed_tags and breed_tags.special
		local special_chance = talent_settings_3.offensive_3.special_proc_chance
		local chance = talent_settings_3.offensive_3.proc_chance
		local random = math.random()
		local do_stun = (is_special or is_monster) and random <= special_chance or random <= chance

		if do_stun then
			local force_field_extension = ScriptUnit.extension(params.force_field_unit, "force_field_system")
			local force_field_health_extension = ScriptUnit.extension(params.force_field_unit, "health_system")
			local direction = Quaternion.forward(Unit.local_rotation(unit, 1))
			local reflected_direction = force_field_extension:reflected_direction(unit, direction)

			if is_special then
				force_field_health_extension:add_damage(8, nil, nil, nil, nil, nil, nil, nil)
			end

			local damage_profile = DamageProfileTemplates.psyker_shield_stagger
			local damage_dealt, attack_result = Attack.execute(unit, damage_profile, "power_level", DEFAULT_POWER_LEVEL, "attack_direction", reflected_direction, "attacking_unit", force_field_owner_unit, "attack_type", attack_types.push, "damage_type", damage_types.electrocution)
			local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

			if buff_extension then
				local t = FixedFrame.get_latest_fixed_time()

				buff_extension:add_internally_controlled_buff("psyker_stun_effect", t, "owner_unit", template_context.unit)
			end
		end
	end,
}

local shield_toughness_ally = talent_settings_3.combat_ability.toughness_for_allies

templates.psyker_boost_allies_in_sphere_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_3_tier_4_name_1",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	predicted = false,
	buff_category = buff_categories.talents_secondary,
	update_func = function (template_data, template_context, dt, t)
		Toughness.replenish_percentage(template_context.unit, shield_toughness_ally * dt, false, "psyker_sphere")
	end,
}
templates.psyker_boost_allies_in_sphere_end_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_3_tier_4_name_1",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	predicted = false,
	buff_category = buff_categories.talents_secondary,
	duration = talent_settings_3.combat_ability.toughness_duration,
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = talent_settings_3.combat_ability.toughness_damage_reduction,
	},
}
templates.psyker_boost_allies_passing_through_force_field = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_unit_touch_force_field] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.force_fields_used = {}
	end,
	proc_func = function (params, template_data, template_context)
		local force_field_owner_unit = params.force_field_owner_unit

		if force_field_owner_unit ~= template_context.unit then
			return
		end

		if not params.is_player_unit then
			return
		end

		local unit = params.passing_unit
		local force_field_unit = params.force_field_unit

		if not template_data.force_fields_used[force_field_unit] then
			template_data.force_fields_used[force_field_unit] = {}
		elseif template_data.force_fields_used[force_field_unit][unit] then
			return
		end

		local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

		if buff_extension then
			local t = FixedFrame.get_latest_fixed_time()

			buff_extension:add_internally_controlled_buff("psyker_force_field_buff", t)

			template_data.force_fields_used[force_field_unit][unit] = true
		end
	end,
}
templates.psyker_force_field_buff = {
	class_name = "buff",
	predicted = true,
	refresh_duration_on_stack = true,
	buff_category = buff_categories.talents_secondary,
	duration = talent_settings_3.defensive_1.duration,
	max_stacks = talent_settings_3.defensive_1.max_stacks,
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = talent_settings_3.defensive_1.toughness_damage_taken_multiplier,
		[stat_buffs.movement_speed] = talent_settings_3.defensive_1.movement_speed,
	},
	player_effects = {
		on_screen_effect = "content/fx/particles/screenspace/screen_psyker_protectorate_shield_buff",
	},
}

local distance = talent_settings_3.coop_3.distance
local valid_distance_sq = distance * distance
local toughness_percentage = talent_settings_3.coop_3.toughness_percentage

templates.psyker_toughness_regen_at_shield = {
	class_name = "interval_buff",
	interval = 1,
	predicted = false,
	start_func = function (template_data, template_context)
		local side_system = Managers.state.extension:system("side_system")

		template_data.side = side_system.side_by_unit[template_context.unit]
		template_data.force_field_system = Managers.state.extension:system("force_field_system")
	end,
	interval_func = function (template_data, template_context)
		local unit = template_context.unit
		local extensions = template_data.force_field_system:get_extensions_by_owner_unit(unit)

		if #extensions > 0 then
			local valid_player_units = template_data.side.valid_player_units

			for i = 1, #valid_player_units do
				local player_unit = valid_player_units[i]

				for _, extension in pairs(extensions) do
					local force_field_unit = extension:force_field_unit()
					local force_field_pos = Unit.local_position(force_field_unit, 1)
					local player_unit_pos = POSITION_LOOKUP[player_unit]
					local distance_sq = Vector3.distance_squared(force_field_pos, player_unit_pos)

					if distance_sq < valid_distance_sq then
						Toughness.replenish_percentage(player_unit, toughness_percentage)
					end
				end
			end
		end
	end,
}
templates.psyker_aura_ability_cooldown = {
	class_name = "buff",
	coherency_id = "psyker_protectorate_coherency_aura",
	coherency_priority = 2,
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_aura_cooldown_regen",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 5,
	predicted = false,
	buff_category = buff_categories.aura,
	max_stacks = talent_settings_3.coherency.max_stacks,
	keywords = {},
	stat_buffs = {
		[stat_buffs.ability_cooldown_modifier] = talent_settings_3.coherency.ability_cooldown_modifier,
	},
	start_func = _penance_start_func("psyker_cooldown_reduction_aura_tracking_buff"),
}
templates.psyker_cooldown_reduction_aura_tracking_buff = {
	class_name = "proc_buff",
	predicted = false,
	unique_buff_id = "psyker_cooldown_reduction_aura_tracking_buff",
	proc_events = {
		[proc_events.on_combat_ability] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.ability_extension = ScriptUnit.extension(unit, "ability_system")
		template_data.last_num_in_coherency = 0
		template_data.valid_buff_owners = {}
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local modified_cooldown_time = template_data.ability_extension:get_current_ability_cooldown_time()
		local default_cooldown_time = modified_cooldown_time / (talent_settings_3.coherency.ability_cooldown_modifier * -1 * 100 - 100) * 100 * -1
		local saved_time = default_cooldown_time * talent_settings_3.coherency.ability_cooldown_modifier * -1
		local hook_name = "hook_psyker_team_cooldown_recovery_aura"
		local parent_buff_name = "psyker_aura_ability_cooldown"

		template_data.last_num_in_coherency, template_data.valid_buff_owners = template_data.coherency_extension:evaluate_and_send_achievement_data(template_data.last_num_in_coherency, template_data.valid_buff_owners, parent_buff_name, hook_name, saved_time)
	end,
}
templates.psyker_aura_ability_cooldown_improved = {
	class_name = "buff",
	coherency_id = "psyker_protectorate_coherency_aura_improved",
	coherency_priority = 1,
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_aura_seers_presence",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 5,
	predicted = false,
	buff_category = buff_categories.aura,
	max_stacks = talent_settings_3.coop_2.max_stacks,
	keywords = {},
	stat_buffs = {
		[stat_buffs.ability_cooldown_modifier] = talent_settings_3.coherency.ability_cooldown_modifier_improved,
	},
	start_func = _penance_start_func("psyker_improved_cooldown_reduction_aura_tracking_buff"),
}
templates.psyker_improved_cooldown_reduction_aura_tracking_buff = {
	class_name = "proc_buff",
	predicted = false,
	unique_buff_id = "psyker_improved_cooldown_reduction_aura_tracking_buff",
	proc_events = {
		[proc_events.on_combat_ability] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.ability_extension = ScriptUnit.extension(unit, "ability_system")
		template_data.last_num_in_coherency = 0
		template_data.valid_buff_owners = {}
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local modified_cooldown_time = template_data.ability_extension:get_current_ability_cooldown_time()
		local default_cooldown_time = modified_cooldown_time / (talent_settings_3.coherency.ability_cooldown_modifier_improved * -1 * 100 - 100) * 100 * -1
		local saved_time = default_cooldown_time * talent_settings_3.coherency.ability_cooldown_modifier_improved * -1
		local hook_name = "hook_psyker_team_cooldown_recovery_aura"
		local parent_buff_name = "psyker_cooldown_aura_improved"

		template_data.last_num_in_coherency, template_data.valid_buff_owners = template_data.coherency_extension:evaluate_and_send_achievement_data(template_data.last_num_in_coherency, template_data.valid_buff_owners, parent_buff_name, hook_name, saved_time)
	end,
}
templates.psyker_stun_effect = {
	class_name = "interval_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	start_interval_on_apply = true,
	keywords = {
		keywords.electrocuted,
	},
	interval = talent_settings_3.grenade.stun_interval,
	duration = talent_settings_3.grenade.duration,
	interval_func = function (template_data, template_context, template)
		local is_server = template_context.is_server

		if not is_server then
			return
		end

		local unit = template_context.unit

		if HEALTH_ALIVE[unit] then
			local damage_template = DamageProfileTemplates.psyker_stun
			local owner_unit = template_context.owner_unit
			local attack_direction
			local target_position = POSITION_LOOKUP[unit]
			local owner_position = owner_unit and POSITION_LOOKUP[owner_unit]

			if owner_position and target_position then
				attack_direction = Vector3.normalize(target_position - owner_position)
			end

			Attack.execute(unit, damage_template, "power_level", DEFAULT_POWER_LEVEL, "attacking_unit", HEALTH_ALIVE[owner_unit] and owner_unit, "attack_direction", attack_direction)
		end
	end,
	minion_effects = {
		ailment_effect = ailment_effects.electrocution,
		node_effects = {
			{
				node_name = "j_spine",
				vfx = {
					material_emission = true,
					orphaned_policy = "destroy",
					particle_effect = "content/fx/particles/enemies/buff_chainlightning",
					stop_type = "stop",
				},
				sfx = {
					looping_wwise_start_event = "wwise/events/weapon/play_psyker_chain_lightning_hit",
					looping_wwise_stop_event = "wwise/events/weapon/stop_psyker_chain_lightning_hit",
				},
			},
		},
	},
}
templates.psyker_throwing_knives_piercing = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.psyker_smite_max_hit_mass_attack_modifier] = 0.5,
		[stat_buffs.psyker_smite_max_hit_mass_impact_modifier] = 0.5,
	},
}
templates.psyker_throwing_knives_ability_recharge = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_combat_ability] = 1,
	},
	proc_func = function (params, template_data, template_context, t)
		local ability_extension = ScriptUnit.has_extension(template_context.unit, "ability_system")

		if ability_extension then
			local charges = talent_settings.throwing_knives.charges_restored

			ability_extension:restore_ability_charge("grenade_ability", charges)
		end
	end,
}
templates.psyker_throwing_knife_stacking_speed = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_shoot_projectile] = 1,
	},
	proc_func = function (params, template_data, template_context, t)
		template_context.buff_extension:add_internally_controlled_buff("psyker_throwing_knife_stacking_speed_buff", t)
	end,
}
templates.psyker_throwing_knife_stacking_speed_buff = {
	class_name = "buff",
	duration = 8,
	max_stacks = 5,
	predicted = false,
	refresh_duration_on_stack = true,
	stat_buffs = {
		[stat_buffs.psyker_throwing_knife_speed_modifier] = 0.05,
	},
}
templates.psyker_increased_vent_speed = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.vent_warp_charge_speed] = talent_settings_3.mixed_3.vent_warp_charge_speed,
	},
}
templates.psyker_kills_stack_other_weapon_damage = {
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	proc_func = function (params, template_data, template_context, t)
		local damage_type = params.damage_type

		if not warp_damage_types[damage_type] then
			local buff_name = "psyker_cycle_stacking_warp_damage"

			template_context.buff_extension:add_internally_controlled_buff(buff_name, t)
		end

		if warp_damage_types[damage_type] then
			local buff_name = "psyker_cycle_stacking_non_warp_damage"

			template_context.buff_extension:add_internally_controlled_buff(buff_name, t)
		end
	end,
}
templates.psyker_cycle_stacking_warp_damage = {
	class_name = "buff",
	duration = 8,
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_1_tier_2_name_2",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 5,
	max_stacks = 5,
	predicted = false,
	refresh_duration_on_stack = true,
	stat_buffs = {
		[stat_buffs.warp_damage] = 0.04,
	},
}
templates.psyker_cycle_stacking_non_warp_damage = {
	class_name = "buff",
	duration = 8,
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_1_tier_2_name_2",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 5,
	max_stacks = 5,
	predicted = false,
	refresh_duration_on_stack = true,
	stat_buffs = {
		[stat_buffs.damage] = 0.04,
		[stat_buffs.warp_damage] = -0.04,
	},
}
templates.psyker_cycle_stacking_melee_damage_stacks = {
	class_name = "proc_buff",
	max_stacks = 4,
	stat_buffs = {
		[stat_buffs.melee_damage] = 0.05,
	},
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	proc_func = function (params, template_data, template_context)
		local attack_type = params.attack_type

		if attack_type == attack_types.melee then
			template_data.finish = true
		end
	end,
	conditional_exit_func = function (template_data, template_context)
		return template_data.finish
	end,
}
templates.psyker_cycle_stacking_ranged_damage_stacks = {
	class_name = "proc_buff",
	max_stacks = 4,
	stat_buffs = {
		[stat_buffs.ranged_damage] = 0.05,
	},
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	proc_func = function (params, template_data, template_context)
		local attack_type = params.attack_type

		if attack_type == attack_types.ranged then
			template_data.finish = true
		end
	end,
	conditional_exit_func = function (template_data, template_context)
		return template_data.finish
	end,
}
templates.psyker_crits_empower_warp = {
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_crit,
	proc_func = function (params, template_data, template_context, t)
		template_context.buff_extension:add_internally_controlled_buff("psyker_crits_empower_warp_buff", t)
	end,
}
templates.psyker_crits_empower_warp_buff = {
	always_show_in_hud = true,
	class_name = "buff",
	duration = 10,
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_1_tier_2_name_3",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	max_stacks = 5,
	predicted = false,
	refresh_duration_on_stack = true,
	stat_buffs = {
		[stat_buffs.warp_damage] = 0.03,
	},
}
templates.psyker_dodge_after_crits = {
	active_duration = 1,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_1_tier_4_name_1",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	proc_keywords = {
		keywords.count_as_dodge_vs_ranged,
	},
	check_proc_func = CheckProcFunctions.on_crit,
}
templates.psyker_crits_regen_toughness_movement_speed = {
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	talent_overrides = {
		{
			toughness_percentage = 0.05,
		},
		{
			toughness_percentage = 0.1,
		},
		{
			toughness_percentage = 0.15,
		},
	},
	check_proc_func = CheckProcFunctions.on_crit,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.buff_extension = ScriptUnit.extension(unit, "buff_system")
	end,
	proc_func = function (params, template_data, template_context)
		local is_first_target = params and params.target_number == 1

		if not is_first_target then
			return
		end

		local unit = template_context.unit
		local template_override_data = template_context.template_override_data
		local toughness_percentage_to_replenish = template_override_data.toughness_percentage

		Toughness.replenish_percentage(unit, toughness_percentage_to_replenish, false, "psyker_crits_regen_toughness_movement_speed")

		local buff_to_add = "psyker_stacking_movement_buff"
		local buff_extension = ScriptUnit.extension(unit, "buff_system")
		local t = FixedFrame.get_latest_fixed_time()

		buff_extension:add_internally_controlled_buff(buff_to_add, t)
	end,
}
templates.psyker_stacking_movement_buff = {
	class_name = "buff",
	duration = 4,
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_1_tier_4_name_2",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 3,
	max_stacks = 3,
	predicted = true,
	refresh_duration_on_stack = true,
	stat_buffs = {
		[stat_buffs.movement_speed] = 0.05,
	},
}
templates.psyker_improved_dodge = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.dodge_linger_time_modifier] = 0.5,
		[stat_buffs.extra_consecutive_dodges] = 1,
	},
}
templates.psyker_guaranteed_crit_on_multiple_weakspot_hits = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_weakspot_hit,
	proc_func = function (params, template_data, template_context, t)
		local no_damage = params and params.damage <= 0

		if no_damage then
			return
		end

		if params.attack_instigator_unit and params.attack_instigator_unit ~= params.attacking_unit then
			if params.attack_instigator_unit == template_data.attack_instigator_unit then
				return
			else
				template_data.attack_instigator_unit = params.attack_instigator_unit
			end
		elseif params.target_index and params.target_index > 1 then
			return
		end

		template_context.buff_extension:add_internally_controlled_buff("psyker_guaranteed_ranged_shot_on_stacked", t)
	end,
}

local weakspot_crit_stacks = 5

templates.psyker_guaranteed_ranged_shot_on_stacked = {
	always_show_in_hud = true,
	class_name = "proc_buff",
	hud_always_show_stacks = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_1_tier_2_name_1",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	max_stacks = weakspot_crit_stacks,
	proc_events = {
		[proc_events.on_critical_strike] = 1,
	},
	conditional_keywords = {
		keywords.guaranteed_ranged_critical_strike,
	},
	on_stack_added_func = function (template_data, template_context)
		template_data.active = template_context.stack_count >= weakspot_crit_stacks
	end,
	proc_func = function (params, template_data, template_context)
		local attack_type = params.attack_type
		local is_ranged_attack = attack_type == AttackSettings.attack_types.ranged

		if is_ranged_attack and template_data.active then
			template_data.finish = true
		end
	end,
	conditional_exit_func = function (template_data, template_context)
		return template_data.finish
	end,
	conditional_keywords_func = function (template_data, template_context)
		return template_data.active
	end,
}
templates.psyker_aura_toughness_on_ally_knocked_down = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_ally_knocked_down] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.coherency_extension = ScriptUnit.has_extension(unit, "coherency_system")
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local toughness_percent = talent_settings_3.coop_1.toughness_percent
		local units_in_coherence = template_data.coherency_extension:in_coherence_units()

		for coherency_unit, _ in pairs(units_in_coherence) do
			Toughness.replenish_percentage(coherency_unit, toughness_percent)
		end
	end,
}
templates.psyker_chain_lightning_increases_movement_speed = {
	class_name = "proc_buff",
	predicted = true,
	proc_events = {
		[proc_events.on_chain_lightning_start] = talent_settings_3.defensive_3.on_chain_lighting_start_proc_chance,
	},
	proc_stat_buffs = {
		[stat_buffs.movement_speed] = talent_settings_3.defensive_3.movement_speed,
	},
	active_duration = talent_settings_3.defensive_3.active_duration,
}
templates.psyker_melee_attack_speed = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.melee_attack_speed] = talent_settings.melee_attack_speed.attack_speed,
	},
}
templates.psyker_cleave_from_peril = {
	class_name = "buff",
	predicted = false,
	lerped_stat_buffs = {
		[stat_buffs.max_hit_mass_attack_modifier] = {
			min = talent_settings.cleave_from_peril.min,
			max = talent_settings.cleave_from_peril.max,
		},
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.warp_charge_component = unit_data_extension:read_component("warp_charge")
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local current_percent = template_data.warp_charge_component.current_percentage

		return current_percent
	end,
}
templates.psyker_melee_weaving = {
	active_duration = 4,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_blocking_soulblaze",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.warp_charge_amount] = 0.8,
	},
	check_proc_func = CheckProcFunctions.on_melee_weakspot_kills,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local warp_charge_component = unit_data_extension:write_component("warp_charge")

		template_data.warp_charge_component = warp_charge_component
		template_data.procced = false
	end,
	proc_func = function (params, template_data, template_context, t)
		template_data.procced = true
	end,
	update_func = function (template_data, template_context, dt, t)
		if template_data.procced then
			local warp_charge_component = template_data.warp_charge_component
			local remove_percentage = 0.05
			local unit = template_context.unit

			WarpCharge.decrease_immediate(remove_percentage, warp_charge_component, unit)

			template_data.procced = false
		end
	end,
}

local soublaze_dr_max_stacks = talent_settings.nearby_soublaze_defense.max_stacks

templates.psyker_nearby_soulblaze_reduced_damage = {
	always_show_in_hud = true,
	class_name = "buff",
	hud_always_show_stacks = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_nearby_soulblaze_reduced_damage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	lerped_stat_buffs = {
		[stat_buffs.melee_critical_strike_chance] = {
			min = talent_settings.nearby_soublaze_defense.critical_min,
			max = talent_settings.nearby_soublaze_defense.critical_max,
		},
	},
	start_func = function (template_data, template_context)
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase

		template_data.broadphase = broadphase
		template_data.broadphase_results = {}
		template_data.num_stacks = 0

		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")
		local t = FixedFrame.get_latest_fixed_time()

		template_data.next_soulblaze_check = t + 0.25
		template_data.enemy_side_names = enemy_side_names
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local next_soulblaze_check = template_data.next_soulblaze_check

		if next_soulblaze_check < t then
			local player_unit = template_context.unit
			local player_position = POSITION_LOOKUP[player_unit]
			local broadphase = template_data.broadphase
			local enemy_side_names = template_data.enemy_side_names
			local broadphase_results = template_data.broadphase_results

			table.clear(broadphase_results)

			local num_stacks = 0
			local num_hits = broadphase.query(broadphase, player_position, soulblaze_range, broadphase_results, enemy_side_names)

			for i = 1, num_hits do
				local enemy_unit = broadphase_results[i]
				local buff_extension = ScriptUnit.has_extension(enemy_unit, "buff_system")

				if buff_extension then
					local target_is_bleeding = buff_extension:has_keyword(keywords.warpfire_burning)

					if target_is_bleeding then
						num_stacks = num_stacks + 1
					end
				end
			end

			template_data.num_stacks = num_stacks
			template_data.next_soulblaze_check = t + 1
		end

		return math.clamp(template_data.num_stacks / soublaze_dr_max_stacks, 0, 1)
	end,
	visual_stack_count = function (template_data, template_context)
		return math.clamp(template_data.num_stacks, 0, soublaze_dr_max_stacks)
	end,
}
templates.psyker_killing_enemy_with_warpfire_boosts = {
	class_name = "proc_buff",
	predicted = false,
	toughness_percentage = 0.05,
	proc_events = {
		[proc_events.on_minion_death] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.buff_name = "psyker_killing_enemy_with_warpfire_boosts_boost_buff"
	end,
	proc_func = function (params, template_data, template_context, t)
		local killed_unit = params.dying_unit
		local killed_unit_buff_extension = ScriptUnit.has_extension(killed_unit, "buff_system")
		local valid_target = killed_unit_buff_extension and (killed_unit_buff_extension:has_keyword(keywords.warpfire_burning) or killed_unit_buff_extension:had_keyword(keywords.warpfire_burning))

		if not valid_target then
			local own_unit = template_context.unit
			local attacking_unit = params.attacking_unit

			if own_unit == attacking_unit then
				local damage_type = params.damage_type

				valid_target = damage_type == damage_types.warpfire
			end
		end

		if valid_target then
			local buff_name = template_data.buff_name

			template_context.buff_extension:add_internally_controlled_buff(buff_name, t)

			local template = template_context.template

			Toughness.replenish_percentage(template_context.unit, template.toughness_percentage)
		end
	end,
}
templates.psyker_killing_enemy_with_warpfire_boosts_boost_buff = {
	class_name = "buff",
	duration = 5,
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_nearby_soulblaze_reduced_damage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	max_stacks = 1,
	predicted = false,
	stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.05,
	},
}
templates.psyker_warp_glass_cannon = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.warp_charge_amount] = talent_settings.glass_cannon.warp_charge_amount,
		[stat_buffs.toughness_replenish_multiplier] = talent_settings.glass_cannon.toughness_replenish_multiplier,
	},
}
templates.psyker_warp_attacks_rending = {
	always_show_in_hud = true,
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_warp_attacks_rending",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.warp_attacks_rending_multiplier] = talent_settings.warp_attacks_rending.warp_rending,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.warp_charge_component.current_percentage >= talent_settings.warp_attacks_rending.threshold
	end,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local warp_charge_component = unit_data_extension:write_component("warp_charge")

		template_data.warp_charge_component = warp_charge_component
		template_data.inventory_slot_secondary_component = unit_data_extension:read_component("slot_secondary")
	end,
}
templates.psyker_soulblaze_reduces_damage_taken = {
	active_duration = 3,
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_soulblaze_reduces_damage_taken",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	proc_events = {
		[proc_events.on_warp_fire_applied] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = talent_settings.soulblaze_reduces_damage_taken.toughness_damage_taken_multiplier,
	},
	check_proc_func = function (params, template_data, template_context)
		return params.buffer_unit == template_context.unit
	end,
}
templates.psyker_ranged_crits_vent = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = talent_settings.ranged_crits_vent.proc_chance,
	},
	check_proc_func = function (params, template_data, template_context)
		if not params.is_critical_strike then
			return false
		end

		local damage_type = params.damage_type

		if warp_damage_types[damage_type] then
			return false
		end

		return params.attack_type == attack_types.ranged
	end,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local warp_charge_component = unit_data_extension:write_component("warp_charge")

		template_data.warp_charge_component = warp_charge_component
		template_data.counter = 0
	end,
	proc_func = function (params, template_data, template_context)
		template_data.procced = true
	end,
	update_func = function (template_data, template_context, dt, t)
		if template_data.procced then
			local warp_charge_component = template_data.warp_charge_component
			local remove_percentage = talent_settings.ranged_crits_vent.warp_charge_percent
			local unit = template_context.unit

			WarpCharge.decrease_immediate(remove_percentage, warp_charge_component, unit)

			template_data.procced = false
		end
	end,
}
templates.psyker_reload_speed_warp = {
	always_show_in_hud = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_ranged_shots_soulblaze",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	predicted = false,
	proc_events = {
		[proc_events.on_reload] = 1,
		[proc_events.on_reload_start] = 1,
	},
	conditional_stat_buffs = {
		[stat_buffs.reload_speed] = talent_settings.reload_speed_warp.reload_speed,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.warp_charge_component.current_percentage <= talent_settings.reload_speed_warp.threshold
	end,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local warp_charge_component = unit_data_extension:write_component("warp_charge")

		template_data.warp_charge_component = warp_charge_component
		template_data.inventory_slot_secondary_component = unit_data_extension:read_component("slot_secondary")
	end,
	specific_proc_func = {
		on_reload_start = function (params, template_data, template_context, t)
			local inventory_slot_secondary_component = template_data.inventory_slot_secondary_component
			local current_ammo_in_clip = inventory_slot_secondary_component.current_ammunition_clip

			template_data.current_ammo = current_ammo_in_clip
		end,
		on_reload = function (params, template_data, template_context, t)
			local inventory_slot_secondary_component = template_data.inventory_slot_secondary_component
			local current_ammo_in_clip = inventory_slot_secondary_component.current_ammunition_clip
			local ammo_refilled = current_ammo_in_clip - template_data.current_ammo

			if ammo_refilled <= 0 then
				return
			end

			local max_ammo_in_clip = inventory_slot_secondary_component.max_ammunition_clip
			local refilled_percent = ammo_refilled / max_ammo_in_clip
			local warp_charge_component = template_data.warp_charge_component
			local increase_percentage = talent_settings.reload_speed_warp.warp_charge
			local unit = template_context.unit
			local charge_template = WeaponChargeTemplates.psyker_reload_speed_warp

			WarpCharge.increase_immediate(t, increase_percentage, warp_charge_component, charge_template, unit, refilled_percent, true)
		end,
	},
}
templates.psyker_chain_lightning_heavy_attacks = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_heavy_hit,
	proc_func = function (params, template_data, template_context, t)
		local buff_ext = ScriptUnit.has_extension(params.attacked_unit, "buff_system")

		if buff_ext then
			local talent_extension = ScriptUnit.has_extension(template_context.unit, "talent_system")
			local improved_target_buff = talent_extension and talent_extension:has_special_rule(special_rules.psyker_chain_lightning_improved_target_buff)
			local buff_name = improved_target_buff and "psyker_heavy_swings_shock_improved" or "psyker_heavy_swings_shock"

			buff_ext:add_internally_controlled_buff(buff_name, t)
		end
	end,
}
templates.psyker_force_staff_quick_attack_bonus = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = function (params, template_data, template_context)
		return params.damage_type == damage_types.force_staff_single_target
	end,
	proc_func = function (params, template_data, template_context, t)
		local attacked_unit = params.attacked_unit
		local buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")

		if buff_extension then
			buff_extension:add_internally_controlled_buff("psyker_force_staff_quick_attack_debuff", t)
		end
	end,
}
templates.psyker_force_staff_quick_attack_debuff = {
	class_name = "buff",
	duration = 10,
	max_stacks = 5,
	predicted = false,
	refresh_duration_on_stack = true,
	stat_buffs = {
		[stat_buffs.warp_damage_taken_multiplier] = 1.06,
	},
}
templates.psyker_force_staff_melee_attack_bonus = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_sweep_finish] = 1,
	},
	check_proc_func = function (params, template_data, template_context)
		local wielded_slot = template_data.inventory_component.wielded_slot

		return wielded_slot == "slot_secondary"
	end,
	lerped_stat_buffs = {
		[stat_buffs.force_staff_melee_damage] = {
			min = talent_settings.psyker_force_staff_melee_attack_bonus.min,
			max = talent_settings.psyker_force_staff_melee_attack_bonus.max,
		},
	},
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local current_percent = template_data.warp_charge_component.current_percentage

		return current_percent
	end,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local warp_charge_component = unit_data_extension:write_component("warp_charge")
		local inventory_component = unit_data_extension:read_component("inventory")

		template_data.warp_charge_component = warp_charge_component
		template_data.inventory_component = inventory_component
		template_data.counter = 0
	end,
	proc_func = function (params, template_data, template_context)
		template_data.procced = true
	end,
	update_func = function (template_data, template_context, dt, t)
		if template_data.procced then
			local warp_charge_component = template_data.warp_charge_component
			local remove_percentage = talent_settings.psyker_force_staff_melee_attack_bonus.venting
			local unit = template_context.unit

			WarpCharge.decrease_immediate(remove_percentage, warp_charge_component, unit)

			template_data.procced = false
		end
	end,
}
templates.psyker_force_staff_wield_speed = {
	class_name = "buff",
	predicted = false,
	lerped_stat_buffs = {
		[stat_buffs.wield_speed] = {
			min = talent_settings.psyker_force_staff_wield_speed.min,
			max = talent_settings.psyker_force_staff_wield_speed.max,
		},
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.warp_charge_component = unit_data_extension:read_component("warp_charge")
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local current_percent = template_data.warp_charge_component.current_percentage

		return current_percent
	end,
}
templates.psyker_melee_toughness = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness_melee_replenish] = 1,
	},
}
templates.psyker_alternative_peril_explosion = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.overheat_explosion_speed_modifier] = 1.65,
	},
}
templates.psyker_force_staff_bonus = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_action_finish] = 1,
	},
	check_proc_func = function (params, template_data, template_context)
		local wielded_slot = template_data.inventory_component.wielded_slot

		if wielded_slot ~= "slot_secondary" then
			return false
		end

		local action_settings = params.action_settings
		local name = action_settings.name
		local wielded_weapon_template = PlayerUnitVisualLoadout.wielded_weapon_template(template_data.visual_loadout_extension, template_data.inventory_component)
		local template_name = wielded_weapon_template.name

		if template_name == "forcestaff_p2_m1" then
			return name and name == "action_charge_flame"
		else
			return name and name == "action_charge"
		end
	end,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local inventory_component = unit_data_extension:read_component("inventory")

		template_data.inventory_component = inventory_component
		template_data.visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	end,
	proc_func = function (params, template_data, template_context, t)
		if params.charge_level < 0.95 then
			return
		end

		template_context.buff_extension:add_internally_controlled_buff("psyker_force_staff_bonus_buff", t)
	end,
}
templates.psyker_force_staff_bonus_buff = {
	class_name = "buff",
	duration = 5,
	hud_icon = "content/ui/textures/icons/buffs/hud/psyker/psyker_force_staff_bonus",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	stat_buffs = {
		[stat_buffs.force_staff_single_target_damage] = 0.3,
	},
}

return templates
