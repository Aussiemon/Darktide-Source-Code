local Attack = require("scripts/utilities/attack/attack")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctionTemplates = require("scripts/settings/buff/check_proc_function_templates")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local buff_proc_events = BuffSettings.proc_events
local buff_stat_buffs = BuffSettings.stat_buffs
local special_rules = SpecialRulesSetting.special_rules
local stat_buffs = BuffSettings.stat_buffs
local templates = {
	knocked_down_damage_reduction = {
		predicted = false,
		class_name = "buff",
		lerped_stat_buffs = {
			[stat_buffs.damage_taken_multiplier] = {
				max = 1,
				min = 0
			}
		},
		start_func = function (template_data, template_context)
			local unit = template_context.unit
			local health_extension = ScriptUnit.extension(unit, "health_system")
			template_data.health_extension = health_extension
		end,
		lerp_t_func = function (t, start_time, duration, template_data, template_context)
			local health_extension = template_data.health_extension
			local health_percentage = health_extension:current_health_percent()
			local active_duration = t - start_time
			local alive_t = 20
			local time_percent = 1 - math.min(active_duration, alive_t) / alive_t

			if time_percent <= 0 then
				return 1
			end

			if time_percent < health_percentage then
				local full_damage_percentage_diff = 0.2
				local lerp_t = math.min((health_percentage - time_percent) / full_damage_percentage_diff, 1)

				return lerp_t
			end

			return 0
		end
	},
	knocked_down_damage_tick = {
		interval = 2,
		hud_icon = "content/ui/textures/icons/buffs/hud/states_knocked_down_buff_hud",
		hud_priority = 1,
		class_name = "interval_buff",
		start_func = function (template_data, template_context)
			local unit = template_context.unit
			template_data.health_extension = ScriptUnit.extension(unit, "health_system")
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			template_data.assisted_state_input = unit_data_extension:read_component("assisted_state_input")
		end,
		interval_function = function (template_data, template_context)
			local assisted_state_input = template_data.assisted_state_input
			local is_being_assisted = assisted_state_input and PlayerUnitStatus.is_assisted(assisted_state_input)

			if is_being_assisted then
				return
			end

			local unit = template_context.unit

			if HEALTH_ALIVE[unit] then
				local damage_profile = DamageProfileTemplates.knocked_down_tick
				local target_index = 0
				local power_level = 500
				local has_power_boost = false
				local is_critical_strike = false

				Attack.execute(unit, damage_profile, "target_index", target_index, "power_level", power_level, "has_power_boost", has_power_boost, "is_critical_strike", is_critical_strike)
			end
		end
	},
	netted_damage_tick = {
		interval = 5,
		predicted = false,
		class_name = "interval_buff",
		start_func = function (template_data, template_context)
			local unit = template_context.unit
			template_data.health_extension = ScriptUnit.extension(unit, "health_system")
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			template_data.assisted_state_input = unit_data_extension:read_component("assisted_state_input")
		end,
		power_level = {
			50,
			50,
			100,
			100,
			150
		},
		interval_function = function (template_data, template_context)
			local assisted_state_input = template_data.assisted_state_input
			local is_being_assisted = assisted_state_input and PlayerUnitStatus.is_assisted(assisted_state_input)

			if is_being_assisted then
				return
			end

			local unit = template_context.unit

			if HEALTH_ALIVE[unit] then
				local template = template_context.template
				local power_level = Managers.state.difficulty:get_table_entry_by_challenge(template.power_level)
				local damage_profile = DamageProfileTemplates.netted_tick

				Attack.execute(unit, damage_profile, "power_level", power_level)
			end
		end,
		effects = {
			node_effects = {
				{
					node_name = "j_spine",
					vfx = {
						orphaned_policy = "destroy",
						particle_effect = "content/fx/particles/player_buffs/player_netted_idle",
						stop_type = "stop"
					}
				}
			}
		}
	},
	grimoire_damage_tick = {
		class_name = "grimoire_buff",
		predicted = false
	},
	weakspot_kill_reload_speed = {
		class_name = "proc_buff",
		active_duration = 5,
		proc_events = {
			[buff_proc_events.on_hit] = 0.5
		},
		proc_stat_buffs = {
			[buff_stat_buffs.reload_speed] = 0.5
		},
		check_proc_func = CheckProcFunctionTemplates.on_kill_weakspot
	},
	coherency_toughness_regen = {
		hud_priority = 1,
		predicted = false,
		hud_icon = "content/ui/textures/icons/buffs/hud/states_coherence_buff_hud",
		max_stacks = 4,
		class_name = "stepped_stat_buff",
		keywords = {},
		stepped_stat_buffs = {
			{
				[buff_stat_buffs.toughness_coherency_regen_rate_modifier] = 0
			},
			{
				[buff_stat_buffs.toughness_coherency_regen_rate_modifier] = 0.5
			},
			{
				[buff_stat_buffs.toughness_coherency_regen_rate_modifier] = 0.75
			},
			{
				[buff_stat_buffs.toughness_coherency_regen_rate_modifier] = 1
			}
		},
		start_func = function (template_data, template_context)
			local unit = template_context.unit
			template_data.specialization_extension = ScriptUnit.extension(unit, "specialization_system")
		end,
		min_max_step_func = function (template_data, template_context)
			local specialization_extension = template_data.specialization_extension
			local always_at_least_one_coherency = special_rules.always_at_least_one_coherency
			local has_at_least_one = specialization_extension:has_special_rule(always_at_least_one_coherency)
			local always_at_least_two_coherency = special_rules.always_at_least_two_coherency
			local has_at_least_two = specialization_extension:has_special_rule(always_at_least_two_coherency)
			local min = (has_at_least_two and 3) or (has_at_least_one and 2) or 0

			return min, nil
		end
	},
	no_toughness_damage_buff = {
		class_name = "proc_buff",
		stat_buffs = {
			[buff_stat_buffs.toughness_damage_taken_multiplier] = 0
		},
		proc_events = {
			[buff_proc_events.on_finished_lunge] = 1
		},
		proc_func = function (params, template_data)
			template_data.finish = true
		end,
		conditional_exit_func = function (template_data)
			return template_data.finish
		end
	}
}

return templates
