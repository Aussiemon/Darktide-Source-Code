local AilmentSettings = require("scripts/settings/ailments/ailment_settings")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local HitZone = require("scripts/utilities/attack/hit_zone")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local MasterItems = require("scripts/backend/master_items")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local TalentSettings = require("scripts/settings/buff/talent_settings")
local Toughness = require("scripts/utilities/toughness/toughness")
local WarpCharge = require("scripts/utilities/warp_charge")
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local ailment_effects = AilmentSettings.effects
local attack_results = AttackSettings.attack_results
local hit_zone_names = HitZone.hit_zone_names
local damage_types = DamageSettings.damage_types
local keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local special_rules = SpecialRulesSetting.special_rules
local stat_buffs = BuffSettings.stat_buffs
local talent_settings = TalentSettings.psyker_2
local templates = {}
local base_max_souls = talent_settings.passive_1.base_max_souls
local max_souls_talent = talent_settings.offensive_2_1.max_souls_talent
local soul_duration = talent_settings.passive_1.soul_duration

local function psyker_biomancer_passive_start(template_data, template_context)
	local unit = template_context.unit
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local buff_extension = ScriptUnit.extension(unit, "buff_system")
	local specialization_extension = ScriptUnit.extension(unit, "specialization_system")
	local fx_extension = ScriptUnit.extension(unit, "fx_system")
	local first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	local coherency_extension = ScriptUnit.extension(unit, "coherency_system")
	template_data.action_module_targeting_component = unit_data_extension:read_component("action_module_targeting")
	template_data.specialization_resource_component = unit_data_extension:write_component("specialization_resource")
	template_data.warp_charge_component = unit_data_extension:read_component("warp_charge")
	template_data.buff_extension = buff_extension
	template_data.fx_extension = fx_extension
	template_data.coherency_extension = coherency_extension
	template_data.num_souls = 0
	local first_person_unit = first_person_extension:first_person_unit()
	template_data.first_person_unit = first_person_unit
	local inventory_item_name = "content/items/weapons/player/grenade_krak"
	local item_definitions = MasterItems.get_cached()
	template_data.item = item_definitions[inventory_item_name]
	template_data.psyker_biomancer_toughness_regen_soul = specialization_extension:has_special_rule(special_rules.psyker_biomancer_toughness_regen_soul)
	template_data.psyker_biomancer_increased_max_souls = specialization_extension:has_special_rule(special_rules.psyker_biomancer_increased_max_souls)
	template_data.psyker_biomancer_restore_cooldown_per_soul = specialization_extension:has_special_rule(special_rules.psyker_biomancer_restore_cooldown_per_soul)
	template_data.psyker_biomancer_efficient_smites = specialization_extension:has_special_rule(special_rules.psyker_biomancer_efficient_smites)
	template_data.psyker_biomancer_discharge_applies_warpfire = specialization_extension:has_special_rule(special_rules.psyker_biomancer_discharge_applies_warpfire)
	template_data.psyker_biomancer_all_kills_can_generate_souls = specialization_extension:has_special_rule(special_rules.psyker_biomancer_all_kills_can_generate_souls)
	template_data.buff_name = template_data.psyker_biomancer_increased_max_souls and "psyker_biomancer_souls_increased_max_stacks" or "psyker_biomancer_souls"
	local is_playing = fx_extension:is_looping_particles_playing("psyker_biomancer_soul")

	if not is_playing then
		local data = {
			particle_name = "content/fx/particles/abilities/biomancer_soul"
		}
		local spawner_name = "hips"

		fx_extension:spawn_looping_particles("psyker_biomancer_soul", spawner_name, data)
	end

	local toughness_talent_soul_requirement = talent_settings.defensive_2.soul_threshold
	template_data.num_warpfire_stacks = 0
	template_data.toughness_talent_soul_requirement = toughness_talent_soul_requirement
	template_data.max_souls_talent = max_souls_talent
	template_data.max_souls = template_data.psyker_biomancer_increased_max_souls and max_souls_talent or base_max_souls
	template_data.specialization_resource_component.max_resource = max_souls_talent
	template_data.specialization_resource_component.current_resource = 0
