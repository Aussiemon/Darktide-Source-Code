-- chunkname: @scripts/settings/buff/player_buff_templates.lua

local Attack = require("scripts/utilities/attack/attack")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local Stamina = require("scripts/utilities/attack/stamina")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local buff_proc_events = BuffSettings.proc_events
local buff_stat_buffs = BuffSettings.stat_buffs
local keywords = BuffSettings.keywords
local special_rules = SpecialRulesSettings.special_rules
local stat_buffs = BuffSettings.stat_buffs
local zealot_1 = TalentSettings.zealot_1
local templates = {}

table.make_unique(templates)

templates.knocked_down_damage_reduction = {
	class_name = "buff",
	predicted = false,
	lerped_stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = {
			max = 1,
			min = 0,
		},
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
	end,
}

local MIN_DISTANCE_SQUARED = 2500
local MAX_DISTANCE_SQUARED = 22500
local MIN_POWER_LEVEL = PowerLevelSettings.default_power_level
local MAX_POWER_LEVEL = PowerLevelSettings.max_power_level

templates.knocked_down_damage_tick = {
	class_name = "interval_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/states_knocked_down_buff_hud",
	hud_priority = 1,
	interval = 2,
	is_negative = true,
	predicted = false,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.health_extension = ScriptUnit.extension(unit, "health_system")

		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.assisted_state_input = unit_data_extension:read_component("assisted_state_input")
	end,
	interval_func = function (template_data, template_context)
		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return
		end

		local assisted_state_input = template_data.assisted_state_input
		local is_being_assisted = assisted_state_input and PlayerUnitStatus.is_assisted(assisted_state_input)

		if is_being_assisted then
			return
		end

		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local player_units = side.valid_player_units
		local position = POSITION_LOOKUP[unit]
		local closest_distance = math.huge

		for ii = 1, #player_units do
			local player_unit = player_units[ii]

			if player_unit ~= unit then
				local player_unit_position = POSITION_LOOKUP[player_unit]
				local distance_squared = Vector3.distance_squared(position, player_unit_position)

				if distance_squared < closest_distance then
					closest_distance = distance_squared
				end
			end
		end

		local lerp_t = math.normalize_01(closest_distance, MIN_DISTANCE_SQUARED, MAX_DISTANCE_SQUARED)
		local power_level = math.lerp(MIN_POWER_LEVEL, MAX_POWER_LEVEL, lerp_t)
		local damage_profile = DamageProfileTemplates.knocked_down_tick
		local target_index = 1
		local target_number = 1
		local is_critical_strike = false

		Attack.execute(unit, damage_profile, "target_index", target_index, "target_number", target_number, "power_level", power_level, "is_critical_strike", is_critical_strike)
	end,
}
templates.netted_damage_tick = {
	class_name = "interval_buff",
	interval = 5,
	predicted = false,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.health_extension = ScriptUnit.extension(unit, "health_system")

		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.assisted_state_input = unit_data_extension:read_component("assisted_state_input")
		template_data.num_ticks = 1
	end,
	power_level = {
		200,
		250,
		300,
		350,
		350,
	},
	ticks_to_full_power_level = {
		12,
		10,
		8,
		7,
		7,
	},
	interval_func = function (template_data, template_context)
		local assisted_state_input = template_data.assisted_state_input
		local is_being_assisted = assisted_state_input and PlayerUnitStatus.is_assisted(assisted_state_input)

		if is_being_assisted then
			return
		end

		local unit = template_context.unit

		if HEALTH_ALIVE[unit] then
			local template = template_context.template
			local num_ticks = template_data.num_ticks

			template_data.num_ticks = num_ticks + 1

			local max_power_level = Managers.state.difficulty:get_table_entry_by_challenge(template.power_level)
			local ticks_to_max_power_level = Managers.state.difficulty:get_table_entry_by_challenge(template.ticks_to_full_power_level)
			local power_level = max_power_level * math.min(1, num_ticks / ticks_to_max_power_level)
			local damage_profile = DamageProfileTemplates.netted_tick

			Attack.execute(unit, damage_profile, "power_level", power_level)
		end
	end,
	player_effects = {
		effect_template = EffectTemplates.netted,
	},
}
templates.grimoire_damage_tick = {
	class_name = "grimoire_buff",
	predicted = false,
}
templates.weakspot_kill_reload_speed = {
	active_duration = 5,
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[buff_proc_events.on_kill] = 0.5,
	},
	proc_stat_buffs = {
		[buff_stat_buffs.reload_speed] = 0.5,
	},
	check_proc_func = CheckProcFunctions.on_weakspot_kill,
}
templates.coherency_toughness_regen = {
	class_name = "stepped_stat_buff",
	description = "Increased thoughness regeneration while near squad members.\nEffect stacks with each member nearby.",
	display_description = "loc_player_buff_coherency_toughness_regen_desc",
	display_title = "loc_player_buff_coherency_toughness_regen",
	hud_icon = "content/ui/textures/icons/buffs/hud/states_coherence_buff_hud",
	hud_priority = 0,
	max_stacks = 8,
	predicted = false,
	title = "Coherency",
	keywords = {},
	stepped_stat_buffs = {
		{
			[buff_stat_buffs.toughness_coherency_regen_rate_modifier] = 0,
		},
		{
			[buff_stat_buffs.toughness_coherency_regen_rate_modifier] = 0.5,
		},
		{
			[buff_stat_buffs.toughness_coherency_regen_rate_modifier] = 0.75,
		},
		{
			[buff_stat_buffs.toughness_coherency_regen_rate_modifier] = 1,
		},
		{
			[buff_stat_buffs.toughness_coherency_regen_rate_modifier] = 1.25,
		},
		{
			[buff_stat_buffs.toughness_coherency_regen_rate_modifier] = 1.5,
		},
		{
			[buff_stat_buffs.toughness_coherency_regen_rate_modifier] = 1.75,
		},
		{
			[buff_stat_buffs.toughness_coherency_regen_rate_modifier] = 2,
		},
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.talent_extension = ScriptUnit.extension(unit, "talent_system")
	end,
	min_max_step_func = function (template_data, template_context)
		local talent_extension = template_data.talent_extension

		if talent_extension and talent_extension:has_special_rule(special_rules.zealot_always_at_least_one_coherency) then
			return zealot_1.coherency.toughness_min_stack_override
		end

		if talent_extension and talent_extension:has_special_rule(special_rules.zealot_always_at_least_two_coherency) then
			return 3
		end

		return 0, nil
	end,
}
templates.sprint_with_stamina_buff = {
	class_name = "buff",
	description = "Increased sprint by consuming available stamina.",
	display_description = "loc_player_buff_sprint_with_stamina_buff_desc",
	display_title = "loc_player_buff_sprint_with_stamina_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/states_sprint_buff_hud",
	predicted = false,
	title = "Better run faster!",
	hud_priority = math.huge,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local archetype = unit_data_extension:archetype()
		local base_stamina_template = archetype.stamina

		template_data.base_stamina_template = base_stamina_template
		template_data.stamina_component = unit_data_extension:read_component("stamina")
		template_data.sprint_character_state_component = unit_data_extension:read_component("sprint_character_state")
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		local unit = template_context.unit
		local current_stamina, _ = Stamina.current_and_max_value(unit, template_data.stamina_component, template_data.base_stamina_template)
		local is_sprinting = Sprint.is_sprinting(template_data.sprint_character_state_component)

		return is_sprinting and current_stamina > 0
	end,
}
templates.no_toughness_damage_buff = {
	class_name = "proc_buff",
	predicted = false,
	stat_buffs = {
		[buff_stat_buffs.toughness_damage_taken_multiplier] = 0,
	},
	proc_events = {
		[buff_proc_events.on_lunge_end] = 1,
	},
	proc_func = function (params, template_data)
		template_data.finish = true
	end,
	conditional_exit_func = function (template_data)
		return template_data.finish
	end,
}
templates.player_spawn_grace = {
	class_name = "buff",
	duration = 5,
	hud_icon = "content/ui/textures/icons/buffs/hud/states_grace_time_hud",
	predicted = false,
	keywords = {
		keywords.unperceivable,
	},
	stat_buffs = {
		[buff_stat_buffs.damage_taken_multiplier] = 0,
	},
}
templates.player_toughness_node_buff_low_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness] = 7.5,
	},
	talent_overrides = {
		{
			stat_buffs = {
				[stat_buffs.toughness] = 15,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.toughness] = 20,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.toughness] = 25,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.toughness] = 30,
			},
		},
	},
}
templates.player_toughness_node_buff_low_2 = table.clone(templates.player_toughness_node_buff_low_1)
templates.player_toughness_node_buff_low_3 = table.clone(templates.player_toughness_node_buff_low_1)
templates.player_toughness_node_buff_low_4 = table.clone(templates.player_toughness_node_buff_low_1)
templates.player_toughness_node_buff_low_5 = table.clone(templates.player_toughness_node_buff_low_1)
templates.player_toughness_node_buff_medium_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness] = 15,
	},
	talent_overrides = {
		{
			stat_buffs = {
				[stat_buffs.toughness] = 25,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.toughness] = 30,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.toughness] = 45,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.toughness] = 60,
			},
		},
	},
}
templates.player_toughness_node_buff_medium_2 = table.clone(templates.player_toughness_node_buff_medium_1)
templates.player_toughness_node_buff_medium_3 = table.clone(templates.player_toughness_node_buff_medium_1)
templates.player_toughness_node_buff_medium_4 = table.clone(templates.player_toughness_node_buff_medium_1)
templates.player_toughness_node_buff_medium_5 = table.clone(templates.player_toughness_node_buff_medium_1)
templates.player_toughness_damage_reduction_node_buff_low_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_modifier] = -0.05,
	},
	talent_overrides = {
		{
			stat_buffs = {
				[stat_buffs.toughness_damage_taken_modifier] = -0.05,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.toughness_damage_taken_modifier] = -0.1,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.toughness_damage_taken_modifier] = -0.15,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.toughness_damage_taken_modifier] = -0.2,
			},
		},
	},
}
templates.player_toughness_damage_reduction_node_buff_low_2 = table.clone(templates.player_toughness_damage_reduction_node_buff_low_1)
templates.player_toughness_damage_reduction_node_buff_low_3 = table.clone(templates.player_toughness_damage_reduction_node_buff_low_1)
templates.player_toughness_damage_reduction_node_buff_low_4 = table.clone(templates.player_toughness_damage_reduction_node_buff_low_1)
templates.player_toughness_damage_reduction_node_buff_low_5 = table.clone(templates.player_toughness_damage_reduction_node_buff_low_1)
templates.player_toughness_damage_reduction_node_buff_medium_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_modifier] = -0.1,
	},
	talent_overrides = {
		{
			stat_buffs = {
				[stat_buffs.toughness_damage_taken_modifier] = -0.1,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.toughness_damage_taken_modifier] = -0.2,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.toughness_damage_taken_modifier] = -0.3,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.toughness_damage_taken_modifier] = -0.4,
			},
		},
	},
}
templates.player_toughness_damage_reduction_node_buff_medium_2 = table.clone(templates.player_toughness_damage_reduction_node_buff_medium_1)
templates.player_toughness_damage_reduction_node_buff_medium_3 = table.clone(templates.player_toughness_damage_reduction_node_buff_medium_1)
templates.player_toughness_damage_reduction_node_buff_medium_4 = table.clone(templates.player_toughness_damage_reduction_node_buff_medium_1)
templates.player_toughness_damage_reduction_node_buff_medium_5 = table.clone(templates.player_toughness_damage_reduction_node_buff_medium_1)
templates.player_ranged_toughness_damage_reduction_node_buff_medium_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.ranged_toughness_damage_taken_modifier] = -0.1,
	},
	talent_overrides = {
		{
			stat_buffs = {
				[stat_buffs.ranged_toughness_damage_taken_modifier] = -0.1,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.ranged_toughness_damage_taken_modifier] = -0.2,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.ranged_toughness_damage_taken_modifier] = -0.3,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.ranged_toughness_damage_taken_modifier] = -0.4,
			},
		},
	},
}
templates.player_ranged_toughness_damage_reduction_node_buff_medium_2 = table.clone(templates.player_ranged_toughness_damage_reduction_node_buff_medium_1)
templates.player_ranged_toughness_damage_reduction_node_buff_medium_3 = table.clone(templates.player_ranged_toughness_damage_reduction_node_buff_medium_1)
templates.player_ranged_toughness_damage_reduction_node_buff_medium_4 = table.clone(templates.player_ranged_toughness_damage_reduction_node_buff_medium_1)
templates.player_ranged_toughness_damage_reduction_node_buff_medium_5 = table.clone(templates.player_ranged_toughness_damage_reduction_node_buff_medium_1)
templates.player_melee_toughness_damage_reduction_node_buff_medium_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_modifier] = -0.1,
	},
	talent_overrides = {
		{
			stat_buffs = {
				[stat_buffs.toughness_damage_taken_modifier] = -0.1,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.toughness_damage_taken_modifier] = -0.2,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.toughness_damage_taken_modifier] = -0.3,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.toughness_damage_taken_modifier] = -0.4,
			},
		},
	},
}
templates.player_melee_toughness_damage_reduction_node_buff_medium_2 = table.clone(templates.player_melee_toughness_damage_reduction_node_buff_medium_1)
templates.player_melee_toughness_damage_reduction_node_buff_medium_3 = table.clone(templates.player_melee_toughness_damage_reduction_node_buff_medium_1)
templates.player_melee_toughness_damage_reduction_node_buff_medium_4 = table.clone(templates.player_melee_toughness_damage_reduction_node_buff_medium_1)
templates.player_melee_toughness_damage_reduction_node_buff_medium_5 = table.clone(templates.player_melee_toughness_damage_reduction_node_buff_medium_1)
templates.reduced_stamina_regen_delay_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.stamina_regeneration_delay] = -0.25,
	},
}
templates.reduced_stamina_regen_delay_2 = table.clone(templates.reduced_stamina_regen_delay_1)
templates.reduced_stamina_regen_delay_3 = table.clone(templates.reduced_stamina_regen_delay_1)
templates.reduced_stamina_regen_delay_4 = table.clone(templates.reduced_stamina_regen_delay_1)
templates.reduced_stamina_regen_delay_5 = table.clone(templates.reduced_stamina_regen_delay_1)
templates.player_armor_pen_node_buff_low_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.rending_multiplier] = 0.05,
	},
	talent_overrides = {
		{
			stat_buffs = {
				[stat_buffs.rending_multiplier] = 0.05,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.rending_multiplier] = 0.1,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.rending_multiplier] = 0.15,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.rending_multiplier] = 0.2,
			},
		},
	},
}
templates.player_armor_pen_node_buff_low_2 = table.clone(templates.player_armor_pen_node_buff_low_1)
templates.player_armor_pen_node_buff_low_3 = table.clone(templates.player_armor_pen_node_buff_low_1)
templates.player_armor_pen_node_buff_low_4 = table.clone(templates.player_armor_pen_node_buff_low_1)
templates.player_armor_pen_node_buff_low_5 = table.clone(templates.player_armor_pen_node_buff_low_1)
templates.player_stamina_node_buff_low_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.stamina_modifier] = 1,
	},
	talent_overrides = {
		{
			stat_buffs = {
				[stat_buffs.stamina_modifier] = 1,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.stamina_modifier] = 2,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.stamina_modifier] = 3,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.stamina_modifier] = 4,
			},
		},
	},
}
templates.player_stamina_node_buff_low_2 = table.clone(templates.player_stamina_node_buff_low_1)
templates.player_stamina_node_buff_low_3 = table.clone(templates.player_stamina_node_buff_low_1)
templates.player_stamina_node_buff_low_4 = table.clone(templates.player_stamina_node_buff_low_1)
templates.player_stamina_node_buff_low_5 = table.clone(templates.player_stamina_node_buff_low_1)
templates.player_crit_chance_node_buff_low_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.05,
	},
	talent_overrides = {
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.05,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.1,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.15,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.2,
			},
		},
	},
}
templates.player_crit_chance_node_buff_low_2 = table.clone(templates.player_crit_chance_node_buff_low_1)
templates.player_crit_chance_node_buff_low_3 = table.clone(templates.player_crit_chance_node_buff_low_1)
templates.player_crit_chance_node_buff_low_4 = table.clone(templates.player_crit_chance_node_buff_low_1)
templates.player_crit_chance_node_buff_low_5 = table.clone(templates.player_crit_chance_node_buff_low_1)
templates.player_movement_speed_node_buff_low_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.movement_speed] = 0.05,
	},
	talent_overrides = {
		{
			stat_buffs = {
				[stat_buffs.movement_speed] = 0.05,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.movement_speed] = 0.1,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.movement_speed] = 0.15,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.movement_speed] = 0.2,
			},
		},
	},
}
templates.player_movement_speed_node_buff_low_2 = table.clone(templates.player_movement_speed_node_buff_low_1)
templates.player_movement_speed_node_buff_low_3 = table.clone(templates.player_movement_speed_node_buff_low_1)
templates.player_movement_speed_node_buff_low_4 = table.clone(templates.player_movement_speed_node_buff_low_1)
templates.player_movement_speed_node_buff_low_5 = table.clone(templates.player_movement_speed_node_buff_low_1)
templates.player_coherency_regen_node_buff_low_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness_regen_rate_modifier] = 0.1,
	},
	talent_overrides = {
		{
			stat_buffs = {
				[stat_buffs.toughness_regen_rate_modifier] = 0.1,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.toughness_regen_rate_modifier] = 0.2,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.toughness_regen_rate_modifier] = 0.3,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.toughness_regen_rate_modifier] = 0.4,
			},
		},
	},
}
templates.player_coherency_regen_node_buff_low_2 = table.clone(templates.player_coherency_regen_node_buff_low_1)
templates.player_coherency_regen_node_buff_low_3 = table.clone(templates.player_coherency_regen_node_buff_low_1)
templates.player_coherency_regen_node_buff_low_4 = table.clone(templates.player_coherency_regen_node_buff_low_1)
templates.player_coherency_regen_node_buff_low_5 = table.clone(templates.player_coherency_regen_node_buff_low_1)
templates.player_warp_charge_node_buff_low_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.warp_charge_amount] = 0.95,
	},
	talent_overrides = {
		{
			stat_buffs = {
				[stat_buffs.warp_charge_amount] = 0.95,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.warp_charge_amount] = 0.9,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.warp_charge_amount] = 0.85,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.warp_charge_amount] = 0.8,
			},
		},
	},
}
templates.player_warp_charge_node_buff_low_2 = table.clone(templates.player_warp_charge_node_buff_low_1)
templates.player_warp_charge_node_buff_low_3 = table.clone(templates.player_warp_charge_node_buff_low_1)
templates.player_warp_charge_node_buff_low_4 = table.clone(templates.player_warp_charge_node_buff_low_1)
templates.player_warp_charge_node_buff_low_5 = table.clone(templates.player_warp_charge_node_buff_low_1)
templates.player_health_node_buff_low_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.max_health_modifier] = 0.05,
	},
	talent_overrides = {
		{
			stat_buffs = {
				[stat_buffs.max_health_modifier] = 0.05,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.max_health_modifier] = 0.1,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.max_health_modifier] = 0.15,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.max_health_modifier] = 0.2,
			},
		},
	},
}
templates.player_health_node_buff_low_2 = table.clone(templates.player_health_node_buff_low_1)
templates.player_health_node_buff_low_3 = table.clone(templates.player_health_node_buff_low_1)
templates.player_health_node_buff_low_4 = table.clone(templates.player_health_node_buff_low_1)
templates.player_health_node_buff_low_5 = table.clone(templates.player_health_node_buff_low_1)
templates.player_health_node_buff_medium_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.max_health_modifier] = 0.1,
	},
	talent_overrides = {
		{
			stat_buffs = {
				[stat_buffs.max_health_modifier] = 0.1,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.max_health_modifier] = 0.2,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.max_health_modifier] = 0.3,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.max_health_modifier] = 0.4,
			},
		},
	},
}
templates.player_health_node_buff_medium_2 = table.clone(templates.player_health_node_buff_medium_1)
templates.player_health_node_buff_medium_3 = table.clone(templates.player_health_node_buff_medium_1)
templates.player_health_node_buff_medium_4 = table.clone(templates.player_health_node_buff_medium_1)
templates.player_health_node_buff_medium_5 = table.clone(templates.player_health_node_buff_medium_1)
templates.player_melee_damage_node_buff_low_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.melee_damage] = 0.05,
	},
	talent_overrides = {
		{
			stat_buffs = {
				[stat_buffs.melee_damage] = 0.05,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.melee_damage] = 0.1,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.melee_damage] = 0.15,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.melee_damage] = 0.2,
			},
		},
	},
}
templates.player_melee_damage_node_buff_low_2 = table.clone(templates.player_melee_damage_node_buff_low_1)
templates.player_melee_damage_node_buff_low_3 = table.clone(templates.player_melee_damage_node_buff_low_1)
templates.player_melee_damage_node_buff_low_4 = table.clone(templates.player_melee_damage_node_buff_low_1)
templates.player_melee_damage_node_buff_low_5 = table.clone(templates.player_melee_damage_node_buff_low_1)
templates.player_impact_node_buff_medium_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.impact_modifier] = 0.25,
	},
	talent_overrides = {
		{
			stat_buffs = {
				[stat_buffs.impact_modifier] = 0.25,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.impact_modifier] = 0.25,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.impact_modifier] = 0.25,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.impact_modifier] = 0.25,
			},
		},
	},
}
templates.player_cleave_node_buff_medium_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.max_hit_mass_attack_modifier] = 0.25,
		[stat_buffs.max_hit_mass_impact_modifier] = 0.25,
	},
	talent_overrides = {
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 0.25,
				[stat_buffs.max_hit_mass_impact_modifier] = 0.25,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 0.25,
				[stat_buffs.max_hit_mass_impact_modifier] = 0.25,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 0.25,
				[stat_buffs.max_hit_mass_impact_modifier] = 0.25,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 0.25,
				[stat_buffs.max_hit_mass_impact_modifier] = 0.25,
			},
		},
	},
}
templates.player_melee_damage_node_buff_medium_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.melee_damage] = 0.1,
	},
	talent_overrides = {
		{
			stat_buffs = {
				[stat_buffs.melee_damage] = 0.1,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.melee_damage] = 0.2,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.melee_damage] = 0.3,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.melee_damage] = 0.4,
			},
		},
	},
}
templates.player_melee_damage_node_buff_medium_2 = table.clone(templates.player_melee_damage_node_buff_medium_1)
templates.player_melee_damage_node_buff_medium_3 = table.clone(templates.player_melee_damage_node_buff_medium_1)
templates.player_melee_damage_node_buff_medium_4 = table.clone(templates.player_melee_damage_node_buff_medium_1)
templates.player_melee_damage_node_buff_medium_5 = table.clone(templates.player_melee_damage_node_buff_medium_1)
templates.player_melee_heavy_damage_node_buff_low_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.melee_heavy_damage] = 0.05,
	},
	talent_overrides = {
		{
			stat_buffs = {
				[stat_buffs.melee_heavy_damage] = 0.05,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.melee_heavy_damage] = 0.1,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.melee_heavy_damage] = 0.15,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.melee_heavy_damage] = 0.2,
			},
		},
	},
}
templates.player_melee_heavy_damage_node_buff_low_2 = table.clone(templates.player_melee_heavy_damage_node_buff_low_1)
templates.player_melee_heavy_damage_node_buff_low_3 = table.clone(templates.player_melee_heavy_damage_node_buff_low_1)
templates.player_melee_heavy_damage_node_buff_low_4 = table.clone(templates.player_melee_heavy_damage_node_buff_low_1)
templates.player_melee_heavy_damage_node_buff_low_5 = table.clone(templates.player_melee_heavy_damage_node_buff_low_1)
templates.player_melee_heavy_damage_node_buff_medium_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.melee_heavy_damage] = 0.1,
	},
	talent_overrides = {
		{
			stat_buffs = {
				[stat_buffs.melee_heavy_damage] = 0.1,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.melee_heavy_damage] = 0.2,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.melee_heavy_damage] = 0.3,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.melee_heavy_damage] = 0.4,
			},
		},
	},
}
templates.player_melee_heavy_damage_node_buff_medium_2 = table.clone(templates.player_melee_heavy_damage_node_buff_medium_1)
templates.player_melee_heavy_damage_node_buff_medium_3 = table.clone(templates.player_melee_heavy_damage_node_buff_medium_1)
templates.player_melee_heavy_damage_node_buff_medium_4 = table.clone(templates.player_melee_heavy_damage_node_buff_medium_1)
templates.player_melee_heavy_damage_node_buff_medium_5 = table.clone(templates.player_melee_heavy_damage_node_buff_medium_1)
templates.player_ranged_damage_node_buff_low_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.ranged_damage] = 0.05,
	},
	talent_overrides = {
		{
			stat_buffs = {
				[stat_buffs.ranged_damage] = 0.05,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.ranged_damage] = 0.1,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.ranged_damage] = 0.15,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.ranged_damage] = 0.2,
			},
		},
	},
}
templates.player_ranged_damage_node_buff_low_2 = table.clone(templates.player_ranged_damage_node_buff_low_1)
templates.player_ranged_damage_node_buff_low_3 = table.clone(templates.player_ranged_damage_node_buff_low_1)
templates.player_ranged_damage_node_buff_low_4 = table.clone(templates.player_ranged_damage_node_buff_low_1)
templates.player_ranged_damage_node_buff_low_5 = table.clone(templates.player_ranged_damage_node_buff_low_1)
templates.player_ranged_damage_node_buff_medium_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.ranged_damage] = 0.1,
	},
	talent_overrides = {
		{
			stat_buffs = {
				[stat_buffs.ranged_damage] = 0.1,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.ranged_damage] = 0.2,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.ranged_damage] = 0.3,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.ranged_damage] = 0.4,
			},
		},
	},
}
templates.player_ranged_damage_node_buff_medium_2 = table.clone(templates.player_ranged_damage_node_buff_medium_1)
templates.player_ranged_damage_node_buff_medium_3 = table.clone(templates.player_ranged_damage_node_buff_medium_1)
templates.player_ranged_damage_node_buff_medium_4 = table.clone(templates.player_ranged_damage_node_buff_medium_1)
templates.player_ranged_damage_node_buff_medium_5 = table.clone(templates.player_ranged_damage_node_buff_medium_1)
templates.player_reload_speed_node_buff_low_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.reload_speed] = 0.05,
	},
	talent_overrides = {
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.05,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.1,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.15,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.2,
			},
		},
	},
}
templates.player_reload_speed_node_buff_low_2 = table.clone(templates.player_reload_speed_node_buff_low_1)
templates.player_reload_speed_node_buff_low_3 = table.clone(templates.player_reload_speed_node_buff_low_1)
templates.player_reload_speed_node_buff_low_4 = table.clone(templates.player_reload_speed_node_buff_low_1)
templates.player_reload_speed_node_buff_low_5 = table.clone(templates.player_reload_speed_node_buff_low_1)
templates.player_reload_speed_node_buff_medium_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.reload_speed] = 0.1,
	},
	talent_overrides = {
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.1,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.2,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.3,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.4,
			},
		},
	},
}
templates.player_reload_speed_node_buff_medium_2 = table.clone(templates.player_reload_speed_node_buff_medium_1)
templates.player_reload_speed_node_buff_medium_3 = table.clone(templates.player_reload_speed_node_buff_medium_1)
templates.player_reload_speed_node_buff_medium_4 = table.clone(templates.player_reload_speed_node_buff_medium_1)
templates.player_reload_speed_node_buff_medium_5 = table.clone(templates.player_reload_speed_node_buff_medium_1)
templates.player_suppression_node_buff_low_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.suppression_dealt] = 0.25,
	},
	talent_overrides = {
		{
			stat_buffs = {
				[stat_buffs.suppression_dealt] = 0.25,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.suppression_dealt] = 0.3,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.suppression_dealt] = 0.35,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.suppression_dealt] = 0.4,
			},
		},
	},
}
templates.player_suppression_node_buff_low_2 = table.clone(templates.player_suppression_node_buff_low_1)
templates.player_suppression_node_buff_low_3 = table.clone(templates.player_suppression_node_buff_low_1)
templates.player_suppression_node_buff_low_4 = table.clone(templates.player_suppression_node_buff_low_1)
templates.player_suppression_node_buff_low_5 = table.clone(templates.player_suppression_node_buff_low_1)
templates.player_wounds_node_buff_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.extra_max_amount_of_wounds] = 1,
	},
}
templates.player_wounds_node_buff_2 = table.clone(templates.player_wounds_node_buff_1)
templates.player_wounds_node_buff_2.stats_buffs = {
	[stat_buffs.extra_max_amount_of_wounds] = 2,
}
templates.player_stamina_node_buff_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.stamina_modifier] = 1,
	},
}
templates.player_stamina_node_buff_2 = table.clone(templates.player_stamina_node_buff_1)
templates.player_stamina_node_buff_2.stats_buffs = {
	[stat_buffs.stamina_modifier] = 2,
}
templates.player_max_warp_charge_node_buff_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.warp_charge_amount] = 1,
	},
}
templates.player_max_warp_charge_node_buff_2 = table.clone(templates.player_max_warp_charge_node_buff_1)
templates.player_max_warp_charge_node_buff_2.stats_buffs = {
	[stat_buffs.warp_charge_amount] = 2,
}
templates.player_dodge_count_node_buff_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.extra_consecutive_dodges] = 1,
	},
}
templates.player_dodge_count_node_buff_2 = table.clone(templates.player_dodge_count_node_buff_1)
templates.player_dodge_count_node_buff_2.stats_buffs = {
	[stat_buffs.extra_consecutive_dodges] = 2,
}
templates.player_crit_chance_node_buff_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.critical_strike_chance] = 0.1,
	},
}
templates.player_crit_chance_node_buff_2 = table.clone(templates.player_crit_chance_node_buff_1)
templates.player_crit_chance_node_buff_2.stats_buffs = {
	[stat_buffs.critical_strike_chance] = 0.2,
}
templates.player_max_ammo_node_buff_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.ammo_reserve_capacity] = 0.15,
	},
}
templates.player_max_ammo_node_buff_2 = table.clone(templates.player_max_ammo_node_buff_1)
templates.player_coherency_regen_node_buff_1 = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.toughness_coherency_regen_rate_multiplier] = 0.1,
	},
}
templates.player_coherency_regen_node_buff_2 = table.clone(templates.player_coherency_regen_node_buff_1)
templates.player_coherency_regen_node_buff_2.stats_buffs = {
	[stat_buffs.toughness_coherency_regen_rate_multiplier] = 0.2,
}

