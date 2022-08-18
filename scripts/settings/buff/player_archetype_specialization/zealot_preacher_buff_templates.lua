local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctionTemplates = require("scripts/settings/buff/check_proc_function_templates")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local Health = require("scripts/utilities/health")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local Toughness = require("scripts/utilities/toughness/toughness")
local damage_types = DamageSettings.damage_types
local heal_types = DamageSettings.heal_types
local attack_types = AttackSettings.attack_types
local keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local special_rules = SpecialRulesSetting.special_rules
local stat_buffs = BuffSettings.stat_buffs
local templates = {}
local max_dist = 15
local out_of_combat_time = 8
local buff_removal_interval_time = 0.8
local _fanatic_rage_add_stack = nil
templates.zealot_preacher_fanatic_rage = {
	predicted = false,
	hud_priority = 1,
	use_specialization_resource = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/states_fire_buff_hud",
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_minion_death] = 1,
		[proc_events.on_hit] = 1
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.buff_extension = ScriptUnit.extension(unit, "buff_system")
		template_data.side_system = Managers.state.extension:system("side_system")
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		template_data.specialization_resource_component = unit_data_extension:write_component("specialization_resource")
		template_data.specialization_resource_component.max_resource = 25
		template_data.remove_stack_t = nil
		local specialization_extension = ScriptUnit.extension(unit, "specialization_system")
		template_data.kills_restore_cooldown = specialization_extension:has_special_rule(special_rules.zealot_preacher_fanatic_kills_restore_cooldown)
		template_data.crits_grants_stack = specialization_extension:has_special_rule(special_rules.zealot_preacher_crits_grants_stack)
		template_data.ability_extension = ScriptUnit.extension(unit, "ability_system")
	end,
	specific_proc_func = {
		on_minion_death = function (params, template_data, template_context)
			local unit = template_context.unit
			local dying_unit = params.dying_unit
			local unit_pos = POSITION_LOOKUP[unit]
			local dying_unit_pos = POSITION_LOOKUP[dying_unit]
			local distance_sq = Vector3.distance_squared(unit_pos, dying_unit_pos)

			if distance_sq > max_dist * max_dist then
				return
			end

			if template_data.side_system:is_same_side(unit, dying_unit) then
				return
			end

			_fanatic_rage_add_stack(template_data, template_context)
		end,
		on_hit = function (params, template_data, template_context)
			if not template_context.is_server then
				return
			end

			if template_data.kills_restore_cooldown and CheckProcFunctionTemplates.on_kill(params) then
				local cooldown_time = 0.5

				template_data.ability_extension:reduce_ability_cooldown_time("combat_ability", cooldown_time)
			end

			if template_data.crits_grants_stack and CheckProcFunctionTemplates.on_crit(params) then
				_fanatic_rage_add_stack(template_data, template_context)
			end
		end
	},
	update_func = function (template_data, template_context, dt, t)
		if template_data.remove_stack_t and template_data.remove_stack_t < t then
			local current_resource = template_data.specialization_resource_component.current_resource
			current_resource = math.max(current_resource - 1, 1)
			template_data.specialization_resource_component.current_resource = current_resource
			local timer = math.abs(current_resource / 5 - 5) * buff_removal_interval_time

			if current_resource > 1 then
				template_data.remove_stack_t = t + timer
			else
				template_data.remove_stack_t = nil
			end
		end
	end
}

function _fanatic_rage_add_stack(template_data, template_context)
	local current_resource = template_data.specialization_resource_component.current_resource
	local max_resource = template_data.specialization_resource_component.max_resource
	local t = Managers.time:time("gameplay")
	current_resource = math.min(max_resource, current_resource + 1)

	if current_resource == max_resource then
		template_data.buff_extension:add_internally_controlled_buff("zealot_preacher_fanatic_rage_buff", t)
	end

	template_data.specialization_resource_component.current_resource = current_resource
	template_data.remove_stack_t = t + out_of_combat_time
end