end

local function psyker_biomancer_passive_stop(template_data, template_context)
	local is_playing = template_data.fx_extension:is_looping_particles_playing("psyker_biomancer_soul")

	if is_playing then
		template_data.fx_extension:stop_looping_particles("psyker_biomancer_soul", true)
	end
end

local function psyker_biomancer_passive_conditional_stat_buffs(template_data, template_context)
	if template_data.psyker_biomancer_toughness_regen_soul then
		local soul_requirement = template_data.toughness_talent_soul_requirement
		local num_souls = template_data.specialization_resource_component.current_resource

		return soul_requirement <= num_souls
	end
end

local function psyker_biomancer_passive_lerp_t(t, start_time, duration, template_data, template_context)
	local current_num_souls = template_data.specialization_resource_component.current_resource
	local max_num_souls = template_data.specialization_resource_component.max_resource

	return current_num_souls / max_num_souls
end

local function psyker_biomancer_passive_proc_on_hit(params, template_data, template_context)
	local damage_type = params.damage_type

	if template_data.psyker_biomancer_discharge_applies_warpfire and damage_type == damage_types.psyker_biomancer_discharge then
		local t = FixedFrame.get_latest_fixed_time()
		local unit_hit = params.attacked_unit
		local buff_extension = ScriptUnit.has_extension(unit_hit, "buff_system")

		if buff_extension and HEALTH_ALIVE[unit_hit] then
			local num_warpfire_stacks = template_data.num_warpfire_stacks

			if num_warpfire_stacks > 0 then
				buff_extension:add_internally_controlled_buff_with_stacks("warp_fire", num_warpfire_stacks, t, "owner_unit", template_context.unit)
			end
		end
	end

	if damage_type ~= damage_types.smite and not template_data.psyker_biomancer_all_kills_can_generate_souls then
		return false
	end

	if params.attack_result ~= attack_results.died then
		return false
	end

	local should_proc = true

	if template_data.psyker_biomancer_all_kills_can_generate_souls then
		local rand = math.random()

		if rand > 1 then
			should_proc = false
		end
	end

	if should_proc then
		local t = FixedFrame.get_latest_fixed_time()
		local buff_name = template_data.buff_name

		template_data.buff_extension:add_internally_controlled_buff(buff_name, t)
	end
end

local function psyker_biomancer_passive_proc_on_combat_ability(params, template_data, template_context)
	if template_data.psyker_biomancer_discharge_applies_warpfire then
		local current_souls = template_data.specialization_resource_component.current_resource
		template_data.num_warpfire_stacks = math.max(math.floor(current_souls), 1)
	end

	if template_data.psyker_biomancer_efficient_smites then
		local t = FixedFrame.get_latest_fixed_time()
		local buff_name = "psyker_biomancer_efficient_smites"

		template_data.buff_extension:add_internally_controlled_buff(buff_name, t)
	end
end

templates.psyker_biomancer_passive = {
	predicted = false,
	use_specialization_resource = true,
	class_name = "psyker_biomancer_passive_buff",
	keywords = {},
	stat_buffs = {},
	proc_events = {
		[proc_events.on_hit] = talent_settings.passive_1.on_hit_proc_chance,
		[proc_events.on_combat_ability] = talent_settings.passive_1.on_combat_ability_proc_chance
	},
	conditional_stat_buffs = {
		toughness_replenish_multiplier = talent_settings.defensive_2.toughness_replenish_multiplier
	},
	lerped_stat_buffs = {
		[stat_buffs.damage] = {
			min = 0,
			max = talent_settings.passive_1.damage
		}
	},
	conditional_stat_buffs_func = psyker_biomancer_passive_conditional_stat_buffs,
	lerp_t_func = psyker_biomancer_passive_lerp_t,
	start_func = psyker_biomancer_passive_start,
	stop_func = psyker_biomancer_passive_stop,
	specific_proc_func = {
		on_hit = psyker_biomancer_passive_proc_on_hit,
		on_combat_ability = psyker_biomancer_passive_proc_on_combat_ability
	}
}

