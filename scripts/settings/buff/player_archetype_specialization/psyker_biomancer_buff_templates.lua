local AilmentSettings = require("scripts/settings/ailments/ailment_settings")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local MasterItems = require("scripts/backend/master_items")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local TalentSettings = require("scripts/settings/buff/talent_settings")
local Toughness = require("scripts/utilities/toughness/toughness")
local WarpCharge = require("scripts/utilities/warp_charge")
local CheckProcFunctionTemplates = require("scripts/settings/buff/check_proc_function_templates")
local ailment_effects = AilmentSettings.effects
local attack_results = AttackSettings.attack_results
local damage_types = DamageSettings.damage_types
local keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local special_rules = SpecialRulesSetting.special_rules
local stat_buffs = BuffSettings.stat_buffs
local talent_settings = TalentSettings.psyker_2
local templates = {}
local base_max_souls = talent_settings.passive_1.base_max_souls
local max_souls_talent = talent_settings.spec_passive_1.max_souls_talent
local soul_duration = talent_settings.passive_1.soul_duration
local talent_soul_duration = talent_settings.spec_passive_3.talent_soul_duration
local cooldown_reduction_percent = talent_settings.combat_ability_1.cooldown_reduction_percent
local max_targets_of_warpfire = talent_settings.combat_ability_2.max_targets_of_warpfire
local warpfire_power_level = talent_settings.combat_ability_2.warpfire_power_level
local all_kills_proc_chance = talent_settings.mixed_2.all_kills_proc_chance

local function psyker_biomancer_passive_start(template_data, template_context)
	local unit = template_context.unit
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local buff_extension = ScriptUnit.extension(unit, "buff_system")
	local specialization_extension = ScriptUnit.extension(unit, "specialization_system")
	local ability_extension = ScriptUnit.has_extension(unit, "ability_system")
	local fx_extension = ScriptUnit.extension(unit, "fx_system")
	local first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	local coherency_extension = ScriptUnit.extension(unit, "coherency_system")
	template_data.action_module_targeting_component = unit_data_extension:read_component("action_module_targeting")
	template_data.specialization_resource_component = unit_data_extension:write_component("specialization_resource")
	template_data.warp_charge_component = unit_data_extension:read_component("warp_charge")
	template_data.buff_extension = buff_extension
	template_data.ability_extension = ability_extension
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
	template_data.psyker_biomancer_increased_souls_duration = specialization_extension:has_special_rule(special_rules.psyker_biomancer_increased_souls_duration)
	template_data.psyker_biomancer_restore_cooldown_per_soul = specialization_extension:has_special_rule(special_rules.psyker_biomancer_restore_cooldown_per_soul)
	template_data.psyker_biomancer_efficient_smites = specialization_extension:has_special_rule(special_rules.psyker_biomancer_efficient_smites)
	template_data.psyker_biomancer_discharge_applies_warpfire = specialization_extension:has_special_rule(special_rules.psyker_biomancer_discharge_applies_warpfire)
	template_data.psyker_biomancer_all_kills_can_generate_souls = specialization_extension:has_special_rule(special_rules.psyker_biomancer_all_kills_can_generate_souls)
	template_data.buff_name = template_data.psyker_biomancer_increased_max_souls and "psyker_biomancer_souls_increased_max_stacks" or template_data.psyker_biomancer_increased_souls_duration and "psyker_biomancer_souls_increased_duration" or "psyker_biomancer_souls"
	local is_playing = fx_extension:is_looping_particles_playing("psyker_biomancer_soul")

	if not is_playing then
		local data = {
			particle_name = "content/fx/particles/abilities/biomancer_soul"
		}
		local spawner_name = "hips"

		fx_extension:spawn_looping_particles("psyker_biomancer_soul", spawner_name, data)
	end

	local toughness_talent_soul_requirement = 3
	template_data.warpfire_data = {
		soul_percentage = 0
	}
	template_data.toughness_talent_soul_requirement = toughness_talent_soul_requirement
	template_data.max_souls_talent = max_souls_talent
	template_data.max_souls = template_data.psyker_biomancer_increased_max_souls and max_souls_talent or base_max_souls
	template_data.cooldown_reduction_percent = cooldown_reduction_percent
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
		local t = Managers.time:time("gameplay")
		local unit_hit = params.attacked_unit

		if template_data.num_to_debuff > 0 then
			local buff_extension = ScriptUnit.has_extension(unit_hit, "buff_system")

			if buff_extension and HEALTH_ALIVE[unit_hit] then
				local lerp_value = template_data.warpfire_data.soul_percentage

				buff_extension:add_internally_controlled_buff("psyker_biomancer_warpfire_debuff", t, "buff_lerp_value", lerp_value, "owner_unit", template_context.unit)

				template_data.num_to_debuff = template_data.num_to_debuff - 1
			end
		end
	end

	if damage_type ~= damage_types.smite and not template_data.psyker_biomancer_all_kills_can_generate_souls then
		return false
	end

	if params.result ~= attack_results.died then
		return false
	end

	local should_proc = true

	if template_data.psyker_biomancer_all_kills_can_generate_souls then
		local rand = math.random()

		if all_kills_proc_chance < rand then
			should_proc = false
		end
	end

	if should_proc then
		local t = Managers.time:time("gameplay")
		local buff_name = template_data.buff_name

		template_data.buff_extension:add_internally_controlled_buff(buff_name, t)
	end