templates.zealot_preacher_fanatic_rage_buff = {
	refresh_duration_on_stack = true,
	max_stacks_cap = 1,
	hud_priority = 1,
	predicted = false,
	hud_icon = "content/ui/textures/icons/buffs/hud/states_fire_buff_hud",
	max_stacks = 1,
	class_name = "buff",
	duration = out_of_combat_time,
	stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.15
	},
	conditional_stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.1
	},
	start_func = function (template_data, template_context)
		local specialization_extension = ScriptUnit.extension(template_context.unit, "specialization_system")
		template_data.conditional_stat_buff_active = specialization_extension:has_special_rule(special_rules.zealot_preacher_increased_crit_chance)
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.conditional_stat_buff_active
	end,
	player_effects = {
		on_screen_effect = "content/fx/particles/screenspace/screen_zealot_preacher_rage"
	}
}
templates.zealot_preacher_damage_vs_disgusting = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.disgustingly_resilient_damage] = 0.2
	}
}
local corruption_heal_amount = 0.5
templates.zealot_preacher_coherency_corruption_healing = {
	interval = 1,
	predicted = false,
	class_name = "interval_buff",
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.health_extension = ScriptUnit.extension(unit, "health_system")
	end,
	interval_function = function (template_data, template_context, template)
		if not template_context.is_server then
			return
		end

		template_data.health_extension:reduce_permanent_damage(corruption_heal_amount)
	end
}
templates.zealot_preacher_reduce_corruption_damage = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.corruption_taken_multiplier] = 0.5
	}
}
templates.zealot_preacher_shield = {
	max_stacks = 1,
	duration = 5,
	predicted = false,
	refresh_duration_on_stack = true,
	class_name = "buff",
	keywords = {
		keywords.slowdown_immune,
		keywords.stun_immune,
		keywords.suppression_immune,
		keywords.uninterruptible,
		keywords.damage_immune
	},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		Toughness.replenish_percentage(template_context.unit, 1)
	end,
	stop_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local world = template_context.world
		local physics_world = World.physics_world(world)
		local explosion_template = ExplosionTemplates.zealot_preacher_shield_explosion
		local power_level = 500
		local position = POSITION_LOOKUP[unit]
		local attack_type = AttackSettings.attack_types.explosion

		Explosion.create_explosion(world, physics_world, position, Vector3.up(), unit, explosion_template, power_level, 1, attack_type)
	end
}
templates.zealot_preacher_shield_long_duration = table.clone(templates.zealot_preacher_shield)
templates.zealot_preacher_shield_long_duration.duration = 8
templates.zealot_preacher_shield_coherency = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	duration = 5,
	stat_buffs = {
		[stat_buffs.damage] = 0.25
	}
}
templates.zealot_preacher_impact_power = {
	predicted = false,
	max_stacks_cap = 1,
	max_stacks = 1,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.impact_modifier] = 0.25
	}
}
templates.zealot_preacher_increased_toughness = {
	predicted = false,
	max_stacks_cap = 1,
	max_stacks = 1,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.toughness] = 50
	}
}
templates.zealot_preacher_more_segments = {
	predicted = false,
	max_stacks_cap = 1,
	max_stacks = 1,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.extra_max_amount_of_wounds] = 1
	}
}
local ZEALOT_PREACHER_MELEE_INCREASE_NEXT_MELEE_BUFF_ID = "zealot_preacher_melee_increase_next_melee_buff"
templates.zealot_preacher_melee_increase_next_melee_proc = {
	predicted = false,
	max_stacks_cap = 1,
	max_stacks = 1,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_sweep] = 1
	},
	proc_func = function (params, template_data, template_context)
		local num_hit_units = math.min(params.num_hit_units, 5)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.has_extension(unit, "buff_system")
		local has_buff = buff_extension and buff_extension:has_buff_id(ZEALOT_PREACHER_MELEE_INCREASE_NEXT_MELEE_BUFF_ID)

		if buff_extension and num_hit_units > 0 and not has_buff then
			local t = Managers.time:time("gameplay")

			buff_extension:add_internally_controlled_buff_with_stacks("zealot_preacher_melee_increase_next_melee_buff", num_hit_units, t)
		end
	end
}
templates.zealot_preacher_melee_increase_next_melee_buff = {
	max_stacks_cap = 5,
	predicted = false,
	hud_priority = 2,
	hud_icon = "content/ui/textures/icons/buffs/hud/frame",
	max_stacks = 5,
	class_name = "proc_buff",
	buff_id = ZEALOT_PREACHER_MELEE_INCREASE_NEXT_MELEE_BUFF_ID,
	proc_events = {
		[proc_events.on_sweep] = 1
	},
	stat_buffs = {
		[stat_buffs.melee_damage] = 0.05
	},
	proc_func = function (params, template_data, template_context)
		template_data.exit = true
	end,
	conditional_exit_func = function (template_data, template_context)
		return template_data.exit
	end
}
templates.zealot_preacher_toughness_damage_reduction_per_wound = {
	max_stacks_cap = 1,
	hud_priority = 1,
	predicted = false,
	max_stacks = 1,
	class_name = "stepped_stat_buff",
	keywords = {},
	stepped_stat_buffs = {
		{
			[stat_buffs.toughness_damage_taken_modifier] = 0
		},
		{
			[stat_buffs.toughness_damage_taken_modifier] = 0.1
		},
		{
			[stat_buffs.toughness_damage_taken_modifier] = 0.2
		},
		{
			[stat_buffs.toughness_damage_taken_modifier] = 0.3
		},
		{
			[stat_buffs.toughness_damage_taken_modifier] = 0.4
		},
		{
			[stat_buffs.toughness_damage_taken_modifier] = 0.5
		}
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.health_extension = ScriptUnit.extension(unit, "health_system")
	end,
	min_max_step_func = function (template_data, template_context)
		local health_extension = template_data.health_extension
		local max_wounds = health_extension:max_wounds()

		return 0, max_wounds
	end,
	bonus_step_func = function (template_data, template_context)
		local health_extension = template_data.health_extension
		local max_wounds = health_extension:max_wounds()
		local wounds_remaning = health_extension:num_wounds()
		local wounds_missing = max_wounds - wounds_remaning

		return wounds_missing
	end
}

return templates
