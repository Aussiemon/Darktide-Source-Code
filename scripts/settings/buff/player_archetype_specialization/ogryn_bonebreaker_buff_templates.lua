local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctionTemplates = require("scripts/settings/buff/check_proc_function_templates")
local ConditionalFunctionTemplates = require("scripts/settings/buff/conditional_function_templates")
local TalentSettings = require("scripts/settings/buff/talent_settings")
local Toughness = require("scripts/utilities/toughness/toughness")
local buff_keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local stat_buffs = BuffSettings.stat_buffs
local talent_settings = TalentSettings.ogryn_2
local templates = {
	ogryn_bonebreaker_speed_on_lunge = {
		predicted = true,
		class_name = "proc_buff",
		active_duration = talent_settings.combat_ability.active_duration,
		proc_events = {
			[proc_events.on_finished_lunge] = talent_settings.combat_ability.on_finished_lunge_proc_chance
		},
		proc_stat_buffs = {
			[stat_buffs.movement_speed] = talent_settings.combat_ability.movement_speed,
			[stat_buffs.melee_attack_speed] = talent_settings.combat_ability.melee_attack_speed
		}
	},
	ogryn_bonebreaker_passive = {
		predicted = false,
		class_name = "buff",
		stat_buffs = {
			[stat_buffs.toughness_melee_replenish] = talent_settings.passive_1.toughness_melee_replenish,
			[stat_buffs.melee_heavy_damage] = talent_settings.passive_1.melee_heavy_damage
		}
	},
	ogryn_base_lunge_toughness_and_damage_resistance = {
		predicted = false,
		class_name = "buff",
		conditional_stat_buffs = {
			[stat_buffs.melee_heavy_damage] = talent_settings.passive_2.melee_heavy_damage,
			[stat_buffs.damage_taken_multiplier] = talent_settings.passive_2.damage_taken_multiplier
		},
		conditional_stat_buffs_func = ConditionalFunctionTemplates.is_lunging
	}
}
local num_enemies = talent_settings.mixed_1.num_enemies
templates.ogryn_bonebreaker_hitting_multiple_with_melee_grants_melee_damage_bonus = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_sweep] = talent_settings.mixed_1.on_sweep_proc_chance,
		[proc_events.on_hit] = talent_settings.mixed_1.on_hit_proc_chance
	},
	conditional_stat_buffs = {
		[stat_buffs.melee_damage] = talent_settings.mixed_1.melee_damage
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.is_active
	end,
	check_proc_func = function (params, template_data, template_contex)
		if params.num_hit_units and num_enemies <= params.num_hit_units then
			template_data.is_active = true

			return true
		elseif params.attacked_unit and template_data.is_active then
			template_data.is_active = nil

			return true
		end
	end,
	proc_func = function (params, template_data, template_contex)
		return
	end
}
local increased_toughnes_health_threshold = talent_settings.mixed_2.increased_toughnes_health_threshold
templates.ogryn_bonebreaker_increased_toughness_at_low_health = {
	class_name = "buff",
	conditional_stat_buffs = {
		[stat_buffs.toughness_replenish_multiplier] = talent_settings.mixed_2.toughness_replenish_multiplier
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		local unit = template_context.unit
		local health_extension = ScriptUnit.has_extension(unit, "health_system")

		if health_extension then
			local current_health_percent = health_extension:current_health_percent()

			return current_health_percent < increased_toughnes_health_threshold
		end
	end
}
templates.ogryn_bonebreaker_charge_grants_allied_movement_speed = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_start_lunge] = talent_settings.mixed_3.on_start_lunge_proc_chance
	},
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local coherency_extension = ScriptUnit.has_extension(unit, "coherency_system")

		if coherency_extension then
			local units_in_coherence = coherency_extension:in_coherence_units()
			local movement_speed_buff = "ogryn_bonebreaker_allied_movement_speed_buff"
			local t = Managers.time:time("gameplay")

			for coherency_unit, _ in pairs(units_in_coherence) do
				local is_local_unit = coherency_unit == unit

				if not is_local_unit then
					local coherency_buff_extension = ScriptUnit.extension(coherency_unit, "buff_system")

					coherency_buff_extension:add_internally_controlled_buff(movement_speed_buff, t, "owner_unit", unit)
				end
			end
		end
	end
}
templates.ogryn_bonebreaker_allied_movement_speed_buff = {
	refresh_duration_on_stack = true,
	class_name = "buff",
	duration = talent_settings.mixed_3.duration,
	max_stacks = talent_settings.mixed_3.max_stacks,
	stat_buffs = {
		[stat_buffs.movement_speed] = talent_settings.mixed_3.movement_speed
	}
}
templates.ogryn_bonebreaker_better_ogryn_fighting = {
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.damage_vs_ogryn] = talent_settings.offensive_1.damage_vs_ogryn,
		[stat_buffs.ogryn_damage_taken_multiplier] = talent_settings.offensive_1.ogryn_damage_taken_multiplier
	}
}
templates.ogryn_bonebreaker_armored_damage = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.armored_damage] = talent_settings.offensive_2.armored_damage,
		[stat_buffs.super_armor_damage] = talent_settings.offensive_2.super_armor_damage
	}
}
templates.ogryn_bonebreaker_elite_kills_grant_cooldown_reduction = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = talent_settings.offensive_3.on_hit_proc_chance
	},
	check_proc_func = CheckProcFunctionTemplates.on_elite_kill,
	proc_func = function (params, template_data, template_context)
		local unit = template_context.unit
		local ability_extension = ScriptUnit.has_extension(unit, "ability_system")

		if ability_extension then
			local cooldown_percent = talent_settings.offensive_3.cooldown_percent

			ability_extension:reduce_ability_cooldown_percentage("combat_ability", cooldown_percent)
		end
	end
}
templates.ogryn_bonebreaker_block_regen_on_damage_taken = {
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_damage_taken] = talent_settings.defensive_1.on_damage_taken_proc_chance
	},
	proc_func = function (params, template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

		if buff_extension then
			local t = Managers.time:time("gameplay")

			buff_extension:add_internally_controlled_buff("ogryn_bonebreaker_block_regen_buff", t)
		end
	end
}
templates.ogryn_bonebreaker_block_regen_buff = {
	class_name = "buff",
	refresh_duration_on_stack = true,
	predicted = false,
	stat_buffs = {
		[stat_buffs.stamina_regeneration_modifier] = talent_settings.defensive_1.stamina_regeneration_modifier
	},
	duration = talent_settings.defensive_1.duration,
	max_stacks = talent_settings.defensive_1.max_stacks,
	max_stacks_cap = talent_settings.defensive_1.max_stacks_cap
}
templates.ogryn_bonebreaker_reduce_sprint_staminica_cost = {
	predicted = true,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.sprinting_cost_multiplier] = talent_settings.defensive_2.sprinting_cost_multiplier
	}
}
templates.ogryn_bonebreaker_heavy_hits_damage_reduction = {
	predicted = false,
	class_name = "proc_buff",
	active_duration = talent_settings.defensive_3.active_duration,
	proc_stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = talent_settings.defensive_3.damage_taken_multiplier
	},
	proc_events = {
		[proc_events.on_hit] = talent_settings.defensive_3.on_hit_proc_chance
	},
	check_proc_func = CheckProcFunctionTemplates.on_heavy_hit
}
templates.ogryn_bonebreaker_coherency_increased_melee_damage = {
	predicted = false,
	coherency_priority = 2,
	coherency_id = "ogryn_bonebreaker_coherency_aura",
	class_name = "buff",
	max_stacks = talent_settings.coherency.max_stacks,
	keywords = {},
	stat_buffs = {
		[stat_buffs.melee_damage] = talent_settings.coherency.melee_damage
	}
}
templates.ogryn_bonebreaker_coherency_increased_melee_damage_improved = {
	predicted = false,
	coherency_priority = 1,
	coherency_id = "ogryn_bonebreaker_coherency_aura",
	class_name = "buff",
	max_stacks = talent_settings.coop_2.max_stacks,
	keywords = {},
	stat_buffs = {
		[stat_buffs.melee_damage] = talent_settings.coop_2.melee_damage
	}
}
templates.ogryn_bonebreaker_melee_kills_restore_ally_toughness = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = talent_settings.coop_1.on_hit_proc_chance
	},
	check_proc_func = CheckProcFunctionTemplates.on_melee_kill,
	proc_func = function (params, template_data, template_context)
		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local player_units = side.valid_player_units

		for i = 1, #player_units do
			local player_unit = player_units[i]

			if player_unit ~= unit and HEALTH_ALIVE[player_unit] then
				Toughness.replenish(template_context.unit, "bonebreaker_heavy_hit")
			end
		end
	end
}
templates.ogryn_bonebreaker_fully_charged_attacks_infinite_cleave = {
	predicted = false,
	class_name = "buff",
	keywords = {
		buff_keywords.fully_charged_attacks_infinite_cleave
	}
}
templates.ogryn_bonebreaker_heavy_hits_toughness = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = talent_settings.spec_passive_2.on_hit_proc_chance
	},
	check_proc_func = CheckProcFunctionTemplates.on_heavy_hit,
	proc_func = function (params, template_data, template_context)
		Toughness.replenish(template_context.unit, "bonebreaker_heavy_hit")
	end
}
templates.ogryn_bonebreaker_fully_charged_damage = {
	predicted = false,
	class_name = "buff",
	stat_buffs = {
		[stat_buffs.melee_fully_charged_damage] = talent_settings.spec_passive_3.melee_fully_charged_damage
	}
}

return templates
