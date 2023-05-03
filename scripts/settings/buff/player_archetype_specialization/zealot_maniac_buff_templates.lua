local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local Health = require("scripts/utilities/health")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local TalentSettings = require("scripts/settings/buff/talent_settings")
local Toughness = require("scripts/utilities/toughness/toughness")
local damage_types = DamageSettings.damage_types
local damage_efficiencies = AttackSettings.damage_efficiencies
local attack_types = AttackSettings.attack_types
local keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local special_rules = SpecialRulesSettings.special_rules
local stat_buffs = BuffSettings.stat_buffs
local talent_settings = TalentSettings.zealot_2
local templates = {}
local Action = require("scripts/utilities/weapon/action")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
templates.zealot_maniac_dash_buff = {
	predicted = false,
	refresh_duration_on_stack = true,
	allow_proc_while_active = true,
	class_name = "proc_buff",
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
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local weapon_action_component = unit_data_extension:read_component("weapon_action")
		local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
		local _, current_action = Action.current_action(weapon_action_component, weapon_template)

		if current_action and current_action.kind == "sweep" then
			local critical_strike_component = unit_data_extension:write_component("critical_strike")
			critical_strike_component.is_active = true
		end
	end,
	check_proc_func = CheckProcFunctions.on_melee_hit,
	proc_func = function (params, template_data, template_context)
		local is_push = params.damage_efficiency and params.damage_efficiency == damage_efficiencies.push
		local is_ranged = params.attack_type == attack_types.ranged

		if is_push or is_ranged then
			return
		end

		template_data.finish = true
	end,
	conditional_exit_func = function (template_data)
		return template_data.finish
	end,
	player_effects = {
		on_screen_effect = "content/fx/particles/screenspace/screen_zealot_dash_charge"
	}
}
local martyrdom_health_step = talent_settings.passive_1.health_step
local martyrdom_default_stacks = talent_settings.passive_1.max_stacks
local martyrdom_talent_stacks = talent_settings.offensive_2_3.max_stacks
local martyrdom_damage_step = talent_settings.passive_1.damage_per_step
local empowered_multiplier = talent_settings.combat_ability_2.martyrdom_empowered_multiplier

local function martyrdom_stack_added(template_data, template_context, t)
	if not template_context.is_server then
		return
	end

	if template_data.martyrdom_grants_ally_power_bonus then
		local in_coherence_units = template_data.coherency_extension:in_coherence_units()
		local buff_name = "zealot_maniac_martyrdom_power_level_bonus"

		for coherency_unit, _ in pairs(in_coherence_units) do
			local buff_extension = ScriptUnit.has_extension(coherency_unit, "buff_system")

			if buff_extension then
				buff_extension:add_internally_controlled_buff(buff_name, t)
			end
		end
	end
end