end

local function psyker_biomancer_passive_proc_on_combat_ability(params, template_data, template_context)
	if template_data.psyker_biomancer_discharge_applies_warpfire then
		local current_souls = template_data.specialization_resource_component.current_resource
		template_data.warpfire_data.soul_percentage = current_souls / max_souls_talent
		template_data.num_to_debuff = math.ceil(max_targets_of_warpfire * template_data.warpfire_data.soul_percentage)
	end

	if template_data.psyker_biomancer_efficient_smites then
		local t = Managers.time:time("gameplay")
		local buff_name = "psyker_biomancer_efficient_smites"

		template_data.buff_extension:add_internally_controlled_buff(buff_name, t)
	end
end

templates.psyker_biomancer_passive = {
	predicted = false,
	hud_priority = 1,
	use_specialization_resource = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/states_fire_buff_hud",
	class_name = "psyker_biomancer_passive_buff",
	keywords = {},
	stat_buffs = {},
	proc_events = {
		[proc_events.on_hit] = talent_settings.passive_1.on_hit_proc_chance,
		[proc_events.on_combat_ability] = talent_settings.passive_1.on_combat_ability_proc_chance
	},
	conditional_stat_buffs = {
		toughness_replenish_multiplier = talent_settings.defensive_3.toughness_replenish_multiplier
	},
	lerped_stat_buffs = {
		[stat_buffs.smite_damage] = {
			min = 0,
			max = talent_settings.passive_1.smite_damage
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

local function add_soul_function(template_data, template_context)
	local stacks = template_context.stack_count
	template_data.specialization_resource_component.current_resource = stacks
	local soul_screenspace_effect = nil
	local max_stacks = template_context.template.max_stacks
	soul_screenspace_effect = stacks == max_stacks and "content/fx/particles/screenspace/screen_biomancer_maxsouls" or "content/fx/particles/screenspace/screen_biomancer_souls"

	template_data.fx_extension:spawn_exclusive_particle(soul_screenspace_effect, Vector3(0, 0, 1))
end

local function start_soul_function(template_data, template_context)
	local unit = template_context.unit
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local fx_extension = ScriptUnit.extension(unit, "fx_system")
	local specialization_resource_component = unit_data_extension:write_component("specialization_resource")
	local specialization_extension = ScriptUnit.extension(unit, "specialization_system")
	local psyker_biomancer_discharge_applies_warpfire = specialization_extension:has_special_rule(special_rules.psyker_biomancer_discharge_applies_warpfire)
	template_data.psyker_biomancer_restore_cooldown_per_soul = specialization_extension:has_special_rule(special_rules.psyker_biomancer_restore_cooldown_per_soul)
	template_data.remove_on_ability = template_data.psyker_biomancer_restore_cooldown_per_soul or psyker_biomancer_discharge_applies_warpfire
	template_data.specialization_resource_component = specialization_resource_component
	template_data.fx_extension = fx_extension

	add_soul_function(template_data, template_context)
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

		for i = 1, num_souls do
			if ability_extension then
				ability_extension:reduce_ability_cooldown_percentage("combat_ability", cooldown_reduction_percent)
			end
		end
	end

	template_data.ability_done = true
end

local souls_proc_events = {
	[proc_events.on_combat_ability] = 1
}
templates.psyker_biomancer_souls = {
	refresh_duration_on_stack = true,
	class_name = "proc_buff",
	proc_events = souls_proc_events,
	max_stacks = base_max_souls,
	max_stacks_cap = base_max_souls,
	duration = soul_duration,
	proc_func = souls_proc_func,
	start_func = start_soul_function,
	refresh_func = add_soul_function,
	stop_func = souls_stop_function,
	conditional_exit_func = souls_conditional_exit_function
}
templates.psyker_biomancer_souls_increased_duration = {
	refresh_duration_on_stack = true,
	class_name = "proc_buff",
	proc_events = souls_proc_events,
	max_stacks = base_max_souls,
	max_stacks_cap = base_max_souls,
	duration = talent_soul_duration,
	proc_func = souls_proc_func,
	start_func = start_soul_function,
	refresh_func = add_soul_function,
	stop_func = souls_stop_function,
	conditional_exit_func = souls_conditional_exit_function
}
templates.psyker_biomancer_souls_increased_max_stacks = {
	refresh_duration_on_stack = true,
	class_name = "proc_buff",
	proc_events = souls_proc_events,
	max_stacks = max_souls_talent,
	max_stacks_cap = max_souls_talent,
	duration = soul_duration,
	proc_func = souls_proc_func,
	start_func = start_soul_function,
	refresh_func = add_soul_function,
	stop_func = souls_stop_function,
	conditional_exit_func = souls_conditional_exit_function
}
templates.psyker_biomancer_base_passive = {
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.warp_charge_amount] = talent_settings.passive_2.warp_charge_amount
	}
}
templates.psyker_biomancer_smite_kills_replenish_toughness_stacking = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = talent_settings.mixed_1.on_hit_proc_chance
	},
	check_proc_func = CheckProcFunctionTemplates.on_smite_kill,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")
		template_data.buff_extension = buff_extension
	end,
	proc_func = function (params, template_data, template_context)
		local t = Managers.time:time("gameplay")
		local buff_name = "psyker_biomancer_smite_kills_replenish_toughness_stacking_buff"

		template_data.buff_extension:add_internally_controlled_buff(buff_name, t)
	end
}
local percent_toughness = talent_settings.mixed_1.percent_toughness
templates.psyker_biomancer_smite_kills_replenish_toughness_stacking_buff = {
	predicted = false,
	refresh_duration_on_stack = true,
	class_name = "buff",
	max_stacks = talent_settings.mixed_1.max_stacks,
	max_stacks_cap = talent_settings.mixed_1.max_stacks_cap,
	duration = talent_settings.mixed_1.duration,
	update_func = function (template_data, template_context, dt, t)
		if not template_context.is_server then
			return
		end

		local stacks = template_context.stack_count
		local unit = template_context.unit
		local percent_to_replenish = percent_toughness * stacks * dt

		Toughness.replenish_percentage(unit, percent_to_replenish)
	end
}
templates.psyker_biomancer_warp_charge_increase_non_warp_damage = {
	predicted = false,
	class_name = "buff",
	lerped_stat_buffs = {
		[stat_buffs.damage] = {
			min = 0,
			max = talent_settings.mixed_3.damage
		},
		[stat_buffs.warp_damage] = {
			min = 0,
			max = -talent_settings.mixed_3.damage
		},
		[stat_buffs.smite_damage] = {
			min = 0,
			max = -talent_settings.mixed_3.damage
		}
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		template_data.warp_charge_component = unit_data_extension:read_component("warp_charge")
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local current_percent = template_data.warp_charge_component.current_percentage
		local level = current_percent / talent_settings.mixed_3.max_threshold_health
		level = math.clamp(level, 0, 1)

		return level
	end
}
local warp_percent = talent_settings.offensive_1.warp_percent
templates.psyker_biomancer_melee_kills_reduce_warp_charge = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = talent_settings.offensive_1.on_hit_proc_chance
	},
	check_proc_func = CheckProcFunctionTemplates.on_melee_kill,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		template_data.warp_charge_component = unit_data_extension:write_component("warp_charge")
	end,
	proc_func = function (params, template_data, template_context)
		local warp_charge_component = template_data.warp_charge_component
		local current_percent = warp_charge_component.current_percentage
		local to_remove = current_percent * warp_percent

		WarpCharge.decrease_immediate(to_remove, template_data.warp_charge_component)
	end
}
templates.psyker_biomancer_damage_per_soul = {
	predicted = false,
	class_name = "buff",
	lerped_stat_buffs = {
		[stat_buffs.damage] = {
			min = 0,
			max = talent_settings.offensive_2.damage
		}
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local specialization_resource_component = unit_data_extension:read_component("specialization_resource")
		template_data.specialization_resource_component = specialization_resource_component
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local current_num_souls = template_data.specialization_resource_component.current_resource
		local max_souls = template_data.specialization_resource_component.max_resource

		return current_num_souls / max_souls
	end
}
templates.psyker_biomancer_warp_charge_shout = {
	predicted = false,
	class_name = "buff",
	lerped_stat_buffs = {
		[stat_buffs.shout_damage] = {
			min = 0,
			max = talent_settings.offensive_3.shout_damage
		}
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		template_data.warp_charge_component = unit_data_extension:read_component("warp_charge")
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local warp_charge_damage = nil
		local warp_charge_percent = template_data.warp_charge_component.current_percentage
		warp_charge_damage = warp_charge_percent

		return warp_charge_damage
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
templates.psyker_biomancer_coherency_damage_vs_elites_improved = {
	predicted = false,
	coherency_priority = 1,
	coherency_id = "psyker_bionmancer_coherency_aura",
	class_name = "buff",
	max_stacks = talent_settings.coop_2.max_stacks,
	stat_buffs = {
		[stat_buffs.damage_vs_elites] = talent_settings.coop_2.damage_vs_elites
	}
}
templates.psyker_biomancer_cooldown_reduction_on_elite_kill_for_coherency = {
	predicted = false,
	class_name = "proc_buff",
	stat_buffs = {},
	proc_events = {
		[proc_events.on_hit] = talent_settings.coop_1.on_hit_proc_chance
	},
	check_proc_func = CheckProcFunctionTemplates.on_elite_kill,
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

		local percent = talent_settings.coop_1.percent
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
		[proc_events.on_hit] = talent_settings.coop_3.on_hit_proc_chance
	},
	check_proc_func = CheckProcFunctionTemplates.on_smite_attack,
	proc_func = function (params, template_data, template_context)
		local hit_unit = params.attacked_unit

		if HEALTH_ALIVE[hit_unit] then
			local buff_extension = ScriptUnit.has_extension(hit_unit, "buff_system")

			if buff_extension then
				local t = Managers.time:time("gameplay")
				local buff_name = "psyker_biomancer_smite_vulnerable_debuff"

				buff_extension:add_internally_controlled_buff(buff_name, t, "owner_unit", template_context.unit)
			end
		end
	end
}
templates.psyker_biomancer_smite_vulnerable_debuff = {
	predicted = false,
	refresh_duration_on_stack = true,
	class_name = "buff",
	duration = talent_settings.coop_3.duration,
	max_stacks = talent_settings.coop_3.max_stacks,
	stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = talent_settings.coop_3.damage_taken_multiplier
	}
}
templates.psyker_biomancer_venting_improvements = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.vent_warp_charge_decrease_movement_reduction] = talent_settings.defensive_1.vent_warp_charge_decrease_movement_reduction
	}
}
templates.psyker_biomancer_warp_charge_reduces_ranged_damage_taken = {
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.ranged_damage_taken_multiplier] = 0.66
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local warp_charge_component = unit_data_extension:read_component("warp_charge")
		template_data.warp_charge_component = warp_charge_component
		template_data.warp_charge_requirement = 0.5
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		local warp_charge_component = template_data.warp_charge_component
		local current_warp_charge_percentage = warp_charge_component.current_percentage

		return template_data.warp_charge_requirement <= current_warp_charge_percentage
	end
}
templates.psyker_biomancer_increase_passive_warp_charge_dissipation = {
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.warp_charge_dissipation_multiplier] = talent_settings.defensive_3.warp_charge_dissipation_multiplier
	}
}
templates.psyker_biomancer_souls_increase_warp_charge_decrease_venting = {
	predicted = false,
	class_name = "buff",
	lerped_stat_buffs = {
		[stat_buffs.warp_charge_amount] = {
			min = 1,
			max = talent_settings.spec_passive_2.increased_capacity
		},
		[stat_buffs.vent_warp_charge_multiplier] = {
			min = 1,
			max = talent_settings.spec_passive_2.increased_capacity
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

		return current_souls / base_max_souls
	end
}
templates.psyker_biomancer_discharge_increased_radius_stagger = {
	predicted = false,
	class_name = "buff",
	lerped_stat_buffs = {
		[stat_buffs.shout_impact_modifier] = {
			max = 0.6,
			min = 0
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
templates.psyker_biomancer_efficient_smites = {
	predicted = false,
	class_name = "buff",
	duration = talent_settings.combat_ability_3.duration,
	stat_buffs = {
		[stat_buffs.warp_charge_amount_smite] = talent_settings.combat_ability_3.warp_charge_amount_smite,
		[stat_buffs.smite_attack_speed] = talent_settings.combat_ability_3.smite_attack_speed
	}
}
templates.psyker_biomancer_warpfire_debuff = {
	predicted = false,
	refresh_duration_on_stack = true,
	class_name = "interval_buff",
	keywords = {
		keywords.burning
	},
	duration = talent_settings.combat_ability_2.duration,
	interval = talent_settings.combat_ability_2.interval,
	max_stacks = talent_settings.combat_ability_2.max_stacks,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local power_level = warpfire_power_level * template_context.buff_lerp_value
		template_data.power_level = power_level
	end,
	interval_function = function (template_data, template_context, template)
		local unit = template_context.unit

		if HEALTH_ALIVE[unit] then
			local damage_template = DamageProfileTemplates.warpfire
			local power_level = template_data.power_level
			local owner = template_context.is_server and template_context.owner_unit or nil

			Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_types.warpfire, "attacking_unit", owner)
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