local valid_help_interactions = {
	pull_up = true,
	remove_net = true,
	rescue = true,
	revive = true,
}

local function _passive_revive_conditional(template_data, template_context)
	local is_interacting = template_data.interactor_extension:is_interacting()

	if is_interacting then
		local interaction = template_data.interactor_extension:interaction()
		local interaction_type = interaction:type()
		local is_helping = valid_help_interactions[interaction_type]

		return is_helping
	end
end

templates.bot_medium_buff = {
	class_name = "buff",
	predicted = false,
	keywords = {
		keywords.uninterruptible,
		keywords.stun_immune,
	},
	stat_buffs = {
		[stat_buffs.max_health_modifier] = 0.5,
		[stat_buffs.toughness] = 50,
		[stat_buffs.extra_max_amount_of_wounds] = 1,
		[buff_stat_buffs.toughness_regen_rate_modifier] = 0.15,
		[buff_stat_buffs.block_cost_multiplier] = 0.2,
	},
	conditional_keywords = {
		keywords.uninterruptible,
	},
	conditional_stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = 0.1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local interactor_extension = ScriptUnit.extension(unit, "interactor_system")

		template_data.interactor_extension = interactor_extension
	end,
	conditional_keywords_func = _passive_revive_conditional,
	conditional_stat_buffs_func = _passive_revive_conditional,
}
templates.bot_high_buff = {
	class_name = "buff",
	predicted = false,
	keywords = {
		keywords.uninterruptible,
		keywords.stun_immune,
	},
	stat_buffs = {
		[stat_buffs.max_health_modifier] = 0.8,
		[stat_buffs.toughness] = 100,
		[stat_buffs.extra_max_amount_of_wounds] = 2,
		[buff_stat_buffs.toughness_regen_rate_modifier] = 0.3,
		[buff_stat_buffs.block_cost_multiplier] = 0.2,
	},
	conditional_keywords = {
		keywords.uninterruptible,
	},
	conditional_stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = 0.1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local interactor_extension = ScriptUnit.extension(unit, "interactor_system")

		template_data.interactor_extension = interactor_extension
	end,
	conditional_keywords_func = _passive_revive_conditional,
	conditional_stat_buffs_func = _passive_revive_conditional,
}

return templates