local function add_soul_function(template_data, template_context, t, previous_stack_count)
	local stacks = template_context.stack_count
	local max_stacks = template_context.template.max_stacks
	template_data.specialization_resource_component.current_resource = math.clamp(stacks, 0, max_stacks)
	local soul_screenspace_effect = nil

	if stacks == max_stacks then
		soul_screenspace_effect = "content/fx/particles/screenspace/screen_biomancer_maxsouls"
	else
		soul_screenspace_effect = "content/fx/particles/screenspace/screen_biomancer_souls"
	end

	template_data.fx_extension:spawn_exclusive_particle(soul_screenspace_effect, Vector3(0, 0, 1))

	if template_data.psyker_biomancer_toughness_on_soul and template_context.is_server then
		local player_unit = template_context.unit
		local buff_extension = ScriptUnit.has_extension(player_unit, "buff_system")

		if buff_extension then
			local buff_name = "psyker_biomancer_smite_kills_replenish_toughness_stacking_buff"

			buff_extension:add_internally_controlled_buff(buff_name, t)
		end
	end

	if template_data.psyker_biomancer_warpfire_on_max_souls and template_context.is_server and max_stacks < stacks then
		local broadphase = template_data.broadphase
		local enemy_side_names = template_data.enemy_side_names
		local broadphase_results = template_data.broadphase_results

		table.clear(broadphase_results)

		local player_unit = template_context.unit
		local position = POSITION_LOOKUP[player_unit]
		local distance = talent_settings.offensive_2_2.distance
		local num_results = broadphase:query(position, distance, broadphase_results, enemy_side_names)

		if num_results > 0 then
			local stop_point = math.random(1, num_results)
			local target_unit = nil

			for i = 1, num_results do
				local unit = broadphase_results[i]
				local enemy_unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
				local enemy_breed = enemy_unit_data_extension:breed()

				if i <= stop_point then
					target_unit = unit
				end

				if enemy_breed.tags.monster or enemy_breed.tags.elite then
					target_unit = unit

					break
				end
			end

			local buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")
			local num_stacks = talent_settings.offensive_2_2.num_stacks

			if buff_extension then
				buff_extension:add_internally_controlled_buff_with_stacks("warp_fire", num_stacks, t, "owner_unit", player_unit)
			end
		end
	end
end

local function start_soul_function(template_data, template_context)
	local unit = template_context.unit
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local fx_extension = ScriptUnit.extension(unit, "fx_system")
	local specialization_resource_component = unit_data_extension:write_component("specialization_resource")
	local specialization_extension = ScriptUnit.extension(unit, "specialization_system")
	local psyker_biomancer_discharge_applies_warpfire = specialization_extension:has_special_rule(special_rules.psyker_biomancer_discharge_applies_warpfire)
	template_data.psyker_biomancer_warpfire_on_max_souls = specialization_extension:has_special_rule(special_rules.psyker_biomancer_warpfire_on_max_souls)
	template_data.psyker_biomancer_toughness_on_soul = specialization_extension:has_special_rule(special_rules.psyker_biomancer_toughness_on_soul)
	template_data.psyker_biomancer_restore_cooldown_per_soul = specialization_extension:has_special_rule(special_rules.psyker_biomancer_restore_cooldown_per_soul)
	template_data.remove_on_ability = template_data.psyker_biomancer_restore_cooldown_per_soul or psyker_biomancer_discharge_applies_warpfire
	template_data.specialization_resource_component = specialization_resource_component
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

	add_soul_function(template_data, template_context, t, 0)
end

local REPORT_INTERVALL = 1

