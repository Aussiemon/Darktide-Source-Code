local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctionTemplates = require("scripts/settings/buff/check_proc_function_templates")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local Health = require("scripts/utilities/health")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local TalentSettings = require("scripts/settings/buff/talent_settings")
local Toughness = require("scripts/utilities/toughness/toughness")
local damage_types = DamageSettings.damage_types
local attack_types = AttackSettings.attack_types
local keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local special_rules = SpecialRulesSetting.special_rules
local stat_buffs = BuffSettings.stat_buffs
local talent_settings = TalentSettings.zealot_2
local templates = {}
local martydom_health_step = talent_settings.passive_1.health_step
local martydom_damage_step = talent_settings.passive_1.damage_per_step
local martydom_damage_max = 1 / martydom_health_step * martydom_damage_step
local martydom_improved_damage_step = talent_settings.spec_passive_1.damage_per_step
local martydom_improved_damage_max = 1 / martydom_health_step * martydom_improved_damage_step
local martydom_healing_step = 0.05
local martydom_healing_max = 1 / martydom_health_step * martydom_healing_step
local martydom_movement_step = talent_settings.spec_passive_2.movement_per_step
local martydom_movement_max = 1 + 1 / martydom_health_step * martydom_movement_step
local martydom_damage_reduction_step = talent_settings.spec_passive_3.damage_reduction_per_step
local martydom_damage_reduction_max = 1 / martydom_health_step * martydom_damage_reduction_step
templates.zealot_maniac_martyrdom_base = {
	class_name = "special_rules_based_lerped_stat_buff",
	special_rules_lerped_stat_buffs = {
		[special_rules.martyrdom_increases_healing_received] = {
			[stat_buffs.healing_recieved_modifier] = {
				min = 0,
				max = martydom_healing_max
			}
		},
		[special_rules.martyrdom_increased_movement_speed] = {
			[stat_buffs.movement_speed] = {
				min = 1,
				max = martydom_movement_max
			}
		},
		[special_rules.martyrdom_decrease_damage_taken] = {
			[stat_buffs.damage_taken_multiplier] = {
				min = 1,
				max = 1 - martydom_damage_reduction_max
			}
		},
		[special_rules.martyrdom_increased_damage_output] = {
			[stat_buffs.melee_damage] = {
				min = 0,
				max = martydom_improved_damage_max
			}
		}
	},
	missing_special_rules_lerped_stat_buffs = {
		[special_rules.martyrdom_increased_damage_output] = {
			[stat_buffs.melee_damage] = {
				min = 0,
				max = martydom_damage_max
			}
		}
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.health_extension = ScriptUnit.extension(unit, "health_system")
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local health_extension = template_data.health_extension
		local health_percentage = health_extension:current_health_percent()
		local damage_taken_percentage = 1 - health_percentage
		local lerp_t = math.floor(damage_taken_percentage / martydom_health_step) * martydom_health_step

		return lerp_t
	end
}
templates.zealot_maniac_resist_death = {
	class_name = "proc_buff",
	active_duration = talent_settings.passive_2.active_duration,
	cooldown_duration = talent_settings.passive_2.cooldown_duration,
	proc_events = {
		[proc_events.on_damage_taken] = talent_settings.passive_2.on_damage_taken_proc_chance
	},
	off_cooldown_keywords = {
		BuffSettings.keywords.resist_death
	},
	check_proc_func = CheckProcFunctionTemplates.would_die,
	progressbar_func = function (template_data, template_context)
		local percentage = template_context.active_percentage

		if percentage and percentage > 0 then
			return 1 - percentage
		end

		return nil
	end,
	proc_effects = {
		player_effects = {
			on_screen_effect = "content/fx/particles/screenspace/screen_zealot_invincibility",
			looping_wwise_start_event = "wwise/events/player/play_ability_zealot_maniac_resist_death_on",
			looping_wwise_stop_event = "wwise/events/player/play_ability_zealot_maniac_resist_death_off",
			wwise_state = {
				group = "player_ability",
				on_state = "zealot_maniac_resist_death",
				off_state = "none"
			}
		}
	}
}
templates.zealot_maniac_increased_melee_attack_speed = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.melee_attack_speed] = talent_settings.passive_3.melee_attack_speed
	}
}
templates.zealot_maniac_dash_buff = {
	class_name = "proc_buff",
	refresh_duration_on_stack = true,
	max_stacks = talent_settings.combat_ability.max_stacks,
	duration = talent_settings.combat_ability.duration,
	stat_buffs = {
		[stat_buffs.melee_damage] = talent_settings.combat_ability.melee_damage,
		[stat_buffs.melee_critical_strike_chance] = talent_settings.combat_ability.melee_critical_strike_chance
	},
	keywords = {
		keywords.armor_penetrating
	},
	proc_events = {
		[proc_events.on_hit] = talent_settings.combat_ability.on_hit_proc_chance
	},
	check_proc_func = CheckProcFunctionTemplates.on_melee_hit,
	proc_func = function (params, template_data, template_context)
		local is_push = params.damage_efficiency and params.damage_efficiency == "push"

		if is_push then
			return
		end

		template_data.finish = true
	end,
	conditional_exit_func = function (template_data)
		return template_data.finish
	end,
	player_effects = {
		on_screen_effect = "content/fx/particles/screenspace/screen_zealot_dash_charge",
		looping_wwise_start_event = "wwise/events/player/play_ability_zealot_maniac_resist_death_on",
		looping_wwise_stop_event = "wwise/events/player/play_ability_zealot_maniac_resist_death_off",
		wwise_state = {
			group = "player_ability",
			on_state = "zealot_maniac_resist_death",
			off_state = "none"
		}
	}
}
local burning_buff = "fire_burninating_long"
templates.zealot_maniac_melee_crits_set_target_on_fire = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = talent_settings.mixed_2.on_hit_proc_chance
	},
	check_proc_func = CheckProcFunctionTemplates.on_melee_crit_hit,
	proc_func = function (params, template_data, template_context)
		local attacked_unit = params.attacked_unit

		if ALIVE[attacked_unit] then
			local buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")

			if buff_extension then
				local t = Managers.time:time("gameplay")

				buff_extension:add_internally_controlled_buff(burning_buff, t, "owner_unit", template_context.unit)
			end
		end
	end
}
templates.zealot_maniac_recuperate_a_portion_of_damage_taken = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_damage_taken] = talent_settings.mixed_3.on_damage_taken_proc_chance
	},
	start_func = function (template_data, template_context)
		local duration = talent_settings.mixed_3.duration
		template_data.update_frequency = 0.041666
		template_data.ticks = math.floor(duration / template_data.update_frequency + 0.5)
		template_data.last_update_t = 0
		template_data.damage_pool = {}

		for i = 1, 10 do
			local damage_pool_slice = {
				ticks = 0,
				current_damage = 0
			}
			template_data.damage_pool[i] = damage_pool_slice
		end
	end,
	proc_func = function (params, template_data, template_context)
		local damage_amount = params.damage_amount
		local found_empty = false
		local damage_pool = template_data.damage_pool
		local recuperate_percentage = talent_settings.mixed_3.recuperate_percentage
		damage_amount = damage_amount * recuperate_percentage

		for i = 1, 10 do
			local slice = damage_pool[i]

			if slice.ticks == 0 then
				slice.ticks = template_data.ticks
				slice.current_damage = damage_amount
				template_data.last_slice = i
				found_empty = true

				break
			end
		end

		if not found_empty then
			local last_slice = template_data.last_slice
			damage_pool[last_slice].current_damage = damage_pool[last_slice].current_damage + damage_amount
		end

		template_data.active = true
	end,
	update_func = function (template_data, template_context, dt, t, template)
		if not template_data.active then
			return
		end

		if not template_context.is_server then
			return
		end

		local last_update_t = template_data.last_update_t
		local update_frequency = template_data.update_frequency

		if t > last_update_t + update_frequency then
			local damage_pool = template_data.damage_pool
			local unit = template_context.unit
			local active = false
			local total_heal = 0

			for i = 1, 10 do
				local slice = damage_pool[i]
				local ticks = slice.ticks

				if ticks > 0 then
					local heal = slice.current_damage / ticks
					total_heal = total_heal + heal
					slice.current_damage = slice.current_damage - heal
					ticks = ticks - 1
					slice.ticks = ticks

					if ticks ~= 0 then
						active = true
					end
				end
			end

			Health.add(unit, total_heal, DamageSettings.heal_types.heal_over_time_tick)

			template_data.active = active
			template_data.last_update_t = t
		end
	end
}
templates.zelaot_maniac_melee_critical_strike_chance_increased = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.melee_critical_strike_chance] = talent_settings.offensive_1.melee_critical_strike_chance
	}
}
templates.zealot_maniac_stacking_melee_damage = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = talent_settings.offensive_2.on_hit_proc_chance
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.has_extension(unit, "buff_system")
		template_data.buff_extension = buff_extension
	end,
	proc_func = function (params, template_data, template_context)
		local buff_extension = template_data.buff_extension

		if buff_extension then
			local t = Managers.time:time("gameplay")

			buff_extension:add_internally_controlled_buff("zealot_maniac_stacking_melee_damage_buff", t)
		end
	end
}
templates.zealot_maniac_stacking_melee_damage_buff = {
	predicted = false,
	refresh_duration_on_stack = true,
	class_name = "buff",
	max_stacks = talent_settings.offensive_2.max_stacks,
	max_stacks_cap = talent_settings.offensive_2.max_stacks_cap,
	duration = talent_settings.offensive_2.duration,
	stat_buffs = {
		[stat_buffs.melee_damage] = talent_settings.offensive_2.melee_damage
	}
}
templates.zealot_maniac_attack_speed_low_health = {
	predicted = false,
	class_name = "conditional_switch_stat_buff",
	conditional_stat_buffs = {
		{
			[stat_buffs.attack_speed] = talent_settings.offensive_3.attack_speed
		},
		{
			[stat_buffs.attack_speed] = talent_settings.offensive_3.attack_speed_low
		}
	},
	conditional_switch_stat_buffs_func = function (template_data, template_context)
		local unit = template_context.unit
		local health_extension = ScriptUnit.has_extension(unit, "health_system")
		local current_health_percent = health_extension:current_health_percent()
		local first_health_threshold = talent_settings.offensive_3.first_health_threshold
		local second_health_threshold = talent_settings.offensive_3.second_health_threshold

		if current_health_percent <= second_health_threshold then
			return 2
		elseif current_health_percent <= first_health_threshold then
			return 1
		end

		return false
	end
}
templates.zealot_maniac_toughness_gained_from_kills_increased = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.toughness_melee_replenish] = talent_settings.defensive_1.toughness_melee_replenish
	}
}
templates.zealot_maniac_melee_kills_grant_tougness_damage_reduction_stacking = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = talent_settings.defensive_2.on_hit_proc_chance
	},
	check_proc_func = CheckProcFunctionTemplates.on_melee_kill,
	proc_func = function (params, template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

		if buff_extension then
			local t = Managers.time:time("gameplay")

			buff_extension:add_internally_controlled_buff("zealot_maniac_toughness_damage_reduction_stack_buff", t)
		end
	end
}
templates.zealot_maniac_toughness_damage_reduction_stack_buff = {
	predicted = false,
	refresh_duration_on_stack = true,
	class_name = "buff",
	duration = talent_settings.defensive_2.duration,
	max_stacks = talent_settings.defensive_2.max_stacks,
	max_stacks_cap = talent_settings.defensive_2.max_stacks_cap,
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = talent_settings.defensive_2.toughness_damage_taken_multiplier
	}
}
templates.zealot_maniac_movement_enhanced = {
	class_name = "proc_buff",
	active_duration = talent_settings.defensive_3.active_duration,
	proc_events = {
		[proc_events.on_damage_taken] = talent_settings.defensive_3.on_damage_taken_proc_chance
	},
	proc_stat_buffs = {
		[stat_buffs.movement_speed] = talent_settings.defensive_3.movement_speed
	},
	keywords = {
		keywords.slowdown_immune
	}
}
templates.zealot_maniac_toughness_broken_by_melee_restores_toughness_to_allies = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_player_toughness_broken] = talent_settings.coop_1.on_player_toughness_broken_proc_chance
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.coherency_extension = ScriptUnit.has_extension(unit, "coherency_system")
	end,
	proc_func = function (params, template_data, template_context)
		if not params.melee_attack then
			return
		end

		local in_coherence_units = template_data.coherency_extension:in_coherence_units()
		local percentage = talent_settings.coop_1.replenish_percentage

		for unit, _ in pairs(in_coherence_units) do
			Toughness.replenish_percentage(unit, percentage)
		end
	end
}
templates.zealot_maniac_elite_kills_grant_damage_to_allies = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = talent_settings.coop_3.on_hit_proc_chance
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.coherency_extension = ScriptUnit.has_extension(unit, "coherency_system")
	end,
	check_proc_func = CheckProcFunctionTemplates.on_elite_kill,
	proc_func = function (params, template_data, template_context)
		local in_coherence_units = template_data.coherency_extension:in_coherence_units()

		for unit, _ in pairs(in_coherence_units) do
			local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

			if buff_extension then
				local t = Managers.time:time("gameplay")

				buff_extension:add_internally_controlled_buff("zealot_maniac_elite_kills_grant_damage_to_allies_buff", t, "owner_unit", template_context.unit)
			end
		end
	end
}
templates.zealot_maniac_elite_kills_grant_damage_to_allies_buff = {
	predicted = false,
	refresh_duration_on_stack = true,
	class_name = "buff",
	duration = talent_settings.coop_3.duration,
	max_stacks = talent_settings.coop_3.max_stacks,
	stat_buffs = {
		[stat_buffs.damage] = talent_settings.coop_3.damage
	}
}
templates.zealot_maniac_coherency_toughness_damage_resistance = {
	predicted = false,
	coherency_priority = 2,
	coherency_id = "zelot_maniac_coherency_aura",
	class_name = "buff",
	max_stacks = talent_settings.coherency.max_stacks,
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = talent_settings.coherency.toughness_damage_taken_multiplier
	}
}
templates.zealot_maniac_coherency_toughness_damage_resistance_improved = {
	predicted = false,
	coherency_priority = 1,
	coherency_id = "zelot_maniac_coherency_aura",
	class_name = "buff",
	max_stacks = talent_settings.coop_2.max_stacks,
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = talent_settings.coop_2.toughness_damage_taken_multiplier
	}
}
templates.zealot_maniac_resist_death_improved_with_leech = {
	class_name = "proc_buff",
	active_duration = talent_settings.combat_ability_1.active_duration,
	cooldown_duration = talent_settings.combat_ability_1.cooldown_duration,
	proc_events = {
		[proc_events.on_damage_taken] = talent_settings.combat_ability_1.on_damage_taken_proc_chance
	},
	off_cooldown_keywords = {
		keywords.resist_death
	},
	check_proc_func = CheckProcFunctionTemplates.would_die,
	proc_func = function (params, template_data, template_context)
		local buff_name = "zealot_maniac_resist_death_healing"
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")
		local t = Managers.time:time("gameplay")

		buff_extension:add_internally_controlled_buff(buff_name, t)
	end,
	progressbar_func = function (template_data, template_context)
		local percentage = template_context.active_percentage

		if percentage and percentage > 0 then
			return 1 - percentage
		end

		return nil
	end,
	proc_effects = {
		player_effects = {
			on_screen_effect = "content/fx/particles/screenspace/screen_zealot_invincibility",
			looping_wwise_start_event = "wwise/events/player/play_ability_zealot_maniac_resist_death_on",
			looping_wwise_stop_event = "wwise/events/player/play_ability_zealot_maniac_resist_death_off",
			wwise_state = {
				group = "player_ability",
				on_state = "zealot_maniac_resist_death",
				off_state = "none"
			}
		}
	}
}
local leech = talent_settings.combat_ability_1.leech
local melee_multiplier = talent_settings.combat_ability_1.melee_multiplier
templates.zealot_maniac_resist_death_healing = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = talent_settings.combat_ability_1.on_hit_proc_chance
	},
	duration = talent_settings.combat_ability_1.duration,
	start_func = function (template_data, template_context)
		template_data.heal_amount = 0
	end,
	check_proc_func = CheckProcFunctionTemplates.on_kill,
	proc_func = function (params, template_data, template_context)
		local damage_dealt = params.damage
		local health_per_kill = damage_dealt * leech

		if params.attack_type == attack_types.melee then
			template_data.heal_amount = template_data.heal_amount + health_per_kill * melee_multiplier
		else
			template_data.heal_amount = template_data.heal_amount + health_per_kill
		end
	end,
	stop_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local amount_to_add = template_data.heal_amount

		Health.add(unit, amount_to_add, "leech")
	end
}
templates.zealot_maniac_combat_ability_attack_speed_increase = {
	predicted = false,
	class_name = "proc_buff",
	active_duration = talent_settings.combat_ability_2.active_duration,
	proc_events = {
		[proc_events.on_finished_lunge] = talent_settings.combat_ability_2.on_finished_lunge_proc_chance
	},
	proc_stat_buffs = {
		[stat_buffs.attack_speed] = talent_settings.combat_ability_2.attack_speed
	}
}

return templates