templates.zealot_maniac_martyrdom_base = {
	hud_always_show_stacks = true,
	hud_icon = "content/ui/textures/icons/talents/zealot_2/hud/zealot_2_base_3",
	predicted = true,
	hud_priority = 2,
	class_name = "zealot_maniac_passive_buff",
	lerped_stat_buffs = {
		[stat_buffs.melee_damage] = {
			min = 0,
			max = martyrdom_talent_stacks * martyrdom_damage_step
		}
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		local specialization_extension = ScriptUnit.extension(unit, "specialization_system")
		local increased_stacks_talent = specialization_extension:has_special_rule(special_rules.martyrdom_increased_stacks)
		template_data.max_stacks = increased_stacks_talent and martyrdom_talent_stacks or martyrdom_default_stacks
		template_data.martyrdom_grants_ally_power_bonus = specialization_extension:has_special_rule(special_rules.zealot_maniac_martyrdom_grants_ally_power_bonus)
		template_data.current_stacks = 0
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		local max_stacks = template_data.max_stacks
		local unit = template_context.unit
		local health_extension = ScriptUnit.has_extension(unit, "health_system")

		if health_extension then
			local health_percentage = health_extension:current_health_percent()
			local damage_taken_percentage = 1 - health_percentage
			local current_stacks = math.floor(damage_taken_percentage / martyrdom_health_step)
			current_stacks = math.clamp(current_stacks, 0, max_stacks)

			if template_data.current_stacks < current_stacks then
				martyrdom_stack_added(template_data, template_context, t)
			end

			if current_stacks ~= template_data.current_stacks and Managers.stats.can_record_stats() then
				local player = template_context.player

				Managers.stats:record_zealot_2_martyrdom_stacks(current_stacks, player)
			end

			template_data.current_stacks = current_stacks
			local lerp_t = current_stacks / martyrdom_talent_stacks

			return lerp_t
		end

		return 0
	end
}
templates.zealot_maniac_resist_death = {
	predicted = false,
	hud_priority = 2,
	always_show_in_hud = true,
	hud_icon = "content/ui/textures/icons/talents/zealot_2/hud/zealot_2_base_2",
	class_name = "proc_buff",
	active_duration = talent_settings.passive_2.active_duration,
	cooldown_duration = talent_settings.passive_2.cooldown_duration,
	proc_events = {
		[proc_events.on_damage_taken] = talent_settings.passive_2.on_damage_taken_proc_chance
	},
	off_cooldown_keywords = {
		BuffSettings.keywords.resist_death
	},
	check_proc_func = CheckProcFunctions.would_die,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		local specialization_extension = ScriptUnit.extension(unit, "specialization_system")
		template_data.ally_toughness_special_rule = specialization_extension:has_special_rule(special_rules.zealot_maniac_toughness_on_resist_death)
	end,
	proc_func = function (params, template_data, template_context)
		if not template_data.ally_toughness_special_rule then
			return
		end

		local in_coherence_units = template_data.coherency_extension:in_coherence_units()
		local percentage = talent_settings.coop_1.replenish_percentage

		for coherency_unit, _ in pairs(in_coherence_units) do
			Toughness.replenish_percentage(coherency_unit, percentage, false, "maniac_coop_1")
		end
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
templates.zealot_maniac_toughness_recovery_from_kills_increased = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.toughness_melee_replenish] = talent_settings.toughness_1.toughness_melee_replenish
	}
}
templates.zealot_maniac_melee_toughness_defense = {
	predicted = false,
	class_name = "buff",
	keywords = {
		keywords.zealot_toughness
	}
}
templates.zealot_maniac_critical_strike_toughness_defense = {
	predicted = false,
	max_stacks = 1,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1
	},
	check_proc_func = CheckProcFunctions.on_crit,
	start_func = function (template_data, template_context)
		template_data.buff_extension = ScriptUnit.extension(template_context.unit, "buff_system")
	end,
	proc_func = function (params, template_data, template_context, t)
		template_data.buff_extension:add_internally_controlled_buff("zealot_maniac_critical_strike_toughness_defense_buff", t)
	end
}
templates.zealot_maniac_critical_strike_toughness_defense_buff = {
	predicted = false,
	refresh_duration_on_stack = true,
	hud_icon = "content/ui/textures/icons/talents/zealot_2/hud/zealot_2_tier_5_3",
	max_stacks = 1,
	hud_priority = 4,
	class_name = "buff",
	duration = talent_settings.toughness_2.duration,
	stat_buffs = {
		[stat_buffs.toughness_damage_taken_multiplier] = talent_settings.toughness_2.toughness_damage_taken_multiplier
	}
}
local range = talent_settings.toughness_3.range
templates.zealot_maniac_toughness_regen_in_melee = {
	hud_icon = "content/ui/textures/icons/talents/zealot_2/hud/zealot_2_tier_4_1",
	predicted = false,
	hud_priority = 4,
	class_name = "buff",
	always_show_in_hud = true,
	start_func = function (template_data, template_context)
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase
		template_data.broadphase = broadphase
		template_data.broadphase_results = {}
		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local character_state_component = unit_data_extension:read_component("character_state")
		template_data.enemy_side_names = enemy_side_names
		template_data.current_tick = 0
		template_data.character_state_component = character_state_component
	end,
	update_func = function (template_data, template_context, dt, t, template)
		local next_regen_t = template_data.next_regen_t

		if not next_regen_t then
			template_data.next_regen_t = t + talent_settings.toughness_3.time

			return
		end

		if next_regen_t < t then
			local is_disabled = PlayerUnitStatus.is_disabled(template_data.character_state_component)

			if is_disabled then
				template_data.current_tick = 0
				template_data.is_active = false
			end

			local player_unit = template_context.unit
			local player_position = POSITION_LOOKUP[player_unit]
			local broadphase = template_data.broadphase
			local enemy_side_names = template_data.enemy_side_names
			local broadphase_results = template_data.broadphase_results

			table.clear(broadphase_results)

			local num_hits = broadphase:query(player_position, range, broadphase_results, enemy_side_names)

			if talent_settings.toughness_3.num_enemies <= num_hits then
				template_data.current_tick = template_data.current_tick + 1

				if talent_settings.toughness_3.num_ticks_to_trigger <= template_data.current_tick then
					if template_context.is_server then
						Toughness.replenish_percentage(template_context.unit, talent_settings.toughness_3.toughness, false, "talent_toughness_3")
					end

					template_data.current_tick = 0
				end

				template_data.next_regen_t = t + talent_settings.toughness_3.time
				template_data.is_active = true
			else
				template_data.current_tick = 0
				template_data.is_active = false
			end
		end
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.is_active
	end
}
templates.zelaot_maniac_melee_critical_strike_chance_increased = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.melee_critical_strike_chance] = talent_settings.offensive_1.melee_critical_strike_chance
	}
}
templates.zealot_maniac_increased_damage_vs_shocked = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.damage_vs_electrocuted] = talent_settings.offensive_2.damage
	}
}
templates.zealot_maniac_bleeding_crits = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1
	},
	check_proc_func = CheckProcFunctions.on_melee_hit,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")
		template_data.buff_extension = buff_extension
	end,
	proc_func = function (params, template_data, template_context)
		local victim_unit = params.attacked_unit
		local victim_buff_extension = ScriptUnit.has_extension(victim_unit, "buff_system")
		local target_is_bleeding = victim_buff_extension and (victim_buff_extension:has_keyword(keywords.bleeding) or victim_buff_extension:had_keyword(keywords.bleeding))

		if target_is_bleeding then
			local t = FixedFrame.get_latest_fixed_time()

			template_data.buff_extension:add_internally_controlled_buff("zealot_maniac_critical_strike_chance_buff", t)
		end

		local damage = params.damage or 0
		local is_damaging_crit = params.is_critical_strike and damage > 0

		if is_damaging_crit and HEALTH_ALIVE[victim_unit] and victim_buff_extension then
			local bleeding_dot_buff_name = "bleed"
			local t = FixedFrame.get_latest_fixed_time()
			local unit = template_context.unit
			local num_stacks = talent_settings.offensive_1.stacks

			for i = 1, num_stacks do
				victim_buff_extension:add_internally_controlled_buff(bleeding_dot_buff_name, t, "owner_unit", unit)
			end
		end
	end
}
templates.zealot_maniac_critical_strike_chance_buff = {
	refresh_duration_on_stack = true,
	max_stacks = 3,
	hud_icon = "content/ui/textures/icons/talents/zealot_2/hud/zealot_2_tier_2_1",
	predicted = false,
	hud_priority = 4,
	class_name = "buff",
	duration = talent_settings.offensive_1.duration,
	stat_buffs = {
		[stat_buffs.melee_critical_strike_chance] = talent_settings.offensive_1.melee_critical_strike_chance
	}
}
local min_hits = talent_settings.offensive_2.min_hits
templates.zealot_maniac_multi_hits_increase_impact = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_sweep_finish] = 1
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")
		template_data.buff_extension = buff_extension
	end,
	proc_func = function (params, template_data, template_context)
		if params.num_hit_units < min_hits then
			return
		end

		local t = FixedFrame.get_latest_fixed_time()

		template_data.buff_extension:add_internally_controlled_buff("zealot_maniac_multi_hits_impact_buff", t)
	end
}
local impact_buff_max_stacks = talent_settings.offensive_2.max_stacks
templates.zealot_maniac_multi_hits_impact_buff = {
	class_name = "buff",
	refresh_duration_on_stack = true,
	predicted = false,
	hud_priority = 4,
	hud_icon = "content/ui/textures/icons/talents/zealot_2/hud/zealot_2_tier_2_2_b",
	always_active = true,
	duration = talent_settings.offensive_2.duration,
	max_stacks = impact_buff_max_stacks,
	stat_buffs = {
		[stat_buffs.impact_modifier] = talent_settings.offensive_2.impact_modifier
	},
	conditional_keywords = {
		keywords.uninterruptible,
		keywords.stun_immune
	},
	conditional_keywords_func = function (template_data, template_context)
		return impact_buff_max_stacks <= template_context.stack_count
	end,
	check_active_func = function (template_data, template_context)
		return true
	end
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
templates.zealot_maniac_coherency_crit_aura = {
	predicted = false,
	coherency_priority = 1,
	coherency_id = "zelot_maniac_coherency_crit_aura",
	max_stacks = 1,
	class_name = "buff",
	lerped_stat_buffs = {
		[stat_buffs.critical_strike_chance] = {
			min = 0,
			max = talent_settings.coop_1.crit_chance * martyrdom_talent_stacks
		}
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.source_unit = unit
		local side_system = Managers.state.extension:system("side_system")
		template_data.side = side_system.side_by_unit[unit]
		template_data.max_stacks = martyrdom_default_stacks
		local player_units = template_data.side.valid_player_units

		for i = 1, #player_units do
			local player_unit = player_units[i]
			local specialization_extension = ScriptUnit.has_extension(player_unit, "specialization_system")
			local has_special_rule = specialization_extension and specialization_extension:has_special_rule(special_rules.zealot_maniac_crit_aura)

			if has_special_rule then
				local increased_stacks_talent = specialization_extension:has_special_rule(special_rules.martyrdom_increased_stacks)

				if increased_stacks_talent then
					template_data.source_unit = player_unit
					template_data.max_stacks = martyrdom_talent_stacks

					if player_unit == unit then
						break
					end
				end
			end
		end
	end,
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		if not template_context.is_server then
			return 0
		end

		local max_stacks = template_data.max_stacks
		local unit = template_data.source_unit
		local health_extension = ScriptUnit.has_extension(unit, "health_system")

		if health_extension then
			local health_percentage = health_extension:current_health_percent()
			local damage_taken_percentage = 1 - health_percentage
			local current_stacks = math.floor(damage_taken_percentage / martyrdom_health_step)
			current_stacks = math.clamp(current_stacks, 0, max_stacks)
			local lerp_t = current_stacks / martyrdom_talent_stacks

			return lerp_t
		end

		return 0
	end
}
templates.zealot_maniac_martyrdom_power_level_bonus = {
	refresh_duration_on_stack = true,
	hud_icon = "content/ui/textures/icons/talents/zealot_2/hud/zealot_2_tier_1_2",
	max_stacks = 1,
	predicted = false,
	hud_priority = 4,
	class_name = "buff",
	duration = talent_settings.coop_1.duration,
	stat_buffs = {
		[stat_buffs.power_level_modifier] = talent_settings.coop_1.power_level_modifier
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
templates.zealot_maniac_dash_grants_toughness = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_combat_ability] = 1
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.coherency_extension = coherency_extension
	end,
	proc_func = function (params, template_data, template_context)
		local in_coherence_units = template_data.coherency_extension:in_coherence_units()
		local percentage = talent_settings.coop_3.toughness

		for coherency_unit, _ in pairs(in_coherence_units) do
			if coherency_unit ~= template_context.unit then
				Toughness.replenish_percentage(coherency_unit, percentage, false, "manaic_coop_3")
			end
		end
	end
}
templates.zealot_maniac_resist_death_improved_with_leech = {
	predicted = false,
	hud_priority = 2,
	always_show_in_hud = true,
	hud_icon = "content/ui/textures/icons/talents/zealot_2/hud/zealot_2_base_2",
	class_name = "proc_buff",
	active_duration = talent_settings.defensive_1.active_duration,
	cooldown_duration = talent_settings.defensive_1.cooldown_duration,
	proc_events = {
		[proc_events.on_damage_taken] = talent_settings.defensive_1.on_damage_taken_proc_chance
	},
	off_cooldown_keywords = {
		keywords.resist_death
	},
	check_proc_func = CheckProcFunctions.would_die,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		local specialization_extension = ScriptUnit.extension(unit, "specialization_system")
		template_data.ally_toughness_special_rule = specialization_extension:has_special_rule(special_rules.zealot_maniac_toughness_on_resist_death)
	end,
	proc_func = function (params, template_data, template_context)
		local buff_name = "zealot_maniac_resist_death_healing"
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")
		local t = FixedFrame.get_latest_fixed_time()

		buff_extension:add_internally_controlled_buff(buff_name, t)

		if template_data.ally_toughness_special_rule then
			local in_coherence_units = template_data.coherency_extension:in_coherence_units()
			local percentage = talent_settings.coop_1.replenish_percentage

			for coherency_unit, _ in pairs(in_coherence_units) do
				Toughness.replenish_percentage(coherency_unit, percentage, false, "maniac_coop_1")
			end
		end
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
local leech = talent_settings.defensive_1.leech
local melee_multiplier = talent_settings.defensive_1.melee_multiplier
templates.zealot_maniac_resist_death_healing = {
	predicted = false,
	class_name = "proc_buff",
	allow_proc_while_active = true,
	proc_events = {
		[proc_events.on_damage_dealt] = talent_settings.defensive_1.on_hit_proc_chance
	},
	duration = talent_settings.defensive_1.duration,
	start_func = function (template_data, template_context)
		template_data.heal_amount = 0
	end,
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

		if DEDICATED_SERVER then
			local health_extension = ScriptUnit.has_extension(unit, "health_system")

			if health_extension then
				local max_health = health_extension:max_health()
				local heal_percentage = amount_to_add / max_health
				local player_unit_spawn_manager = Managers.state.player_unit_spawn
				local player = player_unit_spawn_manager:owner(unit)

				Managers.stats:record_zealot_2_health_healed_with_leech_during_resist_death(player, heal_percentage)
			end
		end
	end
}
templates.zealot_maniac_movement_enhanced = {
	predicted = true,
	hud_priority = 4,
	allow_proc_while_active = true,
	hud_icon = "content/ui/textures/icons/talents/zealot_2/hud/zealot_2_tier_3_3",
	class_name = "proc_buff",
	active_duration = talent_settings.defensive_2.active_duration,
	proc_events = {
		[proc_events.on_damage_taken] = talent_settings.defensive_2.on_damage_taken_proc_chance
	},
	check_proc_func = function (params, template_data, template_context)
		local attacked_unit = params.attacked_unit
		local unit = template_context.unit

		return attacked_unit == unit
	end,
	proc_stat_buffs = {
		[stat_buffs.movement_speed] = talent_settings.defensive_2.movement_speed
	},
	keywords = {
		keywords.slowdown_immune,
		keywords.stun_immune
	}
}
local num_slices = 10
templates.zealot_maniac_recuperate_a_portion_of_damage_taken = {
	predicted = false,
	allow_proc_while_active = true,
	hud_icon = "content/ui/textures/icons/talents/zealot_2/hud/zealot_2_tier_4_3_b",
	class_name = "proc_buff",
	active_duration = talent_settings.defensive_3.duration,
	proc_events = {
		[proc_events.on_damage_taken] = talent_settings.defensive_3.on_damage_taken_proc_chance
	},
	start_func = function (template_data, template_context)
		local duration = talent_settings.defensive_3.duration
		template_data.update_frequency = 0.041666
		template_data.ticks = math.floor(duration / template_data.update_frequency + 0.5)
		template_data.last_update_t = 0
		template_data.damage_pool = {}

		for i = 1, num_slices do
			local damage_pool_slice = {
				ticks = 0,
				current_damage = 0
			}
			template_data.damage_pool[i] = damage_pool_slice
		end
	end,
	proc_func = function (params, template_data, template_context)
		local victim_unit = params.attacked_unit

		if victim_unit ~= template_context.unit then
			return
		end

		local damage_amount = params.damage_amount
		local found_empty = false
		local damage_pool = template_data.damage_pool
		local recuperate_percentage = talent_settings.defensive_3.recuperate_percentage
		damage_amount = damage_amount * recuperate_percentage

		for i = 1, num_slices do
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

			for i = 1, num_slices do
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
templates.zealot_maniac_close_ranged_damage = {
	predicted = false,
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.damage_near] = talent_settings.offensive_2_1.damage
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local inventory_component = unit_data_extension:read_component("inventory")
		template_data.inventory_component = inventory_component
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		local wielded_slot = template_data.inventory_component.wielded_slot

		if wielded_slot == "slot_secondary" then
			return true
		end

		return false
	end
}
templates.zealot_maniac_stacking_melee_damage = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = talent_settings.offensive_2_2.on_hit_proc_chance
	},
	check_proc_func = CheckProcFunctions.on_melee_hit,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.has_extension(unit, "buff_system")
		template_data.buff_extension = buff_extension
	end,
	proc_func = function (params, template_data, template_context)
		local buff_extension = template_data.buff_extension

		if buff_extension then
			local t = FixedFrame.get_latest_fixed_time()

			buff_extension:add_internally_controlled_buff("zealot_maniac_stacking_melee_damage_buff", t)
		end
	end
}
templates.zealot_maniac_stacking_melee_damage_buff = {
	predicted = false,
	hud_icon = "content/ui/textures/icons/talents/zealot_2/hud/zealot_2_tier_5_1",
	refresh_duration_on_stack = true,
	hud_priority = 4,
	class_name = "buff",
	max_stacks = talent_settings.offensive_2_2.max_stacks,
	duration = talent_settings.offensive_2_2.duration,
	stat_buffs = {
		[stat_buffs.melee_damage] = talent_settings.offensive_2_2.melee_damage
	}
}
templates.zealot_maniac_combat_ability_crits_reduce_cooldown = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1
	},
	check_proc_func = CheckProcFunctions.on_melee_crit_hit,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local ability_extension = ScriptUnit.has_extension(unit, "ability_system")
		template_data.ability_extension = ability_extension
	end,
	proc_func = function (params, template_data, template_context)
		if not template_data.ability_extension then
			local unit = template_context.unit
			local ability_extension = ScriptUnit.has_extension(unit, "ability_system")

			if not ability_extension then
				return
			end

			template_data.ability_extension = ability_extension
		end

		local ability_extension = template_data.ability_extension
		local ability_type = "combat_ability"

		if not ability_extension or not ability_extension:has_ability_type(ability_type) then
			return
		end

		ability_extension:reduce_ability_cooldown_time(ability_type, talent_settings.combat_ability_1.time)
	end
}
templates.zealot_maniac_combat_ability_attack_speed_increase = {
	predicted = false,
	hud_priority = 3,
	allow_proc_while_active = true,
	hud_icon = "content/ui/textures/icons/talents/zealot_2/hud/zealot_2_tier_6_2",
	class_name = "proc_buff",
	active_duration = talent_settings.combat_ability_2.active_duration + 1,
	proc_keywords = {
		keywords.zealot_maniac_empowered_martyrdom
	},
	proc_events = {
		[proc_events.on_lunge_start] = talent_settings.combat_ability_2.on_lunge_end_proc_chance
	},
	proc_stat_buffs = {
		[stat_buffs.attack_speed] = talent_settings.combat_ability_2.attack_speed
	}
}

return templates