local function update_soul_function(template_data, template_context, dt, t)
	if Managers.stats.can_record_stats() then
		local stacks = template_context.stack_count
		local max_stacks = template_context.template.max_stacks
		local is_on_max = max_stacks <= stacks
		local time_at_max = template_data.time_at_max or 0
		time_at_max = is_on_max and time_at_max + dt or 0
		template_data.time_at_max = time_at_max
		local report_time = is_on_max and template_data.repport_time or 0
		report_time = report_time + (is_on_max and dt or 0)

		if REPORT_INTERVALL < report_time then
			Managers.stats:record_psyker_2_at_max_stack(template_context.player, time_at_max)
		end

		template_data.repport_time = report_time % REPORT_INTERVALL
	end
end

local function souls_stop_function(template_data, template_context)
	template_data.specialization_resource_component.current_resource = 0
end

local function souls_conditional_exit_function(template_data, template_context)
	if not template_data.remove_on_ability then
		return
	end

	return template_data.ability_done
end

local function souls_proc_func(params, template_data, template_context)
	if template_data.psyker_biomancer_restore_cooldown_per_soul then
		local num_souls = template_context.stack_count
		local unit = template_context.unit
		local ability_extension = ScriptUnit.has_extension(unit, "ability_system")

		if num_souls > 0 and ability_extension then
			local cooldown_reduction_percent = talent_settings.combat_ability_1.cooldown_reduction_percent
			local cooldown_percentage = cooldown_reduction_percent * num_souls

			ability_extension:reduce_ability_cooldown_percentage("combat_ability", cooldown_percentage)
		end
	end

	template_data.ability_done = true
end

local souls_proc_events = {
	[proc_events.on_combat_ability] = 1
}
templates.psyker_biomancer_souls = {
	refresh_duration_on_stack = true,
	predicted = false,
	hud_priority = 1,
	allow_proc_while_active = true,
	hud_icon = "content/ui/textures/icons/talents/psyker_2/hud/psyker_2_base_1",
	class_name = "proc_buff",
	proc_events = souls_proc_events,
	max_stacks = base_max_souls,
	duration = soul_duration,
	proc_func = souls_proc_func,
	start_func = start_soul_function,
	update_func = update_soul_function,
	refresh_func = add_soul_function,
	stop_func = souls_stop_function,
	conditional_exit_func = souls_conditional_exit_function
}
templates.psyker_biomancer_souls_increased_max_stacks = {
	hud_priority = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	allow_proc_while_active = true,
	hud_icon = "content/ui/textures/icons/talents/psyker_2/hud/psyker_2_base_1",
	class_name = "proc_buff",
	proc_events = souls_proc_events,
	max_stacks = max_souls_talent,
	duration = soul_duration,
	proc_func = souls_proc_func,
	start_func = start_soul_function,
	update_func = update_soul_function,
	refresh_func = add_soul_function,
	stop_func = souls_stop_function,
	conditional_exit_func = souls_conditional_exit_function
}
templates.psyker_biomancer_base_passive = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = talent_settings.passive_2.on_hit_proc_chance
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
		local warp_charge_component = template_data.warp_charge_component
		local remove_percentage = talent_settings.passive_2.warp_charge_percent
		local unit = template_context.unit

		WarpCharge.decrease_immediate(remove_percentage, warp_charge_component, unit)
	end
}
templates.psyker_biomancer_coherency_damage_vs_elites = {
	predicted = false,
	coherency_priority = 2,
	coherency_id = "psyker_bionmancer_coherency_aura",
	class_name = "buff",
	max_stacks = talent_settings.coherency.max_stacks,
	stat_buffs = {
		[stat_buffs.damage_vs_elites] = talent_settings.coherency.damage_vs_elites
	}
}
templates.psyker_biomancer_smite_kills_replenish_toughness_stacking = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = talent_settings.toughness_1.on_hit_proc_chance
	},
	check_proc_func = CheckProcFunctions.on_smite_kill,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")
		template_data.buff_extension = buff_extension
	end,
	proc_func = function (params, template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()
		local buff_name = "psyker_biomancer_smite_kills_replenish_toughness_stacking_buff"

		template_data.buff_extension:add_internally_controlled_buff(buff_name, t)
	end
}
local percent_toughness = talent_settings.toughness_1.percent_toughness
templates.psyker_biomancer_smite_kills_replenish_toughness_stacking_buff = {
	predicted = false,
	hud_priority = 3,
	hud_icon = "content/ui/textures/icons/talents/psyker_2/hud/psyker_2_tier_1_1",
	refresh_duration_on_stack = true,
	class_name = "buff",
	max_stacks = talent_settings.toughness_1.max_stacks,
	duration = talent_settings.toughness_1.duration,
	update_func = function (template_data, template_context, dt, t)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local percent_to_replenish = percent_toughness * dt

		Toughness.replenish_percentage(unit, percent_to_replenish, false, "talent_toughness_1")
	end
}
templates.psyker_biomancer_toughness_on_warp_kill = {
	max_stacks = 1,
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	check_proc_func = CheckProcFunctions.on_warp_kill,
	proc_func = function (params, template_data, template_context)
		local percentage = talent_settings.toughness_2.percent_toughness

		Toughness.replenish_percentage(template_context.unit, percentage, false, "talent_toughness_2")
	end
}
templates.psyker_biomancer_toughness_on_vent = {
	max_stacks = 1,
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_warp_charge_changed] = 1
	},
	proc_func = function (params, template_data, template_context)
		local percentage_change = params.percentage_change

		if percentage_change > 0 then
			percentage_change = percentage_change * talent_settings.toughness_3.multiplier

			Toughness.replenish_percentage(template_context.unit, percentage_change, false, "talent_toughness_3")
		end
	end
}
templates.psyker_biomancer_warp_charge_increase_force_weapon_damage = {
	predicted = false,
	class_name = "buff",
	lerped_stat_buffs = {
		[stat_buffs.force_weapon_damage] = {
			min = talent_settings.offensive_1_1.damage_min,
			max = talent_settings.offensive_1_1.damage
		}
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		template_data.warp_charge_component = unit_data_extension:read_component("warp_charge")
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local current_percent = template_data.warp_charge_component.current_percentage

		return current_percent
	end
}
templates.psyker_biomancer_souls_increase_warp_charge_decrease_venting = {
	predicted = false,
	class_name = "buff",
	lerped_stat_buffs = {
		[stat_buffs.warp_charge_amount] = {
			min = 1,
			max = talent_settings.offensive_1_2.warp_charge_capacity
		},
		[stat_buffs.vent_warp_charge_multiplier] = {
			min = 1,
			max = talent_settings.offensive_1_2.vent_speed
		}
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local specialization_resource_component = unit_data_extension:read_component("specialization_resource")
		template_data.specialization_resource_component = specialization_resource_component
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local current_souls = template_data.specialization_resource_component.current_resource

		return current_souls / max_souls_talent
	end
}
templates.psyker_biomancer_smite_kills_add_warpfire = {
	max_stacks = 1,
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
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
		local smite_kill = CheckProcFunctions.on_smite_kill(params)
		local elite_or_special_kill = CheckProcFunctions.on_elite_or_special_kill(params)

		return smite_kill and elite_or_special_kill
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

		local distance = talent_settings.offensive_1_3.distance
		local num_results = broadphase:query(position, distance, broadphase_results, enemy_side_names)
		local _has_extension = ScriptUnit.has_extension

		for i = 1, num_results do
			local hit_unit = broadphase_results[i]
			local buff_extension = _has_extension(hit_unit, "buff_system")

			if buff_extension then
				local t = FixedFrame.get_latest_fixed_time()
				local num_stacks = talent_settings.offensive_1_3.num_stacks

				buff_extension:add_internally_controlled_buff_with_stacks("warp_fire", num_stacks, t, "owner_unit", template_context.unit)
			end
		end
	end
}
templates.psyker_biomancer_coherency_souls_on_kill = {
	coherency_id = "psyker_biomancer_coherency_souls_on_kill",
	predicted = false,
	coherency_priority = 2,
	max_stacks = 1,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	check_proc_func = CheckProcFunctions.on_kill,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.units_with_talent = {}
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local units_in_coherence = template_data.coherency_extension:in_coherence_units()
		local units_with_talent = template_data.units_with_talent
		local ScriptUnit_extension = ScriptUnit.extension

		table.clear(units_with_talent)

		for coherency_unit, _ in pairs(units_in_coherence) do
			local specialization_extension = ScriptUnit_extension(coherency_unit, "specialization_system")

			if specialization_extension:has_special_rule(special_rules.psyker_biomancer_coherency_souls_on_kill) then
				units_with_talent[#units_with_talent + 1] = coherency_unit
			end
		end

		local num_units_with_talent = #units_with_talent
		local proc_chance = talent_settings.coop_1.on_kill_proc_chance * num_units_with_talent

		if math.random() < proc_chance then
			local index = math.random(1, num_units_with_talent)
			local unit = units_with_talent[index]
			local specialization_extension = ScriptUnit_extension(unit, "specialization_system")
			local buff_extension = ScriptUnit_extension(unit, "buff_system")
			local has_psyker_biomancer_increased_max_souls = specialization_extension:has_special_rule(special_rules.psyker_biomancer_increased_max_souls)
			local buff_name = "psyker_biomancer_souls"

			if has_psyker_biomancer_increased_max_souls then
				buff_name = "psyker_biomancer_souls_increased_max_stacks"
			end

			local t = FixedFrame.get_latest_fixed_time()

			buff_extension:add_internally_controlled_buff(buff_name, t)
		end
	end
}
templates.psyker_biomancer_cooldown_reduction_on_elite_kill_for_coherency = {
	predicted = false,
	class_name = "proc_buff",
	stat_buffs = {},
	proc_events = {
		[proc_events.on_hit] = 1
	},
	check_proc_func = CheckProcFunctions.on_elite_kill,
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

		local percent = talent_settings.coop_2.percent
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
	end
}
templates.psyker_biomancer_smite_makes_victim_vulnerable = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1
	},
	check_proc_func = CheckProcFunctions.on_smite_attack,
	proc_func = function (params, template_data, template_context)
		local hit_unit = params.attacked_unit

		if HEALTH_ALIVE[hit_unit] then
			local buff_extension = ScriptUnit.has_extension(hit_unit, "buff_system")

			if buff_extension then
				local t = FixedFrame.get_latest_fixed_time()
				local buff_name = "psyker_biomancer_smite_vulnerable_debuff"

				buff_extension:add_internally_controlled_buff(buff_name, t, "owner_unit", template_context.unit)
			end
		end
	end
}
templates.psyker_biomancer_smite_vulnerable_debuff = {
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = 1,
	class_name = "buff",
	duration = talent_settings.coop_3.duration,
	stat_buffs = {
		[stat_buffs.non_warp_damage_taken_multiplier] = talent_settings.coop_3.damage_taken_multiplier
	}
}
templates.psyker_biomancer_block_costs_warp_charge = {
	predicted = false,
	class_name = "buff",
	keywords = {
		keywords.block_gives_warp_charge
	},
	stat_buffs = {
		[stat_buffs.warp_charge_block_cost] = talent_settings.defensive_1.warp_charge_cost_multiplier
	}
}
templates.psyker_biomancer_warp_charge_reduces_toughness_damage_taken = {
	predicted = false,
	class_name = "buff",
	lerped_stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = {
			min = talent_settings.defensive_2.min_toughness_damage_multiplier,
			max = talent_settings.defensive_2.max_toughness_damage_multiplier
		}
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
	end
}
templates.psyker_biomancer_venting_improvements = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.vent_warp_charge_decrease_movement_reduction] = talent_settings.defensive_3.vent_warp_charge_decrease_movement_reduction
	}
}
templates.psyker_biomancer_smite_on_hit = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = talent_settings.offensive_2_3.smite_chance
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.next_allowed_t = 0
		template_data.fx_extension = ScriptUnit.extension(unit, "fx_system")
	end,
	update_func = function (template_data, template_context, dt, t)
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

		template_data.next_allowed_t = t + talent_settings.offensive_2_3.cooldown
		local hit_unit_pos = POSITION_LOOKUP[smite_target]
		local player_pos = POSITION_LOOKUP[player_unit]
		local attack_direction = Vector3.normalize(hit_unit_pos - player_pos)
		local damage_profile = DamageProfileTemplates.psyker_smite_kill
		local damage_type = damage_types.smite
		local hit_world_position = hit_unit_pos
		local attacked_unit_data_extension = ScriptUnit.has_extension(smite_target, "unit_data_system")
		local target_breed = attacked_unit_data_extension and attacked_unit_data_extension:breed()
		local hit_zone_name, hit_actor = nil

		if target_breed then
			local hit_zone_weakspot_types = target_breed.hit_zone_weakspot_types
			local hit_zone = hit_zone_weakspot_types and next(hit_zone_weakspot_types) or hit_zone_names.center_mass
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
	proc_func = function (params, template_data, template_context, t)
		if t < template_data.next_allowed_t then
			return
		end

		local attack_type = params.attack_type

		if not attack_type then
			return
		end

		local damage = params.damage

		if damage == 0 then
			return
		end

		local attacked_unit = params.attacked_unit
		local unit_data_extension = ScriptUnit.has_extension(attacked_unit, "unit_data_system")

		if not unit_data_extension then
			return
		end

		if not HEALTH_ALIVE[attacked_unit] then
			return
		end

		template_data.smite_target = attacked_unit
	end
}
templates.psyker_biomancer_efficient_smites = {
	hud_priority = 3,
	hud_icon = "content/ui/textures/icons/talents/psyker_2/hud/psyker_2_tier_6_3",
	predicted = false,
	class_name = "buff",
	duration = talent_settings.combat_ability_3.duration,
	stat_buffs = {
		[stat_buffs.warp_charge_amount_smite] = talent_settings.combat_ability_3.warp_charge_amount_smite,
		[stat_buffs.smite_attack_speed] = talent_settings.combat_ability_3.smite_attack_speed
	},
	player_effects = {
		on_screen_effect = "content/fx/particles/screenspace/psyker_biomancer_fast_smites"
	}
}
templates.psyker_biomancer_warpfire_grants_souls = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_minion_death] = talent_settings.combat_ability_2.soul_chance
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local specialization_extension = ScriptUnit.has_extension(unit, "specialization_system")
		local has_psyker_biomancer_increased_max_souls = specialization_extension:has_special_rule(special_rules.psyker_biomancer_increased_max_souls)
		template_data.buff_name = has_psyker_biomancer_increased_max_souls and "psyker_biomancer_souls_increased_max_stacks" or "psyker_biomancer_souls"
		template_data.buff_extension = ScriptUnit.extension(unit, "buff_system")
	end,
	proc_func = function (params, template_data, template_context)
		local killed_unit = params.dying_unit
		local killed_unit_buff_extension = ScriptUnit.has_extension(killed_unit, "buff_system")

		if killed_unit_buff_extension and killed_unit_buff_extension:has_keyword(keywords.warpfire_burning) then
			local buff_name = template_data.buff_name
			local buff_extension = template_data.buff_extension
			local t = FixedFrame.get_latest_fixed_time()

			buff_extension:add_internally_controlled_buff(buff_name, t)
		end
	end
}
templates.psyker_biomancer_warpfire_debuff = {
	interval = 0.75,
	predicted = false,
	refresh_duration_on_stack = true,
	max_stacks = 4,
	duration = 15,
	class_name = "interval_buff",
	keywords = {
		keywords.burning,
		keywords.warpfire_burning
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
	minion_effects = {
		ailment_effect = ailment_effects.warpfire,
		node_effects = {
			{
				node_name = "j_spine",
				vfx = {
					material_emission = true,
					particle_effect = "content/fx/particles/enemies/buff_warpfire",
					orphaned_policy = "destroy",
					stop_type = "stop"
				},
				sfx = {
					looping_wwise_stop_event = "wwise/events/weapon/stop_enemy_on_fire",
					looping_wwise_start_event = "wwise/events/weapon/play_enemy_on_fire"
				}
			}
		}
	}
}

return templates
